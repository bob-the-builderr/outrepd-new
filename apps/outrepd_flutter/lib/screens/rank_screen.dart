/// Where the rank card leads (the user's pick, 2026-11-03), in place of the
/// plain list of tiers that was "Your climb": the crest large and lit, the
/// rating counting up to where it stands, the five divisions of this tier
/// with this one filling, all seven tiers, and how a match moves the rating.
///
/// Every number here is the ranking code's own (lib/ranking.dart): a division
/// is [kRatingPerDivision], a win and a loss are the words the match screen
/// already uses, and the floor is the rating of the bottom rung — nothing is
/// promised that the ladder does not keep.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data.dart';
import '../l10n/app_localizations.dart';
import '../motion.dart';
import '../ranking.dart';
import '../theme.dart';
import '../tier_badge.dart';
import '../widgets.dart';

class RankScreen extends StatelessWidget {
  const RankScreen({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final p = profile;
    final top = p.tierIdx >= kTopTier && p.divIdx >= kTopDivision;
    final rating = ratingOf(p.tierIdx, p.divIdx, p.lp);
    final toNext = (kRatingPerDivision - p.lp).clamp(0, kRatingPerDivision);
    final metal = tierMetal(p.tierIdx);

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        backgroundColor: context.colors.background,
        title: Text(l.yourRank),
      ),
      body: ListView(
        key: const Key('rankScreen'),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
        children: [
          // The crest, lit from behind by a slow turning light.
          SizedBox(
            height: 240,
            child: Stack(
              alignment: Alignment.center,
              children: [
                _TurningLight(colour: metal.mid),
                TierBadge(tierIndex: p.tierIdx, size: 190),
              ],
            ),
          ),
          Text(
            tierLabel(l, p.tierIdx, p.divIdx),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.colors.text,
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          CountUp(
            value: rating,
            builder: (context, shown) => Text(
              localNumber(context, shown),
              key: const Key('rankScreenRating'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: metal.light,
                fontSize: 44,
                fontWeight: FontWeight.w900,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          Text(
            [
              l.ratingUnit,
              if (!top)
                l.toNextTier(
                  localNumber(context, toNext),
                  nextRankName(l, p.tierIdx, p.divIdx),
                ),
            ].join(' · '),
            textAlign: TextAlign.center,
            style: TextStyle(color: context.colors.muted, fontSize: 14),
          ),
          const SizedBox(height: 20),

          // This tier, division by division: the ones done full, this one
          // filling, the rest to come.
          RiseIn(
            delay: staggered(1),
            child: _Card(
              title: tierName(l, p.tierIdx),
              child: Row(
                children: [
                  for (var d = 0; d < kDivisions.length; d++) ...[
                    if (d > 0) const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        children: [
                          GrowingBar(
                            value: d < p.divIdx || top
                                ? 1.0
                                : d == p.divIdx
                                    ? (p.lp / kRatingPerDivision).clamp(0.0, 1.0)
                                    : 0.0,
                            colour: metal.mid,
                            background: context.colors.surfaceRaised,
                            radius: 4,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            kDivisions[d],
                            style: TextStyle(
                              color: d == p.divIdx
                                  ? context.colors.text
                                  : context.colors.muted,
                              fontSize: 12.5,
                              fontWeight: d == p.divIdx
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // All seven, the ones still ahead faint.
          RiseIn(
            delay: staggered(2),
            child: _Card(
              title: l.obClimbTitle,
              child: Row(
                children: [
                  for (var t = 0; t < kTiers.length; t++)
                    Expanded(
                      child: Opacity(
                        opacity: t > p.tierIdx ? 0.35 : 1,
                        child: Column(
                          children: [
                            TierBadge(
                              tierIndex: t,
                              size: 36,
                              glow: t == p.tierIdx,
                            ),
                            const SizedBox(height: 4),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                tierName(l, t),
                                style: TextStyle(
                                  color: t == p.tierIdx
                                      ? context.colors.text
                                      : context.colors.muted,
                                  fontSize: 11,
                                  fontWeight: t == p.tierIdx
                                      ? FontWeight.w800
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // How a match moves it, in the match screen's own words.
          RiseIn(
            delay: staggered(3),
            child: _Card(
              title: l.howPointsWork,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.lpMovesWithGap,
                    style: TextStyle(
                      color: context.colors.text,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.ratingFloor(localNumber(context, ratingOf(0, 0, 0))),
                    style: TextStyle(
                      color: context.colors.muted,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              color: context.colors.muted,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// A soft light in the tier's colour turning slowly behind the crest. Still,
/// and simply a glow, where the phone asks for less motion and under tests.
class _TurningLight extends StatefulWidget {
  const _TurningLight({required this.colour});

  final Color colour;

  @override
  State<_TurningLight> createState() => _TurningLightState();
}

class _TurningLightState extends State<_TurningLight>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (loopsAllowed(context)) {
      if (!_controller.isAnimating) _controller.repeat();
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Transform.rotate(
        angle: _controller.value * 2 * math.pi,
        child: Container(
          width: 230,
          height: 230,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                c.withValues(alpha: 0),
                c.withValues(alpha: 0.32),
                c.withValues(alpha: 0),
                c.withValues(alpha: 0.2),
                c.withValues(alpha: 0),
              ],
            ),
            boxShadow: [
              BoxShadow(color: c.withValues(alpha: 0.22), blurRadius: 60),
            ],
          ),
        ),
      ),
    );
  }
}
