import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.started() = AuthStarted;
  const factory AuthEvent.loginSubmitted({
    required String email,
    required String password,
  }) = AuthLoginSubmitted;
  const factory AuthEvent.googleSignInRequested() = AuthGoogleSignInRequested;
  const factory AuthEvent.googleRegisterSubmitted({
    required String credential,
    required String fullName,
    required String nickname,
    required String dateOfBirth,
    required String country,
  }) = AuthGoogleRegisterSubmitted;
  const factory AuthEvent.googleRegistrationNavigated() =
      AuthGoogleRegistrationNavigated;
  const factory AuthEvent.logoutRequested() = AuthLogoutRequested;
  const factory AuthEvent.sessionExpired() = AuthSessionExpired;
}
