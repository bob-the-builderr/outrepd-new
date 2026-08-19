import 'package:flutter/material.dart';

import '../data.dart';
import '../rewards.dart';
import '../motion.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets.dart';

/// Everything there is to chase besides rank: the streak, and the titles.
class AwardsScreen extends StatefulWidget {
  const AwardsScreen({super.key});

  @override
  State<AwardsScreen> createState() => _AwardsScreenState();
}

class _AwardsScreenState extends State<AwardsScreen> {
  @override
  Widget build(BuildContext context) {
    final owned = kTitles.where((t) => rewards.has(t.id)).toList();
    final locked = kTitles.where((t) => !rewards.has(t.id)).toList();

    return Scaffold(
      appBar: AppBar(title: Text(L.of(context).awards)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          const _StreakCard(),
          const SizedBox(height: 24),
          SectionHeader(
            title: L.of(context).yourTitles,
            trailing: Text(
              L.of(context).xOfY(owned.length, kTitles.length),
              style: TextStyle(color: context.colors.muted, fontSize: 13),
            ),
          ),
          if (owned.isEmpty)
            Panel(
              child: Text(
                L.of(context).noTitlesYet,
                style: TextStyle(color: context.colors.muted, fontSize: 13),
              ),
            )
          else ...[
            Text(
              L.of(context).wearHint,
              style: TextStyle(color: context.colors.muted, fontSize: 12),
            ),
            const SizedBox(height: 12),
            for (final title in owned)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _TitleRow(
                  title: title,
                  owned: true,
                  worn: rewards.wearing == title.id,
                  onTap: () async {
                    // Tapping the one you are wearing takes it off, so nobody
                    // is stuck displaying something they have outgrown.
                    await rewards.wear(
                      rewards.wearing == title.id ? null : title.id,
                    );
                    if (mounted) setState(() {});
                  },
                ),
              ),
          ],
          const SizedBox(height: 24),
          SectionHeader(title: L.of(context).stillToEarn),
          for (final title in locked)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _TitleRow(title: title, owned: false, worn: false),
            ),
        ],
      ),
    );
  }
}

/// The streak, and how much rest is still in the bank.
class _StreakCard extends StatelessWidget {
  const _StreakCard();

  @override
  Widget build(BuildContext context) {
    final restLeft =
        (kRestDaysPerWeek - rewards.restUsedThisWeek).clamp(0, kRestDaysPerWeek);

    return Panel(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Breathe(
                child: Icon(Icons.local_fire_department,
                    color: Color(0xFFFF8C00), size: 34),
              ),
              const SizedBox(width: 10),
              PopOnChange(
                value: rewards.streak,
                child: Text(
                  '${rewards.streak}',
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: 46,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            L.of(context).dayStreak,
            style: TextStyle(
              color: context.colors.muted,
              fontSize: 12.5,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _Stat(label: L.of(context).bestEver, value: '${rewards.bestStreak}'),
              ),
              Expanded(
                child: _Stat(label: L.of(context).restDaysLeft, value: '$restLeft'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: context.colors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.bedtime_outlined,
                    color: context.colors.muted, size: 17),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    // Said out loud because most apps do the opposite, and
                    // someone protecting a long streak needs to know resting
                    // will not cost them it.
                    L.of(context).restIsTraining,
                    style:
                        TextStyle(color: context.colors.muted, fontSize: 11.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: context.colors.text,
            fontSize: 19,
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

class _TitleRow extends StatelessWidget {
  const _TitleRow({
    required this.title,
    required this.owned,
    required this.worn,
    this.onTap,
  });

  final EarnedTitle title;
  final bool owned;
  final bool worn;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colour = title.colour ?? context.colors.brand;

    return Container(
      decoration: BoxDecoration(
        color: worn ? colour.withValues(alpha: 0.12) : context.colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: worn ? colour : context.colors.surfaceRaised,
          width: worn ? 1.6 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: owned
                        ? colour.withValues(alpha: 0.16)
                        : context.colors.surfaceRaised,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    owned ? title.icon : Icons.lock_outline,
                    color: owned ? colour : context.colors.muted,
                    size: 19,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.title,
                        style: TextStyle(
                          color: owned
                              ? context.colors.text
                              : context.colors.muted,
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        title.hint,
                        style: TextStyle(
                          color: context.colors.muted,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),
                if (worn)
                  Text(
                    L.of(context).worn,
                    style: TextStyle(
                      color: colour,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The title beside a name. Small on purpose — it should read as a badge, not
/// compete with the name it belongs to.
class TitleChip extends StatelessWidget {
  const TitleChip({super.key, required this.title, this.compact = false});

  final EarnedTitle title;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colour = title.colour ?? context.colors.brand;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 10,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: colour.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colour.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(title.icon, size: compact ? 10 : 12, color: colour),
          SizedBox(width: compact ? 4 : 5),
          Text(
            title.title,
            style: TextStyle(
              color: colour,
              fontSize: compact ? 10 : 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown the moment something is unlocked. Finding out later, buried in a
/// list, is not the same thing at all.
Future<void> celebrate(BuildContext context, List<EarnedTitle> unlocked) async {
  for (final title in unlocked) {
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text(
          L.of(context).titleUnlocked,
          style: TextStyle(color: context.colors.text, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(title.icon, size: 44, color: title.colour ?? context.colors.brand),
            const SizedBox(height: 14),
            Text(
              title.title,
              style: TextStyle(
                color: context.colors.text,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title.hint,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.colors.muted, fontSize: 12.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(L.of(context).wearItLater,
                style: TextStyle(color: context.colors.muted)),
          ),
          TextButton(
            onPressed: () async {
              await rewards.wear(title.id);
              if (context.mounted) Navigator.of(context).pop();
            },
            child: Text(L.of(context).wearIt,
                style: TextStyle(
                  color: context.colors.brand,
                  fontWeight: FontWeight.w700,
                )),
          ),
        ],
      ),
    );
  }
}

/// Kept so the old achievement list still has a home while it is folded in.
List<Achievement> get legacyAchievements => demoAchievements;
