import 'package:flutter/material.dart';

class BeginnerSentenceScreen extends StatelessWidget {
  const BeginnerSentenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Sentence Structure and Rules'),
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
              'Sentence Structure and Rules',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Sentence structure — это структура предложения, то есть порядок и связь всех его частей: подлежащее, сказуемое, объекты, фразы и пунктуация.',
              style: TextStyle(fontSize: 15, height: 1.5, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            const Text(
              'In English, every sentence has its own architecture — the order of the subject, verb, and objects. '
              'Mastering this makes your sentences clear, logical, and natural.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 30),

            _sectionTitle('Basic Parts of a Sentence'),
            _paragraph(
                'Every sentence needs at least a subject and a verb. The subject does the action, and the verb shows what the action is.'),
            _exampleBlock([
              'I am waiting.',
              '→ "I" is the subject (я), "am waiting" is the verb (жду).'
            ]),
            _paragraph(
                'Sometimes, we add objects. The object receives the action.'),
            _exampleBlock([
              'My buddy lends me their calculator.',
              '→ subject: my buddy | verb: lends | direct object: calculator | indirect object: me'
            ]),
            _tipBox(
                '🔎 Remember: Subject pronouns (I, he, she) differ from object pronouns (me, him, her).'),

            const SizedBox(height: 30),
            _sectionTitle('4 Grammar Rules for Sentence Structure'),
            _bulletList([
              'Capitalize the first letter of a sentence. (Начинай с большой буквы.)',
              'End a sentence with . ? ! or quotation marks.',
              'The usual order: Subject → Verb → Object.',
              'Subjects and verbs must agree in number: He runs / They run.',
            ]),

            const SizedBox(height: 30),
            _sectionTitle('Clauses — Main and Dependent'),
            _paragraph(
                'A clause — это часть предложения, где есть подлежащее и сказуемое. '
                'Clauses могут быть независимыми (independent) или зависимыми (dependent).'),
            _exampleBlock([
              'Independent clause: We’ll eat dinner at five.',
              'Dependent clause: because it rained last night.',
              '→ "because" — это subordinating conjunction (подчинительный союз).'
            ]),
            _paragraph(
                'Dependent clauses add extra information but cannot stand alone. '
                'They always depend on a main clause.'),

            const SizedBox(height: 30),
            _sectionTitle('4 Types of Sentence Structure'),
            _paragraph(
                'Depending on how you combine clauses, there are 4 main types of sentence structure:'),

            _miniCard(
              'Simple Sentence',
              'One independent clause. (Одно простое предложение)',
              ['I love English.', 'Life is beautiful.'],
            ),
            _miniCard(
              'Compound Sentence',
              'Two or more independent clauses joined by FANBOYS (for, and, nor, but, or, yet, so) or a semicolon.',
              ['I study hard, and I improve every day.', 'Be yourself; everyone else is taken.'],
            ),
            _miniCard(
              'Complex Sentence',
              'One independent + one or more dependent clauses.',
              ['Because it was raining, we stayed home.', 'I smiled when I saw you.'],
            ),
            _miniCard(
              'Compound-Complex Sentence',
              'At least two independent + one dependent clause.',
              ['If you work hard, you succeed, and you inspire others.'],
            ),

            const SizedBox(height: 30),
            _tipBox(
                '💡 Beginner advice: Focus first on forming correct simple sentences. '
                'Once you feel confident, move on to complex and compound ones. '
                'Главное — правильный порядок: Subject → Verb → Object.'),
          ],
        ),
      ),
    );
  }

  // --- UI helpers ---
  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
        ),
      );

  Widget _paragraph(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          text,
          style: const TextStyle(fontSize: 15.5, height: 1.6, color: Colors.black87),
        ),
      );

  Widget _exampleBlock(List<String> examples) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: examples
              .map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      e,
                      style: const TextStyle(
                          fontSize: 14.5,
                          fontStyle: FontStyle.italic,
                          color: Colors.black87),
                    ),
                  ))
              .toList(),
        ),
      );

  Widget _bulletList(List<String> items) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map((i) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '• $i',
                    style: const TextStyle(fontSize: 15, height: 1.5),
                  ),
                ))
            .toList(),
      );

  Widget _miniCard(String title, String desc, List<String> examples) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blueAccent)),
            const SizedBox(height: 4),
            Text(desc, style: const TextStyle(fontSize: 14.5, height: 1.4)),
            const SizedBox(height: 6),
            for (final ex in examples)
              Text('• $ex',
                  style: const TextStyle(
                      fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black87)),
          ],
        ),
      );

  Widget _tipBox(String text) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.greenAccent.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 14.5, height: 1.5, color: Colors.black87),
        ),
      );
}
