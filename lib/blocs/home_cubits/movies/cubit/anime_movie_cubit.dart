import 'package:anigui/models/anime_home_card.dart';
import 'package:anigui/services/http_api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'anime_movie_state.dart';

class AnimeMovieCubit extends Cubit<AnimeMovieState> {
  final ApiService _apiService;
  AnimeMovieCubit(this._apiService) : super(AnimeMovieInitialState());

  Future<void> loadMovieAnime()async{
    try {
      emit(AnimeMovieLoadingState());
      final result = await _apiService.fetchAnimeByTypes(types: ['Movie']);
      emit(AnimeMovieSuccessState(animes: result));
    } catch (e) {
      emit(AnimeMovieErrorState(errorMessage: e.toString()));
    }
  }
}
