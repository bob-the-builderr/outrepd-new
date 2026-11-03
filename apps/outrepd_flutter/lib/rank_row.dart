/// The rank row: the Match tab's, and the card somebody's name opens.
library;

import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'motion.dart';
import 'ranking.dart';
import 'theme.dart';
import 'tier_badge.dart';
import 'tier_card_frame.dart';
import 'widgets.dart';

/// The rank as one quiet row (the user's pick 2, 2026-11-03): the crest with
/// a light breathing slowly behind it, the tier, the rating and what the
/// next division needs, and a thin bar — wearing its tier's frame (pick A,
/// lib/tier_card_frame.dart). On the Match tab, where the profile keeps the
/// large card and the match is the point, and on the card a name opens.
class RankRow extends StatelessWidget {
  const RankRow({
    super.key,
    required this.tierIdx,
    required this.divIdx,
    required this.lp,
    this.onTap,
  });

  final int tierIdx;
  final int divIdx;
  final int lp;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final metal = tierMetal(tierIdx);
    final dark = Theme.of(context).brightness == Brightness.dark;
    // As on the profile's card: Master's identity is its terracotta wings,
    // and the name is in the lightest metal on the dark theme, the darkest
    // on the light one.
    final accent = tierIdx >= kTopTier ? metal.wing : metal.mid;
    final ink = dark ? metal.light : metal.base;
    final top = tierIdx >= kTopTier && divIdx >= kTopDivision;
    final toNext = (kRatingPerDivision - lp).clamp(0, kRatingPerDivision);
    final fill = top ? 1.0 : (lp / kRatingPerDivision).clamp(0.0, 1.0);
    final next = top
        ? null
        : l.toNextTier(
            localNumber(context, toNext),
            nextRankName(l, tierIdx, divIdx),
          );
    final radius = BorderRadius.circular(18);

    return PressScale(
      scale: 0.98,
      child: TierCardFrame(
        key: const Key('rankRow'),
        tierIdx: tierIdx,
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 10, 12, 10),
              child: Row(
                children: [
                  _Breathe(
                    colour: accent,
                    child: TierBadge(tierIndex: tierIdx, size: 52),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShrinkText(
                          tierLabel(l, tierIdx, divIdx).toUpperCase(),
                          maxLines: 1,
                          style: TextStyle(
                            color: ink,
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.4,
                          ),
                        ),
                        const SizedBox(height: 1),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text.rich(
                            key: const Key('rankRowRating'),
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: localNumber(
                                    context,
                                    ratingOf(tierIdx, divIdx, lp),
                                  ),
                                  style: TextStyle(
                                    color: colors.text,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                                if (next != null)
                                  TextSpan(
                                    text: '  ·  $next',
                                    style: TextStyle(
                                      color: colors.muted,
                                      fontSize: 12.5,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: SizedBox(
                            height: 4,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ColoredBox(
                                  color: Colors.black.withValues(
                                    alpha: dark ? 0.35 : 0.08,
                                  ),
                                ),
                                FractionallySizedBox(
                                  alignment: AlignmentDirectional.centerStart,
                                  widthFactor: fill,
                                  child: ColoredBox(
                                    color: accent.withValues(alpha: 0.85),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.chevron_right, color: colors.muted, size: 22),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A soft light in the tier's colour behind the crest, swelling and fading
/// over six seconds. Held halfway where the phone asks for less motion, and
/// under tests.
class _Breathe extends StatefulWidget {
  const _Breathe({required this.colour, required this.child});

  final Color colour;
  final Widget child;

  @override
  State<_Breathe> createState() => _BreatheState();
}

class _BreatheState extends State<_Breathe>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
    value: 0.5,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loopsAllowed(context)) {
      if (!_controller.isAnimating) _controller.repeat(reverse: true);
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.colour;
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -8,
          top: -8,
          right: -8,
          bottom: -8,
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                final t = Curves.easeInOut.transform(_controller.value);
                return DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        c.withValues(alpha: 0.12 + 0.16 * t),
                        c.withValues(alpha: 0),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}
