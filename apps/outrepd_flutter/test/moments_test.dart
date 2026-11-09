/// Moments (lib/moments.dart): what a set brings, and when last month's
/// recap is due.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/moments.dart';

void main() {
  setUp(() {
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
  });

  test('a very first set is no personal best: there was nothing to beat', () {
    expect(momentsOf(reps: 12, bestBefore: 0, totalBefore: 0), isEmpty);
  });

  test('beating the best is a personal best; equalling it is not', () {
    final out = momentsOf(reps: 27, bestBefore: 24, totalBefore: 500);
    expect(out.single, isA<PersonalBest>());
    expect((out.single as PersonalBest).before, 24);
    expect(momentsOf(reps: 24, bestBefore: 24, totalBefore: 500), isEmpty);
  });

  test('crossing a milestone, once, the highest one crossed', () {
    final out = momentsOf(reps: 30, bestBefore: 40, totalBefore: 980);
    expect(out.single, isA<Milestone>());
    expect((out.single as Milestone).mark, 1000);
    expect((out.single as Milestone).next, 5000);
    final big = momentsOf(reps: 200, bestBefore: 300, totalBefore: 4900);
    expect((big.single as Milestone).mark, 5000);
  });

  test('a set can be both, the best first', () {
    final out = momentsOf(reps: 30, bestBefore: 25, totalBefore: 90);
    expect(out.first, isA<PersonalBest>());
    expect(out.last, isA<Milestone>());
  });

  test('the month: its longest run, its top day, how far the best rose', () {
    final recap = MonthRecap(
      month: DateTime(2026, 11),
      days: [0, 10, 20, 30, 0, 5, 60, 0, 0, 0],
      numbers: const MonthNumbers(reps: 125, best: 27, bestBefore: 24, wins: 3, losses: 1),
    );
    expect(recap.longestRun, 3);
    expect(recap.topDay, 7);
    expect(recap.daysTrained, 5);
    expect(recap.bestRise, 3);
    expect(recap.reps, 125);
  });

  test('last month is due in the first week, once it had push-ups, until seen', () async {
    int reps(DateTime d) => d.month == 11 && d.day == 3 ? 40 : 0;
    final early = RecapStore(clock: () => DateTime(2026, 12, 2), repsOn: reps);
    await early.load();
    expect(early.due, isTrue);
    await early.markSeen();
    expect(early.due, isFalse);

    final late = RecapStore(clock: () => DateTime(2026, 12, 9), repsOn: reps);
    expect(late.due, isFalse);

    final empty = RecapStore(clock: () => DateTime(2026, 12, 2), repsOn: (_) => 0);
    expect(empty.due, isFalse);
  });

  test('January\'s recap is December\'s, a year back', () {
    final store = RecapStore(clock: () => DateTime(2027, 1, 3));
    expect(store.lastMonth, DateTime(2026, 12));
  });
}
