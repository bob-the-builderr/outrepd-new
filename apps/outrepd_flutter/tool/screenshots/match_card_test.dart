/// Screenshots of the card a lifter shares after a duel — a win and a loss,
/// in both shapes — to see exactly what leaves the phone. See shots.dart for
/// how these are run and published.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/share_card.dart';
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

  for (final (name, data) in [
    (
      'won',
      const MatchShareData(
        username: 'mokhtar',
        won: true,
        yourReps: 18,
        theirReps: 11,
        opponent: 'iron_mike',
        seconds: 60,
        tierIdx: 3,
        divIdx: 2,
        lpDelta: 24,
        newBest: true,
      ),
    ),
    (
      'lost',
      const MatchShareData(
        username: 'mokhtar',
        won: false,
        yourReps: 14,
        theirReps: 19,
        opponent: 'iron_mike',
        seconds: 60,
        tierIdx: 3,
        divIdx: 2,
        lpDelta: -12,
      ),
    ),
  ]) {
    for (final shape in ['Story', 'Post']) {
      testWidgets('match card $name ${shape.toLowerCase()}', (tester) async {
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
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: TextButton(
                    onPressed: () => showMatchShareSheet(context, data: data),
                    child: const Text('open'),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();
        await tester.tap(find.text(shape));
        await tester.pumpAndSettle();

        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('goldens/match_${name}_${shape.toLowerCase()}.png'),
        );
      });
    }
  }
}
