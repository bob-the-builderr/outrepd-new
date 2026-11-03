/// The rank as the profile shows it (the user's pick A, 2026-11-02): a card
/// in the tier's own metal — its colour washed in from the corner, along the
/// border and through the bar — with the crest at the start, the tier and
/// division above the rating, and what the next division needs.
///
/// It replaced "Gold III · 64 / 100 LP" over a thin bar, which the user found
/// hard to read: the rating is one number now, so it is drawn as one. Since
/// 2026-11-03 it wears its tier's frame (lib/tier_card_frame.dart): the edge,
/// the feathers and the glow are the frame's, the light inside is its own.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'motion.dart';
import 'ranking.dart';
import 'theme.dart';
import 'tier_badge.dart';
import 'tier_card_frame.dart';
import 'widgets.dart';

class RankCard extends StatelessWidget {
  const RankCard({
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
    final metal = tierMetal(tierIdx);
    final dark = Theme.of(context).brightness == Brightness.dark;
    // Master's identity is its terracotta wings, not its pale shield.
    final accent = tierIdx >= kTopTier ? metal.wing : metal.mid;
    // The tier's name in its lightest metal on the dark theme, its darkest
    // on the light one, where the light metal would vanish.
    final ink = dark ? metal.light : metal.base;
    final top = tierIdx >= kTopTier && divIdx >= kTopDivision;
    final rating = ratingOf(tierIdx, divIdx, lp);
    final from = ratingOf(tierIdx, divIdx, 0);
    final to = from + kRatingPerDivision;
    final fill = top ? 1.0 : (lp / kRatingPerDivision).clamp(0.0, 1.0);

    final lit = _Lit(
      accent: accent,
      light: metal.light,
      dark: dark,
      child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 12, 16, 11),
      child: Row(
        children: [
          TierBadge(tierIndex: tierIdx, size: 74),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShrinkText(
                            tierLabel(l, tierIdx, divIdx).toUpperCase(),
                            maxLines: 1,
                            style: TextStyle(
                              color: ink,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.6,
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              localNumber(context, rating),
                              key: const Key('rankCardRating'),
                              style: TextStyle(
                                color: context.colors.text,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                height: 1.12,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!top) ...[
                      const SizedBox(width: 8),
                      // Against the far edge, however short the words are.
                      Flexible(
                        fit: FlexFit.tight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ShrinkText(
                              l.rankNext(nextRankName(l, tierIdx, divIdx)),
                              maxLines: 1,
                              style: TextStyle(
                                color: context.colors.text,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            ShrinkText(
                              l.rankAt(localNumber(context, to)),
                              maxLines: 1,
                              style: TextStyle(
                                color: context.colors.muted,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 7),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                    height: 8,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ColoredBox(
                          color: Colors.black.withValues(alpha: dark ? 0.35 : 0.08),
                        ),
                        FractionallySizedBox(
                          alignment: AlignmentDirectional.centerStart,
                          widthFactor: fill,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              gradient: LinearGradient(
                                colors: [metal.base, accent, metal.light],
                                stops: const [0, 0.7, 1],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!top) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        localNumber(context, from),
                        style: TextStyle(color: context.colors.muted, fontSize: 11.5),
                      ),
                      Expanded(
                        child: Text(
                          l.toGo(localNumber(context, to - rating)),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: context.colors.text, fontSize: 11.5),
                        ),
                      ),
                      Text(
                        localNumber(context, to),
                        style: TextStyle(color: context.colors.muted, fontSize: 11.5),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      ),
    );

    return TierCardFrame(
      tierIdx: tierIdx,
      fill: false,
      child: onTap == null
          ? lit
          : Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(18),
                child: lit,
              ),
            ),
    );
  }
}

/// The card's metal, lit: the tier's colour washed in from one side, and —
/// where the phone allows motion — that light travelling across the whole
/// card and round again, and a brighter sheen crossing it (the user,
/// 2026-11-03: the glow on the left stood still). Still, it is the card as it
/// was, lit from the top corner. Its edge and glow are the frame's.
class _Lit extends StatefulWidget {
  const _Lit({
    required this.accent,
    required this.light,
    required this.dark,
    required this.child,
  });

  final Color accent;
  final Color light;
  final bool dark;
  final Widget child;

  @override
  State<_Lit> createState() => _LitState();
}

class _LitState extends State<_Lit> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4200),
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
    final accent = widget.accent;
    final dark = widget.dark;
    final surface = context.colors.surface;
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (context, child) {
        final moving = _controller.isAnimating;
        final t = moving ? _controller.value : 0.0;
        // The wash runs from the start edge to the far one and back, so it
        // never jumps.
        final along = moving ? (1 - math.cos(t * 2 * math.pi)) / 2 : 0.0;
        // The sheen crosses in the first half of the cycle, then rests.
        final sheen = (t / 0.5).clamp(0.0, 1.0);
        return Container(
          key: const Key('rankCard'),
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: AlignmentDirectional(-1 + 2 * along, -1 + along),
              radius: 1.6,
              colors: [
                accent.withValues(alpha: dark ? 0.34 : 0.22),
                accent.withValues(alpha: dark ? 0.13 : 0.08),
                surface,
              ],
              stops: const [0, 0.38, 0.75],
            ),
            borderRadius: BorderRadius.circular(18),
          ),
          foregroundDecoration: moving && t < 0.5
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment(-3 + 4 * sheen, -0.4),
                    end: Alignment(-1 + 4 * sheen, 0.4),
                    colors: [
                      widget.light.withValues(alpha: 0),
                      widget.light.withValues(alpha: dark ? 0.16 : 0.22),
                      widget.light.withValues(alpha: 0),
                    ],
                  ),
                )
              : null,
          child: child,
        );
      },
    );
  }
}
