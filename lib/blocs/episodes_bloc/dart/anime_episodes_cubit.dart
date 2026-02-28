import 'dart:developer' as dev;

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../helpers/db_helper.dart';
import '../../../models/episodes_model.dart';
import '../../../services/http_api_service.dart';

part 'anime_episodes_state.dart';

class AnimeEpisodesCubit extends Cubit<AnimeEpisodesState> {
  final ApiService _apiService;
  final DbHelper _databaseHelper;

  AnimeEpisodesCubit(this._apiService, this._databaseHelper)
    : super(AnimeEpisodesInitial());

  Future<void> fetchEpisodeSources({
    required String showId,
    required String episode,
    required bool isDub,
  }) async {
    try {
      emit(AnimeEpisodesLoading());

      final res = await _apiService.fetchEpisodeSources(
        showId: showId,
        episode: episode,
        translationType: isDub ? "dub" : "sub",
      );

      // Extract all URLs from the response
      List<String> videoUrls = res
          .map<String>((e) => e['url']?.toString() ?? '')
          .toList();

      // Remove any empty URLs
      videoUrls = videoUrls.where((url) => url.isNotEmpty).toList();

      if (videoUrls.isNotEmpty) {
        // Create episode model
        final episodeModel = EpisodeModel(
          animeId: showId,
          episodeNumber: int.tryParse(episode) ?? 0,
          videoUrls: videoUrls,
          isSub: !isDub,
        );

        // Save episode to database
        await _databaseHelper.insertEpisode(episodeModel);

        emit(
          AnimeEpisodesLoaded(
            videoUrls: videoUrls,
            episodeNo: episode,
            animeId: showId,
            isSub: !isDub,
          ),
        );
      } else {
        emit(AnimeEpisodesError(message: 'No video URLs found'));
      }
    } catch (e) {
      emit(AnimeEpisodesError(message: e.toString()));
    }
  }

  Future<void> updateWatchProgress({
    required String animeId,
    required int episodeNumber,
    required bool isSub,
    required int watchedTime,
    int? isCompletelyWatched,
  }) async {
    try {
      await _databaseHelper.updateEpisodeProgress(
        animeId: animeId,
        episodeNumber: episodeNumber,
        isSub: isSub,
        watchedTime: watchedTime,
        isCompletelyWatched: isCompletelyWatched,
      );
    } catch (e) {
      debugPrint('Error updating watch progress: $e');
    }
  }

  Future<EpisodeModel?> getEpisodeFromDatabase({
    required String animeId,
    required int episodeNumber,
    required bool isSub,
  }) async {
    try {
      return await _databaseHelper.getEpisode(
        animeId: animeId,
        episodeNumber: episodeNumber,
        isSub: isSub,
      );
    } catch (e) {
      debugPrint('Error getting episode from database: $e');
      return null;
    }
  }

  Future<List<EpisodeModel>> getAllEpisodes(String animeId) async {
    try {
      return await _databaseHelper.getEpisodesByAnimeId(animeId);
    } catch (e) {
      print('Error getting episodes from database: $e');
      return [];
    }
  }

  // Add this method to AnimeEpisodesCubit

  Future<void> updateWatchTime({
    required String animeId,
    required int episodeNumber,
    required bool isSub,
    required int watchedTime,
  }) async {
    try {
      await _databaseHelper.updateEpisodeProgress(
        animeId: animeId,
        episodeNumber: episodeNumber,
        isSub: isSub,
        watchedTime: watchedTime,
      );
      dev.log("watch time updated");
    } catch (e) {
      dev.log('Error updating watch time: $e');
    }
  }

  void resetState() {
    emit(AnimeEpisodesInitial());
  }
}
