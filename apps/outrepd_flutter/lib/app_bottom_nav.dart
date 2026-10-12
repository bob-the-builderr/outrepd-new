/// The four-item bottom navigation.
///
/// The open tab is a cream pill with its name in it; the others are icons
/// alone. The pill slides and widens to whichever tab is opened, so the bar
/// says where you are by shape as well as colour, and the names that are not
/// needed right now stop crowding it. Each label may still shrink — a word
/// in thirteen languages, at whatever text size the reader has set.
library;

import 'package:flutter/foundation.dart'
    show LicenseEntryWithLineBreaks, LicenseRegistry;
import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'motion.dart';
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
    // border all the way round, round ends, and a gap on three sides. It
    // still sits in the Scaffold's bottomNavigationBar slot, so nothing is
    // laid out underneath it.
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: context.colors.border, width: 0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
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
                  icon: const Icon(Icons.people_outline),
                  selected: currentIndex == 1,
                  badgeCount: friendRequestCount,
                  onTap: () => onTap(1),
                ),
                _NavItem(
                  label: l.tabRanks,
                  icon: const Icon(Icons.emoji_events_outlined),
                  selected: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
                _NavItem(
                  label: l.tabProfile,
                  icon: const Icon(Icons.person_outline),
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
    // 0 closed, 1 open: the slot's share of the bar, the pill's colour and
    // how much of the name shows all move together.
    return TweenAnimationBuilder<double>(
      tween: Tween(end: selected ? 1 : 0),
      duration: reduceMotion(context)
          ? Duration.zero
          : const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) {
        final ink = Color.lerp(
          context.colors.muted,
          context.colors.background,
          t,
        )!;
        return Expanded(
          flex: 100 + (130 * t).round(),
          child: Semantics(
            button: true,
            selected: selected,
            label: label,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (!selected) tap();
                onTap();
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: context.colors.brand.withValues(alpha: t),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _IconWithBadge(icon: icon, colour: ink, count: badgeCount),
                    // The name, as wide as the pill is open: all of it when
                    // open, none of it closed, and in the tree either way.
                    Flexible(
                      child: ClipRect(
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          widthFactor: t,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(start: 8),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                label,
                                maxLines: 1,
                                style: TextStyle(
                                  color: ink,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                ),
                              ),
                            ),
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
      },
    );
  }
}

class _IconWithBadge extends StatelessWidget {
  const _IconWithBadge({
    required this.icon,
    required this.colour,
    required this.count,
  });

  final Widget icon;
  final Color colour;
  final int count;

  @override
  Widget build(BuildContext context) {
    // Wide enough to hold the badge as well as the icon, so nothing above
    // can clip it away.
    return SizedBox(
      width: 30,
      height: 26,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          IconTheme(
            data: IconThemeData(color: colour, size: 26),
            child: icon,
          ),
          if (count > 0)
            PositionedDirectional(
              top: -5,
              start: 17,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  // Rival, not brand: somebody else is asking for something,
                  // and it has to read differently from the colour that
                  // means "you".
                  color: context.colors.rival,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  count > 9 ? '9+' : '$count',
                  style: TextStyle(
                    color: context.colors.background,
                    fontSize: 11,
                    height: 1.2,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Crossed swords: Tabler Icons' `swords`, the icon the bar was picked from
/// (MIT; its licence is on the app's licences page, see
/// [registerIconLicences]). Material has no equivalent, so it is painted from
/// Tabler's own outline, on its 24-unit grid with its 2-unit stroke.
class SwordsIcon extends StatelessWidget {
  const SwordsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final colour = IconTheme.of(context).color ?? context.colors.muted;
    final size = IconTheme.of(context).size ?? 22;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _SwordsPainter(colour)),
    );
  }
}

class _SwordsPainter extends CustomPainter {
  _SwordsPainter(this.colour);
  final Color colour;

  /// Tabler's four strokes, each a run of points on the 24-unit grid.
  static const _strokes = [
    // The sword in front, tip at the top right and hilt at the bottom
    // left, as one closed outline.
    [(21.0, 3.0), (21.0, 8.0), (10.0, 17.0), (6.0, 21.0), (3.0, 18.0),
      (7.0, 14.0), (16.0, 3.0), (21.0, 3.0)],
    // Its guard.
    [(5.0, 13.0), (11.0, 19.0)],
    // The sword behind it: its hilt end, bottom right...
    [(14.32, 17.32), (18.0, 21.0), (21.0, 18.0), (17.635, 14.635)],
    // ...and its tip, top left. Its middle is hidden by the front sword.
    [(10.0, 5.5), (8.0, 3.0), (3.0, 3.0), (3.0, 8.0), (6.0, 10.5)],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 24;
    final pen = Paint()
      ..color = colour
      ..strokeWidth = 2 * unit
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    for (final points in _strokes) {
      final path = Path()..moveTo(points[0].$1 * unit, points[0].$2 * unit);
      for (final (x, y) in points.skip(1)) {
        path.lineTo(x * unit, y * unit);
      }
      canvas.drawPath(path, pen);
    }
  }

  @override
  bool shouldRepaint(covariant _SwordsPainter old) => old.colour != colour;
}

/// Puts Tabler Icons' licence on the app's licences page, which MIT asks
/// for wherever its work is copied — here, the swords above.
void registerIconLicences() {
  LicenseRegistry.addLicense(
    () => Stream.value(
      const LicenseEntryWithLineBreaks(['Tabler Icons'], _tablerLicence),
    ),
  );
}

const _tablerLicence = '''MIT License

Copyright (c) 2020-2024 Paweł Kuna

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.''';
