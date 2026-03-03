import 'package:flutter/material.dart';

import 'reading_catalog_screen.dart';

class ArticlesReadScreen extends StatelessWidget {
  final String? token;

  const ArticlesReadScreen({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return ReadingCatalogScreen(
      token: token,
      category: 'articles',
      title: 'Articles',
      icon: Icons.article_rounded,
    );
  }
}
