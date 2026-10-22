/// Generates the cases the server's ladder must agree with.
///
/// The app and the server each compute LP: the app to show it, the server to
/// apply it. Two implementations of one rule drift, and nothing in a running
/// system would notice — a lifter would simply be shown one number and given
/// another, and would have no way to tell which was wrong.
///
/// So the Dart implementation writes down what it does, across a grid that
/// covers every branch, and `supabase/ladder_test.sql` replays the same grid
/// through the SQL and compares. This test regenerates the file; running it is
/// how the vectors stay current when the arithmetic changes.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/ranking.dart';

const _vectors = 'supabase/ladder_vectors.json';

void main() {
  test('the ladder writes down what it does', () {
    // Every rep pair in the grid, crossed with both values of [won] — lp_for
    // only has the one branch left where they can disagree (walking out
    // while still ahead), and this is what makes sure the grid actually
    // covers it rather than only ever pairing `won` with the reps that agree
    // with it.
    final pay = <Map<String, Object?>>[
      for (final won in [true, false])
        for (var yourReps = 0; yourReps <= 40; yourReps += 2)
          for (var theirReps = 0; theirReps <= 40; theirReps += 4)
            {
              'won': won,
              'your_reps': yourReps,
              'their_reps': theirReps,
              'total': lpFor(won: won, yourReps: yourReps, theirReps: theirReps),
            },
    ];

    // Weighed by the two ranks: level, a little apart, and further apart
    // than the weighing reaches, both ways, won and lost.
    final weighed = <Map<String, Object?>>[
      for (final won in [true, false])
        for (var yourReps = 0; yourReps <= 40; yourReps += 8)
          for (var theirReps = 0; theirReps <= 40; theirReps += 8)
            for (final yourLevel in [1, 12, 30])
              for (final apart in [-8, -5, -2, -1, 0, 1, 3, 5, 9])
                if (yourLevel + apart >= 1 && yourLevel + apart <= kLadderLevels)
                  {
                    'won': won,
                    'your_reps': yourReps,
                    'their_reps': theirReps,
                    'your_level': yourLevel,
                    'their_level': yourLevel + apart,
                    'total': lpFor(
                      won: won,
                      yourReps: yourReps,
                      theirReps: theirReps,
                      yourLevel: yourLevel,
                      theirLevel: yourLevel + apart,
                    ),
                  },
    ];

    final applied = <Map<String, Object?>>[];
    for (final from in [
      (0, 0, 0),
      (3, 2, 40),
      (3, 4, 95),
      (kTopTier, 4, 99),
      (2, 0, 5),
      (5, 3, 50),
    ]) {
      for (final delta in [-200, -60, -18, -1, 0, 1, 23, 99, 140, 250]) {
        for (final floor in [0, 3, kTopTier]) {
          final change = applyLp(
            Rank(tierIdx: from.$1, divIdx: from.$2, lp: from.$3),
            delta,
            floorTierIdx: floor,
          );
          applied.add({
            'from_tier': from.$1,
            'from_div': from.$2,
            'from_lp': from.$3,
            'delta': delta,
            'floor_tier': floor,
            'tier_idx': change.after.tierIdx,
            'div_idx': change.after.divIdx,
            'lp': change.after.lp,
          });
        }
      }
    }

    final levels = <Map<String, Object?>>[
      for (var tier = 0; tier <= kTopTier; tier++)
        for (var div = 0; div <= kTopDivision; div++)
          {'tier_idx': tier, 'div_idx': div, 'level': ladderLevel(tier, div)},
    ];

    final placements = <Map<String, Object?>>[
      for (var wins = 0; wins <= 5; wins++)
        () {
          final r = placementRank(wins);
          return {
            'wins': wins,
            'tier_idx': r.tierIdx,
            'div_idx': r.divIdx,
            'lp': r.lp,
          };
        }(),
    ];

    File(_vectors).writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert({'generated_by': 'flutter test test/ladder_vectors_test.dart', 'lp_for': pay, 'lp_for_levels': weighed, 'apply_lp': applied, 'ladder_level': levels, 'placement_rank': placements})}\n',
    );

    // A grid that misses a branch proves nothing, so the shape is asserted
    // rather than assumed.
    expect(pay.length, greaterThan(200));
    expect(weighed.length, greaterThan(500));
    // Weighed, a duel never pays more than half again the gap, nor less than
    // half of it, and level ranks pay the gap exactly.
    for (final row in weighed) {
      final gap =
          ((row['your_reps']! as int) - (row['their_reps']! as int)).abs();
      final paid = (row['total']! as int).abs();
      expect(paid, inInclusiveRange((gap * 5 + 5) ~/ 10, (gap * 15 + 5) ~/ 10),
          reason: 'weighed past the reach: $row');
      if (row['your_level'] == row['their_level']) {
        expect(paid, gap, reason: 'level ranks paid other than the gap: $row');
      }
    }
    expect(applied.length, greaterThan(150));
    expect(levels.length, kLadderLevels);
    expect(placements.length, 6);

    // The property the server must preserve, stated here so the vectors
    // cannot be regenerated from a broken implementation without this failing.
    for (final row in pay) {
      final gap =
          ((row['your_reps']! as int) - (row['their_reps']! as int)).abs();
      expect(
        row['total'],
        (row['won']! as bool) ? gap : -gap,
        reason: 'a row is not the signed rep gap: $row',
      );
    }
    for (final row in applied) {
      expect(row['lp'], inInclusiveRange(0, 99));
      expect(row['tier_idx'], inInclusiveRange(0, kTopTier));
      expect(row['div_idx'], inInclusiveRange(0, kTopDivision));
      if ((row['delta']! as int) < 0) {
        // The floor holds, and where the grid invents a rank already below its
        // own floor — which a real account cannot be, since the floor is the
        // peak it once held — falling no further is the right answer.
        final floor = row['floor_tier']! as int;
        final from = row['from_tier']! as int;
        expect(
          row['tier_idx'],
          greaterThanOrEqualTo(floor < from ? floor : from),
          reason: 'fell through the floor: $row',
        );
      }
    }
  });
}
