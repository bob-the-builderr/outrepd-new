/// Which of the things that happen are worth being told about, and the daily
/// reminder.
///
/// The settings mock drew a season ending and a friend passing you on the
/// board too — neither exists: there are no seasons, and nothing watches the
/// board for overtakes. A switch for each would be a control wired to nothing.
///
/// The three notice switches are enforced where the notice is written.
/// Turning one off does not hide the notice — it stops the server storing it
/// at all, and so its push with it, which is the only version of "off" worth
/// the name. The reminder lives on the phone; see lib/reminders.dart.
library;

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'
    show openAppSettings;

import '../backend/backend.dart';
import '../l10n/app_localizations.dart';
import '../push.dart';
import '../settings.dart';
import '../theme.dart';
import 'settings_parts.dart';

class NoticeSettingsScreen extends StatefulWidget {
  const NoticeSettingsScreen({super.key});

  @override
  State<NoticeSettingsScreen> createState() => _NoticeSettingsScreenState();
}

class _NoticeSettingsScreenState extends State<NoticeSettingsScreen>
    with WidgetsBindingObserver {
  late RemotePrefs _prefs = backend.me?.prefs ?? const RemotePrefs();
  bool _saving = false;

  /// Whether the phone lets the app show notifications. Only false earns a
  /// row: every switch below is pointless while the phone says no, and
  /// nothing else on the screen would tell anybody why nothing arrives.
  bool? _allowed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAllowed();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Back from the phone's settings, where the answer may have changed.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _checkAllowed();
  }

  Future<void> _checkAllowed() async {
    final allowed = await notificationsAllowed();
    if (mounted && allowed != _allowed) setState(() => _allowed = allowed);
  }

  Future<void> _pickTime() async {
    final minutes = settings.reminderMinutes;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
    );
    if (picked == null || !mounted) return;
    settings.update(
      () => settings.reminderMinutes = picked.hour * 60 + picked.minute,
    );
    setState(() {});
  }

  /// Applies the change on screen, then tries to save it.
  ///
  /// Optimistic on purpose: a switch that waits for a round trip before it
  /// moves feels broken on a slow connection. If the save fails it goes back
  /// to where it was and says so, because a switch that shows "off" while
  /// the server still says "on" is the one outcome worth avoiding.
  Future<void> _change(RemotePrefs next) async {
    final was = _prefs;
    setState(() {
      _prefs = next;
      _saving = true;
    });

    try {
      final saved = await backend.savePrefs(next);
      if (mounted) setState(() => _prefs = saved);
    } on Object catch (_) {
      if (!mounted) return;
      setState(() => _prefs = was);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L.of(context).notSaved),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.notifications),
        bottom: _saving
            ? const PreferredSize(
                preferredSize: Size.fromHeight(2),
                child: LinearProgressIndicator(minHeight: 2),
              )
            : null,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          if (_allowed == false)
            SettingsSection(
              title: l.phoneSection,
              children: [
                NavRow(
                  key: const Key('allowNotifications'),
                  icon: Icons.notifications_off_outlined,
                  label: l.allowNotifications,
                  caption: l.allowNotificationsHint,
                  onTap: openAppSettings,
                  last: true,
                ),
              ],
            ),
          SettingsSection(
            title: l.remindersSection,
            children: [
              SwitchRow(
                key: const Key('reminderSwitch'),
                icon: Icons.alarm_outlined,
                label: l.dailyReminder,
                caption: l.dailyReminderHint,
                value: settings.reminder,
                onChanged: (v) {
                  settings.update(() => settings.reminder = v);
                  setState(() {});
                },
                last: !settings.reminder,
              ),
              if (settings.reminder)
                NavRow(
                  key: const Key('reminderTime'),
                  icon: Icons.schedule_outlined,
                  label: l.reminderTime,
                  value: MaterialLocalizations.of(context).formatTimeOfDay(
                    TimeOfDay(
                      hour: settings.reminderMinutes ~/ 60,
                      minute: settings.reminderMinutes % 60,
                    ),
                  ),
                  onTap: _pickTime,
                  last: true,
                ),
            ],
          ),
          SettingsSection(
            title: l.duelSection,
            children: [
              SwitchRow(
                icon: Icons.sports_mma_outlined,
                label: l.noticeRaced,
                caption: l.noticeRacedHint,
                value: _prefs.notifyRaced,
                onChanged: (v) => _change(_prefs.copyWith(notifyRaced: v)),
              ),
              SwitchRow(
                key: const Key('noticeChallenged'),
                icon: Icons.replay,
                label: l.noticeChallenged,
                value: _prefs.notifyChallenged,
                onChanged: (v) =>
                    _change(_prefs.copyWith(notifyChallenged: v)),
              ),
              SwitchRow(
                key: const Key('noticeLiveInvite'),
                icon: Icons.sensors,
                label: l.noticeLiveInvite,
                value: _prefs.notifyLiveInvite,
                onChanged: (v) =>
                    _change(_prefs.copyWith(notifyLiveInvite: v)),
                last: true,
              ),
            ],
          ),
          SettingsSection(
            title: l.socialSection,
            children: [
              SwitchRow(
                icon: Icons.person_add_alt_1,
                label: l.friendRequestsLabel,
                value: _prefs.notifyFriendRequest,
                onChanged: (v) =>
                    _change(_prefs.copyWith(notifyFriendRequest: v)),
              ),
              SwitchRow(
                icon: Icons.how_to_reg_outlined,
                label: l.noticeFriendOk,
                value: _prefs.notifyFriendOk,
                onChanged: (v) => _change(_prefs.copyWith(notifyFriendOk: v)),
                last: true,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              l.noticesStoredNote,
              style: TextStyle(
                color: context.colors.faint,
                fontSize: 11,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
