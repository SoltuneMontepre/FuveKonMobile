import 'package:country_picker/country_picker.dart';
import 'package:flutter/widgets.dart';

/// [country_picker] does not ship Vietnamese. Fall back to English country names
/// so `vi` locale does not trigger localization-delegate warnings.
class FallbackCountryLocalizationsDelegate
    extends LocalizationsDelegate<CountryLocalizations> {
  const FallbackCountryLocalizationsDelegate();

  static const delegate = FallbackCountryLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CountryLocalizations> load(Locale locale) {
    final packageLocale = CountryLocalizations.delegate.isSupported(locale)
        ? locale
        : const Locale('en');
    return CountryLocalizations.delegate.load(packageLocale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<CountryLocalizations> old) =>
      false;
}
