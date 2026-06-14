import 'package:fuvekonmobile/core/auth/user_role.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/foundation.dart';

class AuthSessionNotifier extends ChangeNotifier {
  AuthState _state = const AuthState.initial();
  UserRole? _role;
  bool? _isVerified;

  AuthState get state => _state;
  UserRole? get role => _role;
  bool? get isVerified => _isVerified;

  void update(AuthState state) {
    final roleChanged = _clearRoleIfLoggedOut(state);
    if (_state == state && !roleChanged) return;
    _state = state;
    notifyListeners();
  }

  void updateRole(UserRole? role) {
    if (_role == role) return;
    _role = role;
    notifyListeners();
  }

  void updateVerified(bool? isVerified) {
    if (_isVerified == isVerified) return;
    _isVerified = isVerified;
    notifyListeners();
  }

  bool _clearRoleIfLoggedOut(AuthState state) {
    final loggedOut = state is AuthUnauthenticated || state is AuthInitial;
    if (!loggedOut) return false;
    final hadSessionData = _role != null || _isVerified != null;
    _role = null;
    _isVerified = null;
    return hadSessionData;
  }

  bool get isAuthenticated =>
      _state is AuthAuthenticated || _state is AuthSessionRestored;

  String get homeRoute => _role?.homeRoute ?? Routes.home;

  bool get isAdmin => _role == UserRole.admin;
  bool get isStaff => _role == UserRole.staff;
}
