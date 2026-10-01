import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('settings survive a restart', () async {
    final before = AppSettings();
    await before.load();

    before.update(() {
      before.themeMode = ThemeMode.light;
      before.vibration = false;
      before.showSkeleton = false;
    });

    // A second instance stands in for the next launch of the app.
    final after = AppSettings();
    await after.load();

    expect(after.themeMode, ThemeMode.light);
    expect(after.vibration, isFalse);
    expect(after.showSkeleton, isFalse);
  });

  test('untouched settings keep their defaults', () async {
    final fresh = AppSettings();
    await fresh.load();

    expect(fresh.themeMode, ThemeMode.dark);
    expect(fresh.showSkeleton, isTrue);
  });
}
