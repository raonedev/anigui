import 'dart:developer';

import 'package:anigui/models/anime_home_card.dart';
import 'package:dio/dio.dart';

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
  Future<List<AnimeHomeCard>> fetchAnimeCards({required List<String> types}) async {
    try {
      final response = await _dio.post(
        "api",
        data: { // Changed from `queryParameters` to `data` for the POST body
          "variables": {
            "search": {
              "allowAdult": false,
              "allowUnknown": false,
              "types": types,
            },
            "limit": 20,
            "page": 1,
            "translationType": "sub",
            "countryOrigin": "ALL"
          },
          "query":
              "query(\$search: SearchInput \$limit: Int \$page: Int \$translationType: VaildTranslationTypeEnumType \$countryOrigin: VaildCountryOriginEnumType) {shows(search: \$search limit: \$limit page: \$page translationType: \$translationType countryOrigin: \$countryOrigin) {edges{_id englishName thumbnail score type genres tags episodeDuration episodeCount status __typename}}}"
        },
      );

      final data = response.data['data']['shows']['edges'] as List;
      return data.map((e) => AnimeHomeCard.fromJson(e)).toList();
    } on DioException catch (e) {
      // It's good practice to catch Dio-specific exceptions for detailed logging.
      log("DioError fetching anime cards", error: e.response?.data ?? e.message);
      return []; 
    } catch (e) {
      log("Unknown error fetching anime cards", error: e);
      return [];
    }
  }
}
