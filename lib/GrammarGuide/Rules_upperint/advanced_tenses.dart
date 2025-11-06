import 'package:flutter/material.dart';

class AdvancedTensesScreen extends StatelessWidget {
  const AdvancedTensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Advanced Tenses'),
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
              'Perfect and Continuous Aspects in Depth',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _sectionTitle('Present Perfect vs Present Perfect Continuous'),
            _sectionText('Result vs activity/duration; states vs temporary repeated actions.'),
            _exampleBlock([
              'I\'ve written three emails. (result/number completed)',
              'I\'ve been writing emails all morning. (activity/duration)',
              'She\'s lived here for 10 years. (state verb, simple form)',
            ]),

            _sectionTitle('Past Perfect and Past Perfect Continuous'),
            _sectionText('Earlier past in narratives; show cause/background to a past event.'),
            _exampleBlock([
              'By the time we arrived, the film had started.',
              'They had been waiting for an hour when the bus came.',
            ]),

            _sectionTitle('Future forms: will be V‑ing; will have V‑ed; will have been V‑ing'),
            _sectionText('Future Continuous: action in progress at a future time; Future Perfect: completed by a future point; Future Perfect Continuous: duration up to a future point.'),
            _exampleBlock([
              'This time tomorrow, I\'ll be flying to Dubai. (in progress)',
              'By 2030, she will have finished her PhD. (completed by then)',
              'By noon, they will have been driving for six hours. (duration)',
            ]),

            _sectionTitle('Narrative and reporting uses'),
            _sectionText('Use perfect aspects to frame backstory and consequences; continuous to highlight temporary/background actions.'),
            _exampleBlock([
              'He\'d been studying all night, so he was exhausted.',
              'I\'ve been meaning to call you. (unfinished intention up to now)',
            ]),

            _sectionTitle('Stative vs dynamic verbs'),
            _sectionText('Stative verbs (know, believe, own, seem) rarely use continuous. Use simple/perfect forms instead.'),
            _exampleBlock([
              'I\'ve known her since school. (not: I\'ve been knowing)',
            ]),

            const SizedBox(height: 18),
            _tipBlock('Tip: Prefer the simple perfect with how many/how much; use the continuous for how long and unfinished activity.'),
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
              .map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      e,
                      style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                    ),
                  ))
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

