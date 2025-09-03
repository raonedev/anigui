import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'anime_detail_state.dart';

class AnimeDetailCubit extends Cubit<AnimeDetailState> {
  AnimeDetailCubit() : super(AnimeDetailInitialState());
}
