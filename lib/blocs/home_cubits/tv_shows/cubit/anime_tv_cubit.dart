import 'package:anigui/helpers/db_helper.dart';
import 'package:anigui/models/anime_home_card.dart';
import 'package:anigui/services/http_api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'anime_tv_state.dart';

class AnimeTvCubit extends Cubit<AnimeTvState> {
  final ApiService _apiService;
  final DbHelper _databaseService;
  AnimeTvCubit(this._apiService, this._databaseService) : super(AnimeTvInitialState());

  Future<void> loadTvAnimes()async{
    try {
      emit(AnimeTvLoadingState());
      final result = await _apiService.fetchAnimeByTypes(types: ['TV']);
      // Update database with fresh data
      await _databaseService.insertAnimeCardsBatch(result);
      emit(AnimeTvSuccessState(animes: result));
    } catch (e) {
      // if Network fail, try to get cached data from database
      final cachedAnime = await _databaseService.getAnimeCardsByType('TV');
      // If we have cached data, emit it immediately
      if (cachedAnime.isNotEmpty) {
        emit(AnimeTvSuccessState(
          animes: cachedAnime,
        ));
        return;
      }
      emit(AnimeTvErrorState(errorMessage: e.toString()));
    }
  }
}
