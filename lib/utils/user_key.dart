import 'dart:convert';

String deriveUserKeyFromToken(String? token) {
  print('[deriveUserKeyFromToken] input token: $token');

  if (token == null || token.isEmpty) {
    print('[deriveUserKeyFromToken] token is null or empty → guest');
    return 'guest';
  }

  try {
    final parts = token.split('.');
    print('[deriveUserKeyFromToken] token parts count: ${parts.length}');

    if (parts.length == 3) {
      String normalizeBase64Url(String s) {
        final pad = (4 - s.length % 4) % 4;
        return s.replaceAll('-', '+').replaceAll('_', '/') + '=' * pad;
      }

      final payloadB64 = normalizeBase64Url(parts[1]);
      print('[deriveUserKeyFromToken] payloadB64: $payloadB64');

      final payloadJson =
          utf8.decode(base64.decode(payloadB64));
      print('[deriveUserKeyFromToken] decoded payload json: $payloadJson');

      final payload =
          jsonDecode(payloadJson) as Map<String, dynamic>;

      print('[deriveUserKeyFromToken] payload map: $payload');

      final candidates = [
        payload['sub'],
        payload['user_id'],
        payload['userId'],
        payload['id'],
        payload['uid'],
        payload['email'],
        payload['username'],
      ];

      for (final c in candidates) {
        print('[deriveUserKeyFromToken] checking candidate: $c');
        if (c is String && c.isNotEmpty) {
          print('[deriveUserKeyFromToken] selected (string): $c');
          return c;
        }
        if (c is num) {
          print('[deriveUserKeyFromToken] selected (num): $c');
          return c.toString();
        }
      }
    }
  } catch (e) {
    print('[deriveUserKeyFromToken] exception: $e');
  }

  final fallback =
      token.length > 24 ? token.substring(0, 24) : token;
  print('[deriveUserKeyFromToken] fallback result: $fallback');

  return fallback;
}
