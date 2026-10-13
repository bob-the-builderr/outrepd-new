/// The store screenshots for 1.1, at Google Play's size and the App Store's:
/// the eight screens after the live match (live_match_test.dart draws that
/// one), named as the 1.0 set was so each can replace its old one.
///
/// Drawn by the real screens with the sample data a build with no server
/// shows, so they carry what 1.1 changed — the badges, the frames round
/// every picture, the bar's icons, today's goal — without a phone and a
/// staged account. See shots.dart for how these are run and published.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/career.dart';
import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/awards.dart';
import 'package:outrepd/screens/other_profile.dart';
import 'package:outrepd/screens/post_match.dart';
import 'package:outrepd/screens/progression.dart';
import 'package:outrepd/screens/shell.dart';
import 'package:outrepd/theme.dart';

Future<void> _font(String family, List<String> paths) async {
  final loader = FontLoader(family);
  var any = false;
  for (final path in paths) {
    final file = File(path);
    if (!file.existsSync()) continue;
    final bytes = file.readAsBytesSync();
    loader.addFont(Future.value(ByteData.view(bytes.buffer)));
    any = true;
  }
  if (any) await loader.load();
}

/// iron_mike, as the server would describe him to someone he has beaten
/// three times out of four.
class _Rival extends NoBackend {
  @override
  bool get available => true;

  @override
  Future<LifterProfile?> lifterProfile(String theirId) async => LifterProfile(
    id: 'iron_mike-id',
    username: 'iron_mike',
    tierIdx: 5,
    divIdx: 1,
    lp: 72,
    placementsDone: 5,
    totalReps: 3140,
    bestSet: 31,
    wins: 41,
    losses: 12,
    winStreak: 22,
    globalPlace: 3,
    country: 'US',
    countryPlace: 1,
    isFriend: true,
    winsVsYou: 3,
    lossesVsYou: 1,
    yourBestVsThem: 16,
    lastDuelAt: DateTime.now().subtract(const Duration(days: 2)),
    lastYourReps: 14,
    lastTheirReps: 19,
    title: 'giant_slayer',
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

/// A week of training ending today, part of the way to today's goal, so the
/// goal ring and the week's chart have something to show.
Map<String, Object> _week() {
  String key(DateTime day) =>
      '${day.year.toString().padLeft(4, '0')}-'
      '${day.month.toString().padLeft(2, '0')}-'
      '${day.day.toString().padLeft(2, '0')}';
  final today = DateTime.now();
  const reps = [32, 50, 0, 60, 45, 25, 40];
  return {
    'career.days': jsonEncode({
      for (var back = 0; back < reps.length; back++)
        key(today.subtract(Duration(days: back))): reps[back],
    }),
  };
}

void main() {
  setUpAll(() async {
    final fonts = Platform.environment['SHOT_FONTS'] ?? 'tool/screenshots/fonts';
    // Roboto, the face the app is set in on Android, in the weights the
    // screens use; Noto Sans where the runner has no Roboto.
    final roboto = [
      for (final w in ['Regular', 'Medium', 'Bold']) '$fonts/Roboto-$w.ttf',
    ];
    final face = File(roboto.first).existsSync()
        ? roboto
        : ['$fonts/NotoSans.ttf'];
    await _font('Roboto', face);
    await _font('FlutterTest', face);
    final root = Platform.environment['FLUTTER_ROOT'];
    if (root != null) {
      await _font('MaterialIcons', [
        '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
      ]);
    }
  });

  // A test in all but folder: it lives in tool/ so `flutter test` skips it.
  setUp(() async {
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues(_week());
    await Career.instance.load();
  });
  tearDown(() => backend = const NoBackend());

  final screens = <(String, Widget Function())>[
    ('01-home', () => const AppShell()),
    ('02-ranks', () => const AppShell(initialIndex: 2)),
    ('03-friends', () => const AppShell(initialIndex: 1)),
    (
      '04-otherprofile',
      () => const OtherProfileScreen(id: 'iron_mike-id', username: 'iron_mike'),
    ),
    ('05-profile', () => const AppShell(initialIndex: 3)),
    ('06-road', () => ProgressionScreen(profile: demoProfile)),
    (
      '07-won',
      () => Scaffold(
        body: DuelResultView(
          won: true,
          yourReps: 18,
          theirReps: 11,
          opponent: demoOpponents.first,
          outcome: demoOutcome(won: true, newBest: true),
          onRematch: () {},
          onDone: () {},
          monthBefore: 14,
          monthAfter: 11,
        ),
      ),
    ),
    ('08-awards', () => const AwardsScreen()),
  ];

  // Both drawn at three pixels to the point, as the phones they stand for.
  for (final (width, height) in [(1080, 1920), (1320, 2868)]) {
    for (final (name, screen) in screens) {
      testWidgets('store $name ${width}x$height', (tester) async {
        tester.view.physicalSize = Size(width.toDouble(), height.toDouble());
        tester.view.devicePixelRatio = 3;
        addTearDown(tester.view.reset);
        // Only the rival's page asks a server; the tabs keep the sample
        // data they show with none.
        if (name == '04-otherprofile') backend = _Rival();

        await tester.pumpWidget(_app(screen()));
        // Pumped for a fixed while rather than settled: some of these
        // screens keep a ticker going, and settling would wait on it for ever.
        for (var i = 0; i < 20; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/store_${width}x${height}_$name.png'),
        );
        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(seconds: 1));
      });
    }
  }
}
