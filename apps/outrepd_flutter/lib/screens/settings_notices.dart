/// Which of the three things that happen are worth being told about.
///
/// Three switches, not six. The settings mock drew a season ending, a friend
/// passing you on the board, a streak reminder and a line about the phone's
/// own notification settings — and none of those exist: there are no
/// seasons, nothing watches the board for overtakes, there are no scheduled
/// reminders, and there is no push. A switch for each would have been four
/// controls wired to nothing.
///
/// Each of these is enforced where it is written. Turning one off does not
/// hide the notice — it stops the server storing it at all, which is the
/// only version of "off" worth the name.
library;

import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import 'settings_parts.dart';

class NoticeSettingsScreen extends StatefulWidget {
  const NoticeSettingsScreen({super.key});

  @override
  State<NoticeSettingsScreen> createState() => _NoticeSettingsScreenState();
}

class _NoticeSettingsScreenState extends State<NoticeSettingsScreen> {
  late RemotePrefs _prefs = backend.me?.prefs ?? const RemotePrefs();
  bool _saving = false;

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
          SettingsSection(
            title: l.duelSection,
            children: [
              SwitchRow(
                icon: Icons.sports_mma_outlined,
                label: l.noticeRaced,
                caption: l.noticeRacedHint,
                value: _prefs.notifyRaced,
                onChanged: (v) => _change(_prefs.copyWith(notifyRaced: v)),
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
