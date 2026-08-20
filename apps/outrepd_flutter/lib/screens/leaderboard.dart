import 'package:flutter/material.dart';

import '../data.dart';
import '../profile_avatar.dart';
import '../l10n/app_localizations.dart';
import '../type_scale.dart';
import '../theme.dart';
import '../widgets.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  bool _global = true;

  @override
  Widget build(BuildContext context) {
    final entries = _global
        ? demoLeaderboard
        : demoLeaderboard.where((e) => e.tierIdx <= 4).toList();

    return Scaffold(
      appBar: AppBar(title: Text(L.of(context).leaderboard)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: SegmentedButton<bool>(
              segments: [
                ButtonSegment(value: true, label: Text(L.of(context).global)),
                ButtonSegment(
                    value: false, label: Text(L.of(context).myCountry)),
              ],
              selected: {_global},
              onSelectionChanged: (s) => setState(() => _global = s.first),
              style: SegmentedButton.styleFrom(
                backgroundColor: context.colors.surface,
                foregroundColor: context.colors.muted,
                selectedBackgroundColor: context.colors.brand,
                selectedForegroundColor: context.colors.text,
                side: BorderSide(color: context.colors.surfaceRaised),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: entries.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final e = entries[i];
                final isMe = e.username == demoProfile.username;
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isMe
                        ? context.colors.brand.withValues(alpha: 0.12)
                        : context.colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isMe ? context.colors.brand : context.colors.surfaceRaised,
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 28,
                        child: Text(
                          localNumber(context, i + 1),
                          style: context.type.heading.copyWith(color: i < 3 ? AppColors.gold : context.colors.muted),
                        ),
                      ),
                      ProfileAvatar(
                        tierIdx: e.tierIdx,
                        username: e.username,
                        size: 50,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.username,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.type.body.copyWith(color: isMe ? context.colors.brand : context.colors.text),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${tierLabel(L.of(context), e.tierIdx, e.divIdx)}'
                              ' · ${L.of(context).winLoss(localNumber(context, e.wins),
                                  localNumber(context, e.losses))}',
                              style: context.type.label.copyWith(color: context.colors.muted),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        L.of(context).lpAmount(localNumber(context, e.lp)),
                        style: TextStyle(
                          color: context.colors.text,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
