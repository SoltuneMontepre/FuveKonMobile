import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuvekonmobile/features/auth/domain/entities/user.dart';

part 'auth_state.freezed.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated(User user) = AuthAuthenticated;
  const factory AuthState.sessionRestored() = AuthSessionRestored;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.googleRegistrationRequired(String credential) =
      AuthGoogleRegistrationRequired;
  const factory AuthState.failure(String message) = AuthFailure;
}
