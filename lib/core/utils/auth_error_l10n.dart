import 'package:fuvekonmobile/core/utils/auth_messages.dart';
import 'package:fuvekonmobile/l10n/app_localizations.dart';

/// Resolves auth error keys (from [AuthBloc]) to localized copy.
String resolveAuthErrorMessage(AppLocalizations l10n, String message) {
  return switch (message) {
    'googleNotConfigured' => l10n.authGoogleNotConfigured,
    'googleUnsupportedPlatform' => l10n.authGoogleUnsupportedPlatform,
    'googleLoginFailed' => l10n.authGoogleLoginFailed,
    'googleDeveloperError' => l10n.authGoogleDeveloperError,
    'googleIdTokenMissing' => l10n.authGoogleIdTokenMissing,
    'invalidGoogleToken' => l10n.authGoogleLoginFailed,
    'googleRegistrationDetailsRequired' =>
      l10n.authGoogleRegistrationDetailsRequired,
    _ => authErrorMessage(message, fallback: message),
  };
}
