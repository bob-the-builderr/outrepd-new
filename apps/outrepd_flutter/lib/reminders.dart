/// The daily reminder: one notification at the lifter's chosen time, on a day
/// they have not trained yet, so a streak is not lost to simply forgetting.
///
/// Scheduled on the phone — no server, no account — a week ahead, and again
/// whenever the app opens, a set is recorded, or the time is changed. A day
/// already trained is skipped, so the reminder never nags somebody who has
/// done their set.
///
/// Also creates the two notification channels Android lists under the app's
/// settings, since this is the code that runs the plugin that makes them.
library;

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import 'l10n/app_localizations.dart';
import 'push.dart';
import 'rewards.dart';
import 'settings.dart';

/// One reminder.
@immutable
class ReminderSlot {
  const ReminderSlot(this.at, {this.streak = 0});

  /// When, on the phone's clock.
  final DateTime at;

  /// The run of days it keeps going, when it can say so truthfully — only
  /// today's, and only when yesterday was trained. Zero otherwise.
  final int streak;
}

/// The reminders for the [days] days from [now]: at [minutes] past midnight
/// each day, except a time already gone and except today if it has been
/// trained.
///
/// Only today's can name the streak. Further out, whether it is still alive
/// depends on days that have not happened yet; the app schedules again each
/// time it opens, so tomorrow's gets its turn tomorrow.
List<ReminderSlot> reminderSlots({
  required DateTime now,
  required int minutes,
  required DateTime? lastSession,
  required int streak,
  int days = 7,
}) {
  final today = DateTime(now.year, now.month, now.day);
  final lastDay = lastSession == null
      ? null
      : DateTime(lastSession.year, lastSession.month, lastSession.day);
  final trainedToday = lastDay == today;
  final trainedYesterday =
      lastDay == DateTime(today.year, today.month, today.day - 1);

  final slots = <ReminderSlot>[];
  for (var d = 0; d < days; d++) {
    // Built from the calendar date, not by adding hours, so a clock change
    // does not shift the reminder by one.
    final at = DateTime(
      today.year,
      today.month,
      today.day + d,
      minutes ~/ 60,
      minutes % 60,
    );
    if (!at.isAfter(now)) continue;
    if (d == 0 && trainedToday) continue;
    slots.add(
      ReminderSlot(at, streak: d == 0 && trainedYesterday ? streak : 0),
    );
  }
  return slots;
}

class Reminders {
  Reminders._();

  static final instance = Reminders._();

  /// Ids of the week's reminders. Far from anything else the plugin shows.
  static const _firstId = 7000;
  static const _days = 7;

  /// Android's notification channels. `matches` is also named in the
  /// manifest as the channel a push lands in.
  static const matchesChannel = 'matches';
  static const remindersChannel = 'reminders';

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _started = false;
  Timer? _pending;

  Future<void> start() async {
    if (!notificationsPossible || _started) return;
    try {
      // Only for the type the plugin asks for. Every time handed to it is an
      // exact instant in UTC worked out from the phone's own clock, so the
      // phone's time zone never has to be named.
      tz_data.initializeTimeZones();
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('ic_stat_outrepd'),
          iOS: DarwinInitializationSettings(
            // Asked for once, at a moment that explains itself; see
            // askForNotificationsOnce.
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
          ),
        ),
      );
      _started = true;
      await _createChannels();
      settings.addListener(_soon);
      rewards.addListener(_soon);
      await reschedule();
    } on Object catch (error) {
      debugPrint('Reminders are not available: $error');
    }
  }

  L get _words => lookupL(Locale(appLanguageCode()));

  Future<void> _createChannels() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return;
    final l = _words;
    await android.createNotificationChannel(
      AndroidNotificationChannel(
        matchesChannel,
        l.channelMatches,
        importance: Importance.high,
      ),
    );
    await android.createNotificationChannel(
      AndroidNotificationChannel(remindersChannel, l.channelReminders),
    );
  }

  /// Settings and rewards both change in bursts; one reschedule per burst.
  void _soon() {
    _pending?.cancel();
    _pending = Timer(const Duration(milliseconds: 400), () {
      unawaited(reschedule());
    });
  }

  /// Clears the week's reminders and sets them again from what is true now.
  Future<void> reschedule() async {
    if (!_started) return;
    try {
      for (var i = 0; i < _days; i++) {
        await _plugin.cancel(id: _firstId + i);
      }
      if (!settings.reminder) return;

      final l = _words;
      // The channel names follow the language too.
      await _createChannels();
      final slots = reminderSlots(
        now: DateTime.now(),
        minutes: settings.reminderMinutes,
        lastSession: rewards.lastSession,
        streak: rewards.streak,
        days: _days,
      );
      for (var i = 0; i < slots.length; i++) {
        final slot = slots[i];
        await _plugin.zonedSchedule(
          id: _firstId + i,
          title: l.reminderTitle,
          body: slot.streak >= 2
              ? l.reminderStreakBody('${slot.streak}')
              : l.reminderBody,
          scheduledDate: tz.TZDateTime.from(slot.at, tz.UTC),
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              remindersChannel,
              l.channelReminders,
              icon: 'ic_stat_outrepd',
              color: const Color(0xFFE8846B),
            ),
            iOS: const DarwinNotificationDetails(),
          ),
          // Inexact: a reminder a few minutes late is fine, and exact alarms
          // need a permission Google Play asks apps to justify.
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    } on Object catch (error) {
      debugPrint('Could not schedule reminders: $error');
    }
  }
}
