import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'GrammarLevel.dart';

class GrammarGuideScreen extends StatefulWidget {
  final String? token;
  const GrammarGuideScreen({super.key, this.token});

  @override
  State<GrammarGuideScreen> createState() => _GrammarGuideScreenState();
}

class _GrammarGuideScreenState extends State<GrammarGuideScreen> {
  static const List<String> levels = [
    'Beginner',
    'Elementary',
    'Pre-Intermediate',
    'Intermediate',
    'Upper-Intermediate',
    'Advanced',
  ];

  String? userLevel;
  int recommendedIndex = 0; // default to Beginner
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileAndComputeRecommendation();
  }

  Future<void> _loadProfileAndComputeRecommendation() async {
    // Default recommendation
    int rec = 0;

    final token = widget.token;
    if (token != null && token.isNotEmpty) {
      try {
        final url = Uri.parse('http://localhost:3001/profile');
        final resp = await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        if (resp.statusCode == 200) {
          final data = jsonDecode(resp.body) as Map<String, dynamic>;
          final user = data['user'] as Map<String, dynamic>?;
          final lvl = (user?['level'] as String?)?.trim();
          if (lvl != null && lvl.isNotEmpty) {
            userLevel = lvl;
            final idx = _levelIndexOf(lvl);
            if (idx != null) {
              rec = idx; // exactly user's level
            }
          }
        }
      } catch (_) {
        // ignore network errors; keep defaults
      }
    }

    setState(() {
      recommendedIndex = rec;
      loading = false;
    });
  }

  int? _levelIndexOf(String value) {
    final v = value.toLowerCase().replaceAll('-', ' ').replaceAll('_', ' ').trim();
    for (int i = 0; i < levels.length; i++) {
      final n = levels[i].toLowerCase().replaceAll('-', ' ');
      if (n == v ||
          (n.contains('upper intermediate') && (v == 'upper int' || v == 'upper intermediate')) ||
          (n.contains('pre intermediate') && (v == 'pre intermediate')) ||
          (n.contains('pre intermediate') && (v == 'pre-int')) ||
          (n.contains('upper intermediate') && (v == 'upper-int'))) {
        return i;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Grammar Guide',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Recommended level: ${levels[recommendedIndex]}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: levels.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final title = levels[index];
                      final isRecommended = index == recommendedIndex;
                      return Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GrammarLevelScreen(
                                  token: widget.token,
                                  level: title,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.menu_book, color: Colors.blueAccent),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (isRecommended) ...[
                                        const SizedBox(height: 6),
                                        const Text(
                                          'Recommended for you',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right, color: Colors.black54),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
