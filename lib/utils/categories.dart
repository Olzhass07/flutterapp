import 'package:flutter/material.dart';

String normalizeCategoryTitle(String title) {
  return title.trim().toLowerCase();
}

String readCategoryKey(String title) {
  switch (normalizeCategoryTitle(title)) {
    case 'books':
      return 'books';
    case 'articles':
      return 'articles';
    case 'news':
      return 'news';
    default:
      return 'books';
  }
}

String videoCategoryKey(String title) {
  switch (normalizeCategoryTitle(title)) {
    case 'tutorials':
      return 'tutorials';
    case 'documentaries':
      return 'documentaries';
    case 'movies':
      return 'movies';
    case 'podcasts':
      return 'podcasts';
    default:
      return '';
  }
}

IconData readCategoryIcon(String title) {
  switch (normalizeCategoryTitle(title)) {
    case 'books':
      return Icons.menu_book_rounded;
    case 'articles':
      return Icons.article_rounded;
    case 'news':
      return Icons.newspaper_rounded;
    default:
      return Icons.folder_rounded;
  }
}

List<Color> readCategoryGradient(String title) {
  switch (normalizeCategoryTitle(title)) {
    case 'books':
      return const [Color(0xFF4F46E5), Color(0xFF60A5FA)];
    case 'articles':
      return const [Color(0xFF2563EB), Color(0xFF34D399)];
    case 'news':
      return const [Color(0xFFDB2777), Color(0xFFF59E0B)];
    default:
      return const [Color(0xFF64748B), Color(0xFF94A3B8)];
  }
}

IconData videoCategoryIcon(String title) {
  switch (normalizeCategoryTitle(title)) {
    case 'tutorials':
      return Icons.school_rounded;
    case 'documentaries':
      return Icons.movie_filter_rounded;
    case 'movies':
      return Icons.local_movies_rounded;
    case 'podcasts':
      return Icons.podcasts_rounded;
    default:
      return Icons.folder_rounded;
  }
}

List<Color> videoCategoryGradient(String title) {
  switch (normalizeCategoryTitle(title)) {
    case 'tutorials':
      return const [Color(0xFF4F46E5), Color(0xFF60A5FA)];
    case 'documentaries':
      return const [Color(0xFF2563EB), Color(0xFF34D399)];
    case 'movies':
      return const [Color(0xFFDB2777), Color(0xFFF59E0B)];
    case 'podcasts':
      return const [Color(0xFF9333EA), Color(0xFF6366F1)];
    default:
      return const [Color(0xFF64748B), Color(0xFF94A3B8)];
  }
}
