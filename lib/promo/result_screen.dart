/// What the take ends on: the app's own result screen, with both sides as
/// chosen before the match. A promotion, when the rating earns one, comes first,
/// then a level-up when the plan asks for one — in that order in the app too.
///
/// Drawn from lib/screens/post_match.dart in the app, so a video of this is a
/// video of the real thing. The rank moves for the screen only: the plan keeps
/// the rank it started from, so every retake starts from the same place.
library;

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../l10n/app_localizations.dart';
import '../motion.dart';
import '../player_avatar.dart';
import '../ranking.dart';
import '../theme.dart';
import '../tier_badge.dart';
import '../type_scale.dart';
import '../screens/level.dart';
import '../screens/race_chart.dart';
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
    this.yourRepTimes = const [],
    this.theirRepTimes = const [],
  });

  final PromoPlan plan;
  final int yours;
  final int theirs;
  final bool gaveUp;

  /// When each rep landed, for the race chart.
  final List<int> yourRepTimes;
  final List<int> theirRepTimes;

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
    lpFor(won: _won, yourReps: widget.yours, theirReps: widget.theirs),
    floorTierIdx: 0,
  );

  late bool _promotion = _change.promoted;

  /// The reps and twenty for the match, from where the plan puts the level.
  late final XpGain _xp = () {
    final gained = widget.yours + kXpPerMatch;
    final before = widget.plan.myXpBefore(gained);
    return XpGain(before: before, after: before + gained, reps: widget.yours);
  }();

  late bool _levelUp = _xp.leveledUp;

  /// The week's board as the plan has it, and after this match: the app's
  /// points, and a couple of places either way for the arrow.
  MonthPlace _week(int place, int points) {
    final now = DateTime.now().toUtc();
    return MonthPlace(
      season: DateTime.utc(now.year, now.month, now.day),
      endsAt: now.add(const Duration(days: 3)),
      place: place,
      ofTotal: 0,
      points: points,
      wins: 0,
      played: 0,
    );
  }

  late final MonthPlace _weekBefore = _week(
    widget.plan.weekPlace,
    widget.plan.weekPoints,
  );
  late final MonthPlace _weekAfter = _week(
    _won ? math.max(1, widget.plan.weekPlace - 2) : widget.plan.weekPlace + 1,
    math.max(0, widget.plan.weekPoints + (_won ? 5 : -2)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.background,
      body: _promotion
          ? _PromotionView(
              tierIdx: _change.after.tierIdx,
              divIdx: _change.after.divIdx,
              fromTierIdx: _change.before.tierIdx,
              fromDivIdx: _change.before.divIdx,
              highest: true,
              onContinue: () => setState(() => _promotion = false),
            )
          : _levelUp
          ? LevelUpView(
              gain: _xp,
              onContinue: () => setState(() => _levelUp = false),
            )
          : _ResultView(
              plan: widget.plan,
              won: _won,
              yourReps: widget.yours,
              theirReps: widget.theirs,
              change: _change,
              xp: _xp,
              weekBefore: _weekBefore,
              weekAfter: _weekAfter,
              yourRepTimes: widget.yourRepTimes,
              theirRepTimes: widget.theirRepTimes,
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
    required this.weekBefore,
    required this.weekAfter,
    required this.yourRepTimes,
    required this.theirRepTimes,
    required this.onRematch,
    required this.onDone,
  });

  final PromoPlan plan;
  final bool won;
  final int yourReps;
  final int theirReps;
  final RankChange change;
  final XpGain xp;
  final MonthPlace weekBefore;
  final MonthPlace weekAfter;
  final List<int> yourRepTimes;
  final List<int> theirRepTimes;
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
                      if (yourRepTimes.isNotEmpty &&
                          theirRepTimes.isNotEmpty &&
                          yourRepTimes.length == yourReps &&
                          theirRepTimes.length == theirReps) ...[
                        const SizedBox(height: 14),
                        RaceChart(
                          yours: yourRepTimes,
                          theirs: theirRepTimes,
                          opponent: plan.oppName,
                        ),
                      ],
                      const SizedBox(height: 24),
                      _LpCard(
                        change: change,
                        weekBefore: weekBefore,
                        weekAfter: weekAfter,
                      ),
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

/// What the duel did to the rank — the rating it moved by, where that leaves
/// you, what it was made of — and, under it, what it added to the week's
/// board and where that moved you on it: the reason to play the next one.
class _LpCard extends StatelessWidget {
  const _LpCard({
    required this.change,
    this.weekBefore,
    this.weekAfter,
  });

  final RankChange change;

  /// The week's board before and after, when the server answered.
  final MonthPlace? weekBefore;
  final MonthPlace? weekAfter;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final lp = change.lpDelta;
    final gained = lp >= 0;

    // Everything on this card comes out of the change itself, never out of
    // the live profile. They agree in the app — the profile was just written
    // from this — but a card that reads half its numbers from somewhere else
    // is a card that can contradict itself, and the preview showed it doing
    // exactly that.
    final now = change.after;
    final before = (change.before.lp / 100).clamp(0.0, 1.0);
    final after = (now.lp / 100).clamp(0.0, 1.0);

    // The rating lands in front of you: the number counts up and the bar
    // fills to where it ends, rather than both simply being there. The end
    // state is the same numbers the card always showed.
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1100),
      curve: Curves.easeOutCubic,
      builder: (context, t, _) => _card(
        context,
        l: l,
        now: now,
        lpShown: (lp.abs() * t).round(),
        gained: gained,
        before: before,
        after: before + (after - before) * t,
      ),
    );
  }

  /// "25 for the win + 7 for the reps": what the number was made of.
  String _parts(L l, BuildContext context, int delta) {
    final won = delta >= 0;
    final base = won ? kWinRating : kLossRating;
    final reps = delta.abs() - base;
    final first = won
        ? l.ratingForWin(localNumber(context, base))
        : l.ratingForLoss(localNumber(context, base));
    if (reps <= 0) return first;
    return '$first + ${l.ratingForReps(localNumber(context, reps))}';
  }

  Widget _card(
    BuildContext context, {
    required L l,
    required Rank now,
    required int lpShown,
    required bool gained,
    required double before,
    required double after,
  }) {
    final top = now.tierIdx >= kTopTier && now.divIdx >= kTopDivision;
    final toGo = (kRatingPerDivision - now.lp).clamp(0, kRatingPerDivision);
    final week = weekAfter;
    return Container(
      key: const Key('rankCard'),
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
              // The rank and the rating shrink together, as one line, beside
              // the total on a small phone at a large text size.
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        tierLabel(l, now.tierIdx, now.divIdx),
                        maxLines: 1,
                        style: TextStyle(color: context.colors.text, fontSize: 15),
                      ),
                      Text(
                        '  ·  ${localNumber(context, now.rating)}',
                        key: const Key('rating'),
                        style: TextStyle(color: context.colors.muted, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                '${gained ? '+' : '−'}${localNumber(context, lpShown)}',
                key: const Key('ratingDelta'),
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
          _LpBar(before: before, after: after.clamp(0.0, 1.0), gained: gained),
          const SizedBox(height: 6),
          ShrinkText(
            [
              if (!top)
                l.toNextTier(
                  localNumber(context, toGo),
                  nextRankName(l, now.tierIdx, now.divIdx),
                ),
              _parts(l, context, change.lpDelta),
            ].join('  ·  '),
            maxLines: 1,
            style: TextStyle(color: context.colors.muted, fontSize: 13),
          ),
          if (week != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: Divider(height: 1, color: context.colors.border),
            ),
            _WeekLine(before: weekBefore, after: week),
          ],
        ],
      ),
    );
  }
}

/// The week's board under the rank: the points this duel added and the
/// places it moved you, then the total and, one win short of a third in a
/// row, what the next win is worth.
class _WeekLine extends StatelessWidget {
  const _WeekLine({required this.before, required this.after});

  final MonthPlace? before;
  final MonthPlace after;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final before = this.before;
    final added = before == null ? null : after.points - before.points;
    final from = before?.place;
    final to = after.place;
    final rose = to != null && (from == null || to < from);
    final placeStyle = TextStyle(
      color: rose ? AppColors.win : context.colors.muted,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
    return Column(
      key: const Key('weekLine'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // "This week ▲ #14 → #12" shrinks as one line beside the points.
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerStart,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l.boardThisWeek,
                      maxLines: 1,
                      style: TextStyle(color: context.colors.text, fontSize: 15),
                    ),
                    if (to != null) ...[
                      const SizedBox(width: 8),
                      // The arrows drawn, not typed: as characters they are
                      // boxes on phones whose font does not have them.
                      if (rose)
                        Icon(Icons.arrow_drop_up_rounded, size: 22, color: placeStyle.color),
                      if (from != null && from != to) ...[
                        Text('#${localNumber(context, from)}', style: placeStyle),
                        Icon(Icons.arrow_forward_rounded, size: 15, color: placeStyle.color),
                      ],
                      Text('#${localNumber(context, to)}', style: placeStyle),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (added != null)
              Text(
                l.ptsAmount(
                  '${added >= 0 ? '+' : '−'}${localNumber(context, added.abs())}',
                ),
                key: const Key('weekPoints'),
                style: TextStyle(
                  color: added >= 0 ? AppColors.gold : context.colors.rival,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        ShrinkText(
          l.ptsAmount(localNumber(context, after.points)),
          maxLines: 1,
          style: TextStyle(color: context.colors.muted, fontSize: 13),
        ),
      ],
    );
  }
}

/// The LP bar, with the part this result moved drawn over the part that was
/// already there.
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
    // A win draws from where the bar was to where it is; a loss draws the
    // stretch it gave back. Either way the ghost is the change itself.
    final low = before < after ? before : after;
    final high = before < after ? after : before;

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 8,
        // Expand, so every layer is handed the bar's full 8dp. A Stack's
        // default loose height lets a childless ColoredBox shrink to nothing,
        // which is how the fill went missing.
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

/// The screen a promotion earns: it says the one thing that just happened.
class _PromotionView extends StatelessWidget {
  const _PromotionView({
    required this.tierIdx,
    required this.divIdx,
    required this.highest,
    required this.onContinue,
    this.fromTierIdx,
    this.fromDivIdx,
  });

  final int tierIdx;
  final int divIdx;

  /// The rank it came up from, when known: "from Gold III".
  final int? fromTierIdx;
  final int? fromDivIdx;

  /// Further than this account has ever been.
  final bool highest;

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            // Centred in the space above the buttons when it fits, rather
            // than pinned to the top with half the screen empty under it.
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
                  if (fromTierIdx case final fromTier?) ...[
                    const SizedBox(height: 3),
                    Text(
                      l.promotedFrom(
                        tierLabel(l, fromTier, fromDivIdx ?? 0),
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.colors.muted,
                        fontSize: 15,
                      ),
                    ),
                  ],
                  if (highest) ...[
                    const SizedBox(height: 7),
                    Text(
                      l.highestReached,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.colors.muted,
                        fontSize: 14,
                      ),
                    ),
                  ],
                  // The next tier and what it starts at. It used to be the
                  // floor ("Gold is yours"), until a tier could be lost
                  // (2026-11-02). Nothing above Master to name.
                  if (tierIdx < kTopTier) ...[
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
                            Icons.flag_outlined,
                            size: 17,
                            color: context.colors.brand,
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Text(
                              l.tierStartsAt(
                                tierName(l, tierIdx + 1),
                                localNumber(
                                  context,
                                  tierStartRating(tierIdx + 1),
                                ),
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
                    // There for the picture: nothing to share from a staged
                    // match.
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
