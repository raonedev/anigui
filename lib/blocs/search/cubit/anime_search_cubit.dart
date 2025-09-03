import 'package:anigui/models/anime_home_card.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../services/http_api_service.dart';

part 'anime_search_state.dart';

class AnimeSearchCubit extends Cubit<AnimeSearchState> {
  final ApiService _apiService;
  AnimeSearchCubit(this._apiService) : super(AnimeSearchInitialState());

    Future<void> searchAnime({List<String>? types, required String name}) async {
      try {
        emit(AnimeSearchLoadingState());
        final result = await _apiService.fetchAnimeBySearch(name: name);
        emit(AnimeSearchSuccessState(animes: result));
      } catch (e) {
        emit(AnimeSearchErrorState(errorMessage: e.toString()));
      }
    }
}
