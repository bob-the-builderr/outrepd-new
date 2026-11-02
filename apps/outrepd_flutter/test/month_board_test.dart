/// This month's board: the podium, the line under tenth, and what the pinned
/// row says about the account looking at it — plus the end of a month, told
/// once to somebody who won something.
library;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/ranks.dart';
import 'package:outrepd/screens/season_over.dart';
import 'package:outrepd/theme.dart';

const _names = [
  'karimfit', 'sara.lifts', 'aly99', 'nour_x', 'omarpush', 'youssef_r',
  'hana.m', 'ziad10', 'mariam_k', 'mo_reps', 'tarek_p', 'laila_s', 'adam.f',
];

List<MonthRow> _board(int count) => [
  for (var i = 0; i < count; i++)
    MonthRow(
      place: i + 1,
      id: 'id-$i',
      username: _names[i],
      tierIdx: 3,
      divIdx: 2,
      // 142, 131, 124 … tenth on 98.
      points: const [142, 131, 124, 117, 109, 104, 101, 99, 98, 98, 91, 88, 87][i],
      wins: 10,
      played: 18,
    ),
];

class _Month extends NoBackend {
  _Month({required this.rows, this.place, this.played = 12, this.points = 86});

  final List<MonthRow> rows;
  final int? place;
  final int played;
  final int points;

  List<SeasonAward> awards = const [];
  int markedSeen = 0;
  MonthWinners? winners;

  @override
  bool get available => true;

  @override
  Future<List<MonthRow>> monthBoard({int limit = 100, String? country}) async => rows;

  @override
  Future<MonthPlace?> myMonthPlace({String? country}) async => MonthPlace(
    season: DateTime.utc(2026, 10),
    endsAt: clock.now().add(const Duration(days: 20, hours: 4, minutes: 30)),
    place: place,
    ofTotal: 312,
    points: points,
    wins: 9,
    played: played,
  );

  @override
  Future<MonthWinners?> lastMonthWinners() async => winners;

  @override
  Future<List<SeasonAward>> mySeasonAwards() async => awards;

  @override
  Future<void> markSeasonAwardsSeen() async => markedSeen++;
}

Widget _app(Widget home, {double scale = 1.0, Locale locale = const Locale('en')}) =>
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
      home: home,
    );

void main() {
  setUp(() => backend = const NoBackend());
  tearDown(() => backend = const NoBackend());

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  void ranked() {
    final was = demoProfile.placementsDone;
    demoProfile.placementsDone = kPlacementDuels;
    addTearDown(() => demoProfile.placementsDone = was);
  }

    /// The board opens on the week; the month is the switch's other half.
  Future<void> toMonth(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('lengthMonth')));
    await tester.pumpAndSettle();
  }

  group('the week board', () {
    testWidgets('opens first, with the switch to the month', (tester) async {
      phone(tester);
      ranked();
      backend = _Month(rows: _board(13), place: 14);
      await tester.pumpWidget(_app(const RanksScreen()));
      await tester.pumpAndSettle();

      expect(find.textContaining('This week'), findsOneWidget);
      expect(find.text('Starts again every Monday'), findsOneWidget);
      expect(find.byKey(const Key('lengthMonth')), findsOneWidget);
    });

    testWidgets('says a new week is empty, not a new month', (tester) async {
      // It used to borrow the month's words on a Monday morning.
      phone(tester);
      ranked();
      backend = _Month(rows: const [], place: null, played: 0, points: 0);
      await tester.pumpWidget(_app(const RanksScreen()));
      await tester.pumpAndSettle();

      expect(find.text('A fresh week'), findsOneWidget);
      expect(find.text('A fresh month'), findsNothing);
    });
  });

group('the month board', () {
    testWidgets('a tap away, with the podium and the time left', (tester) async {
      phone(tester);
      ranked();
      backend = _Month(rows: _board(13), place: 14);
      await tester.pumpWidget(_app(const RanksScreen()));
      await tester.pumpAndSettle();
      await toMonth(tester);

      expect(find.text('October · 20d 4h left'), findsOneWidget);
      expect(find.text('karimfit'), findsOneWidget);
      expect(find.text('142 LP'), findsOneWidget);
      expect(find.text('20 Club badge · 12/20 ranked duels'), findsOneWidget);
    });

    testWidgets('marks the top ten and draws the line under it', (tester) async {
      phone(tester);
      ranked();
      backend = _Month(rows: _board(13), place: 14);
      await tester.pumpWidget(_app(const RanksScreen()));
      await tester.pumpAndSettle();
      await toMonth(tester);

      await tester.scrollUntilVisible(
        find.text('adam.f'),
        200,
        scrollable: find.byType(Scrollable).last,
      );
      // Fourth to tenth say what they would win; eleventh on, their rank.
      expect(find.text('Top 10'), findsWidgets);
      expect(find.textContaining('Gold'), findsWidgets);
    });

    testWidgets('tells somebody past tenth how far the top ten is', (tester) async {
      phone(tester);
      ranked();
      backend = _Month(rows: _board(13), place: 14);
      await tester.pumpWidget(_app(const RanksScreen()));
      await tester.pumpAndSettle();
      await toMonth(tester);

      // Tenth has 98; 86 needs 13 more to be sure of passing, not 12 —
      // level on points goes to whoever has more wins.
      expect(find.text('13 LP to the top 10'), findsOneWidget);
      expect(find.text('YOU'), findsOneWidget);
    });

    testWidgets('tells somebody in the top ten what they would win', (tester) async {
      phone(tester);
      ranked();
      backend = _Month(rows: _board(13), place: 2, points: 131);
      await tester.pumpWidget(_app(const RanksScreen()));
      await tester.pumpAndSettle();
      await toMonth(tester);

      expect(find.text('Podium if the month ended now'), findsOneWidget);
    });

    testWidgets('tells somebody not on it yet how to get on', (tester) async {
      phone(tester);
      ranked();
      backend = _Month(rows: _board(13), place: null, played: 0, points: 0);
      await tester.pumpWidget(_app(const RanksScreen()));
      await tester.pumpAndSettle();
      await toMonth(tester);

      expect(
        find.text("Play a ranked duel to get on this month's board"),
        findsOneWidget,
      );
    });

    testWidgets('says a new month is empty rather than broken', (tester) async {
      phone(tester);
      ranked();
      backend = _Month(rows: const [], place: null, played: 0, points: 0);
      await tester.pumpWidget(_app(const RanksScreen()));
      await tester.pumpAndSettle();
      await toMonth(tester);

      expect(find.text('A fresh month'), findsOneWidget);
      expect(find.text('No connection'), findsNothing);
    });

    testWidgets("a new month shows last month's winners", (tester) async {
      phone(tester);
      ranked();
      backend = _Month(rows: const [], place: null, played: 0, points: 0)
        ..winners = MonthWinners(
          season: DateTime.utc(2026, 10),
          rows: _board(10),
        );
      await tester.pumpWidget(_app(const RanksScreen()));
      await tester.pumpAndSettle();
      await toMonth(tester);

      expect(find.text('A fresh month'), findsOneWidget);
      expect(find.byKey(const Key('lastMonthPlay')), findsOneWidget);
      expect(find.text("OCTOBER'S WINNERS"), findsOneWidget);
      expect(find.text('karimfit'), findsOneWidget);
      expect(find.text('CHAMPION'), findsOneWidget);
      expect(find.text('PODIUM'), findsNWidgets(2));
      // Fourth to tenth under the podium, each marked with what it won.
      expect(find.text('Top 10'), findsNWidgets(7));
    });

    testWidgets("last month's winners fit at 1.3x in de", (tester) async {
      phone(tester);
      ranked();
      backend = _Month(rows: const [], place: null, played: 0, points: 0)
        ..winners = MonthWinners(
          season: DateTime.utc(2026, 10),
          rows: _board(10),
        );
      await tester.pumpWidget(
        _app(const RanksScreen(), scale: 1.3, locale: const Locale('de')),
      );
      await tester.pumpAndSettle();
      await toMonth(tester);
      expect(tester.takeException(), isNull);
      expect(find.text('GEWINNER IM OKTOBER'), findsOneWidget);
    });

    testWidgets('shows the badge once it is earned', (tester) async {
      phone(tester);
      ranked();
      backend = _Month(rows: _board(13), place: 14, played: 23);
      await tester.pumpWidget(_app(const RanksScreen()));
      await tester.pumpAndSettle();
      await toMonth(tester);

      expect(find.text('20 Club badge earned this month'), findsOneWidget);
    });

    testWidgets('still has the all-time boards a tap away', (tester) async {
      phone(tester);
      ranked();
      backend = _Month(rows: _board(13), place: 14);
      await tester.pumpWidget(_app(const RanksScreen()));
      await tester.pumpAndSettle();
      await toMonth(tester);

      await tester.tap(find.text('Top Players'));
      await tester.pumpAndSettle();
      expect(find.text('October · 20d 4h left'), findsNothing);
    });

    for (final (scale, code) in [(1.3, 'de'), (1.6, 'en'), (1.3, 'hi'), (1.3, 'ru')]) {
      testWidgets('fits at ${scale}x in $code', (tester) async {
        phone(tester);
        ranked();
        backend = _Month(rows: _board(13), place: 14);
        await tester.pumpWidget(
          _app(const RanksScreen(), scale: scale, locale: Locale(code)),
        );
        await tester.pumpAndSettle();
        await toMonth(tester);
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('the end of a month', () {
    final september = DateTime.utc(2026, 9);

    testWidgets('shows the place and every award from it', (tester) async {
      phone(tester);
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: SeasonOverDialog(
              awards: [
                SeasonAward(
                  season: september,
                  kind: SeasonAwardKind.top10,
                  place: 7,
                  points: 104,
                  played: 23,
                ),
                SeasonAward(
                  season: september,
                  kind: SeasonAwardKind.regular,
                  points: 104,
                  played: 23,
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Season over'), findsOneWidget);
      expect(find.text('September 2026'), findsOneWidget);
      expect(find.text('#7'), findsOneWidget);
      expect(find.text('104 LP · 23 ranked duels'), findsOneWidget);
      expect(find.text('Top 10 · Sep'), findsOneWidget);
      expect(find.text('20 Club · Sep'), findsOneWidget);
    });

    testWidgets('is told once, then marked seen', (tester) async {
      phone(tester);
      final server = _Month(rows: const [])
        ..awards = [
          SeasonAward(
            season: september,
            kind: SeasonAwardKind.champion,
            place: 1,
            points: 151,
            played: 30,
            seen: false,
          ),
          // An older month the account was already told about.
          SeasonAward(
            season: DateTime.utc(2026, 8),
            kind: SeasonAwardKind.podium,
            place: 3,
          ),
        ];
      backend = server;

      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => tellSeasonAwards(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Champion'), findsOneWidget);
      expect(find.text('Podium · Aug'), findsNothing);
      await tester.tap(find.text('Play the new month'));
      await tester.pumpAndSettle();

      expect(find.text('Season over'), findsNothing);
      expect(server.markedSeen, 1);
    });

    testWidgets('says nothing when there is nothing new', (tester) async {
      phone(tester);
      final server = _Month(rows: const [])
        ..awards = [
          SeasonAward(
            season: september,
            kind: SeasonAwardKind.top10,
            place: 9,
          ),
        ];
      backend = server;

      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => tellSeasonAwards(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Season over'), findsNothing);
      expect(server.markedSeen, 0);
    });
  });
}
