const List<String> grammarLevels = [
  'Beginner',
  'Elementary',
  'Pre-Intermediate',
  'Intermediate',
  'Upper-Intermediate',
  'Advanced',
];

String normalizeGrammarLevelKey(String value) {
  final v = value.toLowerCase().replaceAll('-', ' ').replaceAll('_', ' ').trim();
  if (v == 'beginner') return 'beginner';
  if (v == 'elementary') return 'elementary';
  if (v == 'pre intermediate' || v == 'pre int' || v == 'preint') {
    return 'pre-intermediate';
  }
  if (v == 'intermediate' || v == 'int') return 'intermediate';
  if (v == 'upper intermediate' || v == 'upper int' || v == 'upperint') {
    return 'upper-intermediate';
  }
  if (v == 'advanced') return 'advanced';
  return '';
}

String? grammarLevelTitleFor(String value) {
  final key = normalizeGrammarLevelKey(value);
  switch (key) {
    case 'beginner':
      return 'Beginner';
    case 'elementary':
      return 'Elementary';
    case 'pre-intermediate':
      return 'Pre-Intermediate';
    case 'intermediate':
      return 'Intermediate';
    case 'upper-intermediate':
      return 'Upper-Intermediate';
    case 'advanced':
      return 'Advanced';
    default:
      return null;
  }
}

int? grammarLevelIndexOf(String value) {
  final title = grammarLevelTitleFor(value);
  if (title == null) return null;
  return grammarLevels.indexOf(title);
}
