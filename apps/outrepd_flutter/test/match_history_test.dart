/// The match history: the record and the form first, then a line a match
/// under the day it was played.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/match_history.dart';
import 'package:outrepd/theme.dart';

Widget _app({double scale = 1, Locale locale = const Locale('en')}) =>
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
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(scale),
        ),
        child: child!,
      ),
      home: const MatchHistoryScreen(),
    );

MatchRecord _match(
  String who,
  int mine,
  int theirs,
  int lp, {
  int daysAgo = 0,
}) => MatchRecord(
  won: mine >= theirs,
  userReps: mine,
  opponentReps: theirs,
  opponent: who,
  lpChange: lp,
  at: DateTime.now().subtract(Duration(days: daysAgo)),
);

void main() {
  setUp(() {
    matchHistory
      ..clear()
      ..addAll([
        _match('karimfit', 18, 11, 7),
        _match('sara.lifts', 14, 19, -5),
        _match('aly99', 22, 20, 2, daysAgo: 1),
        _match('a_friend', 12, 9, 0, daysAgo: 1),
        _match('nour_x', 25, 12, 13, daysAgo: 3),
      ]);
  });
  tearDown(matchHistory.clear);

  testWidgets('the form, then a line a match under its day', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('historyForm')), findsOneWidget);
    expect(find.text('TODAY'), findsOneWidget);
    expect(find.text('YESTERDAY'), findsOneWidget);
    expect(find.text('18–11'), findsOneWidget);
    expect(find.text('+7'), findsOneWidget);
    // A loss in LP is a real minus sign, and a friendly match moved none.
    expect(find.text('−5'), findsOneWidget);
    expect(find.text('—'), findsOneWidget);
  });

  for (final (scale, locale) in [
    (1.6, const Locale('en')),
    (1.3, const Locale('de')),
    (1.3, const Locale('ru')),
  ]) {
    testWidgets('fits at ${scale}x in ${locale.languageCode}', (tester) async {
      await tester.pumpWidget(_app(scale: scale, locale: locale));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
