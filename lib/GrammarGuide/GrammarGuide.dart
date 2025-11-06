import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GrammarGuideScreen extends StatefulWidget {
  final String? token;
  const GrammarGuideScreen({super.key, this.token});

  @override
  State<GrammarGuideScreen> createState() => _GrammarGuideScreenState();
}

class _GrammarGuideScreenState extends State<GrammarGuideScreen>
    with SingleTickerProviderStateMixin {
  static const List<String> levels = [
    'Beginner',
    'Elementary',
    'Pre-Intermediate',
    'Intermediate',
    'Upper-Intermediate',
    'Advanced',
  ];

  String? userLevel;
  int recommendedIndex = 0;
  bool loading = true;
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _loadProfileAndComputeRecommendation();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfileAndComputeRecommendation() async {
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
            if (idx != null) rec = idx;
          }
        }
      } catch (_) {}
    }

    setState(() {
      recommendedIndex = rec;
      loading = false;
    });
    _animCtrl.forward();
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
    final gradient = const LinearGradient(
      colors: [Color(0xFF5A7FFB), Color(0xFF1D53DE)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FB),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Grammar Guide',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : FadeTransition(
              opacity: _animCtrl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Рекомендация пользователя
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.white, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Рекомендованный уровень: ${levels[recommendedIndex]}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Список уровней
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: levels.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final title = levels[index];
                        final isRecommended = index == recommendedIndex;

                        return AnimatedScale(
                          duration: const Duration(milliseconds: 250),
                          scale: isRecommended ? 1.03 : 1.0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: isRecommended
                                            ? [Color(0xFF61A1FA), Color(0xFF3B82F6)]
                                            : [Color(0xFFE3E9F6), Color(0xFFDDE3F0)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(Icons.menu_book_rounded,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            color: isRecommended
                                                ? Colors.blueAccent
                                                : Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          isRecommended
                                              ? 'Recommended for you'
                                              : 'Explore grammar lessons',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: isRecommended
                                                ? Colors.green
                                                : Colors.black54,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
            ),
    );
  }
}
