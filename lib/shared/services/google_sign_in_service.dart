import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fuvekonmobile/core/config/app_config.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Native / web Google Sign-In; returns an ID token for `POST /auth/google`.
///
/// Supported: Android, iOS, macOS, Web — **not** Linux or Windows desktop.
class GoogleSignInService {
  GoogleSignIn? _instance;

  static bool get isPlatformSupported {
    if (kIsWeb) return true;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return true;
      case TargetPlatform.linux:
      case TargetPlatform.windows:
      case TargetPlatform.fuchsia:
        return false;
    }
  }

  bool get isAvailable => AppConfig.hasGoogleSignIn && isPlatformSupported;

  GoogleSignIn get _googleSignIn {
    if (!AppConfig.hasGoogleSignIn) {
      throw StateError(
        'Google Sign-In is not configured. Set GOOGLE_CLIENT_ID in .env.',
      );
    }
    if (!isPlatformSupported) {
      throw UnsupportedError('Google Sign-In is not supported on this platform.');
    }

    return _instance ??= GoogleSignIn(
      scopes: const ['email', 'profile'],
      // Web + Apple need [clientId]; Android uses [serverClientId] for ID tokens.
      clientId: kIsWeb ||
              defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS
          ? AppConfig.googleClientId
          : null,
      serverClientId: AppConfig.googleClientId,
    );
  }

  /// Returns a Google ID token, or `null` if the user cancelled.
  Future<String?> signInAndGetIdToken() async {
    if (!isAvailable) return null;

    await _googleSignIn.signOut();

    final account = await _googleSignIn.signIn();
    if (account == null) return null;

    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw PlatformException(
        code: 'id_token_missing',
        message:
            'Google did not return an ID token. Check GOOGLE_CLIENT_ID (Web client) '
            'and Android OAuth setup (SHA-1 + package com.example.fuvekonmobile).',
      );
    }
    return idToken;
  }

  /// Maps [PlatformException] from Google Sign-In to app error keys.
  static String? errorKeyFromPlatformException(PlatformException e) {
    if (e.code == 'sign_in_canceled' || e.code == '12501') return null;

    final message = e.message ?? '';
    if (e.code == 'id_token_missing') return 'googleIdTokenMissing';
    if (e.code == 'sign_in_failed' &&
        (message.contains('10') ||
            message.contains('DEVELOPER_ERROR') ||
            message.contains('ApiException: 10'))) {
      return 'googleDeveloperError';
    }
    return 'googleLoginFailed';
  }
}
