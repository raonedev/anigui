part of 'anime_episodes_cubit.dart';

@immutable
sealed class AnimeEpisodesState {}

final class AnimeEpisodesInitial extends AnimeEpisodesState {}

final class AnimeEpisodesLoading extends AnimeEpisodesState {}

final class AnimeEpisodesLoaded extends AnimeEpisodesState {
  final List<String> videoUrls;
  final String episodeNo;
  final String animeId;
  final bool isSub;

  AnimeEpisodesLoaded({
    required this.videoUrls,
    required this.episodeNo,
    required this.animeId,
    required this.isSub,
  });
}

final class AnimeEpisodesError extends AnimeEpisodesState {
  final String message;

  AnimeEpisodesError({required this.message});
}
