import 'package:anigui/models/anime_home_card.dart';
import 'package:anigui/services/http_api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../helpers/db_helper.dart';

part 'anime_ova_state.dart';

class AnimeOvaCubit extends Cubit<AnimeOvaState> {
  final ApiService _apiService;
  final DbHelper _databaseService;
  AnimeOvaCubit(this._apiService, this._databaseService) : super(AnimeOvaInitialState());

  Future<void> loadOvaAnime()async{
    try {
      emit(AnimeOvaLoadingState());
      final result = await _apiService.fetchAnimeByTypes(types: ["OVA"]);
      // Update database with fresh data
      await _databaseService.insertAnimeCardsBatch(result);
      emit(AnimeOvaSuccessState(animes: result));
    } catch (e) {
      // if Network fail, try to get cached data from database
      final cachedAnime = await _databaseService.getAnimeCardsByType('OVA');
      // If we have cached data, emit it immediately
      if (cachedAnime.isNotEmpty) {
        emit(AnimeOvaSuccessState(
          animes: cachedAnime,
        ));
        return;
      }
      emit(AnimeOvaErrorState(errorMessage: e.toString()));
    }
  }

}
