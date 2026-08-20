import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/data.dart';
import 'package:outrepd/settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('settings survive a restart', () async {
    final before = AppSettings();
    await before.load();

    before.update(() {
      before.themeMode = ThemeMode.light;
      before.weightUnit = WeightUnit.lb;
      before.heightUnit = HeightUnit.ft;
      before.visibility = ProfileVisibility.friends;
      before.sound = false;
      before.notifyWeeklySummary = true;
    });

    // A second instance stands in for the next launch of the app.
    final after = AppSettings();
    await after.load();

    expect(after.themeMode, ThemeMode.light);
    expect(after.weightUnit, WeightUnit.lb);
    expect(after.heightUnit, HeightUnit.ft);
    expect(after.visibility, ProfileVisibility.friends);
    expect(after.sound, isFalse);
    expect(after.notifyWeeklySummary, isTrue);
  });

  test('untouched settings keep their defaults', () async {
    final fresh = AppSettings();
    await fresh.load();

    expect(fresh.themeMode, ThemeMode.dark);
    expect(fresh.weightUnit, WeightUnit.kg);
    expect(fresh.allowFriendRequests, isTrue);
  });

  test('body measurements survive a restart', () async {
    demoProfile
      ..heightCm = 181
      ..weightKg = 88
      ..age = 27;
    await saveProfileStats();

    // Wipe the in-memory values so only a successful read can restore them.
    demoProfile
      ..heightCm = 0
      ..weightKg = 0
      ..age = 0;
    await loadProfileStats();

    expect(demoProfile.heightCm, 181);
    expect(demoProfile.weightKg, 88);
    expect(demoProfile.age, 27);
  });

  test('unit conversions round to something a human would write', () {
    // The maths, not the sentence. Formatting needs a widget tree now, because
    // the digits are localised — and the rounding is what this is about.
    settings.weightUnit = WeightUnit.lb;
    expect(displayWeight(82), 181);

    expect(feetInches(178), (5, 10));
    // 5'11.6" must carry to 6'0", never report 5'12".
    expect(feetInches(182), (6, 0));

    settings.weightUnit = WeightUnit.kg;
    expect(displayWeight(82), 82);
  });
}
