/// What a duel ends on.
///
/// Three screens: a win, a loss, and the promotion that sometimes follows one.
/// They share a shape — the verdict, the two scores, then a card that says
/// what it did to the rank — because the question after a minute of push-ups
/// is always the same two things in the same order: did I win, and what did it
/// cost or pay.
///
/// The LP card used to itemise a "+33 LP" into the reasons behind it — tier
/// gap, margin, form. There is only one reason now: LP is exactly the gap in
/// reps, which the two scores above the card already say in full.
library;

import 'dart:io';

import 'package:flutter/material.dart';

import '../avatar.dart';
import '../backend/backend.dart';
import '../career.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../player_avatar.dart';
import '../ranking.dart';
import '../theme.dart';
import '../tier_badge.dart';
import '../type_scale.dart';
import '../widgets.dart';
import 'match_flow.dart' show kDuelLength;
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
  });

  final bool won;
  final int yourReps;
  final int theirReps;
  final Opponent opponent;
  final DuelOutcome? outcome;

  /// The narrowest defeat on record. Only ever true on a loss, and only when
  /// it is actually true — a consolation the app invents is worth nothing.
  final bool closestYet;

  final VoidCallback onRematch;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final margin = (yourReps - theirReps).abs();
    // Only what is true about this set. [DuelOutcome.newBest] is judged on
    // the set alone, so a best set in a loss still says so.
    final chips = [
      if (outcome?.newBest ?? false) '★ ${l.newPersonalBest}',
      if (!won && closestYet) l.closestYet,
    ];

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 8),
              child: Column(
                children: [
                  Text(
                    won ? l.youWonPlain : l.youLostPlain,
                    textAlign: TextAlign.center,
                    style: context.type.title.copyWith(
                      color: context.colors.text,
                      fontSize: 34,
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
                      fontSize: 12.5,
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
                  if (chips.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 6,
                      runSpacing: 6,
                      children: [for (final c in chips) _Chip(label: c)],
                    ),
                  ],
                  const SizedBox(height: 24),
                  LpCard(outcome: outcome),
                ],
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
                    onPressed: onRematch,
                    child: Text(l.rematch),
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
                image: avatar.hasPhoto
                    ? FileImage(File(avatar.photoPath!))
                    : null,
                size: 46,
                ringColour: context.colors.surface,
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
              style: TextStyle(color: context.colors.faint, fontSize: 15),
            ),
          ),
          Expanded(
            child: _Side(
              avatar: PlayerAvatar(
                name: opponent.username,
                tierIdx: opponent.tierIdx,
                size: 46,
                ringColour: context.colors.surface,
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
            style: TextStyle(color: context.colors.muted, fontSize: 11.5),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              localNumber(context, reps),
              style: TextStyle(
                color: colour,
                fontSize: 48,
                fontWeight: FontWeight.w600,
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
                fontSize: 10.5,
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
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: context.colors.surfaceRaised,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(color: context.colors.text, fontSize: 11.5),
      ),
    );
  }
}

/// What the duel did to the rank: the total, where it leaves you, and what the
/// total was made of.
class LpCard extends StatelessWidget {
  const LpCard({super.key, required this.outcome});

  final DuelOutcome? outcome;

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
    final toGo = (100 - now.lp).clamp(0, 100);

    return Container(
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
                  style: TextStyle(color: context.colors.text, fontSize: 13),
                ),
              ),
              Text(
                '${gained ? '+' : '−'}'
                '${l.lpAmount(localNumber(context, lp.abs()))}',
                style: TextStyle(
                  color: gained ? context.colors.brand : context.colors.rival,
                  fontSize: 21,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          _LpBar(before: before, after: after, gained: gained),
          const SizedBox(height: 6),
          ShrinkText(
            '${localNumber(context, now.lp)} '
            '${l.lpOutOf(localNumber(context, 100))}'
            '  ·  '
            '${l.toNextTier(localNumber(context, toGo), nextRankName(l, now.tierIdx, now.divIdx))}',
            maxLines: 1,
            style: TextStyle(color: context.colors.muted, fontSize: 11),
          ),
        ],
      ),
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
  });

  final int tierIdx;
  final int divIdx;

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 34, 24, 8),
              child: Column(
                children: [
                  Text(
                    l.promotedLabel.toUpperCase(),
                    style: TextStyle(
                      color: context.colors.muted,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TierBadge(tierIndex: tierIdx, size: 96),
                  const SizedBox(height: 12),
                  ShrinkText(
                    tierLabel(l, tierIdx, divIdx),
                    maxLines: 1,
                    style: context.type.title.copyWith(
                      color: context.colors.text,
                      fontSize: 27,
                    ),
                  ),
                  if (highest) ...[
                    const SizedBox(height: 7),
                    Text(
                      l.highestReached,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.colors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
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
                            // The floor, which is the one promise a promotion
                            // in this app actually makes.
                            l.floorKept(
                              tierName(l, tierIdx),
                              tierLabel(l, tierIdx, 0),
                            ),
                            style: TextStyle(
                              color: context.colors.text,
                              fontSize: 13,
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

/// An outcome for the web preview, where no duel has been fought.
///
/// Built from the real arithmetic rather than hand-written numbers, so what
/// the preview shows is what a lifter would be shown for the same result.
DuelOutcome demoOutcome({required bool won, bool newBest = false}) {
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
    rank: applyLp(before, delta, floorTierIdx: demoProfile.peakTierIdx),
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
  );
}
