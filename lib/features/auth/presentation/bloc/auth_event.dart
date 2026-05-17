import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
sealed class AuthEvent with _$AuthEvent {
  const factory AuthEvent.started() = AuthStarted;
  const factory AuthEvent.loginSubmitted({
    required String email,
    required String password,
  }) = AuthLoginSubmitted;
  const factory AuthEvent.logoutRequested() = AuthLogoutRequested;
}
