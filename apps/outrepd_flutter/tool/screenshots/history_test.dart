/// A screenshot of the match history, as the app draws it. See shots.dart for
/// how these are run and published.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/match_history.dart';
import 'package:outrepd/theme.dart';

Future<void> _font(String family, String path) async {
  final file = File(path);
  if (!file.existsSync()) return;
  final bytes = file.readAsBytesSync();
  final loader = FontLoader(family)
    ..addFont(Future.value(ByteData.view(bytes.buffer)));
  await loader.load();
}

MatchRecord _match(String who, int mine, int theirs, int lp, int daysAgo) =>
    MatchRecord(
      won: mine >= theirs,
      userReps: mine,
      opponentReps: theirs,
      opponent: who,
      lpChange: lp,
      at: DateTime.now().subtract(Duration(days: daysAgo)),
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

  testWidgets('match history', (tester) async {
    tester.view.physicalSize = const Size(412 * 2, 915 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    matchHistory
      ..clear()
      ..addAll([
        _match('karimfit', 18, 11, 7, 0),
        _match('sara.lifts', 14, 19, -5, 0),
        _match('aly99', 22, 20, 2, 1),
        _match('nour_x', 25, 12, 13, 1),
        _match('omarpush', 9, 16, -7, 3),
        _match('a_friend', 12, 9, 0, 3),
        _match('youssef_r', 20, 14, 6, 3),
        _match('hana.m', 17, 21, -4, 5),
        _match('ziad10', 23, 15, 8, 5),
        _match('mariam_k', 19, 18, 1, 9),
      ]);
    addTearDown(matchHistory.clear);

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
        home: const MatchHistoryScreen(),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/match_history.png'),
    );
  });
}
