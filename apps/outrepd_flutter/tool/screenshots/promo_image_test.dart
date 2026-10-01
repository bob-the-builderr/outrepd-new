/// The subscription's promotional image for App Store Connect: 1024 by 1024,
/// square-cornered and opaque — the app's name with REP in the rival colour
/// it wears in the wordmark, and a PRO badge under it. See shots.dart for how
/// these are run and published.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

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

void main() {
  setUpAll(() async {
    final fonts = Platform.environment['SHOT_FONTS'] ?? 'tool/screenshots/fonts';
    final roboto = [
      for (final w in ['Regular', 'Medium', 'Bold']) '$fonts/Roboto-$w.ttf',
    ];
    final face = File(roboto.first).existsSync()
        ? roboto
        : ['$fonts/NotoSans.ttf'];
    await _font('Roboto', face);
  });

  testWidgets('promo image pro 1024', (tester) async {
    tester.view.physicalSize = const Size(1024, 1024);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    const cream = Color(0xFFE8DCC8);
    final name = TextStyle(
      fontFamily: 'Roboto',
      fontSize: 150,
      fontWeight: FontWeight.w900,
      letterSpacing: 2,
      color: cream,
      height: 1,
    );

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: RepaintBoundary(
          key: const Key('promo'),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.6, -1),
                end: Alignment(0.6, 1),
                colors: [Color(0xFF1C1A18), Color(0xFF121110)],
                stops: [0, 0.6],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(
                    TextSpan(
                      style: name,
                      children: [
                        const TextSpan(text: 'OUT'),
                        TextSpan(
                          text: 'REP',
                          style: name.copyWith(color: kDarkPalette.rival),
                        ),
                        const TextSpan(text: 'D'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                  Container(
                    padding: const EdgeInsets.fromLTRB(84, 18, 70, 18),
                    decoration: BoxDecoration(
                      color: cream,
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: const Text(
                      'PRO',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 88,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 14,
                        color: Color(0xFF121110),
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await expectLater(
      find.byKey(const Key('promo')),
      matchesGoldenFile('goldens/promo_pro_1024.png'),
    );
  });
}
