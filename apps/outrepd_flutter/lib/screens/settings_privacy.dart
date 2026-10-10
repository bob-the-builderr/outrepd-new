/// Who may reach you, who may see you, and what to do about somebody who
/// should be neither.
///
/// Three screens, all of them promises the server keeps rather than the
/// phone: `find_opponent_set` refuses to hand your set to somebody you have
/// shut out, and `leaderboard()` leaves you off the board. The switches here
/// only say what you asked for — a preference the client enforces is a
/// preference anybody with the APK can skip.
library;

import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../l10n/app_localizations.dart';
import '../settings.dart';
import '../theme.dart';
import '../widgets.dart';
import 'settings_parts.dart';

// ──────────────────────────── privacy and safety ─────────────────────────────

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  late RemotePrefs _prefs = backend.me?.prefs ?? const RemotePrefs();
  bool _saving = false;

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
        title: Text(l.privacy),
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
            title: l.whoCanChallenge,
            children: [
              for (final who in Challengeable.values)
                NavRow(
                  icon: switch (who) {
                    Challengeable.everyone => Icons.public,
                    Challengeable.friends => Icons.people_outline,
                    Challengeable.nobody => Icons.do_not_disturb_on_outlined,
                  },
                  label: who.label(l),
                  chevron: false,
                  value: _prefs.challengeable == who ? '✓' : null,
                  onTap: () => _change(_prefs.copyWith(challengeable: who)),
                  last: who == Challengeable.values.last,
                ),
            ],
          ),

          SettingsSection(
            title: l.visibilitySection,
            children: [
              SwitchRow(
                icon: Icons.leaderboard_outlined,
                label: l.showOnLeaderboards,
                value: _prefs.showOnBoard,
                onChanged: (v) => _change(_prefs.copyWith(showOnBoard: v)),
              ),
              SwitchRow(
                icon: Icons.flag_outlined,
                label: l.showMyCountry,
                caption: l.showMyCountryHint,
                value: _prefs.showCountry,
                onChanged: (v) => _change(_prefs.copyWith(showCountry: v)),
                last: true,
              ),
            ],
          ),

          SettingsSection(
            title: l.safetySection,
            children: [
              NavRow(
                icon: Icons.block,
                label: l.blockedAccounts,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BlockedScreen()),
                ),
              ),
              NavRow(
                icon: Icons.flag_outlined,
                label: l.reportProblem,
                onTap: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const ReportScreen())),
                last: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────── blocked accounts ───────────────────────────────

class BlockedScreen extends StatefulWidget {
  const BlockedScreen({super.key});

  @override
  State<BlockedScreen> createState() => _BlockedScreenState();
}

class _BlockedScreenState extends State<BlockedScreen> {
  List<BlockedLifter> _blocked = const [];
  bool _loading = false;
  bool _loadFailed = false;

  @override
  void initState() {
    super.initState();
    if (backend.available) _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadFailed = false;
    });
    try {
      final blocked = await backend.blocked();
      if (mounted) setState(() => _blocked = blocked);
    } on Object catch (_) {
      // An empty list and a list nobody could fetch look the same on this
      // screen's own terms — nobody's unblockable either way — but the flag
      // still earns its own message and a way to try again, rather than
      // reading as a confirmed "nobody blocked" that a retry never fixes.
      if (mounted) setState(() => _loadFailed = true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _unblock(BlockedLifter who) async {
    try {
      await backend.unblock(who.id);
      await _load();
    } on Object catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L.of(context).notSaved),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.blockedAccounts)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
            child: Text(
              l.blockedIntro,
              style: TextStyle(
                color: context.colors.muted,
                fontSize: 12,
                height: 1.6,
              ),
            ),
          ),
          if (_loading && _blocked.isEmpty)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_loadFailed && _blocked.isEmpty)
            Expanded(
              child: EmptyState(
                icon: Icons.error_outline,
                title: l.couldNotLoadProfile,
                body: l.noBlockedBody,
                action: OutlinedButton(onPressed: _load, child: Text(l.retry)),
              ),
            )
          else if (_blocked.isEmpty)
            Expanded(
              child: EmptyState(
                icon: Icons.block,
                title: l.noBlockedTitle,
                body: l.noBlockedBody,
              ),
            )
          else
            Expanded(
              child: RefreshIndicator(
                onRefresh: _load,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                  itemCount: _blocked.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 7),
                  itemBuilder: (context, i) => _BlockedRow(
                    who: _blocked[i],
                    onUnblock: () => _unblock(_blocked[i]),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BlockedRow extends StatelessWidget {
  const _BlockedRow({required this.who, required this.onUnblock});

  final BlockedLifter who;
  final VoidCallback onUnblock;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: context.colors.border, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.colors.surfaceRaised,
            ),
            child: Text(
              who.username.isEmpty
                  ? '?'
                  : who.username.characters.first.toUpperCase(),
              style: TextStyle(color: context.colors.muted, fontSize: 13),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  who.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: context.colors.text, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  l.blockedWhen(
                    relativeDays(
                      context,
                      DateTime.now().difference(who.at).inDays,
                    ),
                  ),
                  style: TextStyle(color: context.colors.muted, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: onUnblock,
            borderRadius: BorderRadius.circular(11),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                border: Border.all(color: context.colors.border, width: 0.5),
              ),
              child: Text(
                l.unblock,
                style: TextStyle(color: context.colors.text, fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────── reporting ──────────────────────────────────

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key, this.aboutId, this.aboutName});

  /// Who is being reported, when the screen was opened from their row. Null
  /// when it was opened from settings, which is somebody reporting the app
  /// rather than a person.
  final String? aboutId;
  final String? aboutName;

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  ReportReason? _reason;
  final _details = TextEditingController();
  bool _alsoBlock = true;
  bool _sending = false;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final reason = _reason;
    if (reason == null || _sending) return;

    final l = L.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() => _sending = true);

    try {
      await backend.report(
        aboutId: widget.aboutId,
        reason: reason,
        details: _details.text.trim(),
      );
      if (widget.aboutId case final id? when _alsoBlock) {
        await backend.block(id);
      }
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.reportSent),
          behavior: SnackBarBehavior.floating,
        ),
      );
      navigator.pop();
    } on Object catch (error) {
      if (!mounted) return;
      setState(() => _sending = false);
      messenger.showSnackBar(
        SnackBar(
          content: Text(error is RateLimited ? l.tooOften : l.needsServer),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.reportProblem)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              children: [
                if (widget.aboutName case final name?)
                  Container(
                    margin: const EdgeInsets.only(bottom: 18),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(
                        color: context.colors.border,
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.colors.surfaceRaised,
                          ),
                          child: Text(
                            name.isEmpty
                                ? '?'
                                : name.characters.first.toUpperCase(),
                            style: TextStyle(
                              color: context.colors.text,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  color: context.colors.text,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                l.reportingThisAccount,
                                style: TextStyle(
                                  color: context.colors.muted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                SettingsSection(
                  title: l.whatHappened,
                  children: [
                    for (final reason in ReportReason.values)
                      NavRow(
                        icon: _reason == reason
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        label: _reasonLabel(l, reason),
                        chevron: false,
                        onTap: () => setState(() => _reason = reason),
                        last: reason == ReportReason.values.last,
                      ),
                  ],
                ),

                TextField(
                  controller: _details,
                  maxLines: 4,
                  maxLength: 1000,
                  style: TextStyle(color: context.colors.text, fontSize: 13),
                  cursorColor: context.colors.brand,
                  decoration: InputDecoration(
                    hintText: l.addDetails,
                    hintStyle: TextStyle(
                      color: context.colors.faint,
                      fontSize: 13,
                    ),
                    filled: true,
                    fillColor: context.colors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13),
                      borderSide: BorderSide(color: context.colors.border),
                    ),
                  ),
                ),

                if (widget.aboutId != null)
                  CheckboxListTile(
                    value: _alsoBlock,
                    onChanged: (v) => setState(() => _alsoBlock = v ?? false),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      l.alsoBlock,
                      style: TextStyle(
                        color: context.colors.text,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _reason == null || _sending ? null : _send,
                  child: Text(l.sendReport),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _reasonLabel(L l, ReportReason reason) => switch (reason) {
    ReportReason.cheating => l.reasonCheating,
    ReportReason.harassment => l.reasonHarassment,
    ReportReason.content => l.reasonContent,
    ReportReason.impersonation => l.reasonImpersonation,
    ReportReason.other => l.reasonOther,
  };
}
