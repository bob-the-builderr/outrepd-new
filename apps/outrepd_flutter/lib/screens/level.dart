/// The level: where it stands on the profile, what a session added to it,
/// and the screen the session that crosses one ends on.
///
/// The level is read off experience (xp.dart) — one for every rep, twenty for
/// every match — and never comes down. The rank is the badge; this is how
/// much somebody has put in, and a loss still adds to it.
library;

import 'package:flutter/material.dart';

import '../avatar.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../motion.dart';
import '../player_avatar.dart';
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
    // Quiet (direction B, 2026-11-02): the level a line, not a headline,
    // under the rank card that is the profile's headline.
    return Container(
      key: const Key('xpCard'),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 13),
      decoration: BoxDecoration(
        color: context.colors.surface,
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
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                l.xpOf(
                  localNumber(context, at.into),
                  localNumber(context, at.span),
                ),
                style: TextStyle(
                  color: context.colors.muted,
                  fontSize: 13,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _XpBar(
            from: at.progress,
            to: at.progress,
            colour: context.colors.brand,
            height: 6,
          ),
          const SizedBox(height: 7),
          Text(
            l.xpToLevel(
              localNumber(context, at.toNext),
              localNumber(context, at.level + 1),
            ),
            style: TextStyle(color: context.colors.muted, fontSize: 12),
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
  const _XpBar({
    required this.from,
    required this.to,
    required this.colour,
    this.height = 8,
  });

  final double from;
  final double to;
  final Color colour;
  final double height;

  @override
  Widget build(BuildContext context) {
    final low = from.clamp(0.0, 1.0);
    final high = to.clamp(low, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: height,
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
/// crossed it: the level on its badge, what the session paid, how far the
/// next one is, and where the level shows — beside the name, everywhere.
class LevelUpView extends StatelessWidget {
  const LevelUpView({super.key, required this.gain, required this.onContinue});

  final XpGain gain;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final now = xpLevel(gain.after);

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            // Centred in the space above the button when it fits, rather than
            // a number floating in the middle of an empty screen.
            child: LayoutBuilder(
              builder: (context, box) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: (box.maxHeight - 24).clamp(0, double.infinity),
                  ),
                  child: Column(
                    key: const Key('levelUp'),
                    mainAxisAlignment: MainAxisAlignment.center,
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
                      const SizedBox(height: 14),
                      PopIn(
                        from: 0.5,
                        child: _LevelBadge(level: now.level, size: 210),
                      ),
                      const SizedBox(height: 12),
                      ShrinkText(
                        l.levelNumber(localNumber(context, now.level)),
                        maxLines: 1,
                        style: context.type.title.copyWith(
                          color: context.colors.text,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l.xpGained(localNumber(context, gain.total)),
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 26),
                      _NextLevelCard(now: now),
                      const SizedBox(height: 12),
                      _BesideYourName(xp: gain.after),
                    ],
                  ),
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

/// The new level on a gold hexagon, glowing along its own edge.
class _LevelBadge extends StatelessWidget {
  const _LevelBadge({required this.level, required this.size});

  final int level;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 1.08,
      child: CustomPaint(
        painter: _HexPainter(fill: context.colors.surface),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size * 0.16),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                localNumber(context, level),
                style: TextStyle(
                  color: const Color(0xFFF2D27A),
                  fontSize: size * 0.46,
                  fontWeight: FontWeight.w900,
                  height: 1,
                  shadows: [
                    Shadow(
                      color: AppColors.gold.withValues(alpha: 0.6),
                      blurRadius: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HexPainter extends CustomPainter {
  const _HexPainter({required this.fill});

  final Color fill;

  Path _hex(Size size, double inset) {
    final w = size.width, h = size.height;
    return Path()
      ..moveTo(w / 2, inset)
      ..lineTo(w - inset, h * 0.25)
      ..lineTo(w - inset, h * 0.75)
      ..lineTo(w / 2, h - inset)
      ..lineTo(inset, h * 0.75)
      ..lineTo(inset, h * 0.25)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final outer = _hex(size, 6);
    // The glow follows the hexagon's edge, not a circle behind it.
    canvas.drawPath(
      outer,
      Paint()
        ..color = AppColors.gold.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );
    canvas.drawPath(outer, Paint()..color = fill);
    canvas.drawPath(
      outer,
      Paint()
        ..color = AppColors.gold
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawPath(
      _hex(size, size.width * 0.1),
      Paint()
        ..color = const Color(0xFF8A6518)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_HexPainter old) => old.fill != fill;
}

/// Where the new level stands: the bar to the next one, filling from empty.
class _NextLevelCard extends StatelessWidget {
  const _NextLevelCard({required this.now});

  final XpLevel now;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: reduceMotion(context) ? 1.0 : 0.0, end: 1.0),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) => Container(
        key: const Key('levelUpNext'),
        padding: const EdgeInsets.all(16),
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
                    style: TextStyle(color: context.colors.text, fontSize: 17),
                  ),
                ),
                Text(
                  l.xpOf(
                    localNumber(context, now.into),
                    localNumber(context, now.span),
                  ),
                  style: TextStyle(color: context.colors.muted, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 11),
            _XpBar(from: 0, to: now.progress * t, colour: AppColors.gold),
            const SizedBox(height: 9),
            ShrinkText(
              l.xpToLevel(
                localNumber(context, now.toNext),
                localNumber(context, now.level + 1),
              ),
              maxLines: 1,
              style: TextStyle(color: context.colors.muted, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

/// The level where everyone else sees it: this lifter's own row — picture,
/// name, and the chip that now carries the new number.
class _BesideYourName extends StatelessWidget {
  const _BesideYourName({required this.xp});

  final int xp;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final p = demoProfile;
    return Container(
      key: const Key('levelUpBeside'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.border, width: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          PlayerAvatar(
            name: p.username,
            tierIdx: p.isRanked ? p.tierIdx : null,
            image: avatar.picture,
            size: 40,
          ),
          const SizedBox(width: 12),
          // The name gets the whole width; what the row is for sits under
          // it, rather than beside it squeezing the name to "demo…".
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NameWithLevel(
                  name: p.username,
                  xp: xp,
                  chipFontSize: 13,
                  style: TextStyle(color: context.colors.text, fontSize: 17),
                ),
                const SizedBox(height: 2),
                Text(
                  l.levelBesideName,
                  style: TextStyle(color: context.colors.muted, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
