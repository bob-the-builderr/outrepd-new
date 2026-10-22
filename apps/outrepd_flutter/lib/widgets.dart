import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'l10n/app_localizations.dart';
import 'tier_badge.dart';
import 'type_scale.dart';
import 'theme.dart';
import 'xp.dart';

/// Rounded dark panel used for most content blocks.
class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.surfaceRaised),
      ),
      child: child,
    );

    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: content,
    );
  }
}

/// Small label + value pair, used across profile and stats.
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // The number is the reason anybody looks at a stat tile, so it gets
        // the weight — and tabular figures, so a row of tiles keeps its
        // columns while the values change underneath.
        Text(
          value,
          style: context.type.statValue.copyWith(
            color: color ?? context.colors.text,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label.toUpperCase(),
          textAlign: TextAlign.center,
          style: context.type.micro.copyWith(color: context.colors.muted),
        ),
      ],
    );
  }
}

/// The crest, by its older name.
///
/// It used to load a PNG per tier while [TierBadge] drew a polygon, so the
/// app showed two different badges for the same rank depending on the screen.
/// There is one badge now, and this is it — kept only so the screens that
/// still say `TierCrest` keep working.
class TierCrest extends StatelessWidget {
  const TierCrest({super.key, required this.tierIdx, this.size = 48});

  final int tierIdx;
  final double size;

  @override
  Widget build(BuildContext context) =>
      TierBadge(tierIndex: tierIdx, size: size);
}

/// Divisions climb from V up to I, so a higher [divIdx] is a better division.
const kDivisions = ['V', 'IV', 'III', 'II', 'I'];

/// The tier's display name in the reader's language. [Tier.name] itself stays
/// English — it doubles as the id the rest of the code refers to a tier by.
String tierName(L l, int tierIdx) =>
    switch (tierIdx.clamp(0, kTiers.length - 1)) {
      0 => l.tierIron,
      1 => l.tierBronze,
      2 => l.tierSilver,
      3 => l.tierGold,
      4 => l.tierPlatinum,
      5 => l.tierDiamond,
      _ => l.tierMaster,
    };

/// The rank one step up: the next division of this tier, or the first
/// division of the next tier when this one is nearly done.
///
/// Named rather than numbered, because "38 to Gold I" is a destination and
/// "38 LP" is a quantity — and a destination is what makes somebody train.
String nextRankName(L l, int tierIdx, int divIdx) {
  // Climbing means a *higher* index: V is 0 and I is last. Getting this
  // backwards promises Gold III a promotion to Gold IV, which is a demotion.
  if (divIdx < kDivisions.length - 1) {
    return '${tierName(l, tierIdx)} ${kDivisions[divIdx + 1]}';
  }
  // Past division I the only way up is the next tier, entered at its bottom.
  final next = (tierIdx + 1).clamp(0, kTiers.length - 1);
  return '${tierName(l, next)} ${kDivisions.first}';
}

String tierLabel(L l, int tierIdx, int divIdx) =>
    '${tierName(l, tierIdx)} ${kDivisions[divIdx.clamp(0, kDivisions.length - 1)]}';

String relativeDays(BuildContext context, int days) {
  final l = L.of(context);
  if (days == 0) return l.today;
  if (days == 1) return l.yesterday;
  if (days < 7) return l.daysAgo(localNumber(context, days));
  final weeks = days ~/ 7;
  return l.weeksAgo(localNumber(context, weeks));
}

/// Text that gives up a point of size rather than snapping a word in half.
///
/// Flutter's own wrapping breaks a word across lines once the word is wider
/// than the line — "Encyclo / pedia" — which on a two-line card reads as a
/// rendering fault rather than a long word. This measures instead: it walks the
/// size down until the whole block fits in [maxLines] *and* its longest single
/// word fits on one line, then draws at that size.
///
/// It respects the reader's text scale, so the shrinking happens on top of
/// their setting rather than in place of it — at 1.3x a title that already fit
/// simply stays where it was.
class ShrinkText extends StatelessWidget {
  const ShrinkText(
    this.text, {
    super.key,
    required this.style,
    this.maxLines = 2,
    this.minScale = 0.78,
  });

  final String text;
  final TextStyle style;
  final int maxLines;

  /// How small it may go before it stops shrinking and clips. Past about a
  /// quarter off, a smaller title is no more readable than a clipped one.
  final double minScale;

  @override
  Widget build(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    // A `Text` merges the ambient default over its own style, and the theme's
    // default carries a line height. Measuring the bare style measures a
    // shorter line than the one that gets drawn, which is how a card that
    // "fits" overflows anyway.
    final effective = DefaultTextStyle.of(context).style.merge(style);
    final base = effective.fontSize ?? 14;
    final longest = text
        .split(RegExp(r'\s+'))
        .fold<String>('', (a, b) => b.length > a.length ? b : a);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final direction = Directionality.of(context);
        var size = base;
        if (width.isFinite) {
          for (; size > base * minScale; size -= 0.5) {
            if (_fits(
                  text,
                  effective,
                  size,
                  width,
                  scaler,
                  maxLines,
                  direction,
                ) &&
                _fits(longest, effective, size, width, scaler, 1, direction)) {
              break;
            }
          }
        }
        return Text(
          text,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: style.copyWith(fontSize: size),
        );
      },
    );
  }

  bool _fits(
    String s,
    TextStyle effective,
    double size,
    double width,
    TextScaler scaler,
    int lines,
    TextDirection direction,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: s,
        style: effective.copyWith(fontSize: size),
      ),
      maxLines: lines,
      textScaler: scaler,
      textDirection: direction,
    )..layout(maxWidth: width);
    return !painter.didExceedMaxLines;
  }
}

/// Section heading with optional trailing action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Flexible, because a heading is the one thing on a settings screen
          // nobody thinks to check: "Who can challenge me" fits at 1.0x and
          // runs 204 pixels past the edge at 1.6x, and a Row will happily
          // draw it there.
          Flexible(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.type.heading.copyWith(color: context.colors.text),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// Seconds as m:ss. Every language the app ships in writes a clock this way.
String formatClock(BuildContext context, int seconds) {
  final safe = seconds < 0 ? 0 : seconds;
  final minutes = safe ~/ 60;
  final rest = (safe % 60).toString().padLeft(2, '0');
  return '$minutes:$rest';
}

/// A number as the reader's language groups it: 1,234 in English, 1.234 in
/// German. The digits are Western in every language the app ships in —
/// Hindi, Japanese, Korean and Chinese all write numbers that way in practice.
String localNumber(BuildContext context, num n) {
  final locale = Localizations.localeOf(context);
  return NumberFormat.decimalPattern(locale.toString()).format(n);
}

/// What a screen says before it has anything to show.
///
/// Every list in the app opened onto demo data, so nobody had seen these
/// screens the way the first person to install it will: friends with no
/// friends, a history with no matches, an inbox with nothing in it. A bare
/// heading over an empty page reads as something failing to load.
///
/// So an empty state names what is missing and — this is the part that matters
/// — says what to do about it. "No matches yet" is a dead end; "your first one
/// shows up here, win or lose" is an invitation.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.action,
    this.footnote,
  });

  final IconData icon;
  final String title;
  final String body;

  /// An optional way out of the emptiness, when the screen has one to offer.
  final Widget? action;

  /// A line under the action, for progress towards leaving this state —
  /// "0 of 5 done". It sits below the button because it describes the thing
  /// the button starts, not the button.
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    // Centred like BlockingNotice: where a caller has room to give (an
    // Expanded slot rather than a place in a longer scrolling list), the
    // message should sit in the middle of it, not pinned to the top with the
    // rest of the screen reading as blank space underneath.
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 34, 30, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // A bare icon, not one in a bordered circle. The circle read as a
            // disabled button, which on a screen with nothing on it is the
            // opposite of the message.
            Icon(icon, size: 34, color: context.colors.faint),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.text,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              body,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.muted,
                fontSize: 13,
                height: 1.6,
              ),
            ),
            if (action case final action?) ...[
              const SizedBox(height: 16),
              action,
            ],
            if (footnote case final footnote?) ...[
              const SizedBox(height: 12),
              Text(
                footnote,
                style: TextStyle(color: context.colors.muted, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A dead end that takes the whole screen: the camera refused, the network
/// gone, the thing you came to do not currently possible.
///
/// Distinct from [EmptyState], which is a list with nothing in it. This is
/// heavier because it has to carry an explanation — every one of these asks
/// the reader to do something outside the app, and people do not act on a
/// sentence that has not told them why.
///
/// Both ways out are always offered. A screen with only "Open settings" on it
/// traps anyone who does not want to grant the permission.
class BlockingNotice extends StatelessWidget {
  const BlockingNotice({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
    this.secondaryLabel,
    this.onSecondary,
    this.secondaryProminent = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;

  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  /// Whether the second way out is a real alternative rather than a dismissal.
  /// "Practice offline" still gets you a workout; "Not now" just leaves.
  final bool secondaryProminent;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 38, color: context.colors.muted),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.text,
                fontSize: 19,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              body,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.muted,
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Material(
                color: context.colors.brand,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: onAction,
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    child: Center(
                      child: Text(
                        actionLabel,
                        style: TextStyle(
                          color: context.colors.background,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (secondaryLabel case final label?) ...[
              const SizedBox(height: 14),
              InkWell(
                onTap: onSecondary,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: secondaryProminent
                          ? context.colors.text
                          : context.colors.muted,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The filled pill used to leave an empty state.
///
/// Sized to its label rather than stretched across the screen: at the bottom
/// of an empty page a full-width bar reads as the page's main content, and
/// this is a suggestion, not the subject.
class PillButton extends StatelessWidget {
  const PillButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.brand,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
          child: Text(
            label,
            style: TextStyle(
              color: context.colors.background,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

/// The small red "Live" pill on anything happening with both lifters on
/// camera at once — the opponent found, the invite, the score card. Grey and
/// "Reconnecting" while the other phone has gone quiet.
class LiveTag extends StatelessWidget {
  const LiveTag({super.key, this.reconnecting = false, this.label});

  final bool reconnecting;

  /// In place of "Live", for a pill that says a little more.
  final String? label;

  static const _red = Color(0xFFE24B4A);

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: reconnecting ? context.colors.surfaceRaised : const Color(0xFF3A1414),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: reconnecting ? context.colors.muted : _red,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            reconnecting ? l.reconnecting : (label ?? l.liveTag),
            style: TextStyle(
              color: reconnecting ? context.colors.muted : const Color(0xFFF09595),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// The mark apps that work with Apple Health show beside it: a red heart on
/// a white rounded square. Drawn, not the Health app's own icon, which is
/// Apple's.
class HealthMark extends StatelessWidget {
  const HealthMark({super.key, this.size = 30});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size * 0.24),
      ),
      child: Icon(
        Icons.favorite,
        size: size * 0.66,
        color: const Color(0xFFFF2D55),
      ),
    );
  }
}

/// The level beside a name: "Lv 12". Read off experience (xp.dart), so it
/// only ever climbs — the badge is the rank, and this is how much somebody
/// has put in.
class LevelChip extends StatelessWidget {
  const LevelChip({super.key, required this.xp, this.fontSize = 11});

  final int xp;
  final double fontSize;

  /// How wide the chip draws here, at this text size.
  static double widthOf(BuildContext context, int xp, double fontSize) {
    final painter = TextPainter(
      text: TextSpan(
        text: L.of(context).levelShort(localNumber(context, levelOf(xp))),
        style: DefaultTextStyle.of(
          context,
        ).style.copyWith(fontSize: fontSize, fontWeight: FontWeight.w700),
      ),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
      maxLines: 1,
    )..layout();
    final width = painter.width;
    painter.dispose();
    // The padding and the border either side.
    return width + 14;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: context.colors.surfaceRaised,
        border: Border.all(color: context.colors.border),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        L.of(context).levelShort(localNumber(context, levelOf(xp))),
        maxLines: 1,
        style: TextStyle(
          color: context.colors.text,
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
      ),
    );
  }
}

/// A name with the level after it, the name giving way first when the row
/// is short of room.
class NameWithLevel extends StatelessWidget {
  const NameWithLevel({
    super.key,
    required this.name,
    required this.xp,
    this.style,
    this.chipFontSize = 11,
  });

  final String name;

  /// Null when it is not known, and then only the name.
  final int? xp;
  final TextStyle? style;
  final double chipFontSize;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
    final xp = this.xp;
    if (xp == null) return text;
    return LayoutBuilder(
      builder: (context, box) {
        // The chip and a few letters of the name, or the name alone: a busy
        // row at a large text size has no room for both, and the name is
        // what the row is for.
        final needs =
            LevelChip.widthOf(context, xp, chipFontSize) +
            6 +
            MediaQuery.textScalerOf(context).scale(36);
        if (box.maxWidth < needs) return text;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: text),
            const SizedBox(width: 6),
            LevelChip(xp: xp, fontSize: chipFontSize),
          ],
        );
      },
    );
  }
}
