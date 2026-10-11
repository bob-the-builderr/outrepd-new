/// Giving a friend a week: the card on the Friends tab.
///
/// Only a paying yearly subscriber's code gives one (supabase/invites.sql),
/// so the card is shown only to them. The one who invites gets nothing for
/// it; the card says what the friend gets and how many have come in.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../backend/backend.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets.dart';

/// The page a shared invite opens: their profile, their code, and the stores.
String inviteLink(String username, String code) =>
    'https://www.outrepd.com/u/${Uri.encodeComponent(username)}?code=$code';

class InviteCard extends StatelessWidget {
  const InviteCard({super.key, required this.invites});

  final MyInvites invites;

  Future<void> _send(BuildContext context) async {
    final me = backend.me;
    if (me == null) return;
    final l = L.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final text =
        '${l.inviteShareText('#${me.friendCode}')}\n'
        '${inviteLink(me.username, me.friendCode)}';
    try {
      await SharePlus.instance.share(ShareParams(text: text));
    } on Object catch (error) {
      debugPrint('Could not share the invite: $error');
      await Clipboard.setData(ClipboardData(text: text));
      messenger.showSnackBar(
        SnackBar(
          content: Text(l.codeCopied),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final code = backend.me?.friendCode;
    if (code == null) return const SizedBox.shrink();

    return Container(
      key: const Key('inviteCard'),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.card_giftcard, color: AppColors.gold, size: 22),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  l.inviteTitle,
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l.inviteBody,
            style: TextStyle(
              color: context.colors.muted,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.inviteYourCode,
                      style: TextStyle(
                        color: context.colors.muted,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '#$code',
                      style: TextStyle(
                        color: context.colors.text,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
              if (invites.joined > 0)
                Text(
                  l.inviteJoined(localNumber(context, invites.joined)),
                  style: const TextStyle(
                    color: AppColors.gold,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => _send(context),
              child: Text(l.inviteSend),
            ),
          ),
        ],
      ),
    );
  }
}
