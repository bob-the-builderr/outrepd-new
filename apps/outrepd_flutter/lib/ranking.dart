/// What a result does to a rank.
///
/// Pure arithmetic, no storage and no widgets, because this is the part that
/// has to be right. Everything else in the app can be corrected by looking at
/// it; a promotion rule that is subtly wrong quietly mis-ranks everybody and
/// nobody can tell by looking.
///
/// The ladder is seven tiers of five divisions — Iron to Master. Divisions
/// climb V → I, so a higher [Rank.divIdx] is better, and LP runs 0–99 inside
/// a division (past 99 in Master I, which has nothing above it). The tier
/// count is [kTiers]'s length and `top_tier()` in `supabase/ladder.sql` is
/// the same number; they move together or the server hands out a rank the app
/// cannot draw.
///
/// Since 2026-11-02 the rank is shown as one number, its [Rank.rating]: 1,000
/// at the bottom of Iron, 100 a division, 500 a tier — the same rungs, with
/// the LP inside a division as the last two digits. "LP" is only the name the
/// code and the server still use for those points.
library;

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

/// What the bottom of the ladder is worth, and so what everybody starts on
/// (the user's number, 2026-11-02). Nobody goes below it.
const kRatingStart = 1000;

/// The points a division is: a whole division of LP.
const kRatingPerDivision = 100;

/// The rating at a rung and the LP into it.
int ratingOf(int tierIdx, int divIdx, int lp) =>
    kRatingStart +
    (tierIdx * kDivisions.length + divIdx) * kRatingPerDivision +
    lp;

/// The rating at the bottom of a tier.
int tierStartRating(int tierIdx) => ratingOf(tierIdx, 0, 0);

/// Where an account sits on the ladder.
class Rank {
  const Rank({required this.tierIdx, required this.divIdx, required this.lp});

  final int tierIdx;
  final int divIdx;
  final int lp;

  /// The very bottom of the ladder, where a placed account can land.
  static const start = Rank(tierIdx: 0, divIdx: 0, lp: 0);

  /// The rank as one number: [kRatingStart] at the bottom of Iron, 100 a
  /// division, 500 a tier.
  int get rating => ratingOf(tierIdx, divIdx, lp);

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

  /// The floor stopped a loss from applying in full: the rank is resting on
  /// the bottom of the ladder having moved no divisions. (There is no
  /// ceiling: Master I keeps counting.)
  bool get absorbed {
    if (promoted || demoted) return false;
    return before.lp + lpDelta < 0 && after.lp == 0;
  }

  /// The rating it moved by, what was actually realised.
  int get ratingDelta => after.rating - before.rating;
}

/// Applies an LP change and carries it through as many promotions or
/// demotions as it earns.
///
/// [floorTierIdx] is the tier whose bottom it cannot fall through. It used to
/// be the highest tier ever reached; since 2026-11-02 a tier can be lost and
/// every caller passes Iron, so the floor is [kRatingStart].
RankChange applyLp(Rank from, int delta, {required int floorTierIdx}) {
  var tier = from.tierIdx;
  var div = from.divIdx;
  var lp = from.lp + delta;

  // A loop rather than a single step: nothing in the app hands out 200 LP
  // today, but a rule that only works for small numbers is a rule waiting to
  // be broken by a bonus.
  while (lp >= 100) {
    if (tier >= kTopTier && div >= kTopDivision) {
      // Nothing above this to roll into: LP keeps counting instead.
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

/// What a duel pays (the user's rule, 2026-11-02): [kWinRating] for a win
/// and [kLossRating] off for a loss, and the gap in reps on top of either.
/// Who it was against does not count. The same arithmetic as lp_for in
/// supabase/ladder.sql.
///
/// [won] and the reps normally agree — more reps than the other side is a
/// win — so this only matters in the one place they can split: walking out
/// while still ahead is a loss regardless of the count at the moment of
/// quitting, and a loss must never pay a gain.
int lpFor({required bool won, required int yourReps, required int theirReps}) {
  final gap = (yourReps - theirReps).abs();
  return won ? kWinRating + gap : -(kLossRating + gap);
}

/// What a win pays before the gap in reps.
const kWinRating = 25;

/// What a loss costs before the gap in reps.
const kLossRating = 20;

/// A forfeit has no reps to compare: a win with no gap.
const kForfeitLp = kWinRating;

/// Where an account starts once its placement duel is done: Iron V with no
/// LP, whatever the result. One duel says nothing about a lifter, so it
/// decides nothing but that the climb has begun. The twin of
/// `placement_rank` in supabase/ladder.sql.
Rank placementRank(int wins) => Rank.start;
