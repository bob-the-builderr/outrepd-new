/// The week's last call: six hours before the weekly board closes, at
/// Monday 00:00 UTC (week_start in seasons.sql).
library;

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reminders.dart';

void main() {
  test('mid-week, it is this Sunday evening', () {
    expect(
      weekClosingReminderAt(DateTime.utc(2026, 11, 11, 10)),
      DateTime.utc(2026, 11, 15, 18),
    );
  });

  test('once this week\'s has gone by, it is next week\'s', () {
    expect(
      weekClosingReminderAt(DateTime.utc(2026, 11, 15, 19)),
      DateTime.utc(2026, 11, 22, 18),
    );
  });

  test('just after the board closed, it is the new week\'s', () {
    expect(
      weekClosingReminderAt(DateTime.utc(2026, 11, 16, 0, 30)),
      DateTime.utc(2026, 11, 22, 18),
    );
  });
}
