/// Country codes read as names in the reader's language.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/country_names.dart';
import 'package:outrepd/country_names.g.dart';
import 'package:outrepd/l10n/app_localizations.dart';

Future<String> _nameIn(WidgetTester tester, String lang, String code) async {
  late String name;
  await tester.pumpWidget(
    MaterialApp(
      locale: Locale(lang),
      localizationsDelegates: const [
        L.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L.supportedLocales,
      home: Builder(
        builder: (context) {
          name = countryName(context, code);
          return const SizedBox();
        },
      ),
    ),
  );
  return name;
}

void main() {
  testWidgets('a code reads in the reader\'s language', (tester) async {
    expect(await _nameIn(tester, 'fr', 'EG'), 'Égypte');
    expect(await _nameIn(tester, 'de', 'EG'), 'Ägypten');
    expect(await _nameIn(tester, 'en', 'eg'), 'Egypt');
  });

  testWidgets('something that is not a code is shown as it is', (
    tester,
  ) async {
    expect(await _nameIn(tester, 'fr', 'Egypt'), 'Egypt');
  });

  test('every app language has a name for every country English has', () {
    final english = kCountryNames['en']!.keys.toSet();
    for (final lang in L.supportedLocales.map((l) => l.languageCode)) {
      expect(kCountryNames[lang], isNotNull, reason: lang);
      expect(
        english.difference(kCountryNames[lang]!.keys.toSet()),
        isEmpty,
        reason: lang,
      );
    }
  });
}
