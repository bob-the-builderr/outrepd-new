/// Keeps the home-screen widgets in step with the app.
///
/// The widgets work nothing out for themselves: everything they show is
/// written here, in the reader's language, and saved where the widget can
/// read it — Android's shared preferences, or the app group both the app and
/// its iOS widget extension share. Saved again whenever the career or the
/// goal changes, which is whenever a set lands.
library;

import 'dart:async';
import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

import 'career.dart';
import 'data.dart';
import 'l10n/app_localizations.dart';
import 'settings.dart';
import 'widgets.dart';

abstract final class HomeWidgets {
  /// Shared with the widget extension; the same id is in both targets'
  /// entitlements (ios/Runner, ios/OutrepdWidget).
  static const appGroup = 'group.com.outrepd.outrepd';

  /// The iOS widget's kind, and the two Android providers.
  static const _iOSName = 'OutrepdWidget';
  static const _androidSmall = 'com.outrepd.outrepd.OutrepdSmallWidget';
  static const _androidMedium = 'com.outrepd.outrepd.OutrepdMediumWidget';

  static bool _started = false;
  static Timer? _soon;

  /// Called once at launch, on a phone. Nothing here may stop the app from
  /// opening, so every failure is only reported.
  static Future<void> start() async {
    if (_started || kIsWeb) return;
    _started = true;
    try {
      await HomeWidget.setAppGroupId(appGroup);
    } on Object catch (error) {
      debugPrint('Could not reach the widget storage: $error');
    }
    Career.instance.addListener(_later);
    settings.addListener(_later);
    await push();
  }

  /// A set lands as a burst of changes; one write after it is enough.
  static void _later() {
    _soon?.cancel();
    _soon = Timer(const Duration(milliseconds: 600), () => unawaited(push()));
  }

  /// What the widgets show, written in the app's language.
  static Map<String, String> contents(L l) {
    final p = demoProfile;
    final goal = settings.dailyGoal;
    final done = Career.instance.repsToday;
    final percent = goal <= 0 ? 0 : (done * 100 ~/ goal).clamp(0, 100);
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return {
      // The day the count is for: past midnight the widget shows a fresh
      // ring on its own rather than yesterday's.
      'goal_day': '${now.year}-${two(now.month)}-${two(now.day)}',
      'goal_of_fresh': l.widgetGoalOf('$goal'),
      'goal_count': '$done',
      'goal_percent': '$percent',
      'goal_of': done >= goal ? l.dailyGoalDone : l.widgetGoalOf('$goal'),
      'streak': p.dayStreak > 0 ? l.dayStreakCount('${p.dayStreak}') : '',
      'rank': p.isRanked ? tierLabel(l, p.tierIdx, p.divIdx) : l.unranked,
      'lp': p.isRanked ? '${p.lp} / 100 LP' : '',
      'lp_percent': p.isRanked ? '${p.lp.clamp(0, 100)}' : '0',
    };
  }

  static Future<void> push() async {
    if (kIsWeb) return;
    try {
      final locale =
          settings.language.locale ?? PlatformDispatcher.instance.locale;
      final l = lookupL(
        L.supportedLocales.any((s) => s.languageCode == locale.languageCode)
            ? Locale(locale.languageCode)
            : const Locale('en'),
      );
      for (final entry in contents(l).entries) {
        await HomeWidget.saveWidgetData<String>(entry.key, entry.value);
      }
      await HomeWidget.updateWidget(
        iOSName: _iOSName,
        qualifiedAndroidName: _androidSmall,
      );
      await HomeWidget.updateWidget(qualifiedAndroidName: _androidMedium);
    } on Object catch (error) {
      // No widget on the home screen, or none on this platform: nothing to
      // keep up to date, and nothing worth troubling anyone about.
      debugPrint('Could not update the home-screen widgets: $error');
    }
  }
}
