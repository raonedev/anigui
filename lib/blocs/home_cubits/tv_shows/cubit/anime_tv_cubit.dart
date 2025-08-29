import 'package:anigui/models/anime_home_card.dart';
import 'package:anigui/services/home_api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'anime_tv_state.dart';

class AnimeTvCubit extends Cubit<AnimeTvState> {
  final ApiService _apiService;
  AnimeTvCubit(this._apiService) : super(AnimeTvInitialState());

  Future<void> loadTvAnimes()async{
    try {
      emit(AnimeTvLoadingState());
      final result = await _apiService.fetchAnimeCards(types: ['TV']);
      emit(AnimeTvSuccessState(animes: result));
    } catch (e) {
      emit(AnimeTvErrorState(errorMessage: e.toString()));
    }
  }
}
