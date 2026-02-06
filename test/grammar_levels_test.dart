import 'package:flutter_test/flutter_test.dart';
import 'package:olzhasmobileproject/utils/grammar_levels.dart';

void main() {
  test('normalizeGrammarLevelKey handles upper int', () {
    expect(normalizeGrammarLevelKey('Upper Int'), 'upper-intermediate');
  });

  test('normalizeGrammarLevelKey handles pre-int', () {
    expect(normalizeGrammarLevelKey('pre-int'), 'pre-intermediate');
  });

  test('normalizeGrammarLevelKey handles int', () {
    expect(normalizeGrammarLevelKey('int'), 'intermediate');
  });

  test('grammarLevelTitleFor returns title', () {
    expect(grammarLevelTitleFor('advanced'), 'Advanced');
  });

  test('grammarLevelIndexOf returns correct index', () {
    expect(grammarLevelIndexOf('Pre-Intermediate'), 2);
  });
}
