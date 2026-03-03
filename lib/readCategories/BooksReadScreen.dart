import 'package:flutter/material.dart';

import 'reading_catalog_screen.dart';

class BooksReadScreen extends StatelessWidget {
  final String? token;

  const BooksReadScreen({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return ReadingCatalogScreen(
      token: token,
      category: 'books',
      title: 'Books',
      icon: Icons.menu_book_rounded,
    );
  }
}
