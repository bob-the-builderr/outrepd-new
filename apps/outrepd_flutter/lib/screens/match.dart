import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'match_flow.dart';
import 'notifications.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = demoProfile;
    final unread = demoNotifications.where((n) => n.unread).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('OUTREPD'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                ),
              ),
              if (unread > 0)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: AppColors.loss,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _RankCard(p: p),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Start a match'),
          const _MuscleGrid(),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Recent matches',
            trailing: Text(
              '${p.wins}W · ${p.losses}L',
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
          ),
          ...demoMatches.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MatchRow(m: m),
              )),
        ],
      ),
    );
  }
}

class _RankCard extends StatelessWidget {
  const _RankCard({required this.p});
  final Profile p;

  @override
  Widget build(BuildContext context) {
    return Panel(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              TierBadge(tierIdx: p.tierIdx, size: 64),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tierLabel(p.tierIdx, p.divIdx),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${p.lp} LP',
                      style: const TextStyle(
                        color: AppColors.brand,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (p.winStreak > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.win.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '🔥 ${p.winStreak}',
                    style: const TextStyle(
                      color: AppColors.win,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: p.lp / 100,
              minHeight: 8,
              backgroundColor: AppColors.surfaceRaised,
              valueColor: const AlwaysStoppedAnimation(AppColors.brand),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${100 - p.lp} LP to promotion',
              style: const TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _MuscleGrid extends StatelessWidget {
  const _MuscleGrid();

  static const _icons = <String, IconData>{
    'Chest': Icons.fitness_center,
    'Back': Icons.rowing,
    'Legs': Icons.directions_run,
    'Shoulders': Icons.accessibility_new,
    'Arms': Icons.sports_gymnastics,
    'Core': Icons.self_improvement,
  };

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.1,
      children: muscleGroups.map((g) {
        return Panel(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => MatchFlowScreen(muscle: g)),
          ),
          child: Row(
            children: [
              Icon(_icons[g], color: AppColors.brand, size: 22),
              const SizedBox(width: 10),
              Text(
                g,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _MatchRow extends StatelessWidget {
  const _MatchRow({required this.m});
  final MatchRecord m;

  @override
  Widget build(BuildContext context) {
    final color = m.won ? AppColors.win : AppColors.loss;
    return Panel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              m.won ? 'W' : 'L',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${m.muscleGroup} vs ${m.opponent}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${formatVolume(m.userVolume)} · ${formatVolume(m.opponentVolume)} · ${relativeDays(m.daysAgo)}',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '${m.lpChange > 0 ? '+' : ''}${m.lpChange}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
