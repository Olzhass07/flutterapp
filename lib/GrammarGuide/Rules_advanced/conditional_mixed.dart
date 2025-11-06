import 'package:flutter/material.dart';

class MixedConditionalsScreen extends StatelessWidget {
  const MixedConditionalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Mixed Conditionals (Advanced)'),
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
            const Text('Cross-time situations', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            _sectionTitle('Past condition → present result'),
            _sectionText('If + Past Perfect, would + base verb (now).'),
            _exampleBlock([
              'If I had chosen engineering, I would have a different job now.',
            ]),

            _sectionTitle('Present condition → past result'),
            _sectionText('If + Past Simple (unreal now), would have + past participle (then).'),
            _exampleBlock([
              'If I were taller, I would have played basketball professionally.',
            ]),

            _sectionTitle('Why mix?'),
            _sectionText('To show time contrast between condition and result (past ↔ present/future).'),
            _exampleBlock([
              'If he weren\'t so proud, he would have apologized earlier.',
              'If they had saved money, they wouldn\'t be in debt now.',
            ]),

            const SizedBox(height: 18),
            _tipBlock('Tip: Decide the time of the condition and the time of the result first; then choose the clause forms accordingly.'),
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

