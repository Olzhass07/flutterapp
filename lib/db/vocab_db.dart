import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VocabDb {
  VocabDb._();
  static final VocabDb instance = VocabDb._();

  Database? _db;

  Future<Database> get database async {
    if (kIsWeb) {
      throw StateError('DB not used on web');
    }
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    // Mobile/desktop path (sqflite). Web is handled via SharedPreferences below.
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/vocab.db';
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE vocab (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_token TEXT,
            word TEXT NOT NULL,
            ru TEXT,
            kk TEXT,
            created_at INTEGER
          )
        ''');
        await db.execute('CREATE INDEX IF NOT EXISTS idx_vocab_user ON vocab(user_token)');
        await db.execute('''
          CREATE TABLE flashcard_stats (
            user_token TEXT NOT NULL,
            word TEXT NOT NULL,
            left_count INTEGER NOT NULL DEFAULT 0,
            right_count INTEGER NOT NULL DEFAULT 0,
            wrong_streak INTEGER NOT NULL DEFAULT 0,
            last_seen INTEGER,
            next_review_at INTEGER,
            PRIMARY KEY (user_token, word)
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS flashcard_stats (
              user_token TEXT NOT NULL,
              word TEXT NOT NULL,
              left_count INTEGER NOT NULL DEFAULT 0,
              right_count INTEGER NOT NULL DEFAULT 0,
              wrong_streak INTEGER NOT NULL DEFAULT 0,
              last_seen INTEGER,
              next_review_at INTEGER,
              PRIMARY KEY (user_token, word)
            )
          ''');
        }
      },
    );
  }

  Future<int> insertEntry({
    required String userToken,
    required String word,
    required String ru,
    required String kk,
  }) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final key = 'vocab_$userToken';
      final raw = prefs.getString(key);
      final List list = raw == null ? [] : (jsonDecode(raw) as List);
      final int id = DateTime.now().microsecondsSinceEpoch;
      final item = {
        'id': id,
        'user_token': userToken,
        'word': word,
        'ru': ru,
        'kk': kk,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      };
      list.add(item);
      await prefs.setString(key, jsonEncode(list));
      return id;
    } else {
      final db = await database;
      return db.insert('vocab', {
        'user_token': userToken,
        'word': word,
        'ru': ru,
        'kk': kk,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchEntries(String userToken) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final key = 'vocab_$userToken';
      final raw = prefs.getString(key);
      final List list = raw == null ? [] : (jsonDecode(raw) as List);
      list.sort((a, b) => (b['created_at'] as int).compareTo(a['created_at'] as int));
      return List<Map<String, dynamic>>.from(list);
    } else {
      final db = await database;
      return db.query(
        'vocab',
        where: 'user_token = ?',
        whereArgs: [userToken],
        orderBy: 'created_at DESC',
      );
    }
  }

  Future<int> deleteEntry(int id) async {
    if (kIsWeb) {
      // We don't know userToken here; scan all keys starting with vocab_
      final prefs = await SharedPreferences.getInstance();
      for (final key in prefs.getKeys()) {
        if (!key.startsWith('vocab_')) continue;
        final raw = prefs.getString(key);
        if (raw == null) continue;
        final List list = jsonDecode(raw) as List;
        final newList = list.where((e) => e['id'] != id).toList();
        if (newList.length != list.length) {
          await prefs.setString(key, jsonEncode(newList));
          return 1;
        }
      }
      return 0;
    } else {
      final db = await database;
      return db.delete('vocab', where: 'id = ?', whereArgs: [id]);
    }
  }

  Future<Map<String, Map<String, dynamic>>> fetchFlashcardStats(
    String userToken,
    Iterable<String> words,
  ) async {
    final normalized = words
        .map((w) => w.trim().toLowerCase())
        .where((w) => w.isNotEmpty)
        .toSet()
        .toList();
    if (normalized.isEmpty) return {};

    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final key = 'flash_stats_$userToken';
      final raw = prefs.getString(key);
      final Map<String, dynamic> map =
          raw == null ? {} : Map<String, dynamic>.from(jsonDecode(raw) as Map);
      final out = <String, Map<String, dynamic>>{};
      for (final w in normalized) {
        final v = map[w];
        if (v is Map) {
          out[w] = Map<String, dynamic>.from(v);
        }
      }
      return out;
    } else {
      final db = await database;
      final placeholders = List.filled(normalized.length, '?').join(',');
      final rows = await db.query(
        'flashcard_stats',
        where: 'user_token = ? AND word IN ($placeholders)',
        whereArgs: [userToken, ...normalized],
      );
      final out = <String, Map<String, dynamic>>{};
      for (final r in rows) {
        final word = (r['word'] ?? '').toString();
        if (word.isNotEmpty) out[word] = r;
      }
      return out;
    }
  }

  Future<void> recordFlashcardResult({
    required String userToken,
    required String word,
    required bool knew,
  }) async {
    final normalized = word.trim().toLowerCase();
    if (normalized.isEmpty) return;
    final now = DateTime.now().millisecondsSinceEpoch;

    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final key = 'flash_stats_$userToken';
      final raw = prefs.getString(key);
      final Map<String, dynamic> map =
          raw == null ? {} : Map<String, dynamic>.from(jsonDecode(raw) as Map);
      final current = map[normalized] is Map
          ? Map<String, dynamic>.from(map[normalized] as Map)
          : <String, dynamic>{};

      final left = _asInt(current['left_count']);
      final right = _asInt(current['right_count']);
      final streak = _asInt(current['wrong_streak']);
      int nextReviewAt;
      int nextStreak;
      int nextLeft = left;
      int nextRight = right;

      if (knew) {
        nextRight += 1;
        nextStreak = 0;
        final gapMinutes = (right + 1) * 60;
        nextReviewAt = now + Duration(minutes: gapMinutes).inMilliseconds;
      } else {
        nextLeft += 1;
        nextStreak = streak + 1;
        final gapMinutes = (10 - (nextStreak * 2)).clamp(2, 10).toInt();
        nextReviewAt = now + Duration(minutes: gapMinutes).inMilliseconds;
      }

      map[normalized] = {
        'user_token': userToken,
        'word': normalized,
        'left_count': nextLeft,
        'right_count': nextRight,
        'wrong_streak': nextStreak,
        'last_seen': now,
        'next_review_at': nextReviewAt,
      };
      await prefs.setString(key, jsonEncode(map));
      return;
    }

    final db = await database;
    final existing = await db.query(
      'flashcard_stats',
      where: 'user_token = ? AND word = ?',
      whereArgs: [userToken, normalized],
      limit: 1,
    );
    final row = existing.isEmpty ? <String, dynamic>{} : existing.first;

    final left = _asInt(row['left_count']);
    final right = _asInt(row['right_count']);
    final streak = _asInt(row['wrong_streak']);
    int nextReviewAt;
    int nextStreak;
    int nextLeft = left;
    int nextRight = right;

    if (knew) {
      nextRight += 1;
      nextStreak = 0;
      final gapMinutes = (right + 1) * 60;
      nextReviewAt = now + Duration(minutes: gapMinutes).inMilliseconds;
    } else {
      nextLeft += 1;
      nextStreak = streak + 1;
      final gapMinutes = (10 - (nextStreak * 2)).clamp(2, 10).toInt();
      nextReviewAt = now + Duration(minutes: gapMinutes).inMilliseconds;
    }

    await db.insert(
      'flashcard_stats',
      {
        'user_token': userToken,
        'word': normalized,
        'left_count': nextLeft,
        'right_count': nextRight,
        'wrong_streak': nextStreak,
        'last_seen': now,
        'next_review_at': nextReviewAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }
}
