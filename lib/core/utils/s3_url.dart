import 'package:fuvekonmobile/core/config/app_config.dart';

/// Mirrors Fuvekon web `getS3ProxyUrl` (`Fuvekon/src/utils/s3.ts`).
abstract final class S3Url {
  static bool isS3Url(String url) {
    try {
      final host = Uri.parse(url).host;
      return host.contains('s3') && host.contains('amazonaws.com');
    } catch (_) {
      return false;
    }
  }

  /// Extracts the object key from a full S3 HTTPS URL.
  static String? objectKeyFromUrl(String s3Url) {
    try {
      final key = Uri.parse(s3Url).path.replaceFirst(RegExp(r'^/'), '');
      return key.isEmpty ? null : key;
    } catch (_) {
      return null;
    }
  }

  /// Resolves an image URL for display. Private S3 objects are loaded via the
  /// general-service `/s3/image` proxy, which streams the object through the API.
  static String resolveImageUrl(String url) {
    final key = isS3Url(url)
        ? objectKeyFromUrl(url)
        : localStackObjectKeyFromUrl(url);
    if (key == null) return url;

    final base = AppConfig.baseUrl.replaceAll(RegExp(r'/$'), '');
    return '$base/s3/image?key=${Uri.encodeComponent(key)}';
  }

  /// Object key from a LocalStack-style URL: `http://host:4566/<bucket>/<key>`.
  static String? localStackObjectKeyFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.port != 4566) return null;
      if (uri.pathSegments.length < 2) return null;
      return uri.pathSegments.sublist(1).join('/');
    } catch (_) {
      return null;
    }
  }
}
