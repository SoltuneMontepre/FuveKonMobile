import 'package:fuvekonmobile/core/auth/user_permissions.dart';
import 'package:fuvekonmobile/core/auth/user_role.dart';
import 'package:fuvekonmobile/core/router/routes.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/foundation.dart';

enum SessionHydrationStatus { idle, loading, success, failure }

class AuthSessionNotifier extends ChangeNotifier {
  AuthState _state = const AuthState.initial();
  UserRole? _role;
  bool? _isVerified;
  List<String> _permissions = const [];
  SessionHydrationStatus _hydrationStatus = SessionHydrationStatus.idle;
  String? _hydrationError;

  AuthState get state => _state;
  UserRole? get role => _role;
  bool? get isVerified => _isVerified;
  List<String> get permissions => _permissions;
  SessionHydrationStatus get hydrationStatus => _hydrationStatus;
  String? get hydrationError => _hydrationError;

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

  void resetHydration() {
    if (_hydrationStatus == SessionHydrationStatus.idle &&
        _hydrationError == null) {
      return;
    }
    _hydrationStatus = SessionHydrationStatus.idle;
    _hydrationError = null;
    notifyListeners();
  }

  void beginHydration() {
    if (_hydrationStatus == SessionHydrationStatus.loading) return;
    _hydrationStatus = SessionHydrationStatus.loading;
    _hydrationError = null;
    notifyListeners();
  }

  void completeHydration({required bool success, String? error}) {
    final nextStatus =
        success ? SessionHydrationStatus.success : SessionHydrationStatus.failure;
    if (_hydrationStatus == nextStatus && _hydrationError == error) return;
    _hydrationStatus = nextStatus;
    _hydrationError = error;
    notifyListeners();
  }

  /// Applies hydrated profile fields in a single listener notification.
  void applyHydrationProfile({
    required UserRole? role,
    required bool? isVerified,
    required List<String> permissions,
    required bool success,
    String? error,
  }) {
    final nextStatus =
        success ? SessionHydrationStatus.success : SessionHydrationStatus.failure;
    final changed = _role != role ||
        _isVerified != isVerified ||
        !listEquals(_permissions, permissions) ||
        _hydrationStatus != nextStatus ||
        _hydrationError != error;
    if (!changed) return;
    _role = role;
    _isVerified = isVerified;
    _permissions = permissions;
    _hydrationStatus = nextStatus;
    _hydrationError = error;
    notifyListeners();
  }

  void clearHydrationProfile() {
    final changed = _role != null ||
        _isVerified != null ||
        _permissions.isNotEmpty ||
        _hydrationStatus != SessionHydrationStatus.idle ||
        _hydrationError != null;
    if (!changed) return;
    _role = null;
    _isVerified = null;
    _permissions = const [];
    _hydrationStatus = SessionHydrationStatus.idle;
    _hydrationError = null;
    notifyListeners();
  }

  bool _clearRoleIfLoggedOut(AuthState state) {
    final loggedOut = state is AuthUnauthenticated || state is AuthInitial;
    if (!loggedOut) return false;
    final hadSessionData = _role != null ||
        _isVerified != null ||
        _permissions.isNotEmpty ||
        _hydrationStatus != SessionHydrationStatus.idle ||
        _hydrationError != null;
    _role = null;
    _isVerified = null;
    _permissions = const [];
    _hydrationStatus = SessionHydrationStatus.idle;
    _hydrationError = null;
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

/// Notifies [GoRouter] only when redirect-relevant session fields change.
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(this._session) {
    _authState = _session.state;
    _role = _session.role;
    _isVerified = _session.isVerified;
    _hydrationStatus = _session.hydrationStatus;
    _permissions = List<String>.from(_session.permissions);
    _session.addListener(_onSessionChanged);
  }

  final AuthSessionNotifier _session;
  late AuthState _authState;
  UserRole? _role;
  bool? _isVerified;
  late SessionHydrationStatus _hydrationStatus;
  late List<String> _permissions;

  void _onSessionChanged() {
    final authChanged = _session.state != _authState;
    final roleChanged = _session.role != _role;
    final verifiedChanged = _session.isVerified != _isVerified;
    final hydrationChanged = _session.hydrationStatus != _hydrationStatus;
    final permissionsChanged =
        !listEquals(_session.permissions, _permissions);

    _authState = _session.state;
    _role = _session.role;
    _isVerified = _session.isVerified;
    _hydrationStatus = _session.hydrationStatus;
    _permissions = List<String>.from(_session.permissions);

    if (authChanged ||
        roleChanged ||
        verifiedChanged ||
        hydrationChanged ||
        permissionsChanged) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _session.removeListener(_onSessionChanged);
    super.dispose();
  }
}
