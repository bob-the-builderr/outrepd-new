/// A person, as a circle with their rank hanging off it.
///
/// The one treatment, used everywhere somebody's picture appears: the profile,
/// the leaderboard, the score card in a duel. It replaced a set of
/// painted tier frames — PNG rings from the old app, drawn around the picture
/// — which survived the redesign in three screens after the rest of the app
/// had moved on, so a lifter met two different ideas of what they look like
/// depending on which tab they opened.
///
/// An initial, never gym clip-art. The one place that is supposed to be the
/// person is the last place to put a picture of a dumbbell.
library;

import 'package:flutter/material.dart';

import 'theme.dart';
import 'tier_badge.dart';

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({
    super.key,
    required this.name,
    this.tierIdx,
    this.image,
    this.size = 48,
    this.ringColour,
    this.textColour,
    this.onTap,
    this.onBadgeTap,
  });

  /// Whose it is. The first letter is what gets drawn when there is no
  /// [photoUrl], or while it is still loading.
  final String name;

  /// Their tier, or null for somebody who has no rank to show yet — a new
  /// account, or a row where the rank is already written beside the name.
  final int? tierIdx;

  /// Null for everyone who has not set a photo — most people, most of the
  /// time — which is what makes the initial the fallback rather than a
  /// special case drawn once and forgotten. A `NetworkImage` for anyone
  /// else's uploaded photo, or a `FileImage` for this account's own picture
  /// before or between uploads — both are an `ImageProvider`, so the circle
  /// does not need to know which one it was handed.
  final ImageProvider? image;

  final double size;

  /// What the badge is ringed with, so it reads as sitting on top of the
  /// circle rather than cut out of it. Defaults to the page colour; a card
  /// with its own background passes that instead.
  final Color? ringColour;

  /// The initial's colour. Defaults to the body colour; the duel card uses it
  /// to tell the two lifters apart.
  final Color? textColour;

  final VoidCallback? onTap;

  /// Tapping the badge alone, where the badge is a way into the rank rather
  /// than decoration on the picture.
  final VoidCallback? onBadgeTap;

  @override
  Widget build(BuildContext context) {
    // The badge overhangs the circle, so the box is a little wider than it.
    final badge = size * 0.36;
    final initial = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: context.colors.surfaceRaised,
        border: Border.all(color: context.colors.border, width: 1.5),
      ),
      child: Text(
        name.isEmpty ? '?' : name.characters.first.toUpperCase(),
        style: TextStyle(
          color: textColour ?? context.colors.text,
          fontSize: size * 0.38,
        ),
      ),
    );

    final circle = image == null
        ? initial
        : Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: context.colors.border, width: 1.5),
            ),
            child: ClipOval(
              child: Image(
                image: image!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                // A photo that is still loading or failed to load reads as
                // no photo at all, not as a hole in the row — the initial is
                // never a special case, only ever the fallback.
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : initial,
                errorBuilder: (context, error, stack) => initial,
              ),
            ),
          );

    final content = tierIdx == null
        ? SizedBox(width: size, height: size, child: circle)
        : SizedBox(
            width: size + badge * 0.2,
            height: size + badge * 0.1,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                circle,
                PositionedDirectional(
                  end: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: onBadgeTap,
                    child: Container(
                      padding: EdgeInsets.all(size * 0.04),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ringColour ?? context.colors.background,
                      ),
                      child: TierBadge(tierIndex: tierIdx!, size: badge),
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
