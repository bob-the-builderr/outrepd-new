/// Screenshots of moments (the user's picks, 2026-11-09: A and the month),
/// to set beside design/mockups/2026-11-10/moments: a new personal best, a
/// milestone, last month's card on the Match tab, and the recap. See
/// shots.dart for how these run.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/moments.dart';
import 'package:outrepd/screens/match.dart';
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

/// November 2026 as the mockup has it.
const _days = [0, 40, 60, 0, 35, 80, 120, 0, 50, 70, 90, 0, 60, 110, 30, 0, 75, 95, 40, 0, 85, 160, 70, 0, 55, 100, 65, 0, 45, 90];

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
  tearDown(() => recaps = RecapStore());

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(412 * 2, 915 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
  }

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('a new personal best', (tester) async {
    phone(tester);
    await tester.pumpWidget(
      _app(Scaffold(body: PersonalBestView(best: const PersonalBest(reps: 27, before: 24), onContinue: () {}))),
    );
    await settle(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/moment_best.png'));
  });

  testWidgets('a milestone', (tester) async {
    phone(tester);
    await tester.pumpWidget(
      _app(Scaffold(body: MilestoneView(mark: const Milestone(mark: 1000, total: 1012), onContinue: () {}))),
    );
    await settle(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/moment_milestone.png'));
  });

  testWidgets('last month\'s card on the Match tab', (tester) async {
    phone(tester);
    recaps = RecapStore(
      clock: () => DateTime(2026, 12, 2),
      repsOn: (d) => d.year == 2026 && d.month == 11 ? _days[d.day - 1] : 0,
    );
    await tester.pumpWidget(_app(const MatchScreen()));
    await settle(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/recap_card.png'));
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });

  testWidgets('the month', (tester) async {
    phone(tester);
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: MonthRecapView(
            recap: MonthRecap(
              month: DateTime(2026, 11),
              days: _days,
              numbers: const MonthNumbers(reps: 1240, sets: 52, best: 27, bestBefore: 24, wins: 14, losses: 6),
            ),
            onDone: () {},
          ),
        ),
      ),
    );
    await settle(tester);
    await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/recap.png'));
  });
}
