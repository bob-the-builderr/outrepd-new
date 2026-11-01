/// Screenshots of this month's board and of the end of a month, as the app
/// draws them. See shots.dart for how these are run and published.
library;

import 'dart:io';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/ranks.dart';
import 'package:outrepd/screens/season_over.dart';
import 'package:outrepd/theme.dart';

Future<void> _font(String family, String path) async {
  final file = File(path);
  if (!file.existsSync()) return;
  final bytes = file.readAsBytesSync();
  final loader = FontLoader(family)
    ..addFont(Future.value(ByteData.view(bytes.buffer)));
  await loader.load();
}

const _people = [
  ('karimfit', 5, 1, 142),
  ('sara.lifts', 4, 3, 131),
  ('aly99', 4, 1, 124),
  ('nour_x', 3, 2, 117),
  ('omarpush', 3, 4, 109),
  ('youssef_r', 3, 0, 104),
  ('hana.m', 2, 2, 101),
  ('ziad10', 2, 3, 99),
  ('mariam_k', 2, 1, 98),
  ('mo_reps', 2, 0, 98),
  ('tarek_p', 1, 4, 91),
  ('laila_s', 1, 2, 88),
];

class _Month extends NoBackend {
  @override
  bool get available => true;

  @override
  Future<List<MonthRow>> monthBoard({int limit = 100, String? country}) async => [
    for (final (i, (name, tier, div, points)) in _people.indexed)
      MonthRow(
        place: i + 1,
        id: 'id-$i',
        username: name,
        tierIdx: tier,
        divIdx: div,
        points: points,
        wins: 12,
        played: 18,
        xp: 600 + 900 * (12 - i),
      ),
  ];

  @override
  Future<MonthPlace?> myMonthPlace({String? country}) async => MonthPlace(
    season: DateTime.utc(2026, 10),
    endsAt: clock.now().add(const Duration(days: 20, hours: 4, minutes: 30)),
    place: 14,
    ofTotal: 312,
    points: 86,
    wins: 9,
    played: 12,
  );
}

/// The 1st of a month, before anybody has won LP in it: last month's top ten
/// stand in for the empty board.
class _NewMonth extends _Month {
  @override
  Future<List<MonthRow>> monthBoard({int limit = 100, String? country}) async =>
      const [];

  @override
  Future<MonthPlace?> myMonthPlace({String? country}) async => MonthPlace(
    season: DateTime.utc(2026, 11),
    endsAt: clock.now().add(const Duration(days: 29, hours: 23, minutes: 30)),
    place: null,
    ofTotal: 0,
    points: 0,
    wins: 0,
    played: 0,
  );

  @override
  Future<MonthWinners?> lastMonthWinners() async => MonthWinners(
    season: DateTime.utc(2026, 10),
    rows: (await super.monthBoard()).take(10).toList(),
  );
}

Widget _app(Widget home) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: buildTheme(Brightness.dark),
  locale: const Locale('en'),
  localizationsDelegates: const [
    L.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: L.supportedLocales,
  home: home,
);

void main() {
  setUpAll(() async {
    final fonts = Platform.environment['SHOT_FONTS'] ?? 'tool/screenshots/fonts';
    await _font('Roboto', '$fonts/NotoSans.ttf');
    await _font('FlutterTest', '$fonts/NotoSans.ttf');
    final root = Platform.environment['FLUTTER_ROOT'];
    if (root != null) {
      await _font(
        'MaterialIcons',
        '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
      );
    }
  });

  tearDown(() => backend = const NoBackend());

  testWidgets('month board', (tester) async {
    tester.view.physicalSize = const Size(412 * 2, 915 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final was = demoProfile.placementsDone;
    demoProfile.placementsDone = kPlacementDuels;
    addTearDown(() => demoProfile.placementsDone = was);
    backend = _Month();

    await tester.pumpWidget(_app(const RanksScreen()));
    await tester.pumpAndSettle();
    // The board opens on the week; this is the month's.
    await tester.tap(find.byKey(const Key('lengthMonth')));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/month_board.png'),
    );

    await tester.drag(find.byType(Scrollable).last, const Offset(0, -400));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/month_board_scrolled.png'),
    );
  });

  testWidgets('new month', (tester) async {
    tester.view.physicalSize = const Size(412 * 2, 915 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final was = demoProfile.placementsDone;
    demoProfile.placementsDone = kPlacementDuels;
    addTearDown(() => demoProfile.placementsDone = was);
    backend = _NewMonth();

    await tester.pumpWidget(_app(const RanksScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('lengthMonth')));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/month_board_new_month.png'),
    );
  });

  testWidgets('season over', (tester) async {
    tester.view.physicalSize = const Size(412 * 2, 915 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final september = DateTime.utc(2026, 9);

    await tester.pumpWidget(
      _app(
        Scaffold(
          body: ColoredBox(
            color: Colors.black54,
            child: SeasonOverDialog(
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
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/season_over.png'),
    );
  });
}
