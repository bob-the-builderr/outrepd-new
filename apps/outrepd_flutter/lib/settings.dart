/// Every preference the app exposes. There is no backend yet, so these live on
/// the device rather than an account — reinstalling starts you over.
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';

enum WeightUnit { kg, lb }

enum HeightUnit { cm, ft }

enum ProfileVisibility { everyone, friends, nobody }

/// The languages the app ships in. Following the device is the default: most
/// people never open a language picker, and a phone already knows.
enum AppLanguage {
  system,
  english,
  arabic,
  spanish,
  french,
  german,
  portuguese,
  italian,
  russian,
  turkish,
  indonesian,
  hindi,
  japanese,
  korean,
  chinese,
}

// Even the abbreviations are translated: "kg" is كجم in Arabic, 公斤 in
// Chinese, किग्रा in Hindi. Leaving them in Latin script is the kind of detail
// that makes a translated app feel half-done.
extension WeightUnitLabel on WeightUnit {
  String label(L l) => this == WeightUnit.kg ? l.unitKg : l.unitLb;
  String short(L l) => this == WeightUnit.kg ? l.shortKg : l.shortLb;
}

extension HeightUnitLabel on HeightUnit {
  String label(L l) => this == HeightUnit.cm ? l.unitCm : l.unitFt;
  String short(L l) => this == HeightUnit.cm ? l.shortCm : l.shortFt;
}

extension ProfileVisibilityLabel on ProfileVisibility {
  String label(L l) => switch (this) {
        ProfileVisibility.everyone => l.visEveryone,
        ProfileVisibility.friends => l.visFriends,
        ProfileVisibility.nobody => l.visNobody,
      };

  String description(L l) => switch (this) {
        ProfileVisibility.everyone => l.visEveryoneHint,
        ProfileVisibility.friends => l.visFriendsHint,
        ProfileVisibility.nobody => l.visNobodyHint,
      };
}

extension AppLanguageLabel on AppLanguage {
  /// Each language names itself. Somebody looking for their own language
  /// scans for the word they recognise, not for its English translation.
  /// "Match device" is the exception — it names a setting, not a language, so
  /// it is read in whatever the app is currently speaking.
  String label(L l) => switch (this) {
        AppLanguage.system => l.themeSystem,
        AppLanguage.english => 'English',
        AppLanguage.arabic => 'العربية',
        AppLanguage.spanish => 'Español',
        AppLanguage.french => 'Français',
        AppLanguage.german => 'Deutsch',
        AppLanguage.portuguese => 'Português',
        AppLanguage.italian => 'Italiano',
        AppLanguage.russian => 'Русский',
        AppLanguage.turkish => 'Türkçe',
        AppLanguage.indonesian => 'Bahasa Indonesia',
        AppLanguage.hindi => 'हिन्दी',
        AppLanguage.japanese => '日本語',
        AppLanguage.korean => '한국어',
        AppLanguage.chinese => '中文',
      };

  /// Null follows the device.
  Locale? get locale => switch (this) {
        AppLanguage.system => null,
        AppLanguage.english => const Locale('en'),
        AppLanguage.arabic => const Locale('ar'),
        AppLanguage.spanish => const Locale('es'),
        AppLanguage.french => const Locale('fr'),
        AppLanguage.german => const Locale('de'),
        AppLanguage.portuguese => const Locale('pt'),
        AppLanguage.italian => const Locale('it'),
        AppLanguage.russian => const Locale('ru'),
        AppLanguage.turkish => const Locale('tr'),
        AppLanguage.indonesian => const Locale('id'),
        AppLanguage.hindi => const Locale('hi'),
        AppLanguage.japanese => const Locale('ja'),
        AppLanguage.korean => const Locale('ko'),
        AppLanguage.chinese => const Locale('zh'),
      };
}

extension ThemeModeLabel on ThemeMode {
  String label(L l) => switch (this) {
        ThemeMode.system => l.themeSystem,
        ThemeMode.light => l.themeLight,
        ThemeMode.dark => l.themeDark,
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
  AppLanguage language = AppLanguage.system;

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
String formatBodyWeight(L l, int kg) => settings.weightUnit == WeightUnit.kg
    ? '$kg ${l.shortKg}'
    : '${(kg * 2.20462).round()} ${l.shortLb}';

String formatHeight(L l, int cm) {
  if (settings.heightUnit == HeightUnit.cm) return '$cm ${l.shortCm}';
  final totalInches = cm / 2.54;
  final feet = totalInches ~/ 12;
  final inches = (totalInches % 12).round();
  // 11.6" rounds to 12" — carry it rather than print 5'12".
  return inches == 12 ? "${feet + 1}'0\"" : "$feet'$inches\"";
}
