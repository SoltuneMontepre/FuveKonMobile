import 'package:dio/dio.dart';

/// Fuvekon sets `access_token` in an HttpOnly cookie on login (see general-service
/// `SetAuthCookie`). Mobile reads it from response headers and stores it for Bearer auth.
abstract final class AuthTokenExtractor {
  static const cookieName = 'access_token';

  static String? fromResponse(Response<dynamic> response) {
    return fromHeaders(response.headers) ??
        fromBody(response.data) ??
        fromSetCookieList(response.headers.map['set-cookie']);
  }

  static String? fromHeaders(Headers headers) {
    final values = headers.map['set-cookie'] ?? headers.map['Set-Cookie'];
    return fromSetCookieList(values);
  }

  static String? fromSetCookieList(List<String>? cookies) {
    if (cookies == null) return null;
    for (final raw in cookies) {
      final token = _parseCookieValue(raw);
      if (token != null) return token;
    }
    return null;
  }

  static String? fromBody(dynamic data) {
    if (data is! Map) return null;
    final map = Map<String, dynamic>.from(data);
    final nested = map['data'];
    if (nested is Map) {
      final token = nested['access_token'];
      if (token is String && token.isNotEmpty) return token;
    }
    final topLevel = map['access_token'];
    if (topLevel is String && topLevel.isNotEmpty) return topLevel;
    return null;
  }

  static String? _parseCookieValue(String raw) {
    final segments = raw.split(';');
    for (final segment in segments) {
      final trimmed = segment.trim();
      if (trimmed.startsWith('$cookieName=')) {
        final value = trimmed.substring(cookieName.length + 1);
        return value.isEmpty ? null : value;
      }
    }
    return null;
  }
}
