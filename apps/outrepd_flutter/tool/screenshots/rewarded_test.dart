/// Screenshots of what a rewarded video gives (the user's pick, 2026-11-09,
/// A + B + C), to set beside design/mockups/2026-11-09/rewarded_*: the XP
/// card offering to double and doubled, the streak card on the home screen,
/// and the sheet over a locked Pro part. See shots.dart for how these run.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/ads.dart';
import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/lifter/catalog.dart';
import 'package:outrepd/rewards.dart';
import 'package:outrepd/screens/match.dart';
import 'package:outrepd/screens/post_match.dart';
import 'package:outrepd/screens/rewarded.dart';
import 'package:outrepd/theme.dart';
import 'package:outrepd/xp.dart';

Future<void> _font(String family, String path) async {
  final file = File(path);
  if (!file.existsSync()) return;
  final bytes = file.readAsBytesSync();
  final loader = FontLoader(family)
    ..addFont(Future.value(ByteData.view(bytes.buffer)));
  await loader.load();
}

class _Server extends NoBackend {
  @override
  bool get available => true;

  @override
  Future<int> doubleDuelXp(String duelId) async => 38;
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
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(disableAnimations: true),
    child: child!,
  ),
  home: home,
);

/// A won duel the server settled, 18 to 11: 38 XP, doubled to 76.
DuelResultView _won() => DuelResultView(
  won: true,
  yourReps: 18,
  theirReps: 11,
  opponent: const Opponent('karimfit', 3, 2),
  outcome: demoOutcome(won: true, duelId: 'duel-1'),
  onRematch: () {},
  onDone: () {},
  xp: const XpGain(before: 4180, after: 4180 + 18 + kXpPerMatch, reps: 18),
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

  setUp(() {
    // A test in all but folder: it lives in tool/ so `flutter test` skips it.
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
    // ignore: invalid_use_of_visible_for_testing_member
    Ads.debugRewarded = true;
    backend = _Server();
  });
  tearDown(() {
    // ignore: invalid_use_of_visible_for_testing_member
    Ads.debugRewarded = null;
    backend = const NoBackend();
  });

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(412 * 2, 915 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
  }

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('A: the XP card offers to double, then has', (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(Scaffold(body: _won())));
    await settle(tester);
    await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -600));
    await settle(tester);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/rewarded_xp_offer.png'),
    );
    await tester.tap(find.byKey(const Key('doubleXp')));
    await settle(tester);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/rewarded_xp_doubled.png'),
    );
  });

  testWidgets('B: the streak that just ended, on the home screen', (tester) async {
    phone(tester);
    final now = DateTime.now();
    rewards
      ..streak = 9
      ..restUsedThisWeek = kRestDaysPerWeek
      ..lastSession = now.subtract(const Duration(days: 4));
    demoProfile.dayStreak = 9;
    await tester.pumpWidget(_app(const MatchScreen()));
    await settle(tester);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/rewarded_streak.png'),
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('C: a locked Pro part, worn for a day', (tester) async {
    phone(tester);
    final lifter = Lifter.fromJson({
      'skin': 'tan',
      'hair': 'inferno',
      'background': kBackgroundColors[3],
    });
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => showProTrialSheet(context, lifter: lifter),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await settle(tester);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/rewarded_pro_part.png'),
    );
  });
}
