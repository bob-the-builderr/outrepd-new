/// A country's name in the reader's language, from the two-letter code an
/// account stores.
library;

import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/widgets.dart';

import 'country_names.g.dart';

/// [code] as the reader would say it: "Égypte" in French, "Ägypten" in German.
/// Falls back to English, and then to [code] itself, so a code nobody has a
/// name for, or an old row that already holds a name, still reads as
/// something.
String countryName(BuildContext context, String code) {
  final key = code.trim().toUpperCase();
  final lang = Localizations.localeOf(context).languageCode;
  return kCountryNames[lang]?[key] ?? kCountryNames['en']![key] ?? code;
}

/// Where this phone says it is, as a two-letter code, or null when it does
/// not say. What a new account starts with, until its lifter picks.
String? deviceCountryCode() {
  final code = PlatformDispatcher.instance.locale.countryCode;
  return (code == null || code.isEmpty) ? null : code.toUpperCase();
}

/// Every country to choose from, by code: the regions with names, less the
/// groupings and placeholders CLDR lists beside them.
final List<String> kCountryCodes = [
  for (final code in kCountryNames['en']!.keys)
    if (RegExp(r'^[A-Z]{2}$').hasMatch(code) &&
        !const {'EU', 'EZ', 'UN', 'QO', 'XA', 'XB', 'ZZ'}.contains(code))
      code,
];

/// The flag for [code], drawn by the phone's own emoji font.
String countryFlag(String code) => String.fromCharCodes([
  for (final unit in code.toUpperCase().codeUnits) 0x1F1E6 + unit - 0x41,
]);
