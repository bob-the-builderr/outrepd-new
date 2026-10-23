/// What the take ends on: the app's own result screen, with both sides as
/// chosen before the match. A promotion, when the LP earns one, comes first,
/// then a level-up when the plan asks for one — in that order in the app too.
///
/// Drawn from lib/screens/post_match.dart in the app, so a video of this is a
/// video of the real thing. The rank moves for the screen only: the plan keeps
/// the rank it started from, so every retake starts from the same place.
library;

import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../motion.dart';
import '../player_avatar.dart';
import '../ranking.dart';
import '../theme.dart';
import '../tier_badge.dart';
import '../type_scale.dart';
import '../screens/level.dart';
import '../widgets.dart';
import '../xp.dart';
import 'match_screen.dart' show photoOf;
import 'plan.dart';

class PromoResultScreen extends StatefulWidget {
  const PromoResultScreen({
    super.key,
    required this.plan,
    required this.yours,
    required this.theirs,
    required this.gaveUp,
  });

  final PromoPlan plan;
  final int yours;
  final int theirs;
  final bool gaveUp;

  @override
  State<PromoResultScreen> createState() => _PromoResultScreenState();
}

class _PromoResultScreenState extends State<PromoResultScreen> {
  late final bool _won = !widget.gaveUp && widget.yours >= widget.theirs;

  late final RankChange _change = applyLp(
    Rank(
      tierIdx: widget.plan.myTier,
      divIdx: widget.plan.myDiv,
      lp: widget.plan.myLp,
    ),
    // Weighed by the two ranks, as the app pays it.
    lpFor(
      won: _won,
      yourReps: widget.yours,
      theirReps: widget.theirs,
      yourLevel: ladderLevel(widget.plan.myTier, widget.plan.myDiv),
      theirLevel: ladderLevel(widget.plan.oppTier, widget.plan.oppDiv),
    ),
    floorTierIdx: widget.plan.myTier,
  );

  late bool _promotion = _change.promoted;

  /// The reps and twenty for the match, from where the plan puts the level.
  late final XpGain _xp = () {
    final gained = widget.yours + kXpPerMatch;
    final before = widget.plan.myXpBefore(gained);
    return XpGain(before: before, after: before + gained, reps: widget.yours);
  }();

  late bool _levelUp = _xp.leveledUp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: _promotion
          ? _PromotionView(
              change: _change,
              onContinue: () => setState(() => _promotion = false),
            )
          : _levelUp
          ? LevelUpView(
              level: levelOf(_xp.after),
              onContinue: () => setState(() => _levelUp = false),
            )
          : _ResultView(
              plan: widget.plan,
              won: _won,
              yourReps: widget.yours,
              theirReps: widget.theirs,
              change: _change,
              xp: _xp,
              onRematch: () => Navigator.of(context).pop(true),
              onDone: () => Navigator.of(context).pop(false),
            ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.plan,
    required this.won,
    required this.yourReps,
    required this.theirReps,
    required this.change,
    required this.xp,
    required this.onRematch,
    required this.onDone,
  });

  final PromoPlan plan;
  final bool won;
  final int yourReps;
  final int theirReps;
  final RankChange change;
  final XpGain xp;

  /// "+4 for the reps · +2 for a Platinum IV opponent": said only when the
  /// opponent's rank moved what the duel paid, the way the app says it.
  String? _breakdown(BuildContext context) {
    final gap = (yourReps - theirReps).abs();
    final forReps = won ? gap : -gap;
    final adjust = change.lpDelta - forReps;
    if (gap == 0 || adjust == 0 || adjust.abs() * 2 > gap + 1) return null;
    final l = L.of(context);
    String signed(int n) => n > 0
        ? '+${localNumber(context, n)}'
        : '−${localNumber(context, -n)}';
    return l.lpBreakdown(
      signed(forReps),
      signed(adjust),
      tierLabel(l, plan.oppTier, plan.oppDiv),
    );
  }
  final VoidCallback onRematch;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final margin = (yourReps - theirReps).abs();

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, box) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: (box.maxHeight - 40).clamp(0, double.infinity),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PopIn(
                        from: 0.6,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            (won ? l.youWonPlain : l.youLostPlain)
                                .toUpperCase(),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: context.type.title.copyWith(
                              color: won
                                  ? context.colors.brand
                                  : context.colors.rival,
                              fontSize: 46,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        won
                            ? l.repsAhead(localNumber(context, margin))
                            : l.repsOff(localNumber(context, margin)),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.colors.muted,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _Scoreboard(
                        plan: plan,
                        won: won,
                        yourReps: yourReps,
                        theirReps: theirReps,
                        yourTierIdx: change.after.tierIdx,
                      ),
                      const SizedBox(height: 24),
                      _LpCard(change: change, breakdown: _breakdown(context)),
                      const SizedBox(height: 10),
                      XpGainCard(gain: xp),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: const Key('rematch'),
                    onPressed: onRematch,
                    child: Text(l.rematch),
                  ),
                ),
                const SizedBox(height: 11),
                Row(
                  children: [
                    Expanded(
                      // There for the picture: the app has it here. Nothing
                      // to share from a staged match.
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Text(l.shareAction),
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: OutlinedButton(
                        key: const Key('done'),
                        onPressed: onDone,
                        child: Text(l.doneAction),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Scoreboard extends StatelessWidget {
  const _Scoreboard({
    required this.plan,
    required this.won,
    required this.yourReps,
    required this.theirReps,
    required this.yourTierIdx,
  });

  final PromoPlan plan;
  final bool won;
  final int yourReps;
  final int theirReps;
  final int yourTierIdx;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.border, width: 0.5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Side(
              avatar: PlayerAvatar(
                name: plan.myName,
                tierIdx: yourTierIdx,
                image: photoOf(plan.myPhoto),
                size: 58,
              ),
              name: plan.myName,
              reps: yourReps,
              colour: context.colors.text,
              accent: context.colors.brand,
              winner: won,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              '–',
              style: TextStyle(color: context.colors.faint, fontSize: 17),
            ),
          ),
          Expanded(
            child: _Side(
              avatar: PlayerAvatar(
                name: plan.oppName,
                tierIdx: plan.oppTier,
                image: photoOf(plan.oppPhoto),
                size: 58,
              ),
              name: plan.oppName,
              reps: theirReps,
              colour: context.colors.rival,
              accent: context.colors.rival,
              winner: !won,
            ),
          ),
        ],
      ),
    );
  }
}

class _Side extends StatelessWidget {
  const _Side({
    required this.avatar,
    required this.name,
    required this.reps,
    required this.colour,
    required this.accent,
    required this.winner,
  });

  final Widget avatar;
  final String name;
  final int reps;
  final Color colour;
  final Color accent;
  final bool winner;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: winner ? accent.withValues(alpha: 0.07) : null,
        border: Border.all(
          color: winner ? accent.withValues(alpha: 0.4) : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          avatar,
          const SizedBox(height: 6),
          ShrinkText(
            name,
            maxLines: 1,
            style: TextStyle(color: context.colors.muted, fontSize: 13),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              localNumber(context, reps),
              style: TextStyle(
                color: colour,
                fontSize: 62,
                fontWeight: FontWeight.w800,
                height: 1.05,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Visibility(
            visible: winner,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: ShrinkText(
              l.winnerLabel,
              maxLines: 1,
              style: TextStyle(
                color: accent,
                fontSize: 12,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// What the match did to the rank: the total, where it leaves you, and the
/// bar filling to it.
class _LpCard extends StatelessWidget {
  const _LpCard({required this.change, this.breakdown});

  final RankChange change;

  /// What the total was made of, when the opponent's rank changed it.
  final String? breakdown;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final lp = change.lpDelta;
    final gained = lp >= 0;
    final now = change.after;
    final before = (change.before.lp / 100).clamp(0.0, 1.0);
    // Promoted: the bar starts again from the bottom of the new division.
    final from = change.promoted ? 0.0 : before;
    final after = (now.lp / 100).clamp(0.0, 1.0);
    final toGo = (100 - now.lp).clamp(0, 100);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) => Container(
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
                    tierLabel(l, now.tierIdx, now.divIdx),
                    maxLines: 1,
                    style: TextStyle(color: context.colors.text, fontSize: 15),
                  ),
                ),
                Text(
                  '${gained ? '+' : '−'}'
                  '${l.lpAmount(localNumber(context, (lp.abs() * t).round()))}',
                  style: TextStyle(
                    color: gained ? context.colors.brand : context.colors.rival,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            _LpBar(
              before: from,
              after: (from + (after - from) * t).clamp(0.0, 1.0),
              gained: gained,
            ),
            const SizedBox(height: 6),
            ShrinkText(
              '${localNumber(context, now.lp)} '
              '${l.lpOutOf(localNumber(context, 100))}'
              '  ·  '
              '${l.toNextTier(localNumber(context, toGo), nextRankName(l, now.tierIdx, now.divIdx))}',
              maxLines: 1,
              style: TextStyle(color: context.colors.muted, fontSize: 13),
            ),
            if (breakdown case final breakdown?) ...[
              const SizedBox(height: 6),
              Text(
                breakdown,
                style: const TextStyle(color: AppColors.gold, fontSize: 13),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _LpBar extends StatelessWidget {
  const _LpBar({
    required this.before,
    required this.after,
    required this.gained,
  });

  final double before;
  final double after;
  final bool gained;

  @override
  Widget build(BuildContext context) {
    final low = before < after ? before : after;
    final high = before < after ? after : before;

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 8,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: context.colors.surfaceRaised),
            FractionallySizedBox(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: low,
              child: ColoredBox(color: context.colors.brand),
            ),
            FractionallySizedBox(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: high,
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: FractionallySizedBox(
                  widthFactor: high == 0 ? 0 : (high - low) / high,
                  heightFactor: 1,
                  child: ColoredBox(
                    color:
                        (gained ? context.colors.brand : context.colors.rival)
                            .withValues(alpha: 0.45),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The screen a promotion earns, as the app draws it.
class _PromotionView extends StatelessWidget {
  const _PromotionView({required this.change, required this.onContinue});

  final RankChange change;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final tierIdx = change.after.tierIdx;
    final divIdx = change.after.divIdx;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, box) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: (box.maxHeight - 40).clamp(0, double.infinity),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l.promotedLabel.toUpperCase(),
                        style: TextStyle(
                          color: context.colors.muted,
                          fontSize: 14,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _PromotedBadge(tierIdx: tierIdx, size: 172),
                      const SizedBox(height: 18),
                      ShrinkText(
                        tierLabel(l, tierIdx, divIdx),
                        maxLines: 1,
                        style: context.type.title.copyWith(
                          color: context.colors.text,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        l.promotedFrom(
                          tierLabel(
                            l,
                            change.before.tierIdx,
                            change.before.divIdx,
                          ),
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.colors.muted,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: context.colors.surface,
                          border: Border.all(
                            color: context.colors.border,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.lock_open_outlined,
                              size: 17,
                              color: context.colors.brand,
                            ),
                            const SizedBox(width: 11),
                            Expanded(
                              child: Text(
                                l.floorKept(
                                  tierName(l, tierIdx),
                                  tierLabel(l, tierIdx, 0),
                                ),
                                style: TextStyle(
                                  color: context.colors.text,
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {},
                    child: Text(l.shareAction),
                  ),
                ),
                const SizedBox(height: 6),
                TextButton(
                  key: const Key('continue'),
                  onPressed: onContinue,
                  child: Text(l.continueAction),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PromotedBadge extends StatelessWidget {
  const _PromotedBadge({required this.tierIdx, required this.size});

  final int tierIdx;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colour = kTiers[tierIdx.clamp(0, kTiers.length - 1)].color;

    Widget glow(double blur, double opacity) => ImageFiltered(
      imageFilter: ui.ImageFilter.blur(
        sigmaX: blur,
        sigmaY: blur,
        tileMode: ui.TileMode.decal,
      ),
      child: Opacity(
        opacity: opacity,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(colour, BlendMode.srcATop),
          child: TierBadge(tierIndex: tierIdx, size: size),
        ),
      ),
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutBack,
      builder: (context, t, _) => SizedBox(
        width: size,
        height: size,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            glow(28, (0.55 * t).clamp(0.0, 1.0)),
            glow(12, (0.7 * t).clamp(0.0, 1.0)),
            Transform.scale(
              scale: 0.7 + 0.3 * t,
              child: TierBadge(tierIndex: tierIdx, size: size),
            ),
          ],
        ),
      ),
    );
  }
}
