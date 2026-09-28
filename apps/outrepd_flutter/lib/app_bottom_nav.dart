/// The four-item bottom navigation.
///
/// Built from the supplied reference, with three changes: the colours come
/// from the theme rather than from literals, the labels come from the ARB
/// files, and each label is allowed to shrink — four fixed-width tabs have to
/// hold a word in thirteen languages at whatever text size the reader has set,
/// and an ellipsis through "プロフィール" is worse than a point smaller.
library;

import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'theme.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.friendRequestCount = 0,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  /// How many friend requests are waiting. A friend request is the one thing
  /// in the app that arrives without you asking, so the tab is where you find
  /// out — otherwise it sits unanswered until somebody opens the list.
  final int friendRequestCount;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    // A floating card rather than a bar welded to the bottom edge: hairline
    // border all the way round, 14dp corners, and a gap on three sides.
    //
    // It still sits in the Scaffold's bottomNavigationBar slot, so the body is
    // laid out above it and nothing is hidden underneath — the bar reserves
    // its own height plus the margin, and the page colour showing through the
    // gap is what makes it read as lifted.
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.colors.border, width: 0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 11, bottom: 14),
            child: Row(
              children: [
                _NavItem(
                  label: l.tabMatch,
                  icon: const SwordsIcon(),
                  selected: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                _NavItem(
                  label: l.tabFriends,
                  icon: const Icon(Icons.people_outline, size: 22),
                  selected: currentIndex == 1,
                  badgeCount: friendRequestCount,
                  onTap: () => onTap(1),
                ),
                _NavItem(
                  label: l.tabRanks,
                  icon: const Icon(Icons.emoji_events_outlined, size: 22),
                  selected: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
                _NavItem(
                  label: l.tabProfile,
                  icon: const Icon(Icons.person_outline, size: 22),
                  selected: currentIndex == 3,
                  onTap: () => onTap(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.badgeCount = 0,
  });

  final String label;
  final Widget icon;
  final bool selected;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    final colour = selected ? context.colors.brand : context.colors.muted;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: onTap,
          // No ripple: it looks wrong over a warm dark bar.
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Wide enough to hold the badge as well as the icon. The badge
                // used to hang outside the stack on a negative offset, which
                // is fine until something above it clips — and then it
                // vanishes with nothing on screen to say why.
                SizedBox(
                  width: 44,
                  height: 22,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      IconTheme(
                        data: IconThemeData(color: colour, size: 22),
                        child: icon,
                      ),
                      if (badgeCount > 0)
                        PositionedDirectional(
                          top: -2,
                          start: 24,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              // Rival, not brand: somebody else is asking for
                              // something, and it has to read differently
                              // from the colour that means "you".
                              color: context.colors.rival,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              badgeCount > 9 ? '9+' : '$badgeCount',
                              style: TextStyle(
                                color: context.colors.background,
                                fontSize: 9,
                                height: 1.2,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      maxLines: 1,
                      style: TextStyle(
                        color: colour,
                        fontSize: 10,
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Crossed swords. Material has no equivalent, so it is painted.
class SwordsIcon extends StatelessWidget {
  const SwordsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final colour = IconTheme.of(context).color ?? context.colors.muted;
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: _SwordsPainter(colour)),
    );
  }
}

class _SwordsPainter extends CustomPainter {
  _SwordsPainter(this.colour);
  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final blade = Paint()
      ..color = colour
      ..strokeWidth = s * 0.09
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Two blades crossing just above centre.
    canvas.drawLine(
      Offset(s * 0.16, s * 0.86),
      Offset(s * 0.80, s * 0.14),
      blade,
    );
    canvas.drawLine(
      Offset(s * 0.84, s * 0.86),
      Offset(s * 0.20, s * 0.14),
      blade,
    );

    // Short hilts at the bottom of each blade.
    canvas.drawLine(
      Offset(s * 0.10, s * 0.66),
      Offset(s * 0.30, s * 0.86),
      blade,
    );
    canvas.drawLine(
      Offset(s * 0.90, s * 0.66),
      Offset(s * 0.70, s * 0.86),
      blade,
    );
  }

  @override
  bool shouldRepaint(covariant _SwordsPainter old) => old.colour != colour;
}
