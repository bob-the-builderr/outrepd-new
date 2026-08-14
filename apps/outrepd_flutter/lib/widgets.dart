import 'package:flutter/material.dart';

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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceRaised),
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
            color: color ?? Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 12),
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

String tierLabel(int tierIdx, int divIdx) {
  const romans = ['I', 'II', 'III', 'IV'];
  final tier = kTiers[tierIdx.clamp(0, kTiers.length - 1)];
  return '${tier.name} ${romans[divIdx.clamp(0, 3)]}';
}

String formatVolume(int kg) {
  if (kg >= 1000000) return '${(kg / 1000000).toStringAsFixed(1)}M kg';
  if (kg >= 1000) return '${(kg / 1000).toStringAsFixed(1)}k kg';
  return '$kg kg';
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
            style: const TextStyle(
              color: Colors.white,
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
