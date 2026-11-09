/// Beat your past self: a six-week plan from the lifter's best minute (the
/// user's pick, 2026-11-09).
///
/// A goal above the starting best, three to five training days a week with a
/// few short sets each, and every Sunday a race against last week's you: the
/// lifter's own best minute of the week before, at the pace they really
/// lifted it. Free for everybody, and friendly — nothing here moves the
/// ladder. The account keeps the plan (supabase/plan.sql), so a new phone
/// carries on where the old one was.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backend/backend.dart';

/// How long a plan runs.
const kPlanWeeks = 6;

/// Sets on each training day.
const kPlanSetsPerDay = 3;

/// The race is on Sundays.
const kRaceWeekday = DateTime.sunday;

/// Days counted from 1970 by the calendar date here, not by hours: every day
/// is one, across a clock change.
int dayNumber(DateTime when) =>
    DateTime.utc(when.year, when.month, when.day).millisecondsSinceEpoch ~/
    Duration.millisecondsPerDay;

/// The local midnight a [dayNumber] starts at.
DateTime dayStart(int day) {
  final utc = DateTime.fromMillisecondsSinceEpoch(
    day * Duration.millisecondsPerDay,
    isUtc: true,
  );
  return DateTime(utc.year, utc.month, utc.day);
}

/// Monday to Sunday, as [DateTime.weekday] counts.
int weekdayOf(int day) => DateTime.fromMillisecondsSinceEpoch(
  day * Duration.millisecondsPerDay,
  isUtc: true,
).weekday;

/// The Monday of [day]'s week.
int mondayOf(int day) => day - (weekdayOf(day) - 1);

/// The three goals a plan offers from a starting best: steady, recommended,
/// hard — a quarter, a half and three quarters more, always at least a few
/// reps above where it starts.
List<int> planGoals(int best) => [
  math.min(300, math.max(best + 2, (best * 1.25).round())),
  math.min(300, math.max(best + 4, (best * 1.5).round())),
  math.min(300, math.max(best + 6, (best * 1.75).round())),
];

/// The weekdays a plan trains on, by how many a week.
Set<int> trainingWeekdays(int days) => switch (days) {
  3 => const {DateTime.monday, DateTime.wednesday, DateTime.friday},
  4 => const {DateTime.monday, DateTime.tuesday, DateTime.thursday, DateTime.friday},
  _ => const {
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
  },
};

@immutable
class TrainingPlan {
  const TrainingPlan({
    required this.start,
    required this.goal,
    required this.days,
    required this.began,
    this.sets = const {},
    this.races = const {},
  });

  /// The best minute it started from, and the one it is working towards.
  final int start;
  final int goal;

  /// Training days a week: three, four or five.
  final int days;

  /// The [dayNumber] it began on.
  final int began;

  /// Sets done on each day that had any, by [dayNumber].
  final Map<int, int> sets;

  /// The best race of each week, by week (1 to [kPlanWeeks]).
  final Map<int, int> races;

  /// Which week [day] is in: 1 for the week the plan began, Monday to
  /// Sunday; above [kPlanWeeks] once it is over.
  int weekOf(int day) => (mondayOf(day) - mondayOf(began)) ~/ 7 + 1;

  bool overOn(int day) => weekOf(day) > kPlanWeeks;

  /// Where the week is meant to be by its race: the start in week one, the
  /// goal in the last, evenly between.
  int targetFor(int week) {
    final w = week.clamp(1, kPlanWeeks);
    return start + ((goal - start) * (w - 1) / (kPlanWeeks - 1)).round();
  }

  /// Reps in each of the day's sets: a little under half the week's target,
  /// the share of a max that can be done three times over with rest.
  int repsPerSet(int week) => math.max(3, (targetFor(week) * 0.45).round());

  bool trainsOn(int day) => trainingWeekdays(days).contains(weekdayOf(day));

  bool racesOn(int day) => weekdayOf(day) == kRaceWeekday;

  int setsOn(int day) => sets[day] ?? 0;

  bool doneOn(int day) => setsOn(day) >= kPlanSetsPerDay;

  /// Training days done in [day]'s week, and how many there are in it from
  /// the day the plan began.
  ({int done, int of}) weekProgress(int day) {
    final monday = mondayOf(day);
    var done = 0, of = 0;
    for (var d = monday; d < monday + 7; d++) {
      if (d < began || !trainsOn(d)) continue;
      of++;
      if (doneOn(d)) done++;
    }
    return (done: done, of: of);
  }

  /// The race of [day]'s week, once raced.
  int? raceOf(int day) => races[weekOf(day)];

  /// The best minute so far: the start, then every race.
  int get bestSoFar => races.values.fold(start, math.max);

  TrainingPlan copyWith({Map<int, int>? sets, Map<int, int>? races}) =>
      TrainingPlan(
        start: start,
        goal: goal,
        days: days,
        began: began,
        sets: sets ?? this.sets,
        races: races ?? this.races,
      );

  Map<String, Object?> toJson() => {
    'start': start,
    'goal': goal,
    'days': days,
    'began': began,
    // The latest sixty days are all a plan needs, and all the account keeps.
    'sets': {
      for (final e
          in (sets.entries.toList()..sort((a, b) => b.key - a.key)).take(60))
        '${e.key}': e.value,
    },
    'races': {for (final e in races.entries) '${e.key}': e.value},
  };

  static TrainingPlan? fromJson(Object? json) {
    if (json is! Map) return null;
    int number(String key) => (json[key] as num?)?.toInt() ?? 0;
    Map<int, int> tally(Object? raw) => {
      if (raw is Map)
        for (final e in raw.entries)
          if (int.tryParse('${e.key}') case final k? when e.value is num)
            k: (e.value as num).toInt(),
    };
    final start = number('start'), goal = number('goal'), days = number('days');
    final began = number('began');
    if (start <= 0 || goal <= start || days < 3 || days > 5 || began <= 0) {
      return null;
    }
    return TrainingPlan(
      start: start,
      goal: goal,
      days: days,
      began: began,
      sets: tally(json['sets']),
      races: tally(json['races']),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is TrainingPlan &&
      jsonEncode(other.toJson()) == jsonEncode(toJson());

  @override
  int get hashCode => jsonEncode(toJson()).hashCode;
}

/// Last week's you: the minute this week's race is against.
@immutable
class PastSelf {
  const PastSelf({required this.reps, this.repTimes = const [], this.at});

  final int reps;

  /// When each rep landed; empty when only the count is known, and then the
  /// race spreads it evenly.
  final List<int> repTimes;

  /// When it was lifted, when known.
  final DateTime? at;
}

/// This lifter's plan, on this phone and on the account.
class PlanStore extends ChangeNotifier {
  PlanStore({DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;

  static const _key = 'trainingPlan';

  TrainingPlan? _plan;
  TrainingPlan? get plan => _plan;

  /// On a plan that is still running.
  bool get active => _plan != null && !_plan!.overOn(today);

  int get today => dayNumber(_clock());

  Future<void> load() async {
    final store = await SharedPreferences.getInstance();
    final raw = store.getString(_key);
    if (raw == null) return;
    try {
      _plan = TrainingPlan.fromJson(jsonDecode(raw));
    } on FormatException {
      _plan = null;
    }
    notifyListeners();
  }

  /// A plan begun today from [start] towards [goal].
  Future<void> begin({
    required int start,
    required int goal,
    required int days,
  }) async {
    _plan = TrainingPlan(start: start, goal: goal, days: days, began: today);
    _lastWeek = null;
    await _changed();
  }

  /// One of the day's sets, done with [reps]: it counts when it reached the
  /// day's number, and a training day counts it whichever day it is done.
  Future<bool> recordSet(int reps) async {
    final p = _plan;
    if (p == null || reps < p.repsPerSet(p.weekOf(today))) return false;
    _plan = p.copyWith(sets: {...p.sets, today: p.setsOn(today) + 1});
    await _changed();
    return true;
  }

  /// This week's race, run with [reps]: the best of the week is kept.
  Future<void> recordRace(int reps) async {
    final p = _plan;
    if (p == null) return;
    final week = p.weekOf(today);
    final held = p.races[week] ?? 0;
    if (reps <= held) return;
    _plan = p.copyWith(races: {...p.races, week: reps});
    await _changed();
  }

  /// Off the plan.
  Future<void> stop() async {
    _plan = null;
    _lastWeek = null;
    await _changed();
  }

  Future<void> _changed() async {
    notifyListeners();
    final store = await SharedPreferences.getInstance();
    if (_plan case final p?) {
      await store.setString(_key, jsonEncode(p.toJson()));
    } else {
      await store.remove(_key);
    }
    unawaited(_push());
  }

  Future<void> _push() async {
    if (!backend.available || backend.me == null) return;
    try {
      await backend.savePlan(_plan?.toJson());
    } on Object catch (error) {
      debugPrint('Could not keep the plan on the account: $error');
    }
  }

  /// On entering the app: the account's plan when this phone has none, else
  /// this phone's sent up.
  Future<void> sync() async {
    if (!backend.available || backend.me == null) return;
    try {
      if (_plan == null) {
        final held = TrainingPlan.fromJson(await backend.myPlan());
        if (held != null) {
          _plan = held;
          await _changed();
        }
        return;
      }
      await _push();
    } on Object catch (error) {
      debugPrint('Could not read the plan from the account: $error');
    }
  }

  /// Signed out, or about to take another account's: nothing here.
  Future<void> forget() async {
    _plan = null;
    _lastWeek = null;
    final store = await SharedPreferences.getInstance();
    await store.remove(_key);
    notifyListeners();
  }

  /// A log-in to an account that already existed: its plan, not this
  /// phone's.
  Future<void> adopt() async {
    await forget();
    await sync();
  }

  ({int monday, PastSelf self})? _lastWeek;

  /// A plan as a test wants it, without a day of training to get there.
  @visibleForTesting
  set debugPlan(TrainingPlan? value) {
    _plan = value;
    notifyListeners();
  }

  /// Last week's you as a test wants it, without a server to ask.
  @visibleForTesting
  set debugLastWeek(PastSelf value) =>
      _lastWeek = (monday: mondayOf(today), self: value);

  /// Last week's you for this week's race: the best whole minute lifted the
  /// week before, or failing that the best before this week, or failing
  /// that the plan's starting best with no pace to it.
  Future<PastSelf> lastWeek() async {
    final p = _plan;
    final monday = mondayOf(today);
    if (_lastWeek case final held? when held.monday == monday) return held.self;
    var self = PastSelf(reps: p?.start ?? 0);
    if (backend.available && backend.me != null) {
      try {
        final thisWeek = dayStart(monday);
        final found =
            await backend.myBestMinute(
              dayStart(monday - 7),
              thisWeek,
            ) ??
            await backend.myBestMinute(DateTime(2020), thisWeek);
        if (found != null) {
          self = PastSelf(
            reps: found.reps,
            repTimes: found.repTimes,
            at: found.at,
          );
        }
      } on Object catch (error) {
        debugPrint('Could not find last week\'s minute: $error');
      }
    }
    _lastWeek = (monday: monday, self: self);
    return self;
  }
}

/// The one the app uses; a test puts in one with its own clock.
PlanStore trainingPlan = PlanStore();
