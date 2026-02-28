// Episode Model
import 'dart:convert';

class EpisodeModel {
  final int? id;
  final String animeId;
  final int episodeNumber;
  final int watchedTime;
  final int isCompletelyWatched;
  final bool isSub;
  final List<String> videoUrls;

  EpisodeModel({
    this.id,
    required this.animeId,
    required this.episodeNumber,
    this.watchedTime = 0,
    this.isCompletelyWatched = 0,
    required this.isSub,
    required this.videoUrls,
  });

  // Convert from database map to model
  factory EpisodeModel.fromMap(Map<String, dynamic> map) {
    return EpisodeModel(
      id: map['id'] as int?,
      animeId: map['animeId'] as String,
      episodeNumber: map['episodeNumber'] as int,
      watchedTime: map['watchedTime'] as int? ?? 0,
      isCompletelyWatched: map['isCompletelyWatched'] as int? ?? 0,
      isSub: (map['isSub'] as int? ?? 1) == 1,
      videoUrls: (jsonDecode(map['video_urls'] as String) as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
    );
  }

  // Convert from model to database map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'animeId': animeId,
      'episodeNumber': episodeNumber,
      'watchedTime': watchedTime,
      'isCompletelyWatched': isCompletelyWatched,
      'isSub': isSub ? 1 : 0,
      'video_urls': jsonEncode(videoUrls),
    };
  }

  // CopyWith method for easy updates
  EpisodeModel copyWith({
    int? id,
    String? animeId,
    int? episodeNumber,
    int? watchedTime,
    int? isCompletelyWatched,
    bool? isSub,
    List<String>? videoUrls,
  }) {
    return EpisodeModel(
      id: id ?? this.id,
      animeId: animeId ?? this.animeId,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      watchedTime: watchedTime ?? this.watchedTime,
      isCompletelyWatched: isCompletelyWatched ?? this.isCompletelyWatched,
      isSub: isSub ?? this.isSub,
      videoUrls: videoUrls ?? this.videoUrls,
    );
  }

  @override
  String toString() {
    return 'EpisodeModel(id: $id, animeId: $animeId, episodeNumber: $episodeNumber, watchedTime: $watchedTime, isCompletelyWatched: $isCompletelyWatched, isSub: $isSub, videoUrls: $videoUrls)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EpisodeModel &&
        other.id == id &&
        other.animeId == animeId &&
        other.episodeNumber == episodeNumber &&
        other.watchedTime == watchedTime &&
        other.isCompletelyWatched == isCompletelyWatched &&
        other.isSub == isSub;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    animeId.hashCode ^
    episodeNumber.hashCode ^
    watchedTime.hashCode ^
    isCompletelyWatched.hashCode ^
    isSub.hashCode;
  }
}