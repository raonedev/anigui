import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/anime_home_card.dart';
import '../models/anime_model.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;
  factory DbHelper() => _instance;
  DbHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Initialize database and create tables
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'anime_app.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  /// Create all necessary tables
  /// Tables:
  /// 1. anime_cards - Stores anime data by type (TV, OVA, Movie, Special, ONA)
  /// 2. anime_details - Stores complete anime detail information
  /// 3. search_history - Stores user search keywords
  Future<void> _onCreate(Database db, int version) async {
    // Table for anime cards (TV, OVA, Movie, Special, ONA)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS anime_cards (
        id TEXT PRIMARY KEY,
        englishName TEXT,
        thumbnail TEXT,
        score REAL,
        type TEXT NOT NULL,
        genres TEXT,
        tags TEXT,
        episodeDuration TEXT,
        episodeCount TEXT,
        status TEXT,
        typename TEXT,
        createdAt INTEGER DEFAULT (cast(strftime('%s','now') as int))
      )
    ''');
    // Create index for type queries (frequently used)
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_anime_cards_type 
      ON anime_cards(type)
    ''');

    // Create index for search queries
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_anime_cards_englishName 
      ON anime_cards(englishName)
    ''');

    // Table for anime details (complete information)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS anime_details (
        id TEXT PRIMARY KEY,
        updateQueue TEXT,
        isAdult INTEGER,
        manualUpdated INTEGER,
        dailyUpdateNeeded INTEGER,
        hidden INTEGER,
        lastUpdateStart TEXT,
        lastUpdateEnd TEXT,
        name TEXT,
        englishName TEXT,
        nativeName TEXT,
        nameOnlyString TEXT,
        countryOfOrigin TEXT,
        malId TEXT,
        aniListId TEXT,
        status TEXT,
        description TEXT,
        thumbnail TEXT,
        banner TEXT,
        musics TEXT,
        score REAL,
        type TEXT,
        averageScore INTEGER,
        popularity TEXT,
        airedStart TEXT,
        airedEnd TEXT,
        season TEXT,
        rating TEXT,
        broadcastInterval TEXT,
        relatedShows TEXT,
        relatedMangas TEXT,
        characters TEXT,
        determinedInterval TEXT,
        episodeDuration TEXT,
        studios TEXT,
        lastEpisodeDate TEXT,
        lastEpisodeTimestamp TEXT,
        availableEpisodes TEXT,
        availableEpisodesDetail TEXT,
        thumbnails TEXT,
        prevideos TEXT,
        genres TEXT,
        tags TEXT,
        trustedAltNames TEXT,
        altNames TEXT,
        createdAt INTEGER DEFAULT (cast(strftime('%s','now') as int)),
        updatedAt INTEGER DEFAULT (cast(strftime('%s','now') as int))
      )
    ''');

    // Create index for anime details
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_anime_details_id 
      ON anime_details(id)
    ''');

    // Table for search history (user search keywords)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS search_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        keyword TEXT NOT NULL UNIQUE,
        searchCount INTEGER DEFAULT 1,
        lastSearched INTEGER DEFAULT (cast(strftime('%s','now') as int))
      )
    ''');

    // Create index for search history
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_search_history_keyword 
      ON search_history(keyword)
    ''');

    // Create index for sorting by recency
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_search_history_lastSearched 
      ON search_history(lastSearched DESC)
    ''');
  }

  // ==================== ANIME CARDS OPERATIONS ====================

  /// Insert or update anime card
  /// If anime already exists, it will be updated
  Future<int> insertAnimeCard(AnimeHomeCard animeCard) async {
    final db = await database;
    return await db.insert('anime_cards', {
      'id': animeCard.id,
      'englishName': animeCard.englishName,
      'thumbnail': animeCard.thumbnail,
      'score': animeCard.score,
      'type': animeCard.type,
      'genres': animeCard.genres?.join(','),
      'tags': animeCard.tags?.join(','),
      'episodeDuration': animeCard.episodeDuration,
      'episodeCount': animeCard.episodeCount,
      'status': animeCard.status,
      'typename': animeCard.typename,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Batch insert anime cards (efficient for inserting multiple items)
  Future<void> insertAnimeCardsBatch(List<AnimeHomeCard> animeCards) async {
    final db = await database;
    final batch = db.batch();

    for (var animeCard in animeCards) {
      batch.insert('anime_cards', {
        'id': animeCard.id,
        'englishName': animeCard.englishName,
        'thumbnail': animeCard.thumbnail,
        'score': animeCard.score,
        'type': animeCard.type,
        'genres': animeCard.genres?.join(','),
        'tags': animeCard.tags?.join(','),
        'episodeDuration': animeCard.episodeDuration,
        'episodeCount': animeCard.episodeCount,
        'status': animeCard.status,
        'typename': animeCard.typename,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    await batch.commit(noResult: true);
  }

  /// Get all anime cards by type
  Future<List<AnimeHomeCard>> getAnimeCardsByType(String type) async {
    final db = await database;

    // Query the database for all cards of the specified type
    final List<Map<String, dynamic>> maps = await db.query(
      'anime_cards',
      where: 'type = ?',
      whereArgs: [type],
      orderBy:
          'createdAt DESC', // Optional: Order by creation time (newest first)
    );

    // Convert each map to an AnimeHomeCard object
    return List.generate(maps.length, (i) {
      final map = maps[i];

      // Helper function to safely split string into list
      List<String> splitStringToList(String? value) {
        if (value == null || value.isEmpty) return [];
        return value.split(',');
      }

      return AnimeHomeCard(
        id: map['id'],
        englishName: map['englishName'],
        thumbnail: map['thumbnail'],
        score: map['score'],
        type: map['type'],
        genres: splitStringToList(map['genres']),
        tags: splitStringToList(map['tags']),
        episodeDuration: map['episodeDuration'],
        episodeCount: map['episodeCount'],
        status: map['status'],
        typename: map['typename'],
      );
    });
  }

  /// Get all anime cards (all types)
  Future<List<AnimeHomeCard>> getAllAnimeCards() async {
    final db = await database;

    // Query the database for all anime cards
    final List<Map<String, dynamic>> maps = await db.query(
      'anime_cards',
      orderBy: 'createdAt DESC', // Order by creation time (newest first)
    );

    // Convert each map to an AnimeHomeCard object
    return List.generate(maps.length, (i) {
      final map = maps[i];

      // Helper function to safely split string into list
      List<String> splitStringToList(String? value) {
        if (value == null || value.isEmpty) return [];
        return value.split(',');
      }

      return AnimeHomeCard(
        id: map['id'],
        englishName: map['englishName'],
        thumbnail: map['thumbnail'],
        score: map['score'],
        type: map['type'],
        genres: splitStringToList(map['genres']),
        tags: splitStringToList(map['tags']),
        episodeDuration: map['episodeDuration'],
        episodeCount: map['episodeCount'],
        status: map['status'],
        typename: map['typename'],
      );
    });
  }

  Future<AnimeHomeCard?> getAnimeCardById(String id) async {
    final db = await database;

    // Query the database for the specific anime card
    final List<Map<String, dynamic>> maps = await db.query(
      'anime_cards',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null; // Return null if no card found
    }

    // Convert the map to an AnimeHomeCard object
    final map = maps.first;

    // Helper function to safely split string into list
    List<String> splitStringToList(String? value) {
      if (value == null || value.isEmpty) return [];
      return value.split(',');
    }

    return AnimeHomeCard(
      id: map['id'],
      englishName: map['englishName'],
      thumbnail: map['thumbnail'],
      score: map['score'],
      type: map['type'],
      genres: splitStringToList(map['genres']),
      tags: splitStringToList(map['tags']),
      episodeDuration: map['episodeDuration'],
      episodeCount: map['episodeCount'],
      status: map['status'],
      typename: map['typename'],
    );
  }

  /// Search anime cards by name
  Future<List<AnimeHomeCard>> searchAnimeCards(String query) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'anime_cards',
      where: 'englishName LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'score DESC',
      limit: 20,
    );

    // Convert each map to an AnimeHomeCard object
    return List.generate(maps.length, (i) {
      final map = maps[i];

      // Helper function to safely split string into list
      List<String> splitStringToList(String? value) {
        if (value == null || value.isEmpty) return [];
        return value.split(',');
      }

      return AnimeHomeCard(
        id: map['id'],
        englishName: map['englishName'],
        thumbnail: map['thumbnail'],
        score: map['score'],
        type: map['type'],
        genres: splitStringToList(map['genres']),
        tags: splitStringToList(map['tags']),
        episodeDuration: map['episodeDuration'],
        episodeCount: map['episodeCount'],
        status: map['status'],
        typename: map['typename'],
      );
    });
  }

  /// Delete all anime cards of a specific type
  Future<int> deleteAnimeCardsByType(String type) async {
    final db = await database;
    return await db.delete('anime_cards', where: 'type = ?', whereArgs: [type]);
  }

  /// Clear all anime cards
  Future<int> clearAllAnimeCards() async {
    final db = await database;
    return await db.delete('anime_cards');
  }

  // ==================== ANIME DETAILS OPERATIONS ====================

  /// Insert or update anime detail
  /// Stores complete anime information with nested data as JSON strings
  Future<int> insertAnimeDetail(AnimeModel animeModel) async {
    final db = await database;

    // Prepare data for insertion - convert lists to comma-separated strings
    final data = <String, dynamic>{
      'id': animeModel.id,
      'updateQueue': animeModel.updateQueue,
      'isAdult': animeModel.isAdult,
      'manualUpdated': animeModel.manualUpdated,
      'dailyUpdateNeeded': animeModel.dailyUpdateNeeded,
      'hidden': animeModel.hidden,
      'lastUpdateStart': animeModel.lastUpdateStart,
      'lastUpdateEnd': animeModel.lastUpdateEnd,
      'name': animeModel.name,
      'englishName': animeModel.englishName,
      'nativeName': animeModel.nativeName,
      'nameOnlyString': animeModel.nameOnlyString,
      'countryOfOrigin': animeModel.countryOfOrigin,
      'malId': animeModel.malId,
      'aniListId': animeModel.aniListId,
      'status': animeModel.status,
      'altNames': animeModel.altNames?.join(','),
      'trustedAltNames': animeModel.trustedAltNames?.join(','),
      'description': animeModel.description,
      'prevideos': animeModel.prevideos?.join(','),
      'thumbnail': animeModel.thumbnail,
      'banner': animeModel.banner,
      'thumbnails': animeModel.thumbnails?.join(','),
      'musics': animeModel.musics?.map((m) => m.toJson()).toList().toString(),
      'score': animeModel.score,
      'type': animeModel.type,
      'averageScore': animeModel.averageScore,
      'genres': animeModel.genres?.join(','),
      'tags': animeModel.tags?.join(','),
      'popularity': animeModel.popularity,
      'airedStart': animeModel.airedStart?.toJson(),
      'airedEnd': animeModel.airedEnd?.toJson(),
      'season': animeModel.season?.toJson(),
      'rating': animeModel.rating,
      'broadcastInterval': animeModel.broadcastInterval,
      'relatedShows': animeModel.relatedShows
          ?.map((r) => r.toJson())
          .toList()
          .toString(),
      'relatedMangas': animeModel.relatedMangas
          ?.map((r) => r.toJson())
          .toList()
          .toString(),
      'characters': animeModel.characters
          ?.map((c) => c.toJson())
          .toList()
          .toString(),
      'determinedInterval': animeModel.determinedInterval?.toJson(),
      'episodeDuration': animeModel.episodeDuration,
      'studios': animeModel.studios?.join(','),
      'lastEpisodeDate': animeModel.lastEpisodeDate?.toJson(),
      'lastEpisodeTimestamp': animeModel.lastEpisodeTimestamp?.toJson(),
      'availableEpisodes': animeModel.availableEpisodes?.toJson(),
      'availableEpisodesDetail': animeModel.availableEpisodesDetail?.toJson(),
    };

    return await db.insert(
      'anime_details',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get anime detail by ID
  Future<AnimeModel?> getAnimeDetail(String id) async {
    final db = await database;
    final result = await db.query(
      'anime_details',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;

    final map = result.first;

    // Helper function to safely split string into list
    List<String> splitStringToList(String? value) {
      if (value == null || value.isEmpty) return [];
      return value.split(',');
    }

    // Helper function to safely parse JSON string
    T? parseJson<T>(String? value) {
      if (value == null || value.isEmpty) return null;
      try {
        return jsonDecode(value) as T;
      } catch (e) {
        return null;
      }
    }

    // Helper function to parse list of objects from JSON
    List<T>? parseListFromJson<T>(
      String? value,
      T Function(Map<String, dynamic>) fromMap,
    ) {
      if (value == null || value.isEmpty) return null;
      try {
        final list = jsonDecode(value) as List;
        return list
            .map((item) => fromMap(item as Map<String, dynamic>))
            .toList();
      } catch (e) {
        return null;
      }
    }

    return AnimeModel(
      id: map['id'] as String?,
      updateQueue: map['updateQueue'] as String?,
      isAdult: (map['isAdult'] as int?) == 1,
      manualUpdated: map['manualUpdated'] as bool?,
      dailyUpdateNeeded: map['dailyUpdateNeeded'] as bool?,
      hidden: map['hidden'] as bool?,
      lastUpdateStart: map['lastUpdateStart'] as String?,
      lastUpdateEnd: map['lastUpdateEnd'] as String?,
      name: map['name'] as String?,
      englishName: map['englishName'] as String?,
      nativeName: map['nativeName'] as String?,
      nameOnlyString: map['nameOnlyString'] as String?,
      countryOfOrigin: map['countryOfOrigin'] as String?,
      malId: map['malId'] as String?,
      aniListId: map['aniListId'] as String?,
      status: map['status'] as String?,
      altNames: splitStringToList(map['altNames'] as String?),
      trustedAltNames: splitStringToList(map['trustedAltNames'] as String?),
      description: map['description'] as String?,
      prevideos: splitStringToList(map['prevideos'] as String?),
      thumbnail: map['thumbnail'] as String?,
      banner: map['banner'] as String?,
      thumbnails: splitStringToList(map['thumbnails'] as String?),
      musics: parseListFromJson(
        map['musics'] as String?,
        (m) => Music.fromMap(m),
      ),
      score: map['score'] as double?,
      type: map['type'] as String?,
      averageScore: map['averageScore'] as int?,
      genres: splitStringToList(map['genres'] as String?),
      tags: splitStringToList(map['tags'] as String?),
      popularity: map['popularity'] as String?,
      airedStart: parseJson(map['airedStart'] as String?) != null
          ? AiredStart.fromMap(
              parseJson(map['airedStart'] as String?) as Map<String, dynamic>,
            )
          : null,
      airedEnd: parseJson(map['airedEnd'] as String?) != null
          ? AiredEnd.fromMap(
              parseJson(map['airedEnd'] as String?) as Map<String, dynamic>,
            )
          : null,
      season: parseJson(map['season'] as String?) != null
          ? Season.fromMap(
              parseJson(map['season'] as String?) as Map<String, dynamic>,
            )
          : null,
      rating: map['rating'] as String?,
      broadcastInterval: map['broadcastInterval'] as String?,
      relatedShows: parseListFromJson(
        map['relatedShows'] as String?,
        (r) => RelatedShows.fromMap(r),
      ),
      relatedMangas: parseListFromJson(
        map['relatedMangas'] as String?,
        (r) => RelatedMangas.fromMap(r),
      ),
      characters: parseListFromJson(
        map['characters'] as String?,
        (c) => Characters.fromMap(c),
      ),
      determinedInterval:
          parseJson(map['determinedInterval'] as String?) != null
          ? DeterminedInterval.fromMap(
              parseJson(map['determinedInterval'] as String?)
                  as Map<String, dynamic>,
            )
          : null,
      episodeDuration: map['episodeDuration'] as String?,
      studios: splitStringToList(map['studios'] as String?),
      lastEpisodeDate: parseJson(map['lastEpisodeDate'] as String?) != null
          ? LastEpisodeDate.fromMap(
              parseJson(map['lastEpisodeDate'] as String?)
                  as Map<String, dynamic>,
            )
          : null,
      lastEpisodeTimestamp:
          parseJson(map['lastEpisodeTimestamp'] as String?) != null
          ? LastEpisodeTimestamp.fromMap(
              parseJson(map['lastEpisodeTimestamp'] as String?)
                  as Map<String, dynamic>,
            )
          : null,
      availableEpisodes: parseJson(map['availableEpisodes'] as String?) != null
          ? AvailableEpisodes.fromMap(
              parseJson(map['availableEpisodes'] as String?)
                  as Map<String, dynamic>,
            )
          : null,
      availableEpisodesDetail:
          parseJson(map['availableEpisodesDetail'] as String?) != null
          ? AvailableEpisodesDetail.fromMap(
              parseJson(map['availableEpisodesDetail'] as String?)
                  as Map<String, dynamic>,
            )
          : null,
    );
  }

  /// Delete anime detail
  Future<int> deleteAnimeDetail(String id) async {
    final db = await database;
    return await db.delete('anime_details', where: 'id = ?', whereArgs: [id]);
  }

  /// Clear all anime details
  Future<int> clearAllAnimeDetails() async {
    final db = await database;
    return await db.delete('anime_details');
  }
}
