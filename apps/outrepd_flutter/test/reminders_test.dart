/// When the daily reminder comes, and what it can truthfully say.
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reminders.dart';

void main() {
  const sevenPm = 19 * 60;

  test('a week of reminders at the chosen time', () {
    final slots = reminderSlots(
      now: DateTime(2026, 3, 10, 9),
      minutes: sevenPm,
      lastSession: DateTime(2026, 3, 8, 18),
      streak: 0,
      doneToday: 0,
      goal: 50,
    );
    expect(slots, hasLength(7));
    expect(slots.first.at, DateTime(2026, 3, 10, 19));
    expect(slots.last.at, DateTime(2026, 3, 16, 19));
  });

  test('not today once the goal is met', () {
    // The one reminder that would nag somebody who has done what they set
    // out to.
    final slots = reminderSlots(
      now: DateTime(2026, 3, 10, 9),
      minutes: sevenPm,
      lastSession: DateTime(2026, 3, 10, 7, 30),
      streak: 4,
      doneToday: 50,
      goal: 50,
    );
    expect(slots.first.at, DateTime(2026, 3, 11, 19));
    expect(slots, hasLength(6));
  });

  test('today, part done, says what is left; other days the whole goal', () {
    final slots = reminderSlots(
      now: DateTime(2026, 3, 10, 9),
      minutes: sevenPm,
      lastSession: DateTime(2026, 3, 10, 7, 30),
      streak: 4,
      doneToday: 20,
      goal: 50,
    );
    expect(slots, hasLength(7));
    expect(slots.first.at, DateTime(2026, 3, 10, 19));
    expect(slots.first.left, 30);
    expect(slots.skip(1).every((s) => s.left == 50), isTrue);
    // Trained today, so the streak is safe and not the thing to say.
    expect(slots.first.streak, 0);
  });

  test('not a time already gone', () {
    final slots = reminderSlots(
      now: DateTime(2026, 3, 10, 21),
      minutes: sevenPm,
      lastSession: null,
      streak: 0,
      doneToday: 0,
      goal: 50,
    );
    expect(slots.first.at, DateTime(2026, 3, 11, 19));
  });

  test('names the streak only when yesterday kept it alive', () {
    final kept = reminderSlots(
      now: DateTime(2026, 3, 10, 9),
      minutes: sevenPm,
      lastSession: DateTime(2026, 3, 9, 20),
      streak: 6,
      doneToday: 0,
      goal: 50,
    );
    expect(kept.first.streak, 6);
    // Tomorrow's cannot know: it depends on today.
    expect(kept.skip(1).every((s) => s.streak == 0), isTrue);

    final lapsed = reminderSlots(
      now: DateTime(2026, 3, 10, 9),
      minutes: sevenPm,
      lastSession: DateTime(2026, 3, 6, 20),
      streak: 6,
      doneToday: 0,
      goal: 50,
    );
    expect(lapsed.every((s) => s.streak == 0), isTrue,
        reason: 'a streak last fed four days ago is not "going"');
  });

  test('across the end of a month', () {
    final slots = reminderSlots(
      now: DateTime(2026, 1, 30, 8),
      minutes: 7 * 60 + 15,
      lastSession: null,
      streak: 0,
      doneToday: 0,
      goal: 50,
      days: 4,
    );
    // Today's 7:15 has gone by 8:00; the rest roll into February.
    expect(slots.map((s) => s.at), [
      DateTime(2026, 1, 31, 7, 15),
      DateTime(2026, 2, 1, 7, 15),
      DateTime(2026, 2, 2, 7, 15),
    ]);
  });
}
