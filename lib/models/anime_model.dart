import 'dart:convert';

import 'package:flutter/foundation.dart';

class AnimeModel {
  final String? id;
  final String? updateQueue;
  final bool? isAdult;
  final bool? manualUpdated;
  final bool? dailyUpdateNeeded;
  final bool? hidden;
  final String? lastUpdateStart;
  final String? lastUpdateEnd;
  final String? name;
  final String? englishName;
  final String? nativeName;
  final String? nameOnlyString;
  final String? countryOfOrigin;
  final String? malId;
  final String? aniListId;
  final String? status;
  final List<String>? altNames;
  final List<String>? trustedAltNames;
  final String? description;
  final List<String>? prevideos;
  final String? thumbnail;
  final String? banner;
  final List<String>? thumbnails;
  final List<Music>? musics;
  final double? score;
  final String? type;
  final int? averageScore;
  final List<String>? genres;
  final List<String>? tags;
  final String? popularity;
  final AiredStart? airedStart;
  final AiredEnd? airedEnd;
  final Season? season;
  final String? rating;
  final String? broadcastInterval;
  final List<RelatedShows>? relatedShows;
  final List<RelatedMangas>? relatedMangas;
  final List<Characters>? characters;
  final DeterminedInterval? determinedInterval;
  final String? episodeDuration;
  final List<String>? studios;
  final LastEpisodeDate? lastEpisodeDate;
  final LastEpisodeTimestamp? lastEpisodeTimestamp;
  final AvailableEpisodes? availableEpisodes;
  final AvailableEpisodesDetail? availableEpisodesDetail;
  AnimeModel({
    this.id,
    this.updateQueue,
    this.isAdult,
    this.manualUpdated,
    this.dailyUpdateNeeded,
    this.hidden,
    this.lastUpdateStart,
    this.lastUpdateEnd,
    this.name,
    this.englishName,
    this.nativeName,
    this.nameOnlyString,
    this.countryOfOrigin,
    this.malId,
    this.aniListId,
    this.status,
    this.altNames,
    this.trustedAltNames,
    this.description,
    this.prevideos,
    this.thumbnail,
    this.banner,
    this.thumbnails,
    this.musics,
    this.score,
    this.type,
    this.averageScore,
    this.genres,
    this.tags,
    this.popularity,
    this.airedStart,
    this.airedEnd,
    this.season,
    this.rating,
    this.broadcastInterval,
    this.relatedShows,
    this.relatedMangas,
    this.characters,
    this.determinedInterval,
    this.episodeDuration,
    this.studios,
    this.lastEpisodeDate,
    this.lastEpisodeTimestamp,
    this.availableEpisodes,
    this.availableEpisodesDetail,
  });

  AnimeModel copyWith({
    String? id,
    String? updateQueue,
    bool? isAdult,
    bool? manualUpdated,
    bool? dailyUpdateNeeded,
    bool? hidden,
    String? lastUpdateStart,
    String? lastUpdateEnd,
    String? name,
    String? englishName,
    String? nativeName,
    String? nameOnlyString,
    String? countryOfOrigin,
    String? malId,
    String? aniListId,
    String? status,
    List<String>? altNames,
    List<String>? trustedAltNames,
    String? description,
    List<String>? prevideos,
    String? thumbnail,
    String? banner,
    List<String>? thumbnails,
    List<Music>? musics,
    double? score,
    String? type,
    int? averageScore,
    List<String>? genres,
    List<String>? tags,
    String? popularity,
    AiredStart? airedStart,
    AiredEnd? airedEnd,
    Season? season,
    String? rating,
    String? broadcastInterval,
    List<RelatedShows>? relatedShows,
    List<RelatedMangas>? relatedMangas,
    List<Characters>? characters,
    DeterminedInterval? determinedInterval,
    String? episodeDuration,
    List<String>? studios,
    LastEpisodeDate? lastEpisodeDate,
    LastEpisodeTimestamp? lastEpisodeTimestamp,
    AvailableEpisodes? availableEpisodes,
    AvailableEpisodesDetail? availableEpisodesDetail,
  }) {
    return AnimeModel(
      id: id ?? this.id,
      updateQueue: updateQueue ?? this.updateQueue,
      isAdult: isAdult ?? this.isAdult,
      manualUpdated: manualUpdated ?? this.manualUpdated,
      dailyUpdateNeeded: dailyUpdateNeeded ?? this.dailyUpdateNeeded,
      hidden: hidden ?? this.hidden,
      lastUpdateStart: lastUpdateStart ?? this.lastUpdateStart,
      lastUpdateEnd: lastUpdateEnd ?? this.lastUpdateEnd,
      name: name ?? this.name,
      englishName: englishName ?? this.englishName,
      nativeName: nativeName ?? this.nativeName,
      nameOnlyString: nameOnlyString ?? this.nameOnlyString,
      countryOfOrigin: countryOfOrigin ?? this.countryOfOrigin,
      malId: malId ?? this.malId,
      aniListId: aniListId ?? this.aniListId,
      status: status ?? this.status,
      altNames: altNames ?? this.altNames,
      trustedAltNames: trustedAltNames ?? this.trustedAltNames,
      description: description ?? this.description,
      prevideos: prevideos ?? this.prevideos,
      thumbnail: thumbnail ?? this.thumbnail,
      banner: banner ?? this.banner,
      thumbnails: thumbnails ?? this.thumbnails,
      musics: musics ?? this.musics,
      score: score ?? this.score,
      type: type ?? this.type,
      averageScore: averageScore ?? this.averageScore,
      genres: genres ?? this.genres,
      tags: tags ?? this.tags,
      popularity: popularity ?? this.popularity,
      airedStart: airedStart ?? this.airedStart,
      airedEnd: airedEnd ?? this.airedEnd,
      season: season ?? this.season,
      rating: rating ?? this.rating,
      broadcastInterval: broadcastInterval ?? this.broadcastInterval,
      relatedShows: relatedShows ?? this.relatedShows,
      relatedMangas: relatedMangas ?? this.relatedMangas,
      characters: characters ?? this.characters,
      determinedInterval: determinedInterval ?? this.determinedInterval,
      episodeDuration: episodeDuration ?? this.episodeDuration,
      studios: studios ?? this.studios,
      lastEpisodeDate: lastEpisodeDate ?? this.lastEpisodeDate,
      lastEpisodeTimestamp: lastEpisodeTimestamp ?? this.lastEpisodeTimestamp,
      availableEpisodes: availableEpisodes ?? this.availableEpisodes,
      availableEpisodesDetail:
          availableEpisodesDetail ?? this.availableEpisodesDetail,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'updateQueue': updateQueue,
      'isAdult': isAdult,
      'manualUpdated': manualUpdated,
      'dailyUpdateNeeded': dailyUpdateNeeded,
      'hidden': hidden,
      'lastUpdateStart': lastUpdateStart,
      'lastUpdateEnd': lastUpdateEnd,
      'name': name,
      'englishName': englishName,
      'nativeName': nativeName,
      'nameOnlyString': nameOnlyString,
      'countryOfOrigin': countryOfOrigin,
      'malId': malId,
      'aniListId': aniListId,
      'status': status,
      'altNames': altNames,
      'trustedAltNames': trustedAltNames,
      'description': description,
      'prevideos': prevideos,
      'thumbnail': thumbnail,
      'banner': banner,
      'thumbnails': thumbnails,
      'musics': musics?.map((x) => x.toMap()).toList(),
      'score': score,
      'type': type,
      'averageScore': averageScore,
      'genres': genres,
      'tags': tags,
      'popularity': popularity,
      'airedStart': airedStart?.toMap(),
      'airedEnd': airedEnd?.toMap(),
      'season': season?.toMap(),
      'rating': rating,
      'broadcastInterval': broadcastInterval,
      'relatedShows': relatedShows?.map((x) => x.toMap()).toList(),
      'relatedMangas': relatedMangas?.map((x) => x.toMap()).toList(),
      'characters': characters?.map((x) => x.toMap()).toList(),
      'determinedInterval': determinedInterval?.toMap(),
      'episodeDuration': episodeDuration,
      'studios': studios,
      'lastEpisodeDate': lastEpisodeDate?.toMap(),
      'lastEpisodeTimestamp': lastEpisodeTimestamp?.toMap(),
      'availableEpisodes': availableEpisodes?.toMap(),
      'availableEpisodesDetail': availableEpisodesDetail?.toMap(),
    };
  }

  factory AnimeModel.fromMap(Map<String, dynamic> map) {
    return AnimeModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      updateQueue: map['updateQueue'] != null
          ? map['updateQueue'] as String
          : null,
      isAdult: map['isAdult'] != null ? map['isAdult'] as bool : null,
      manualUpdated: map['manualUpdated'] != null
          ? map['manualUpdated'] as bool
          : null,
      dailyUpdateNeeded: map['dailyUpdateNeeded'] != null
          ? map['dailyUpdateNeeded'] as bool
          : null,
      hidden: map['hidden'] != null ? map['hidden'] as bool : null,
      lastUpdateStart: map['lastUpdateStart'] != null
          ? map['lastUpdateStart'] as String
          : null,
      lastUpdateEnd: map['lastUpdateEnd'] != null
          ? map['lastUpdateEnd'] as String
          : null,
      name: map['name'] != null ? map['name'] as String : null,
      englishName: map['englishName'] != null
          ? map['englishName'] as String
          : null,
      nativeName: map['nativeName'] != null
          ? map['nativeName'] as String
          : null,
      nameOnlyString: map['nameOnlyString'] != null
          ? map['nameOnlyString'] as String
          : null,
      countryOfOrigin: map['countryOfOrigin'] != null
          ? map['countryOfOrigin'] as String
          : null,
      malId: map['malId'] != null ? map['malId'] as String : null,
      aniListId: map['aniListId'] != null ? map['aniListId'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      description: map['description'] != null
          ? map['description'] as String
          : null,
      thumbnail: map['thumbnail'] != null ? map['thumbnail'] as String : null,
      banner: map['banner'] != null ? map['banner'] as String : null,
      musics: map['musics'] != null
          ? List<Music>.from(
              (map['musics'] as List<dynamic>).map<Music?>(
                (x) => Music.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      score: map['score'] != null ? map['score'] as double : null,
      type: map['type'] != null ? map['type'] as String : null,
      averageScore: map['averageScore'] != null
          ? map['averageScore'] as int
          : null,
      popularity: map['popularity'] != null
          ? map['popularity'] as String
          : null,
      airedStart: map['airedStart'] != null
          ? AiredStart.fromMap(map['airedStart'] as Map<String, dynamic>)
          : null,
      airedEnd: map['airedEnd'] != null
          ? AiredEnd.fromMap(map['airedEnd'] as Map<String, dynamic>)
          : null,
      season: map['season'] != null
          ? Season.fromMap(map['season'] as Map<String, dynamic>)
          : null,
      rating: map['rating'] != null ? map['rating'] as String : null,
      broadcastInterval: map['broadcastInterval'] != null
          ? map['broadcastInterval'] as String
          : null,
      relatedShows: map['relatedShows'] != null
          ? List<RelatedShows>.from(
              (map['relatedShows'] as List<dynamic>).map<RelatedShows?>(
                (x) => RelatedShows.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      relatedMangas: map['relatedMangas'] != null
          ? List<RelatedMangas>.from(
              (map['relatedMangas'] as List<dynamic>).map<RelatedMangas?>(
                (x) => RelatedMangas.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      characters: map['characters'] != null
          ? List<Characters>.from(
              (map['characters'] as List<dynamic>).map<Characters?>(
                (x) => Characters.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      determinedInterval: map['determinedInterval'] != null
          ? DeterminedInterval.fromMap(
              map['determinedInterval'] as Map<String, dynamic>,
            )
          : null,
      episodeDuration: map['episodeDuration'] != null
          ? map['episodeDuration'] as String
          : null,
      studios: map['studios'] != null
          ? (map['studios'] as List).cast<String>().toList()
          : null,
      lastEpisodeDate: map['lastEpisodeDate'] != null
          ? LastEpisodeDate.fromMap(
              map['lastEpisodeDate'] as Map<String, dynamic>,
            )
          : null,
      lastEpisodeTimestamp: map['lastEpisodeTimestamp'] != null
          ? LastEpisodeTimestamp.fromMap(
              map['lastEpisodeTimestamp'] as Map<String, dynamic>,
            )
          : null,
      availableEpisodes: map['availableEpisodes'] != null
          ? AvailableEpisodes.fromMap(
              map['availableEpisodes'] as Map<String, dynamic>,
            )
          : null,
      availableEpisodesDetail: map['availableEpisodesDetail'] != null
          ? AvailableEpisodesDetail.fromMap(
              map['availableEpisodesDetail'] as Map<String, dynamic>,
            )
          : null,

      thumbnails: map['thumbnails'] != null
          ? (map['thumbnails'] as List).cast<String>().toList()
          : null,
      prevideos: map['prevideos'] != null
          ? (map['prevideos'] as List).cast<String>().toList()
          : null,
      genres: map['genres'] != null 
          ? (map['genres'] as List).cast<String>().toList()
          : null,
      tags: map['tags'] != null 
        ? (map['tags'] as List).cast<String>().toList()
        : null,
      trustedAltNames: map['trustedAltNames'] != null
          ? (map['trustedAltNames'] as List).cast<String>().toList()
          : null,
      altNames: map['altNames'] != null
          ? (map['altNames'] as List).cast<String>().toList()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AnimeModel.fromJson(String source) =>
      AnimeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AnimeModel(id: $id, updateQueue: $updateQueue, isAdult: $isAdult, manualUpdated: $manualUpdated, dailyUpdateNeeded: $dailyUpdateNeeded, hidden: $hidden, lastUpdateStart: $lastUpdateStart, lastUpdateEnd: $lastUpdateEnd, name: $name, englishName: $englishName, nativeName: $nativeName, nameOnlyString: $nameOnlyString, countryOfOrigin: $countryOfOrigin, malId: $malId, aniListId: $aniListId, status: $status, altNames: $altNames, trustedAltNames: $trustedAltNames, description: $description, prevideos: $prevideos, thumbnail: $thumbnail, banner: $banner, thumbnails: $thumbnails, musics: $musics, score: $score, type: $type, averageScore: $averageScore, genres: $genres, tags: $tags, popularity: $popularity, airedStart: $airedStart, airedEnd: $airedEnd, season: $season, rating: $rating, broadcastInterval: $broadcastInterval, relatedShows: $relatedShows, relatedMangas: $relatedMangas, characters: $characters, determinedInterval: $determinedInterval, episodeDuration: $episodeDuration, studios: $studios, lastEpisodeDate: $lastEpisodeDate, lastEpisodeTimestamp: $lastEpisodeTimestamp, availableEpisodes: $availableEpisodes, availableEpisodesDetail: $availableEpisodesDetail)';
  }

  @override
  bool operator ==(covariant AnimeModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.updateQueue == updateQueue &&
        other.isAdult == isAdult &&
        other.manualUpdated == manualUpdated &&
        other.dailyUpdateNeeded == dailyUpdateNeeded &&
        other.hidden == hidden &&
        other.lastUpdateStart == lastUpdateStart &&
        other.lastUpdateEnd == lastUpdateEnd &&
        other.name == name &&
        other.englishName == englishName &&
        other.nativeName == nativeName &&
        other.nameOnlyString == nameOnlyString &&
        other.countryOfOrigin == countryOfOrigin &&
        other.malId == malId &&
        other.aniListId == aniListId &&
        other.status == status &&
        listEquals(other.altNames, altNames) &&
        listEquals(other.trustedAltNames, trustedAltNames) &&
        other.description == description &&
        listEquals(other.prevideos, prevideos) &&
        other.thumbnail == thumbnail &&
        other.banner == banner &&
        listEquals(other.thumbnails, thumbnails) &&
        listEquals(other.musics, musics) &&
        other.score == score &&
        other.type == type &&
        other.averageScore == averageScore &&
        listEquals(other.genres, genres) &&
        listEquals(other.tags, tags) &&
        other.popularity == popularity &&
        other.airedStart == airedStart &&
        other.airedEnd == airedEnd &&
        other.season == season &&
        other.rating == rating &&
        other.broadcastInterval == broadcastInterval &&
        listEquals(other.relatedShows, relatedShows) &&
        listEquals(other.relatedMangas, relatedMangas) &&
        listEquals(other.characters, characters) &&
        other.determinedInterval == determinedInterval &&
        other.episodeDuration == episodeDuration &&
        listEquals(other.studios, studios) &&
        other.lastEpisodeDate == lastEpisodeDate &&
        other.lastEpisodeTimestamp == lastEpisodeTimestamp &&
        other.availableEpisodes == availableEpisodes &&
        other.availableEpisodesDetail == availableEpisodesDetail;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        updateQueue.hashCode ^
        isAdult.hashCode ^
        manualUpdated.hashCode ^
        dailyUpdateNeeded.hashCode ^
        hidden.hashCode ^
        lastUpdateStart.hashCode ^
        lastUpdateEnd.hashCode ^
        name.hashCode ^
        englishName.hashCode ^
        nativeName.hashCode ^
        nameOnlyString.hashCode ^
        countryOfOrigin.hashCode ^
        malId.hashCode ^
        aniListId.hashCode ^
        status.hashCode ^
        altNames.hashCode ^
        trustedAltNames.hashCode ^
        description.hashCode ^
        prevideos.hashCode ^
        thumbnail.hashCode ^
        banner.hashCode ^
        thumbnails.hashCode ^
        musics.hashCode ^
        score.hashCode ^
        type.hashCode ^
        averageScore.hashCode ^
        genres.hashCode ^
        tags.hashCode ^
        popularity.hashCode ^
        airedStart.hashCode ^
        airedEnd.hashCode ^
        season.hashCode ^
        rating.hashCode ^
        broadcastInterval.hashCode ^
        relatedShows.hashCode ^
        relatedMangas.hashCode ^
        characters.hashCode ^
        determinedInterval.hashCode ^
        episodeDuration.hashCode ^
        studios.hashCode ^
        lastEpisodeDate.hashCode ^
        lastEpisodeTimestamp.hashCode ^
        availableEpisodes.hashCode ^
        availableEpisodesDetail.hashCode;
  }
}

class Music {
  final String? type;
  final String? title;
  final String? format;
  final String? musicId;
  final String? url;

  Music({this.type, this.title, this.format, this.musicId, this.url});

  Music copyWith({
    String? type,
    String? title,
    String? format,
    String? musicId,
    String? url,
  }) {
    return Music(
      type: type ?? this.type,
      title: title ?? this.title,
      format: format ?? this.format,
      musicId: musicId ?? this.musicId,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'title': title,
      'format': format,
      'musicId': musicId,
      'url': url,
    };
  }

  factory Music.fromMap(Map<String, dynamic> map) {
    return Music(
      type: map['type'] != null ? map['type'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      format: map['format'] != null ? map['format'] as String : null,
      musicId: map['musicId'] != null ? map['musicId'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Music.fromJson(String source) =>
      Music.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Music(type: $type, title: $title, format: $format, musicId: $musicId, url: $url)';
  }

  @override
  bool operator ==(covariant Music other) {
    if (identical(this, other)) return true;

    return other.type == type &&
        other.title == title &&
        other.format == format &&
        other.musicId == musicId &&
        other.url == url;
  }

  @override
  int get hashCode {
    return type.hashCode ^
        title.hashCode ^
        format.hashCode ^
        musicId.hashCode ^
        url.hashCode;
  }
}

class AiredStart {
  final int? year;
  final int? month;
  final int? date;
  final int? hour;
  final int? minute;
  AiredStart({this.year, this.month, this.date, this.hour, this.minute});

  AiredStart copyWith({
    int? year,
    int? month,
    int? date,
    int? hour,
    int? minute,
  }) {
    return AiredStart(
      year: year ?? this.year,
      month: month ?? this.month,
      date: date ?? this.date,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'year': year,
      'month': month,
      'date': date,
      'hour': hour,
      'minute': minute,
    };
  }

  factory AiredStart.fromMap(Map<String, dynamic> map) {
    return AiredStart(
      year: map['year'] != null ? (map['year'] as num).toInt() : null,
      month: map['month'] != null ? (map['month'] as num).toInt() : null,
      date: map['date'] != null ? (map['date'] as num).toInt() : null,
      hour: map['hour'] != null ? (map['hour'] as num).toInt() : null,
      minute: map['minute'] != null ? (map['minute'] as num).toInt() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AiredStart.fromJson(String source) =>
      AiredStart.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AiredStart(year: $year, month: $month, date: $date, hour: $hour, minute: $minute)';
  }

  @override
  bool operator ==(covariant AiredStart other) {
    if (identical(this, other)) return true;

    return other.year == year &&
        other.month == month &&
        other.date == date &&
        other.hour == hour &&
        other.minute == minute;
  }

  @override
  int get hashCode {
    return year.hashCode ^
        month.hashCode ^
        date.hashCode ^
        hour.hashCode ^
        minute.hashCode;
  }
}

class AiredEnd {
  final int? year;
  final int? month;
  final int? date;
  final int? hour;
  final int? minute;
  AiredEnd({this.year, this.month, this.date, this.hour, this.minute});

  AiredEnd copyWith({
    int? year,
    int? month,
    int? date,
    int? hour,
    int? minute,
  }) {
    return AiredEnd(
      year: year ?? this.year,
      month: month ?? this.month,
      date: date ?? this.date,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'year': year,
      'month': month,
      'date': date,
      'hour': hour,
      'minute': minute,
    };
  }

  factory AiredEnd.fromMap(Map<String, dynamic> map) {
    return AiredEnd(
      year: map['year'] != null ? (map['year'] as num).toInt() : null,
      month: map['month'] != null ? (map['month'] as num).toInt() : null,
      date: map['date'] != null ? (map['date'] as num).toInt() : null,
      hour: map['hour'] != null ? (map['hour'] as num).toInt() : null,
      minute: map['minute'] != null ? (map['minute'] as num).toInt() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AiredEnd.fromJson(String source) =>
      AiredEnd.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AiredStart(year: $year, month: $month, date: $date, hour: $hour, minute: $minute)';
  }

  @override
  bool operator ==(covariant AiredEnd other) {
    if (identical(this, other)) return true;

    return other.year == year &&
        other.month == month &&
        other.date == date &&
        other.hour == hour &&
        other.minute == minute;
  }

  @override
  int get hashCode {
    return year.hashCode ^
        month.hashCode ^
        date.hashCode ^
        hour.hashCode ^
        minute.hashCode;
  }
}

class Season {
  final String? quarter;
  final int? year;
  Season({this.quarter, this.year});

  Season copyWith({String? quarter, int? year}) {
    return Season(quarter: quarter ?? this.quarter, year: year ?? this.year);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'quarter': quarter, 'year': year};
  }

  factory Season.fromMap(Map<String, dynamic> map) {
    return Season(
      quarter: map['quarter'] != null ? map['quarter'] as String : null,
      year: map['year'] != null ? (map['year'] as num).toInt() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Season.fromJson(String source) =>
      Season.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Season(quarter: $quarter, year: $year)';

  @override
  bool operator ==(covariant Season other) {
    if (identical(this, other)) return true;

    return other.quarter == quarter && other.year == year;
  }

  @override
  int get hashCode => quarter.hashCode ^ year.hashCode;
}

class RelatedShows {
  final String? relation;
  final String? showId;
  RelatedShows({this.relation, this.showId});

  RelatedShows copyWith({String? relation, String? showId}) {
    return RelatedShows(
      relation: relation ?? this.relation,
      showId: showId ?? this.showId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'relation': relation, 'showId': showId};
  }

  factory RelatedShows.fromMap(Map<String, dynamic> map) {
    return RelatedShows(
      relation: map['relation'] != null ? map['relation'] as String : null,
      showId: map['showId'] != null ? map['showId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RelatedShows.fromJson(String source) =>
      RelatedShows.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'RelatedShows(relation: $relation, showId: $showId)';

  @override
  bool operator ==(covariant RelatedShows other) {
    if (identical(this, other)) return true;

    return other.relation == relation && other.showId == showId;
  }

  @override
  int get hashCode => relation.hashCode ^ showId.hashCode;
}

class RelatedMangas {
  final String? relation;
  final String? mangaId;
  RelatedMangas({this.relation, this.mangaId});

  RelatedMangas copyWith({String? relation, String? mangaId}) {
    return RelatedMangas(
      relation: relation ?? this.relation,
      mangaId: mangaId ?? this.mangaId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'relation': relation, 'mangaId': mangaId};
  }

  factory RelatedMangas.fromMap(Map<String, dynamic> map) {
    return RelatedMangas(
      relation: map['relation'] != null ? map['relation'] as String : null,
      mangaId: map['mangaId'] != null ? map['mangaId'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory RelatedMangas.fromJson(String source) =>
      RelatedMangas.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'RelatedShows(relation: $relation, mangaId: $mangaId)';

  @override
  bool operator ==(covariant RelatedMangas other) {
    if (identical(this, other)) return true;

    return other.relation == relation && other.mangaId == mangaId;
  }

  @override
  int get hashCode => relation.hashCode ^ mangaId.hashCode;
}

class Characters {
  final String? role;
  final Name? name;
  final Image? image;
  final int? aniListId;
  final List<VoiceActors>? voiceActors;

  Characters({
    this.role,
    this.name,
    this.image,
    this.aniListId,
    this.voiceActors,
  });

  Characters copyWith({
    String? role,
    Name? name,
    Image? image,
    int? aniListId,
    List<VoiceActors>? voiceActors,
  }) {
    return Characters(
      role: role ?? this.role,
      name: name ?? this.name,
      image: image ?? this.image,
      aniListId: aniListId ?? this.aniListId,
      voiceActors: voiceActors ?? this.voiceActors,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'role': role,
      'name': name?.toMap(),
      'image': image?.toMap(),
      'aniListId': aniListId,
      'voiceActors': voiceActors?.map((x) => x.toMap()).toList(),
    };
  }

  factory Characters.fromMap(Map<String, dynamic> map) {
    return Characters(
      role: map['role'] != null ? map['role'] as String : null,
      name: map['name'] != null
          ? Name.fromMap(map['name'] as Map<String, dynamic>)
          : null,
      image: map['image'] != null
          ? Image.fromMap(map['image'] as Map<String, dynamic>)
          : null,
      aniListId: map['aniListId'] != null ? map['aniListId'] as int : null,
      voiceActors: map['voiceActors'] != null
          ? List<VoiceActors>.from(
              (map['voiceActors'] as List<dynamic>).map<VoiceActors?>(
                (x) => VoiceActors.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Characters.fromJson(String source) =>
      Characters.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Characters(role: $role, name: $name, image: $image, aniListId: $aniListId, voiceActors: $voiceActors)';
  }

  @override
  bool operator ==(covariant Characters other) {
    if (identical(this, other)) return true;

    return other.role == role &&
        other.name == name &&
        other.image == image &&
        other.aniListId == aniListId &&
        listEquals(other.voiceActors, voiceActors);
  }

  @override
  int get hashCode {
    return role.hashCode ^
        name.hashCode ^
        image.hashCode ^
        aniListId.hashCode ^
        voiceActors.hashCode;
  }
}

class Name {
  final String? full;
  final String? native;

  Name({this.full, this.native});

  Name copyWith({String? full, String? native}) {
    return Name(full: full ?? this.full, native: native ?? this.native);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'full': full, 'native': native};
  }

  factory Name.fromMap(Map<String, dynamic> map) {
    return Name(
      full: map['full'] != null ? map['full'] as String : null,
      native: map['native'] != null ? map['native'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Name.fromJson(String source) =>
      Name.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Name(full: $full, native: $native)';

  @override
  bool operator ==(covariant Name other) {
    if (identical(this, other)) return true;

    return other.full == full && other.native == native;
  }

  @override
  int get hashCode => full.hashCode ^ native.hashCode;
}

class Image {
  String? large;
  String? medium;

  Image({this.large, this.medium});

  Image copyWith({String? large, String? medium}) {
    return Image(large: large ?? this.large, medium: medium ?? this.medium);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'large': large, 'medium': medium};
  }

  factory Image.fromMap(Map<String, dynamic> map) {
    return Image(
      large: map['large'] != null ? map['large'] as String : null,
      medium: map['medium'] != null ? map['medium'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Image.fromJson(String source) =>
      Image.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Image(large: $large, medium: $medium)';

  @override
  bool operator ==(covariant Image other) {
    if (identical(this, other)) return true;

    return other.large == large && other.medium == medium;
  }

  @override
  int get hashCode => large.hashCode ^ medium.hashCode;
}

class VoiceActors {
  final String? language;
  final int? aniListId;

  VoiceActors({this.language, this.aniListId});

  VoiceActors copyWith({String? language, int? aniListId}) {
    return VoiceActors(
      language: language ?? this.language,
      aniListId: aniListId ?? this.aniListId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'language': language, 'aniListId': aniListId};
  }

  factory VoiceActors.fromMap(Map<String, dynamic> map) {
    return VoiceActors(
      language: map['language'] != null ? map['language'] as String : null,
      aniListId: map['aniListId'] != null
          ? (map['aniListId'] as num).toInt()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory VoiceActors.fromJson(String source) =>
      VoiceActors.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'VoiceActors(language: $language, aniListId: $aniListId)';

  @override
  bool operator ==(covariant VoiceActors other) {
    if (identical(this, other)) return true;

    return other.language == language && other.aniListId == aniListId;
  }

  @override
  int get hashCode => language.hashCode ^ aniListId.hashCode;
}

class DeterminedInterval {
  final int? sub;
  final int? dub;
  DeterminedInterval({this.sub, this.dub});

  DeterminedInterval copyWith({int? sub, int? dub}) {
    return DeterminedInterval(sub: sub ?? this.sub, dub: dub ?? this.dub);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'sub': sub, 'dub': dub};
  }

  factory DeterminedInterval.fromMap(Map<String, dynamic> map) {
    return DeterminedInterval(
      sub: map['sub'] != null ? (map['sub'] as num).toInt() : null,
      dub: map['dub'] != null ? (map['dub'] as num).toInt() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeterminedInterval.fromJson(String source) =>
      DeterminedInterval.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DeterminedInterval(sub: $sub, dub: $dub)';

  @override
  bool operator ==(covariant DeterminedInterval other) {
    if (identical(this, other)) return true;

    return other.sub == sub && other.dub == dub;
  }

  @override
  int get hashCode => sub.hashCode ^ dub.hashCode;
}

class LastEpisodeDate {
  final Dub? dub;
  final Dub? sub;

  LastEpisodeDate({this.dub, this.sub});

  LastEpisodeDate copyWith({Dub? dub, Dub? sub}) {
    return LastEpisodeDate(dub: dub ?? this.dub, sub: sub ?? this.sub);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'dub': dub?.toMap(), 'sub': sub?.toMap()};
  }

  factory LastEpisodeDate.fromMap(Map<String, dynamic> map) {
    return LastEpisodeDate(
      dub: map['dub'] != null
          ? Dub.fromMap(map['dub'] as Map<String, dynamic>)
          : null,
      sub: map['sub'] != null
          ? Dub.fromMap(map['sub'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LastEpisodeDate.fromJson(String source) =>
      LastEpisodeDate.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LastEpisodeDate(dub: $dub, sub: $sub)';

  @override
  bool operator ==(covariant LastEpisodeDate other) {
    if (identical(this, other)) return true;

    return other.dub == dub && other.sub == sub;
  }

  @override
  int get hashCode => dub.hashCode ^ sub.hashCode;
}

class Dub {
  final int? hour;
  final int? minute;
  final int? year;
  final int? month;
  final int? date;

  Dub({this.hour, this.minute, this.year, this.month, this.date});

  Dub copyWith({int? hour, int? minute, int? year, int? month, int? date}) {
    return Dub(
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      year: year ?? this.year,
      month: month ?? this.month,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'hour': hour,
      'minute': minute,
      'year': year,
      'month': month,
      'date': date,
    };
  }

  factory Dub.fromMap(Map<String, dynamic> map) {
    return Dub(
      hour: map['hour'] != null ? map['hour'] as int : null,
      minute: map['minute'] != null ? map['minute'] as int : null,
      year: map['year'] != null ? map['year'] as int : null,
      month: map['month'] != null ? map['month'] as int : null,
      date: map['date'] != null ? map['date'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Dub.fromJson(String source) =>
      Dub.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Dub(hour: $hour, minute: $minute, year: $year, month: $month, date: $date)';
  }

  @override
  bool operator ==(covariant Dub other) {
    if (identical(this, other)) return true;

    return other.hour == hour &&
        other.minute == minute &&
        other.year == year &&
        other.month == month &&
        other.date == date;
  }

  @override
  int get hashCode {
    return hour.hashCode ^
        minute.hashCode ^
        year.hashCode ^
        month.hashCode ^
        date.hashCode;
  }
}

class LastEpisodeTimestamp {
  final int? sub;
  final int? dub;
  final int? raw;

  LastEpisodeTimestamp({this.sub, this.dub, this.raw});

  LastEpisodeTimestamp copyWith({int? sub, int? dub, int? raw}) {
    return LastEpisodeTimestamp(
      sub: sub ?? this.sub,
      dub: dub ?? this.dub,
      raw: raw ?? this.raw,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'sub': sub, 'dub': dub, 'raw': raw};
  }

  factory LastEpisodeTimestamp.fromMap(Map<String, dynamic> map) {
    return LastEpisodeTimestamp(
      sub: map['sub'] != null ? (map['sub'] as num).toInt() : null,
      dub: map['dub'] != null ? (map['dub'] as num).toInt() : null,
      raw: map['raw'] != null ? (map['raw'] as num).toInt() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LastEpisodeTimestamp.fromJson(String source) =>
      LastEpisodeTimestamp.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LastEpisodeTimestamp(sub: $sub, dub: $dub, raw: $raw)';

  @override
  bool operator ==(covariant LastEpisodeTimestamp other) {
    if (identical(this, other)) return true;

    return other.sub == sub && other.dub == dub && other.raw == raw;
  }

  @override
  int get hashCode => sub.hashCode ^ dub.hashCode ^ raw.hashCode;
}

class LastEpisodeInfo {
  Sub? sub;
  Sub? dub;
  Sub? raw;

  LastEpisodeInfo({this.sub, this.dub, this.raw});

  LastEpisodeInfo copyWith({Sub? sub, Sub? dub, Sub? raw}) {
    return LastEpisodeInfo(
      sub: sub ?? this.sub,
      dub: dub ?? this.dub,
      raw: raw ?? this.raw,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sub': sub?.toMap(),
      'dub': dub?.toMap(),
      'raw': raw?.toMap(),
    };
  }

  factory LastEpisodeInfo.fromMap(Map<String, dynamic> map) {
    return LastEpisodeInfo(
      sub: map['sub'] != null
          ? Sub.fromMap(map['sub'] as Map<String, dynamic>)
          : null,
      dub: map['dub'] != null
          ? Sub.fromMap(map['dub'] as Map<String, dynamic>)
          : null,
      raw: map['raw'] != null
          ? Sub.fromMap(map['raw'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LastEpisodeInfo.fromJson(String source) =>
      LastEpisodeInfo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'LastEpisodeInfo(sub: $sub, dub: $dub, raw: $raw)';

  @override
  bool operator ==(covariant LastEpisodeInfo other) {
    if (identical(this, other)) return true;

    return other.sub == sub && other.dub == dub && other.raw == raw;
  }

  @override
  int get hashCode => sub.hashCode ^ dub.hashCode ^ raw.hashCode;
}

class Sub {
  String? episodeString;
  Sub({this.episodeString});

  Sub copyWith({String? episodeString}) {
    return Sub(episodeString: episodeString ?? this.episodeString);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'episodeString': episodeString};
  }

  factory Sub.fromMap(Map<String, dynamic> map) {
    return Sub(
      episodeString: map['episodeString'] != null
          ? map['episodeString'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Sub.fromJson(String source) =>
      Sub.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Sub(episodeString: $episodeString)';

  @override
  bool operator ==(covariant Sub other) {
    if (identical(this, other)) return true;

    return other.episodeString == episodeString;
  }

  @override
  int get hashCode => episodeString.hashCode;
}

class AvailableEpisodes {
  final int? sub;
  final int? dub;
  final int? raw;
  AvailableEpisodes({this.sub, this.dub, this.raw});

  AvailableEpisodes copyWith({int? sub, int? dub, int? raw}) {
    return AvailableEpisodes(
      sub: sub ?? this.sub,
      dub: dub ?? this.dub,
      raw: raw ?? this.raw,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'sub': sub, 'dub': dub, 'raw': raw};
  }

  factory AvailableEpisodes.fromMap(Map<String, dynamic> map) {
    return AvailableEpisodes(
      sub: map['sub'] != null ? (map['sub'] as num).toInt() : null,
      dub: map['dub'] != null ? (map['dub'] as num).toInt() : null,
      raw: map['raw'] != null ? (map['raw'] as num).toInt() : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AvailableEpisodes.fromJson(String source) =>
      AvailableEpisodes.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AvailableEpisodes(sub: $sub, dub: $dub, raw: $raw)';

  @override
  bool operator ==(covariant AvailableEpisodes other) {
    if (identical(this, other)) return true;

    return other.sub == sub && other.dub == dub && other.raw == raw;
  }

  @override
  int get hashCode => sub.hashCode ^ dub.hashCode ^ raw.hashCode;
}

class AvailableEpisodesDetail {
  final List<String>? sub;
  final List<String>? dub;
  final List<String>? raw;

  AvailableEpisodesDetail({this.sub, this.dub, this.raw});

  AvailableEpisodesDetail copyWith({
    List<String>? sub,
    List<String>? dub,
    List<String>? raw,
  }) {
    return AvailableEpisodesDetail(
      sub: sub ?? this.sub,
      dub: dub ?? this.dub,
      raw: raw ?? this.raw,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'sub': sub, 'dub': dub, 'raw': raw};
  }

  factory AvailableEpisodesDetail.fromMap(Map<String, dynamic> map) {
    return AvailableEpisodesDetail(
      sub: map['sub'] != null
          ? (map['sub'] as List).cast<String>().toList()
          : null,
      dub: map['dub'] != null
          ? (map['dub'] as List).cast<String>().toList()
          : null,
      raw: map['raw'] != null
          ? (map['raw'] as List).cast<String>().toList()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AvailableEpisodesDetail.fromJson(String source) =>
      AvailableEpisodesDetail.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  String toString() =>
      'AvailableEpisodesDetail(sub: $sub, dub: $dub, raw: $raw)';

  @override
  bool operator ==(covariant AvailableEpisodesDetail other) {
    if (identical(this, other)) return true;

    return listEquals(other.sub, sub) &&
        listEquals(other.dub, dub) &&
        listEquals(other.raw, raw);
  }

  @override
  int get hashCode => sub.hashCode ^ dub.hashCode ^ raw.hashCode;
}
