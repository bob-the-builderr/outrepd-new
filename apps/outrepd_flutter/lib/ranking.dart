/// What a result does to a rank.
///
/// Pure arithmetic, no storage and no widgets, because this is the part that
/// has to be right. Everything else in the app can be corrected by looking at
/// it; a promotion rule that is subtly wrong quietly mis-ranks everybody and
/// nobody can tell by looking.
///
/// The ladder is seven tiers of five divisions — Iron to Master. Divisions
/// climb V → I, so a higher [Rank.divIdx] is better, and LP runs 0–99 inside
/// a division. The tier count is [kTiers]'s length and `top_tier()` in
/// `supabase/ladder.sql` is the same number; they move together or the server
/// hands out a rank the app cannot draw.
library;

import 'package:flutter/foundation.dart';

import 'data.dart' show kPlacementDuels;
import 'theme.dart' show kTiers;
import 'widgets.dart' show kDivisions;

/// The last division index — I, the top of a tier.
final int kTopDivision = kDivisions.length - 1;

/// The last tier index.
final int kTopTier = kTiers.length - 1;

/// How many rungs the ladder has: every division of every tier.
final int kLadderLevels = kTiers.length * kDivisions.length;

/// The rung somebody is standing on, counted from the bottom, starting at 1.
///
/// A level rather than a second currency. Nothing is stored for it and nothing
/// is earned towards it — it is the rank said as a number, so a score card can
/// show what two lifters are worth to each other in one glyph instead of
/// "Gold III" against "Silver I", which takes a moment to compare and means
/// nothing at all to somebody in their first week.
int ladderLevel(int tierIdx, int divIdx) =>
    tierIdx.clamp(0, kTopTier) * kDivisions.length +
    divIdx.clamp(0, kTopDivision) +
    1;

/// Where an account sits on the ladder.
class Rank {
  const Rank({required this.tierIdx, required this.divIdx, required this.lp});

  final int tierIdx;
  final int divIdx;
  final int lp;

  /// The very bottom of the ladder, where a placed account can land.
  static const start = Rank(tierIdx: 0, divIdx: 0, lp: 0);

  bool get atCeiling => tierIdx >= kTopTier && divIdx >= kTopDivision;

  Rank copyWith({int? tierIdx, int? divIdx, int? lp}) => Rank(
    tierIdx: tierIdx ?? this.tierIdx,
    divIdx: divIdx ?? this.divIdx,
    lp: lp ?? this.lp,
  );

  @override
  bool operator ==(Object other) =>
      other is Rank &&
      other.tierIdx == tierIdx &&
      other.divIdx == divIdx &&
      other.lp == lp;

  @override
  int get hashCode => Object.hash(tierIdx, divIdx, lp);

  @override
  String toString() => 'Rank(t$tierIdx d$divIdx ${lp}lp)';
}

/// How a rank changed, so the screen after a duel can say what happened.
class RankChange {
  const RankChange({
    required this.before,
    required this.after,
    required this.lpDelta,
  });

  final Rank before;
  final Rank after;

  /// What was applied, before any clamping at the floor or the ceiling. Kept
  /// separate from the difference actually realised so a result can say
  /// "−18 LP" honestly even when the floor absorbed it.
  final int lpDelta;

  bool get promoted =>
      after.tierIdx > before.tierIdx ||
      (after.tierIdx == before.tierIdx && after.divIdx > before.divIdx);

  bool get demoted =>
      after.tierIdx < before.tierIdx ||
      (after.tierIdx == before.tierIdx && after.divIdx < before.divIdx);

  bool get changedTier => after.tierIdx != before.tierIdx;

  /// A boundary stopped the change from applying in full.
  ///
  /// Either the floor held a loss that would have dropped a tier, or the
  /// ceiling held a win with nowhere above it to go. In both cases the rank
  /// ends up resting exactly on the boundary having moved no divisions.
  bool get absorbed {
    if (promoted || demoted) return false;
    final unbounded = before.lp + lpDelta;
    if (unbounded < 0) return after.lp == 0;
    if (unbounded >= 100) return after.lp == 99;
    return false;
  }
}

/// Applies an LP change and carries it through as many promotions or
/// demotions as it earns.
///
/// [floorTierIdx] is the highest tier this account has ever reached. It cannot
/// fall out of that tier — which is a promise the progression screen already
/// makes in words ("Gold is yours"), so the arithmetic has to keep it.
RankChange applyLp(Rank from, int delta, {required int floorTierIdx}) {
  var tier = from.tierIdx;
  var div = from.divIdx;
  var lp = from.lp + delta;

  // A loop rather than a single step: nothing in the app hands out 200 LP
  // today, but a rule that only works for small numbers is a rule waiting to
  // be broken by a bonus.
  while (lp >= 100) {
    if (tier >= kTopTier && div >= kTopDivision) {
      // Nothing above this. LP stops rather than rolling over into a tier
      // that does not exist.
      lp = 99;
      break;
    }
    lp -= 100;
    if (div < kTopDivision) {
      div++;
    } else {
      tier++;
      div = 0;
    }
  }

  while (lp < 0) {
    final atTierBottom = div == 0;
    // The floor: a tier once reached is kept. Falling below it is not a
    // smaller loss, it is no loss at all.
    if (atTierBottom && tier <= floorTierIdx) {
      lp = 0;
      break;
    }
    lp += 100;
    if (div > 0) {
      div--;
    } else {
      tier--;
      div = kTopDivision;
    }
  }

  return RankChange(
    before: from,
    after: Rank(tierIdx: tier, divIdx: div, lp: lp),
    lpDelta: delta,
  );
}

/// One duel's LP, itemised.
///
/// A single number tells somebody what happened to them and nothing about why.
/// These are the reasons, and they are added up rather than decorated onto a
/// total — so the screen cannot show a breakdown that does not sum to what the
/// account actually moved by.
@immutable
class LpBreakdown {
  const LpBreakdown({
    required this.result,
    required this.tierGap,
    required this.margin,
    required this.form,
  });

  /// The win or the loss itself, before anything about how it went.
  final int result;

  /// Who was on the other side. Beating somebody above you is worth more;
  /// losing to somebody below you costs more.
  final int tierGap;

  /// How far apart it finished.
  ///
  /// ⚠️ Two things constrain this, and both are load-bearing.
  ///
  /// It used to be deliberately absent: paying for margin pays for picking on
  /// people. So it is capped hard — five LP at the very most against a base of
  /// fifteen — and a blowout is worth a third of a win, which farming a weak
  /// opponent can never make up against facing a strong one.
  ///
  /// And it never makes a loss worse. The card before the round promises a
  /// number, and margin is not knowable then; if a heavy defeat cost more than
  /// the card said, the app would have quietly risked more of somebody's rank
  /// than it told them it would. So on a loss this only ever softens — a
  /// narrow defeat costs less — which leaves the promise a worst case rather
  /// than a guess.
  final int margin;

  /// A set of full-depth reps, measured against the lifter's own deepest.
  final int form;

  int get total => result + tierGap + margin + form;
}

/// The most margin can move a result, either way.
const kMarginCap = 5;

/// Reps of difference each point of margin is worth.
const kRepsPerMarginPoint = 3;

/// What a duel pays, itemised.
///
/// [clean] is whether the reps held their depth — the counter measures it
/// against the lifter's own deepest rep, not a table of angles, so it means
/// "you did not shorten them as you tired" rather than "you match a model".
LpBreakdown lpFor({
  required bool won,
  required int yourTier,
  required int theirTier,
  required int yourReps,
  required int theirReps,
  required bool clean,
}) {
  final apart = (yourReps - theirReps).abs();
  final gap = apart ~/ kRepsPerMarginPoint;
  return LpBreakdown(
    result: won ? 15 : -12,
    tierGap: won
        ? (theirTier - yourTier).clamp(0, 6) * 2
        : -(yourTier - theirTier).clamp(0, 6) * 2,
    // A win pays for the gap it opened. A loss is *refunded* for how close it
    // was, so the worst case is the number the lifter was shown beforehand.
    margin: won
        ? gap.clamp(0, kMarginCap)
        : (kMarginCap - 1 - gap).clamp(0, kMarginCap - 1),
    // Paid on a loss too. A lifter who went all the way down on every rep and
    // still lost did the work, and the screen that tells them they lost is the
    // wrong place to also tell them it counted for nothing.
    form: clean ? 2 : 0,
  );
}

/// What a win pays and what a loss costs, from the gap in rank alone.
///
/// Beating somebody far above you is worth more than beating somebody level.
/// These are [lpFor] without the parts that need a score, kept for the places
/// that have no score to read — a forfeit, and the tests that predate margin.
int lpForWin(int yourTier, int theirTier) =>
    15 + (theirTier - yourTier).clamp(0, 6) * 2;

int lpForLoss(int yourTier, int theirTier) =>
    -(12 + (yourTier - theirTier).clamp(0, 6) * 2);

/// A forfeit is a flat win. You did not have to close the gap, so the gap
/// pays nothing.
const kForfeitLp = 20;

/// Where an account starts once its placement duels are done.
///
/// Wins decide it, and nothing else. Margin would let somebody farm a start
/// by picking soft opponents, and five duels is far too small a sample to
/// read anything finer than "how often did they win".
///
/// The top of the range is Gold IV: placements can find a strong beginner
/// quickly, but the tiers above that are meant to be climbed, not granted.
Rank placementRank(int wins, {int duels = kPlacementDuels}) {
  final safeDuels = duels <= 0 ? 1 : duels;
  final share = wins.clamp(0, safeDuels) / safeDuels;

  // tier, division — read as a ladder rather than computed, so the outcome of
  // each result is obvious to anybody reading it.
  //
  // Re-spaced when the ladder went from nine tiers to seven. A clean sweep
  // used to land at Gold IV, which was below the middle of nine and is the
  // middle of seven — and placements handing somebody the middle of the app
  // on their first afternoon is the thing this table exists not to do. The
  // top of it is Silver I, which leaves four of the seven tiers to climb.
  const ladder = <(int, int)>[
    (0, 2), // no wins        → Iron III
    (0, 4), // one in five    → Iron I
    (1, 2), // two            → Bronze III
    (1, 4), // three          → Bronze I
    (2, 2), // four           → Silver III
    (2, 4), // all five       → Silver I
  ];

  final step = (share * (ladder.length - 1)).round();
  final (tier, div) = ladder[step.clamp(0, ladder.length - 1)];
  return Rank(tierIdx: tier, divIdx: div, lp: 0);
}
