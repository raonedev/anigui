import 'package:anigui/models/anime_home_card.dart';
import 'package:anigui/services/home_api_service.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'anime_ova_state.dart';

class AnimeOvaCubit extends Cubit<AnimeOvaState> {
  final ApiService _apiService;
  AnimeOvaCubit(this._apiService) : super(AnimeOvaInitialState());

  Future<void> loadOvaAnime()async{
    try {
      emit(AnimeOvaLoadingState());
      final result = await _apiService.fetchAnimeCards(types: ["OVA"]);
      emit(AnimeOvaSuccessState(animes: result));
    } catch (e) {
      emit(AnimeOvaErrorState(errorMessage: e.toString()));
    }
  }

}
