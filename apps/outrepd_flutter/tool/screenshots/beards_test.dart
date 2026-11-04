/// Every beard with an open mouth on it, head and shoulders: whether the mouth
/// shows through a beard round the jaw and sits under a moustache (the user,
/// 2026-11-04: with a full beard on, the mouth was gone). See shots.dart for
/// how these are run and published.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/lifter/catalog.dart';
import 'package:outrepd/lifter/lifter_art.dart' show LifterView;
import 'package:outrepd/lifter/lifter_view.dart';

void main() {
  testWidgets('every beard, with a mouth', (tester) async {
    tester.view.physicalSize = const Size(412 * 2, 560 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    // Teeth, a grin and a shout: three mouths, every beard.
    const mouths = [1, 2, 3];
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFF121110),
          body: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                for (final mouth in mouths)
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      for (var beard = 0; beard < kBeards.length; beard++)
                        LifterImage(
                          Lifter(beard: beard, mouth: mouth, hairColor: 2),
                          size: 64,
                          view: LifterView.head,
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    // The pictures are SVG, drawn a frame or two after they are asked for.
    await tester.pump(const Duration(milliseconds: 1200));
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/beards.png'),
    );
  });
}
