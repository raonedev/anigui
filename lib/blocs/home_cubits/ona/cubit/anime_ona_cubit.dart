import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../helpers/db_helper.dart';
import '../../../../models/anime_home_card.dart';
import '../../../../services/http_api_service.dart';

part 'anime_ona_state.dart';

class AnimeOnaCubit extends Cubit<AnimeOnaState> {
  final ApiService _apiService;
  final DbHelper _databaseService;
  AnimeOnaCubit(this._apiService, this._databaseService) : super(AnimeOnaInitial());

  Future<void> loadOnaAnime()async{
    try {
      emit(AnimeOnaLoadingState());
      final result = await _apiService.fetchAnimeByTypes(types: ["ONA"]);
      // Update database with fresh data
      await _databaseService.insertAnimeCardsBatch(result);
      emit(AnimeOnaSuccessState(animes: result));
    } catch (e) {
      // if Network fail, try to get cached data from database
      final cachedAnime = await _databaseService.getAnimeCardsByType('ONA');
      // If we have cached data, emit it immediately
      if (cachedAnime.isNotEmpty) {
        emit(AnimeOnaSuccessState(
          animes: cachedAnime,
        ));
        return;
      }
      emit(AnimeOnaErrorState(errorMessage: e.toString()));
    }
  }
}
