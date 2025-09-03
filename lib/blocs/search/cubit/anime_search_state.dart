part of 'anime_search_cubit.dart';

@immutable
sealed class AnimeSearchState {}

final class AnimeSearchInitialState extends AnimeSearchState {}


final class AnimeSearchLoadingState extends AnimeSearchState {}

final class AnimeSearchEmptyState extends AnimeSearchState {}

final class AnimeSearchErrorState extends AnimeSearchState {
  final String errorMessage;
  AnimeSearchErrorState({required this.errorMessage});
}

final class AnimeSearchSuccessState extends AnimeSearchState {
  final List<AnimeHomeCard> animes;
  AnimeSearchSuccessState({required this.animes});
}


