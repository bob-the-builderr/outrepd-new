/// Screenshots of the four tabs and the settings, with the sample data a
/// build with no server shows. For comparing the app with its mockups at
/// the size a phone really draws it. See shots.dart for how these are run
/// and published.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/friends.dart';
import 'package:outrepd/screens/match.dart';
import 'package:outrepd/screens/profile.dart';
import 'package:outrepd/screens/rank_screen.dart';
import 'package:outrepd/screens/ranks.dart';
import 'package:outrepd/screens/settings.dart';
import 'package:outrepd/screens/shell.dart';
import 'package:outrepd/theme.dart';

Future<void> _font(String family, String path) async {
  final file = File(path);
  if (!file.existsSync()) return;
  final bytes = file.readAsBytesSync();
  final loader = FontLoader(family)
    ..addFont(Future.value(ByteData.view(bytes.buffer)));
  await loader.load();
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

  // A test in all but folder: it lives in tool/ so `flutter test` skips it.
  // ignore: invalid_use_of_visible_for_testing_member
  setUp(() => SharedPreferences.setMockInitialValues({}));

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(412 * 2, 915 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
  }

  // Pumped for a fixed while rather than settled: some of these screens keep
  // a ticker going, and settling would wait on it for ever.
  Future<void> shoot(WidgetTester tester, Widget screen, String name) async {
    phone(tester);
    await tester.pumpWidget(_app(screen));
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/tab_$name.png'),
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('match', (tester) => shoot(tester, const MatchScreen(), 'match'));
  testWidgets(
    'your rank',
    (tester) => shoot(tester, RankScreen(profile: demoProfile), 'rank_screen'),
  );
  testWidgets(
    'match with the bar',
    (tester) => shoot(tester, const AppShell(), 'shell_match'),
  );
  testWidgets(
    'friends',
    (tester) => shoot(tester, const FriendsScreen(), 'friends'),
  );
  testWidgets(
    'ranks this month',
    (tester) => shoot(tester, const RanksScreen(), 'ranks_month'),
  );
  testWidgets('ranks top players', (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(const RanksScreen()));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byKey(const Key('boardOverall')));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/tab_ranks_top.png'),
    );
  });
  testWidgets('ranks: how points work', (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(const RanksScreen()));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byKey(const Key('howPoints')));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/tab_ranks_how_points.png'),
    );
  });
  testWidgets(
    'profile',
    (tester) => shoot(tester, const ProfileScreen(), 'profile'),
  );
  testWidgets('profile recent', (tester) async {
    phone(tester);
    final was = [...matchHistory];
    addTearDown(() => matchHistory..clear()..addAll(was));
    matchHistory
      ..clear()
      ..addAll([
        for (final (who, mine, theirs, lp) in const [
          ('karimfit', 18, 11, 7),
          ('sara.lifts', 14, 19, -5),
          ('aly99', 22, 20, 2),
          ('nour_x', 25, 12, 13),
          ('omarpush', 9, 16, -7),
          ('youssef_r', 20, 14, 6),
        ])
          MatchRecord(
            won: mine >= theirs,
            userReps: mine,
            opponentReps: theirs,
            opponent: who,
            lpChange: lp,
            at: DateTime.now(),
          ),
      ]);
    await tester.pumpWidget(_app(const ProfileScreen()));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.dragUntilVisible(
      find.byKey(const Key('recentForm')),
      find.byType(ListView).first,
      const Offset(0, -300),
    );
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/tab_profile_recent.png'),
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
  testWidgets(
    'settings',
    (tester) => shoot(tester, const SettingsScreen(), 'settings'),
  );
}
