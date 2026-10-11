/// What the app hands the home-screen widgets: words already written in the
/// reader's language, and numbers the widget only has to draw.
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/career.dart';
import 'package:outrepd/home_widgets.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await settings.load();
    await Career.instance.load();
  });
  tearDown(() => settings.dailyGoal = 50);

  test('today, the goal and the rank, ready to draw', () {
    settings.dailyGoal = 50;
    final shown = HomeWidgets.contents(lookupL(const Locale('en')));
    final done = Career.instance.repsToday;
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');

    expect(shown['goal_day'], '${now.year}-${two(now.month)}-${two(now.day)}');
    expect(shown['goal_count'], '$done');
    expect(int.parse(shown['goal_percent']!), inInclusiveRange(0, 100));
    expect(shown['goal_of_fresh'], 'of 50 today');
    expect(shown['rank'], isNotEmpty);
  });

  test('in the reader\'s language', () {
    settings.dailyGoal = 25;
    final shown = HomeWidgets.contents(lookupL(const Locale('de')));
    expect(shown['goal_of_fresh'], 'von 25 heute');
  });
}
