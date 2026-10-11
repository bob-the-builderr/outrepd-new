/// The monthly board's awards, as the app draws them: what each is called,
/// what colour it wears, and how much of the month is left to win one.
///
/// A month is a UTC month on the server, so every date here is read in UTC:
/// read as local time, the 1st at midnight lands in the month before for
/// anybody west of Greenwich.
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'backend/backend.dart';
import 'l10n/app_localizations.dart';
import 'theme.dart';
import 'widgets.dart';

String awardName(L l, SeasonAwardKind kind) => switch (kind) {
  SeasonAwardKind.champion => l.awardChampion,
  SeasonAwardKind.podium => l.awardPodium,
  SeasonAwardKind.top10 => l.awardTop10,
  SeasonAwardKind.regular => l.awardRegular,
};

/// The same three colours the board spends on its podium, so a chip on a
/// profile reads as the place it came from.
Color awardColour(BuildContext context, SeasonAwardKind kind) => switch (kind) {
  SeasonAwardKind.champion => AppColors.gold,
  SeasonAwardKind.podium => AppColors.silver,
  SeasonAwardKind.top10 => AppColors.bronze,
  SeasonAwardKind.regular => context.colors.brand,
};

/// What a place on the board earns when the month ends, or null below tenth.
SeasonAwardKind? awardForPlace(int place) => switch (place) {
  1 => SeasonAwardKind.champion,
  2 || 3 => SeasonAwardKind.podium,
  <= 10 => SeasonAwardKind.top10,
  _ => null,
};

String _locale(BuildContext context) =>
    Localizations.localeOf(context).toString();

/// "October", in the reader's language and as a heading — the standalone
/// form, since some languages decline a month inside a date.
String monthName(BuildContext context, DateTime season) =>
    toBeginningOfSentenceCase(
      DateFormat.LLLL(_locale(context)).format(season.toUtc()),
      _locale(context),
    );

/// "Sep", for a chip.
String shortMonthName(BuildContext context, DateTime season) =>
    DateFormat.LLL(_locale(context)).format(season.toUtc());

/// "September 2026", for the month an award came from.
String monthAndYear(BuildContext context, DateTime season) =>
    toBeginningOfSentenceCase(
      DateFormat.yMMMM(_locale(context)).format(season.toUtc()),
      _locale(context),
    );

/// How long the month has left: days and hours, or hours alone on the
/// last day, when the days would read zero.
String monthLeft(BuildContext context, DateTime endsAt, DateTime now) {
  final l = L.of(context);
  final left = endsAt.difference(now);
  if (left.isNegative) return l.timeLeft(l.shortHours(localNumber(context, 0)));
  final days = left.inDays;
  final hours = left.inHours - days * 24;
  final time = days == 0
      ? l.shortHours(localNumber(context, hours))
      : '${l.shortDays(localNumber(context, days))} '
            '${l.shortHours(localNumber(context, hours))}';
  return l.timeLeft(time);
}

/// The awards somebody has won, as a row of chips: "Top 10 · Sep".
class SeasonAwardChips extends StatelessWidget {
  const SeasonAwardChips({
    super.key,
    required this.awards,
    this.alignment = WrapAlignment.start,
  });

  final List<SeasonAward> awards;
  final WrapAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return Wrap(
      alignment: alignment,
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final award in awards)
          AwardChip(
            label:
                '${awardName(l, award.kind)} · '
                '${shortMonthName(context, award.season)}',
            colour: awardColour(context, award.kind),
          ),
      ],
    );
  }
}

class AwardChip extends StatelessWidget {
  const AwardChip({
    super.key,
    required this.label,
    required this.colour,
    this.fontSize = 11,
  });

  final String label;
  final Color colour;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: colour,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: context.colors.background,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
