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
                  icon: const TablerIcon(TablerIcon.swords),
                  selected: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                _NavItem(
                  label: l.tabFriends,
                  icon: const TablerIcon(TablerIcon.users),
                  selected: currentIndex == 1,
                  badgeCount: friendRequestCount,
                  onTap: () => onTap(1),
                ),
                _NavItem(
                  label: l.tabRanks,
                  icon: const TablerIcon(TablerIcon.trophy),
                  selected: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
                _NavItem(
                  label: l.tabProfile,
                  icon: const TablerIcon(TablerIcon.user),
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

/// An icon from Tabler Icons, painted from Tabler's own outline on its
/// 24-unit grid with its 2-unit stroke. The bar was picked from a mockup
/// drawn with these four, and Material's are drawn by a different hand, so
/// the bar uses Tabler's (MIT; the licence is on the app's licences page,
/// see [registerIconLicences]).
class TablerIcon extends StatelessWidget {
  const TablerIcon(this.paths, {super.key});

  /// The icon's outline, as the `d` of each of Tabler's `<path>`s.
  final List<String> paths;

  static const swords = [
    'M21 3v5l-11 9l-4 4l-3 -3l4 -4l9 -11z',
    'M5 13l6 6',
    'M14.32 17.32l3.68 3.68l3 -3l-3.365 -3.365',
    'M10 5.5l-2 -2.5h-5v5l3 2.5',
  ];
  static const users = [
    'M9 7m-4 0a4 4 0 1 0 8 0a4 4 0 1 0 -8 0',
    'M3 21v-2a4 4 0 0 1 4 -4h4a4 4 0 0 1 4 4v2',
    'M16 3.13a4 4 0 0 1 0 7.75',
    'M21 21v-2a4 4 0 0 0 -3 -3.85',
  ];
  static const trophy = [
    'M8 21l8 0',
    'M12 17l0 4',
    'M7 4l10 0',
    'M17 4v8a5 5 0 0 1 -10 0v-8',
    'M5 9m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0',
    'M19 9m-2 0a2 2 0 1 0 4 0a2 2 0 1 0 -4 0',
  ];
  static const user = [
    'M8 7a4 4 0 1 0 8 0a4 4 0 0 0 -8 0',
    'M6 21v-2a4 4 0 0 1 4 -4h4a4 4 0 0 1 4 4v2',
  ];

  /// The notifications button on the Match tab, in the bar's own hand.
  static const bell = [
    'M10 5a2 2 0 1 1 4 0a7 7 0 0 1 4 6v3a4 4 0 0 0 2 3h-16a4 4 0 0 0 2 -3v-3a7 7 0 0 1 4 -6',
    'M9 17v1a3 3 0 0 0 6 0v-1',
  ];

  @override
  Widget build(BuildContext context) {
    final colour = IconTheme.of(context).color ?? context.colors.muted;
    final size = IconTheme.of(context).size ?? 22;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _TablerPainter(paths, colour)),
    );
  }
}

class _TablerPainter extends CustomPainter {
  _TablerPainter(this.paths, this.colour);
  final List<String> paths;
  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 24;
    final pen = Paint()
      ..color = colour
      // On the 24-unit grid, scaled below: Tabler's stroke is 2 units.
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    canvas.scale(unit);
    for (final d in paths) {
      canvas.drawPath(_outline(d), pen);
    }
  }

  @override
  bool shouldRepaint(covariant _TablerPainter old) =>
      old.colour != colour || !identical(old.paths, paths);
}

final _outlines = <String, Path>{};

/// One of Tabler's path strings as a [Path] on the 24-unit grid. Only what
/// Tabler's outlines use: moves, lines, arcs and closing, absolute and
/// relative.
Path _outline(String d) => _outlines.putIfAbsent(d, () {
  final tokens = RegExp(r'[MmLlHhVvAaZz]|-?(?:\d+\.?\d*|\.\d+)')
      .allMatches(d)
      .map((m) => m[0]!)
      .toList();
  final path = Path();
  var i = 0;
  var command = 'M';
  var x = 0.0, y = 0.0, startX = 0.0, startY = 0.0;
  double next() => double.parse(tokens[i++]);

  while (i < tokens.length) {
    if (RegExp('[A-Za-z]').hasMatch(tokens[i])) command = tokens[i++];
    final relative = command == command.toLowerCase();
    switch (command.toUpperCase()) {
      case 'M':
        final (dx, dy) = (next(), next());
        x = relative ? x + dx : dx;
        y = relative ? y + dy : dy;
        path.moveTo(x, y);
        (startX, startY) = (x, y);
        // Further pairs after a move are lines.
        command = relative ? 'l' : 'L';
      case 'L':
        final (dx, dy) = (next(), next());
        x = relative ? x + dx : dx;
        y = relative ? y + dy : dy;
        path.lineTo(x, y);
      case 'H':
        final dx = next();
        x = relative ? x + dx : dx;
        path.lineTo(x, y);
      case 'V':
        final dy = next();
        y = relative ? y + dy : dy;
        path.lineTo(x, y);
      case 'A':
        final (rx, ry, rotation) = (next(), next(), next());
        final (largeArc, sweep) = (next() != 0, next() != 0);
        final (dx, dy) = (next(), next());
        x = relative ? x + dx : dx;
        y = relative ? y + dy : dy;
        path.arcToPoint(
          Offset(x, y),
          radius: Radius.elliptical(rx, ry),
          rotation: rotation,
          largeArc: largeArc,
          clockwise: sweep,
        );
      case 'Z':
        path.close();
        (x, y) = (startX, startY);
      default:
        throw StateError('A Tabler outline used "$command": $d');
    }
  }
  return path;
});

/// Puts Tabler Icons' licence on the app's licences page, which MIT asks
/// for wherever its work is copied — here, the bar's four icons above.
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
