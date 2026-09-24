/// The three screens a duel ends on.
///
/// The one thing that must never be wrong here is the arithmetic on the LP
/// card: a breakdown that does not add up to the number beside it turns the
/// most-read screen in the app into a reason to distrust the rest of it.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/career.dart';
import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/ranking.dart';
import 'package:outrepd/screens/post_match.dart';
import 'package:outrepd/theme.dart';

Widget _app(
  Widget home, {
  Locale locale = const Locale('en'),
  double scale = 1.0,
}) =>
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
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        minScaleFactor: scale,
        maxScaleFactor: scale,
        child: child!,
      ),
      home: Scaffold(body: home),
    );

/// Every number on screen that could be an LP row or a total.
List<int> _signedNumbers(WidgetTester tester) {
  final out = <int>[];
  for (final text in tester.widgetList<Text>(find.byType(Text))) {
    final data = text.data;
    if (data == null) continue;
    final match = RegExp(r'^([+−-])(\d+)').firstMatch(data.trim());
    if (match == null) continue;
    final value = int.parse(match.group(2)!);
    out.add(match.group(1) == '+' ? value : -value);
  }
  return out;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  void phone(WidgetTester tester, {Size size = const Size(400, 900)}) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  DuelResultView view({required bool won}) => DuelResultView(
        won: won,
        yourReps: won ? 18 : 14,
        theirReps: won ? 11 : 19,
        opponent: demoOpponents.first,
        outcome: demoOutcome(won: won),
        onRematch: () {},
        onDone: () {},
      );

  group('the LP card', () {
    testWidgets('the rows add up to the total', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(view(won: true)));
      await tester.pumpAndSettle();

      final outcome = demoOutcome(won: true);
      final total = outcome.rank!.lpDelta;
      final parts = outcome.breakdown!;

      // The header, then every non-zero row.
      final numbers = _signedNumbers(tester);
      expect(numbers.first.abs(), total.abs(),
          reason: 'the headline is not the total');

      final rows = numbers.skip(1).toList();
      expect(rows.fold<int>(0, (a, b) => a + b), total,
          reason: 'the rows on screen sum to something else: $rows');
      expect(rows.length, [parts.result, parts.tierGap, parts.margin, parts.form]
          .where((p) => p != 0)
          .length);
    });

    test('a loss is itemised the same way', () {
      final outcome = demoOutcome(won: false);
      final parts = outcome.breakdown!;
      expect(parts.total, outcome.rank!.lpDelta);
      expect(parts.result, lessThan(0));
    });

    testWidgets('rows that did nothing are not shown', (tester) async {
      phone(tester);
      // Level opponent, one rep in it, depth not held: only the result itself
      // moved. Three rows of zero would read as three rules broken.
      final parts = lpFor(
        won: true,
        yourTier: 3,
        theirTier: 3,
        yourReps: 11,
        theirReps: 10,
        clean: false,
      );
      expect(parts.tierGap, 0);
      expect(parts.margin, 0);
      expect(parts.form, 0);

      await tester.pumpWidget(_app(DuelResultView(
        won: true,
        yourReps: 11,
        theirReps: 10,
        opponent: demoOpponents.first,
        outcome: DuelOutcome(
          won: true,
          rank: applyLp(
            const Rank(tierIdx: 3, divIdx: 2, lp: 40),
            parts.total,
            floorTierIdx: 3,
          ),
          breakdown: parts,
          record: MatchRecord(
            won: true,
            userReps: 11,
            opponentReps: 10,
            opponent: 'x',
            lpChange: parts.total,
            at: DateTime.now(),
          ),
          placementsFinished: false,
          newBest: false,
        ),
        onRematch: () {},
        onDone: () {},
      )));
      await tester.pumpAndSettle();

      // The headline and one row.
      expect(_signedNumbers(tester).length, 2);
    });
  });

  group('the screens lay out', () {
    for (final won in [true, false]) {
      for (final scale in [1.0, 1.6]) {
        testWidgets('${won ? 'a win' : 'a loss'} at ${scale}x', (tester) async {
          phone(tester, size: const Size(360, 640));
          await tester.pumpWidget(_app(view(won: won), scale: scale));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        });
      }
    }

    for (final code in ['ar', 'de', 'ja']) {
      testWidgets('a win in $code', (tester) async {
        phone(tester, size: const Size(360, 640));
        await tester.pumpWidget(
          _app(view(won: true), locale: Locale(code), scale: 1.3),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('a promotion, in Arabic at 1.6x', (tester) async {
      phone(tester, size: const Size(360, 640));
      await tester.pumpWidget(_app(
        PromotionView(
          tierIdx: 3,
          divIdx: 2,
          highest: true,
          onContinue: () {},
        ),
        locale: const Locale('ar'),
        scale: 1.6,
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('the loss note', () {
    testWidgets('says how far off it was', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(view(won: false)));
      await tester.pumpAndSettle();
      expect(find.textContaining('5'), findsWidgets);
    });

    testWidgets('only claims the closest match when it is one', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(view(won: false)));
      await tester.pumpAndSettle();
      // Nothing in the history to be closer than, so the app does not say it.
      expect(find.textContaining('Closest'), findsNothing);
    });
  });
}
