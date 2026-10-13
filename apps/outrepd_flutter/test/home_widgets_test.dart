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
import 'package:outrepd/tier_badge.dart';

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

  testWidgets('the medium widget\'s badge is a PNG for every tier',
      (tester) async {
    // The widgets cannot run the painter, so this picture is all of the
    // badge they ever show: every tier, and the unranked outline, has to
    // come out as a real image at the size asked for.
    for (final tier in <int?>[null, 0, 1, 2, 3, 4, 5, 6]) {
      final png = (await tester.runAsync(
        () => tierBadgePng(tierIdx: tier, size: 88, pixelRatio: 3),
      ))!;
      expect(png.sublist(0, 8), [137, 80, 78, 71, 13, 10, 26, 10]);
      // The header's width and height, big-endian, at bytes 16 and 20.
      int word(int at) =>
          png[at] << 24 | png[at + 1] << 16 | png[at + 2] << 8 | png[at + 3];
      expect(word(16), 264, reason: 'tier $tier');
      expect(word(20), 264, reason: 'tier $tier');
    }
  });
}
