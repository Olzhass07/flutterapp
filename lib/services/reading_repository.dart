import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/reading_item.dart';

class ReadingRepository {
  const ReadingRepository();

  static const String _catalogPath = 'assets/reading/index.json';
  static const String _newsUrl = 'http://localhost:3001/reading/news';

  Future<List<ReadingItem>> loadCatalog({String? category}) async {
    if ((category ?? '').toLowerCase() == 'news') {
      return _loadNews();
    }

    final raw = await rootBundle.loadString(_catalogPath);
    final List<dynamic> data = jsonDecode(raw) as List<dynamic>;
    final items = data
        .whereType<Map>()
        .map((item) => ReadingItem.fromJson(Map<String, dynamic>.from(item)))
        .where((item) => item.id.isNotEmpty && item.title.isNotEmpty)
        .toList();

    if (category == null || category.isEmpty) {
      return items;
    }

    return items
        .where((item) => item.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  Future<String> loadText(ReadingItem item) {
    if (item.content.trim().isNotEmpty) {
      return Future.value(item.content);
    }
    return rootBundle.loadString(item.assetPath);
  }

  Future<List<ReadingItem>> _loadNews() async {
    final response = await http.get(Uri.parse(_newsUrl));
    if (response.statusCode != 200) {
      throw Exception('Failed to load news: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = (data['items'] as List<dynamic>? ?? const <dynamic>[])
        .whereType<Map>()
        .map((item) => ReadingItem.fromJson(Map<String, dynamic>.from(item)))
        .toList();
    return items;
  }
}
