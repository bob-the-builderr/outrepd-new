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

import 'dart:async';

import 'package:flutter/material.dart';

import 'lifter/catalog.dart';
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
    this.lifter,
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

  /// The lifter drawn when there is no [image], and in a photo's place while
  /// it comes down: the one they made (face.dart). Null for the one [name]
  /// gives.
  final Lifter? lifter;

  @override
  Widget build(BuildContext context) {
    final picture = image;
    final drawn = picture is LifterPicture
        ? picture.lifter
        : lifter ?? lifterFor(name);
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
              child: PhotoOrLifter(
                image: decodedAt(context, picture, size),
                size: size,
                lifter: fallback,
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

/// A photo, square to [size], with [lifter] standing in until it is drawn.
///
/// A photo already on the phone draws within a frame or two, and nothing
/// stands in for it: the lifter flashing first read as somebody else's
/// picture (the user, 2026-11-05). One still on its way from the server — a
/// few seconds, the first time — shows [lifter] after [kPhotoWait] rather
/// than an empty circle, which read as no picture at all (the same day). A
/// photo that cannot be had stays [lifter].
class PhotoOrLifter extends StatefulWidget {
  const PhotoOrLifter({
    super.key,
    required this.image,
    required this.size,
    required this.lifter,
  });

  final ImageProvider image;
  final double size;
  final Widget lifter;

  @override
  State<PhotoOrLifter> createState() => _PhotoOrLifterState();
}

/// How long a photo may take before [PhotoOrLifter.lifter] stands in.
const kPhotoWait = Duration(milliseconds: 500);

class _PhotoOrLifterState extends State<PhotoOrLifter> {
  Timer? _wait;
  bool _late = false;

  @override
  void initState() {
    super.initState();
    _wait = Timer(kPhotoWait, () {
      if (mounted) setState(() => _late = true);
    });
  }

  @override
  void didUpdateWidget(PhotoOrLifter old) {
    super.didUpdateWidget(old);
    if (old.image != widget.image) {
      _wait?.cancel();
      _late = false;
      _wait = Timer(kPhotoWait, () {
        if (mounted) setState(() => _late = true);
      });
    }
  }

  @override
  void dispose() {
    _wait?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Image(
    image: widget.image,
    width: widget.size,
    height: widget.size,
    fit: BoxFit.cover,
    // Kept on screen while the next one loads, so a row being drawn again
    // does not blink.
    gaplessPlayback: true,
    frameBuilder: (context, child, frame, synchronous) {
      if (frame != null) {
        _wait?.cancel();
        return child;
      }
      return _late ? widget.lifter : SizedBox(width: widget.size, height: widget.size);
    },
    errorBuilder: (context, error, stack) => widget.lifter,
  );
}
