import 'package:flutter/material.dart';

import '../data.dart';
import '../l10n/app_localizations.dart';
import '../type_scale.dart';
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
      appBar: AppBar(title: Text(L.of(context).matchHistory)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Panel(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: _Tally(
                    value: localNumber(context, p.wins),
                    label: L.of(context).wins,
                    color: AppColors.win,
                  ),
                ),
                Expanded(
                  child: _Tally(
                    value: localNumber(context, p.losses),
                    label: L.of(context).losses,
                    color: AppColors.loss,
                  ),
                ),
                Expanded(
                  child: _Tally(
                    value:
                        '${localNumber(context, (p.winRate * 100).round())}%',
                    label: L.of(context).winRate,
                    color: context.colors.text,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SectionHeader(title: L.of(context).allMatches),
          if (matchHistory.isEmpty)
            EmptyState(
              icon: Icons.sports_mma_outlined,
              title: L.of(context).noMatchesTitle,
              body: L.of(context).noMatchesBody,
            ),
          ...matchHistory.map(
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
          style: context.type.title.copyWith(color: color),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: context.type.label.copyWith(color: context.colors.muted),
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
              style: context.type.heading.copyWith(color: color),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.won
                      ? L.of(context).wonVs(m.opponent)
                      : L.of(context).lostVs(m.opponent),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.type.body.copyWith(color: context.colors.text),
                ),
                const SizedBox(height: 3),
                // Reps, not kilos. The kilo pair outlived the weights it was
                // measuring by several months.
                Text(
                  '${localNumber(context, m.userReps)} – '
                  '${localNumber(context, m.opponentReps)}'
                  ' · ${relativeDays(context, m.daysAgo)}',
                  style: context.type.label.copyWith(color: context.colors.muted),
                ),
              ],
            ),
          ),
          Text(
            '${m.lpChange > 0 ? '+' : ''}'
            '${localNumber(context, m.lpChange)}',
            style: context.type.body.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
