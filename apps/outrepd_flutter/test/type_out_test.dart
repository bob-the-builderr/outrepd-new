/// The line a screen opens on, typing itself out: the text already typed must
/// stay exactly where it is while the rest arrives.
library;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/motion.dart';

void main() {
  testWidgets('typing out a centred line never moves what is already typed',
      (tester) async {
    // Reported from a phone (2026-11-04): the typing "lags strangely". The
    // cursor was a letter of its own, so the line it was on was one letter
    // wider: centred, it slid half a letter sideways and back as the cursor
    // passed through it.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 300,
              child: TypeOut(
                'Race a real person, rep for rep, live on camera.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, height: 1.6),
              ),
            ),
          ),
        ),
      ),
    );

    // The line itself: the first paragraph; the cursor is drawn by one of
    // its own, over it.
    RenderParagraph paragraph() => tester.renderObject<RenderParagraph>(
      find
          .descendant(of: find.byType(TypeOut), matching: find.byType(RichText))
          .first,
    );
    Offset firstLetter() =>
        paragraph().getOffsetForCaret(const TextPosition(offset: 0), Rect.zero);

    await tester.pump(const Duration(milliseconds: 150));
    final early = firstLetter();
    final size = paragraph().size;
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      expect(firstLetter(), early, reason: 'the typed text moved');
      expect(paragraph().size, size, reason: 'the line changed size');
    }
    await tester.pumpAndSettle();
    expect(firstLetter(), early);
  });
}
