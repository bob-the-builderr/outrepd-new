/// What a finished duel does to the account.
///
/// The app used to have no memory at all: a duel ended, the screen popped, and
/// every number was exactly where it had been. These tests exist so that can
/// never quietly become true again — each one names a thing a result has to
/// move, and fails if it stops moving.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/career.dart';
import 'package:outrepd/data.dart';
import 'package:outrepd/ranking.dart';
import 'package:outrepd/rewards.dart';
import 'package:outrepd/xp.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final career = Career.instance;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await career.startFresh();
    rewards
      ..streak = 0
      ..bestStreak = 0
      ..lastSession = null
      ..cleanSets = 0
      ..earlySessions = 0
      ..lateSessions = 0
      ..perfectDayRun = 0
      ..perfectWeeksCount = 0
      ..earned.clear();
  });

  /// Gets the account past placements and onto the ladder.
  Future<void> place({int wins = 3}) async {
    for (var i = 0; i < kPlacementDuels; i++) {
      await career.recordDuel(
        yourReps: i < wins ? 20 : 5,
        theirReps: 10,
        opponent: 'placer',
        opponentTier: 2,
      );
    }
  }

  group('a duel is written down', () {
    test('a win moves the rank, the record and the totals', () async {
      await place();
      final before = career.rank;
      final wins = demoProfile.wins;
      final reps = demoProfile.totalReps;
      final history = matchHistory.length;

      final outcome = await career.recordDuel(
        yourReps: 22,
        theirReps: 15,
        opponent: 'benchgod',
        opponentTier: demoProfile.tierIdx,
      );

      expect(outcome.won, isTrue);
      expect(demoProfile.wins, wins + 1);
      expect(demoProfile.totalReps, reps + 22);
      expect(matchHistory.length, history + 1);
      expect(matchHistory.first.opponent, 'benchgod');

      // The rank actually moved, and by what the result was worth.
      expect(outcome.rank, isNotNull);
      expect(outcome.rank!.lpDelta, greaterThan(0));
      expect(career.rank, isNot(before));
    });

    test('a loss costs LP and breaks the win streak', () async {
      // A lost placement, so the streak below starts from nothing.
      await place(wins: 0);
      // Placements are real duels and their losses are on the record too, so
      // this counts from where they left it rather than from zero.
      final losses = demoProfile.losses;
      await career.recordDuel(
        yourReps: 30,
        theirReps: 10,
        opponent: 'a',
        opponentTier: demoProfile.tierIdx,
      );
      expect(demoProfile.winStreak, 1);

      final outcome = await career.recordDuel(
        yourReps: 8,
        theirReps: 25,
        opponent: 'b',
        opponentTier: demoProfile.tierIdx,
      );

      expect(outcome.won, isFalse);
      expect(outcome.rank!.lpDelta, lessThan(0));
      expect(demoProfile.winStreak, 0);
      expect(demoProfile.losses, losses + 1);
    });

    test('the reps count even when the duel is lost', () async {
      await place();
      final reps = demoProfile.totalReps;

      await career.recordDuel(
        yourReps: 14,
        theirReps: 40,
        opponent: 'c',
        opponentTier: demoProfile.tierIdx,
      );

      // Losing does not un-do the push-ups. Somebody who trained hard and lost
      // has still trained hard, and an app that says otherwise is wrong about
      // the thing it is for.
      expect(demoProfile.totalReps, reps + 14);
      expect(career.repsToday, greaterThanOrEqualTo(14));
    });

    test('a best set is a best set', () async {
      await place();
      await career.recordDuel(
        yourReps: 12,
        theirReps: 30,
        opponent: 'd',
        opponentTier: demoProfile.tierIdx,
      );
      final best = demoProfile.bestSet;

      final outcome = await career.recordDuel(
        yourReps: best + 5,
        theirReps: 99,
        opponent: 'e',
        opponentTier: demoProfile.tierIdx,
      );

      expect(outcome.newBest, isTrue);
      expect(demoProfile.bestSet, best + 5);
    });

    test('a forfeit is a win worth a flat amount', () async {
      await place();
      // Behind on the count, and still the winner: they left.
      final outcome = await career.recordDuel(
        yourReps: 12,
        theirReps: 14,
        opponent: 'kickk',
        opponentTier: demoProfile.tierIdx,
        forfeit: true,
      );

      expect(outcome.won, isTrue);
      expect(outcome.rank!.lpDelta, kForfeitLp);
    });
  });

  group('the placement', () {
    test('one duel places an account, and pays no LP', () async {
      expect(demoProfile.isRanked, isFalse);

      final outcome = await career.recordDuel(
        yourReps: 20,
        theirReps: 5,
        opponent: 'x',
        opponentTier: 2,
      );

      expect(outcome.rank, isNull, reason: 'the placement moved a rank');
      expect(outcome.placementsFinished, isTrue);
      expect(demoProfile.isRanked, isTrue);
    });

    test('winning or losing it, everybody starts at Iron V', () async {
      await place(wins: 1);
      final won = career.rank;

      await career.startFresh();
      await place(wins: 0);
      final lost = career.rank;

      expect(won, Rank.start);
      expect(lost, Rank.start);
    });

    test('the placed tier becomes the floor', () async {
      await place(wins: 1);
      expect(demoProfile.peakTierIdx, demoProfile.tierIdx);
    });

    test('it still counts as a match and as reps', () async {
      await place(wins: 1);
      expect(demoProfile.totalMatches, kPlacementDuels);
      expect(demoProfile.totalReps, greaterThan(0));
      expect(matchHistory.length, kPlacementDuels);
    });
  });

  group('practice', () {
    test('counts reps and never touches the rank', () async {
      await place();
      final rank = career.rank;
      final matches = demoProfile.totalMatches;
      final reps = demoProfile.totalReps;

      await career.recordPractice(18);

      expect(demoProfile.totalReps, reps + 18);
      // A ladder that can be climbed alone in an empty room measures
      // willingness to grind, not strength against anybody.
      expect(career.rank, rank);
      expect(demoProfile.totalMatches, matches);
      expect(matchHistory.length, kPlacementDuels);
    });

    test('a set of nothing is not a day of training', () async {
      await career.recordPractice(0);
      expect(rewards.streak, 0);
      expect(career.repsToday, 0);
    });
  });

  group('experience', () {
    test('a rep is one, practice included', () async {
      await career.recordPractice(18);
      expect(demoProfile.xp, 18);
    });

    test('a match is its reps and twenty, won or lost', () async {
      await career.recordDuel(
        yourReps: 14,
        theirReps: 20,
        opponent: 'iron_mike',
        opponentTier: 2,
      );
      expect(demoProfile.xp, 14 + kXpPerMatch);
      await career.recordDuel(
        yourReps: 9,
        theirReps: 3,
        opponent: 'iron_mike',
        opponentTier: 2,
        ranked: false,
      );
      expect(demoProfile.xp, 14 + 9 + 2 * kXpPerMatch);
    });

    test('starting again starts it from nothing', () async {
      await career.recordPractice(30);
      await career.startFresh();
      expect(demoProfile.xp, 0);
    });
  });

  group('the week', () {
    test('always has seven days, rest days included', () async {
      expect(career.weekReps.length, 7);
      await career.recordPractice(25);

      final week = career.weekReps;
      expect(week.length, 7);
      expect(week.last, 25, reason: 'today is the last bar');
      expect(week.take(6), everyElement(0));
    });

    test('two sets on one day add up', () async {
      await career.recordPractice(10);
      await career.recordPractice(7);
      expect(career.weekReps.last, 17);
    });
  });

  group('it survives a restart', () {
    test('rank, record, history and days all come back', () async {
      await place(wins: 4);
      await career.recordDuel(
        yourReps: 21,
        theirReps: 11,
        opponent: 'iron_mike',
        opponentTier: 5,
      );

      final rank = career.rank;
      final wins = demoProfile.wins;
      final reps = demoProfile.totalReps;
      final best = demoProfile.bestSet;
      final xp = demoProfile.xp;
      final history = matchHistory.length;
      final today = career.repsToday;

      // Scramble everything in memory, then read it back off disk — which is
      // exactly what a relaunch does.
      demoProfile
        ..tierIdx = 0
        ..divIdx = 0
        ..lp = 0
        ..wins = 0
        ..totalReps = 0
        ..bestSet = 0
        ..xp = 0;
      matchHistory.clear();
      await career.load();

      expect(career.rank, rank);
      expect(demoProfile.wins, wins);
      expect(demoProfile.totalReps, reps);
      expect(demoProfile.bestSet, best);
      expect(demoProfile.xp, xp);
      expect(matchHistory.length, history);
      expect(matchHistory.first.opponent, 'iron_mike');
      expect(career.repsToday, today);
    });

    test('a history entry remembers when, not how long ago', () async {
      await place();
      await career.recordDuel(
        yourReps: 10,
        theirReps: 9,
        opponent: 'z',
        opponentTier: 2,
      );

      final stored = matchHistory.first;
      expect(stored.daysAgo, 0);
      // Within the hour, which is the most common case there is: the duel
      // that just finished.
      expect(stored.hoursAgo, 0);

      // The old shape stored the number 1 for "yesterday", which stayed 1
      // forever. Round-tripping has to preserve the instant.
      final json = stored.toJson();
      final back = MatchRecord.fromJson(json)!;
      expect(back.at, stored.at);
    });

    test('rubbish on disk is dropped, not fatal', () async {
      SharedPreferences.setMockInitialValues({
        'career.profile': 'not json',
        'career.history': '{"also": "not a list"}',
        'career.days': '[]',
      });

      // A file somebody else wrote, half a write, a hand edit — none of it is
      // worth refusing to launch over.
      await career.load();
      expect(career.weekReps.length, 7);
    });
  });

  group('LP is exactly the gap in reps', () {
    test('a win pays exactly what it won by', () async {
      await place();

      final outcome = await career.recordDuel(
        yourReps: 20,
        theirReps: 10,
        opponent: 'above',
        opponentTier: 6,
      );

      expect(outcome.rank!.lpDelta, 10);
    });

    test('a loss costs exactly what it lost by, whatever the opponent\'s tier',
        () async {
      await place();

      // Tier 0 here on purpose: the old formula paid more for beating tiers
      // above you and less for losing to tiers below — this loss is against
      // the softest possible opponent, where that would have cost the most.
      final outcome = await career.recordDuel(
        yourReps: 2,
        theirReps: 40,
        opponent: 'below',
        opponentTier: 0,
      );

      expect(outcome.rank!.lpDelta, -38);
    });
  });

  group('the floor holds across a career', () {
    test('a losing streak cannot cost a tier that was earned', () async {
      await place(wins: 5);
      final floor = demoProfile.peakTierIdx;

      for (var i = 0; i < 40; i++) {
        await career.recordDuel(
          yourReps: 1,
          theirReps: 50,
          opponent: 'nemesis',
          opponentTier: demoProfile.tierIdx,
        );
      }

      expect(demoProfile.tierIdx, floor);
      expect(demoProfile.lp, 0);
    });
  });

  group('the two rules the user settled', () {
    test('giving up is a loss even when you were ahead', () async {
      await place(wins: 3);
      final before = demoProfile.wins;

      final outcome = await career.recordDuel(
        yourReps: 30,
        theirReps: 4,
        opponent: 'someone',
        opponentTier: demoProfile.tierIdx,
        surrendered: true,
      );

      // Otherwise the way to protect a rank is to quit while ahead of somebody
      // who is still going.
      expect(outcome.won, isFalse);
      expect(demoProfile.wins, before);
      expect(outcome.rank!.lpDelta, lessThan(0));
    });

    test('quitting early costs more than fighting to a close finish',
        () async {
      await place(wins: 3);
      // Walking out records whatever was counted before the quit — here,
      // nothing yet — rather than the near-tie a few more seconds might have
      // reached. No separate rule has to take a refund away: fewer of your
      // own reps on the board already costs more on its own.
      final quit = await career.recordDuel(
        yourReps: 0,
        theirReps: 20,
        opponent: 'a',
        opponentTier: demoProfile.tierIdx,
        surrendered: true,
      );

      await career.startFresh();
      await place(wins: 3);
      final fought = await career.recordDuel(
        yourReps: 19,
        theirReps: 20,
        opponent: 'b',
        opponentTier: demoProfile.tierIdx,
      );

      expect(quit.rank!.lpDelta, lessThan(fought.rank!.lpDelta));
    });

    test('a friend match moves nothing but the reps', () async {
      await place(wins: 3);
      final rank = (demoProfile.tierIdx, demoProfile.divIdx, demoProfile.lp);
      final wins = demoProfile.wins;
      final losses = demoProfile.losses;
      final reps = demoProfile.totalReps;

      final outcome = await career.recordDuel(
        yourReps: 22,
        theirReps: 9,
        opponent: 'friend',
        opponentTier: 8,
        ranked: false,
      );

      // A rank people can arrange between themselves is not a rank — and the
      // record the rank is built on follows the same line.
      expect(outcome.rank, isNull);
      expect((demoProfile.tierIdx, demoProfile.divIdx, demoProfile.lp), rank);
      expect(demoProfile.wins, wins);
      expect(demoProfile.losses, losses);

      // The reps were done, so they count.
      expect(demoProfile.totalReps, reps + 22);
      expect(matchHistory.first.opponent, 'friend');
      expect(matchHistory.first.lpChange, 0);
    });
  });

  group('the titles only a duel\'s own history can judge', () {
    // Placements are real duels and count as real history, so left as they
    // are they leak into what these tests are trying to isolate: its own
    // fixed opponentTier is 2 tiers above where an account starts (giving
    // every placement win a free Giant Slayer), and the wins:3 pattern ends
    // on two losses (which a further loss can complete into Comeback's own
    // three). Clearing both after placing is what actually isolates "what
    // this one duel did" from "what placing itself already did".
    Future<void> placeCleanly() async {
      await place(wins: 3);
      rewards.earned.clear();
      matchHistory.clear();
    }

    test('beating someone two tiers up unlocks Giant Slayer', () async {
      await placeCleanly();
      await career.recordDuel(
        yourReps: 25,
        theirReps: 10,
        opponent: 'giant',
        opponentTier: demoProfile.tierIdx + 2,
      );
      expect(rewards.has('giant_slayer'), isTrue);
    });

    test('beating someone one tier up does not', () async {
      await placeCleanly();
      await career.recordDuel(
        yourReps: 25,
        theirReps: 10,
        opponent: 'a_bit_higher',
        opponentTier: demoProfile.tierIdx + 1,
      );
      expect(rewards.has('giant_slayer'), isFalse);
    });

    test('losing to someone above you is not a Giant Slayer moment',
        () async {
      await placeCleanly();
      await career.recordDuel(
        yourReps: 5,
        theirReps: 25,
        opponent: 'giant',
        opponentTier: demoProfile.tierIdx + 2,
      );
      expect(rewards.has('giant_slayer'), isFalse);
    });

    test('a win straight after three losses unlocks Comeback', () async {
      await placeCleanly();
      for (var i = 0; i < 3; i++) {
        await career.recordDuel(
          yourReps: 5,
          theirReps: 25,
          opponent: 'a',
          opponentTier: demoProfile.tierIdx,
        );
      }
      expect(rewards.has('comeback'), isFalse, reason: 'three losses, no win yet');

      await career.recordDuel(
        yourReps: 25,
        theirReps: 5,
        opponent: 'b',
        opponentTier: demoProfile.tierIdx,
      );
      expect(rewards.has('comeback'), isTrue);
    });

    test('a win after only two losses does not unlock Comeback', () async {
      await placeCleanly();
      for (var i = 0; i < 2; i++) {
        await career.recordDuel(
          yourReps: 5,
          theirReps: 25,
          opponent: 'a',
          opponentTier: demoProfile.tierIdx,
        );
      }
      await career.recordDuel(
        yourReps: 25,
        theirReps: 5,
        opponent: 'b',
        opponentTier: demoProfile.tierIdx,
      );
      expect(rewards.has('comeback'), isFalse);
    });

    test('beating the same lifter five times unlocks Nemesis', () async {
      await placeCleanly();
      for (var i = 0; i < 5; i++) {
        await career.recordDuel(
          yourReps: 25,
          theirReps: 10,
          opponent: 'rival',
          opponentTier: demoProfile.tierIdx,
        );
      }
      expect(rewards.has('nemesis'), isTrue);
    });

    test('four wins against the same lifter is not Nemesis yet', () async {
      await placeCleanly();
      for (var i = 0; i < 4; i++) {
        await career.recordDuel(
          yourReps: 25,
          theirReps: 10,
          opponent: 'rival',
          opponentTier: demoProfile.tierIdx,
        );
      }
      expect(rewards.has('nemesis'), isFalse);
    });

    test('five wins spread across different lifters is not Nemesis', () async {
      await placeCleanly();
      for (var i = 0; i < 5; i++) {
        await career.recordDuel(
          yourReps: 25,
          theirReps: 10,
          opponent: 'rival_$i',
          opponentTier: demoProfile.tierIdx,
        );
      }
      expect(rewards.has('nemesis'), isFalse);
    });

    test('a clean set threads through to the clean-set tally', () async {
      await placeCleanly();
      await career.recordDuel(
        yourReps: 25,
        theirReps: 10,
        opponent: 'a',
        opponentTier: demoProfile.tierIdx,
        clean: true,
      );
      expect(rewards.has('clean_hands'), isTrue);
    });
  });

  group('a duel the server already settled', () {
    test('copies its numbers rather than recomputing them', () async {
      await place(wins: 5);
      final reps = demoProfile.totalReps;

      final settled = SettledDuel(
        duelId: 'd1',
        won: true,
        lpDelta: 27,
        tierIdx: demoProfile.tierIdx + 1,
        divIdx: 0,
        lp: 4,
        wins: demoProfile.wins + 1,
        losses: demoProfile.losses,
        winStreak: demoProfile.winStreak + 1,
        bestStreak: demoProfile.bestStreak + 1,
        placementsDone: demoProfile.placementsDone,
        placementWins: demoProfile.placementWins,
      );

      final outcome = await career.recordSettledDuel(
        settled: settled,
        yourReps: 25,
        theirReps: 12,
        opponent: 'someone',
        opponentTier: demoProfile.tierIdx,
        ranked: true,
      );

      // Every one of these came off the response, not off local arithmetic.
      expect(demoProfile.tierIdx, settled.tierIdx);
      expect(demoProfile.divIdx, settled.divIdx);
      expect(demoProfile.lp, settled.lp);
      expect(demoProfile.wins, settled.wins);
      expect(demoProfile.winStreak, settled.winStreak);
      expect(demoProfile.bestStreak, settled.bestStreak);

      expect(outcome.won, isTrue);
      expect(outcome.rank, isNotNull);
      expect(outcome.rank!.lpDelta, 27);
      expect(outcome.rank!.after.tierIdx, settled.tierIdx);

      // Reps still count locally, same as every other path.
      expect(demoProfile.totalReps, reps + 25);
    });

    test('reports no rank change on the placement itself', () async {
      // The placement sets a rank rather than moving one: recordSettledDuel
      // reports no RankChange for it, matching what recordDuel does for a
      // locally-computed placement. The server marks the account placed with
      // five.
      final settled = SettledDuel(
        duelId: 'd2',
        won: true,
        lpDelta: 0,
        tierIdx: 0,
        divIdx: 0,
        lp: 0,
        wins: 1,
        losses: 0,
        winStreak: 1,
        bestStreak: 1,
        placementsDone: 5,
        placementWins: 1,
      );

      final outcome = await career.recordSettledDuel(
        settled: settled,
        yourReps: 20,
        theirReps: 10,
        opponent: 'placer',
        opponentTier: 0,
        ranked: true,
      );

      expect(outcome.rank, isNull);
      expect(outcome.placementsFinished, isTrue);
      expect(demoProfile.isRanked, isTrue);
      expect(career.rank, Rank.start);
    });

    test(
      'a friend duel gets no RankChange even though it was settled',
      () async {
        await place(wins: 5);
        final rank = (demoProfile.tierIdx, demoProfile.divIdx, demoProfile.lp);

        // What settle_duel returns for a friend room: paid nothing, and every
        // record field unchanged from what it already was.
        final settled = SettledDuel(
          duelId: 'd3',
          won: true,
          lpDelta: 0,
          tierIdx: demoProfile.tierIdx,
          divIdx: demoProfile.divIdx,
          lp: demoProfile.lp,
          wins: demoProfile.wins,
          losses: demoProfile.losses,
          winStreak: demoProfile.winStreak,
          bestStreak: demoProfile.bestStreak,
          placementsDone: demoProfile.placementsDone,
          placementWins: demoProfile.placementWins,
        );

        final outcome = await career.recordSettledDuel(
          settled: settled,
          yourReps: 22,
          theirReps: 9,
          opponent: 'friend',
          opponentTier: demoProfile.tierIdx,
          ranked: false,
        );

        expect(outcome.rank, isNull);
        expect(outcome.placementsFinished, isFalse);
        expect((demoProfile.tierIdx, demoProfile.divIdx, demoProfile.lp), rank);
      },
    );

    test('a best set is still a best set', () async {
      await place(wins: 5);
      await career.recordDuel(
        yourReps: 12,
        theirReps: 30,
        opponent: 'd',
        opponentTier: demoProfile.tierIdx,
      );
      final best = demoProfile.bestSet;

      final settled = SettledDuel(
        duelId: 'd4',
        won: true,
        lpDelta: 20,
        tierIdx: demoProfile.tierIdx,
        divIdx: demoProfile.divIdx,
        lp: demoProfile.lp + 20,
        wins: demoProfile.wins + 1,
        losses: demoProfile.losses,
        winStreak: demoProfile.winStreak + 1,
        bestStreak: demoProfile.bestStreak + 1,
        placementsDone: demoProfile.placementsDone,
        placementWins: demoProfile.placementWins,
      );

      final outcome = await career.recordSettledDuel(
        settled: settled,
        yourReps: best + 5,
        theirReps: 3,
        opponent: 'e',
        opponentTier: demoProfile.tierIdx,
        ranked: true,
      );

      // Read against the count from before _countReps moved it — read after,
      // this would always be false.
      expect(outcome.newBest, isTrue);
      expect(demoProfile.bestSet, best + 5);
    });
  });

  group('applyServerProfile', () {
    test('overwrites the ladder identity local storage restored', () {
      // What local storage would have handed back: numbers from a duel this
      // device played and remembers, but not the account's real ones — the
      // gap a fresh install or a second phone would otherwise fall into.
      demoProfile
        ..tierIdx = 1
        ..divIdx = 4
        ..lp = 10
        ..peakTierIdx = 1
        ..wins = 2
        ..losses = 1
        ..winStreak = 1
        ..bestStreak = 1
        ..placementsDone = 5
        ..placementWins = 3
        ..totalReps = 40
        ..bestSet = 12;

      applyServerProfile(const RemoteProfile(
        id: 'server-id',
        username: 'someone',
        tierIdx: 4,
        divIdx: 2,
        lp: 55,
        friendCode: '918273',
        peakTierIdx: 5,
        wins: 30,
        losses: 12,
        winStreak: 4,
        bestStreak: 9,
        placementsDone: 5,
        placementWins: 4,
        totalReps: 980,
        bestSet: 41,
        country: 'EG',
      ));

      expect(demoProfile.tierIdx, 4);
      expect(demoProfile.divIdx, 2);
      expect(demoProfile.lp, 55);
      expect(demoProfile.peakTierIdx, 5);
      expect(demoProfile.wins, 30);
      expect(demoProfile.losses, 12);
      expect(demoProfile.winStreak, 4);
      expect(demoProfile.bestStreak, 9);
      expect(demoProfile.placementsDone, 5);
      expect(demoProfile.placementWins, 4);
      expect(demoProfile.totalReps, 980);
      expect(demoProfile.bestSet, 41);
      expect(demoProfile.country, 'EG');
      expect(demoProfile.friendCode, '918273');
    });

    test('a phone that would not say the country keeps the one it had', () {
      demoProfile.country = 'US';
      applyServerProfile(RemoteProfile(
        id: 'server-id',
        username: demoProfile.username,
        tierIdx: demoProfile.tierIdx,
        divIdx: demoProfile.divIdx,
        lp: demoProfile.lp,
        friendCode: demoProfile.friendCode,
      ));
      expect(demoProfile.country, 'US');
    });
  });
}
