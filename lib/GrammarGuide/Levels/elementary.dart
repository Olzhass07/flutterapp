import 'package:flutter/material.dart';
import 'package:olzhasmobileproject/GrammarGuide/Rules_elementary/articles.dart';
import 'package:olzhasmobileproject/GrammarGuide/Rules_elementary/theristhereare.dart';
import 'package:olzhasmobileproject/GrammarGuide/Rules_elementary/questionforms.dart';

class ElementaryLevelScreen extends StatelessWidget {
  const ElementaryLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> topics = [
      {
        'title': 'Articles (a, an, the)',
        'description':
            'Understand how to use articles correctly to talk about general and specific things.',
        'screen': const ArticlesScreen(),
      },
      {
        'title': 'There is / There are',
        'description':
            'Learn how to describe the existence or presence of things in English.',
        'screen': const ThereIsThereAreScreen(),
      },
      {
        'title': 'Question Forms (Wh- & Yes/No)',
        'description':
            'Practice forming correct English questions for daily conversation.',
        'screen': const QuestionFormsScreen(),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text(
          'Elementary Grammar',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          final topic = topics[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
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
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => topic['screen'] as Widget),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.lightBlueAccent.shade100,
                            Colors.blueAccent.shade100
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.menu_book_rounded,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            topic['title']!,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            topic['description']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded,
                        size: 18, color: Colors.black45),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
