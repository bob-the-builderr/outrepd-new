/// Titles worth wearing, and a streak that understands rest days.
///
/// Frames come from rank, which means only the strong ever get one. These are
/// the other half: things a beginner can earn in their first week, and things
/// that say something about *how* someone trains rather than how much they
/// lift. Every one of them is visible to other people — a reward nobody else
/// can see does not motivate anyone.
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// What a title asks of you. Kept as plain numbers so the condition can be
/// checked against a profile without each title carrying its own code.
enum TitleKind {
  matches,
  wins,
  reps,
  streakDays,
  crewWeeks,
  cleanSet,
  giantSlayer,
  comeback,
}

class EarnedTitle {
  const EarnedTitle({
    required this.id,
    required this.title,
    required this.hint,
    required this.kind,
    required this.threshold,
    required this.icon,
    this.colour,
  });

  final String id;

  /// What it says beside your name.
  final String title;

  /// What you have to do, in words a lifter would use.
  final String hint;

  final TitleKind kind;
  final int threshold;
  final IconData icon;

  /// Rare titles carry their own colour so they stand out in a list of names.
  final Color? colour;
}

/// Written to be worth wanting. A title people would rather not wear is the
/// same as no title at all.
const kTitles = <EarnedTitle>[
  EarnedTitle(
    id: 'first_blood',
    title: 'First Blood',
    hint: 'Finish your first match',
    kind: TitleKind.matches,
    threshold: 1,
    icon: Icons.flag,
  ),
  EarnedTitle(
    id: 'no_days_off',
    title: 'No Days Off',
    hint: 'Train seven days running',
    kind: TitleKind.streakDays,
    threshold: 7,
    icon: Icons.local_fire_department,
  ),
  EarnedTitle(
    id: 'unbroken',
    title: 'Unbroken',
    hint: 'Keep a thirty day streak alive',
    kind: TitleKind.streakDays,
    threshold: 30,
    icon: Icons.whatshot,
    colour: Color(0xFFFF8C00),
  ),
  EarnedTitle(
    id: 'the_machine',
    title: 'The Machine',
    hint: 'A thousand counted reps',
    kind: TitleKind.reps,
    threshold: 1000,
    icon: Icons.settings,
  ),
  EarnedTitle(
    id: 'ten_thousand',
    title: 'Ten Thousand',
    hint: 'Ten thousand counted reps',
    kind: TitleKind.reps,
    threshold: 10000,
    icon: Icons.all_inclusive,
    colour: Color(0xFF00E5FF),
  ),
  EarnedTitle(
    id: 'century',
    title: 'Century',
    hint: 'A hundred matches',
    kind: TitleKind.matches,
    threshold: 100,
    icon: Icons.emoji_events,
    colour: Color(0xFFFFD700),
  ),
  EarnedTitle(
    id: 'giant_slayer',
    title: 'Giant Slayer',
    hint: 'Beat someone two tiers above you',
    kind: TitleKind.giantSlayer,
    threshold: 1,
    icon: Icons.bolt,
    colour: Color(0xFF9B59B6),
  ),
  EarnedTitle(
    id: 'comeback',
    title: 'Comeback',
    hint: 'Win straight after three losses',
    kind: TitleKind.comeback,
    threshold: 1,
    icon: Icons.replay,
  ),
  EarnedTitle(
    id: 'clean_hands',
    title: 'Clean Hands',
    hint: 'A full set with every rep counted',
    kind: TitleKind.cleanSet,
    threshold: 1,
    icon: Icons.verified,
    colour: Color(0xFF22C55E),
  ),
  EarnedTitle(
    id: 'backbone',
    title: 'Backbone',
    hint: 'Top your crew four weeks running',
    kind: TitleKind.crewWeeks,
    threshold: 4,
    icon: Icons.shield,
  ),
  EarnedTitle(
    id: 'on_a_roll',
    title: 'On a Roll',
    hint: 'Win ten in a row',
    kind: TitleKind.wins,
    threshold: 10,
    icon: Icons.trending_up,
  ),
];

/// A streak that counts training days but does not punish rest.
///
/// Resting is part of lifting. An app that wipes a month's streak because
/// someone took a Sunday off is teaching a bad habit and, worse, is the moment
/// most people stop opening it — once the number is gone there is nothing left
/// to protect. So a couple of rest days a week are simply allowed.
const kRestDaysPerWeek = 2;

class Rewards extends ChangeNotifier {
  int streak = 0;
  int bestStreak = 0;

  /// Days since the last session, used to decide whether a rest was taken or a
  /// streak was dropped.
  DateTime? lastSession;

  int restUsedThisWeek = 0;

  /// Titles unlocked, and the one being worn.
  final Set<String> earned = {};
  String? wearing;

  EarnedTitle? get worn {
    if (wearing == null) return null;
    for (final title in kTitles) {
      if (title.id == wearing) return title;
    }
    return null;
  }

  bool has(String id) => earned.contains(id);

  Future<void> load() async {
    final store = await SharedPreferences.getInstance();
    streak = store.getInt('streak') ?? 0;
    bestStreak = store.getInt('bestStreak') ?? 0;
    restUsedThisWeek = store.getInt('restUsed') ?? 0;
    wearing = store.getString('wearingTitle');

    final stamp = store.getInt('lastSession');
    lastSession = stamp == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(stamp);

    earned
      ..clear()
      ..addAll(store.getStringList('earnedTitles') ?? const []);
  }

  /// Titles are a statement about what you have already done, so they are
  /// checked against the record on every launch rather than only at the moment
  /// a session ends. Otherwise someone who qualified before this existed would
  /// never be given what they had plainly earned.
  Future<List<EarnedTitle>> syncWithProfile({
    required int matches,
    required int wins,
    required int reps,
  }) async {
    final unlocked = _check(matches: matches, wins: wins, reps: reps);
    if (unlocked.isNotEmpty) await _save();
    return unlocked;
  }

  /// Called when a session finishes. Returns any titles unlocked by it, so the
  /// UI can celebrate rather than leave someone to find it later.
  Future<List<EarnedTitle>> recordSession({
    required int matches,
    required int wins,
    required int reps,
  }) async {
    final today = DateTime.now();
    final last = lastSession;

    if (last == null) {
      streak = 1;
    } else {
      final gap = DateTime(today.year, today.month, today.day)
          .difference(DateTime(last.year, last.month, last.day))
          .inDays;

      if (gap == 0) {
        // Already counted today. Training twice does not count twice.
      } else if (gap == 1) {
        streak++;
      } else if (gap - 1 <= kRestDaysPerWeek - restUsedThisWeek) {
        // Rest days cover the gap, so the streak carries on.
        restUsedThisWeek += gap - 1;
        streak++;
      } else {
        streak = 1;
        restUsedThisWeek = 0;
      }
    }

    lastSession = today;
    if (streak > bestStreak) bestStreak = streak;

    final unlocked = _check(matches: matches, wins: wins, reps: reps);
    await _save();
    notifyListeners();
    return unlocked;
  }

  List<EarnedTitle> _check({
    required int matches,
    required int wins,
    required int reps,
  }) {
    final unlocked = <EarnedTitle>[];

    for (final title in kTitles) {
      if (earned.contains(title.id)) continue;

      final reached = switch (title.kind) {
        TitleKind.matches => matches >= title.threshold,
        TitleKind.wins => wins >= title.threshold,
        TitleKind.reps => reps >= title.threshold,
        TitleKind.streakDays => streak >= title.threshold,
        // The rest need a match or a set to report them, which the engine and
        // the crew screen will do once those are wired to real results.
        _ => false,
      };

      if (reached) {
        earned.add(title.id);
        unlocked.add(title);
      }
    }

    // Wearing the first thing you earn beats an empty space beside your name.
    if (wearing == null && earned.isNotEmpty) wearing = earned.first;

    return unlocked;
  }

  /// Unlocks a title that only a match or a set can judge.
  Future<void> award(String id) async {
    if (!earned.add(id)) return;
    wearing ??= id;
    await _save();
    notifyListeners();
  }

  Future<void> wear(String? id) async {
    wearing = id;
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final store = await SharedPreferences.getInstance();
    await store.setInt('streak', streak);
    await store.setInt('bestStreak', bestStreak);
    await store.setInt('restUsed', restUsedThisWeek);
    await store.setStringList('earnedTitles', earned.toList());

    if (wearing == null) {
      await store.remove('wearingTitle');
    } else {
      await store.setString('wearingTitle', wearing!);
    }

    final last = lastSession;
    if (last != null) {
      await store.setInt('lastSession', last.millisecondsSinceEpoch);
    }
  }
}

final rewards = Rewards();
