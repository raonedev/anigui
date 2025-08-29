import 'package:anigui/models/anime_home_card.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'anime_movie_state.dart';

class AnimeMovieCubit extends Cubit<AnimeMovieState> {
  AnimeMovieCubit() : super(AnimeMovieInitialState());
}
