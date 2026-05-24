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
    if (!isS3Url(url)) return url;

    final key = objectKeyFromUrl(url);
    if (key == null) return url;

    final base = AppConfig.baseUrl.replaceAll(RegExp(r'/$'), '');
    return '$base/s3/image?key=${Uri.encodeComponent(key)}';
  }
}
