// data/datasources/local/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/anime_home_card.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('anime.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE anime_cards (
        id TEXT PRIMARY KEY,
        englishName TEXT,
        thumbnail TEXT,
        score REAL,
        type TEXT,
        genres TEXT,
        tags TEXT,
        episodeDuration TEXT,
        episodeCount TEXT,
        status TEXT,
        typename TEXT
      )
    ''');
  }

  Future<void> insertAnimeCards(List<AnimeHomeCard> animeCards) async {
    final db = await database;
    final batch = db.batch();
    for (var anime in animeCards) {
      batch.insert(
        'anime_cards',
        {
          'id': anime.id,
          'englishName': anime.englishName,
          'thumbnail': anime.thumbnail,
          'score': anime.score,
          'type': anime.type,
          'genres': anime.genres?.join(','),
          'tags': anime.tags?.join(','),
          'episodeDuration': anime.episodeDuration,
          'episodeCount': anime.episodeCount,
          'status': anime.status,
          'typename': anime.typename,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<List<AnimeHomeCard>> getAnimeCards() async {
    final db = await database;
    final maps = await db.query('anime_cards');
    return maps.map((map) => AnimeHomeCard(
          id: map['id'] as String?,
          englishName: map['englishName'] as String?,
          thumbnail: map['thumbnail'] as String?,
          score: map['score'] as num?,
          type: map['type'] as String?,
          genres: (map['genres'] as String?)?.split(','),
          tags: (map['tags'] as String?)?.split(','),
          episodeDuration: map['episodeDuration'] as String?,
          episodeCount: map['episodeCount'] as String?,
          status: map['status'] as String?,
          typename: map['typename'] as String?,
        )).toList();
  }

  Future<void> clearAnimeCards() async {
    final db = await database;
    await db.delete('anime_cards');
  }
}