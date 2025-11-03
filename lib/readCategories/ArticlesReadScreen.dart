import 'package:flutter/material.dart';

class ArticlesReadScreen extends StatelessWidget {
  final String? token;
  const ArticlesReadScreen({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(8, (i) => 'Article ${i + 1}');
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Articles'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFFFFFFF)],
          ),
        ),
        child: SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.article_rounded),
                  title: Text(items[index]),
                  subtitle: const Text('Tap to read'),
                  onTap: () {
                    // TODO: open article detail
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

