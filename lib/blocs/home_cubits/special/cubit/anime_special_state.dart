part of 'anime_special_cubit.dart';

@immutable
sealed class AnimeSpecialState {}

final class AnimeSpecialInitial extends AnimeSpecialState {}

final class AnimeSpecialLoadingState extends AnimeSpecialState {}

final class AnimeSpecialErrorState extends AnimeSpecialState {
  final String errorMessage;
  AnimeSpecialErrorState({required this.errorMessage});
}

final class AnimeSpecialSuccessState extends AnimeSpecialState {
  final List<AnimeHomeCard> animes;
  AnimeSpecialSuccessState({required this.animes});
}
