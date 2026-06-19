import 'package:flutter/foundation.dart';
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
  static String get baseUrl => _resolveDevApiHost(
        _read('BASE_URL', defaultValue: 'https://api.fuve.vn/api/general/v1'),
      );

  /// Maps dev loopback hosts per platform (Android emulator uses `10.0.2.2`).
  ///
  /// - `localhost` on Android → `10.0.2.2` (emulator → host PC)
  /// - `127.0.0.1` is left unchanged (physical device + `adb reverse`)
  /// - LAN IPs are left unchanged (physical device on Wi‑Fi)
  static String _resolveDevApiHost(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return url;

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      if (uri.host == 'localhost') {
        return uri.replace(host: '10.0.2.2').toString();
      }
      return url;
    }

    // `10.0.2.2` is Android-emulator-only; map to loopback on other platforms.
    if (uri.host == '10.0.2.2') {
      return uri.replace(host: 'localhost').toString();
    }

    return url;
  }

  /// Fuvekon Next.js site (used for non-API web assets if needed).
  static String get webBaseUrl => _resolveDevApiHost(
        _read('WEB_BASE_URL', defaultValue: 'https://fuve.vn'),
      );

  /// Google OAuth web client ID (`NEXT_PUBLIC_GOOGLE_CLIENT_ID` on Fuvekon web).
  static String get googleClientId => _read('GOOGLE_CLIENT_ID');

  static bool get hasGoogleSignIn => googleClientId.isNotEmpty;

  /// Optional LocalStack/S3 origin hint for docs/tooling (presigned URLs must be
  /// generated with a device-reachable host on the backend — see `.env.example`).
  static String get s3UploadEndpoint => _read('S3_UPLOAD_ENDPOINT');

  /// When true, ticket tiers/purchase/my-ticket use in-memory mock data (no API).
  /// Defaults to on in debug builds; set `MOCK_TICKET_MODE=false` to use real API.
  static bool get mockTicketMode {
    final raw = _read('MOCK_TICKET_MODE');
    if (raw.isNotEmpty) {
      final v = raw.toLowerCase();
      if (v == '0' || v == 'false' || v == 'no') return false;
      return v == '1' || v == 'true' || v == 'yes';
    }
    return kDebugMode;
  }

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration uploadSendTimeout = Duration(minutes: 2);
}
