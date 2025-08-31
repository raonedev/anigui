import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../models/anime_home_card.dart';
import '../../../../services/home_api_service.dart';

part 'anime_ona_state.dart';

class AnimeOnaCubit extends Cubit<AnimeOnaState> {
  final ApiService _apiService;
  AnimeOnaCubit(this._apiService) : super(AnimeOnaInitial());

  Future<void> loadOnaAnime()async{
    try {
      emit(AnimeOnaLoadingState());
      final result = await _apiService.fetchAnimeCards(types: ["ONA"]);
      emit(AnimeOnaSuccessState(animes: result));
    } catch (e) {
      emit(AnimeOnaErrorState(errorMessage: e.toString()));
    }
  }
}
