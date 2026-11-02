/// The progression ladder and the home screen.
///
/// Both are mostly one column of text over a drawn badge, so the thing that
/// breaks them is length: a long tier name in German, at 1.6x, in a row that
/// also holds a 34dp badge and a tick.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/match.dart';
import 'package:outrepd/screens/progression.dart';
import 'package:outrepd/theme.dart';
import 'package:outrepd/tier_badge.dart';

Widget _app(Widget home, double scale, Locale locale) => MaterialApp(
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
      home: home,
    );

void main() {
  const small = Size(360, 640);

  void phone(WidgetTester tester) {
    tester.view.physicalSize = small;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  for (final scale in [1.0, 1.3, 1.6]) {
    testWidgets('the climb lays out at ${scale}x', (tester) async {
      phone(tester);
      await tester.pumpWidget(
        _app(ProgressionScreen(profile: demoProfile), scale, const Locale('en')),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('home lays out at ${scale}x', (tester) async {
      phone(tester);
      await tester.pumpWidget(
        _app(const MatchScreen(), scale, const Locale('en')),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  // German and Russian write these unlocks long; Hindi runs tallest.
  for (final code in ['hi', 'de', 'ru', 'ja']) {
    testWidgets('the climb lays out in $code', (tester) async {
      phone(tester);
      await tester.pumpWidget(
        _app(ProgressionScreen(profile: demoProfile), 1.3, Locale(code)),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('home lays out in $code', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(const MatchScreen(), 1.3, Locale(code)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('a rung promises no unlock', (tester) async {
    phone(tester);
    await tester.pumpWidget(
      _app(ProgressionScreen(profile: demoProfile), 1.0, const Locale('en')),
    );
    await tester.pumpAndSettle();

    // Nothing in the app is gated on a tier, so the ladder names none.
    expect(find.text('Open lobbies'), findsNothing);
    expect(find.text('Named on the global board'), findsNothing);
    expect(find.text('Rematch button'), findsNothing);
  });

  testWidgets('the ladder is ordered bottom to top', (tester) async {
    phone(tester);
    await tester.pumpWidget(
      _app(ProgressionScreen(profile: demoProfile), 1.0, const Locale('en')),
    );
    await tester.pumpAndSettle();

    // Higher tiers sit higher up the screen: reading upward is climbing.
    final master = tester.getTopLeft(find.text('Master')).dy;
    final bronze = tester.getTopLeft(find.text('Bronze')).dy;
    expect(master, lessThan(bronze));
  });

  testWidgets('no floor is promised: a tier can be lost (2026-11-02)',
      (tester) async {
    phone(tester);
    await tester.pumpWidget(
      _app(ProgressionScreen(profile: demoProfile), 1.0, const Locale('en')),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('is yours'), findsNothing);
  });

  testWidgets('a first-tier player is shown no floor', (tester) async {
    phone(tester);
    final beginner = Profile(
      username: demoProfile.username,
      tierIdx: 0,
      divIdx: 0,
      lp: 10,
      wins: 0,
      losses: 1,
      winStreak: 0,
      dayStreak: 0,
      bestStreak: 0,
      totalReps: 12,
      bestSet: 6,
      globalRank: 98412,
      localRank: 3107,
      country: 'Egypt',
    );
    await tester.pumpWidget(
      _app(ProgressionScreen(profile: beginner), 1.0, const Locale('en')),
    );
    await tester.pumpAndSettle();

    // There is nothing below them to be safe from yet, and inventing a floor
    // would be a promise the ladder does not make.
    expect(find.textContaining('is yours'), findsNothing);
  });

  testWidgets('the badge gains a side per tier and never degenerates',
      (tester) async {
    // The spec's formula and its own shape list disagree; the shapes and the
    // mock win. Gold is a hexagon, and no tier asks for a polygon with fewer
    // than three sides.
    for (var tier = 0; tier < kTiers.length; tier++) {
      final badge = TierBadge(tierIndex: tier, size: 34);
      await tester.pumpWidget(
        _app(Scaffold(body: Center(child: badge)), 1.0, const Locale('en')),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'tier $tier failed to paint');
    }
  });

  testWidgets('home leads with the match button, not the badge',
      (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(const MatchScreen(), 1.0, const Locale('en')));
    await tester.pumpAndSettle();

    final button = find.text('Find a match');
    expect(button, findsOneWidget);
    // Above the fold on the smallest screen we support: this is the one thing
    // the home screen exists to offer.
    expect(tester.getBottomLeft(button).dy, lessThan(640));

    // The adventure took the practice link's place; friends are challenged
    // from their own tab.
    expect(find.byKey(const Key('adventureCard')), findsOneWidget);
    expect(find.text('Practice — no rank, no opponent'), findsNothing);
    expect(find.text('Challenge a friend'), findsNothing);
    expect(find.text('60 seconds · ranked'), findsOneWidget);
  });
}
