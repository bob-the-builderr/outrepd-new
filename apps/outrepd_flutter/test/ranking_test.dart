/// The promotion and demotion rules.
///
/// Tested harder than anything else in the app because a rank is the only
/// number here nobody can check by looking. A miscounted rep is visible in the
/// same second; a promotion rule that is off by one quietly mis-ranks every
/// account and looks completely normal doing it.
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/data.dart';
import 'package:outrepd/ranking.dart';
import 'package:outrepd/theme.dart';
import 'package:outrepd/widgets.dart';

void main() {
  const gold3 = Rank(tierIdx: 3, divIdx: 2, lp: 64);

  group('inside a division', () {
    test('a win adds LP and nothing else moves', () {
      final change = applyLp(gold3, 18, floorTierIdx: 3);

      expect(change.after, const Rank(tierIdx: 3, divIdx: 2, lp: 82));
      expect(change.promoted, isFalse);
      expect(change.demoted, isFalse);
    });

    test('a loss takes LP and nothing else moves', () {
      final change = applyLp(gold3, -14, floorTierIdx: 3);

      expect(change.after, const Rank(tierIdx: 3, divIdx: 2, lp: 50));
      expect(change.demoted, isFalse);
    });
  });

  group('crossing a division', () {
    test('a hundred promotes and carries the remainder', () {
      final change = applyLp(gold3, 40, floorTierIdx: 3);

      // 64 + 40 = 104 → up one division with 4 LP in hand. Losing the
      // remainder is the bug this guards: it silently steals a few points on
      // every promotion anybody ever earns.
      expect(change.after, const Rank(tierIdx: 3, divIdx: 3, lp: 4));
      expect(change.promoted, isTrue);
      expect(change.changedTier, isFalse);
    });

    test('below zero demotes and carries the remainder', () {
      final change = applyLp(gold3, -80, floorTierIdx: 0);

      // 64 − 80 = −16 → down one division, 84 LP left.
      expect(change.after, const Rank(tierIdx: 3, divIdx: 1, lp: 84));
      expect(change.demoted, isTrue);
    });

    test('the top division promotes into the next tier at its bottom', () {
      const goldI = Rank(tierIdx: 3, divIdx: 4, lp: 90);
      final change = applyLp(goldI, 20, floorTierIdx: 3);

      expect(change.after, const Rank(tierIdx: 4, divIdx: 0, lp: 10));
      expect(change.changedTier, isTrue);
      expect(change.promoted, isTrue);
    });

    test('the bottom division demotes into the tier below at its top', () {
      const platV = Rank(tierIdx: 4, divIdx: 0, lp: 10);
      final change = applyLp(platV, -30, floorTierIdx: 0);

      expect(change.after, const Rank(tierIdx: 3, divIdx: 4, lp: 80));
      expect(change.changedTier, isTrue);
      expect(change.demoted, isTrue);
    });

    test('a very large gain walks up as many steps as it earns', () {
      const stoneV = Rank(tierIdx: 0, divIdx: 0, lp: 0);
      final change = applyLp(stoneV, 640, floorTierIdx: 0);

      // Six whole divisions and 40 left over: Stone has five, so this lands
      // in Bronze. A rule that only promotes once per result would leave the
      // other five hundred points on the floor.
      expect(change.after, const Rank(tierIdx: 1, divIdx: 1, lp: 40));
    });
  });

  group('the floor', () {
    test('a tier once reached is never lost', () {
      const goldV = Rank(tierIdx: 3, divIdx: 0, lp: 5);
      final change = applyLp(goldV, -40, floorTierIdx: 3);

      // The progression screen promises this in words — "Gold is yours" — so
      // the arithmetic has to keep it.
      expect(change.after, const Rank(tierIdx: 3, divIdx: 0, lp: 0));
      expect(change.demoted, isFalse);
      // The loss is still reported honestly even though it was absorbed.
      expect(change.lpDelta, -40);
      expect(change.absorbed, isTrue);
    });

    test('a tier above the floor can still be lost', () {
      const platV = Rank(tierIdx: 4, divIdx: 0, lp: 5);
      final change = applyLp(platV, -40, floorTierIdx: 3);

      expect(change.after.tierIdx, 3);
      expect(change.demoted, isTrue);
    });

    test('the very bottom cannot go below zero', () {
      const stoneV = Rank(tierIdx: 0, divIdx: 0, lp: 3);
      final change = applyLp(stoneV, -50, floorTierIdx: 0);

      expect(change.after, const Rank(tierIdx: 0, divIdx: 0, lp: 0));
    });
  });

  group('the ceiling', () {
    test('the top of the ladder holds instead of rolling over', () {
      final top = Rank(
        tierIdx: kTiers.length - 1,
        divIdx: kDivisions.length - 1,
        lp: 95,
      );
      final change = applyLp(top, 40, floorTierIdx: 0);

      expect(change.after.tierIdx, kTiers.length - 1);
      expect(change.after.divIdx, kDivisions.length - 1);
      expect(change.after.lp, 99);
      expect(change.promoted, isFalse);
    });
  });

  group('what a result is worth', () {
    test('beating somebody above you pays more', () {
      expect(lpForWin(3, 5), greaterThan(lpForWin(3, 3)));
    });

    test('beating somebody below you pays no less than level', () {
      // No penalty for who you drew — you do not choose your opponent.
      expect(lpForWin(5, 3), lpForWin(5, 5));
    });

    test('losing to somebody below you costs more', () {
      expect(lpForLoss(5, 3), lessThan(lpForLoss(5, 5)));
    });

    test('a loss is always a loss and a win always a win', () {
      for (var mine = 0; mine < kTiers.length; mine++) {
        for (var theirs = 0; theirs < kTiers.length; theirs++) {
          expect(lpForWin(mine, theirs), greaterThan(0));
          expect(lpForLoss(mine, theirs), lessThan(0));
        }
      }
    });

    test('a forfeit pays a flat win with no margin in it', () {
      expect(kForfeitLp, greaterThan(0));
    });
  });

  group('placements', () {
    test('more wins never means a worse start', () {
      var previous = placementRank(0);
      for (var wins = 1; wins <= kPlacementDuels; wins++) {
        final next = placementRank(wins);
        final climbed = next.tierIdx > previous.tierIdx ||
            (next.tierIdx == previous.tierIdx && next.divIdx >= previous.divIdx);
        expect(climbed, isTrue,
            reason: '$wins wins placed below ${wins - 1}: $next vs $previous');
        previous = next;
      }
    });

    test('nobody is placed outside the ladder', () {
      for (var wins = 0; wins <= kPlacementDuels; wins++) {
        final rank = placementRank(wins);
        expect(rank.tierIdx, inInclusiveRange(0, kTiers.length - 1));
        expect(rank.divIdx, inInclusiveRange(0, kDivisions.length - 1));
        expect(rank.lp, inInclusiveRange(0, 99));
      }
    });

    test('a clean sweep still has most of the ladder left to climb', () {
      // Placements find a strong beginner quickly; they do not hand anybody
      // the top of the app on their first afternoon.
      expect(placementRank(kPlacementDuels).tierIdx,
          lessThan(kTiers.length ~/ 2));
    });

    test('losing every placement still puts somebody on the board', () {
      final rank = placementRank(0);
      expect(rank.tierIdx, 0);
      // Not at the very bottom of the bottom tier: starting on the floor with
      // nowhere to fall is a worse first impression than it needs to be.
      expect(rank.divIdx, greaterThan(0));
    });
  });

  group('a long season never breaks the ladder', () {
    test('a thousand mixed results stay inside the rails', () {
      var rank = placementRank(2);
      var floor = rank.tierIdx;

      // Alternating wins and losses with a slight upward bias, which is what
      // a real account looks like. The point is not where it lands; it is that
      // nothing ever escapes the ladder on the way.
      for (var i = 0; i < 1000; i++) {
        final delta = i % 3 == 0
            ? lpForLoss(rank.tierIdx, rank.tierIdx)
            : lpForWin(rank.tierIdx, rank.tierIdx);
        rank = applyLp(rank, delta, floorTierIdx: floor).after;
        if (rank.tierIdx > floor) floor = rank.tierIdx;

        expect(rank.lp, inInclusiveRange(0, 99), reason: 'result $i');
        expect(rank.tierIdx, inInclusiveRange(0, kTiers.length - 1),
            reason: 'result $i');
        expect(rank.divIdx, inInclusiveRange(0, kDivisions.length - 1),
            reason: 'result $i');
        expect(rank.tierIdx, greaterThanOrEqualTo(floor),
            reason: 'fell below the floor at result $i');
      }
    });
  });

  group('the level', () {
    test('counts rungs from the bottom of the ladder', () {
      // A level is the rank said as a number, so the two must never disagree:
      // the bottom of the ladder is 1, the top is every division of every
      // tier, and nothing in between repeats.
      expect(ladderLevel(0, 0), 1);
      expect(ladderLevel(kTopTier, kTopDivision), kLadderLevels);
    });

    test('never goes backwards on the way up', () {
      var last = 0;
      for (var tier = 0; tier <= kTopTier; tier++) {
        for (var div = 0; div <= kTopDivision; div++) {
          final level = ladderLevel(tier, div);
          expect(level, last + 1,
              reason: 'tier $tier division $div broke the run');
          last = level;
        }
      }
      expect(last, kLadderLevels);
    });

    test('a rank off the end of the ladder still reads as a level', () {
      // Stored ranks outlive the ladder they were written against. A level
      // that throws — or reads zero — on an old profile is worse than one
      // that clamps to the end.
      expect(ladderLevel(-3, -1), 1);
      expect(ladderLevel(999, 999), kLadderLevels);
    });
  });

  group('what a duel pays, itemised', () {
    LpBreakdown pay({
      bool won = true,
      int yourTier = 3,
      int theirTier = 3,
      int yourReps = 20,
      int theirReps = 10,
      bool clean = false,
    }) =>
        lpFor(
          won: won,
          yourTier: yourTier,
          theirTier: theirTier,
          yourReps: yourReps,
          theirReps: theirReps,
          clean: clean,
        );

    test('the parts add up to the total', () {
      final b = pay(theirTier: 6, clean: true);
      expect(b.total, b.result + b.tierGap + b.margin + b.form);
    });

    test('the base is what the card promised', () {
      // The screen before the round shows result + tierGap and nothing else,
      // because margin and form have not happened yet.
      final b = pay(theirTier: 6);
      expect(b.result + b.tierGap, lpForWin(3, 6));

      final lost = pay(won: false, theirTier: 0, yourReps: 5, theirReps: 30);
      expect(lost.result + lost.tierGap, lpForLoss(3, 0));
    });

    test('a loss never costs more than it risked', () {
      // Margin can only refund a loss. If it could deepen one, the card would
      // have understated the risk — which is the one direction that is not
      // allowed to be a surprise.
      for (var apart = 0; apart < 60; apart++) {
        final b = pay(won: false, yourReps: 0, theirReps: apart);
        expect(b.margin, greaterThanOrEqualTo(0),
            reason: '$apart reps behind cost extra');
        expect(b.total, greaterThanOrEqualTo(lpForLoss(3, 3)),
            reason: '$apart reps behind cost more than the card said');
      }
    });

    test('a narrow loss costs less than a thrashing', () {
      final close = pay(won: false, yourReps: 19, theirReps: 20);
      final thrashed = pay(won: false, yourReps: 2, theirReps: 40);
      expect(close.total, greaterThan(thrashed.total));
    });

    test('margin is capped, so a blowout cannot outweigh the ladder', () {
      final huge = pay(yourReps: 500, theirReps: 0);
      expect(huge.margin, kMarginCap);

      // Beating somebody six tiers up, narrowly, still beats thrashing a
      // lifter of your own rank. Otherwise the way to climb is to pick on
      // people.
      final upward = pay(theirTier: 9, yourReps: 11, theirReps: 10);
      expect(upward.total, greaterThan(huge.total));
    });

    test('depth pays the same either way', () {
      // A lifter who held their depth and still lost did the work.
      expect(pay(clean: true).form, greaterThan(pay().form));
      expect(pay(won: false, clean: true).form, pay(clean: true).form);
    });
  });
}
