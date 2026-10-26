/// A whole duel, against the real server.
///
/// The ladder arithmetic is checked case by case elsewhere. This asks the
/// other question, the one only a live database can answer: does a duel
/// actually settle — two accounts, two sets, one call — and does it move both
/// ranks the way the app says it will?
///
/// It signs in twice anonymously and leaves rows behind. That is the point:
/// they are the evidence it ran. The names it uses all begin with `t_` so they
/// are easy to find and clear out.
///
///   flutter test test/duel_server_test.dart ///     --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
library;

import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/ranking.dart';

import 'server_harness.dart';

void main() {
  final configured = serverConfigured;
  final tag = Random().nextInt(0xFFFFF).toRadixString(16);

  test('two lifters, two sets, one duel', () async {
    if (!configured) {
      // ignore: avoid_print
      print('no server configured — skipping');
      return;
    }

    final a = await Lifter.signUp('t_a$tag');
    final b = await Lifter.signUp('t_b$tag');

    // Reps count when the set is stored, whether or not anybody ever races it.
    final bTimes = [
      4200,
      9100,
      14600,
      21300,
      28800,
      35100,
      41900,
      48200,
      54600,
      59100,
      59800,
    ];
    final bSet = await b.uploadSet(reps: 11, repTimes: bTimes);
    expect((await b.profile())['total_reps'], 11);

    final aSet = await a.uploadSet(reps: 18);
    expect((await a.profile())['best_set'], 18);

    // A finds B's set: near enough in level, and never faced.
    final found = await a.findOpponent();
    expect(found, isNotNull, reason: 'no opponent found for a fresh account');
    expect(found!['set_id'], bSet);
    expect(found['reps'], 11, reason: 'the VS card needs their count');
    // The point of the column: the opponent's bar has to move at their own
    // pace, not their total spread evenly. That only works if these timings
    // survive the round trip through the table and back out of the function.
    expect(
      found['rep_times'],
      bTimes,
      reason: 'rep_times did not round-trip through find_opponent_set',
    );

    final settled = await a.settle(aSet, bSet);
    expect(settled['won'], isTrue, reason: '18 beats 11');

    // This was the placement for both, so nothing is paid, and both are
    // placed at Iron V whatever the result — marked with the five every check
    // reads as placed.
    expect(settled['lp_delta'], 0);

    final aAfter = await a.profile();
    final bAfter = await b.profile();
    expect(aAfter['placements_done'], 5);
    expect(bAfter['placements_done'], 5);
    for (final placed in [aAfter, bAfter]) {
      expect(placed['tier_idx'], Rank.start.tierIdx);
      expect(placed['div_idx'], Rank.start.divIdx);
    }
    expect(aAfter['placement_wins'], 1);
    expect(bAfter['placement_wins'], 0);

    // A placement is a real duel, so the record counts it.
    expect(aAfter['wins'], 1);
    expect(bAfter['losses'], 1);
    expect(aAfter['lp'], 0);

    // The whole point of returning these from settle_duel: the app copies
    // them straight off the response rather than recomputing win/loss and
    // placements locally, so they have to already match the row they were
    // just read back from.
    expect(settled['wins'], aAfter['wins']);
    expect(settled['losses'], aAfter['losses']);
    expect(settled['win_streak'], aAfter['win_streak']);
    expect(settled['best_streak'], aAfter['best_streak']);
    expect(settled['placements_done'], aAfter['placements_done']);
    expect(settled['placement_wins'], aAfter['placement_wins']);

    // A set is faced once. Replaying the same pair would otherwise be free.
    await expectLater(
      a.settle(aSet, bSet),
      throwsA(isA<HttpException>()),
      reason: 'the same sets settled twice',
    );
  }, timeout: const Timeout(Duration(minutes: 5)));

  test(
    'once placed, the server pays what the app would',
    () async {
      if (!configured) return;

      final a = await Lifter.signUp('t_p$tag');
      final b = await Lifter.signUp('t_q$tag');

      // One duel each to clear the placement.
      await a.settle(await a.uploadSet(reps: 20), await b.uploadSet(reps: 10));

      final placedA = await a.profile();
      final placedB = await b.profile();
      expect(placedA['placements_done'], 5);
      expect(placedB['placements_done'], 5);

      // Won or lost, the placement puts everybody at Iron V.
      final expected = placementRank(1);
      expect(placedA['tier_idx'], expected.tierIdx);
      expect(placedA['div_idx'], expected.divIdx);

      // Now a ranked duel, and the LP must be exactly what the app would show.
      final mine = await a.uploadSet(reps: 25, depth: 0.95);
      final theirs = await b.uploadSet(reps: 12, depth: 0.5);
      final settled = await a.settle(mine, theirs);

      final ours = lpFor(won: true, yourReps: 25, theirReps: 12);
      expect(
        settled['lp_delta'],
        ours,
        reason: 'the server paid something the app would not have shown',
      );

      final after = applyLp(
        Rank(
          tierIdx: placedA['tier_idx'] as int,
          divIdx: placedA['div_idx'] as int,
          lp: placedA['lp'] as int,
        ),
        ours,
        floorTierIdx: placedA['peak_tier_idx'] as int,
      );
      expect(settled['tier_idx'], after.after.tierIdx);
      expect(settled['div_idx'], after.after.divIdx);
      expect(settled['lp'], after.after.lp);
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );

  test('nobody can write their own rank', () async {
    if (!configured) return;

    final a = await Lifter.signUp('t_c$tag');

    // The whole ladder rests on this failing.
    await expectLater(
      send('PATCH', '/rest/v1/profiles?id=eq.${a.id}', {
        'lp': 99,
        'tier_idx': 8,
      }, a.token),
      throwsA(isA<HttpException>()),
      reason: 'a client wrote its own rank',
    );

    final after = await a.profile();
    expect(after['lp'], 0);
    expect(after['tier_idx'], 0);
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('giving up loses even with more reps', () async {
    if (!configured) return;

    final a = await Lifter.signUp('t_gu$tag');
    final b = await Lifter.signUp('t_gv$tag');

    // 25 would beat 10 on the count alone — the whole point of the test.
    final theirSet = await b.uploadSet(reps: 10);
    final mySet = await a.uploadSet(reps: 25, gaveUp: true);
    final settled = await a.settle(mySet, theirSet);

    expect(settled['won'], isFalse, reason: 'a gave-up set still won');
    expect(
      settled['lp_delta'],
      lessThanOrEqualTo(0),
      reason: 'a loss paid a gain',
    );
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('being given up on wins even with fewer reps', () async {
    if (!configured) return;

    final a = await Lifter.signUp('t_gw$tag');
    final b = await Lifter.signUp('t_gx$tag');

    final theirSet = await b.uploadSet(reps: 25, gaveUp: true);
    final mySet = await a.uploadSet(reps: 10);
    final settled = await a.settle(mySet, theirSet);

    expect(
      settled['won'],
      isTrue,
      reason: 'the account that gave up still won',
    );
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('a rematch finds exactly the set reserved for it', () async {
    if (!configured) return;

    final a = await Lifter.signUp('t_r$tag');
    final b = await Lifter.signUp('t_s$tag');
    final stranger = await Lifter.signUp('t_t$tag');

    // The open pool never sees this — it is reserved, not offered.
    final reserved = await a.uploadSet(reps: 17, challengeTarget: b.id);
    expect(
      await b.findOpponent(),
      isNull,
      reason: 'a reserved set was handed out by the open pool',
    );

    // Reserved for b, so nobody else can find it as theirs.
    expect(await stranger.findTargetedOpponent(a.id), isNull);

    final found = await b.findTargetedOpponent(a.id);
    expect(found, isNotNull, reason: 'the reserved set was never found');
    expect(found!['set_id'], reserved);
    expect(found['reps'], 17);

    // Facing it moves nothing — a rematch is the same story a second time,
    // and find_opponent_set already refuses to pair two people who have
    // already duelled, so a rematch that paid LP would be the one way round
    // that rule.
    final mine = await b.uploadSet(reps: 22);
    final settled = await b.settle(mine, reserved, ranked: false);
    expect(settled['lp_delta'], 0);

    // Faced once, same as any other set.
    expect(await b.findTargetedOpponent(a.id), isNull);
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('a block still holds over a rematch challenge', () async {
    if (!configured) return;

    final a = await Lifter.signUp('t_u$tag');
    final b = await Lifter.signUp('t_v$tag');

    await a.uploadSet(reps: 15, challengeTarget: b.id);
    await send('POST', '/rest/v1/rpc/block_lifter', {
      'their_id': a.id,
    }, b.token);

    expect(
      await b.findTargetedOpponent(a.id),
      isNull,
      reason: 'a block did not hold over an existing challenge',
    );
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('a friend duel moves nothing', () async {
    if (!configured) return;

    final a = await Lifter.signUp('t_f$tag');
    final b = await Lifter.signUp('t_g$tag');

    final before = await a.profile();
    final mine = await a.uploadSet(reps: 30);
    final theirs = await b.uploadSet(reps: 5);
    final settled = await a.settle(mine, theirs, ranked: false);

    expect(settled['won'], isTrue);
    expect(settled['lp_delta'], 0);

    final after = await a.profile();
    expect(
      after['placements_done'],
      before['placements_done'],
      reason: 'a friend duel counted towards placements',
    );
    expect(
      after['wins'],
      before['wins'],
      reason: 'a friend duel counted towards the record',
    );
    // The reps were done, so they count.
    expect(after['total_reps'], (before['total_reps'] as int) + 30);

    // Nothing moved, so settle_duel's own copy of the record has to say so
    // too — the app applies these numbers unconditionally on every duel, so
    // a friend room returning stale or wrong ones would quietly corrupt the
    // record the very next time somebody played one.
    expect(settled['wins'], before['wins']);
    expect(settled['losses'], before['losses']);
    expect(settled['placements_done'], before['placements_done']);
    expect(settled['placement_wins'], before['placement_wins']);
  }, timeout: const Timeout(Duration(minutes: 5)));
}
