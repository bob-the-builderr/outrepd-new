/// The player's picture inside the ring their rank earned them.
library;

import 'dart:io';

import 'package:flutter/material.dart';

import 'avatar.dart';
import 'theme.dart';

/// Where the frame's opening sits inside its own image. The artwork is square
/// with the ring's hole a little above centre, so the picture is placed by
/// these rather than simply filling the box.
const _holeDiameter = 0.56;
const _holeCentreY = 0.455;

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
    final hole = size * _holeDiameter;

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
            top: size * _holeCentreY - hole / 2,
            child: ClipOval(
              child: SizedBox(
                width: hole,
                height: hole,
                child: _AvatarContent(size: hole, username: username),
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
