Map<String, dynamic> parseDictionaryDetails(dynamic data) {
  String? example;
  final Set<String> syns = {};

  if (data is List && data.isNotEmpty) {
    try {
      final first = data[0];
      if (first is Map<String, dynamic>) {
        final defBlocks = first['def'] as List?;
        if (defBlocks != null && defBlocks.isNotEmpty) {
          final sseq = defBlocks[0]['sseq'];
          if (sseq is List && sseq.isNotEmpty) {
            for (final sub in sseq) {
              if (sub is! List || sub.isEmpty) continue;
              final entry = sub[0];
              if (entry is List && entry.isNotEmpty) {
                final dt = entry.length > 1 ? entry[1]['dt'] : null;
                if (dt is List) {
                  for (final item in dt) {
                    if (item is List && item.length > 1 && item[0] == 'vis') {
                      final visList = item[1];
                      if (visList is List && visList.isNotEmpty) {
                        final vis = visList[0];
                        if (vis is Map && vis['t'] is String) {
                          example = (vis['t'] as String)
                              .replaceAll(RegExp(r'\{.*?\}'), '');
                          break;
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }

        final meta = first['meta'];
        if (meta is Map && meta['syns'] is List) {
          for (final list in meta['syns']) {
            if (list is List) syns.addAll(list.map((e) => e.toString()));
          }
        }
      }
    } catch (_) {}
  }

  return {
    'example': example,
    'synonyms': syns.toList(),
  };
}
