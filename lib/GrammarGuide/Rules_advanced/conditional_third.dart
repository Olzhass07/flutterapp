import 'package:flutter/material.dart';

class ThirdConditionalScreen extends StatelessWidget {
  const ThirdConditionalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Third Conditional (Unreal Past)'),
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
            const Text('Form & Use', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _sectionTitle('Structure'),
            _sectionText('If + Past Perfect, would have + past participle.'),
            _exampleBlock([
              'If I had known, I would have called you.',
              'If they had left earlier, they would have caught the train.',
            ]),

            _sectionTitle('Meaning'),
            _sectionText('Regrets or hypothetical results about a past situation that did not happen.'),
            _exampleBlock([
              'If she had studied, she would have passed. (but she didn\'t study)',
            ]),

            _sectionTitle('Modal variations'),
            _sectionText('could have / might have for ability/possibility in the hypothetical past.'),
            _exampleBlock([
              'If you had called, I could have helped.',
              'If he had tried, he might have won.',
            ]),

            _sectionTitle('Inversion (formal)'),
            _sectionText('Had + subject + past participle, ... (omit if).'),
            _exampleBlock([
              'Had I known, I would have acted differently.',
            ]),

            const SizedBox(height: 18),
            _tipBlock('Tip: Use the past perfect in the if-clause; avoid mixing with simple past (If I would know — incorrect).'),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 14),
        child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
      );
  Widget _sectionText(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text, style: const TextStyle(fontSize: 15.5, height: 1.6, color: Colors.black87)),
      );
  Widget _exampleBlock(List<String> examples) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: examples
              .map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(e, style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5)),
                  ))
              .toList(),
        ),
      );
  Widget _tipBlock(String text) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
        child: Text(text, style: const TextStyle(fontSize: 15, color: Colors.black87, fontStyle: FontStyle.italic)),
      );
}

