import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../helpers/db_helper.dart';
import '../../../../models/anime_home_card.dart';
import '../../../../services/http_api_service.dart';

part 'anime_special_state.dart';

class AnimeSpecialCubit extends Cubit<AnimeSpecialState> {

   final ApiService _apiService;
   final DbHelper _databaseService;
  AnimeSpecialCubit(this._apiService, this._databaseService) : super(AnimeSpecialInitial());

  Future<void> loadSpecialAnimes()async{
    try {
      emit(AnimeSpecialLoadingState());
      final result = await _apiService.fetchAnimeByTypes(types: ['Special']);
      // Update database with fresh data
      await _databaseService.insertAnimeCardsBatch(result);
      final cachedAnime = await _databaseService.getAnimeCardsByType('Special');
      // If we have cached data, emit it immediately
      if (cachedAnime.isNotEmpty) {
        emit(AnimeSpecialSuccessState(
          animes: cachedAnime,
        ));
        return;
      }
      emit(AnimeSpecialSuccessState(animes: result));
    } catch (e) {
      // if Network fail, try to get cached data from database
      final cachedAnime = await _databaseService.getAnimeCardsByType('Special');
      // If we have cached data, emit it immediately
      if (cachedAnime.isNotEmpty) {
        emit(AnimeSpecialSuccessState(
          animes: cachedAnime,
        ));
        return;
      }
      emit(AnimeSpecialErrorState(errorMessage: e.toString()));
    }
  }
}
