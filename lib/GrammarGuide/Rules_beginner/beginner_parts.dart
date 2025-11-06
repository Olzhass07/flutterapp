import 'package:flutter/material.dart';

class BeginnerPartsScreen extends StatelessWidget {
  const BeginnerPartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final parts = [
      {
        'emoji': '👤',
        'title': 'Noun',
        'desc': 'A noun is a word that names a person, place, thing, or idea.',
        'translate': 'Существительное — это слово, обозначающее человека, место, предмет или идею.',
        'examples': 'Example: cat, school, love, phone'
      },
      {
        'emoji': '🙋‍♂️',
        'title': 'Pronoun',
        'desc': 'A pronoun replaces a noun to avoid repeating it.',
        'translate': 'Местоимение заменяет существительное, чтобы не повторять его.',
        'examples': 'Example: I, you, he, she, it, we, they'
      },
      {
        'emoji': '⚡',
        'title': 'Verb',
        'desc': 'A verb shows an action or state.',
        'translate': 'Глагол показывает действие или состояние.',
        'examples': 'Example: run, eat, be, study, sleep'
      },
      {
        'emoji': '🎨',
        'title': 'Adjective',
        'desc': 'An adjective describes a noun or pronoun.',
        'translate': 'Прилагательное описывает существительное или местоимение.',
        'examples': 'Example: big, small, happy, red, beautiful'
      },
      {
        'emoji': '⏰',
        'title': 'Adverb',
        'desc': 'An adverb tells how, when, or where something happens.',
        'translate': 'Наречие говорит как, когда или где происходит действие.',
        'examples': 'Example: quickly, always, very, soon'
      },
      {
        'emoji': '📍',
        'title': 'Preposition',
        'desc': 'A preposition shows the relationship between words.',
        'translate': 'Предлог показывает связь между словами в предложении.',
        'examples': 'Example: in, on, at, under, from'
      },
      {
        'emoji': '🔗',
        'title': 'Conjunction',
        'desc': 'A conjunction connects words or parts of a sentence.',
        'translate': 'Союз соединяет слова или части предложения.',
        'examples': 'Example: and, but, or, because, so'
      },
      {
        'emoji': '💬',
        'title': 'Interjection',
        'desc': 'An interjection shows strong emotion or surprise.',
        'translate': 'Междометие выражает эмоции или удивление.',
        'examples': 'Example: Wow! Hey! Oops! Oh no!'
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        title: const Text('Parts of Speech'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'What are “Parts of Speech”?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Every English word belongs to a group called a “part of speech.” '
            'These groups help us understand how words work together in sentences. '
            'Learning them makes it easier to write and speak clearly.',
            style: TextStyle(fontSize: 16, height: 1.6),
          ),
          const SizedBox(height: 16),
          const Text(
            'Каждое слово в английском языке относится к определённой группе — '
            'части речи. Понимая эти группы, ты начинаешь чувствовать логику языка.',
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 24),

          // вывод карточек
          for (final p in parts) _buildPartCard(p),

          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '💡 Tip: Don’t try to memorize everything at once. '
              'Learn 1–2 parts of speech each week and practice them in real sentences.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartCard(Map<String, String> part) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            children: [
              Text(part['emoji']!, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Text(
                part['title']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            part['desc']!,
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
          const SizedBox(height: 4),
          Text(
            part['translate']!,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontStyle: FontStyle.italic,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            part['examples']!,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
