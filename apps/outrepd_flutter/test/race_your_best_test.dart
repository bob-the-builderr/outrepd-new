/// With nobody near your rank free, a duel races your own best, not a
/// made-up opponent.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/match_flow.dart';
import 'package:outrepd/theme.dart';

Widget _app({Locale locale = const Locale('en')}) => MaterialApp(
  theme: buildTheme(Brightness.dark),
  locale: locale,
  localizationsDelegates: const [
    L.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: L.supportedLocales,
  home: const MatchFlowScreen(),
);

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  late int bestWas;
  setUp(() => bestWas = demoProfile.bestSet);
  tearDown(() => demoProfile.bestSet = bestWas);

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  /// Past the search, which waits a random 2.2 to 5.6 seconds, and onto the
  /// versus screen, which stays for 1.5 before the camera opens. Stepped, so
  /// the test stops on it whatever the wait turned out to be.
  Future<void> toVersus(WidgetTester tester, {String vs = 'VS'}) async {
    await tester.pump();
    for (var i = 0; i < 60 && find.text(vs).evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(find.text(vs), findsOneWidget);
  }

  /// Gone before the camera opens, so no timer is left running.
  Future<void> leave(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
  }

  testWidgets('the other side is your best, and it says so', (tester) async {
    phone(tester);
    demoProfile.bestSet = 24;
    await tester.pumpWidget(_app());
    await toVersus(tester);

    expect(find.text('Your best'), findsOneWidget);
    expect(find.text('24'), findsOneWidget);
    expect(find.textContaining('Race your best instead'), findsOneWidget);
    expect(find.textContaining("doesn't move your rank"), findsOneWidget);
    for (final o in demoOpponents) {
      expect(find.text(o.username), findsNothing);
    }
    expect(tester.takeException(), isNull);
    await leave(tester);
  });

  testWidgets('with no best yet, it is only the clock', (tester) async {
    phone(tester);
    demoProfile.bestSet = 0;
    await tester.pumpWidget(_app());
    await toVersus(tester);

    expect(find.text('The clock'), findsOneWidget);
    expect(find.textContaining('Set your first score'), findsOneWidget);
    await leave(tester);
  });

  for (final code in ['hi', 'de', 'ja']) {
    testWidgets('lays out in $code', (tester) async {
      phone(tester);
      demoProfile.bestSet = 31;
      await tester.pumpWidget(_app(locale: Locale(code)));
      await toVersus(tester, vs: code == 'hi' ? 'बनाम' : 'VS');
      expect(tester.takeException(), isNull);
      await leave(tester);
    });
  }
}
