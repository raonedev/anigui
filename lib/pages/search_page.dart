import 'dart:convert';
import 'dart:developer';

import 'package:anigui/pages/anime_detail.dart';
import 'package:anigui/services/http_api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  final Dio _dio = Dio();
  bool _isLoading = false;
  List<dynamic> _results = [];

  Future<void> _searchAnime(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _results = [];
    });

    final url = "https://api.allanime.day/api";
    final variables = {
      "search": {"allowAdult": false, "allowUnknown": false, "query": query},
      "limit": 10,
      "page": 1,
      "translationType": "sub",
      "countryOrigin": "ALL",
    };

    final gqlQuery = '''
      query(\$search: SearchInput, \$limit: Int, \$page: Int, \$translationType: VaildTranslationTypeEnumType, \$countryOrigin: VaildCountryOriginEnumType) {
        shows(search: \$search, limit: \$limit, page: \$page, translationType: \$translationType, countryOrigin: \$countryOrigin) {
          edges {
            _id
            name
            description
            banner
            thumbnails
          }
        }
      }
    ''';

    try {
      final response = await _dio.get(
        url,
        queryParameters: {
          "variables": jsonEncode(variables),
          "query": gqlQuery,
        },
        options: Options(headers: {"Referer": "https://allmanga.to"}),
      );

      final data = response.data["data"]["shows"]["edges"] as List;
      setState(() {
        _results = data;
      });
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String? getValidThumbnail(List thumbnails) {
    if (thumbnails.isEmpty) return null;
    final thumb = thumbnails[0];
    if (thumb.toString().startsWith("http")) {
      return thumb;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CupertinoSearchTextField(
          controller: _controller,
          onSubmitted: _searchAnime,
          placeholder: "Search anime...",
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _results.isEmpty
          ?  Center(child: ElevatedButton(onPressed: () async{
                ApiService apiService = ApiService();
                final val = await apiService.fetchAnimeDetail(id: "bNxsZLcHxRPbs4eTf");
                log(val.toString());
              }, child: Text("click me")))
          : ListView.builder(
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final anime = _results[index];
                final name = anime["name"] ?? "Unknown";
                final description = (anime["description"] ?? "")
                    .toString()
                    .replaceAll("<br>", "\n");
                final thumbnail = getValidThumbnail(anime["thumbnails"]);

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AnimeDetailScreen(
                            animeId: anime["_id"],
                            name: name,
                            description: description,
                            thumbnail: thumbnail,
                          ),
                        ),
                      );
                    },
                    leading: thumbnail != null
                        ? Image.network(
                            thumbnail,
                            width: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported);
                            },
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(name),
                    subtitle: Text(
                      description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
