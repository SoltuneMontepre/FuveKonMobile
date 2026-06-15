import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Runtime config loaded from `.env` (see `.env.example`).
abstract final class AppConfig {
  static const String appName = 'Fuvekon';

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } on Object {
      // `.env` is optional for local dev; copy `.env.flutter.example` to `.env`.
    }
  }

  static String _read(String key, {String defaultValue = ''}) {
    final value = dotenv.env[key]?.trim();
    if (value != null && value.isNotEmpty) return value;
    return defaultValue;
  }

  /// Fuvekon general API: `https://api.fuve.vn/api/general/v1`
  static String get baseUrl =>
      _read('BASE_URL', defaultValue: 'https://api.fuve.vn/api/general/v1');

  /// Fuvekon Next.js site (used for non-API web assets if needed).
  static String get webBaseUrl =>
      _read('WEB_BASE_URL', defaultValue: 'https://fuve.vn');

  /// Google OAuth web client ID (`NEXT_PUBLIC_GOOGLE_CLIENT_ID` on Fuvekon web).
  static String get googleClientId => _read('GOOGLE_CLIENT_ID');

  static bool get hasGoogleSignIn => googleClientId.isNotEmpty;

  /// Optional LocalStack/S3 origin hint for docs/tooling (presigned URLs must be
  /// generated with a device-reachable host on the backend — see `.env.example`).
  static String get s3UploadEndpoint => _read('S3_UPLOAD_ENDPOINT');

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration uploadSendTimeout = Duration(minutes: 2);
}
