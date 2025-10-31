import 'package:flutter/material.dart';

class ReadScreen extends StatelessWidget {
  final String categoryTitle;
  final bool isBookCategory;

  const ReadScreen({
    super.key,
    required this.categoryTitle,
    required this.isBookCategory,
  });

  
  List<Map<String, String>> get materials {
    if (isBookCategory) {
      return [
        {'title': 'Harry Potter', 'author': 'J. K. Rowling'},
        {'title': 'Harry Potter', 'author': 'J. K. Rowling'},
        {'title': 'Harry Potter', 'author': 'J. K. Rowling'},
        {'title': 'Harry Potter', 'author': 'J. K. Rowling'},
      ];
    } else {
      return [
        {'title': 'Physics', 'author': 'AAA'},
        {'title': 'Physics', 'author': 'AAA'},
        {'title': 'Physics', 'author': 'AAA'},
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryTitle,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F7FA), Color(0xFFB3E5FC)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 80, 16, 16), 
          child: ListView.builder(
            itemCount: materials.length,
            itemBuilder: (context, index) {
              final item = materials[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                child: ListTile(
                  title: Text(item['title']!),
                  subtitle: Text(item['author']!),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Вы выбрали "${item['title']}"')),
                    );
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
