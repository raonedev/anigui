import 'package:anigui/models/anime_home_card.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'anime_ova_state.dart';

class AnimeOvaCubit extends Cubit<AnimeOvaState> {
  AnimeOvaCubit() : super(AnimeOvaInitialState());
}
