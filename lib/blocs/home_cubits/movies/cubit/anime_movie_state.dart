part of 'anime_movie_cubit.dart';

@immutable
sealed class AnimeMovieState {}

final class AnimeMovieInitialState extends AnimeMovieState {}

final class AnimeMovieLoadingState extends AnimeMovieState {}

final class AnimeMovieErrorState extends AnimeMovieState {
  final String errorMessage;

  AnimeMovieErrorState({required this.errorMessage});
}

final class AnimeMovieSuccessState extends AnimeMovieState {
  final List<AnimeHomeCard> animes;
  AnimeMovieSuccessState({required this.animes});
}
