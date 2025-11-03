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
      version: 1,
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
      final key = 'vocab_' + userToken;
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
      final key = 'vocab_' + userToken;
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
}
