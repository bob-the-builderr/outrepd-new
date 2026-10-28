/// Screenshots of onboarding's first screens as the app draws them: the
/// welcome, the idea's three cards — the live match, the rep rule part way
/// through a rep, the ladder — and the camera's question. See shots.dart for
/// how these are run and published.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/onboarding.dart';
import 'package:outrepd/theme.dart';

Future<void> _font(String family, String path) async {
  final file = File(path);
  if (!file.existsSync()) return;
  final bytes = file.readAsBytesSync();
  final loader = FontLoader(family)
    ..addFont(Future.value(ByteData.view(bytes.buffer)));
  await loader.load();
}

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

  testWidgets('onboarding idea', (tester) async {
    tester.view.physicalSize = const Size(412 * 2, 915 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
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
        home: const OnboardingScreen(),
      ),
    );

    // Pictures decode outside the test's fake time, so they are loaded
    // first; otherwise every one of them is a blank box in the shot.
    final context = tester.element(find.byType(OnboardingScreen));
    await tester.runAsync(
      () => Future.wait([
        for (final name in [
          'logo-wordmark.png',
          'onboarding_live.jpg',
        ])
          precacheImage(AssetImage('assets/images/$name'), context),
      ]),
    );

    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/onboarding_welcome.png'),
    );

    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/onboarding_idea_1.png'),
    );

    // Part way back up, past the gold line: the bottom line green, the top
    // one lit, the second step named.
    await tester.tap(find.text('Next'));
    for (var i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/onboarding_idea_2.png'),
    );

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/onboarding_idea_3.png'),
    );

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('13 or over'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('I understand outrepd counts reps'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/onboarding_camera.png'),
    );
  });
}
