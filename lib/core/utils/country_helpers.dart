import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

/// Resolves a stored country value (ISO-2 code or legacy full name) to [Country].
Country? countryFromStoredValue(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  return Country.tryParse(value.trim());
}

/// ISO-2 code to persist, or null when nothing is selected.
String? countryToStoredValue(Country? country) => country?.countryCode;

/// Human-readable label for display (flag + localized or English name).
String countryDisplayLabel(String? stored, {BuildContext? context}) {
  final trimmed = stored?.trim();
  if (trimmed == null || trimmed.isEmpty) return '';

  final country = countryFromStoredValue(trimmed);
  if (country == null) return trimmed;

  final name = context != null
      ? country.getTranslatedName(context) ?? country.name
      : country.name;
  return '${country.flagEmoji} $name';
}
