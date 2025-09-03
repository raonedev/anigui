import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AnimeDetailScreen extends StatefulWidget {
  final String animeId;
  final String name;
  final String description;
  final String? thumbnail;

  const AnimeDetailScreen({
    super.key,
    required this.animeId,
    required this.name,
    required this.description,
    this.thumbnail,
  });

  @override
  State<AnimeDetailScreen> createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends State<AnimeDetailScreen> {
  final Dio _dio = Dio();
  bool _loading = true;
  Map<String, dynamic> _episodes = {};
  String? _apiResponse;
  List<Map<String, String>> finalVideoLinks = [];

  @override
  void initState() {
    super.initState();
    _fetchEpisodes();
  }

  Future<void> _fetchEpisodes() async {
    final url = "https://api.allanime.day/api";
    final variables = {"showId": widget.animeId};
    final gqlQuery = '''
      query (\$showId: String!) {
        show(_id: \$showId) {
          _id
          availableEpisodesDetail
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

      final data = response.data["data"]["show"]["availableEpisodesDetail"];
      setState(() {
        _episodes = Map<String, dynamic>.from(data);
      });
    } catch (e) {
      log("Error fetching episodes: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _fetchEpisodeSources(String episode) async {
    final url = "https://api.allanime.day/api";
    final variables = {
      "showId": widget.animeId,
      "translationType": "sub",
      "episodeString": episode,
    };
    final gqlQuery = '''
      query (\$showId: String!, \$translationType: VaildTranslationTypeEnumType!, \$episodeString: String!) {
        episode(showId: \$showId, translationType: \$translationType, episodeString: \$episodeString) {
          episodeString
          sourceUrls
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

      final List<dynamic> sourceUrls =
          response.data["data"]["episode"]["sourceUrls"];
      // Use a List<String> to store the final, decoded URLs
      finalVideoLinks.clear();

      for (var map in sourceUrls) {
        final sourceName = map['sourceName'].toString();
        final sourceUrl = map['sourceUrl'].toString().replaceFirst('--', '');
        final String decodedUrl =
            (sourceName == "Default" ||
                sourceName == "Yt-mp4" ||
                sourceName == "S-mp4" ||
                sourceName == "Luf-Mp4")
            ? providerInit(sourceUrl, sourceName)
            : '';

        if (decodedUrl.isNotEmpty) {
          // If it's a clock.json link, fetch its content
          if (decodedUrl.contains('/clock.json')) {
            await _fetchClockJsonLinks(decodedUrl);
          } else {
            // It's a direct, usable link
            // log('Source: $sourceName -> Direct URL: $decodedUrl');
            finalVideoLinks.add({'resolution': sourceName, 'url': decodedUrl});
          }
        }
      }

      log('--- All Processed Video Links ---');
      for (var link in finalVideoLinks) {
        log('${link['resolution']} -> ${link['url']}');
      }
    } catch (e) {
      log("Error fetching episode sources: $e");
    }
  }

  String providerInit(String encodedUrl, String providerName) {
    // Mapping table remains the same
    final Map<String, String> mapping = {
      "79": "A",
      "7a": "B",
      "7b": "C",
      "7c": "D",
      "7d": "E",
      "7e": "F",
      "7f": "G",
      "70": "H",
      "71": "I",
      "72": "J",
      "73": "K",
      "74": "L",
      "75": "M",
      "76": "N",
      "77": "O",
      "68": "P",
      "69": "Q",
      "6a": "R",
      "6b": "S",
      "6c": "T",
      "6d": "U",
      "6e": "V",
      "6f": "W",
      "60": "X",
      "61": "Y",
      "62": "Z",
      "59": "a",
      "5a": "b",
      "5b": "c",
      "5c": "d",
      "5d": "e",
      "5e": "f",
      "5f": "g",
      "50": "h",
      "51": "i",
      "52": "j",
      "53": "k",
      "54": "l",
      "55": "m",
      "56": "n",
      "57": "o",
      "48": "p",
      "49": "q",
      "4a": "r",
      "4b": "s",
      "4c": "t",
      "4d": "u",
      "4e": "v",
      "4f": "w",
      "40": "x",
      "41": "y",
      "42": "z",
      "08": "0",
      "09": "1",
      "0a": "2",
      "0b": "3",
      "0c": "4",
      "0d": "5",
      "0e": "6",
      "0f": "7",
      "00": "8",
      "01": "9",
      "15": "-",
      "16": ".",
      "67": "_",
      "46": "~",
      "02": ":",
      "17": "/",
      "07": "?",
      "1b": "#",
      "63": "[",
      "65": "]",
      "78": "@",
      "19": "!",
      "1c": "\$",
      "1e": "&",
      "10": "(",
      "11": ")",
      "12": "*",
      "13": "+",
      "14": ",",
      "03": ";",
      "05": "=",
      "1d": "%",
    };

    // 1. REMOVED: No need to find a match. The input string is the encoded data.
    // final regex = RegExp("^$providerName\\s*:(.*)\$", multiLine: true);
    // final match = regex.firstMatch(resp);
    // if (match == null) return "";
    // final encoded = match.group(1)!.trim();

    // The 'encodedUrl' is already the string we need to decode.
    final encoded = encodedUrl.trim();

    // 2. CHECK: Only process if the source URL is not a standard URL.
    if (!encoded.startsWith("http")) {
      // Split into 2-char pairs
      final pairs = <String>[];
      for (var i = 0; i < encoded.length; i += 2) {
        pairs.add(encoded.substring(i, i + 2));
      }
      // Decode using mapping
      final decoded = pairs.map((p) => mapping[p] ?? "").join();
      // Replace /clock → /clock.json
      return decoded.replaceAll("/clock", "/clock.json");
    }

    // 3. RETURN ORIGINAL: If it's a normal URL, just return it.
    return encodedUrl;
  }

  Future<void> _fetchClockJsonLinks(String clockUrl) async {
    try {
      // Construct the full URL
      final fullUrl = "https://allanime.day$clockUrl";

      // log('Fetching links from: $fullUrl');
      final response = await _dio.get(
        fullUrl,
        options: Options(headers: {"Referer": "https://allmanga.to"}),
      );

      final List<dynamic> links = response.data['links'];

      for (var linkData in links) {
        final String link = linkData['link'];
        // Parse the link using the logic from your bash script
        final parsedLinks = await _parseVideoLinks(link);
        finalVideoLinks.addAll(parsedLinks);
      }
    } catch (e) {
      log("Error fetching clock.json links: $e");
    }
  }

  /// Parses different types of video URLs based on the bash script logic.
  Future<List<Map<String, String>>> _parseVideoLinks(String link) async {
    final List<Map<String, String>> parsedLinks = [];

    // Case 1: Handle links from 'repackager.wixmp.com'
    if (link.contains('repackager.wixmp.com')) {
      log('Parsing wixmp link...');
      try {
        // Extracts: video.wixstatic.com/video/.../mp4/file.mp4
        final extractLink = link
            .replaceAll('repackager.wixmp.com/', '')
            .replaceAll(RegExp(r'\.urlset.*'), '');

        // Extracts: 1080p,720p,480p
        final resolutionsMatch = RegExp(r'\/,(.*?),\/\w+\/').firstMatch(link);
        if (resolutionsMatch != null) {
          final resolutions = resolutionsMatch.group(1)!.split(',');
          for (var res in resolutions) {
            // Replaces the resolution block with the current resolution
            final finalLink = extractLink.replaceAll(
              RegExp(r',[^/]+'),
              // --- THIS IS THE CORRECTED LINE ---
              res.replaceAll('p', 'p'), // Remove the leading slash '/'
            );
            parsedLinks.add({
              'resolution': res,
              'url':finalLink, // Also ensure you add the protocol back
            });
          }
        }
      } catch (e) {
        log("Error parsing wixmp link: $e");
      }
    }
    // Case 2: Handle master M3U8 links (that are not wixmp)
    else if (link.contains('master.m3u8')) {
      log('Parsing master.m3u8 link...');
      try {
        // Get the base path for relative links inside the M3U8 file
        final relativeLink = link.substring(0, link.lastIndexOf('/') + 1);
        final response = await _dio.get(link);
        final m3u8Content = response.data.toString();

        final lines = m3u8Content.split('\n');
        for (var i = 0; i < lines.length; i++) {
          final line = lines[i];
          if (line.startsWith('#EXT-X-STREAM-INF')) {
            final resolutionMatch = RegExp(
              r'RESOLUTION=\d+x(\d+)',
            ).firstMatch(line);
            if (resolutionMatch != null) {
              final resolution = '${resolutionMatch.group(1)}p';
              final streamUrl = lines[i + 1]; // The URL is on the next line
              final fullStreamUrl = streamUrl.startsWith('http')
                  ? streamUrl
                  : relativeLink + streamUrl;
              parsedLinks.add({'resolution': resolution, 'url': fullStreamUrl});
            }
          }
        }
      } catch (e) {
        log("Error parsing m3u8 link: $e");
      }
    }
    // Case 3: Default case for any other links
    else {
      log('Found default link...');
      parsedLinks.add({'resolution': 'Default', 'url': link});
    }

    // Sort by resolution descending (like 'sort -nr')
    parsedLinks.sort((a, b) {
      int resA = int.tryParse(a['resolution']!.replaceAll('p', '')) ?? 0;
      int resB = int.tryParse(b['resolution']!.replaceAll('p', '')) ?? 0;
      return resB.compareTo(resA);
    });

    return parsedLinks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.thumbnail != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.thumbnail!,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.description),
                  const SizedBox(height: 16),
                  const Text(
                    "Episodes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  if (_episodes.isEmpty)
                    const Text("No episodes available")
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _episodes["sub"]
                          .map<Widget>(
                            (ep) => ActionChip(
                              label: Text("EP $ep"),
                              onPressed: () => _fetchEpisodeSources(ep),
                            ),
                          )
                          .toList(),
                    ),
                  const SizedBox(height: 16),
                  if (_apiResponse != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "API Response",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(_apiResponse!),
                      ],
                    ),
                ],
              ),
            ),
    );
  }
}
