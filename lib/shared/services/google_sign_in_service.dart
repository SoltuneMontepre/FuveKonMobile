import 'package:fuvekonmobile/core/config/app_config.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Native / web Google Sign-In; returns an ID token for `POST /auth/google`.
///
/// [GoogleSignIn] is created lazily so the app can start on web when
/// [AppConfig.hasGoogleSignIn] is false (no `GOOGLE_CLIENT_ID` in `.env`).
class GoogleSignInService {
  GoogleSignIn? _instance;

  bool get isAvailable => AppConfig.hasGoogleSignIn;

  GoogleSignIn get _googleSignIn {
    if (!isAvailable) {
      throw StateError(
        'Google Sign-In is not configured. Set GOOGLE_CLIENT_ID in .env.',
      );
    }
    return _instance ??= GoogleSignIn(
      scopes: const ['email', 'profile'],
      // Web requires [clientId]; mobile uses [serverClientId] for ID tokens.
      clientId: AppConfig.googleClientId,
      serverClientId: AppConfig.googleClientId,
    );
  }

  /// Returns a Google ID token, or `null` if the user cancelled.
  Future<String?> signInAndGetIdToken() async {
    if (!isAvailable) return null;

    // Avoid stale account picking the wrong profile on repeat sign-in.
    await _googleSignIn.signOut();

    final account = await _googleSignIn.signIn();
    if (account == null) return null;

    final auth = await account.authentication;
    final idToken = auth.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw StateError('Google Sign-In did not return an ID token.');
    }
    return idToken;
  }
}
