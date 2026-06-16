import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AppPreferences {
  Future<bool> get onboardingCompleted;
  Future<void> setOnboardingCompleted(bool value);

  Future<bool> get introductionCompleted;
  Future<void> setIntroductionCompleted(bool value);

  Future<bool> get eventRulesAccepted;
  Future<void> setEventRulesAccepted(bool value);

  Future<String?> get languageCode;
  Future<void> setLanguageCode(String code);

  Future<ThemeMode> get themeMode;
  Future<void> setThemeMode(ThemeMode mode);
}

final class SharedAppPreferences implements AppPreferences {
  SharedAppPreferences(this._prefs);

  final SharedPreferences _prefs;

  static const _onboardingKey = 'onboarding_completed';
  static const _introductionKey = 'introduction_completed';
  static const _eventRulesKey = 'event_rules_accepted';
  static const _languageKey = 'language_code';
  static const _themeModeKey = 'theme_mode';

  static Future<SharedAppPreferences> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedAppPreferences(prefs);
  }

  @override
  Future<bool> get onboardingCompleted async =>
      _prefs.getBool(_onboardingKey) ?? false;

  @override
  Future<void> setOnboardingCompleted(bool value) async {
    await _prefs.setBool(_onboardingKey, value);
  }

  @override
  Future<bool> get introductionCompleted async =>
      _prefs.getBool(_introductionKey) ?? false;

  @override
  Future<void> setIntroductionCompleted(bool value) async {
    await _prefs.setBool(_introductionKey, value);
  }

  @override
  Future<bool> get eventRulesAccepted async =>
      _prefs.getBool(_eventRulesKey) ?? false;

  @override
  Future<void> setEventRulesAccepted(bool value) async {
    await _prefs.setBool(_eventRulesKey, value);
  }

  @override
  Future<String?> get languageCode async => _prefs.getString(_languageKey);

  @override
  Future<void> setLanguageCode(String code) async {
    await _prefs.setString(_languageKey, code);
  }

  @override
  Future<ThemeMode> get themeMode async {
    final saved = _prefs.getString(_themeModeKey);
    return saved == 'light' ? ThemeMode.light : ThemeMode.dark;
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    await _prefs.setString(
      _themeModeKey,
      mode == ThemeMode.light ? 'light' : 'dark',
    );
  }
}
