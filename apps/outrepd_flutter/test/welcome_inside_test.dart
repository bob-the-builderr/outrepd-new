/// The screen a brand-new account passes through on its way home: titles,
/// and its own friend code.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/rewards.dart';
import 'package:outrepd/screens/welcome_inside.dart';
import 'package:outrepd/theme.dart';

Widget _app(VoidCallback done, {Locale locale = const Locale('en')}) =>
    MaterialApp(
      theme: buildTheme(Brightness.dark),
      locale: locale,
      localizationsDelegates: const [
        L.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L.supportedLocales,
      home: WelcomeInsideScreen(onDone: (_) => done()),
    );

void main() {
  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  testWidgets('shows the titles and friends, and goes on', (tester) async {
    phone(tester);
    var done = false;
    await tester.pumpWidget(_app(() => done = true));
    await tester.pumpAndSettle();

    expect(find.text('${kTitles.length} titles to earn'), findsOneWidget);
    expect(find.text('Settle it with friends'), findsOneWidget);
    await tester.tap(find.text('Let’s go'));
    expect(done, isTrue);
  });

  for (final code in ['hi', 'de', 'ja']) {
    testWidgets('lays out in $code', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(() {}, locale: Locale(code)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
