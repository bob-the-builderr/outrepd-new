/// Titles that only a set or a session can judge — a clean rep, an early
/// start, a perfect week — and the two, [giant_slayer] and friends, that only
/// a duel's own history can report through [Rewards.award].
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/rewards.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Rewards rewards;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    rewards = Rewards();
    await rewards.load();
  });

  group('the exercise-count titles are gone', () {
    test('nothing in the list can no longer be earned', () {
      // This app counts one exercise. A title asking for five, fifteen or
      // forty different ones was a promise from the old multi-exercise design
      // that nobody could ever collect on now.
      for (final id in ['all_rounder', 'explorer', 'encyclopedia']) {
        expect(
          kTitles.any((t) => t.id == id),
          isFalse,
          reason: '$id is still listed, and still unreachable',
        );
      }
    });
  });

  group('clean sets', () {
    test('a session with no clean set does not move the tally', () async {
      await rewards.recordSession(matches: 1, wins: 0, reps: 20, clean: false);
      expect(rewards.cleanSets, 0);
      expect(rewards.has('clean_hands'), isFalse);
    });

    test('one clean set unlocks Clean Hands', () async {
      final unlocked = await rewards.recordSession(
        matches: 1,
        wins: 0,
        reps: 20,
        clean: true,
      );
      expect(rewards.cleanSets, 1);
      expect(rewards.has('clean_hands'), isTrue);
      expect(unlocked.map((t) => t.id), contains('clean_hands'));
      // Spotless asks for ten — one is not ten.
      expect(rewards.has('spotless'), isFalse);
    });

    test('ten clean sets unlocks Spotless too', () async {
      for (var i = 0; i < 10; i++) {
        await rewards.recordSession(
          matches: i + 1,
          wins: 0,
          reps: 20,
          clean: true,
          at: DateTime(2026, 1, i + 1, 12),
        );
      }
      expect(rewards.cleanSets, 10);
      expect(rewards.has('clean_hands'), isTrue);
      expect(rewards.has('spotless'), isTrue);
      expect(rewards.has('textbook'), isFalse);
    });
  });

  group('the hours', () {
    test('a session at midday counts towards neither', () async {
      await rewards.recordSession(
        matches: 1,
        wins: 0,
        reps: 20,
        at: DateTime(2026, 1, 1, 12),
      );
      expect(rewards.earlySessions, 0);
      expect(rewards.lateSessions, 0);
    });

    test('ten sessions before seven unlocks Early Shift', () async {
      for (var i = 0; i < 10; i++) {
        await rewards.recordSession(
          matches: i + 1,
          wins: 0,
          reps: 20,
          at: DateTime(2026, 1, i + 1, 6, 30),
        );
      }
      expect(rewards.earlySessions, 10);
      expect(rewards.has('early_bird'), isTrue);
      expect(rewards.has('sunrise_club'), isFalse);
    });

    test('ten sessions after ten at night unlocks Night Shift', () async {
      for (var i = 0; i < 10; i++) {
        await rewards.recordSession(
          matches: i + 1,
          wins: 0,
          reps: 20,
          at: DateTime(2026, 1, i + 1, 23),
        );
      }
      expect(rewards.lateSessions, 10);
      expect(rewards.has('night_owl'), isTrue);
    });

    test('seven in the morning itself is neither early nor late', () async {
      // The hint says "before seven" and "after ten" — the boundary hours
      // themselves belong to the ordinary middle of the day.
      await rewards.recordSession(
        matches: 1,
        wins: 0,
        reps: 20,
        at: DateTime(2026, 1, 1, 7),
      );
      await rewards.recordSession(
        matches: 2,
        wins: 0,
        reps: 20,
        at: DateTime(2026, 1, 2, 22),
      );
      expect(rewards.earlySessions, 0);
      expect(rewards.lateSessions, 1);
    });
  });

  group('the perfect week', () {
    test('seven consecutive days with no rest unlocks Perfect Week', () async {
      for (var i = 0; i < 7; i++) {
        await rewards.recordSession(
          matches: i + 1,
          wins: 0,
          reps: 20,
          at: DateTime(2026, 1, i + 1, 12),
        );
      }
      expect(rewards.perfectDayRun, 7);
      expect(rewards.perfectWeeksCount, 1);
      expect(rewards.has('perfect_week'), isTrue);
      expect(rewards.has('perfect_month'), isFalse);
    });

    test('a single rest day breaks it, even though the forgiving streak '
        'survives', () async {
      await rewards.recordSession(
        matches: 1,
        wins: 0,
        reps: 20,
        at: DateTime(2026, 1, 1, 12),
      );
      // A day skipped entirely — kRestDaysPerWeek forgives it for `streak`,
      // but a perfect week has no rest days to forgive.
      await rewards.recordSession(
        matches: 2,
        wins: 0,
        reps: 20,
        at: DateTime(2026, 1, 3, 12),
      );

      expect(rewards.streak, 2, reason: 'the forgiving streak should survive');
      expect(rewards.perfectDayRun, 1, reason: 'the perfect run should not');
    });

    test('four straight perfect weeks unlocks Perfect Month', () async {
      for (var i = 0; i < 28; i++) {
        await rewards.recordSession(
          matches: i + 1,
          wins: 0,
          reps: 20,
          at: DateTime(2026, 1, 1).add(Duration(days: i, hours: 12)),
        );
      }
      expect(rewards.perfectWeeksCount, 4);
      expect(rewards.has('perfect_month'), isTrue);
    });
  });

  group('award', () {
    test('unlocks exactly the id given, once', () async {
      await rewards.award('giant_slayer');
      expect(rewards.has('giant_slayer'), isTrue);
      expect(rewards.has('comeback'), isFalse);

      // Calling it again is a no-op, not a second unlock.
      final before = Set.of(rewards.earned);
      await rewards.award('giant_slayer');
      expect(rewards.earned, before);
    });

    test('the first title earned is worn automatically', () async {
      expect(rewards.wearing, isNull);
      await rewards.award('nemesis');
      expect(rewards.wearing, 'nemesis');
    });
  });

  group('surviving a restart', () {
    test('every new tally comes back exactly as it was', () async {
      await rewards.recordSession(
        matches: 1,
        wins: 0,
        reps: 20,
        clean: true,
        at: DateTime(2026, 1, 1, 6),
      );
      await rewards.award('giant_slayer');

      final reloaded = Rewards();
      await reloaded.load();

      expect(reloaded.cleanSets, rewards.cleanSets);
      expect(reloaded.earlySessions, rewards.earlySessions);
      expect(reloaded.lateSessions, rewards.lateSessions);
      expect(reloaded.perfectDayRun, rewards.perfectDayRun);
      expect(reloaded.perfectWeeksCount, rewards.perfectWeeksCount);
      expect(reloaded.has('giant_slayer'), isTrue);
      expect(reloaded.has('clean_hands'), isTrue);
    });
  });
}
