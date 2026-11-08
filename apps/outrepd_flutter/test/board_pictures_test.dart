/// Pictures on every board: the week's, the month's and Overall, for the world
/// and among friends, the podium and the rows. An uploaded photo shows on every
/// one of them, the podium too, Pro or not. A Pro with no photo has their
/// lifter out over the ring — the one they made, or the one their name gives —
/// and a photo stays a photo. How they look arrives after the board, so each
/// part of it has to draw again when it does.
library;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/lifter/lifter_view.dart';
import 'package:outrepd/player_avatar.dart';
import 'package:outrepd/screens/ranks.dart';
import 'package:outrepd/theme.dart';

/// Who is on every board, best first: a Pro with no photo on the podium, a
/// Pro with a photo, then free accounts, the pro with no photo again below
/// the podium.
const _people = [
  ('pop-first', 'pro_first', true, null),
  ('photo-pro', 'photo_pro', true, 'https://example.test/a/photo.jpg?v=1'),
  ('free-1', 'free_one', false, null),
  ('free-2', 'free_two', false, 'https://example.test/b/photo.jpg?v=1'),
  ('pop-row', 'pro_row', true, null),
  ('made-free', 'made_free', false, null),
];

/// The one free account that made a lifter: no picture went up for it.
const _madeLifter = {'skin': 'neon', 'hair': 'buzz'};

List<MonthRow> _monthRows() => [
  for (final (i, (id, name, _, url)) in _people.indexed)
    MonthRow(
      place: i + 1,
      id: id,
      username: name,
      tierIdx: 3,
      divIdx: 2,
      points: 100 - i * 10,
      wins: 5,
      played: 8,
      avatarUrl: url,
    ),
];

List<BoardRow> _boardRows() => [
  for (final (i, (id, name, _, url)) in _people.indexed)
    BoardRow(
      id: id,
      username: name,
      tierIdx: 4 - i ~/ 2,
      divIdx: 2,
      lp: 50,
      wins: 10,
      losses: 5,
      avatarUrl: url,
    ),
];

class _Boards extends NoBackend {
  @override
  bool get available => true;

  MonthPlace _place() => MonthPlace(
    season: DateTime.utc(2026, 11),
    endsAt: clock.now().add(const Duration(days: 3)),
    place: 9,
    ofTotal: 40,
    points: 20,
    wins: 2,
    played: 4,
  );

  @override
  Future<List<MonthRow>> weekBoard({int limit = 100, String? country}) async => _monthRows();

  @override
  Future<MonthPlace?> myWeekPlace({String? country}) async => _place();

  @override
  Future<List<MonthRow>> monthBoard({int limit = 100, String? country}) async => _monthRows();

  @override
  Future<MonthPlace?> myMonthPlace({String? country}) async => _place();

  @override
  Future<List<MonthRow>> friendsBoard({bool month = false}) async => _monthRows();

  @override
  Future<List<BoardRow>> leaderboard({
    int limit = 100,
    String? country,
    int? tierIdx,
    int? divIdx,
  }) async => _boardRows();

  @override
  Future<List<BoardRow>> friendsLeaderboard() async => _boardRows();

  @override
  Future<Map<String, ProLook>> proLooks(List<String> ids) async => {
    for (final (id, _, pro, _) in _people)
      if (ids.contains(id))
        id: ProLook(id: id, pro: pro, lifter: id == 'made-free' ? _madeLifter : null),
  };
}

Widget _app() => MaterialApp(
  theme: buildTheme(Brightness.dark),
  locale: const Locale('en'),
  localizationsDelegates: const [
    L.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: L.supportedLocales,
  home: const RanksScreen(),
);

void main() {
  setUp(() => backend = _Boards());
  tearDown(() => backend = const NoBackend());

  Future<void> open(WidgetTester tester) async {
    tester.view.physicalSize = const Size(412, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final was = demoProfile.placementsDone;
    demoProfile.placementsDone = kPlacementDuels;
    addTearDown(() => demoProfile.placementsDone = was);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
  }

  Future<void> to(WidgetTester tester, String key) async {
    await tester.tap(find.byKey(Key(key)));
    await tester.pumpAndSettle();
  }

  Future<void> amongFriends(WidgetTester tester) async {
    await to(tester, 'boardsPlace');
    await to(tester, 'boardsFriends');
  }

  // The two Pros with no photo, one on the podium and one in the rows; the
  // Pro with a photo shows it, and nobody free breaks out. Both photos are
  // drawn: the Pro's on the podium and the free account's in the rows.
  void twoOut() {
    expect(find.byType(PopOutLifter), findsNWidgets(2));
    expect(find.byType(PhotoOrLifter), findsNWidgets(2));
    // The free account that made a lifter wears it, drawn from its parts,
    // though its picture never went up.
    expect(
      find.byWidgetPredicate((w) => w is LifterCircle && w.lifter != null),
      findsWidgets,
    );
  }

  // The photos are asked for and given up on (there is no server in a test),
  // so no download is left waiting when the test ends.
  Future<void> letPhotosGo(WidgetTester tester) => tester.pump(const Duration(seconds: 30));

  testWidgets('the week, for the world', (tester) async {
    await open(tester);
    twoOut();
    await letPhotosGo(tester);
  });

  testWidgets('the month, for the world', (tester) async {
    await open(tester);
    await to(tester, 'lengthMonth');
    twoOut();
    await letPhotosGo(tester);
  });

  testWidgets('Overall, for the world', (tester) async {
    await open(tester);
    await to(tester, 'boardOverall');
    twoOut();
    await letPhotosGo(tester);
  });

  testWidgets('the week, the month and Overall among friends', (tester) async {
    await open(tester);
    await amongFriends(tester);
    twoOut();
    await to(tester, 'lengthMonth');
    twoOut();
    await to(tester, 'boardOverall');
    twoOut();
    await letPhotosGo(tester);
  });
}
