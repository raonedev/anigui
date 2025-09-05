import 'package:anigui/models/anime_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../services/http_api_service.dart' show ApiService;

part 'anime_detail_state.dart';

class AnimeDetailCubit extends Cubit<AnimeDetailState> {
  final ApiService _apiService;
  AnimeDetailCubit(this._apiService) : super(AnimeDetailInitialState());

  Future<void> getAnimeDetail({required String animeId})async{
    try {
      emit(AnimeDetailLoadingState());
      final result = await _apiService.fetchAnimeDetail(id: animeId);
      emit(AnimeDetailSuccessState(animeDetail: result));
    } catch (e) {
      emit(AnimeDetailErrorState(errorMessage: e.toString()));
    }
  }
}
