/// A person, as a circle in the frame of their tier.
///
/// The one treatment, used everywhere somebody's picture appears: the profile,
/// the leaderboard, the score card in a duel. The frame (lib/tier_frame.dart)
/// is drawn in the tier badges' language and replaced the badge that used to
/// hang off the circle's corner. Long before that, PNG tier rings from the
/// old app survived in three screens after the rest had moved on; the frame
/// is drawn, not loaded, and it is the same everywhere.
///
/// A photo, or the person's lifter: the comic-ink character they made, or
/// until they make one, the one their name gives (lib/lifter/). Never an
/// initial (the user's rule, 2026-11-01).
library;

import 'package:flutter/material.dart';

import 'lifter/lifter_view.dart';
import 'lifter/my_lifter.dart';
import 'theme.dart';
import 'tier_frame.dart';

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({
    super.key,
    required this.name,
    this.tierIdx,
    this.image,
    this.size = 48,
    this.textColour,
    this.onTap,
    this.onBadgeTap,
    this.alive = false,
  });

  /// Whose it is. Their name gives the lifter drawn when there is no
  /// [image], or when it could not be loaded.
  final String name;

  /// Their tier, or null for somebody who has no rank to show yet — a new
  /// account, or a row where the rank is already written beside the name.
  final int? tierIdx;

  /// Null for everyone who has not set a photo — most people, most of the
  /// time — which is what makes the lifter the fallback rather than a
  /// special case drawn once and forgotten. A [LifterPicture] is drawn as
  /// its lifter, in vectors. A `NetworkImage` for anyone
  /// else's uploaded photo, or a `FileImage` for this account's own picture
  /// before or between uploads — both are an `ImageProvider`, so the circle
  /// does not need to know which one it was handed.
  final ImageProvider? image;

  /// The circle's diameter. A framed picture's box is wider and taller than
  /// this; see [TierFrame.widthFor].
  final double size;

  /// Kept for the callers that set it; a lifter has no letter to colour.
  final Color? textColour;

  final VoidCallback? onTap;

  /// Tapping the frame rather than the picture, where the frame is a way
  /// into the rank rather than decoration on it.
  final VoidCallback? onBadgeTap;

  /// A Pro's lifter, alive in its frame: it blinks and breathes. Only for a
  /// lifter; a photo stays a photo.
  final bool alive;

  @override
  Widget build(BuildContext context) {
    final picture = image;
    final drawn = picture is LifterPicture ? picture.lifter : lifterFor(name);
    final fallback = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: context.colors.border, width: 1.5),
      ),
      child: ClipOval(
        child: alive
            ? AliveLifter(
                lifter: drawn,
                builder: (context, shown, breath) =>
                    breathing(breath, LifterImage(shown, size: size)),
              )
            : LifterImage(drawn, size: size),
      ),
    );

    // While a photo is read — from the phone, or the first time from the
    // server — the circle stays empty: the lifter standing in for a few
    // seconds read as somebody else's picture (the user, 2026-11-05). The
    // lifter is only for a photo that could not be had.
    final blank = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.colors.border.withValues(alpha: 0.3),
        border: Border.all(color: context.colors.border, width: 1.5),
      ),
    );

    final circle = picture == null || picture is LifterPicture
        ? fallback
        : Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: context.colors.border, width: 1.5),
            ),
            child: ClipOval(
              child: Image(
                image: decodedAt(context, picture, size),
                width: size,
                height: size,
                fit: BoxFit.cover,
                frameBuilder: (context, child, frame, synchronous) =>
                    frame == null ? blank : child,
                // A photo that failed to load reads as no photo at all, not
                // as a hole in the row.
                errorBuilder: (context, error, stack) => fallback,
              ),
            ),
          );

    final content = tierIdx == null
        ? SizedBox(width: size, height: size, child: circle)
        : TierFrame(
            tierIdx: tierIdx,
            size: size,
            onTap: onBadgeTap,
            child: circle,
          );

    if (onTap == null) return content;
    return GestureDetector(onTap: onTap, child: content);
  }
}

/// [picture] decoded at the pixels a circle [size] across needs, not at the
/// size it was uploaded (800 px square).
///
/// A board draws up to a hundred of these. Decoded whole, each is 2.5 MB of
/// memory against Flutter's 100 MB image cache — a long board pushed
/// pictures out as it scrolled and decoded them again, which is jank on a
/// slow phone. At 40 px on a 3x screen one is 58 KB. What is drawn is the
/// same: it is shown no larger than this anyway.
ImageProvider decodedAt(BuildContext context, ImageProvider picture, double size) =>
    ResizeImage.resizeIfNeeded(
      (size * MediaQuery.devicePixelRatioOf(context)).ceil(),
      null,
      picture,
    );
