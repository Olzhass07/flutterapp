import 'package:flutter_test/flutter_test.dart';
import 'package:olzhasmobileproject/utils/dictionary_parser.dart';

void main() {
  test('parseDictionaryDetails returns empty for invalid data', () {
    final result = parseDictionaryDetails({'x': 1});
    expect(result['example'], isNull);
    expect(result['synonyms'], isEmpty);
  });

  test('parseDictionaryDetails extracts example text', () {
    final data = [
      {
        'def': [
          {
            'sseq': [
              [
                [
                  'sense',
                  {
                    'dt': [
                      ['vis', [{'t': 'Hello {it}world{/it}!'}]]
                    ]
                  }
                ]
              ]
            ]
          }
        ],
        'meta': {
          'syns': [
            ['a', 'b']
          ]
        }
      }
    ];

    final result = parseDictionaryDetails(data);
    expect(result['example'], 'Hello world!');
  });

  test('parseDictionaryDetails merges synonyms', () {
    final data = [
      {
        'def': [],
        'meta': {
          'syns': [
            ['alpha'],
            ['beta', 'gamma']
          ]
        }
      }
    ];

    final result = parseDictionaryDetails(data);
    expect(result['synonyms'], unorderedEquals(['alpha', 'beta', 'gamma']));
  });

  test('parseDictionaryDetails handles empty list', () {
    final result = parseDictionaryDetails([]);
    expect(result['example'], isNull);
    expect(result['synonyms'], isEmpty);
  });

  test('parseDictionaryDetails ignores non-list synonyms', () {
    final data = [
      {
        'meta': {
          'syns': ['bad']
        }
      }
    ];

    final result = parseDictionaryDetails(data);
    expect(result['synonyms'], isEmpty);
  });
}
