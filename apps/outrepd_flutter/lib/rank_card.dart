/// The rank as the profile shows it (the user's pick A, 2026-11-02): a card
/// in the tier's own metal — its colour washed in from the corner, along the
/// border and through the bar — with the crest at the start, the tier and
/// division above the rating, and what the next division needs.
///
/// It replaced "Gold III · 64 / 100 LP" over a thin bar, which the user found
/// hard to read: the rating is one number now, so it is drawn as one.
library;

import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'ranking.dart';
import 'theme.dart';
import 'tier_badge.dart';
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

    final card = Container(
      key: const Key('rankCard'),
      padding: const EdgeInsetsDirectional.fromSTEB(10, 12, 16, 11),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: AlignmentDirectional.topStart,
          radius: 1.6,
          colors: [
            accent.withValues(alpha: dark ? 0.34 : 0.22),
            accent.withValues(alpha: dark ? 0.13 : 0.08),
            context.colors.surface,
          ],
          stops: const [0, 0.38, 0.75],
        ),
        border: Border.all(color: accent, width: 1.5),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: accent.withValues(alpha: 0.18), blurRadius: 22),
        ],
      ),
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
                      Flexible(
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
    );

    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: card,
      ),
    );
  }
}
