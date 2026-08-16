import 'package:flutter/material.dart';

import '../settings.dart';
import '../theme.dart';
import '../widgets.dart';

/// The full settings page. Everything here writes to the in-memory [settings]
/// object; the appearance rows rebuild the whole app through its listener.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _set(VoidCallback change) => settings.update(change);

  void _todo(String what) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$what needs a server — not wired up yet')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _Section(
            title: 'Appearance',
            children: [
              _NavRow(
                icon: settings.themeMode.icon,
                label: 'Theme',
                value: settings.themeMode.label,
                onTap: _pickTheme,
              ),
              // The quick toggle people actually look for, next to the full
              // three-way picker above it.
              _SwitchRow(
                icon: Icons.dark_mode_outlined,
                label: 'Dark mode',
                caption: settings.themeMode == ThemeMode.system
                    ? 'Following your device right now'
                    : null,
                value: settings.resolveBrightness(
                      MediaQuery.platformBrightnessOf(context),
                    ) ==
                    Brightness.dark,
                onChanged: (on) => _set(
                  () => settings.themeMode =
                      on ? ThemeMode.dark : ThemeMode.light,
                ),
              ),
              _NavRow(
                icon: Icons.translate,
                label: 'Language',
                value: settings.language.label,
                onTap: _pickLanguage,
                last: true,
              ),
            ],
          ),
          _Section(
            title: 'Units',
            children: [
              _NavRow(
                icon: Icons.monitor_weight_outlined,
                label: 'Weight',
                value: settings.weightUnit.label,
                onTap: () => _pick<WeightUnit>(
                  title: 'Weight unit',
                  values: WeightUnit.values,
                  current: settings.weightUnit,
                  label: (v) => v.label,
                  onPick: (v) => _set(() => settings.weightUnit = v),
                ),
              ),
              _NavRow(
                icon: Icons.straighten,
                label: 'Height',
                value: settings.heightUnit.label,
                onTap: () => _pick<HeightUnit>(
                  title: 'Height unit',
                  values: HeightUnit.values,
                  current: settings.heightUnit,
                  label: (v) => v.label,
                  onPick: (v) => _set(() => settings.heightUnit = v),
                ),
                last: true,
              ),
            ],
          ),
          _Section(
            title: 'Notifications',
            children: [
              _SwitchRow(
                icon: Icons.sports_mma_outlined,
                label: 'Match invites',
                value: settings.notifyMatchInvites,
                onChanged: (v) => _set(() => settings.notifyMatchInvites = v),
              ),
              _SwitchRow(
                icon: Icons.emoji_events_outlined,
                label: 'Match results',
                value: settings.notifyMatchResults,
                onChanged: (v) => _set(() => settings.notifyMatchResults = v),
              ),
              _SwitchRow(
                icon: Icons.person_add_alt_outlined,
                label: 'Friend requests',
                value: settings.notifyFriendRequests,
                onChanged: (v) => _set(() => settings.notifyFriendRequests = v),
              ),
              _SwitchRow(
                icon: Icons.groups_2_outlined,
                label: 'Crew activity',
                value: settings.notifyCrewActivity,
                onChanged: (v) => _set(() => settings.notifyCrewActivity = v),
              ),
              _SwitchRow(
                icon: Icons.trending_up,
                label: 'Rank changes',
                value: settings.notifyRankChanges,
                onChanged: (v) => _set(() => settings.notifyRankChanges = v),
              ),
              _SwitchRow(
                icon: Icons.calendar_month_outlined,
                label: 'Weekly summary',
                value: settings.notifyWeeklySummary,
                onChanged: (v) => _set(() => settings.notifyWeeklySummary = v),
              ),
              _SwitchRow(
                icon: Icons.volume_up_outlined,
                label: 'Sound',
                value: settings.sound,
                onChanged: (v) => _set(() => settings.sound = v),
              ),
              _SwitchRow(
                icon: Icons.vibration,
                label: 'Vibration',
                value: settings.vibration,
                onChanged: (v) => _set(() => settings.vibration = v),
                last: true,
              ),
            ],
          ),
          _Section(
            title: 'Privacy',
            children: [
              _NavRow(
                icon: Icons.visibility_outlined,
                label: 'Who can see my profile',
                value: settings.visibility.label,
                onTap: () => _pick<ProfileVisibility>(
                  title: 'Profile visibility',
                  values: ProfileVisibility.values,
                  current: settings.visibility,
                  label: (v) => v.label,
                  caption: (v) => v.description,
                  onPick: (v) => _set(() => settings.visibility = v),
                ),
              ),
              _SwitchRow(
                icon: Icons.leaderboard_outlined,
                label: 'Show me on leaderboards',
                value: settings.showOnLeaderboard,
                onChanged: (v) => _set(() => settings.showOnLeaderboard = v),
              ),
              _SwitchRow(
                icon: Icons.mail_outline,
                label: 'Allow match invites',
                value: settings.allowMatchInvites,
                onChanged: (v) => _set(() => settings.allowMatchInvites = v),
              ),
              _SwitchRow(
                icon: Icons.person_add_alt_1_outlined,
                label: 'Allow friend requests',
                value: settings.allowFriendRequests,
                onChanged: (v) => _set(() => settings.allowFriendRequests = v),
              ),
              _SwitchRow(
                icon: Icons.accessibility_new,
                label: 'Show height and weight',
                caption: 'Off keeps your body stats to yourself',
                value: settings.showBodyStats,
                onChanged: (v) => _set(() => settings.showBodyStats = v),
                last: true,
              ),
            ],
          ),
          _Section(
            title: 'Matches',
            children: [
              _SwitchRow(
                icon: Icons.bolt_outlined,
                label: 'Auto-accept from friends',
                value: settings.autoAcceptFriendMatches,
                onChanged: (v) =>
                    _set(() => settings.autoAcceptFriendMatches = v),
              ),
              _SwitchRow(
                icon: Icons.timer_outlined,
                label: 'Rest timer between sets',
                value: settings.restTimer,
                onChanged: (v) => _set(() => settings.restTimer = v),
                last: true,
              ),
            ],
          ),
          _Section(
            title: 'Data',
            children: [
              _NavRow(
                icon: Icons.download_outlined,
                label: 'Export my data',
                onTap: () => _todo('Exporting your data'),
              ),
              _NavRow(
                icon: Icons.cleaning_services_outlined,
                label: 'Clear cache',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cache cleared')),
                  );
                },
                last: true,
              ),
            ],
          ),
          _Section(
            title: 'About',
            children: [
              _NavRow(
                icon: Icons.info_outline,
                label: 'Version',
                value: '1.0.0',
                chevron: false,
              ),
              _NavRow(
                icon: Icons.star_outline,
                label: 'Rate OUTREPD',
                onTap: () => _todo('The store listing'),
              ),
              _NavRow(
                icon: Icons.support_agent_outlined,
                label: 'Contact support',
                onTap: () => _todo('Support'),
              ),
              _NavRow(
                icon: Icons.description_outlined,
                label: 'Terms of service',
                onTap: () => _todo('Terms'),
              ),
              _NavRow(
                icon: Icons.privacy_tip_outlined,
                label: 'Privacy policy',
                onTap: () => _todo('The privacy policy'),
              ),
              _NavRow(
                icon: Icons.article_outlined,
                label: 'Open source licences',
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: 'OUTREPD',
                  applicationVersion: '1.0.0',
                ),
                last: true,
              ),
            ],
          ),
          _Section(
            title: 'Danger zone',
            children: [
              _NavRow(
                icon: Icons.restart_alt,
                label: 'Reset my progress',
                danger: true,
                onTap: () => _confirm(
                  title: 'Reset your progress?',
                  body: 'Rank, LP and match history all go back to zero. '
                      'This cannot be undone.',
                  action: 'Reset',
                  onConfirm: () => _todo('Resetting progress'),
                ),
              ),
              _NavRow(
                icon: Icons.delete_outline,
                label: 'Delete account',
                danger: true,
                last: true,
                onTap: () => _confirm(
                  title: 'Delete your account?',
                  body: 'Your profile, crews and every match you have lifted '
                      'are removed for good.',
                  action: 'Delete',
                  onConfirm: () => _todo('Deleting the account'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'OUTREPD · 1.0.0',
              style: TextStyle(color: context.colors.muted, fontSize: 11.5),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTheme() => _pick<ThemeMode>(
        title: 'Theme',
        values: ThemeMode.values,
        current: settings.themeMode,
        label: (v) => v.label,
        icon: (v) => v.icon,
        onPick: (v) => _set(() => settings.themeMode = v),
      );

  Future<void> _pickLanguage() => _pick<AppLanguage>(
        title: 'Language',
        values: AppLanguage.values,
        current: settings.language,
        label: (v) => v.label,
        onPick: (v) => _set(() => settings.language = v),
      );

  /// One sheet for every either-or setting on the page.
  Future<void> _pick<T>({
    required String title,
    required List<T> values,
    required T current,
    required String Function(T) label,
    required void Function(T) onPick,
    String Function(T)? caption,
    IconData Function(T)? icon,
  }) async {
    final picked = await showModalBottomSheet<T>(
      context: context,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
              child: Text(
                title,
                style: TextStyle(
                  color: context.colors.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            for (final v in values)
              ListTile(
                leading: icon == null
                    ? null
                    : Icon(
                        icon(v),
                        color: v == current ? context.colors.brand : context.colors.muted,
                      ),
                title: Text(
                  label(v),
                  style: TextStyle(
                    color: context.colors.text,
                    fontWeight:
                        v == current ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                subtitle: caption == null
                    ? null
                    : Text(
                        caption(v),
                        style:
                            TextStyle(color: context.colors.muted, fontSize: 12),
                      ),
                trailing: v == current
                    ? Icon(Icons.check_circle, color: context.colors.brand)
                    : null,
                onTap: () => Navigator.of(context).pop(v),
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
    if (picked != null) {
      onPick(picked);
      if (mounted) setState(() {});
    }
  }

  Future<void> _confirm({
    required String title,
    required String body,
    required String action,
    required VoidCallback onConfirm,
  }) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text(title, style: TextStyle(color: context.colors.text)),
        content: Text(body, style: TextStyle(color: context.colors.muted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: TextStyle(color: context.colors.muted)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              action,
              style: const TextStyle(
                color: AppColors.loss,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
    if (ok == true) onConfirm();
  }
}

/// A titled group of rows in one panel.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: title),
          Panel(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

/// Shared chrome for a settings row: icon, label, optional caption, and a
/// hairline unless it closes the section.
class _RowFrame extends StatelessWidget {
  const _RowFrame({
    required this.icon,
    required this.label,
    required this.trailing,
    this.caption,
    this.onTap,
    this.last = false,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final Widget trailing;
  final String? caption;
  final VoidCallback? onTap;
  final bool last;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final tint = danger ? AppColors.loss : context.colors.text;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          border: last
              ? null
              : Border(bottom: BorderSide(color: context.colors.surfaceRaised)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: danger ? AppColors.loss : context.colors.muted),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: tint,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (caption != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      caption!,
                      style: TextStyle(color: context.colors.muted, fontSize: 11.5),
                    ),
                  ],
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.caption,
    this.last = false,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? caption;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return _RowFrame(
      icon: icon,
      label: label,
      caption: caption,
      last: last,
      onTap: () => onChanged(!value),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white,
        activeTrackColor: context.colors.brand,
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
    this.last = false,
    this.danger = false,
    this.chevron = true,
  });

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final bool last;
  final bool danger;
  final bool chevron;

  @override
  Widget build(BuildContext context) {
    return _RowFrame(
      icon: icon,
      label: label,
      last: last,
      danger: danger,
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            ConstrainedBox(
              // Long unit names would otherwise shove the label off the row.
              constraints: const BoxConstraints(maxWidth: 130),
              child: Text(
                value!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: TextStyle(color: context.colors.muted, fontSize: 13),
              ),
            ),
          if (chevron)
            Icon(Icons.chevron_right, size: 20, color: context.colors.muted),
        ],
      ),
    );
  }
}
