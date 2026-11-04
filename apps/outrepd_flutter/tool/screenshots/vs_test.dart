/// Screenshots of the VS screen as each kind of match opens it — live, a
/// saved set, a rematch (the user's pick, 2026-11-04: a saved set gets the
/// same screen with a grey dot) — to see them without a phone. See shots.dart
/// for how these are run and published.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/vs_screen.dart';
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
  // The entrance is a move; a still frame shows where it lands.
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(disableAnimations: true),
    child: child!,
  ),
  home: Scaffold(body: home),
);

void main() {
  setUpAll(() async {
    final fonts = Platform.environment['SHOT_FONTS'] ?? 'tool/screenshots/fonts';
    await _font('Roboto', '$fonts/NotoSans.ttf');
    await _font('FlutterTest', '$fonts/NotoSans.ttf');
  });

  for (final kind in VsKind.values) {
    testWidgets('the VS screen, ${kind.name}', (tester) async {
      tester.view.physicalSize = const Size(412 * 2, 915 * 2);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        _app(
          VsScreen(
            opponentId: 'karim',
            opponentName: 'karim.reps',
            opponentTierIdx: 2,
            opponentDivIdx: 2,
            opponentXp: 900,
            kind: kind,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 1200));

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/vs_${kind.name}.png'),
      );
      await tester.pumpWidget(const SizedBox());
    });
  }
}
