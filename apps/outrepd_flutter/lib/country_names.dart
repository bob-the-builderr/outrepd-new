/// A country's name in the reader's language, from the two-letter code an
/// account stores.
library;

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
