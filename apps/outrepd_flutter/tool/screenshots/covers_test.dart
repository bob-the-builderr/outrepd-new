/// The four Pro covers the user picked (2026-11-04), drawn by the app itself
/// — still at the moment a still cover shows, and a moment later — to set
/// beside the mockup they were picked from. See shots.dart for how these are
/// run and published.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/lifter/covers.dart';

void main() {
  for (final (name, t) in const [('covers_new_1', 1.0), ('covers_new_2', 2.4)]) {
    testWidgets('the new covers at ${t}s, drawn by the app', (tester) async {
      tester.view.physicalSize = const Size(412 * 2, 1160 * 2);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: const Color(0xFF121110),
            body: Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                children: [
                  for (final id in const ['fireworks', 'fight_night', 'orbit', 'champion_podium']) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: CoverPainter.width / CoverPainter.height,
                        child: CustomPaint(painter: CoverPainter(id, ValueNotifier(t))),
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/$name.png'));
    });
  }
}
