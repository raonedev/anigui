import 'package:anigui/models/anime_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../helpers/db_helper.dart';
import '../../../services/http_api_service.dart' show ApiService;

part 'anime_detail_state.dart';

class AnimeDetailCubit extends Cubit<AnimeDetailState> {
  final ApiService _apiService;
  final DbHelper _databaseService;

  AnimeDetailCubit(this._apiService, this._databaseService)
    : super(AnimeDetailInitialState());

  Future<void> getAnimeDetail({required String animeId}) async {
    try {
      emit(AnimeDetailLoadingState());

      final AnimeModel result = await _apiService.fetchAnimeDetail(id: animeId);
      // Update database with fresh data
      await _databaseService.insertAnimeDetail(result);

      // First, try to get cached data from database
      final cachedDetail = await _databaseService.getAnimeDetail(animeId);

      // If we have cached data, emit it immediately
      if (cachedDetail != null) {
        emit(AnimeDetailSuccessState(animeDetail: cachedDetail));
        return;
      }
      emit(AnimeDetailSuccessState(animeDetail: result));
    } catch (e) {
      // First, try to get cached data from database
      final cachedDetail = await _databaseService.getAnimeDetail(animeId);

      // If we have cached data, emit it immediately
      if (cachedDetail != null) {
        emit(AnimeDetailSuccessState(animeDetail: cachedDetail));
        return;
      }
      emit(AnimeDetailErrorState(errorMessage: e.toString()));
    }
  }
}
