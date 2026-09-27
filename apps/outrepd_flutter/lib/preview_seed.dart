/// A lived-in history for the web preview and store screenshots.
///
/// Only in a build made with `--dart-define=SEED_PREVIEW=true`, and only
/// when there is no server: it writes into local storage, in the format the
/// app already saves, before anything reads it. A real build never carries
/// the flag, so nobody's own history is ever touched by this.
library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'data.dart';

const kSeedPreview = bool.fromEnvironment('SEED_PREVIEW');

Future<void> seedPreviewHistory() async {
  final store = await SharedPreferences.getInstance();
  // Once. A preview somebody has played with keeps what they did.
  if (store.containsKey('career.days')) return;

  final now = DateTime.now();
  String day(int back) {
    final d = now.subtract(Duration(days: back));
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  // Oldest first, ending today: six days trained, one rest day.
  const week = [42, 0, 55, 38, 61, 47, 58];
  await store.setString(
    'career.days',
    jsonEncode({
      for (var i = 0; i < week.length; i++)
        if (week[i] > 0) day(week.length - 1 - i): week[i],
    }),
  );

  const duels = [
    ('iron_mike', true, 24, 19, 6),
    ('squat_queen', false, 21, 23, -3),
    ('benchgod', true, 22, 14, 9),
    ('cardio_hater', true, 19, 17, 3),
    ('delt_destroyer', true, 23, 16, 8),
  ];
  await store.setString(
    'career.history',
    jsonEncode([
      for (final (i, (opponent, won, you, them, lp)) in duels.indexed)
        MatchRecord(
          won: won,
          userReps: you,
          opponentReps: them,
          opponent: opponent,
          lpChange: lp,
          at: now.subtract(Duration(hours: 5 + i * 20)),
        ).toJson(),
    ]),
  );

  await store.setInt('streak', 5);
  await store.setInt('bestStreak', 12);
  await store.setInt('lastSession', now.millisecondsSinceEpoch);
}
