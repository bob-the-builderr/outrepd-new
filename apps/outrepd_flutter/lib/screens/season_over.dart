/// The month that just ended, told once: where this account finished and
/// what it won.
///
/// Shown only to somebody who won something. A month without an award has
/// nothing to tell, and a popup saying so would be one more thing between
/// them and the next duel.
library;

import 'package:flutter/material.dart';

import '../backend/backend.dart';
import '../l10n/app_localizations.dart';
import '../season.dart';
import '../theme.dart';
import '../widgets.dart';
import 'shell.dart';

/// Tells this account about awards it has not been shown yet, newest month
/// only, then marks them all seen. Quiet on any failure: the awards are on
/// the profile either way, and the next launch asks again.
Future<void> tellSeasonAwards(BuildContext context) async {
  if (!backend.available) return;
  try {
    final awards = await backend.mySeasonAwards();
    final unseen = awards.where((a) => !a.seen).toList();
    if (unseen.isEmpty || !context.mounted) return;
    final latest = unseen
        .map((a) => a.season)
        .reduce((a, b) => a.isAfter(b) ? a : b);
    final month = unseen.where((a) => a.season == latest).toList();
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => SeasonOverDialog(
        awards: month,
        onPlay: () {
          if (context.mounted) AppShell.goToMatch(context);
        },
      ),
    );
    await backend.markSeasonAwardsSeen();
  } on Object catch (error) {
    debugPrint('Could not tell the season awards: $error');
  }
}

class SeasonOverDialog extends StatelessWidget {
  const SeasonOverDialog({super.key, required this.awards, this.onPlay});

  /// One month's awards: a place, the badge, or both.
  final List<SeasonAward> awards;

  /// After the dialog closes. The dialog sits above the tabs rather than in
  /// them, so it is handed the way to the Match tab instead of looking for it.
  final VoidCallback? onPlay;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    // The place leads when there is one; the badge alone otherwise.
    final placed = awards.where((a) => a.place != null).firstOrNull;
    final lead = placed ?? awards.first;
    final colour = awardColour(context, lead.kind);

    return Dialog(
      backgroundColor: context.colors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: context.colors.border, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l.seasonOver,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.text,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              monthAndYear(context, lead.season),
              style: TextStyle(color: context.colors.muted, fontSize: 13),
            ),
            const SizedBox(height: 18),
            Icon(
              placed != null ? Icons.emoji_events : Icons.verified_outlined,
              color: colour,
              size: 44,
            ),
            if (placed?.place case final place?)
              Text(
                '#${localNumber(context, place)}',
                style: TextStyle(
                  color: colour,
                  fontSize: 56,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
            const SizedBox(height: 2),
            Text(
              awardName(l, lead.kind),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.colors.text,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${localNumber(context, lead.points)} ${l.lpUnit} · '
              '${l.rankedDuelsCount(localNumber(context, lead.played))}',
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.muted, fontSize: 13),
            ),
            const SizedBox(height: 14),
            SeasonAwardChips(awards: awards),
            const SizedBox(height: 14),
            Text(
              l.seasonOverBody,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.muted, fontSize: 13),
            ),
            const SizedBox(height: 20),
            Material(
              color: context.colors.brand,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context).pop();
                  onPlay?.call();
                },
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: Center(
                    child: Text(
                      l.seasonPlayCta,
                      style: TextStyle(
                        color: context.colors.background,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
