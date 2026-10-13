/// The frame a lifter's picture wears: their tier, drawn around it in place
/// of the badge that used to hang off its corner.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/player_avatar.dart';
import 'package:outrepd/theme.dart';
import 'package:outrepd/tier_badge.dart';
import 'package:outrepd/tier_frame.dart';

Widget _app(Widget child) => MaterialApp(
      theme: buildTheme(Brightness.dark),
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  for (final size in [40.0, 52.0, 78.0]) {
    testWidgets('every tier draws at $size', (tester) async {
      await tester.pumpWidget(_app(SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var tier = 0; tier < 7; tier++)
              TierFrame(
                tierIdx: tier,
                size: size,
                child: SizedBox(width: size, height: size),
              ),
          ],
        ),
      )));
      expect(tester.takeException(), isNull);
      expect(find.byType(TierFrame), findsNWidgets(7));
    });
  }

  for (final size in [20.0, 34.0, 206.0]) {
    testWidgets('every badge draws at $size, whole, hollow and unranked',
        (tester) async {
      await tester.pumpWidget(_app(SingleChildScrollView(
        child: Wrap(
          children: [
            for (var tier = 0; tier < 7; tier++) ...[
              TierBadge(tierIndex: tier, size: size),
              TierBadge(tierIndex: tier, size: size, locked: true),
            ],
            TierBadge.unranked(size: size),
          ],
        ),
      )));
      expect(tester.takeException(), isNull);
      expect(find.byType(TierBadge), findsNWidgets(15));
    });
  }

  test("Master's frame wears the same closed wing as its badge", () {
    // Five feathers a side either way; Master's are its fan, which the
    // frame reads from the badge rather than keeping a copy.
    expect(crestOf(6).wingShapes, hasLength(5));
    expect(crestOf(0).wingShapes, isEmpty);
    for (final shape in crestOf(6).wingShapes) {
      expect(shape, hasLength(4));
      expect(shape.first.dx, 98, reason: 'a root on the shield edge');
      expect(shape.last.dx, 98, reason: 'a root on the shield edge');
    }
  });

  testWidgets('the same box for every tier, so a list lines up',
      (tester) async {
    await tester.pumpWidget(_app(Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final tier in [0, 6, null])
          TierFrame(
            tierIdx: tier,
            size: 40,
            child: const SizedBox(width: 40, height: 40),
          ),
      ],
    )));
    for (final box in tester.widgetList(find.byType(TierFrame))) {
      expect(tester.getSize(find.byWidget(box)),
          Size(TierFrame.widthFor(40), TierFrame.heightFor(40)));
    }
  });

  testWidgets('a ranked picture wears the frame, not the badge',
      (tester) async {
    await tester.pumpWidget(_app(const PlayerAvatar(name: 'karimfit', tierIdx: 3, size: 52)));
    expect(find.byType(TierFrame), findsOneWidget);
    expect(find.byType(TierBadge), findsNothing);
  });

  testWidgets('a picture still in its placements wears nothing',
      (tester) async {
    await tester.pumpWidget(_app(const PlayerAvatar(name: 'new_lifter', size: 52)));
    expect(find.byType(TierFrame), findsNothing);
    expect(tester.getSize(find.byType(PlayerAvatar)), const Size(52, 52));
  });

  testWidgets('the picture changes the photo, the frame opens the rank',
      (tester) async {
    var photo = 0, rank = 0;
    await tester.pumpWidget(_app(PlayerAvatar(
      name: 'dr_moh',
      tierIdx: 4,
      size: 78,
      onTap: () => photo++,
      onBadgeTap: () => rank++,
    )));

    final centre = tester.getCenter(find.byType(TierFrame));
    await tester.tapAt(centre);
    expect((photo, rank), (1, 0));

    // Out on a wing, well clear of the circle.
    await tester.tapAt(centre.translate(78 * 0.85, 0));
    expect((photo, rank), (1, 1));
  });
}
