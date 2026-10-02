/// Taking everything with you, and leaving.
///
/// Both screens make a promise in writing, and both promises are checked by
/// `test/safety_server_test.dart` against the real database rather than
/// taken on trust:
///
///   * the export holds no pose landmarks, because landmarks never leave the
///     phone. There is nothing of them on any server to hand back;
///   * deleting is one statement and it cascades. Nothing is kept.
///
/// The address is asked for here rather than stored on the profile: most
/// accounts are still anonymous, tied to one phone rather than an email, and
/// an account that has since added one (see `settings.dart`'s account
/// section) should not have its export silently switch to it — a person
/// typing the address themselves always knows where the file is going.
library;

import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../l10n/app_localizations.dart';
import '../push.dart';
import '../theme.dart';
import '../widgets.dart';
import 'leave_account.dart';
import 'settings_parts.dart';

// ──────────────────────────── download my data ───────────────────────────────

class DownloadDataScreen extends StatefulWidget {
  const DownloadDataScreen({super.key});

  @override
  State<DownloadDataScreen> createState() => _DownloadDataScreenState();
}

class _DownloadDataScreenState extends State<DownloadDataScreen> {
  // The account's own address, already in: it is the only one the export
  // goes to (functions/email-my-data), so asking for it would be asking the
  // lifter to type the one answer that works.
  final _address = TextEditingController(text: backend.accountEmail ?? '');
  bool _sending = false;
  bool _sent = false;

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final to = _address.text.trim();
    if (to.isEmpty || _sending) return;

    final l = L.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _sending = true);

    try {
      await backend.emailMyData(to);
      if (mounted) setState(() => _sent = true);
    } on Object catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.needsServer),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.exportData)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 18),
                  child: Text(
                    l.exportIntro,
                    style: TextStyle(
                      color: context.colors.muted,
                      fontSize: 12,
                      height: 1.65,
                    ),
                  ),
                ),

                SettingsSection(
                  title: l.whatsIncluded,
                  children: [
                    for (final line in [
                      l.incProfile,
                      l.incSets,
                      l.incDuels,
                      l.incFriends,
                      l.incNotices,
                    ])
                      NavRow(
                        icon: Icons.check,
                        label: line,
                        chevron: false,
                        last: line == l.incNotices,
                      ),
                  ],
                ),

                // The one thing worth saying about what is *not* in it.
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: context.colors.border,
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 15,
                        color: context.colors.muted,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l.noLandmarksNote,
                          style: TextStyle(
                            color: context.colors.muted,
                            fontSize: 11,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Text(
                  l.sendItTo,
                  style: TextStyle(color: context.colors.muted, fontSize: 11),
                ),
                const SizedBox(height: 7),
                TextField(
                  controller: _address,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  onChanged: (_) => setState(() => _sent = false),
                  style: TextStyle(color: context.colors.text, fontSize: 14),
                  cursorColor: context.colors.brand,
                  decoration: InputDecoration(
                    hintText: l.emailHint,
                    hintStyle: TextStyle(
                      color: context.colors.faint,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: context.colors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                  ),
                ),
                // Asked for rather than remembered: this account has no email
                // on it, and one typed here to receive a file is not a reason
                // to start keeping one.
                const SizedBox(height: 7),
                Text(
                  l.addressNotKept,
                  style: TextStyle(color: context.colors.faint, fontSize: 11),
                ),

                if (_sent) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 16,
                        color: context.colors.brand,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l.exportSent(_address.text.trim()),
                          style: TextStyle(
                            color: context.colors.text,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _address.text.trim().isEmpty || _sending
                      ? null
                      : _send,
                  child: Text(l.requestMyData),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────── delete account ────────────────────────────────

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _typed = TextEditingController();
  AccountSummary? _summary;
  bool _deleting = false;
  bool _summaryFailed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _typed.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (!backend.available) return;
    try {
      final summary = await backend.accountSummary();
      if (mounted) setState(() => _summary = summary);
    } on Object catch (_) {
      // Shown without the figures rather than not shown — and not blocked
      // either. Somebody who came here to leave should not be stopped by a
      // failed read. The flag exists only so the empty space says why it is
      // empty, instead of looking like the screen forgot to draw something.
      if (mounted) setState(() => _summaryFailed = true);
    }
  }

  Future<void> _delete() async {
    final l = L.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() => _deleting = true);

    try {
      // The server drops the account's phones with it; this also drops the
      // address on the phone, so the next account here starts clean. If the
      // delete then fails, the next launch registers again.
      await Push.instance.stop();
      await backend.deleteAccount();
    } on Object catch (_) {
      if (!mounted) return;
      setState(() => _deleting = false);
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.needsServer),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    // Gone from the server: the phone goes back to how a fresh install is,
    // exactly as signing out leaves it.
    await leaveForWelcome(navigator);
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final summary = _summary;
    final word = l.deleteWord;
    final armed = _typed.text.trim().toUpperCase() == word.toUpperCase();

    return Scaffold(
      appBar: AppBar(title: Text(l.deleteAccount)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 18),
                  child: Text(
                    l.deleteIntro,
                    style: TextStyle(
                      color: context.colors.muted,
                      fontSize: 12,
                      height: 1.65,
                    ),
                  ),
                ),

                // Read back from the server rather than from whatever the
                // profile screen is showing: a confirmation quoting figures
                // the phone supplied confirms whatever the phone felt like
                // saying.
                if (summary != null)
                  Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: context.colors.border,
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        _Lost(
                          label: l.rankLabel,
                          value: summary.ranked
                              ? '${tierLabel(l, summary.tierIdx, summary.divIdx)}'
                                    ' · ${l.lpAmount(localNumber(context, summary.lp))}'
                              : l.unranked,
                        ),
                        _Lost(
                          label: l.totalReps,
                          value: localNumber(context, summary.totalReps),
                        ),
                        _Lost(
                          label: l.bestSet,
                          value: localNumber(context, summary.bestSet),
                        ),
                        _Lost(
                          label: l.tabFriends,
                          value: localNumber(context, summary.friends),
                          last: true,
                        ),
                      ],
                    ),
                  )
                else if (_summaryFailed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      l.couldNotLoadProfile,
                      style: TextStyle(color: context.colors.faint, fontSize: 11),
                    ),
                  ),

                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.colors.surface,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(
                      color: context.colors.border,
                      width: 0.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.wantCopyFirst,
                        style: TextStyle(
                          color: context.colors.text,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l.wantCopyBody,
                        style: TextStyle(
                          color: context.colors.muted,
                          fontSize: 11,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const DownloadDataScreen(),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(11),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            l.exportData,
                            style: TextStyle(
                              color: context.colors.brand,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // The store bills the subscription, so deleting the account
                // does not stop it — and the stores expect an app to say so
                // before the account goes.
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 14, 4, 0),
                  child: Text(
                    l.deleteKeepsSubscription,
                    key: const Key('deleteKeepsSubscription'),
                    style: TextStyle(
                      color: context.colors.muted,
                      fontSize: 12,
                      height: 1.65,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Text(
                  l.typeToConfirm(word),
                  style: TextStyle(color: context.colors.muted, fontSize: 11),
                ),
                const SizedBox(height: 7),
                TextField(
                  controller: _typed,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (_) => setState(() {}),
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: 14,
                    letterSpacing: 1,
                  ),
                  cursorColor: context.colors.rival,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: context.colors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(color: context.colors.rival),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: context.colors.rival,
                        foregroundColor: context.colors.background,
                        disabledBackgroundColor: context.colors.surfaceRaised,
                      ),
                      onPressed: !armed || _deleting
                          ? null
                          : () => confirm(
                              context: context,
                              title: l.deleteAccount,
                              body: l.deleteIntro,
                              action: l.deletePermanently,
                              onConfirm: _delete,
                            ),
                      child: Text(l.deletePermanently),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      l.keepMyAccount,
                      style: TextStyle(color: context.colors.muted),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Lost extends StatelessWidget {
  const _Lost({required this.label, required this.value, this.last = false});

  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(bottom: last ? 0 : 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: context.colors.muted, fontSize: 12),
        ),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: context.colors.text, fontSize: 12),
          ),
        ),
      ],
    ),
  );
}
