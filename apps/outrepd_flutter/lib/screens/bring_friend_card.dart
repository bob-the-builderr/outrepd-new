/// Bringing a friend in: the card at the foot of the Friends tab.
///
/// A yearly subscriber's code used to give the friend seven days of Pro,
/// with a card of its own here; it went with the paywall (2026-10-28), when
/// the app became free and Pro came to mean no ads.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../backend/backend.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';

/// The page a shared profile opens: theirs, and the stores.
String profileLink(String username) =>
    'https://www.outrepd.com/u/${Uri.encodeComponent(username)}';

/// Asking a friend in: a link to this lifter's profile, where the friend can
/// add them, and the friend code under it for anyone who would rather type.
class BringFriendCard extends StatelessWidget {
  const BringFriendCard({super.key});

  Future<void> _send(BuildContext context, String username) async {
    final l = L.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final text = '${l.bringFriendShareText}\n${profileLink(username)}';
    try {
      await SharePlus.instance.share(ShareParams(text: text));
    } on Object catch (error) {
      debugPrint('Could not share the profile: $error');
      await Clipboard.setData(ClipboardData(text: text));
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.linkCopied),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final me = backend.me;
    final username = me?.username ?? demoProfile.username;
    final code = me?.friendCode ?? demoProfile.friendCode;

    return Container(
      key: const Key('bringFriendCard'),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colors.surfaceRaised, width: 2),
      ),
      child: Column(
        children: [
          Text(
            l.bringFriendTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.text,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l.bringFriendBody,
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.muted, fontSize: 15, height: 1.4),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: const Key('bringFriendShare'),
              onPressed: () => _send(context, username),
              child: Text(l.bringFriendShare),
            ),
          ),
          if (code.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              l.orFriendCode('#$code'),
              style: TextStyle(color: colors.muted, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}
