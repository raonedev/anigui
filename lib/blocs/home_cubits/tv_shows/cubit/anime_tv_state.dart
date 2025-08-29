part of 'anime_tv_cubit.dart';

@immutable
sealed class AnimeTvState {}

final class AnimeTvInitialState extends AnimeTvState {}

final class AnimeTvLoadingState extends AnimeTvState {}

final class AnimeTvErrorState extends AnimeTvState {
  final String errorMessage;
  AnimeTvErrorState({required this.errorMessage});
}

final class AnimeTvSuccessState extends AnimeTvState {
  final List<AnimeHomeCard> animes;
  AnimeTvSuccessState({required this.animes});
}

