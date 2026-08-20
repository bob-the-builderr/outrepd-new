import 'package:flutter/material.dart';

import '../data.dart';
import '../profile_avatar.dart';
import '../l10n/app_localizations.dart';
import '../type_scale.dart';
import '../theme.dart';
import '../widgets.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L.of(context).tabFriends),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(L.of(context).needsServer),
                behavior: SnackBarBehavior.floating,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Panel(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Icon(Icons.link, color: context.colors.brand),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    L.of(context).inviteFriendPrivate,
                    style: TextStyle(
                      color: context.colors.text,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(L.of(context).copied),
                      behavior: SnackBarBehavior.floating,
                    ),
                  ),
                  child: Text(L.of(context).copy),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SectionHeader(title: L.of(context).yourFriends(localNumber(context, demoFriends.length))),
          if (demoFriends.isEmpty)
            EmptyState(
              icon: Icons.person_add_alt_1_outlined,
              title: L.of(context).noFriendsTitle,
              body: L.of(context).noFriendsBody,
            ),
          ...demoFriends.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Panel(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        ProfileAvatar(
                          tierIdx: f.tierIdx,
                          username: f.username,
                          size: 54,
                        ),
                        if (f.online)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 11,
                              height: 11,
                              decoration: BoxDecoration(
                                color: AppColors.win,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: context.colors.surface,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            f.username,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.type.body.copyWith(color: context.colors.text),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${tierName(L.of(context), f.tierIdx)}'
                            ' · ${L.of(context).lpAmount(localNumber(context, f.lp))}',
                            style: context.type.label.copyWith(color: context.colors.muted),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(84, 36),
                        side: BorderSide(color: context.colors.brand),
                        foregroundColor: context.colors.brand,
                        padding: EdgeInsets.zero,
                        textStyle: context.type.label,
                      ),
                      onPressed: () =>
                          ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(L.of(context).challengeSent(f.username)),
                          behavior: SnackBarBehavior.floating,
                        ),
                      ),
                      child: Text(L.of(context).challenge),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
