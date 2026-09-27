/// "Your climb" — the whole tier ladder, read bottom to top.
///
/// Ordered upward on purpose: the tiers you have already taken sit underneath
/// you and the ones ahead stack above, so scrolling up is climbing. A list that
/// runs top-down turns the same data into a table of things you have not done.
///
/// Each rung is the tier alone. There are no per-tier unlocks in the app, so
/// the ladder promises none.
///
/// The floor message is never phrased as a failure. "Gold is yours" is the
/// same fact as "you cannot fall out of Gold", and only one of them reads like
/// a reward.
library;

import 'package:flutter/material.dart';

import '../data.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../tier_badge.dart';
import '../widgets.dart';

class ProgressionScreen extends StatelessWidget {
  const ProgressionScreen({required this.profile, super.key});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final current = profile.tierIdx.clamp(0, kTiers.length - 1);

    // Top of the list is the top of the ladder, so the tiers are walked from
    // the last index down.
    final rungs = [for (var i = kTiers.length - 1; i >= 0; i--) i];

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    customBorder: const CircleBorder(),
                    child: Icon(
                      Icons.arrow_back,
                      size: 19,
                      color: context.colors.muted,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ShrinkText(
                      l.yourClimb,
                      style: TextStyle(
                        color: context.colors.text,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            // A tier once reached is kept — the ladder's own floor rule, said
            // as something earned rather than a limit. Nothing to protect at
            // the very first tier, so there is nothing to say yet.
            if (profile.peakTierIdx > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Panel(
                  child: Row(
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        color: kTiers[profile.peakTierIdx].color,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l.floorKept(
                            tierName(l, profile.peakTierIdx),
                            tierLabel(l, profile.peakTierIdx, 0),
                          ),
                          style: TextStyle(
                            color: context.colors.muted,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: rungs.length,
                itemBuilder: (context, index) {
                  final tierIdx = rungs[index];
                  final reached = tierIdx <= current;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Panel(
                      child: Row(
                        children: [
                          TierBadge(
                            tierIndex: tierIdx,
                            size: 34,
                            locked: !reached,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tierName(l, tierIdx),
                                  style: TextStyle(
                                    color: reached
                                        ? context.colors.text
                                        : context.colors.muted,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (reached)
                            Icon(
                              Icons.check_circle,
                              color: context.colors.brand,
                              size: 18,
                            )
                          else
                            Icon(
                              Icons.lock_outline,
                              color: context.colors.faint,
                              size: 16,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
