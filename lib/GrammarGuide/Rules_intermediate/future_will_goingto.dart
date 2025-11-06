import 'package:flutter/material.dart';

class FutureWillGoingToScreen extends StatelessWidget {
  const FutureWillGoingToScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Future: will vs going to'),
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
              'Talking about the future',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _sectionTitle('will: decisions, offers, predictions (no evidence)'),
            _sectionText(
              'Use will for spontaneous decisions, promises, offers, and predictions based on opinion or belief.',
            ),
            _exampleBlock([
              'I\'ll help you with that. (offer/promise)',
              'I think it\'ll rain tomorrow. (opinion)',
              'Okay, I\'ll call her now. (decision at the moment)',
            ]),

            _sectionTitle('be going to: plans/intentions, predictions (evidence)'),
            _sectionText(
              'Use going to for prior plans/intentions and for predictions based on present evidence.',
            ),
            _exampleBlock([
              'We\'re going to visit my grandma next week. (plan)',
              'Look at those clouds! It\'s going to rain. (evidence)',
            ]),

            _sectionTitle('Notes'),
            _sectionText(
              'In speech, will often contracts to \"\'ll\". For arrangements, Present Continuous is also common (We\'re meeting at 6).',
            ),

            const SizedBox(height: 18),
            _tipBlock('Tip: If you decide now → will. If you planned earlier → going to.'),
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

