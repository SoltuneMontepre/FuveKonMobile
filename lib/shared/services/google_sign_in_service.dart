import 'package:fuvekonmobile/core/config/app_config.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Native Google Sign-In; returns an ID token for `POST /auth/google`.
class GoogleSignInService {
  GoogleSignInService()
      : _googleSignIn = GoogleSignIn(
          scopes: const ['email', 'profile'],
          serverClientId:
              AppConfig.hasGoogleSignIn ? AppConfig.googleClientId : null,
        );

  final GoogleSignIn _googleSignIn;

  bool get isAvailable => AppConfig.hasGoogleSignIn;

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
