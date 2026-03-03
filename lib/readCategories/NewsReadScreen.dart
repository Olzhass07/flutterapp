import 'package:flutter/material.dart';

import 'reading_catalog_screen.dart';

class NewsReadScreen extends StatelessWidget {
  final String? token;

  const NewsReadScreen({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return ReadingCatalogScreen(
      token: token,
      category: 'news',
      title: 'News',
      icon: Icons.newspaper_rounded,
    );
  }
}
