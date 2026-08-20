import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

String formatVolume(BuildContext context, L l, int kg) {
  // "184.3k" is an English shorthand. Every locale has its own — ألف in
  // Arabic, 万 in Japanese — and compact() knows which.
  final locale = Localizations.localeOf(context);
  final short = NumberFormat.compact(locale: locale.toString()).format(kg);
  final digits =
      locale.languageCode == 'ar' ? _arabicDigits(short) : short;
  return '$digits ${l.shortKg}';
}

String relativeDays(BuildContext context, int days) {
  final l = L.of(context);
  if (days == 0) return l.today;
  if (days == 1) return l.yesterday;
  if (days < 7) return l.daysAgo(localNumber(context, days));
  final weeks = days ~/ 7;
  return l.weeksAgo(localNumber(context, weeks));
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

/// A number in the reader's own digits.
///
/// Grouping and decimal marks come from the locale. The digits themselves only
/// change for Arabic: ٢٤ rather than 24. Hindi, Japanese, Korean and Chinese
/// all write numbers in Western digits in practice, whatever their scripts
/// historically had, and swapping those out would look wrong rather than
/// localised.
String localNumber(BuildContext context, num n) {
  final locale = Localizations.localeOf(context);
  final text = NumberFormat.decimalPattern(locale.toString()).format(n);
  return locale.languageCode == 'ar' ? _arabicDigits(text) : text;
}

/// Reads a whole number a person typed, in whatever digits their keyboard
/// produces. An Arabic keyboard gives ١٧٥, and `int.tryParse` refuses it — so
/// showing localised digits in an editable field without this makes every save
/// fail with "fill all three with whole numbers" while three numbers sit right
/// there on screen.
int? parseLocalNumber(String text) {
  const arabicIndic = '٠١٢٣٤٥٦٧٨٩';
  final western = text.trim().split('').map((c) {
    final i = arabicIndic.indexOf(c);
    return i == -1 ? c : '$i';
  }).join();
  return int.tryParse(western);
}

String _arabicDigits(String text) {
  const arabicIndic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  return text.split('').map((c) {
    final digit = '0123456789'.indexOf(c);
    return digit == -1 ? c : arabicIndic[digit];
  }).join();
}
