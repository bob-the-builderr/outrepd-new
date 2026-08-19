/// The player's picture inside the ring their rank earned them.
library;

import 'dart:io';

import 'package:flutter/material.dart';

import 'avatar.dart';
import 'theme.dart';

/// Where a frame's opening sits inside its own image.
///
/// The nine were drawn separately and their openings differ by a lot — the
/// master ring's hole is barely three quarters the width of the gold one's, and
/// they sit at different heights. One set of numbers left most pictures either
/// rattling around inside the ring or spilling over it.
///
/// These were measured from each file's own alpha channel rather than by eye,
/// by D:/outrepd-tools/measure_frames.py. Rerun it if the artwork changes.
/// An opening is an **ellipse**, not a circle. Every one of the nine is taller
/// than it is wide — gold's is 0.537 across and 0.588 down — so a single radius
/// could only ever fit one axis: set it to the width and the picture fell short
/// of the ring top and bottom; set it to the height and it spilled over the
/// metal at the sides. That is what a circle in an oval hole looks like.
class FrameHole {
  const FrameHole(this.cx, this.cy, this.width, this.height);
  final double cx;
  final double cy;
  final double width;
  final double height;
}

const kFrameHoles = <String, FrameHole>{
  'bronze': FrameHole(0.501, 0.445, 0.478, 0.491),
  'diamond': FrameHole(0.500, 0.502, 0.453, 0.482),
  'gold': FrameHole(0.500, 0.494, 0.537, 0.588),
  'legend': FrameHole(0.502, 0.504, 0.449, 0.540),
  'master': FrameHole(0.500, 0.526, 0.426, 0.471),
  'mythic': FrameHole(0.499, 0.540, 0.467, 0.540),
  'platinum': FrameHole(0.500, 0.524, 0.514, 0.564),
  'silver': FrameHole(0.498, 0.464, 0.467, 0.548),
  'stone': FrameHole(0.500, 0.485, 0.529, 0.641),
};

/// Grown a hair past the measured opening so the picture tucks under the ring
/// instead of leaving a hairline of background between the two. Small, because
/// the shape now matches: the old value had to be generous to cover the gap a
/// circle left in an oval.
const _overlap = 1.03;

const _fallbackHole = FrameHole(0.5, 0.5, 0.46, 0.5);

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.tierIdx,
    this.size = 120,
    this.onTap,
    this.username,
  });

  /// Decides which ring is drawn — a promotion changes the frame with nothing
  /// else to update.
  final int tierIdx;

  final double size;
  final VoidCallback? onTap;

  /// Somebody else. Their picture is not on this phone, so one is derived from
  /// their name — the same name always gives the same avatar, which is what
  /// makes a face recognisable down a list.
  ///
  /// Null means the player themselves, drawn from what they actually chose.
  final String? username;

  @override
  Widget build(BuildContext context) {
    final tier = kTiers[tierIdx.clamp(0, kTiers.length - 1)];
    final measured = kFrameHoles[tier.name.toLowerCase()] ?? _fallbackHole;
    final holeW = size * measured.width * _overlap;
    final holeH = size * measured.height * _overlap;

    final content = SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The picture goes down first: the ring's inner edge then overlaps
          // it, which hides the seam a circle-clipped photo would otherwise
          // show against the metal.
          Positioned(
            left: size * measured.cx - holeW / 2,
            top: size * measured.cy - holeH / 2,
            // ClipOval on an oblong box gives an ellipse, which is the shape
            // the opening actually is.
            child: ClipOval(
              child: SizedBox(
                width: holeW,
                height: holeH,
                // A face is square; the hole is not. Fill on the long axis and
                // let the clip trim the sides, so nobody gets stretched.
                child: FittedBox(
                  fit: BoxFit.cover,
                  clipBehavior: Clip.hardEdge,
                  child: SizedBox(
                    width: holeW,
                    height: holeW,
                    child: _AvatarContent(size: holeW, username: username),
                  ),
                ),
              ),
            ),
          ),
          Image.asset(
            tier.frame,
            width: size,
            height: size,
            fit: BoxFit.contain,
            // A missing frame must not blank the picture out.
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          ),
          if (onTap != null)
            Positioned(
              // Clear of the frame's lower wings, which reach further out
              // than the ring does.
              right: size * 0.02,
              bottom: size * 0.10,
              child: Container(
                width: size * 0.20,
                height: size * 0.20,
                decoration: BoxDecoration(
                  color: context.colors.brand,
                  shape: BoxShape.circle,
                  border: Border.all(color: context.colors.background, width: 2),
                ),
                child: Icon(
                  Icons.edit,
                  size: size * 0.10,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );

    if (onTap == null) return content;
    return GestureDetector(onTap: onTap, child: content);
  }
}

/// Whatever the player chose: their photo, or an icon on a colour.
class _AvatarContent extends StatelessWidget {
  const _AvatarContent({required this.size, this.username});
  final double size;
  final String? username;

  @override
  Widget build(BuildContext context) {
    if (username != null) return _forName(context, username!);

    return ListenableBuilder(
      listenable: avatar,
      builder: (context, _) {
        if (avatar.hasPhoto) {
          return Image.file(
            File(avatar.photoPath!),
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _builtIn(context),
          );
        }
        return _builtIn(context);
      },
    );
  }

  /// Same name, same avatar, every time and on every device — a hash rather
  /// than anything random.
  Widget _forName(BuildContext context, String name) {
    var hash = 0;
    for (final unit in name.codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    return _paint(
      context,
      kAvatarIcons[hash % kAvatarIcons.length],
      kAvatarColors[(hash ~/ kAvatarIcons.length) % kAvatarColors.length],
    );
  }

  Widget _builtIn(BuildContext context) =>
      _paint(context, avatar.icon, avatar.colour);

  Widget _paint(BuildContext context, IconData icon, Color colour) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(colour, Colors.white, 0.25)!,
            Color.lerp(colour, Colors.black, 0.35)!,
          ],
        ),
      ),
      child: Center(
        child: Icon(icon, size: size * 0.5, color: Colors.white),
      ),
    );
  }
}
