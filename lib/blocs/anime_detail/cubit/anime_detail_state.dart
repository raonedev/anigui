part of 'anime_detail_cubit.dart';

@immutable
sealed class AnimeDetailState {}

final class AnimeDetailInitialState extends AnimeDetailState {}


final class AnimeDetailLoadingState extends AnimeDetailState {}


final class AnimeDetailErrorState extends AnimeDetailState {
  final String errorMessage;

  AnimeDetailErrorState({required this.errorMessage});
}


final class AnimeDetailSuccessState extends AnimeDetailState {
  final AnimeModel animeDetail;
  AnimeDetailSuccessState({required this.animeDetail});
}