import 'package:flutter/material.dart';

import '../data.dart';
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
      appBar: AppBar(title: const Text('Leaderboard')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Global')),
                ButtonSegment(value: false, label: Text('My country')),
              ],
              selected: {_global},
              onSelectionChanged: (s) => setState(() => _global = s.first),
              style: SegmentedButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.muted,
                selectedBackgroundColor: AppColors.brand,
                selectedForegroundColor: Colors.white,
                side: const BorderSide(color: AppColors.surfaceRaised),
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
                        ? AppColors.brand.withValues(alpha: 0.12)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isMe ? AppColors.brand : AppColors.surfaceRaised,
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 28,
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            color: i < 3 ? AppColors.gold : AppColors.muted,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      TierBadge(tierIdx: e.tierIdx, size: 36),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.username,
                              style: TextStyle(
                                color: isMe ? AppColors.brand : Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${tierLabel(e.tierIdx, e.divIdx)} · ${e.wins}W ${e.losses}L',
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${e.lp} LP',
                        style: const TextStyle(
                          color: Colors.white,
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
