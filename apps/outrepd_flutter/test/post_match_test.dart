/// The three screens a duel ends on.
///
/// The one thing that must never be wrong here is the arithmetic on the LP
/// card: the headline is the only number it shows now, and it has to be
/// exactly the rank change or the most-read screen in the app is lying about
/// the one thing it exists to report.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/career.dart';
import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/post_match.dart';
import 'package:outrepd/theme.dart';

Widget _app(
  Widget home, {
  Locale locale = const Locale('en'),
  double scale = 1.0,
}) => MaterialApp(
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

  DuelResultView view({
    required bool won,
    bool newBest = false,
    bool closestYet = false,
  }) => DuelResultView(
    won: won,
    yourReps: won ? 18 : 14,
    theirReps: won ? 11 : 19,
    opponent: demoOpponents.first,
    outcome: demoOutcome(won: won, newBest: newBest),
    onRematch: () {},
    onDone: () {},
    closestYet: closestYet,
  );

  group('the LP card', () {
    testWidgets('the headline is exactly the rank change', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(view(won: true)));
      await tester.pumpAndSettle();

      final outcome = demoOutcome(won: true);
      final total = outcome.rank!.lpDelta;

      // There is nothing left to itemise into rows — LP is exactly the rep
      // gap now, which the two scores above the card already say — so the
      // headline is the only signed number this card ever shows.
      final numbers = _signedNumbers(tester);
      expect(numbers, [total]);
    });

    testWidgets('a loss reads the same way', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(view(won: false)));
      await tester.pumpAndSettle();

      final outcome = demoOutcome(won: false);
      final total = outcome.rank!.lpDelta;
      expect(total, lessThan(0));
      expect(_signedNumbers(tester), [total]);
    });
  });

  testWidgets("the month's move draws its arrow rather than typing it",
      (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(DuelResultView(
      won: true,
      yourReps: 18,
      theirReps: 11,
      opponent: demoOpponents.first,
      outcome: demoOutcome(won: true),
      onRematch: () {},
      onDone: () {},
      monthBefore: 14,
      monthAfter: 11,
    )));
    await tester.pumpAndSettle();
    final line = find.byKey(const Key('monthMove'));
    expect(line, findsOneWidget);
    expect(
      find.descendant(of: line, matching: find.byIcon(Icons.arrow_forward_rounded)),
      findsOneWidget,
    );
    expect(find.textContaining('#14', findRichText: true), findsOneWidget);
    expect(find.textContaining('#11', findRichText: true), findsOneWidget);
  });

  group("today's goal", () {
    DuelResultView passing({required int before, required int after}) {
      final o = demoOutcome(won: true);
      return DuelResultView(
        won: true,
        yourReps: after - before,
        theirReps: 11,
        opponent: demoOpponents.first,
        outcome: DuelOutcome(
          won: true,
          rank: o.rank,
          record: o.record,
          placementsFinished: false,
          newBest: false,
          todayBefore: before,
          todayAfter: after,
        ),
        onRematch: () {},
        onDone: () {},
      );
    }

    testWidgets('the duel that meets it says so', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(passing(before: 40, after: 58)));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('goalDone')), findsOneWidget);
      expect(find.text('58 / 50 push-ups'), findsOneWidget);
    });

    testWidgets('a duel after it, the same day, does not', (tester) async {
      // Met once a day: every match after it that evening would otherwise
      // say the same thing again.
      phone(tester);
      await tester.pumpWidget(_app(passing(before: 58, after: 76)));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('goalDone')), findsNothing);
    });

    testWidgets('a duel short of it does not', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(passing(before: 10, after: 28)));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('goalDone')), findsNothing);
    });

    testWidgets('fits a small phone at 1.6x with the card', (tester) async {
      phone(tester, size: const Size(360, 640));
      await tester.pumpWidget(
        _app(passing(before: 40, after: 58), scale: 1.6),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
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

    for (final code in ['hi', 'de', 'ja']) {
      testWidgets('a win in $code', (tester) async {
        phone(tester, size: const Size(360, 640));
        await tester.pumpWidget(
          _app(view(won: true), locale: Locale(code), scale: 1.3),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('a promotion, in Hindi at 1.6x', (tester) async {
      phone(tester, size: const Size(360, 640));
      await tester.pumpWidget(
        _app(
          PromotionView(
            tierIdx: 3,
            divIdx: 2,
            highest: true,
            onContinue: () {},
          ),
          locale: const Locale('hi'),
          scale: 1.6,
        ),
      );
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

  group('the scoreboard', () {
    testWidgets('a win says the margin and marks you the winner', (
      tester,
    ) async {
      phone(tester);
      await tester.pumpWidget(_app(view(won: true)));
      await tester.pumpAndSettle();

      expect(find.text('7 reps ahead.'), findsOneWidget);
      expect(find.text('18'), findsOneWidget);
      expect(find.text('11'), findsOneWidget);
      // Both halves carry the label so the scores stay level; only the
      // winner's is shown.
      final shown = tester
          .widgetList<Visibility>(find.byType(Visibility))
          .where((v) => v.visible)
          .length;
      expect(shown, 1);
    });

    testWidgets('a new best gets its chip, and only then', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(view(won: true)));
      await tester.pumpAndSettle();
      expect(find.textContaining('New personal best'), findsNothing);

      await tester.pumpWidget(_app(view(won: true, newBest: true)));
      await tester.pumpAndSettle();
      expect(find.textContaining('New personal best'), findsOneWidget);
    });

    testWidgets('the closest loss is a chip under the scores', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(view(won: false, closestYet: true)));
      await tester.pumpAndSettle();
      expect(find.text('5 reps off.'), findsOneWidget);
      expect(find.text('Closest match yet.'), findsOneWidget);
    });
  });

  group('the LP bar', () {
    testWidgets('every layer is drawn at the bar\'s full height', (
      tester,
    ) async {
      phone(tester);
      await tester.pumpWidget(_app(view(won: true)));
      await tester.pumpAndSettle();

      final layers = find.descendant(
        of: find.byType(LpCard),
        matching: find.byType(ColoredBox),
      );
      // Track, fill, and the stretch this win added.
      expect(layers, findsNWidgets(3));
      for (final el in layers.evaluate()) {
        expect((el.renderObject! as RenderBox).size.height, 8);
      }
    });

    testWidgets('the fill starts where the bar starts', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(view(won: true)));
      await tester.pumpAndSettle();

      final layers = find
          .descendant(
            of: find.byType(LpCard),
            matching: find.byType(ColoredBox),
          )
          .evaluate()
          .toList();
      final track = tester.getTopLeft(find.byWidget(layers[0].widget));
      final fill = tester.getTopLeft(find.byWidget(layers[1].widget));
      expect(fill.dx, track.dx);
    });
  });

  testWidgets('the primary button text can be read on its fill', (
    tester,
  ) async {
    phone(tester);
    await tester.pumpWidget(_app(view(won: true)));
    await tester.pumpAndSettle();

    final context = tester.element(find.text('Rematch'));
    final style = Theme.of(context).filledButtonTheme.style!;
    final fg = style.foregroundColor!.resolve({})!;
    final bg = style.backgroundColor!.resolve({})!;
    double lum(Color c) => c.computeLuminance();
    final hi = lum(fg) > lum(bg) ? lum(fg) : lum(bg);
    final lo = lum(fg) > lum(bg) ? lum(bg) : lum(fg);
    // WCAG AA for large bold text.
    expect((hi + 0.05) / (lo + 0.05), greaterThanOrEqualTo(3));
  });
}
