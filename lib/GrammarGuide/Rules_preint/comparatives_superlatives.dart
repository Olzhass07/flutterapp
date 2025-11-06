import 'package:flutter/material.dart';

class ComparativesSuperlativesPreIntScreen extends StatelessWidget {
  const ComparativesSuperlativesPreIntScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Comparatives & Superlatives'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Rules: Comparatives and Superlatives',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _sectionTitle('Forming the comparative (er / more)'),
            _sectionText(
              'Short adjectives: add -er (tall → taller). Long adjectives: use more (beautiful → more beautiful).',
            ),
            _exampleBlock([
              'My sister is taller than me.',
              'This book is more interesting than that one.',
            ]),

            _sectionTitle('Forming the superlative (est / most)'),
            _sectionText(
              'Short adjectives: add -est (small → smallest). Long adjectives: use most (expensive → most expensive).',
            ),
            _exampleBlock([
              'He\'s the tallest in his class.',
              'It\'s the most expensive restaurant here.',
            ]),

            _sectionTitle('Spelling changes'),
            _sectionText(
              'big → bigger/biggest (double consonant); nice → nicer/nicest (drop final -e for -er/-est).',
            ),
            _exampleBlock([
              'big → bigger → biggest',
              'nice → nicer → nicest',
            ]),

            _sectionTitle('Irregular forms'),
            _sectionText('good → better → best; bad → worse → worst; far → farther/further → farthest/furthest.'),
            _exampleBlock([
              'This result is better than before.',
              'It\'s the worst day of the year.',
            ]),

            const SizedBox(height: 18),
            _tipBlock('Tip: Use than after comparatives. Use the before superlatives.'),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 14),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      );

  Widget _sectionText(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          text,
          style: const TextStyle(fontSize: 15.5, height: 1.6, color: Colors.black87),
        ),
      );

  Widget _exampleBlock(List<String> examples) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: examples
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    e,
                    style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                  ),
                ),
              )
              .toList(),
        ),
      );

  Widget _tipBlock(String text) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.greenAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 15, color: Colors.black87, fontStyle: FontStyle.italic),
        ),
      );
}

