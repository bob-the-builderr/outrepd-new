/// The profile screen's layout, at the text sizes real people use.
///
/// The build spec asks for one check by name — the longest achievement title
/// at 1.3x text scale — because that is where a card with a fixed height stops
/// fitting its own contents. Overflow is a silent failure in release builds:
/// the yellow stripe only appears in debug, so without a test it ships.
///
/// These run the whole screen at several scales on the narrowest phone we
/// support, and fail on any overflow, not just the achievements'.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/career.dart';
import 'package:outrepd/data.dart';
import 'package:outrepd/rewards.dart';
import 'package:outrepd/screens/profile.dart';
import 'package:outrepd/theme.dart';
import 'package:outrepd/widgets.dart';

Widget _app(double scale, Locale locale) => MaterialApp(
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
      home: const ProfileScreen(),
    );

void main() {
  // 360x640 is the smallest screen still in wide use. Anything that fits here
  // fits everywhere.
  const small = Size(360, 640);

  for (final scale in [1.0, 1.3, 1.6]) {
    testWidgets('profile lays out at ${scale}x text scale', (tester) async {
      tester.view.physicalSize = small;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_app(scale, const Locale('en')));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      // Scroll the whole page: a card below the fold is never laid out, so a
      // test that only pumps checks the top third of the screen.
      await tester.drag(find.byType(ListView), const Offset(0, -400));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('profile lays out in Arabic', (tester) async {
    tester.view.physicalSize = small;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app(1.3, const Locale('ar')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows both ranks, at the same size', (tester) async {
    tester.view.physicalSize = small;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app(1.0, const Locale('en')));
    await tester.pumpAndSettle();

    // Global says how far there is to go; local is the one most people can
    // actually move. Burying the second under the first is what makes a
    // leaderboard feel pointless to everybody outside the top hundred.
    expect(find.text('#1,842'), findsOneWidget);
    expect(find.text('#64'), findsOneWidget);
    expect(find.text('GLOBAL'), findsOneWidget);
    expect(find.text('UNITED STATES'), findsOneWidget);

    final global = tester.getRect(find.text('#1,842'));
    final local = tester.getRect(find.text('#64'));
    expect(local.height, closeTo(global.height, 0.5));
    // Side by side, not stacked.
    expect((local.center.dy - global.center.dy).abs(), lessThan(1));
  });

  testWidgets('leads the grid with the stat one session can move',
      (tester) async {
    tester.view.physicalSize = small;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app(1.0, const Locale('en')));
    await tester.pumpAndSettle();

    for (final label in ['BEST SET', 'TOTAL REPS', 'RECORD', 'STREAK']) {
      expect(find.text(label), findsOneWidget, reason: '$label missing');
    }

    // The home screen pill and this card are both about showing up, so they
    // read the same field. Wiring one of them to the win streak made two
    // screens disagree about the same word.
    expect(demoProfile.dayStreak, isNot(demoProfile.winStreak));
    expect(find.textContaining('${demoProfile.dayStreak}'), findsWidgets);

    // Best set sits first and wears the colour that means "you".
    final best = tester.getRect(find.text('BEST SET'));
    final total = tester.getRect(find.text('TOTAL REPS'));
    expect(best.left, lessThan(total.left));

    // No weight anywhere: this app counts push-ups.
    expect(find.textContaining('kg'), findsNothing);
    expect(find.textContaining('KG'), findsNothing);
  });

  testWidgets('the week chart shows what was actually done', (tester) async {
    tester.view.physicalSize = small;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({});
    await Career.instance.startFresh();
    await Career.instance.recordPractice(31);

    await tester.pumpWidget(_app(1.0, const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('LAST 7 DAYS'), findsOneWidget);
    // The total is read off the log, not written into the screen.
    expect(find.text('31 reps'), findsOneWidget);

    // Seven bars whatever happened: a rest day is part of the answer to "did
    // I train this week", and a chart that skips it lies by omission.
    final week = Career.instance.weekReps;
    expect(week.length, 7);
    expect(week.where((d) => d == 0).length, 6);
  });

  testWidgets('achievements collapse to one row, not a sample of four',
      (tester) async {
    tester.view.physicalSize = small;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app(1.0, const Locale('en')));
    await tester.pumpAndSettle();

    // It sits at the bottom, which is the point — everything checked daily is
    // above it now — so the list has to be scrolled before it is built.
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();

    expect(find.text('Awards'), findsOneWidget);
    // One count, one list. There used to be a second seven-item list feeding
    // the screen behind this row, so the two disagreed: 11 / 54 here and
    // 4 / 7 there, and that one still listed a kilo achievement.
    final owned = kTitles.where((t) => rewards.has(t.id)).length;
    expect(find.text('$owned / ${kTitles.length}'), findsOneWidget);
    // The grid showed four of sixty-one, which is a sample rather than a
    // summary, and pushed everything checked daily below the fold to do it.
    expect(find.text('First Blood'), findsNothing);
  });

  testWidgets('a long word shrinks rather than breaking in half',
      (tester) async {
    // "Encyclopedia" is the longest single word in the achievement set, and a
    // narrow box is what a locked card's title gets after the lock icon.
    const style = TextStyle(fontSize: 12);
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 125,
            child: ShrinkText('Encyclopedia', style: style),
          ),
        ),
      ),
    ));

    final rendered = tester.widget<Text>(find.text('Encyclopedia'));
    final size = rendered.style!.fontSize!;
    expect(size, lessThan(12), reason: 'it should have given up some size');

    // Shrinking is only worth doing if the word then fits on one line.
    final painter = TextPainter(
      text: TextSpan(text: 'Encyclopedia', style: style.copyWith(fontSize: size)),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 125);
    expect(painter.didExceedMaxLines, isFalse);
  });

  testWidgets('short text is left at full size', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 300,
          child: ShrinkText('Century', style: TextStyle(fontSize: 12)),
        ),
      ),
    ));

    expect(tester.widget<Text>(find.text('Century')).style!.fontSize, 12);
  });
}
