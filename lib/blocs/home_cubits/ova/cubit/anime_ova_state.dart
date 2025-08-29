part of 'anime_ova_cubit.dart';

@immutable
sealed class AnimeOvaState {}

final class AnimeOvaInitialState extends AnimeOvaState {}

final class AnimeOvaLoadingState extends AnimeOvaState {}

final class AnimeOvaErrorState extends AnimeOvaState {
  final String errorMessage;
  AnimeOvaErrorState({required this.errorMessage});
}

final class AnimeOvaSuccessState extends AnimeOvaState {
  final List<AnimeHomeCard> animes;
  AnimeOvaSuccessState({required this.animes});
}
