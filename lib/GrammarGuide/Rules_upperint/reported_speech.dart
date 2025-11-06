import 'package:flutter/material.dart';

class ReportedSpeechScreen extends StatelessWidget {
  const ReportedSpeechScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Reported (Indirect) Speech'),
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
              'From Direct to Reported Speech',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            _sectionTitle('Backshift of tenses (when reporting in the past)'),
            _sectionText(
              'If the reporting verb is in a past tense (said, told, asked), we usually shift the tense back one step.',
            ),
            _exampleBlock([
              'Direct: "I am tired." → He said (that) he was tired.',
              'Direct: "I have finished." → She said (that) she had finished.',
              'Direct: "I will call you." → He said (that) he would call me.',
              'Direct: "I can swim." → She said (that) she could swim.',
            ]),

            _sectionTitle('No backshift (still true / reporting in the present)'),
            _sectionText(
              'If the situation is still true or the reporting verb is present, you can keep the original tense.',
            ),
            _exampleBlock([
              'She says (that) she lives in Almaty. (present reporting)',
              'He said (that) the sun rises in the east. (general truth)',
            ]),

            _sectionTitle('Pronouns and time/place changes'),
            _sectionText(
              'Adjust pronouns, time and place words from the speaker\'s perspective.',
            ),
            _exampleBlock([
              'this → that; these → those; here → there',
              'now → then; today → that day; tomorrow → the next day; yesterday → the day before',
              'my → his/her; we → they',
            ]),

            _sectionTitle('Statements'),
            _sectionText('reporting verb + that-clause (that is often omitted in speech).'),
            _exampleBlock([
              'He said (that) he was busy.',
              'She told me (that) she\'d call later.',
            ]),

            _sectionTitle('Yes/No questions'),
            _sectionText('ask + if/whether + clause (no question word order in the reported part).'),
            _exampleBlock([
              'Direct: "Are you ready?" → He asked if I was ready.',
              'Direct: "Will you come?" → She asked whether I would come.',
            ]),

            _sectionTitle('Wh- questions'),
            _sectionText('ask/want to know + wh-word + clause (normal statement order).'),
            _exampleBlock([
              'Direct: "Where do you live?" → He asked where I lived.',
              'Direct: "Why are you late?" → She asked why I was late.',
            ]),

            _sectionTitle('Commands, requests, advice'),
            _sectionText('tell/ask + object + to-infinitive; negative: tell/ask + object + not to + verb.'),
            _exampleBlock([
              '"Close the door." → He told me to close the door.',
              '"Don\'t be late." → She told me not to be late.',
              '"Please help me." → He asked me to help him.',
            ]),

            _sectionTitle('Reporting verbs variety'),
            _sectionText(
              'admit, deny, promise, suggest, warn, advise, invite, remind, explain, insist, recommend — choose verbs to show attitude.',
            ),
            _exampleBlock([
              'She suggested going for a walk. / She suggested that we (should) go for a walk.',
              'He warned me not to touch the switch.',
            ]),

            const SizedBox(height: 18),
            _tipBlock('Tip: After say we don\'t use an object (say to me → tell me). After tell, we need the object (tell me).'),
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

