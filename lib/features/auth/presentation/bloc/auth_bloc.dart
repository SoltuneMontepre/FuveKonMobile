import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuvekonmobile/core/config/app_config.dart';
import 'package:fuvekonmobile/core/errors/result.dart';
import 'package:fuvekonmobile/core/utils/auth_messages.dart';
import 'package:fuvekonmobile/features/auth/domain/entities/google_register_input.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/google_register_usecase.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/login_usecase.dart';
import 'package:fuvekonmobile/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_event.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:fuvekonmobile/shared/services/google_sign_in_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required GoogleLoginUseCase googleLoginUseCase,
    required GoogleRegisterUseCase googleRegisterUseCase,
    required GoogleSignInService googleSignInService,
    required LogoutUseCase logoutUseCase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
  }) : _loginUseCase = loginUseCase,
       _googleLoginUseCase = googleLoginUseCase,
       _googleRegisterUseCase = googleRegisterUseCase,
       _googleSignInService = googleSignInService,
       _logoutUseCase = logoutUseCase,
       _checkAuthStatusUseCase = checkAuthStatusUseCase,
       super(const AuthState.initial()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginSubmitted>(_onLoginSubmitted);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthGoogleRegisterSubmitted>(_onGoogleRegisterSubmitted);
    on<AuthGoogleRegistrationNavigated>(_onGoogleRegistrationNavigated);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthSessionExpired>(_onSessionExpired);
  }

  final LoginUseCase _loginUseCase;
  final GoogleLoginUseCase _googleLoginUseCase;
  final GoogleRegisterUseCase _googleRegisterUseCase;
  final GoogleSignInService _googleSignInService;
  final LogoutUseCase _logoutUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final isLoggedIn = await _checkAuthStatusUseCase();
    if (isLoggedIn) {
      emit(const AuthState.sessionRestored());
      return;
    }
    emit(const AuthState.unauthenticated());
  }

  Future<void> _onLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    final result = await _loginUseCase(
      email: event.email,
      password: event.password,
    );

    switch (result) {
      case Success(:final data):
        emit(AuthState.authenticated(data));
      case Error(:final failure):
        emit(AuthState.failure(authErrorMessage(failure.message)));
    }
  }

  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (!AppConfig.hasGoogleSignIn) {
      emit(const AuthState.failure('googleNotConfigured'));
      return;
    }

    if (!_googleSignInService.isAvailable) {
      emit(const AuthState.failure('googleUnsupportedPlatform'));
      return;
    }

    emit(const AuthState.loading());

    try {
      final idToken = await _googleSignInService.signInAndGetIdToken();
      if (idToken == null) {
        emit(const AuthState.unauthenticated());
        return;
      }

      final result = await _googleLoginUseCase(credential: idToken);
      switch (result) {
        case Success(:final data):
          emit(AuthState.authenticated(data));
        case Error(:final failure):
          if (failure.message == 'googleRegistrationDetailsRequired') {
            emit(AuthState.googleRegistrationRequired(idToken));
          } else {
            emit(AuthState.failure(failure.message));
          }
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        debugPrint('Google sign-in PlatformException: ${e.code} ${e.message}');
      }
      final key = GoogleSignInService.errorKeyFromPlatformException(e);
      if (key == null) {
        emit(const AuthState.unauthenticated());
        return;
      }
      emit(AuthState.failure(key));
    } on MissingPluginException {
      emit(const AuthState.failure('googleUnsupportedPlatform'));
    } catch (_) {
      emit(const AuthState.failure('googleLoginFailed'));
    }
  }

  Future<void> _onGoogleRegisterSubmitted(
    AuthGoogleRegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    final result = await _googleRegisterUseCase(
      GoogleRegisterInput(
        credential: event.credential,
        fullName: event.fullName,
        nickname: event.nickname,
        dateOfBirth: event.dateOfBirth,
        country: event.country,
      ),
    );

    switch (result) {
      case Success(:final data):
        emit(AuthState.authenticated(data));
      case Error(:final failure):
        emit(AuthState.failure(authErrorMessage(failure.message)));
    }
  }

  void _onGoogleRegistrationNavigated(
    AuthGoogleRegistrationNavigated event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthState.unauthenticated());
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    await _logoutUseCase();
    emit(const AuthState.unauthenticated());
  }

  Future<void> _onSessionExpired(
    AuthSessionExpired event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthUnauthenticated || state is AuthInitial) return;
    await _logoutUseCase();
    emit(const AuthState.unauthenticated());
  }
}
