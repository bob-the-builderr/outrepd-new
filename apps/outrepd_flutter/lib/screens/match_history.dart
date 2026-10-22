import 'package:flutter/material.dart';

import '../data.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets.dart';

/// Full match history, reached from the header rather than padding out the
/// match screen with a list you rarely need in the moment.
///
/// The record and the form first — the last ten as a strip of wins and losses
/// you can read at a glance — then every match, a line each, under the day it
/// was played.
class MatchHistoryScreen extends StatelessWidget {
  const MatchHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    // A heading wherever the day it reads as changes: two matches a week
    // apart are both "2 weeks ago", and sit under the one heading.
    final rows = <Widget>[];
    String? day;
    for (final (i, m) in matchHistory.indexed) {
      final label = relativeDays(context, m.daysAgo);
      if (label != day) {
        day = label;
        rows.add(_DayHeading(label));
      }
      final next = i + 1 < matchHistory.length ? matchHistory[i + 1] : null;
      rows.add(
        MatchRow(
          m: m,
          divider:
              next != null && relativeDays(context, next.daysAgo) == label,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.matchHistory)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          const _Form(),
          if (matchHistory.isEmpty) ...[
            const SizedBox(height: 22),
            EmptyState(
              icon: Icons.sports_mma_outlined,
              title: l.noMatchesTitle,
              body: l.noMatchesBody,
            ),
          ],
          ...rows,
        ],
      ),
    );
  }
}

/// The record, the win rate, and the last ten as a strip.
class _Form extends StatelessWidget {
  const _Form();

  static const _shown = FormStrip.shown;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final p = demoProfile;
    const big = TextStyle(fontSize: 34, fontWeight: FontWeight.w800, height: 1.1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.colors.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: localNumber(context, p.wins),
                          style: big.copyWith(color: AppColors.win),
                        ),
                        TextSpan(
                          text: ' / ',
                          style: TextStyle(
                            color: context.colors.muted,
                            fontSize: 22,
                          ),
                        ),
                        TextSpan(
                          text: localNumber(context, p.losses),
                          style: big.copyWith(color: AppColors.loss),
                        ),
                      ],
                    ),
                    key: const Key('historyRecord'),
                  ),
                ),
              ),
              Text(
                '${localNumber(context, (p.winRate * 100).round())}%',
                style: TextStyle(
                  color: context.colors.text,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '${l.wins} / ${l.losses} · ${l.winRate}',
            style: TextStyle(color: context.colors.muted, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Text(
            l.lastN(localNumber(context, _shown)),
            style: TextStyle(color: context.colors.muted, fontSize: 13),
          ),
          const SizedBox(height: 6),
          const FormStrip(key: Key('historyForm')),
        ],
      ),
    );
  }
}

class _DayHeading extends StatelessWidget {
  const _DayHeading(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 4, 4),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: context.colors.muted,
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// The last ten matches as a strip of wins and losses, the newest at the
/// right end, the way a form guide reads. Ten places whatever has been
/// played, so a new account sees the strip filling in from the right rather
/// than three bars stretched across it.
class FormStrip extends StatelessWidget {
  const FormStrip({super.key, this.height = 26, this.gap = 6});

  static const shown = 10;

  final double height;
  final double gap;

  @override
  Widget build(BuildContext context) {
    // Oldest first, and the empty places before them.
    final last = matchHistory.take(shown).toList().reversed.toList();
    final empty = shown - last.length;
    return Row(
      children: [
        for (var i = 0; i < shown; i++) ...[
          if (i > 0) SizedBox(width: gap),
          Expanded(
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: i < empty
                    ? context.colors.surfaceRaised
                    : (last[i - empty].won ? AppColors.win : AppColors.loss),
                borderRadius: BorderRadius.circular(height / 4.4),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// One result on a line: won or lost, who, the score, and the LP it moved.
class MatchRow extends StatelessWidget {
  const MatchRow({
    super.key,
    required this.m,
    this.divider = false,
    this.inset = 4,
  });

  final MatchRecord m;

  /// Room either side: a little in the list, a card's worth inside one.
  final double inset;

  /// A hairline under it, when the next match is on the same day.
  final bool divider;

  @override
  Widget build(BuildContext context) {
    final colour = m.won ? AppColors.win : AppColors.loss;
    final lp = m.lpChange;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: inset, vertical: 12),
      decoration: divider
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(color: context.colors.border, width: 0.5),
              ),
            )
          : null,
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: colour, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              m.opponent,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: context.colors.text, fontSize: 16),
            ),
          ),
          const SizedBox(width: 10),
          // Reps, not kilos. The kilo pair outlived the weights it was
          // measuring by several months.
          Text(
            '${localNumber(context, m.userReps)}–'
            '${localNumber(context, m.opponentReps)}',
            style: TextStyle(
              color: context.colors.text,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          SizedBox(
            width: 52,
            child: Text(
              // A friendly match moved no LP, and says so with a dash
              // rather than a zero in a winner's colour.
              lp == 0
                  ? '—'
                  : lp > 0
                  ? '+${localNumber(context, lp)}'
                  : '−${localNumber(context, -lp)}',
              textAlign: TextAlign.end,
              style: TextStyle(
                color: lp == 0 ? context.colors.muted : colour,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
