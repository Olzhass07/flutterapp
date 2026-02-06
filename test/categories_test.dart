import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:olzhasmobileproject/utils/categories.dart';

void main() {
  test('readCategoryKey normalizes to books', () {
    expect(readCategoryKey('Books'), 'books');
  });

  test('readCategoryKey defaults to books for unknown', () {
    expect(readCategoryKey('Other'), 'books');
  });

  test('readCategoryIcon maps news to newspaper', () {
    expect(readCategoryIcon('news'), Icons.newspaper_rounded);
  });

  test('readCategoryGradient maps articles colors', () {
    expect(
      readCategoryGradient('Articles'),
      const [Color(0xFF2563EB), Color(0xFF34D399)],
    );
  });

  test('videoCategoryKey maps podcasts', () {
    expect(videoCategoryKey('Podcasts'), 'podcasts');
  });

  test('videoCategoryIcon maps documentaries', () {
    expect(videoCategoryIcon('documentaries'), Icons.movie_filter_rounded);
  });
}
