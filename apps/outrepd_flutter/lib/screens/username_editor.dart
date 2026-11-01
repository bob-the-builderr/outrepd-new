/// Renaming yourself: once every fourteen days (set_my_username,
/// supabase/account.sql), with the same live checks as the sign-up screen.
library;

import 'dart:async';

import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../type_scale.dart';
import '../theme.dart';
import '../username_rules.dart';

Future<void> showUsernameEditor(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) => const _UsernameEditorSheet(),
  );
}

class _UsernameEditorSheet extends StatefulWidget {
  const _UsernameEditorSheet();

  @override
  State<_UsernameEditorSheet> createState() => _UsernameEditorSheetState();
}

class _UsernameEditorSheetState extends State<_UsernameEditorSheet> {
  late final _controller = TextEditingController(text: demoProfile.username);
  Timer? _debounce;

  /// Null while nothing has been checked yet, or the field no longer matches
  /// what was last checked.
  bool? _available;
  bool _checking = false;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  /// When the name may change again, while it may not yet. The sheet says
  /// the day rather than offering a field nobody could save from.
  DateTime? get _nextChange =>
      usernameNextChange(backend.me?.usernameChangedAt);

  bool get _validFormat => usernameValid(_controller.text);

  bool get _unchanged => _controller.text == demoProfile.username;

  void _onChanged(String value) {
    setState(() {
      _available = null;
      _error = null;
    });
    _debounce?.cancel();
    if (!_validFormat || _unchanged || !backend.available) return;

    final checking = value;
    // A pause in typing, not every keystroke — asking the server once per
    // letter would make a rename screen the busiest thing this account ever
    // does to it.
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (!mounted) return;
      setState(() => _checking = true);
      try {
        final ok = await backend.usernameAvailable(checking);
        if (mounted && _controller.text == checking) {
          setState(() {
            _available = ok;
            _checking = false;
          });
        }
      } on Object catch (error) {
        debugPrint('Could not check username availability: $error');
        if (mounted && _controller.text == checking) {
          setState(() {
            _checking = false;
            _error = L.of(context).couldNotCheckUsername;
          });
        }
      }
    });
  }

  Future<void> _save() async {
    final l = L.of(context);
    final name = _controller.text;
    if (!_validFormat) {
      setState(() => _error = usernameProblem(l, name) ?? l.usernameInvalidLength);
      return;
    }
    if (_unchanged || _saving) return;

    if (!backend.available) {
      setState(() => _error = l.needsServer);
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final result = await backend.renameUsername(name);
      if (!mounted) return;
      switch (result) {
        case RenameResult.ok:
          rememberUsername(name);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.usernameChanged),
              behavior: SnackBarBehavior.floating,
            ),
          );
        case RenameResult.taken:
          setState(() {
            _saving = false;
            _available = false;
          });
        case RenameResult.invalid:
          setState(() {
            _saving = false;
            _error = l.usernameInvalidLength;
          });
        case RenameResult.notAllowed:
          setState(() {
            _saving = false;
            _error = l.usernameNotAllowed;
          });
        case RenameResult.alreadyChanged:
          // The client-side check missed it — another tab, another device,
          // or a sheet left open since before the last one landed. Refuse
          // rather than trust the screen's own stale idea of the rule.
          setState(() {
            _saving = false;
            final next = _nextChange;
            _error = next == null
                ? l.usernameAlreadyChangedBody
                : usernameChangeAgainText(l, next);
          });
      }
    } on Object catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = l.needsServer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    if (_nextChange case final next?) {
      return _AlreadyChangedSheet(heading: l.changeUsername, next: next);
    }
    final problem = usernameProblem(l, _controller.text);

    final canSave = _validFormat && !_unchanged && _available != false;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.changeUsername,
                style: context.type.heading.copyWith(
                  color: context.colors.text,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: context.colors.background,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _available == false || problem != null
                        ? AppColors.loss
                        : context.colors.brand,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      '@',
                      style: TextStyle(
                        color: context.colors.faint,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        autocorrect: false,
                        enableSuggestions: false,
                        inputFormatters: usernameFormatters,
                        onChanged: _onChanged,
                        style: TextStyle(
                          color: context.colors.text,
                          fontSize: 18,
                        ),
                        cursorColor: context.colors.brand,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    if (_checking)
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: context.colors.muted,
                        ),
                      )
                    else if (_available == true)
                      const Icon(Icons.check, size: 17, color: AppColors.win)
                    else if (_available == false)
                      const Icon(Icons.close, size: 17, color: AppColors.loss),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error ??
                    problem ??
                    (_available == false
                        ? l.obTaken
                        : _available == true
                        ? l.obAvailable
                        : ''),
                style: context.type.micro.copyWith(
                  color: _available == false || _error != null || problem != null
                      ? AppColors.loss
                      : context.colors.muted,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: canSave && !_saving ? _save : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l.save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown instead of the editor inside the fourteen days — the rule and the
/// day it lifts, not an empty field nobody could save from.
class _AlreadyChangedSheet extends StatelessWidget {
  const _AlreadyChangedSheet({required this.heading, required this.next});

  final String heading;
  final DateTime next;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading,
              style: context.type.heading.copyWith(color: context.colors.text),
            ),
            const SizedBox(height: 8),
            Text(
              '${l.usernameAlreadyChangedBody} ${usernameChangeAgainText(l, next)}.',
              key: const Key('usernameNextChange'),
              style: context.type.body.copyWith(color: context.colors.muted),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(MaterialLocalizations.of(context).closeButtonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
