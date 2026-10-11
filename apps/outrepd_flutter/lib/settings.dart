/// Every preference the app keeps on this phone. They are about this phone
/// — its theme, its language, its sounds — so they live on it rather than on
/// the account, and a reinstall starts them over.
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backend/backend.dart' show Challengeable;
import 'l10n/app_localizations.dart';

/// The languages the app ships in. English is the default, whatever the
/// phone is set to: the app was written in it and every other language is a
/// translation of it. Following the device is still one of the choices.
enum AppLanguage {
  system,
  english,
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

extension ChallengeableLabel on Challengeable {
  String label(L l) => switch (this) {
    Challengeable.everyone => l.visEveryone,
    Challengeable.friends => l.visFriends,
    Challengeable.nobody => l.visNobody,
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
  AppLanguage language = AppLanguage.english;

  // The duel, as it behaves on this phone.
  //
  // Only two things here, and both of them do something. The settings mock
  // also drew a default duration, a camera choice and a "count out loud":
  //
  //   * every duel is sixty seconds because that is what makes two stored
  //     sets comparable. A ninety-second set against a sixty-second one is
  //     not a duel, so this is a rule rather than a preference;
  //   * the counter is tuned for the front camera with the phone propped in
  //     front of the lifter — that is the footage every threshold in
  //     `lib/reps/` was measured from. A rear-camera option would be a
  //     switch that quietly makes the count worse;
  //   * counting out loud needs speech this app does not have.
  //
  // Each of those is a row that would have looked like a setting and
  // behaved like nothing.

  /// A tap of haptic feedback as each rep lands.
  bool vibration = true;

  /// The countdown beeps, a tick for each counted rep, and the end of a
  /// round. On by default: the lifter is looking at the floor, not the
  /// screen. They mix with music rather than interrupt it.
  bool sounds = true;

  /// A notification on a day not yet trained, at [reminderMinutes]. On by
  /// default: a streak lost to forgetting is the commonest way to lose one,
  /// and Android still asks before any notification is shown.
  bool reminder = true;

  /// When the reminder comes, in minutes past midnight. 7 pm: late enough
  /// that most people's day is done, early enough to still do a set.
  int reminderMinutes = 19 * 60;

  /// Draw the tracked skeleton over the camera.
  ///
  /// On by default: it is how somebody can tell the counter is seeing them
  /// before they trust the number, and it is the first thing to look at
  /// when a rep does not count.
  bool showSkeleton = true;

  /// Push-ups a day for today's goal on the Match tab — one of
  /// [kDailyGoals] in daily_goal.dart. Fifty: a real day's work for most,
  /// two or three sets.
  int dailyGoal = 50;

  /// Each set copied to Apple Health or Health Connect as a workout. Off
  /// until turned on, which is when the phone asks (lib/health_sync.dart).
  bool saveToHealth = false;

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
    language = _loadLanguage(s) ?? language;
    // Following the device was the default until English took its place,
    // and every settings change saved whatever the language was — so a saved
    // "follow the device" is almost always the old default, not a choice.
    // Once, it becomes English; picked again after that, it stays.
    if (s.getBool('languageDefaultEnglish') != true) {
      if (language == AppLanguage.system) language = AppLanguage.english;
      s.setBool('languageDefaultEnglish', true);
    }

    bool flag(String key, bool fallback) => s.getBool(key) ?? fallback;

    vibration = flag('vibration', vibration);
    sounds = flag('sounds', sounds);
    reminder = flag('reminder', reminder);
    final minutes = s.getInt('reminderMinutes');
    if (minutes != null && minutes >= 0 && minutes < 24 * 60) {
      reminderMinutes = minutes;
    }
    showSkeleton = flag('showSkeleton', showSkeleton);
    saveToHealth = flag('saveToHealth', saveToHealth);
    final goal = s.getInt('dailyGoal');
    if (goal != null && goal > 0 && goal <= 1000) dailyGoal = goal;
  }

  /// The saved language, by name.
  ///
  /// It used to be saved by its position in [AppLanguage], and Arabic was
  /// taken out of the middle of that list — so an old position is read
  /// against the list as it was then. Arabic itself becomes following the
  /// device, which on an Arabic phone now means English.
  static AppLanguage? _loadLanguage(SharedPreferences s) {
    final name = s.getString('languageName');
    if (name != null) {
      for (final language in AppLanguage.values) {
        if (language.name == name) return language;
      }
      return null;
    }
    final old = s.getInt('language');
    if (old == null || old < 0 || old >= _languagesByOldPosition.length) {
      return null;
    }
    return _languagesByOldPosition[old];
  }

  /// [AppLanguage] as it was ordered while it was saved by position.
  static const _languagesByOldPosition = [
    AppLanguage.system,
    AppLanguage.english,
    AppLanguage.system, // was Arabic
    AppLanguage.spanish,
    AppLanguage.french,
    AppLanguage.german,
    AppLanguage.portuguese,
    AppLanguage.italian,
    AppLanguage.russian,
    AppLanguage.turkish,
    AppLanguage.indonesian,
    AppLanguage.hindi,
    AppLanguage.japanese,
    AppLanguage.korean,
    AppLanguage.chinese,
  ];

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
    s.setString('languageName', language.name);

    s.setBool('vibration', vibration);
    s.setBool('sounds', sounds);
    s.setBool('reminder', reminder);
    s.setInt('reminderMinutes', reminderMinutes);
    s.setBool('showSkeleton', showSkeleton);
    s.setInt('dailyGoal', dailyGoal);
    s.setBool('saveToHealth', saveToHealth);
  }

  /// What [themeMode] means right now, given the device setting.
  Brightness resolveBrightness(Brightness platform) => switch (themeMode) {
    ThemeMode.system => platform,
    ThemeMode.light => Brightness.light,
    ThemeMode.dark => Brightness.dark,
  };
}

final settings = AppSettings();
