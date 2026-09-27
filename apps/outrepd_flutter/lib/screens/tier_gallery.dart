/// Every rank badge at once, for looking at.
///
/// Preview only — nothing in the app navigates here. The crests are drawn
/// rather than exported, so the only way to check the drawing is to put the
/// whole ladder on one screen at the sizes it actually gets used at: large on
/// a result screen, small on a row, and hollow for a rank not reached yet.
library;

import 'package:flutter/material.dart';

import '../theme.dart';
import '../tier_badge.dart';
import '../widgets.dart';
import '../l10n/app_localizations.dart';

class TierGalleryScreen extends StatelessWidget {
  const TierGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Scaffold(
      backgroundColor: context.colors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              // Tall enough for the badge and two lines under it. At 1.15 the
              // second line was cut off by the row beneath.
              childAspectRatio: 0.82,
              children: [
                for (var tier = 0; tier < kTiers.length; tier++)
                  Container(
                    decoration: BoxDecoration(
                      color: context.colors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: context.colors.border,
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TierBadge(tierIndex: tier, size: 110),
                        const SizedBox(height: 4),
                        Text(
                          tierName(l, tier),
                          style: TextStyle(
                            color: context.colors.text,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          kTiers[tier].crest,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: context.colors.muted,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            // Master on its own and large: it carries the crown, the laurel
            // and the only terracotta wings, and it is the one crest whose
            // details are too small to judge in a grid cell.
            const SizedBox(height: 22),
            _Label('master, large'),
            Center(child: TierBadge(tierIndex: kTiers.length - 1, size: 260)),

            const SizedBox(height: 22),
            _Label('all seven at 34dp'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var tier = 0; tier < kTiers.length; tier++)
                  TierBadge(tierIndex: tier, size: 40),
              ],
            ),

            const SizedBox(height: 22),
            _Label('at 15dp, where a badge sits inside a row'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var tier = 0; tier < kTiers.length; tier++)
                  TierBadge(tierIndex: tier, size: 20),
              ],
            ),

            const SizedBox(height: 22),
            _Label('locked, and unranked'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var tier = 2; tier < kTiers.length; tier += 2)
                  TierBadge(tierIndex: tier, size: 64, locked: true),
                const TierBadge.unranked(size: 64),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
        color: context.colors.muted,
        fontSize: 11,
        letterSpacing: 0.5,
      ),
    ),
  );
}
