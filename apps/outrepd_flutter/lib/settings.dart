/// Every preference the app exposes. There is no backend yet, so these live on
/// the device rather than an account — reinstalling starts you over.
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum WeightUnit { kg, lb }

enum HeightUnit { cm, ft }

enum ProfileVisibility { everyone, friends, nobody }

enum AppLanguage { english, arabic }

extension WeightUnitLabel on WeightUnit {
  String get label => this == WeightUnit.kg ? 'Kilograms (kg)' : 'Pounds (lb)';
  String get short => this == WeightUnit.kg ? 'kg' : 'lb';
}

extension HeightUnitLabel on HeightUnit {
  String get label =>
      this == HeightUnit.cm ? 'Centimetres (cm)' : 'Feet & inches';
  String get short => this == HeightUnit.cm ? 'cm' : 'ft';
}

extension ProfileVisibilityLabel on ProfileVisibility {
  String get label => switch (this) {
        ProfileVisibility.everyone => 'Everyone',
        ProfileVisibility.friends => 'Friends only',
        ProfileVisibility.nobody => 'Nobody',
      };

  String get description => switch (this) {
        ProfileVisibility.everyone => 'Anyone can open your profile',
        ProfileVisibility.friends => 'Only lifters you have added',
        ProfileVisibility.nobody => 'Your profile stays private',
      };
}

extension AppLanguageLabel on AppLanguage {
  String get label => this == AppLanguage.english ? 'English' : 'العربية';
}

extension ThemeModeLabel on ThemeMode {
  String get label => switch (this) {
        ThemeMode.system => 'Match device',
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
      };

  IconData get icon => switch (this) {
        ThemeMode.system => Icons.brightness_auto_outlined,
        ThemeMode.light => Icons.light_mode_outlined,
        ThemeMode.dark => Icons.dark_mode_outlined,
      };
}

class AppSettings extends ChangeNotifier {
  // Appearance
  ThemeMode themeMode = ThemeMode.dark;
  AppLanguage language = AppLanguage.english;

  // Units
  WeightUnit weightUnit = WeightUnit.kg;
  HeightUnit heightUnit = HeightUnit.cm;

  // Notifications
  bool notifyMatchInvites = true;
  bool notifyMatchResults = true;
  bool notifyFriendRequests = true;
  bool notifyCrewActivity = true;
  bool notifyRankChanges = true;
  bool notifyWeeklySummary = false;
  bool sound = true;
  bool vibration = true;

  // Privacy
  ProfileVisibility visibility = ProfileVisibility.everyone;
  bool showOnLeaderboard = true;
  bool allowMatchInvites = true;
  bool allowFriendRequests = true;
  bool showBodyStats = false;

  // Matches
  bool autoAcceptFriendMatches = false;
  bool restTimer = true;

  SharedPreferences? _store;

  /// Read what was saved last run. Call before the first frame so the app
  /// never flashes the default theme on its way to the chosen one.
  Future<void> load() async {
    final s = _store = await SharedPreferences.getInstance();

    T pickEnum<T>(String key, List<T> values, T fallback) {
      final i = s.getInt(key);
      return i != null && i >= 0 && i < values.length ? values[i] : fallback;
    }

    themeMode = pickEnum('themeMode', ThemeMode.values, themeMode);
    language = pickEnum('language', AppLanguage.values, language);
    weightUnit = pickEnum('weightUnit', WeightUnit.values, weightUnit);
    heightUnit = pickEnum('heightUnit', HeightUnit.values, heightUnit);
    visibility = pickEnum('visibility', ProfileVisibility.values, visibility);

    bool flag(String key, bool fallback) => s.getBool(key) ?? fallback;

    notifyMatchInvites = flag('notifyMatchInvites', notifyMatchInvites);
    notifyMatchResults = flag('notifyMatchResults', notifyMatchResults);
    notifyFriendRequests = flag('notifyFriendRequests', notifyFriendRequests);
    notifyCrewActivity = flag('notifyCrewActivity', notifyCrewActivity);
    notifyRankChanges = flag('notifyRankChanges', notifyRankChanges);
    notifyWeeklySummary = flag('notifyWeeklySummary', notifyWeeklySummary);
    sound = flag('sound', sound);
    vibration = flag('vibration', vibration);
    showOnLeaderboard = flag('showOnLeaderboard', showOnLeaderboard);
    allowMatchInvites = flag('allowMatchInvites', allowMatchInvites);
    allowFriendRequests = flag('allowFriendRequests', allowFriendRequests);
    showBodyStats = flag('showBodyStats', showBodyStats);
    autoAcceptFriendMatches =
        flag('autoAcceptFriendMatches', autoAcceptFriendMatches);
    restTimer = flag('restTimer', restTimer);
  }

  /// Mutate settings through this so listeners rebuild and the change sticks.
  void update(VoidCallback change) {
    change();
    _persist();
    notifyListeners();
  }

  void _persist() {
    final s = _store;
    // Nothing to write to if load() never ran — the app still works, it just
    // forgets, which beats crashing on a storage error.
    if (s == null) return;

    s.setInt('themeMode', themeMode.index);
    s.setInt('language', language.index);
    s.setInt('weightUnit', weightUnit.index);
    s.setInt('heightUnit', heightUnit.index);
    s.setInt('visibility', visibility.index);

    s.setBool('notifyMatchInvites', notifyMatchInvites);
    s.setBool('notifyMatchResults', notifyMatchResults);
    s.setBool('notifyFriendRequests', notifyFriendRequests);
    s.setBool('notifyCrewActivity', notifyCrewActivity);
    s.setBool('notifyRankChanges', notifyRankChanges);
    s.setBool('notifyWeeklySummary', notifyWeeklySummary);
    s.setBool('sound', sound);
    s.setBool('vibration', vibration);
    s.setBool('showOnLeaderboard', showOnLeaderboard);
    s.setBool('allowMatchInvites', allowMatchInvites);
    s.setBool('allowFriendRequests', allowFriendRequests);
    s.setBool('showBodyStats', showBodyStats);
    s.setBool('autoAcceptFriendMatches', autoAcceptFriendMatches);
    s.setBool('restTimer', restTimer);
  }

  /// What [themeMode] means right now, given the device setting.
  Brightness resolveBrightness(Brightness platform) => switch (themeMode) {
        ThemeMode.system => platform,
        ThemeMode.light => Brightness.light,
        ThemeMode.dark => Brightness.dark,
      };
}

final settings = AppSettings();

/// Body weight in the unit the user picked, rounded — nobody needs grams.
String formatBodyWeight(int kg) => settings.weightUnit == WeightUnit.kg
    ? '$kg kg'
    : '${(kg * 2.20462).round()} lb';

String formatHeight(int cm) {
  if (settings.heightUnit == HeightUnit.cm) return '$cm cm';
  final totalInches = cm / 2.54;
  final feet = totalInches ~/ 12;
  final inches = (totalInches % 12).round();
  // 11.6" rounds to 12" — carry it rather than print 5'12".
  return inches == 12 ? "${feet + 1}'0\"" : "$feet'$inches\"";
}
