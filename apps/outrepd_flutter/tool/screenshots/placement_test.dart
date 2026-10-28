/// A screenshot of onboarding's phone-placement step, the drawing of the
/// lifter in front of the phone. See shots.dart for how these are run and
/// published.
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

  for (final brightness in Brightness.values) {
    testWidgets('onboarding placement ${brightness.name}', (tester) async {
      tester.view.physicalSize = const Size(412 * 2, 915 * 2);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      final theme = buildTheme(brightness);
      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          locale: const Locale('en'),
          localizationsDelegates: const [
            L.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: L.supportedLocales,
          home: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: SafeArea(child: PlacementStep(onNext: () {})),
          ),
        ),
      );
      // The picture decodes outside the test's fake time; without this it
      // is an empty frame in the shot.
      final context = tester.element(find.byType(PlacementStep));
      await tester.runAsync(
        () => precacheImage(
          const AssetImage('assets/images/onboarding_view.jpg'),
          context,
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/onboarding_placement_${brightness.name}.png'),
      );
    });
  }
}
