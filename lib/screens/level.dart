/// The level: where it stands on the profile, what a session added to it,
/// and the screen the session that crosses one ends on.
///
/// The level is read off experience (xp.dart) — one for every rep, twenty for
/// every match — and never comes down. The rank is the badge; this is how
/// much somebody has put in, and a loss still adds to it.
library;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../motion.dart';
import '../theme.dart';
import '../type_scale.dart';
import '../widgets.dart';
import '../xp.dart';

/// The profile's level: the number, the bar to the next, and how it fills.
class XpCard extends StatelessWidget {
  const XpCard({super.key, required this.xp});

  final int xp;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final at = xpLevel(xp);
    return Container(
      key: const Key('xpCard'),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.border, width: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: ShrinkText(
                  l.levelNumber(localNumber(context, at.level)),
                  maxLines: 1,
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                l.xpOf(
                  localNumber(context, at.into),
                  localNumber(context, at.span),
                ),
                style: TextStyle(color: context.colors.muted, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _XpBar(from: at.progress, to: at.progress, colour: context.colors.text),
          const SizedBox(height: 7),
          Text(
            '${l.xpToLevel(localNumber(context, at.toNext), localNumber(context, at.level + 1))}'
            '  ·  '
            '${l.xpHow(localNumber(context, 1), localNumber(context, kXpPerMatch))}',
            style: TextStyle(color: context.colors.muted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

/// What a session added: "+43 XP", the bar moving, and what it was for.
class XpGainCard extends StatelessWidget {
  const XpGainCard({super.key, required this.gain});

  final XpGain gain;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final now = xpLevel(gain.after);
    // Across a level the bar starts again from empty: the level-up screen
    // before this one already said so.
    final from = gain.leveledUp ? 0.0 : xpLevel(gain.before).progress;
    final parts = [
      l.xpForReps(localNumber(context, gain.reps)),
      if (gain.forMatch > 0) l.xpForMatch(localNumber(context, gain.forMatch)),
    ];

    return TweenAnimationBuilder<double>(
      // The total counts up and the bar fills, as the LP card's do.
      tween: Tween(begin: reduceMotion(context) ? 1.0 : 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) => Container(
        key: const Key('xpGain'),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: context.colors.surface,
          border: Border.all(color: context.colors.border, width: 0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: ShrinkText(
                    l.levelNumber(localNumber(context, now.level)),
                    maxLines: 1,
                    style: TextStyle(color: context.colors.text, fontSize: 15),
                  ),
                ),
                Text(
                  l.xpGained(localNumber(context, (gain.total * t).round())),
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            _XpBar(
              from: from,
              to: from + (now.progress - from) * t,
              colour: AppColors.gold,
            ),
            const SizedBox(height: 6),
            ShrinkText(
              parts.join('  ·  '),
              maxLines: 1,
              style: TextStyle(color: context.colors.muted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

/// The bar to the next level, with the part this session filled drawn over
/// the part that was already there.
class _XpBar extends StatelessWidget {
  const _XpBar({required this.from, required this.to, required this.colour});

  final double from;
  final double to;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    final low = from.clamp(0.0, 1.0);
    final high = to.clamp(low, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 8,
        // Expand, so every layer is handed the bar's full height — the same
        // reason as the LP bar's.
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: context.colors.surfaceRaised),
            FractionallySizedBox(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: high,
              child: ColoredBox(color: colour.withValues(alpha: 0.5)),
            ),
            FractionallySizedBox(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: low,
              child: ColoredBox(color: colour),
            ),
          ],
        ),
      ),
    );
  }
}

/// The screen a new level earns, once, straight after the session that
/// crossed it.
class LevelUpView extends StatelessWidget {
  const LevelUpView({super.key, required this.level, required this.onContinue});

  final int level;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: Column(
                  key: const Key('levelUp'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l.levelUp.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.colors.muted,
                        fontSize: 15,
                        letterSpacing: 2.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    PopIn(
                      from: 0.5,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          localNumber(context, level),
                          style: TextStyle(
                            color: const Color(0xFFF2D27A),
                            fontSize: 132,
                            fontWeight: FontWeight.w900,
                            height: 1.05,
                            shadows: [
                              Shadow(
                                color: AppColors.gold.withValues(alpha: 0.75),
                                blurRadius: 34,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ShrinkText(
                      l.levelNumber(localNumber(context, level)),
                      maxLines: 1,
                      style: context.type.title.copyWith(
                        color: context.colors.text,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l.levelUpBody,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.colors.muted,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: const Key('levelUpContinue'),
                onPressed: onContinue,
                child: Text(l.continueAction),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
