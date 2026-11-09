/// Screenshots of beat your past self (the user's picks, 2026-11-09: A,
/// free), to set beside design/mockups/2026-11-10/past_*: starting a plan,
/// the plan in its second week, today's plan on the Match tab in place of
/// today's goal, and the week's race won. The VS screen before the race is
/// vs_test.dart's vs_pastSelf. See shots.dart for how these run.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/plan.dart';
import 'package:outrepd/screens/match.dart';
import 'package:outrepd/screens/plan_screen.dart';
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

/// Begun on Tuesday 10 November 2026, from 24 towards 36, three days a
/// week; Monday of week two done, one set in on Wednesday.
TrainingPlan _plan({Map<int, int> races = const {1: 26}}) => TrainingPlan(
  start: 24,
  goal: 36,
  days: 3,
  began: dayNumber(DateTime(2026, 11, 10)),
  sets: {
    dayNumber(DateTime(2026, 11, 11)): 3,
    dayNumber(DateTime(2026, 11, 13)): 3,
    dayNumber(DateTime(2026, 11, 16)): 3,
    dayNumber(DateTime(2026, 11, 18)): 1,
  },
  races: races,
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
  });
  tearDown(() => trainingPlan = PlanStore());

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

  /// A Wednesday in week two.
  void wednesday() {
    trainingPlan = PlanStore(clock: () => DateTime(2026, 11, 18, 9));
    // ignore: invalid_use_of_visible_for_testing_member
    trainingPlan.debugPlan = _plan();
    // ignore: invalid_use_of_visible_for_testing_member
    trainingPlan.debugLastWeek = const PastSelf(reps: 26);
  }

  testWidgets('starting a plan', (tester) async {
    phone(tester);
    demoProfile.bestSet = 24;
    await tester.pumpWidget(_app(const PlanSetupScreen()));
    await settle(tester);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/plan_setup.png'),
    );
  });

  testWidgets('the plan, week two', (tester) async {
    phone(tester);
    wednesday();
    await tester.pumpWidget(_app(const PlanScreen()));
    await settle(tester);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/plan_page.png'),
    );
  });

  testWidgets('today\'s plan on the Match tab', (tester) async {
    phone(tester);
    wednesday();
    await tester.pumpWidget(_app(const MatchScreen()));
    await settle(tester);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/plan_home.png'),
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('the week\'s race, won', (tester) async {
    phone(tester);
    trainingPlan = PlanStore(clock: () => DateTime(2026, 11, 22, 11));
    // ignore: invalid_use_of_visible_for_testing_member
    trainingPlan.debugPlan = _plan(races: const {1: 26, 2: 29});
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: PastSelfResultView(
            mine: 29,
            theirs: 26,
            onDone: () {},
            xp: const XpGain(before: 4180, after: 4180 + 29, reps: 29),
          ),
        ),
      ),
    );
    await settle(tester);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/past_self_result.png'),
    );
  });
}
