/// What a duel ends on.
///
/// Three screens: a win, a loss, and the promotion that sometimes follows one.
/// They share a shape — the verdict, the two scores, then a card that says
/// what it did to the rank — because the question after a minute of push-ups
/// is always the same two things in the same order: did I win, and what did it
/// cost or pay.
///
/// The LP card itemises. A single "+33 LP" tells somebody what happened to
/// them and nothing about why, and the why is the part that changes what they
/// do next: face somebody higher, finish stronger, hold the depth. Every row
/// comes out of [LpBreakdown], so the rows cannot add up to anything other
/// than what the account actually moved by.
library;

import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../career.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../ranking.dart';
import '../theme.dart';
import '../tier_badge.dart';
import '../type_scale.dart';
import '../widgets.dart';
import 'share_card.dart';

/// The current account, as [showShareCardSheet] needs it — the same shape
/// [ProfileScreen] shares from, built here too since a result or a
/// promotion is exactly the moment somebody wants to say so.
void _shareMyCard(BuildContext context) {
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
      globalPlace: demoProfile.globalRank,
      country: demoProfile.country,
      countryPlace: demoProfile.localRank,
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
                      fontSize: 30,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _Scores(
                    yourReps: yourReps,
                    theirReps: theirReps,
                    opponent: opponent.username,
                  ),
                  if (!won) ...[
                    const SizedBox(height: 14),
                    Text(
                      [
                        l.repsOff(localNumber(
                            context, (theirReps - yourReps).abs())),
                        if (closestYet) l.closestYet,
                      ].join(' '),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.colors.muted,
                        fontSize: 12,
                        height: 1.5,
                      ),
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
                        onPressed: () => _shareMyCard(context),
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

/// The two counts, side by side, with a dash between them.
class _Scores extends StatelessWidget {
  const _Scores({
    required this.yourReps,
    required this.theirReps,
    required this.opponent,
  });

  final int yourReps;
  final int theirReps;
  final String opponent;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    Widget side(String name, int reps, Color colour) => Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShrinkText(
                name,
                maxLines: 1,
                style: TextStyle(color: context.colors.muted, fontSize: 11),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  localNumber(context, reps),
                  style: TextStyle(
                    color: colour,
                    fontSize: 46,
                    height: 1.05,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ],
          ),
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        side(l.you, yourReps, context.colors.text),
        Padding(
          padding: const EdgeInsets.only(bottom: 13),
          child: Text(
            '–',
            style: TextStyle(color: context.colors.faint, fontSize: 15),
          ),
        ),
        side(opponent, theirReps, context.colors.rival),
      ],
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
          if (outcome.breakdown case final parts?) ...[
            const SizedBox(height: 13),
            Divider(height: 1, thickness: 0.5, color: context.colors.border),
            const SizedBox(height: 11),
            // Only the rows that did something. A column of zeroes reads as
            // four rules the lifter failed rather than four that did not apply.
            for (final row in [
              (outcome.won ? l.lpRowWin : l.lpRowLoss, parts.result),
              (l.lpRowOpponent, parts.tierGap),
              (l.lpRowMargin, parts.margin),
              (l.lpRowDepth, parts.form),
            ])
              if (row.$2 != 0) _LpRow(label: row.$1, amount: row.$2),
          ],
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
        child: Stack(
          children: [
            Positioned.fill(
              child: ColoredBox(color: context.colors.surfaceRaised),
            ),
            FractionallySizedBox(
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
                  child: ColoredBox(
                    color: (gained ? context.colors.brand : context.colors.rival)
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

class _LpRow extends StatelessWidget {
  const _LpRow({required this.label, required this.amount});

  final String label;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: ShrinkText(
              label,
              maxLines: 1,
              style: TextStyle(color: context.colors.muted, fontSize: 12),
            ),
          ),
          Text(
            '${amount > 0 ? '+' : '−'}'
            '${localNumber(context, amount.abs())}',
            style: TextStyle(
              color: context.colors.text,
              fontSize: 12,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
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
                      style:
                          TextStyle(color: context.colors.muted, fontSize: 12),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      border:
                          Border.all(color: context.colors.border, width: 0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lock_open_outlined,
                            size: 17, color: context.colors.brand),
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
DuelOutcome demoOutcome({required bool won}) {
  final parts = lpFor(
    won: won,
    yourTier: demoProfile.tierIdx,
    theirTier: demoProfile.tierIdx + (won ? 2 : -1),
    yourReps: won ? 18 : 14,
    theirReps: won ? 11 : 19,
    clean: won,
  );
  final before = Rank(
    tierIdx: demoProfile.tierIdx,
    divIdx: demoProfile.divIdx,
    lp: won ? 29 : 62,
  );

  return DuelOutcome(
    won: won,
    rank: applyLp(before, parts.total, floorTierIdx: demoProfile.peakTierIdx),
    breakdown: parts,
    record: MatchRecord(
      won: won,
      userReps: won ? 18 : 14,
      opponentReps: won ? 11 : 19,
      opponent: demoOpponents.first.username,
      lpChange: parts.total,
      at: DateTime.now(),
    ),
    placementsFinished: false,
    newBest: false,
  );
}
