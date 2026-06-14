import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AppPreferences {
  Future<bool> get onboardingCompleted;
  Future<void> setOnboardingCompleted(bool value);

  Future<String?> get languageCode;
  Future<void> setLanguageCode(String code);
}

final class SharedAppPreferences implements AppPreferences {
  SharedAppPreferences(this._prefs);

  final SharedPreferences _prefs;

  static const _onboardingKey = 'onboarding_completed';
  static const _languageKey = 'language_code';

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
  Future<String?> get languageCode async => _prefs.getString(_languageKey);

  @override
  Future<void> setLanguageCode(String code) async {
    await _prefs.setString(_languageKey, code);
  }
}
