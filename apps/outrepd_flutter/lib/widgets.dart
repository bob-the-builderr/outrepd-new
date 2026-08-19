import 'package:flutter/material.dart';

import 'l10n/app_localizations.dart';
import 'theme.dart';

/// Rounded dark panel used for most content blocks.
class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.surfaceRaised),
      ),
      child: child,
    );

    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: content,
    );
  }
}

/// Small label + value pair, used across profile and stats.
class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color ?? context.colors.text,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: context.colors.muted, fontSize: 12),
        ),
      ],
    );
  }
}

/// Tier badge with the rank artwork, falling back to a coloured dot for
/// tiers that have no image.
class TierBadge extends StatelessWidget {
  const TierBadge({super.key, required this.tierIdx, this.size = 48});

  final int tierIdx;
  final double size;

  @override
  Widget build(BuildContext context) {
    final tier = kTiers[tierIdx.clamp(0, kTiers.length - 1)];
    if (tier.asset == null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: tier.color, shape: BoxShape.circle),
      );
    }
    return Image.asset(tier.asset!, width: size, height: size, fit: BoxFit.contain);
  }
}

/// Divisions climb from V up to I, so a higher [divIdx] is a better division.
const kDivisions = ['V', 'IV', 'III', 'II', 'I'];

/// The tier's display name in the reader's language. [Tier.name] itself stays
/// English — it doubles as the id that finds the frame and badge assets.
String tierName(L l, int tierIdx) => switch (tierIdx.clamp(0, 8)) {
      0 => l.tierStone,
      1 => l.tierBronze,
      2 => l.tierSilver,
      3 => l.tierGold,
      4 => l.tierPlatinum,
      5 => l.tierDiamond,
      6 => l.tierMaster,
      7 => l.tierMythic,
      _ => l.tierLegend,
    };

/// What reaching a tier unlocks, shown on the roadmap.
String tierReward(L l, int tierIdx) => switch (tierIdx.clamp(0, 8)) {
      0 => l.rewardStone,
      1 => l.rewardBronze,
      2 => l.rewardSilver,
      3 => l.rewardGold,
      4 => l.rewardPlatinum,
      5 => l.rewardDiamond,
      6 => l.rewardMaster,
      7 => l.rewardMythic,
      _ => l.rewardLegend,
    };

String tierLabel(L l, int tierIdx, int divIdx) =>
    '${tierName(l, tierIdx)} ${kDivisions[divIdx.clamp(0, kDivisions.length - 1)]}';

String formatVolume(L l, int kg) {
  final unit = l.shortKg;
  if (kg >= 1000000) return '${(kg / 1000000).toStringAsFixed(1)}M $unit';
  if (kg >= 1000) return '${(kg / 1000).toStringAsFixed(1)}k $unit';
  return '$kg $unit';
}

String relativeDays(int days) {
  if (days == 0) return 'Today';
  if (days == 1) return 'Yesterday';
  if (days < 7) return '$days days ago';
  final weeks = days ~/ 7;
  return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
}

/// Section heading with optional trailing action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: context.colors.text,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
