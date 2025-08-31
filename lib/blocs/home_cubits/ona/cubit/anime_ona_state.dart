part of 'anime_ona_cubit.dart';

@immutable
sealed class AnimeOnaState {}

final class AnimeOnaInitial extends AnimeOnaState {}

final class AnimeOnaLoadingState extends AnimeOnaState {}

final class AnimeOnaErrorState extends AnimeOnaState {
  final String errorMessage;
  AnimeOnaErrorState({required this.errorMessage});
}

final class AnimeOnaSuccessState extends AnimeOnaState {
  final List<AnimeHomeCard> animes;
  AnimeOnaSuccessState({required this.animes});
}
