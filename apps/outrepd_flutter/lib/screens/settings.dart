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

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../backend/backend.dart';
import '../career.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../reps/count_accuracy.dart';
import '../settings.dart';
import '../subscription.dart';
import '../theme.dart';
import '../widgets.dart';
import 'auth_entry.dart';
import 'counter_accuracy.dart';
import 'onboarding.dart';
import 'settings_account.dart';
import 'settings_notices.dart';
import 'settings_parts.dart';
import 'settings_privacy.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _set(VoidCallback change) => settings.update(change);

  /// Opens a screen and rebuilds on the way back, so a row's summary catches
  /// up with whatever was changed behind it.
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
          SettingsSection(
            title: l.accountSection,
            children: [
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
                  icon: Icons.mail_outline,
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
                icon: Icons.insights_outlined,
                label: l.counterAccuracy,
                caption: l.counterAccuracyCaption,
                value: countAccuracy.sets == 0
                    ? null
                    : '${localNumber(context, percent(countAccuracy.exactRate))}%',
                onTap: () => _open(const CounterAccuracyScreen()),
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
            title: l.units,
            children: [
              NavRow(
                icon: Icons.monitor_weight_outlined,
                label: l.weight,
                value: settings.weightUnit.label(l),
                onTap: () async {
                  await pickOne<WeightUnit>(
                    context: context,
                    title: l.weightUnitTitle,
                    values: WeightUnit.values,
                    current: settings.weightUnit,
                    label: (v) => v.label(l),
                    onPick: (v) => _set(() => settings.weightUnit = v),
                  );
                  if (mounted) setState(() {});
                },
              ),
              NavRow(
                icon: Icons.straighten,
                label: l.height,
                value: settings.heightUnit.label(l),
                onTap: () async {
                  await pickOne<HeightUnit>(
                    context: context,
                    title: l.heightUnitTitle,
                    values: HeightUnit.values,
                    current: settings.heightUnit,
                    label: (v) => v.label(l),
                    onPick: (v) => _set(() => settings.heightUnit = v),
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
              style: TextStyle(color: context.colors.faint, fontSize: 12),
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
    await Subscription.instance.forget();
    // What this phone kept of the account — its rank and totals — is the
    // server's copy, and comes back with the next sign-in.
    await Career.instance.startFresh();
    await markNotOnboarded();
    try {
      await backend.signIn(username: 'lifter');
    } on Object catch (error) {
      // Offline: the welcome screen still opens, and signing in or up asks
      // the server again when it is used.
      debugPrint('Could not start a new session: $error');
    }

    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      (_) => false,
    );
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
      style: TextStyle(color: context.colors.faint, fontSize: 11, height: 1.55),
    ),
  );
}
