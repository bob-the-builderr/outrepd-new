/// Screenshots of the awards (the user's picks, 2026-11-09: A), to set beside
/// design/mockups/2026-11-10/awards: the cabinet, a family's page, and a new
/// award after a match. See shots.dart for how these run.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/awards/families.dart';
import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/rewards.dart';
import 'package:outrepd/screens/awards.dart';
import 'package:outrepd/screens/moments_view.dart';
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
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(disableAnimations: true),
    child: child!,
  ),
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

  /// An account a few weeks in, as the mockup has it.
  Future<void> seasoned() async {
    // A test in all but folder: it lives in tool/ so `flutter test` skips it.
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
    await rewards.forget();
    demoProfile
      ..totalReps = 2400
      ..wins = 14
      ..bestStreak = 4
      ..bestSet = 27;
    rewards
      ..streak = 9
      ..bestStreak = 14
      ..cleanSets = 52
      ..lateSessions = 12
      ..goalDays = 31
      ..challengeTakers = 2
      ..giantWins = 1;
    rewards.earned.add(kPhotoFinish);
    await rewards.syncWithProfile(matches: 40, wins: 14, reps: 2400, friends: 6, winRun: 4, bestSet: 27);
    await rewards.setShowcase(['grinder_2', 'clean_form_3', 'champion_2']);
    awardRarity
      ..clear()
      ..addAll({'iron_will_2': 4, 'clean_form_4': 2});
  }

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

  testWidgets('the cabinet', (tester) async {
    phone(tester);
    await seasoned();
    await tester.pumpWidget(_app(const AwardsScreen()));
    await settle(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/awards_cabinet.png'));
  });

  testWidgets('a family\'s page', (tester) async {
    phone(tester);
    await seasoned();
    await tester.pumpWidget(_app(const AwardsScreen()));
    await settle(tester);
    await tester.tap(find.byKey(const Key('award_iron_will')));
    await settle(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/awards_sheet.png'));
  });

  testWidgets('a new award after a match', (tester) async {
    phone(tester);
    await seasoned();
    await tester.pumpWidget(
      _app(Scaffold(body: AwardUnlockView(title: titleById('clean_form_4')!, onContinue: () {}))),
    );
    await settle(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/awards_unlock.png'));
  });
}
