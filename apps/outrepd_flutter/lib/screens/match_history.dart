import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';

/// Full match history, reached from the header rather than padding out the
/// match screen with a list you rarely need in the moment.
class MatchHistoryScreen extends StatelessWidget {
  const MatchHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = demoProfile;

    return Scaffold(
      appBar: AppBar(title: const Text('Match history')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Panel(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: _Tally(
                    value: '${p.wins}',
                    label: 'Wins',
                    color: AppColors.win,
                  ),
                ),
                Expanded(
                  child: _Tally(
                    value: '${p.losses}',
                    label: 'Losses',
                    color: AppColors.loss,
                  ),
                ),
                Expanded(
                  child: _Tally(
                    value: '${(p.winRate * 100).round()}%',
                    label: 'Win rate',
                    color: context.colors.text,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const SectionHeader(title: 'All matches'),
          ...demoMatches.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: MatchRow(m: m),
            ),
          ),
        ],
      ),
    );
  }
}

class _Tally extends StatelessWidget {
  const _Tally({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(color: context.colors.muted, fontSize: 11.5),
        ),
      ],
    );
  }
}

/// One result: who, which muscle, the volumes, and what it did to your LP.
class MatchRow extends StatelessWidget {
  const MatchRow({super.key, required this.m});
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.colors.text,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${formatVolume(m.userVolume)} · ${formatVolume(m.opponentVolume)} · ${relativeDays(m.daysAgo)}',
                  style: TextStyle(color: context.colors.muted, fontSize: 12),
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
