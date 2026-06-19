/// Maps Fuvekon API `errorMessage` keys to user-facing copy (web `auth` namespace).
String authErrorMessage(String? key, {String fallback = 'Something went wrong.'}) {
  if (key == null || key.isEmpty) return fallback;
  return switch (key) {
    'invalidEmailOrPassword' => 'Invalid email or password.',
    'accountLocked' => 'Too many failed attempts. Try again later.',
    'userNotVerified' => 'Please verify your email before signing in.',
    'accountBanned' => 'This account has been banned.',
    'registerFailed' => 'Registration failed. Please try again.',
    'forgotPasswordFailed' =>
      'Could not send reset email. Please try again.',
    'resetPasswordConfirmFailed' =>
      'Could not reset password. The link may have expired.',
    'verifyOtpFailed' => 'Invalid or expired code. Please try again.',
    'emailAlreadyExists' => 'An account with this email already exists.',
    'userExists' => 'An account with this email already exists.',
    'googleLoginFailed' => 'Google sign-in failed. Please try again.',
    'googleNotConfigured' =>
      'Google sign-in is not available. Please use email and password.',
    'googleRegistrationDetailsRequired' =>
      'Please complete registration with your details first.',
    'invalidGoogleToken' => 'Invalid Google sign-in. Please try again.',
    _ => key.contains('.') || key.contains(' ') ? key : fallback,
  };
}
