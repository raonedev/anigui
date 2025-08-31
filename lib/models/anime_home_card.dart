import 'dart:convert';

/// _id : "AyKeQpxN9W6kytvZp"
/// englishName : "HAIGAKURA"
/// thumbnail : "https://s4.anilist.co/file/anilistcdn/media/anime/cover/large/bx168537-pytXEirHtk3M.jpg"
/// score : 5.58
/// type : "TV"
/// genres : ["Action","Adventure","Fantasy","Josei","Magic"]
/// tags : ["Josei","Gods","Magic"]
/// episodeDuration : "1380000"
/// episodeCount : "13"
/// status : "Releasing"
/// __typename : "Show"

AnimeHomeCard animeHomeCardFromJson(String str) => AnimeHomeCard.fromJson(json.decode(str));

String animeHomeCardToJson(AnimeHomeCard data) => json.encode(data.toJson());

class AnimeHomeCard {
  AnimeHomeCard({
    String? id,
    String? englishName,
    String? thumbnail,
    num? score,
    String? type,
    List<String>? genres,
    List<String>? tags,
    String? episodeDuration,
    String? episodeCount,
    String? status,
    String? typename,
  }) {
    _id = id;
    _englishName = englishName;
    _thumbnail = thumbnail;
    _score = score;
    _type = type;
    _genres = genres;
    _tags = tags;
    _episodeDuration = episodeDuration;
    _episodeCount = episodeCount;
    _status = status;
    _typename = typename;
  }

  AnimeHomeCard.fromJson(dynamic json) {
    _id = json['_id'];
    _englishName =json['englishName'] ?? json['name'];
    _thumbnail = json['thumbnail'];
    _score = json['score'];
    _type = json['type'];
    _genres = json['genres'] != null ? json['genres'].cast<String>() : [];
    _tags = json['tags'] != null ? json['tags'].cast<String>() : [];
    _episodeDuration = json['episodeDuration'];
    _episodeCount = json['episodeCount'];
    _status = json['status'];
    _typename = json['__typename'];
  }

  String? _id;
  String? _englishName;
  String? _thumbnail;
  num? _score;
  String? _type;
  List<String>? _genres;
  List<String>? _tags;
  String? _episodeDuration;
  String? _episodeCount;
  String? _status;
  String? _typename;

  AnimeHomeCard copyWith({
    String? id,
    String? englishName,
    String? thumbnail,
    num? score,
    String? type,
    List<String>? genres,
    List<String>? tags,
    String? episodeDuration,
    String? episodeCount,
    String? status,
    String? typename,
  }) => AnimeHomeCard(
    id: id ?? _id,
    englishName: englishName ?? _englishName,
    thumbnail: thumbnail ?? _thumbnail,
    score: score ?? _score,
    type: type ?? _type,
    genres: genres ?? _genres,
    tags: tags ?? _tags,
    episodeDuration: episodeDuration ?? _episodeDuration,
    episodeCount: episodeCount ?? _episodeCount,
    status: status ?? _status,
    typename: typename ?? _typename,
  );

  String? get id => _id;

  String? get englishName => _englishName;

  String? get thumbnail => _thumbnail;

  num? get score => _score;

  String? get type => _type;

  List<String>? get genres => _genres;

  List<String>? get tags => _tags;

  String? get episodeDuration => _episodeDuration;

  String? get episodeCount => _episodeCount;

  String? get status => _status;

  String? get typename => _typename;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['_id'] = _id;
    map['englishName'] = _englishName;
    map['thumbnail'] = _thumbnail;
    map['score'] = _score;
    map['type'] = _type;
    map['genres'] = _genres;
    map['tags'] = _tags;
    map['episodeDuration'] = _episodeDuration;
    map['episodeCount'] = _episodeCount;
    map['status'] = _status;
    map['__typename'] = _typename;
    return map;
  }
}
