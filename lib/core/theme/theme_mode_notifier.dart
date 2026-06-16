import 'package:flutter/material.dart';
import 'package:fuvekonmobile/core/di/injection.dart';
import 'package:fuvekonmobile/shared/services/app_preferences.dart';

class ThemeModeNotifier extends ChangeNotifier {
  ThemeModeNotifier({ThemeMode initialMode = ThemeMode.dark})
      : _themeMode = initialMode;

  ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  bool get isDark => _themeMode == ThemeMode.dark;

  void update(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  Future<void> toggle() async {
    final next = isDark ? ThemeMode.light : ThemeMode.dark;
    update(next);
    await sl<AppPreferences>().setThemeMode(next);
  }
}
