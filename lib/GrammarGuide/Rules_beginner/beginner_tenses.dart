import 'package:flutter/material.dart';

class BeginnerTensesScreen extends StatelessWidget {
  const BeginnerTensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Verb Tenses'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Verb Tenses',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Verb tenses show when an action happens — in the past, present, or future. '
            'They also show if it’s finished, still happening, or repeating.',
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
          const SizedBox(height: 8),
          const Text(
            'Времена в английском показывают, когда происходит действие — в прошлом, настоящем или будущем, '
            'и продолжается ли оно, закончилось или повторяется.',
            style: TextStyle(fontSize: 15, height: 1.5, color: Colors.black54),
          ),
          const SizedBox(height: 24),

          _tensesIntro(),

          const SizedBox(height: 16),
          _tenseGroup(
            emoji: '⏳',
            title: 'Past Tenses',
            desc: 'Used for actions that happened before now.',
            content: _pastContent(),
          ),
          _tenseGroup(
            emoji: '⏰',
            title: 'Present Tenses',
            desc: 'Used for actions happening now or regularly.',
            content: _presentContent(),
          ),
          _tenseGroup(
            emoji: '🔮',
            title: 'Future Tenses',
            desc: 'Used for actions that will happen later.',
            content: _futureContent(),
          ),

          const SizedBox(height: 30),
          _tipBox(
            '💡 Tip: English has 12 main tenses. Start by learning the four simple ones first (Present, Past, Future, Continuous). '
            'Постепенно добавляй новые времена, не учи всё сразу — так будет проще.',
          ),
        ],
      ),
    );
  }

  // --- INTRO ---
  Widget _tensesIntro() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'There are 12 verb tenses in English, based on 3 time periods (Past, Present, Future) '
          'and 4 aspects: Simple, Continuous, Perfect, and Perfect Continuous.\n\n'
          '→ Simple = one-time or regular actions\n'
          '→ Continuous = ongoing actions\n'
          '→ Perfect = completed actions related to another time\n'
          '→ Perfect Continuous = long, ongoing actions that started earlier',
          style: TextStyle(fontSize: 15, height: 1.6),
        ),
      );

  // --- TENSE BLOCK ---
  Widget _tenseGroup({
    required String emoji,
    required String title,
    required String desc,
    required List<Widget> content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(14),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: Text(emoji, style: const TextStyle(fontSize: 22)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        subtitle: Text(desc),
        children: content,
      ),
    );
  }

  // --- CONTENT BLOCKS ---
  List<Widget> _pastContent() => [
        _miniTense('Simple Past', '[V + ed / 2nd form]',
            'Used for completed actions in the past.\n(Используется для завершённых действий в прошлом.)',
            ['I visited London last year.', 'She watched a movie.']),
        _miniTense('Past Continuous', '[was/were + V-ing]',
            'Used for actions that were ongoing in the past.\n(Действие длилось в прошлом.)',
            ['I was reading when you called.', 'They were playing football.']),
        _miniTense('Past Perfect', '[had + past participle]',
            'Shows one past action happened before another.\n(Одно действие раньше другого.)',
            ['She had left before I arrived.', 'I had finished my work.']),
        _miniTense('Past Perfect Continuous', '[had + been + V-ing]',
            'Shows an ongoing action before another past action.\n(Действие длилось до другого в прошлом.)',
            ['He had been working for 3 hours before dinner.']),
      ];

  List<Widget> _presentContent() => [
        _miniTense('Simple Present', '[V / V+s]',
            'Used for facts, routines, and general truths.\n(Факты, привычки, расписание.)',
            ['I go to school every day.', 'The sun rises in the east.']),
        _miniTense('Present Continuous', '[am/is/are + V-ing]',
            'Used for actions happening now or near future.\n(То, что происходит сейчас.)',
            ['I am studying English.', 'We are having dinner.']),
        _miniTense('Present Perfect', '[have/has + past participle]',
            'Used for actions that started in the past and continue now.\n(Действие началось в прошлом и длится сейчас.)',
            ['I have lived here for five years.', 'She has already eaten.']),
        _miniTense('Present Perfect Continuous', '[have/has + been + V-ing]',
            'Used for actions continuing from past until now.\n(Длительные действия, начавшиеся раньше.)',
            ['We have been waiting for an hour.', 'He has been working all day.']),
      ];

  List<Widget> _futureContent() => [
        _miniTense('Simple Future', '[will + V]',
            'Used for actions that will happen later.\n(Будущее действие.)',
            ['I will call you tomorrow.', 'She will travel to Japan.']),
        _miniTense('Future Continuous', '[will + be + V-ing]',
            'Used for ongoing actions in the future.\n(Действие будет происходить в будущем.)',
            ['I will be studying at 8 p.m.', 'They will be working next week.']),
        _miniTense('Future Perfect', '[will + have + past participle]',
            'Used for actions completed before a specific time in the future.\n(К определённому моменту в будущем.)',
            ['By 10 o’clock, I will have finished my homework.']),
        _miniTense('Future Perfect Continuous', '[will + have + been + V-ing]',
            'Used for long ongoing actions up to a future point.\n(Действие будет длиться до будущего момента.)',
            ['By next year, she will have been studying English for 5 years.']),
      ];

  // --- MINI TENSE CARD ---
  Widget _miniTense(String title, String formula, String desc, List<String> examples) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          const SizedBox(height: 4),
          Text(formula,
              style: const TextStyle(
                  fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black87)),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(fontSize: 14.5, height: 1.4)),
          const SizedBox(height: 6),
          for (final ex in examples)
            Padding(
              padding: const EdgeInsets.only(left: 6, bottom: 2),
              child: Text('• $ex',
                  style: const TextStyle(
                      fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black87)),
            ),
        ],
      ),
    );
  }

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
