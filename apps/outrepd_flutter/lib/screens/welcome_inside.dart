/// What there is beyond the duel, shown once, to a brand-new account, on the
/// way from sign-up to the first home screen.
///
/// Kept out of onboarding on purpose. Before the account exists there is no
/// friend code to show, only a made-up one, and six screens of reading in a
/// row before doing anything is where people give up on an app. Here the code
/// is the lifter's own, and they can send it to somebody straight away.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../backend/backend.dart';
import '../l10n/app_localizations.dart';
import '../rewards.dart';
import '../theme.dart';
import '../widgets.dart';
import 'share_card.dart';

class WelcomeInsideScreen extends StatelessWidget {
  const WelcomeInsideScreen({super.key, required this.onDone});

  /// Where to go next. Given this screen's own context, since the one that
  /// pushed it has been replaced by the time the button is pressed.
  final void Function(BuildContext context) onDone;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final code = backend.me?.friendCode;

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, box) => SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: box.maxHeight - 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Heading(
                          icon: Icons.military_tech_outlined,
                          text: l.obTitlesHeading(
                            localNumber(context, kTitles.length),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _Body(l.obTitlesBody),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (final t in kTitles.take(6))
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: context.colors.surface,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: context.colors.border,
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  t.name(l),
                                  style: TextStyle(
                                    color: context.colors.text,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 36),
                        _Heading(
                          icon: Icons.people_outline,
                          text: l.obFriendsHeading,
                        ),
                        const SizedBox(height: 8),
                        _Body(l.obFriendsBody),
                        if (code != null) ...[
                          const SizedBox(height: 14),
                          _Code(code: code),
                          const SizedBox(height: 4),
                          // Sent on with an invite, straight from here —
                          // the moment somebody is most likely to ask a
                          // friend along.
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: TextButton.icon(
                              key: const Key('shareFriendCode'),
                              onPressed: () => shareFriendCode(context, code),
                              icon: Icon(
                                Icons.share_outlined,
                                size: 18,
                                color: context.colors.brand,
                              ),
                              label: Text(
                                l.shareThisCode,
                                style: TextStyle(color: context.colors.brand),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => onDone(context),
                  child: Text(l.obLetsGo),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24, color: context.colors.brand),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: context.colors.text,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: context.colors.muted, fontSize: 14, height: 1.5),
    );
  }
}

/// This account's friend code, the way the profile shows it: with the '#' the
/// stored value never has, and copied the same way.
class _Code extends StatelessWidget {
  const _Code({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: '#$code'));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.codeCopied),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.colors.border, width: 0.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '#$code',
                style: TextStyle(
                  color: context.colors.text,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            Icon(Icons.copy, size: 18, color: context.colors.muted),
            const SizedBox(width: 6),
            Text(
              l.copyLink,
              style: TextStyle(color: context.colors.muted, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
