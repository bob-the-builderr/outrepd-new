import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
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

  test('unit conversions round to something a human would write', () async {
    // The suffix comes from the translations now, so the test reads English
    // out of the same place the app does rather than hard-coding "kg".
    final l = await L.delegate.load(const Locale('en'));

    settings.weightUnit = WeightUnit.lb;
    expect(formatBodyWeight(l, 82), '181 lb');

    settings.heightUnit = HeightUnit.ft;
    expect(formatHeight(l, 178), "5'10\"");
    // 5'11.6" must carry to 6'0", never print 5'12".
    expect(formatHeight(l, 182), "6'0\"");

    settings.weightUnit = WeightUnit.kg;
    settings.heightUnit = HeightUnit.cm;
    expect(formatBodyWeight(l, 82), '82 kg');
    expect(formatHeight(l, 178), '178 cm');
  });
}
