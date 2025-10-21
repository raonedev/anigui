import 'package:anigui/models/anime_home_card.dart';
import 'package:anigui/services/http_api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../helpers/db_helper.dart';

part 'anime_movie_state.dart';

class AnimeMovieCubit extends Cubit<AnimeMovieState> {
  final ApiService _apiService;
  final DbHelper _databaseService;

  AnimeMovieCubit(this._apiService, this._databaseService)
    : super(AnimeMovieInitialState());

  Future<void> loadMovieAnime() async {
    try {
      emit(AnimeMovieLoadingState());
      final result = await _apiService.fetchAnimeByTypes(types: ['Movie']);
      // Update database with fresh data
      await _databaseService.insertAnimeCardsBatch(result);
      final cachedAnime = await _databaseService.getAnimeCardsByType('Movie');
      // If we have cached data, emit it immediately
      if (cachedAnime.isNotEmpty) {
        emit(AnimeMovieSuccessState(animes: cachedAnime));
        return;
      }
      emit(AnimeMovieSuccessState(animes: result));
    } catch (e) {
      // if Network fail, try to get cached data from database
      final cachedAnime = await _databaseService.getAnimeCardsByType('Movie');
      // If we have cached data, emit it immediately
      if (cachedAnime.isNotEmpty) {
        emit(AnimeMovieSuccessState(animes: cachedAnime));
        return;
      }
      emit(AnimeMovieErrorState(errorMessage: e.toString()));
    }
  }
}
