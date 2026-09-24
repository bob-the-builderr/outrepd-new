/// The six states from the mockups: a brand new account, placements running,
/// no connection, no friends, no rank, and an opponent who left.
///
/// These are the screens almost nobody building the app ever sees, because the
/// demo data always has friends, a rank and a network. They are also the first
/// screens a new install shows, so they get tested rather than eyeballed.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/connection.dart';
import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/match.dart';
import 'package:outrepd/screens/ranks.dart';
import 'package:outrepd/theme.dart';

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
  // The retry button asks the OS for real via connectivity_plus, which has
  // no platform to answer on a test device — an unmocked call to it hangs
  // forever rather than failing fast, so the channel needs a stand-in here.
  const connectivityChannel = MethodChannel(
    'dev.fluttercommunity.plus/connectivity',
  );
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      connectivityChannel,
      (call) async => call.method == 'check' ? ['wifi'] : null,
    );
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(connectivityChannel, null);
  });

  const small = Size(360, 640);

  void phone(WidgetTester tester) {
    tester.view.physicalSize = small;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  /// The demo profile is shared mutable state, so anything that moves it has
  /// to put it back or it leaks into the next test.
  void withPlacements(int done) {
    final was = demoProfile.placementsDone;
    demoProfile.placementsDone = done;
    addTearDown(() => demoProfile.placementsDone = was);
  }

  void offline() {
    Connection.instance.setOnline(false);
    addTearDown(() => Connection.instance.setOnline(true));
  }

  group('a brand new account', () {
    testWidgets('is unranked rather than bottom-ranked', (tester) async {
      phone(tester);
      withPlacements(0);
      await tester.pumpWidget(_app(const MatchScreen(), 1.0, const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('Unranked'), findsOneWidget);
      // Never handed a tier it has not earned — that is a judgement, and the
      // whole point of placements is to withhold it.
      expect(find.textContaining('Stone'), findsNothing);
      expect(find.textContaining('LP'), findsNothing);

      expect(find.text('Start placements'), findsOneWidget);
      expect(find.text('Practice first'), findsOneWidget);
      expect(find.text('0 of 5 · 60 seconds each'), findsOneWidget);
    });

    testWidgets('shows progress once placements are under way', (tester) async {
      phone(tester);
      withPlacements(3);
      await tester.pumpWidget(_app(const MatchScreen(), 1.0, const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('Unranked'), findsOneWidget);
      expect(find.text('Next placement'), findsOneWidget);
      expect(find.text('3 of 5 · 2 more to get your tier'), findsOneWidget);
      // The invitation to start is gone; they have started.
      expect(find.text('Start placements'), findsNothing);
    });

    testWidgets('gets a rank once the placements are done', (tester) async {
      phone(tester);
      withPlacements(kPlacementDuels);
      await tester.pumpWidget(_app(const MatchScreen(), 1.0, const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('Unranked'), findsNothing);
      expect(find.text('Gold III'), findsOneWidget);
      expect(find.text('Find a match'), findsOneWidget);
    });
  });

  group('with no connection', () {
    testWidgets('the ranked button is dead and practice is promoted',
        (tester) async {
      phone(tester);
      withPlacements(kPlacementDuels);
      offline();
      await tester.pumpWidget(_app(const MatchScreen(), 1.0, const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('No connection'), findsOneWidget);
      // Still on screen, not hidden: a button that vanishes reads as a feature
      // being removed rather than a network being down.
      expect(find.text('Find a match'), findsOneWidget);
      expect(find.text('Practice offline'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('retry brings the normal screen back', (tester) async {
      phone(tester);
      withPlacements(kPlacementDuels);
      offline();
      await tester.pumpWidget(_app(const MatchScreen(), 1.0, const Locale('en')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.text('No connection'), findsNothing);
      expect(find.text('60 seconds · ranked'), findsOneWidget);
    });
  });

  group('the ranks board', () {
    testWidgets('tells an unranked account how to get on it', (tester) async {
      phone(tester);
      withPlacements(0);
      await tester.pumpWidget(_app(const RanksScreen(), 1.0, const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('No rank yet'), findsOneWidget);
      expect(find.text('Start placements'), findsOneWidget);
      expect(find.text('0 of 5 done'), findsOneWidget);
      // "No ranks yet" would be a lie — the board is full, they are not on it.
      expect(find.text('No ranks yet'), findsNothing);

      // And no pinned self row: it sat right under "No rank yet" claiming a
      // rank, a win record and position 1,842, all invented.
      expect(find.text('YOU'), findsNothing);
      expect(find.textContaining('Gold III'), findsNothing);
    });

    testWidgets('shows the board to a ranked account', (tester) async {
      phone(tester);
      withPlacements(kPlacementDuels);
      await tester.pumpWidget(_app(const RanksScreen(), 1.0, const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('No rank yet'), findsNothing);
      expect(find.text('iron_mike'), findsWidgets);
      // The self row comes back with the rank.
      expect(find.text('YOU'), findsOneWidget);
    });
  });

  group('layout survives', () {
    for (final scale in [1.3, 1.6]) {
      testWidgets('a new account at ${scale}x', (tester) async {
        phone(tester);
        withPlacements(0);
        await tester
            .pumpWidget(_app(const MatchScreen(), scale, const Locale('en')));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('the offline screen at ${scale}x', (tester) async {
        phone(tester);
        withPlacements(kPlacementDuels);
        offline();
        await tester
            .pumpWidget(_app(const MatchScreen(), scale, const Locale('en')));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }

    for (final code in ['ar', 'de', 'ru']) {
      testWidgets('a new account in $code', (tester) async {
        phone(tester);
        withPlacements(2);
        await tester.pumpWidget(_app(const MatchScreen(), 1.3, Locale(code)));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });

      testWidgets('the unranked board in $code', (tester) async {
        phone(tester);
        withPlacements(0);
        await tester.pumpWidget(_app(const RanksScreen(), 1.3, Locale(code)));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  });
}
