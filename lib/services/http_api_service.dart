import 'dart:convert';
import 'dart:developer';

import 'package:anigui/models/anime_home_card.dart';
import 'package:dio/dio.dart';

import '../models/anime_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://api.allanime.day/",
      headers: {
        // As seen in your Postman example, the Referer header is required for this API.
        "Referer": "https://allmanga.to",
      },
    ),
  );

  /// Fetches a list of anime cards based on the provided types.
  ///
  /// This method now uses a POST request, which is the correct way to
  /// send GraphQL queries with variables to this specific API endpoint.
  Future<List<AnimeHomeCard>> fetchAnimeByTypes({
    required List<String> types,
  }) async {
    try {
      final response = await _dio.post(
        "api",
        data: {
          // Changed from `queryParameters` to `data` for the POST body
          "variables": {
            "search": {
              "allowAdult": false,
              "allowUnknown": false,
              "types": types,
            },
            "limit": 20,
            "page": 1,
            "translationType": "sub",
            "countryOrigin": "ALL",
          },
          "query":
              "query(\$search: SearchInput \$limit: Int \$page: Int \$translationType: VaildTranslationTypeEnumType \$countryOrigin: VaildCountryOriginEnumType) {shows(search: \$search limit: \$limit page: \$page translationType: \$translationType countryOrigin: \$countryOrigin) {edges{_id englishName name thumbnail score type genres tags episodeDuration episodeCount status __typename}}}",
        },
      );

      final data = response.data['data']['shows']['edges'] as List;
      return data.map((e) => AnimeHomeCard.fromJson(e)).toList();
    } on DioException catch (e) {
      // It's good practice to catch Dio-specific exceptions for detailed logging.
      log(
        "DioError fetching anime cards",
        error: e.response?.data ?? e.message,
      );
      return [];
    } catch (e) {
      log("Unknown error fetching anime cards", error: e);
      rethrow;
    }
  }

  Future<List<AnimeHomeCard>> fetchAnimeBySearch({
    List<String>? types,
    required String name,
  }) async {
    try {
      final response = await _dio.post(
        "api",
        data: {
          // Changed from `queryParameters` to `data` for the POST body
          "variables": {
            "search": {
              "allowAdult": false,
              "allowUnknown": false,
              "query": name,
              if (types != null) "types": types,
            },
            "limit": 20,
            "page": 1,
            "translationType": "sub",
            "countryOrigin": "ALL",
          },
          "query":
              "query(\$search: SearchInput \$limit: Int \$page: Int \$translationType: VaildTranslationTypeEnumType \$countryOrigin: VaildCountryOriginEnumType) {shows(search: \$search limit: \$limit page: \$page translationType: \$translationType countryOrigin: \$countryOrigin) {edges{_id englishName name thumbnail score type genres tags episodeDuration episodeCount status __typename}}}",
        },
      );

      final data = response.data['data']['shows']['edges'] as List;
      return data.map((e) => AnimeHomeCard.fromJson(e)).toList();
    } on DioException catch (e) {
      // It's good practice to catch Dio-specific exceptions for detailed logging.
      log(
        "DioError fetching anime cards",
        error: e.response?.data ?? e.message,
      );
      return [];
    } catch (e) {
      log("Unknown error fetching anime cards", error: e);
      rethrow;
    }
  }

  Future<AnimeModel> fetchAnimeDetail({required String id}) async {
    try {
      final response = await _dio.get(
        "https://api.allanime.day/api",
        queryParameters: {
          "variables": {"showId": id},
          "query":
              "query (\$showId: String!) { show( _id: \$showId ) { _id updateQueue isAdult manualUpdated dailyUpdateNeeded hidden lastUpdateStart lastUpdateEnd name englishName nativeName nameOnlyString countryOfOrigin malId aniListId status altNames trustedAltNames description prevideos thumbnail banner thumbnails musics score type averageScore genres tags popularity airedStart airedEnd season rating broadcastInterval relatedShows relatedMangas characters determinedInterval episodeDuration studios lastEpisodeDate lastEpisodeTimestamp lastEpisodeInfo availableEpisodes availableEpisodesDetail }}",
        },
      );
      if (response.statusCode == 200) {
        // log(show.toString());
        return AnimeModel.fromMap(response.data['data']['show']);
      }
      throw Exception("${response.statusCode} Failed to get AnimeDetail");
    } on DioException catch (e) {
      // It's good practice to catch Dio-specific exceptions for detailed logging.
      log(
        "DioError fetching anime cards",
        error: e.response?.data ?? e.message,
      );
      rethrow;
    } catch (e) {
      log("Unknown error fetching anime cards", error: e);
      rethrow;
    }
  }

  Future<List<Map<String, String>>> fetchEpisodeSources({
    required String showId,
    required String episode,
    required String translationType,
  }) async {
    final List<Map<String, String>> finalVideoLinks = [];
    const String url = "https://api.allanime.day/api";

    final Map<String, dynamic> variables = {
      "showId": showId,
      "translationType": translationType,
      "episodeString": episode,
    };

    const String gqlQuery = '''
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

      final sourceUrls = response.data?["data"]?["episode"]?["sourceUrls"] as List<dynamic>?;

      if (sourceUrls == null || sourceUrls.isEmpty) {
        throw Exception(
          "No source URLs found for episode $episode of anime $showId.",
        );
      }

      for (final source in sourceUrls) {
        final sourceName = source['sourceName']?.toString() ?? '';
        var sourceUrl = source['sourceUrl']?.toString() ?? '';

        if (sourceName.isEmpty || sourceUrl.isEmpty) continue;
        if(!sourceUrl.startsWith("--")) continue;
        sourceUrl = sourceUrl.replaceFirst('--', '');

        final decodedUrl = _isSupportedSource(sourceName)
            ? _providerInit(sourceUrl, sourceName)
            : '';

        if (decodedUrl.isEmpty) continue;

        if (decodedUrl.contains('/clock.json')) {
          try {
            final clockLinks = await _fetchClockJsonLinks(decodedUrl);
          finalVideoLinks.addAll(clockLinks);
          } catch (e) {
            log(e.toString());
          }
        } else {
          finalVideoLinks.add({'resolution': sourceName, 'url': decodedUrl});
        }
      }

      return finalVideoLinks;
    } catch (e, stackTrace) {
      log("Error fetching episode sources: $e");
      log(stackTrace.toString());
      return [];
    }
  }

  bool _isSupportedSource(String sourceName) {
    const supportedSources = {"Default", "Yt-mp4", "S-mp4", "Luf-Mp4"};
    return supportedSources.contains(sourceName);
  }

  String _providerInit(String encodedUrl, String providerName) {
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

  Future<List<Map<String, String>>> _fetchClockJsonLinks(String clockUrl) async {
    final List<Map<String, String>> finalVideoLinks = [];
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
      return finalVideoLinks;
    } catch (e,stackTrace) {
            log(
        "Error fetching clock JSON links: ",
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
  



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
              'url': finalLink, // Also ensure you add the protocol back
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
}
