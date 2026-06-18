import 'package:fuvekonmobile/core/auth/user_permissions.dart';
import 'package:fuvekonmobile/core/auth/user_role.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/foundation.dart';

class AuthSessionNotifier extends ChangeNotifier {
  AuthState _state = const AuthState.initial();
  UserRole? _role;
  bool? _isVerified;
  List<String> _permissions = const [];

  AuthState get state => _state;
  UserRole? get role => _role;
  bool? get isVerified => _isVerified;
  List<String> get permissions => _permissions;

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

  void updatePermissions(List<String> permissions) {
    if (listEquals(_permissions, permissions)) return;
    _permissions = permissions;
    notifyListeners();
  }

  bool _clearRoleIfLoggedOut(AuthState state) {
    final loggedOut = state is AuthUnauthenticated || state is AuthInitial;
    if (!loggedOut) return false;
    final hadSessionData =
        _role != null || _isVerified != null || _permissions.isNotEmpty;
    _role = null;
    _isVerified = null;
    _permissions = const [];
    return hadSessionData;
  }

  bool get isAuthenticated =>
      _state is AuthAuthenticated || _state is AuthSessionRestored;

  String get homeRoute {
    final roleHome = _role?.homeRoute;
    if (roleHome != null) return roleHome;
    return isAuthenticated ? Routes.account : Routes.home;
  }

  bool get isAdmin => _role == UserRole.admin;
  bool get isStaff => _role == UserRole.staff;

  bool hasPermission(String code) {
    if (isAdmin) return true;
    return _permissions.contains(code);
  }

  bool canAccessAdminRoute(String location) {
    final currentRole = _role;
    if (currentRole == null || !currentRole.isPrivileged) return false;
    if (isAdmin) return true;

    final required = UserPermissions.requiredForRoute(location);
    if (required == null) return true;
    return hasPermission(required);
  }
}
