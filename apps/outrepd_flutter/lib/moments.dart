/// Moments (the user's picks, 2026-11-09): a new personal best and a
/// milestone of total push-ups each get a screen of their own after the set
/// that made them, and every month gets a recap.
///
/// The best and the milestones are noticed here as each set is counted
/// (career.dart, _countReps); the match screen shows whatever its own set
/// brought. The month is read from the account (moments.sql), with this
/// phone's day log for the bar of each day.
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backend/backend.dart';

/// Totals worth stopping for.
const kMilestones = [100, 1000, 5000, 10000, 25000, 50000, 100000];

/// The next milestone above [total], or null past the last.
int? nextMilestone(int total) {
  for (final m in kMilestones) {
    if (m > total) return m;
  }
  return null;
}

@immutable
sealed class Moment {
  const Moment();
}

/// A set beat the best there was. Not the very first set: there was no best
/// to beat, and every first set would be a celebration of nothing.
class PersonalBest extends Moment {
  const PersonalBest({required this.reps, required this.before});

  final int reps;
  final int before;
}

/// The total crossed one of [kMilestones].
class Milestone extends Moment {
  const Milestone({required this.mark, required this.total});

  final int mark;
  final int total;

  int? get next => nextMilestone(total);
}

/// What a set of [reps] brought, from the best and the total before it: a
/// new best, and the highest milestone it crossed (one, however many).
List<Moment> momentsOf({
  required int reps,
  required int bestBefore,
  required int totalBefore,
}) {
  final out = <Moment>[];
  if (bestBefore > 0 && reps > bestBefore) {
    out.add(PersonalBest(reps: reps, before: bestBefore));
  }
  final totalAfter = totalBefore + reps;
  for (final m in kMilestones.reversed) {
    if (totalBefore < m && totalAfter >= m) {
      out.add(Milestone(mark: m, total: totalAfter));
      break;
    }
  }
  return out;
}

/// The moments waiting to be shown, oldest first.
class Moments {
  Moments._();

  static final instance = Moments._();

  final List<Moment> _pending = [];

  /// The one to show now.
  Moment? get next => _pending.isEmpty ? null : _pending.first;

  void notice({
    required int reps,
    required int bestBefore,
    required int totalBefore,
  }) => _pending.addAll(
    momentsOf(reps: reps, bestBefore: bestBefore, totalBefore: totalBefore),
  );

  /// The one shown has been seen.
  void done() {
    if (_pending.isNotEmpty) _pending.removeAt(0);
  }

  /// A match begins: what earlier sets brought is not this one's.
  void clear() => _pending.clear();
}

/// One month, as the recap shows it.
@immutable
class MonthRecap {
  const MonthRecap({required this.month, required this.days, this.numbers});

  /// Its first day.
  final DateTime month;

  /// Push-ups on each of its days, the 1st first, from this phone's log.
  final List<int> days;

  /// The account's own numbers for it, when the server could be asked.
  final MonthNumbers? numbers;

  int get reps => numbers?.reps ?? days.fold(0, (a, b) => a + b);

  int get daysTrained => days.where((d) => d > 0).length;

  /// The most days in a row with push-ups in them.
  int get longestRun {
    var best = 0, run = 0;
    for (final d in days) {
      run = d > 0 ? run + 1 : 0;
      if (run > best) best = run;
    }
    return best;
  }

  /// The month's best whole minute, when known.
  int? get best => (numbers?.best ?? 0) > 0 ? numbers!.best : null;

  /// How far the best rose above everything before the month; 0 when it did
  /// not, or there was nothing before.
  int get bestRise {
    final b = best, before = numbers?.bestBefore ?? 0;
    return b != null && before > 0 && b > before ? b - before : 0;
  }

  /// The day with the most push-ups (1-based), or null for an empty month.
  int? get topDay {
    var top = 0, at = -1;
    for (var i = 0; i < days.length; i++) {
      if (days[i] > top) {
        top = days[i];
        at = i;
      }
    }
    return at < 0 ? null : at + 1;
  }
}

/// The recap of last month: due for its first week, until it is opened.
class RecapStore extends ChangeNotifier {
  RecapStore({DateTime Function()? clock, int Function(DateTime day)? repsOn})
    : _clock = clock ?? DateTime.now,
      _repsOn = repsOn;

  final DateTime Function() _clock;

  /// This phone's push-ups on a day; career.dart sets it at startup.
  int Function(DateTime day)? _repsOn;
  set repsOn(int Function(DateTime day) read) {
    _repsOn = read;
    notifyListeners();
  }

  static const _key = 'recapSeen';
  String? _seen;

  /// The first day of last month.
  DateTime get lastMonth {
    final now = _clock();
    return DateTime(now.year, now.month - 1);
  }

  static String _name(DateTime month) =>
      '${month.year}-${month.month.toString().padLeft(2, '0')}';

  List<int> _daysOf(DateTime month) {
    final read = _repsOn;
    final count = DateTime(month.year, month.month + 1, 0).day;
    return [
      for (var d = 1; d <= count; d++)
        read == null ? 0 : read(DateTime(month.year, month.month, d)),
    ];
  }

  /// In the first week of a month, for a last month with push-ups in it,
  /// until the recap has been opened.
  bool get due =>
      _clock().day <= 7 &&
      _seen != _name(lastMonth) &&
      _daysOf(lastMonth).any((d) => d > 0);

  Future<void> load() async {
    final store = await SharedPreferences.getInstance();
    _seen = store.getString(_key);
    notifyListeners();
  }

  /// Last month, with the account's numbers when it can be asked.
  Future<MonthRecap> recap() async {
    final month = lastMonth;
    MonthNumbers? numbers;
    if (backend.available && backend.me != null) {
      try {
        numbers = await backend.myMonthRecap(
          month,
          DateTime(month.year, month.month + 1),
        );
      } on Object catch (error) {
        debugPrint('Could not read last month: $error');
      }
    }
    return MonthRecap(month: month, days: _daysOf(month), numbers: numbers);
  }

  Future<void> markSeen() async {
    _seen = _name(lastMonth);
    notifyListeners();
    final store = await SharedPreferences.getInstance();
    await store.setString(_key, _seen!);
  }
}

/// The one the app uses; a test puts in one with its own clock.
RecapStore recaps = RecapStore();
