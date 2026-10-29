/// Settings.
///
/// A short main screen that leads to the long ones. Everything that needs a
/// paragraph of its own — what people may do to you, what you are told
/// about, what happens to your data — is a screen rather than a row, because
/// those are decisions rather than switches.
///
/// Two kinds of setting live here and they behave differently. Appearance,
/// units and the two duel switches belong to this phone and are kept in
/// local storage. Everything under privacy belongs to the server, because
/// the server is what enforces it: hiding somebody from a board, refusing to
/// hand their set to a stranger and declining to write a notice they did not
/// want are all decisions made where the phone cannot reach.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../backend/backend.dart';
import '../country_names.dart';
import '../data.dart';
import '../health_sync.dart';
import '../l10n/app_localizations.dart';
import '../push.dart';
import '../rewards.dart';
import '../settings.dart';
import '../theme.dart';
import '../type_scale.dart';
import '../username_rules.dart';
import '../widgets.dart';
import 'auth_entry.dart';
import 'country_picker.dart';
import 'leave_account.dart';
import 'settings_account.dart';
import 'settings_notices.dart';
import 'settings_parts.dart';
import 'settings_privacy.dart';
import 'username_editor.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _set(VoidCallback change) => settings.update(change);

  /// Asked for when turned on, not before: the phone's own prompt says what
  /// is shared, and turning it off asks nothing.
  Future<void> _setHealth(bool on) async {
    if (!on) {
      _set(() => settings.saveToHealth = false);
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    final l = L.of(context);
    final allowed = await HealthSync.connect();
    if (!mounted) return;
    if (allowed) {
      _set(() => settings.saveToHealth = true);
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.healthNotAllowed),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Opens a screen and rebuilds on the way back, so a row's summary catches
  /// up with whatever was changed behind it.
  /// When this account's country can change again, or null when it can now.
  /// The fourteen days hold only once the account has an email, as the
  /// name's do.
  DateTime? _countryNext(RemoteProfile me) =>
      backend.hasRealAccount ? usernameNextChange(me.countryChangedAt) : null;

  Future<void> _changeCountry() async {
    final l = L.of(context);
    final messenger = ScaffoldMessenger.of(context);
    void say(String text) => messenger.showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
    final me = backend.me;
    if (me == null) return;
    if (_countryNext(me) case final next?) {
      say(usernameChangeAgainText(l, next));
      return;
    }
    final picked = await showCountryPicker(context, selected: me.country);
    if (picked == null || picked == me.country || !mounted) return;
    try {
      final result = await backend.setMyCountry(picked);
      if (!mounted) return;
      switch (result) {
        case CountryResult.ok:
          demoProfile.country = picked;
          setState(() {});
          say(l.countryChanged);
        case CountryResult.tooSoon:
          say(l.countryEvery14);
        case CountryResult.invalid:
          say(l.countryNotSaved);
      }
    } on Object catch (_) {
      if (mounted) say(l.cantReachServer);
    }
  }

  Future<void> _open(Widget screen) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final prefs = backend.me?.prefs;

    return Scaffold(
      appBar: AppBar(title: Text(l.settings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          // First, and a card of its own: App Review asks that an app using
          // HealthKit says so plainly where people can see it, and a switch
          // among the duel's sounds and vibration was not that (2.5.1,
          // October 2026). A browser has no Health to save to, and on Android
          // the app no longer offers Health Connect at all.
          if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS)
            _HealthCard(onChanged: _setHealth),

          SettingsSection(
            title: l.accountSection,
            children: [
              if (backend.me case final me?) ...[
                NavRow(
                  key: const Key('usernameRow'),
                  icon: Icons.alternate_email,
                  label: l.usernameLabel,
                  value: me.username,
                  onTap: () async {
                    await showUsernameEditor(context);
                    if (mounted) setState(() {});
                  },
                ),
                NavRow(
                  key: const Key('countryRow'),
                  icon: Icons.public,
                  label: l.countryLabel,
                  value: me.country == null
                      ? null
                      : '${countryFlag(me.country!)} '
                            '${countryName(context, me.country!)}',
                  caption: switch (_countryNext(me)) {
                    final next? => usernameChangeAgainText(l, next),
                    null => l.countryEvery14,
                  },
                  onTap: _changeCountry,
                ),
              ],
              if (backend.hasRealAccount) ...[
                NavRow(
                  icon: Icons.verified_user_outlined,
                  label: l.signedInAs(backend.accountEmail ?? ''),
                  chevron: false,
                ),
                // Only for an account with an email: signing out of one
                // without is losing it, with no way back in.
                NavRow(
                  key: const Key('signOut'),
                  icon: Icons.logout,
                  label: l.signOut,
                  onTap: _signOut,
                  last: true,
                ),
              ] else
                NavRow(
                  icon: Icons.person_add_alt_1,
                  label: l.createAccountTitle,
                  caption: l.createAccountBody,
                  onTap: () => _open(const AuthEntryScreen()),
                  last: true,
                ),
            ],
          ),

          SettingsSection(
            title: l.duelSection,
            children: [
              SwitchRow(
                icon: Icons.vibration,
                label: l.hapticsEachRep,
                value: settings.vibration,
                onChanged: (v) => _set(() => settings.vibration = v),
              ),
              SwitchRow(
                key: const Key('soundsSwitch'),
                icon: Icons.volume_up_outlined,
                label: l.soundsLabel,
                caption: l.soundsHint,
                value: settings.sounds,
                onChanged: (v) => _set(() => settings.sounds = v),
              ),
              SwitchRow(
                icon: Icons.accessibility_new,
                label: l.showSkeleton,
                caption: l.showSkeletonHint,
                value: settings.showSkeleton,
                onChanged: (v) => _set(() => settings.showSkeleton = v),
                last: true,
              ),
            ],
          ),

          SettingsSection(
            title: l.notifications,
            children: [
              NavRow(
                icon: Icons.notifications_none,
                label: l.manageNotifications,
                value: prefs == null
                    ? null
                    : l.switchesOn(
                        localNumber(context, prefs.noticesOn),
                        localNumber(context, RemotePrefs.noticeCount),
                      ),
                onTap: () => _open(const NoticeSettingsScreen()),
                last: true,
              ),
            ],
          ),

          SettingsSection(
            title: l.privacy,
            children: [
              NavRow(
                icon: Icons.shield_outlined,
                label: l.whoCanChallenge,
                value: prefs?.challengeable.label(l),
                onTap: () => _open(const PrivacyScreen()),
              ),
              NavRow(
                icon: Icons.block,
                label: l.blockedAccounts,
                onTap: () => _open(const BlockedScreen()),
              ),
              NavRow(
                icon: Icons.flag_outlined,
                label: l.reportProblem,
                onTap: () => _open(const ReportScreen()),
                last: true,
              ),
            ],
          ),
          // The claim sits under the safety section because this is the
          // screen where somebody is deciding how much of themselves to hand
          // over, and it is the answer to the question they are asking.
          _Note(l.onDeviceNote),

          SettingsSection(
            title: l.data,
            children: [
              NavRow(
                icon: Icons.download_outlined,
                label: l.exportData,
                onTap: () => _open(const DownloadDataScreen()),
              ),
              NavRow(
                icon: Icons.delete_outline,
                label: l.deleteAccount,
                danger: true,
                onTap: () => _open(const DeleteAccountScreen()),
                last: true,
              ),
            ],
          ),

          SettingsSection(
            title: l.appearance,
            children: [
              NavRow(
                icon: settings.themeMode.icon,
                label: l.theme,
                value: settings.themeMode.label(l),
                onTap: () async {
                  await pickOne<ThemeMode>(
                    context: context,
                    title: l.theme,
                    values: ThemeMode.values,
                    current: settings.themeMode,
                    label: (v) => v.label(l),
                    icon: (v) => v.icon,
                    onPick: (v) => _set(() => settings.themeMode = v),
                  );
                  if (mounted) setState(() {});
                },
              ),
              NavRow(
                icon: Icons.translate,
                label: l.language,
                value: settings.language.label(l),
                onTap: () async {
                  await pickOne<AppLanguage>(
                    context: context,
                    title: l.language,
                    values: AppLanguage.values,
                    current: settings.language,
                    label: (v) => v.label(l),
                    onPick: (v) => _set(() => settings.language = v),
                  );
                  if (mounted) setState(() {});
                },
                last: true,
              ),
            ],
          ),

          SettingsSection(
            title: l.about,
            children: [
              NavRow(
                icon: Icons.policy_outlined,
                label: l.privacyPolicy,
                onTap: () => _openUrl('https://www.outrepd.com/privacy'),
              ),
              NavRow(
                icon: Icons.description_outlined,
                label: l.termsOfService,
                onTap: () => _openUrl('https://www.outrepd.com/terms'),
              ),
              NavRow(
                icon: Icons.support_agent,
                label: l.contactSupport,
                onTap: () => _openUrl('mailto:$kSupportEmail'),
              ),
              // Android only until the App Store has a listing to point at:
              // Apple's link needs the app's number, which it does not have
              // until the first submission.
              if (Theme.of(context).platform == TargetPlatform.android ||
                  kAppStoreId.isNotEmpty)
                NavRow(
                  icon: Icons.star_outline,
                  label: l.rateApp,
                  onTap: () => _openUrl(
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? 'https://apps.apple.com/app/id$kAppStoreId?action=write-review'
                        : 'https://play.google.com/store/apps/details?id=$kAndroidPackage',
                  ),
                ),
              NavRow(
                icon: Icons.code,
                label: l.openSourceLicences,
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: 'OUTREPD',
                ),
                last: true,
              ),
            ],
          ),

          Center(
            child: Text(
              '${l.version} $appVersionLabel',
              style: TextStyle(color: context.colors.faint, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  /// Signs out, and leaves the phone as a fresh install leaves it: on the
  /// welcome screen, with a new session behind it so that signing up again
  /// works as it did the first time. The account itself is untouched on the
  /// server — rank, history and subscription wait for the next sign-in.
  Future<void> _signOut() async {
    final l = L.of(context);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final sure = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(l.signOutQuestion),
        content: Text(l.signOutBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialog).pop(false),
            child: Text(l.cancel),
          ),
          TextButton(
            key: const Key('confirmSignOut'),
            onPressed: () => Navigator.of(dialog).pop(true),
            child: Text(l.signOut),
          ),
        ],
      ),
    );
    if (sure != true || !mounted) return;

    // While still signed in: the server only lets an account forget its own
    // phones.
    await Push.instance.stop();
    // And the titles and streak, so the account has what this phone has.
    await rewards.push();
    try {
      await backend.signOut();
    } on Object catch (error) {
      debugPrint('Could not sign out: $error');
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.cantReachServer),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    await leaveForWelcome(navigator);
  }

  Future<void> _openUrl(String url) async {
    final messenger = ScaffoldMessenger.of(context);
    final l = L.of(context);
    try {
      final opened = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!opened) throw StateError('launchUrl returned false');
    } on Object catch (error) {
      debugPrint('Could not open $url: $error');
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.couldNotOpenLink),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

/// The small print under a section.
class _Note extends StatelessWidget {
  const _Note(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 0, 4, 22),
    child: Text(
      text,
      style: TextStyle(color: context.colors.faint, fontSize: 13, height: 1.55),
    ),
  );
}

/// Apple Health on an iPhone, Health Connect on Android: a card of its own at
/// the top of Settings, saying what the app does with it before the switch
/// that turns it on.
class _HealthCard extends StatelessWidget {
  const _HealthCard({required this.onChanged});

  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final name = HealthSync.name;
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Container(
        key: const Key('healthCard'),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 6),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.colors.surfaceRaised),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const HealthMark(size: 46),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: context.type.heading.copyWith(
                          color: context.colors.text,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        l.healthWorksWith(name),
                        style: context.type.label.copyWith(
                          color: context.colors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              l.healthCardBody(name),
              style: context.type.label.copyWith(
                color: context.colors.text.withValues(alpha: 0.78),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 14),
            Divider(height: 1, color: context.colors.surfaceRaised),
            InkWell(
              key: const Key('healthSwitch'),
              onTap: () => onChanged(!settings.saveToHealth),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        defaultTargetPlatform == TargetPlatform.iOS
                            ? l.saveToAppleHealth
                            : l.saveToHealthConnect,
                        style: context.type.body.copyWith(
                          color: context.colors.text,
                        ),
                      ),
                    ),
                    Switch(
                      value: settings.saveToHealth,
                      onChanged: onChanged,
                      activeThumbColor: Colors.white,
                      activeTrackColor: context.colors.brand,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
