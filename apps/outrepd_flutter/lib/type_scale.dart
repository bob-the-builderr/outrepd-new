/// The app's type scale.
///
/// Before this file the app wrote **210 font sizes by hand across 25 distinct
/// values**, eight of them crammed between 11 and 14.5. Nobody can see 12
/// against 12.5. Everybody feels the inconsistency, on every screen at once,
/// as the difference between something made and something assembled.
///
/// Six steps, each with a job:
///
/// | step      | size | used for                                        |
/// |-----------|------|-------------------------------------------------|
/// | `display` | 44   | the one number a screen is about                |
/// | `title`   | 24   | screen titles, a rank, a username               |
/// | `heading` | 18   | section headers, an exercise name, a big button |
/// | `body`    | 15   | ordinary text                                   |
/// | `label`   | 13   | captions, hints, the second line of a row       |
/// | `micro`   | 11   | overlines — tracked out and upper-cased         |
///
/// Colour is deliberately NOT baked in. Every style arrives colourless and the
/// caller says what it is for — `context.type.label` on a muted caption, on a
/// brand-coloured link, on a red warning. Baking a default would only mean
/// half the call sites immediately overriding it.
///
/// [micro] is never applied automatically. It carries 1.6 of letter spacing,
/// which is right for a short upper-cased overline and wrong for a sentence,
/// so it goes on by hand where an overline is actually meant.
library;

import 'package:flutter/material.dart';

@immutable
class AppType {
  const AppType();

  /// The hero number: a rep count, an LP total, a match score.
  ///
  /// Tabular figures, always. Proportional digits change width as they change
  /// value, so a live count shudders sideways every time it ticks — which in a
  /// counting app is the difference between a scoreboard and a text field.
  TextStyle get display => const TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.8,
        height: 1,
        fontFeatures: [FontFeature.tabularFigures()],
      );

  /// A stat tile's number: smaller than [display] because several sit in a row,
  /// but still the thing the eye lands on first.
  TextStyle get statValue => const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.2,
        height: 1,
        fontFeatures: [FontFeature.tabularFigures()],
      );

  TextStyle get title => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.4,
      );

  TextStyle get heading => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
      );

  TextStyle get body => const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
      );

  TextStyle get label => const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
      );

  /// An overline. Upper-cased at the call site — at 11px the extra tracking is
  /// what keeps it legible rather than cramped.
  TextStyle get micro => const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.6,
      );

  /// A number inside a row of text — a stat value, a figure in a table. Heavier
  /// than the text around it and tabular, so a column of them lines up.
  TextStyle get figure => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        fontFeatures: [FontFeature.tabularFigures()],
      );
}

const kType = AppType();

extension AppTypeAccess on BuildContext {
  /// Mirrors `context.colors`, so a widget reaches for its type the same way it
  /// reaches for its palette.
  AppType get type => kType;
}
