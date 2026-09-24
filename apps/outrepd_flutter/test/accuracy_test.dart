/// The accuracy record, and the screen that reads it.
///
/// The record used to be two running totals. Totals can say the counter is out
/// by two on average; they cannot say whether that is every set out by two or
/// one set out by forty, and those are completely different faults needing
/// completely different fixes. So each set is kept whole, and these are the
/// tests that say what "kept whole" has to mean.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/reps/count_accuracy.dart';
import 'package:outrepd/screens/counter_accuracy.dart';
import 'package:outrepd/screens/settings.dart';
import 'package:outrepd/theme.dart';

Widget _app({double scale = 1.0, Locale locale = const Locale('en')}) =>
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
      home: const CounterAccuracyScreen(),
    );

/// The same app, opened on Settings — the only way in from inside the app.
Widget _settings() => MaterialApp(
      theme: buildTheme(Brightness.dark),
      locale: const Locale('en'),
      localizationsDelegates: const [
        L.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L.supportedLocales,
      home: const SettingsScreen(),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    clearCountAccuracy();
  });

  AccuracyReport reportOf(List<(int camera, int lifter)> pairs) {
    clearCountAccuracy();
    for (final (camera, lifter) in pairs) {
      recordCountCorrection(camera: camera, lifter: lifter);
    }
    return countAccuracy;
  }

  group('the measurement', () {
    test('a perfect run is exact, unbiased and never misses', () {
      final report = reportOf([(10, 10), (12, 12), (8, 8)]);

      expect(report.sets, 3);
      expect(report.exactRate, 1);
      expect(report.withinOneRate, 1);
      expect(report.meanAbsoluteError, 0);
      expect(report.bias, 0);
      expect(report.worst, 0);
    });

    test('scatter and steady drift are told apart', () {
      // Same mean error, completely different faults. Totals alone cannot
      // separate these, which is why they were not enough.
      final drift = reportOf([(11, 10), (13, 12), (9, 8), (15, 14)]);
      final scatter = reportOf([(14, 10), (12, 12), (8, 12), (14, 14)]);

      expect(drift.meanAbsoluteError, 1);
      expect(scatter.meanAbsoluteError, 2);

      // The drifting counter leans one way every time; the scattering one
      // averages out to nothing while being far more wrong.
      expect(drift.bias, 1);
      expect(scatter.bias, 0);
      expect(drift.worst.abs(), 1);
      expect(scatter.worst.abs(), 4);
    });

    test('direction is kept, not just size', () {
      expect(reportOf([(12, 10), (11, 10)]).bias, greaterThan(0));
      expect(reportOf([(8, 10), (9, 10)]).bias, lessThan(0));
    });

    test('within one is not the same as exact', () {
      final report = reportOf([(10, 10), (11, 10), (10, 11), (14, 10)]);
      expect(report.exact, 1);
      expect(report.withinOne, 3);
    });

    test('nothing measured is not a perfect score', () {
      final report = reportOf([]);
      expect(report.empty, isTrue);
      // Zero sets, zero of them wrong. A report that reads as a pass on no
      // evidence is worse than no report.
      expect(report.exactRate, 0);
      expect(report.withinOneRate, 0);
    });

    test('the record is bounded and keeps the newest', () {
      for (var i = 0; i < kAccuracySamplesKept + 40; i++) {
        recordCountCorrection(camera: i, lifter: i);
      }
      expect(countSamples.length, kAccuracySamplesKept);
      // The oldest fall off, so the figure describes the counter as it
      // behaves now rather than six versions ago.
      expect(countSamples.last.camera, kAccuracySamplesKept + 39);
    });

    test('the recent window moves before the lifetime figure does', () {
      for (var i = 0; i < 40; i++) {
        recordCountCorrection(camera: 10, lifter: 14);
      }
      for (var i = 0; i < 10; i++) {
        recordCountCorrection(camera: 10, lifter: 10);
      }

      expect(recentAccuracy(10).exactRate, 1);
      expect(countAccuracy.exactRate, lessThan(0.3));
    });
  });

  group('the screen', () {
    testWidgets('says nothing is measured rather than showing zeroes',
        (tester) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      expect(find.text('Nothing measured yet'), findsOneWidget);
      expect(find.text('0%'), findsNothing);
    });

    testWidgets('warns while the sample is too small to mean anything',
        (tester) async {
      reportOf([(10, 10), (9, 9)]);
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      // Two sets and 100% exact is exactly the number somebody would act on
      // and should not.
      expect(find.textContaining('Early days'), findsOneWidget);
    });

    testWidgets('shows the four figures and the sets behind them',
        (tester) async {
      reportOf([
        (10, 10),
        (11, 10),
        (9, 10),
        (14, 10),
        (10, 10),
        (10, 10),
        (12, 12),
        (7, 7),
        (9, 9),
        (13, 13),
        (11, 11),
      ]);

      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      for (final label in ['EXACT', 'WITHIN 1 REP', 'AVERAGE MISS', 'WORST MISS']) {
        expect(find.text(label), findsOneWidget, reason: '$label missing');
      }
      expect(find.textContaining('Measured over'), findsOneWidget);
      expect(find.text('RECENT SETS'), findsOneWidget);
      // The sample rows carry both numbers, so a disagreement can be read
      // rather than inferred.
      expect(find.textContaining('Camera'), findsWidgets);
      // And the sample is big enough now, so the warning is gone.
      expect(find.textContaining('Early days'), findsNothing);
    });

    for (final scale in [1.3, 1.6]) {
      testWidgets('lays out at ${scale}x', (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        reportOf([for (var i = 0; i < 12; i++) (10 + i % 3, 10)]);
        await tester.pumpWidget(_app(scale: scale));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('lays out in Arabic', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      reportOf([for (var i = 0; i < 12; i++) (10 + i % 3, 10)]);
      await tester.pumpWidget(_app(scale: 1.3, locale: const Locale('ar')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('the way in', () {
    testWidgets('settings carries the figure, and opens the screen',
        (tester) async {
      tester.view.physicalSize = const Size(400, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      reportOf([for (var i = 0; i < 10; i++) (i < 8 ? 10 : 11, 10)]);

      await tester.pumpWidget(_settings());
      await tester.pumpAndSettle();

      // The number is on the row itself. Somebody who has just been miscounted
      // should not have to open a screen to find out whether that is usual.
      expect(find.text('80%'), findsOneWidget);

      await tester.ensureVisible(find.text('Counter accuracy'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Counter accuracy'));
      await tester.pumpAndSettle();

      expect(find.text('EXACT'), findsOneWidget);
    });
  });
}
