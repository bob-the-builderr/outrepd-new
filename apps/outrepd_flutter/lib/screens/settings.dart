import 'package:flutter/material.dart';

import '../settings.dart';
import '../l10n/app_localizations.dart';
import '../type_scale.dart';
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

  /// Everything on this screen that would need an account behind it says the
  /// same thing, so it says it once.
  void _todo() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(L.of(context).needsServer)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          _Section(
            title: l.appearance,
            children: [
              _NavRow(
                icon: settings.themeMode.icon,
                label: l.theme,
                value: settings.themeMode.label(l),
                onTap: _pickTheme,
              ),
              // The quick toggle people actually look for, next to the full
              // three-way picker above it.
              _SwitchRow(
                icon: Icons.dark_mode_outlined,
                label: l.darkMode,
                caption: settings.themeMode == ThemeMode.system
                    ? l.followingDevice
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
                label: l.language,
                value: settings.language.label(l),
                onTap: _pickLanguage,
                last: true,
              ),
            ],
          ),
          _Section(
            title: l.units,
            children: [
              _NavRow(
                icon: Icons.monitor_weight_outlined,
                label: l.weight,
                value: settings.weightUnit.label(l),
                onTap: () => _pick<WeightUnit>(
                  title: l.weightUnitTitle,
                  values: WeightUnit.values,
                  current: settings.weightUnit,
                  label: (v) => v.label(l),
                  onPick: (v) => _set(() => settings.weightUnit = v),
                ),
              ),
              _NavRow(
                icon: Icons.straighten,
                label: l.height,
                value: settings.heightUnit.label(l),
                onTap: () => _pick<HeightUnit>(
                  title: l.heightUnitTitle,
                  values: HeightUnit.values,
                  current: settings.heightUnit,
                  label: (v) => v.label(l),
                  onPick: (v) => _set(() => settings.heightUnit = v),
                ),
                last: true,
              ),
            ],
          ),
          _Section(
            title: l.notifications,
            children: [
              _SwitchRow(
                icon: Icons.sports_mma_outlined,
                label: l.matchInvites,
                value: settings.notifyMatchInvites,
                onChanged: (v) => _set(() => settings.notifyMatchInvites = v),
              ),
              _SwitchRow(
                icon: Icons.emoji_events_outlined,
                label: l.matchResults,
                value: settings.notifyMatchResults,
                onChanged: (v) => _set(() => settings.notifyMatchResults = v),
              ),
              _SwitchRow(
                icon: Icons.person_add_alt_outlined,
                label: l.friendRequestsLabel,
                value: settings.notifyFriendRequests,
                onChanged: (v) => _set(() => settings.notifyFriendRequests = v),
              ),
              _SwitchRow(
                icon: Icons.groups_2_outlined,
                label: l.crewActivity,
                value: settings.notifyCrewActivity,
                onChanged: (v) => _set(() => settings.notifyCrewActivity = v),
              ),
              _SwitchRow(
                icon: Icons.trending_up,
                label: l.rankChanges,
                value: settings.notifyRankChanges,
                onChanged: (v) => _set(() => settings.notifyRankChanges = v),
              ),
              _SwitchRow(
                icon: Icons.calendar_month_outlined,
                label: l.weeklySummary,
                value: settings.notifyWeeklySummary,
                onChanged: (v) => _set(() => settings.notifyWeeklySummary = v),
              ),
              _SwitchRow(
                icon: Icons.volume_up_outlined,
                label: l.soundLabel,
                value: settings.sound,
                onChanged: (v) => _set(() => settings.sound = v),
              ),
              _SwitchRow(
                icon: Icons.vibration,
                label: l.vibration,
                value: settings.vibration,
                onChanged: (v) => _set(() => settings.vibration = v),
                last: true,
              ),
            ],
          ),
          _Section(
            title: l.privacy,
            children: [
              _NavRow(
                icon: Icons.visibility_outlined,
                label: l.whoCanSeeProfile,
                value: settings.visibility.label(l),
                onTap: () => _pick<ProfileVisibility>(
                  title: l.profileVisibility,
                  values: ProfileVisibility.values,
                  current: settings.visibility,
                  label: (v) => v.label(l),
                  caption: (v) => v.description(l),
                  onPick: (v) => _set(() => settings.visibility = v),
                ),
              ),
              _SwitchRow(
                icon: Icons.leaderboard_outlined,
                label: l.showOnLeaderboards,
                value: settings.showOnLeaderboard,
                onChanged: (v) => _set(() => settings.showOnLeaderboard = v),
              ),
              _SwitchRow(
                icon: Icons.mail_outline,
                label: l.allowMatchInvites,
                value: settings.allowMatchInvites,
                onChanged: (v) => _set(() => settings.allowMatchInvites = v),
              ),
              _SwitchRow(
                icon: Icons.person_add_alt_1_outlined,
                label: l.allowFriendRequests,
                value: settings.allowFriendRequests,
                onChanged: (v) => _set(() => settings.allowFriendRequests = v),
              ),
              _SwitchRow(
                icon: Icons.accessibility_new,
                label: l.showHeightWeight,
                caption: l.showHeightWeightHint,
                value: settings.showBodyStats,
                onChanged: (v) => _set(() => settings.showBodyStats = v),
                last: true,
              ),
            ],
          ),
          _Section(
            title: l.matches,
            children: [
              _SwitchRow(
                icon: Icons.bolt_outlined,
                label: l.autoAcceptFriends,
                value: settings.autoAcceptFriendMatches,
                onChanged: (v) =>
                    _set(() => settings.autoAcceptFriendMatches = v),
              ),
              _SwitchRow(
                icon: Icons.timer_outlined,
                label: l.restTimerBetweenSets,
                value: settings.restTimer,
                onChanged: (v) => _set(() => settings.restTimer = v),
                last: true,
              ),
            ],
          ),
          _Section(
            title: l.data,
            children: [
              _NavRow(
                icon: Icons.download_outlined,
                label: l.exportData,
                onTap: _todo,
              ),
              _NavRow(
                icon: Icons.cleaning_services_outlined,
                label: l.clearCache,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l.cacheCleared)),
                  );
                },
                last: true,
              ),
            ],
          ),
          _Section(
            title: l.about,
            children: [
              _NavRow(
                icon: Icons.info_outline,
                label: l.version,
                value: '1.0.0',
                chevron: false,
              ),
              _NavRow(
                icon: Icons.star_outline,
                label: l.rateApp,
                onTap: _todo,
              ),
              _NavRow(
                icon: Icons.support_agent_outlined,
                label: l.contactSupport,
                onTap: _todo,
              ),
              _NavRow(
                icon: Icons.description_outlined,
                label: l.termsOfService,
                onTap: _todo,
              ),
              _NavRow(
                icon: Icons.privacy_tip_outlined,
                label: l.privacyPolicy,
                onTap: _todo,
              ),
              _NavRow(
                icon: Icons.article_outlined,
                label: l.openSourceLicences,
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
            title: l.dangerZone,
            children: [
              _NavRow(
                icon: Icons.restart_alt,
                label: l.resetProgress,
                danger: true,
                onTap: () => _confirm(
                  title: l.resetProgressTitle,
                  body: l.resetProgressBody,
                  action: l.actionReset,
                  onConfirm: _todo,
                ),
              ),
              _NavRow(
                icon: Icons.delete_outline,
                label: l.deleteAccount,
                danger: true,
                last: true,
                onTap: () => _confirm(
                  title: l.deleteAccountTitle,
                  body: l.deleteAccountBody,
                  action: l.actionDelete,
                  onConfirm: _todo,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'OUTREPD · 1.0.0',
              style: context.type.label.copyWith(color: context.colors.muted),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTheme() => _pick<ThemeMode>(
        title: L.of(context).theme,
        values: ThemeMode.values,
        current: settings.themeMode,
        label: (v) => v.label(L.of(context)),
        icon: (v) => v.icon,
        onPick: (v) => _set(() => settings.themeMode = v),
      );

  Future<void> _pickLanguage() => _pick<AppLanguage>(
        title: L.of(context).language,
        values: AppLanguage.values,
        current: settings.language,
        label: (v) => v.label(L.of(context)),
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
      // The language list is fifteen entries long. Without this the sheet
      // stops at half the screen and the bottom half of the list is
      // unreachable — you cannot pick Japanese at all.
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
                child: Text(
                  title,
                  style: context.type.heading.copyWith(color: context.colors.text),
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 10),
                  children: [
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
                            context.type.label.copyWith(color: context.colors.muted),
                      ),
                trailing: v == current
                    ? Icon(Icons.check_circle, color: context.colors.brand)
                    : null,
                onTap: () => Navigator.of(context).pop(v),
              ),
                  ],
                ),
              ),
            ],
          ),
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
            child: Text(L.of(context).cancel,
                style: TextStyle(color: context.colors.muted)),
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
                    style: context.type.body.copyWith(color: tint),
                  ),
                  if (caption != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      caption!,
                      style: context.type.label.copyWith(color: context.colors.muted),
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
                style: context.type.label.copyWith(color: context.colors.muted),
              ),
            ),
          if (chevron)
            Icon(Icons.chevron_right, size: 20, color: context.colors.muted),
        ],
      ),
    );
  }
}
