import 'package:flutter/material.dart';

class ModalsAbilityObligationScreen extends StatelessWidget {
  const ModalsAbilityObligationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Can / Could / Must / Have to'),
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
              'Ability, Permission, Obligation',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _sectionTitle('can / could (ability, permission)'),
            _sectionText(
              'can: present ability/permission; could: past ability or polite requests.',
            ),
            _exampleBlock([
              'I can swim fast. (present ability)',
              'Could you open the window, please? (polite request)',
              'She could read when she was four. (past ability)',
            ]),

            _sectionTitle('must vs have to (obligation)'),
            _sectionText(
              'must: internal/strong obligation (speaker\'s view); have to: external/necessity (rules, situation).',
            ),
            _exampleBlock([
              'I must finish this today. (my strong decision)',
              'We have to wear helmets at the factory. (rule)',
            ]),

            _sectionTitle('negatives: mustn\'t vs don\'t have to'),
            _sectionText(
              'mustn\'t = prohibition (it is not allowed); don\'t have to = no necessity (it\'s optional).',
            ),
            _exampleBlock([
              'You mustn\'t park here. (prohibited)',
              'You don\'t have to come early. (optional)',
            ]),

            _sectionTitle('forms'),
            _sectionText('Modals (can, must) use base verb. have to changes with subject and time (has to / had to).'),
            _exampleBlock([
              'She has to leave now. / She had to leave early yesterday.',
              'We must be quiet. / We had to be quiet.',
            ]),

            const SizedBox(height: 18),
            _tipBlock('Tip: Use could for polite questions, especially with strangers.'),
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

