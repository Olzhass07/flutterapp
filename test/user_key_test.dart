import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:olzhasmobileproject/utils/user_key.dart';

String _b64Url(Object value) {
  return base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
}

void main() {
  test('deriveUserKeyFromToken returns guest for empty token', () {
    expect(deriveUserKeyFromToken(null), 'guest');
    expect(deriveUserKeyFromToken(''), 'guest');
  });

  test('deriveUserKeyFromToken reads payload fields from JWT', () {
    final header = _b64Url({'alg': 'none', 'typ': 'JWT'});
    final payload = _b64Url({'sub': 'user-123'});
    final token = '$header.$payload.signature';
    expect(deriveUserKeyFromToken(token), 'user-123');
  });

  test('deriveUserKeyFromToken falls back to truncated token', () {
    final token = 'x' * 30;
    expect(deriveUserKeyFromToken(token), 'x' * 24);
  });
}
