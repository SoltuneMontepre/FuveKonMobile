import 'package:flutter/material.dart';

class LocaleNotifier extends ChangeNotifier {
  LocaleNotifier({Locale? initialLocale})
    : _locale = initialLocale ?? const Locale('vi');

  Locale _locale;

  Locale get locale => _locale;

  void update(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }
}
