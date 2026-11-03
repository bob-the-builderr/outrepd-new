/// What a duel ends on.
///
/// Three screens: a win, a loss, and the promotion that sometimes follows one.
/// They share a shape — the verdict, the two scores, then a card that says
/// what it did to the rank — because the question after a minute of push-ups
/// is always the same two things in the same order: did I win, and what did it
/// cost or pay.
///
/// The rank card says what the duel did to the rating — 25 for a win or 20
/// off for a loss, and the gap in reps on top (2026-11-02) — and what it
/// added to the week's board, and where that moved you on it.
library;

import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../avatar.dart';
import '../backend/backend.dart';
import '../career.dart';
import '../data.dart';
import '../subscription.dart';
import '../rewards.dart';
import '../lifter/looks.dart';
import '../l10n/app_localizations.dart';
import '../motion.dart';
import '../player_avatar.dart';
import '../ranking.dart';
import '../health_sync.dart';
import '../settings.dart';
import '../theme.dart';
import '../tier_badge.dart';
import '../type_scale.dart';
import '../widgets.dart';
import '../xp.dart';
import 'daily_goal.dart';
import 'level.dart';
import 'live_rematch.dart';
import 'match_flow.dart' show kDuelLength;
import 'race_chart.dart';
import 'share_card.dart';

/// The current account, as [showShareCardSheet] needs it — the same shape
/// [ProfileScreen] shares from, built here too since a result or a
/// promotion is exactly the moment somebody wants to say so.
///
/// The places on the boards come from the server, as the profile screen's
/// do. They used to be the sample profile's — #1842 in the world, #64 in the
/// country — which nothing ever replaces, so every card shared from here
/// carried two numbers nobody had earned.
Future<void> _shareMyCard(BuildContext context) async {
  int? global;
  int? local;
  if (backend.available) {
    try {
      final places = await Future.wait([
        backend.boardPosition(),
        backend.boardPosition(country: backend.me?.country),
      ]);
      global = places.first;
      local = places.last;
    } on Object catch (error) {
      // No place on the card rather than a wrong one.
      debugPrint('Could not read the board positions: $error');
    }
  } else {
    global = demoProfile.globalRank;
    local = demoProfile.localRank;
  }
  if (!context.mounted) return;
  showShareCardSheet(
    context,
    data: ShareCardData(
      username: demoProfile.username,
      tierIdx: demoProfile.tierIdx,
      divIdx: demoProfile.divIdx,
      lp: demoProfile.lp,
      wins: demoProfile.wins,
      losses: demoProfile.losses,
      bestSet: demoProfile.bestSet,
      winStreak: demoProfile.winStreak,
      globalPlace: global,
      country: demoProfile.country,
      countryPlace: local,
      avatarUrl: backend.me?.avatarUrl,
      xp: demoProfile.xp,
      title: rewards.worn,
      pro: Subscription.instance.active,
      cover: MyCover.instance.cover,
    ),
  );
}

/// This duel, for the card shared from its result: the count, who it was
/// against, and what it did to the rank. The promotion screen shares the
/// profile card instead, because a promotion is news about the rank.
void _shareMatch(
  BuildContext context, {
  required bool won,
  required int yourReps,
  required int theirReps,
  required Opponent opponent,
  required DuelOutcome? outcome,
}) {
  final change = outcome?.rank;
  showMatchShareSheet(
    context,
    data: MatchShareData(
      username: demoProfile.username,
      won: won,
      yourReps: yourReps,
      theirReps: theirReps,
      opponent: opponent.username,
      seconds: kDuelLength.inSeconds,
      tierIdx: change?.after.tierIdx,
      divIdx: change?.after.divIdx ?? 0,
      lpDelta: change?.lpDelta,
      newBest: outcome?.newBest ?? false,
      avatarUrl: backend.me?.avatarUrl,
      opponentTierIdx: opponent.tierIdx,
      lp: change?.after.lp,
      pro: Subscription.instance.active,
      cover: MyCover.instance.cover,
    ),
  );
}

/// The win and the loss. One layout: the verdict reads differently, the
/// numbers do the rest.
class DuelResultView extends StatelessWidget {
  const DuelResultView({
    super.key,
    required this.won,
    required this.yourReps,
    required this.theirReps,
    required this.opponent,
    required this.outcome,
    required this.onRematch,
    required this.onDone,
    this.closestYet = false,
    this.live,
    this.onLiveRematch,
    this.weekBefore,
    this.weekAfter,
    this.rematchLabel,
    this.xp,
    this.yourRepTimes = const [],
    this.theirRepTimes = const [],
  });

  final bool won;
  final int yourReps;
  final int theirReps;

  /// When each rep of each set landed, in milliseconds from the start of the
  /// minute — the race chart, shown only when both are whole: one time for
  /// every rep in the result.
  final List<int> yourRepTimes;
  final List<int> theirRepTimes;
  final Opponent opponent;
  final DuelOutcome? outcome;

  /// The live match this was, when it was one. A live match's rematch is
  /// asked of the other phone, still on its own result screen, instead of
  /// recorded for them to race later.
  final LiveMatch? live;

  /// Both asked for the live rematch, and here it is.
  final ValueChanged<LiveMatch>? onLiveRematch;

  /// This account's place and points on the week's board before and after
  /// the duel, when known.
  final MonthPlace? weekBefore;
  final MonthPlace? weekAfter;

  /// The narrowest defeat on record. Only ever true on a loss, and only when
  /// it is actually true — a consolation the app invents is worth nothing.
  final bool closestYet;

  final VoidCallback onRematch;
  final VoidCallback onDone;

  /// What the button under the result says when it is not a live rematch:
  /// "Find a match" after a saved set, which is not raced twice.
  final String? rematchLabel;

  /// What the duel added to the level: every rep, and the match.
  final XpGain? xp;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final margin = (yourReps - theirReps).abs();
    // Only what is true about this set. [DuelOutcome.newBest] is judged on
    // the set alone, so a best set in a loss still says so.
    // The star drawn, not typed, for the same reason as the month's arrow.
    final chips = [
      if (outcome?.newBest ?? false)
        _Chip(label: l.newPersonalBest, icon: Icons.star_rounded),
      if (!won && closestYet) _Chip(label: l.closestYet),
    ];

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            // Centred in the space above the buttons when it fits, rather
            // than pinned to the top with half the screen empty under it.
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
                  // One line whatever the language: "VOUS AVEZ GAGNÉ" shrinks
                  // to fit rather than breaking the verdict in two.
                  PopIn(
                    from: 0.6,
                    child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      (won ? l.youWonPlain : l.youLostPlain).toUpperCase(),
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
                    won: won,
                    yourReps: yourReps,
                    theirReps: theirReps,
                    opponent: opponent,
                    yourTierIdx:
                        outcome?.rank?.after.tierIdx ??
                        (demoProfile.isRanked ? demoProfile.tierIdx : null),
                  ),
                  // The set's copy in Apple Health, once it is there: the
                  // reviewers asked to see the app say where it saves, and a
                  // lifter who turned it on is owed the same.
                  FutureBuilder<bool>(
                    future: outcome?.savedToHealth,
                    builder: (context, saved) {
                      final all = [
                        ...chips,
                        if (saved.data ?? false) const _HealthChip(),
                      ];
                      if (all.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 14),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 6,
                          runSpacing: 6,
                          children: all,
                        ),
                      );
                    },
                  ),
                  if (yourRepTimes.isNotEmpty &&
                      theirRepTimes.isNotEmpty &&
                      yourRepTimes.length == yourReps &&
                      theirRepTimes.length == theirReps) ...[
                    const SizedBox(height: 14),
                    RaceChart(
                      yours: yourRepTimes,
                      theirs: theirRepTimes,
                      opponent: opponent.username,
                    ),
                  ],
                  const SizedBox(height: 24),
                  LpCard(
                    outcome: outcome,
                    weekBefore: weekBefore,
                    weekAfter: weekAfter,
                  ),
                  if (outcome?.madeFriendly ?? false) ...[
                    const SizedBox(height: 10),
                    Text(
                      l.twoRankedADay,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.colors.muted,
                        fontSize: 14,
                      ),
                    ),
                  ],
                  if (xp case final gain?) ...[
                    const SizedBox(height: 10),
                    XpGainCard(gain: gain),
                  ],
                  // Only on the duel that met it: the goal is a daily thing,
                  // and saying so after every match that evening would turn
                  // it into wallpaper.
                  if (GoalDoneCard.reached(outcome, settings.dailyGoal)) ...[
                    const SizedBox(height: 14),
                    GoalDoneCard(
                      done: outcome!.todayAfter,
                      goal: settings.dailyGoal,
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
                if (live case final match? when onLiveRematch != null)
                  LiveRematchButton(
                    after: match,
                    // Played as ranked and settled as friendly: the next one
                    // would be friendly too, and it says so before the press.
                    friendlyNext: outcome?.madeFriendly ?? false,
                    onStart: onLiveRematch!,
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      key: const Key('rematch'),
                      onPressed: onRematch,
                      child: Text(rematchLabel ?? l.rematch),
                    ),
                  ),
                const SizedBox(height: 11),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _shareMatch(
                          context,
                          won: won,
                          yourReps: yourReps,
                          theirReps: theirReps,
                          opponent: opponent,
                          outcome: outcome,
                        ),
                        child: Text(l.shareAction),
                      ),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: OutlinedButton(
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

/// The two lifters side by side — avatar, name, count — with the winner's
/// half set off in their own colour, the way a match screen in a game shows
/// who took it.
class _Scoreboard extends StatelessWidget {
  const _Scoreboard({
    required this.won,
    required this.yourReps,
    required this.theirReps,
    required this.opponent,
    required this.yourTierIdx,
  });

  final bool won;
  final int yourReps;
  final int theirReps;
  final Opponent opponent;
  final int? yourTierIdx;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.border, width: 0.5),
        borderRadius: BorderRadius.circular(18),
      ),
      // Both halves are built the same way — the winner label is kept in
      // the layout on both — so they come out the same height on their own.
      child: Row(
        children: [
          Expanded(
            child: _Side(
              avatar: PlayerAvatar(
                name: demoProfile.username,
                tierIdx: yourTierIdx,
                image: avatar.picture,
                size: 58,
              ),
              name: l.you,
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
                name: opponent.username,
                tierIdx: opponent.tierIdx,
                image: pictureAt(opponent.avatarUrl),
                size: 58,
              ),
              name: opponent.username,
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
          // Kept in the layout on the losing side too, invisible, so both
          // halves stay the same height and the scores stay level.
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

class _Chip extends StatelessWidget {
  const _Chip({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: context.colors.surfaceRaised,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            if (icon != null) ...[
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Icon(icon, size: 15, color: AppColors.gold),
              ),
              const TextSpan(text: ' '),
            ],
            TextSpan(text: label),
          ],
        ),
        style: TextStyle(color: context.colors.text, fontSize: 13),
      ),
    );
  }
}

/// "Saved to Apple Health" under a result, once [saved] says the set is
/// there: nothing until then, and nothing if it did not go. For the screens
/// without the duel's row of chips — practice, and racing your own best.
class SavedToHealthChip extends StatelessWidget {
  const SavedToHealthChip({super.key, required this.saved});

  final Future<bool>? saved;

  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
    future: saved,
    builder: (context, done) => (done.data ?? false)
        ? const Padding(
            padding: EdgeInsets.only(top: 14),
            child: _HealthChip(),
          )
        : const SizedBox.shrink(),
  );
}

/// "Saved to Apple Health", with the Health mark: a red heart on white.
class _HealthChip extends StatelessWidget {
  const _HealthChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('savedToHealth'),
      padding: const EdgeInsets.fromLTRB(6, 5, 10, 5),
      decoration: BoxDecoration(
        color: context.colors.surfaceRaised,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const HealthMark(size: 18),
          const SizedBox(width: 6),
          Text(
            L.of(context).savedToHealth(HealthSync.name),
            style: TextStyle(color: context.colors.text, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

/// What the duel did to the rank — the rating it moved by, where that leaves
/// you, what it was made of — and, under it, what it added to the week's
/// board and where that moved you on it: the reason to play the next one.
class LpCard extends StatelessWidget {
  const LpCard({
    super.key,
    required this.outcome,
    this.weekBefore,
    this.weekAfter,
  });

  final DuelOutcome? outcome;

  /// The week's board before and after, when the server answered.
  final MonthPlace? weekBefore;
  final MonthPlace? weekAfter;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final outcome = this.outcome;
    final change = outcome?.rank;
    if (outcome == null || change == null) return const SizedBox.shrink();

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
    final change = outcome!.rank!;
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
    final streak = demoProfile.winStreak;
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
          [
            l.ptsAmount(localNumber(context, after.points)),
            // One short of the third win in a row, which is worth ten.
            if (streak > 0 && streak % 3 == 2)
              l.streakNextTen(localNumber(context, streak)),
          ].join('  ·  '),
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

/// The screen a promotion earns.
///
/// It says one thing, which is the thing that just happened. There is no
/// feature unlocked at a tier in this app, so nothing here announces one —
/// the promise it makes instead is the floor, which is real: a tier once
/// reached cannot be lost.
class PromotionView extends StatelessWidget {
  const PromotionView({
    super.key,
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
                    onPressed: () => _shareMyCard(context),
                    child: Text(l.shareAction),
                  ),
                ),
                const SizedBox(height: 6),
                TextButton(
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

/// The screen the placement earns: the account is on the ladder, at Iron V
/// like everybody, and the first rung up is right there.
class PlacedView extends StatelessWidget {
  const PlacedView({
    super.key,
    required this.rank,
    required this.onFindMatch,
    required this.onContinue,
  });

  /// Where the placement put the account — Iron V with no LP, unless the
  /// server ever says otherwise.
  final Rank rank;

  final VoidCallback onFindMatch;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final toGo = 100 - rank.lp;

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
                    key: const Key('placed'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l.placedLabel.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.colors.muted,
                          fontSize: 14,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _PromotedBadge(tierIdx: rank.tierIdx, size: 200),
                      const SizedBox(height: 14),
                      ShrinkText(
                        tierLabel(l, rank.tierIdx, rank.divIdx),
                        maxLines: 1,
                        style: context.type.title.copyWith(
                          color: context.colors.text,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l.placedBody,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: context.colors.muted,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 26),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: context.colors.surface,
                          border: Border.all(
                            color: context.colors.border,
                            width: 0.5,
                          ),
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
                                    l.toNextTier(
                                      localNumber(context, toGo),
                                      nextRankName(
                                        l,
                                        rank.tierIdx,
                                        rank.divIdx,
                                      ),
                                    ),
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: context.colors.text,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                Text(
                                  localNumber(context, rank.rating),
                                  style: TextStyle(
                                    color: context.colors.muted,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 11),
                            _LpBar(
                              before: rank.lp / 100,
                              after: rank.lp / 100,
                              gained: true,
                            ),
                            const SizedBox(height: 9),
                            Text(
                              l.placedHow,
                              style: TextStyle(
                                color: context.colors.muted,
                                fontSize: 14,
                                height: 1.4,
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
                    key: const Key('placedFindMatch'),
                    onPressed: onFindMatch,
                    child: Text(l.findMatch),
                  ),
                ),
                const SizedBox(height: 6),
                TextButton(
                  key: const Key('placedContinue'),
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

/// The new tier's badge arriving: it lands from a little smaller, and a glow
/// in its own colour rises behind it in the badge's own shape — blurred,
/// tinted copies of the badge rather than a circle, which read as a sticker
/// on a light rather than the crest itself shining.
class _PromotedBadge extends StatelessWidget {
  const _PromotedBadge({required this.tierIdx, required this.size});

  final int tierIdx;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colour = kTiers[tierIdx.clamp(0, kTiers.length - 1)].color;

    Widget glow(double blur, double opacity) => ImageFiltered(
      // Decal, not the default clamp: outside the badge there is nothing to
      // blur, and clamping drew a faint disc there — a circle behind the
      // crest, which is the one shape a glow here must not have.
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
        // The blur reaches past the badge; clipped, it would show as a
        // square of light.
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

/// An outcome for the web preview, where no duel has been fought.
///
/// Built from the real arithmetic rather than hand-written numbers, so what
/// the preview shows is what a lifter would be shown for the same result.
DuelOutcome demoOutcome({
  required bool won,
  bool newBest = false,
  Future<bool>? savedToHealth,
}) {
  final yourReps = won ? 18 : 14;
  final theirReps = won ? 11 : 19;
  final delta = lpFor(won: won, yourReps: yourReps, theirReps: theirReps);
  final before = Rank(
    tierIdx: demoProfile.tierIdx,
    divIdx: demoProfile.divIdx,
    lp: won ? 29 : 62,
  );

  return DuelOutcome(
    won: won,
    rank: applyLp(before, delta, floorTierIdx: 0),
    record: MatchRecord(
      won: won,
      userReps: yourReps,
      opponentReps: theirReps,
      opponent: demoOpponents.first.username,
      lpChange: delta,
      at: DateTime.now(),
    ),
    placementsFinished: false,
    newBest: newBest,
    savedToHealth: savedToHealth,
  );
}
