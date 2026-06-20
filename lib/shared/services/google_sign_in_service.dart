import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:fuvekonmobile/core/config/app_config.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Native / web Google Sign-In; returns an ID token for `POST /auth/google`.
///
/// Supported: Android, iOS, macOS, Web — **not** Linux or Windows desktop.
class GoogleSignInService {
  final GoogleSignIn _instance = GoogleSignIn.instance;
  Future<void>? _initializeFuture;

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
      throw UnsupportedError(
        'Google Sign-In is not supported on this platform.',
      );
    }

    return _instance;
  }

  Future<void> _ensureInitialized() {
    return _initializeFuture ??= _googleSignIn.initialize(
      // Web + Apple need [clientId]; Android uses [serverClientId] for ID tokens.
      clientId:
          kIsWeb ||
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

    await _ensureInitialized();
    final GoogleSignInAccount account;
    try {
      account = await _googleSignIn.authenticate(
        scopeHint: const ['email', 'profile'],
      );
    } on GoogleSignInException catch (e) {
      final mapped = _mapGoogleSignInException(e);
      if (mapped == null) {
        return null;
      }
      throw mapped;
    }

    final auth = account.authentication;
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

  /// Maps native [GoogleSignInException] to [PlatformException], or `null` if the
  /// user explicitly cancelled on platforms where that is reliable.
  static PlatformException? _mapGoogleSignInException(GoogleSignInException e) {
    if (e.code == GoogleSignInExceptionCode.canceled ||
        e.code == GoogleSignInExceptionCode.interrupted) {
      // Credential Manager often reports OAuth misconfiguration as "canceled"
      // (see google_sign_in_android troubleshooting). Treat as config error on Android.
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        return PlatformException(
          code: GoogleSignInExceptionCode.clientConfigurationError.name,
          message:
              e.description ??
              'Android Credential Manager sign-in failed. Verify GOOGLE_CLIENT_ID '
                  '(Web client) and Android OAuth client (package + SHA-1).',
        );
      }
      return null;
    }

    if (!kIsWeb &&
        defaultTargetPlatform == TargetPlatform.android &&
        (e.code == GoogleSignInExceptionCode.unknownError ||
            e.code == GoogleSignInExceptionCode.providerConfigurationError)) {
      return PlatformException(
        code: GoogleSignInExceptionCode.clientConfigurationError.name,
        message: e.description,
      );
    }

    return PlatformException(code: e.code.name, message: e.description);
  }

  /// Maps [PlatformException] from Google Sign-In to app error keys.
  static String? errorKeyFromPlatformException(PlatformException e) {
    if (e.code == 'sign_in_canceled' ||
        e.code == '12501' ||
        e.code == GoogleSignInExceptionCode.canceled.name ||
        e.code == GoogleSignInExceptionCode.interrupted.name) {
      return null;
    }

    final message = e.message ?? '';
    if (e.code == GoogleSignInExceptionCode.clientConfigurationError.name ||
        e.code == GoogleSignInExceptionCode.providerConfigurationError.name) {
      return 'googleDeveloperError';
    }
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
