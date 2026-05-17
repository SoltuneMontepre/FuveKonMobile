import 'package:flutter/foundation.dart';
import 'package:fuvekonmobile/features/auth/presentation/bloc/auth_state.dart';

class AuthSessionNotifier extends ChangeNotifier {
  AuthState _state = const AuthState.initial();

  AuthState get state => _state;

  void update(AuthState state) {
    if (_state == state) return;
    _state = state;
    notifyListeners();
  }

  bool get isAuthenticated =>
      _state is AuthAuthenticated || _state is AuthSessionRestored;
}
