import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../models/anime_home_card.dart';
import '../../../../services/home_api_service.dart';

part 'anime_special_state.dart';

class AnimeSpecialCubit extends Cubit<AnimeSpecialState> {

   final ApiService _apiService;
  AnimeSpecialCubit(this._apiService) : super(AnimeSpecialInitial());

  Future<void> loadSpecialAnimes()async{
    try {
      emit(AnimeSpecialLoadingState());
      final result = await _apiService.fetchAnimeCards(types: ['Special']);
      emit(AnimeSpecialSuccessState(animes: result));
    } catch (e) {
      emit(AnimeSpecialErrorState(errorMessage: e.toString()));
    }
  }
}
