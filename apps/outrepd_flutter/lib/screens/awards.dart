import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../adventure/adventure.dart';
import '../awards/award_text.dart';
import '../awards/families.dart';
import '../awards/medal.dart';
import '../backend/backend.dart';
import '../data.dart';

import '../rewards.dart';
import '../motion.dart';
import '../l10n/app_localizations.dart';
import '../type_scale.dart';
import '../theme.dart';
import '../widgets.dart';

/// Everything there is to chase besides rank (the user's pick, 2026-11-09,
/// A): the showcase pinned to the profile, every award family as a medal in
/// a cabinet, the streak, and the titles of before.
class AwardsScreen extends StatefulWidget {
  const AwardsScreen({super.key});

  @override
  State<AwardsScreen> createState() => _AwardsScreenState();
}

/// How many lifters hold each award, as the server last said.
final awardRarity = <String, int>{};

/// Asks the server how rare each award is; quietly nothing without one.
Future<void> loadAwardRarity() async {
  if (!backend.available || backend.me == null) return;
  try {
    awardRarity
      ..clear()
      ..addAll(await backend.awardRarity());
  } on Object catch (error) {
    debugPrint('Could not read how rare the awards are: $error');
  }
}

/// What [family] counts today: the numbers the awards are judged on.
int awardValue(AwardFamily family, {int friends = 0}) {
  final p = demoProfile;
  return switch (family.kind) {
    AwardKind.reps => p.totalReps,
    AwardKind.streak => math.max(rewards.streak, rewards.bestStreak),
    AwardKind.wins => p.wins,
    AwardKind.winRun => p.bestStreak,
    AwardKind.best => p.bestSet,
    AwardKind.giant => rewards.giantWins,
    AwardKind.clean => rewards.cleanSets,
    AwardKind.challengers => rewards.challengeTakers,
    AwardKind.pastSelf => rewards.pastBeats,
    AwardKind.worlds => Adventure.instance.worldsCleared,
    AwardKind.goalDays => rewards.goalDays,
    AwardKind.early => rewards.earlySessions,
    AwardKind.late => rewards.lateSessions,
    AwardKind.friends => friends,
  };
}

class _AwardsScreenState extends State<AwardsScreen> {
  int _friends = 0;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  /// What only the server knows: the friends, who took the challenge links,
  /// a month won, how rare each award is. Then the families judged again.
  Future<void> _refresh() async {
    try {
      _friends = await currentFriendCount();
      if (backend.available && backend.me != null) {
        final links = await backend.myChallenges();
        await rewards.noteChallengeTakers(links.fold(0, (sum, c) => sum + c.takes));
        final months = await backend.mySeasonAwards();
        if (months.any((a) => a.kind == SeasonAwardKind.champion)) {
          await rewards.award(kMonthChampion);
        }
      }
      await rewards.syncWithProfile(
        matches: demoProfile.totalMatches,
        wins: demoProfile.wins,
        reps: demoProfile.totalReps,
        friends: _friends,
        winRun: demoProfile.bestStreak,
        bestSet: demoProfile.bestSet,
        worlds: Adventure.instance.worldsCleared,
      );
      await loadAwardRarity();
    } on Object catch (error) {
      debugPrint('Could not bring the awards up to date: $error');
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    return Scaffold(
      appBar: AppBar(title: Text(l.awards)),
      body: ListenableBuilder(
        listenable: rewards,
        builder: (context, _) {
          final have = kTitles.where((t) => rewards.has(t.id)).length;
          final legacy = kLegacyTitles.where((t) => rewards.has(t.id)).toList();
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
            children: [
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        key: const Key('awardsProgress'),
                        value: have / kAwardCount,
                        minHeight: 8,
                        color: tierColour(2),
                        backgroundColor: colors.surfaceRaised,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l.xOfY(localNumber(context, have), localNumber(context, kAwardCount)),
                    style: TextStyle(color: colors.text, fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              _Caption(
                left: '${l.awShowcase} · ${l.awShowcaseSub}',
                right: l.awEdit,
                onRight: () => _pickShowcase(context),
              ),
              _Showcase(ids: rewards.showcase, onEmpty: () => _pickShowcase(context)),
              const SizedBox(height: 22),
              _Caption(
                left: l.awAll,
                right: l.awFamilies(
                  localNumber(context, kAwardFamilies.length),
                  localNumber(context, kAwardSpecials.length),
                ),
              ),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.82,
                children: [
                  for (final f in kAwardFamilies)
                    _FamilyTile(
                      family: f,
                      value: awardValue(f, friends: _friends),
                      onTap: () => showFamilySheet(context, f, awardValue(f, friends: _friends)),
                    ),
                  for (final s in kAwardSpecials)
                    _SpecialTile(special: s, onTap: () => showSpecialSheet(context, s)),
                ],
              ),
              const SizedBox(height: 24),
              const _StreakCard(),
              if (legacy.isNotEmpty) ...[
                const SizedBox(height: 24),
                SectionHeader(title: l.awOldTitles),
                Text(
                  l.wearHint,
                  style: context.type.label.copyWith(color: colors.muted),
                ),
                const SizedBox(height: 12),
                for (final title in legacy)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _TitleRow(
                      title: title,
                      owned: true,
                      worn: rewards.wearing == title.id,
                      onTap: () => rewards.wear(rewards.wearing == title.id ? null : title.id),
                    ),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _pickShowcase(BuildContext context) async {
    final earned = earnedAwardIds();
    final picked = [...rewards.showcase.where(earned.contains)];
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      builder: (sheet) => StatefulBuilder(
        builder: (sheet, setSheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  L.of(sheet).awPick,
                  style: TextStyle(color: sheet.colors.text, fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                if (earned.isEmpty)
                  Text(L.of(sheet).awShowcaseEmpty, style: TextStyle(color: sheet.colors.muted))
                else
                  Flexible(
                    child: GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.78,
                      children: [
                        for (final id in earned)
                          GestureDetector(
                            key: Key('pin_$id'),
                            onTap: () => setSheet(() {
                              if (!picked.remove(id) && picked.length < 3) picked.add(id);
                            }),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: sheet.colors.background,
                                border: Border.all(
                                  color: picked.contains(id) ? tierColour(2) : sheet.colors.border,
                                  width: picked.contains(id) ? 2 : 0.5,
                                ),
                              ),
                              padding: const EdgeInsets.all(6),
                              child: Column(
                                children: [
                                  AwardMedal(id: id, size: 52),
                                  const SizedBox(height: 4),
                                  Text(
                                    awardName(L.of(sheet), id) ?? id,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: sheet.colors.text, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 14),
                FilledButton(
                  key: const Key('pinSave'),
                  onPressed: () async {
                    await rewards.setShowcase(picked);
                    if (sheet.mounted) Navigator.of(sheet).pop();
                  },
                  child: Text(L.of(sheet).doneAction),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Every award held at its highest: each family's top tier, then specials.
List<String> earnedAwardIds() => [
  for (final f in kAwardFamilies)
    if (tierHeld(f, rewards.earned) case final t when t >= 0) f.idOf(t),
  for (final s in kAwardSpecials)
    if (rewards.has(s.id)) s.id,
];

/// An award's medal, by id: the family's tier, or a special.
class AwardMedal extends StatelessWidget {
  const AwardMedal({super.key, required this.id, this.size = 84, this.locked = false});

  final String id;
  final double size;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    if (familyTierOf(id) case final held?) {
      return Medal(tier: held.tier, glyph: held.family.glyph, size: size, locked: locked);
    }
    if (specialOf(id) case final s?) {
      return Medal(tier: s.tier, glyph: s.glyph, size: size, locked: locked);
    }
    return SizedBox(width: size, height: size);
  }
}

class _Caption extends StatelessWidget {
  const _Caption({required this.left, this.right, this.onRight});

  final String left;
  final String? right;
  final VoidCallback? onRight;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
    child: Row(
      children: [
        Expanded(
          child: Text(left, style: TextStyle(color: context.colors.muted, fontSize: 14, fontWeight: FontWeight.w600)),
        ),
        if (right case final r?)
          GestureDetector(
            onTap: onRight,
            child: Text(
              r,
              style: TextStyle(
                color: onRight == null ? context.colors.text : context.colors.brand,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    ),
  );
}

/// The three pinned to the profile, in a gold-edged case.
class _Showcase extends StatelessWidget {
  const _Showcase({required this.ids, this.onEmpty});

  final List<String> ids;
  final VoidCallback? onEmpty;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    return Container(
      key: const Key('showcase'),
      padding: const EdgeInsets.fromLTRB(10, 14, 10, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: [const Color(0xFF2A2214), colors.surface], stops: const [0, 0.6]),
        border: Border.all(color: tierColour(2), width: 1.5),
      ),
      child: ids.isEmpty
          ? InkWell(
              onTap: onEmpty,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 22),
                child: Text(
                  l.awShowcaseEmpty,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.muted, fontSize: 15),
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final id in ids)
                  Expanded(
                    child: Column(
                      children: [
                        AwardMedal(id: id, size: 84),
                        const SizedBox(height: 6),
                        Text(
                          awardName(l, id) ?? id,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: colors.text, fontSize: 12.5, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }
}

class _NewChip extends StatelessWidget {
  const _NewChip();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
    decoration: BoxDecoration(color: const Color(0xFF3A1F17), borderRadius: BorderRadius.circular(5)),
    child: Text(
      L.of(context).awNew,
      style: TextStyle(color: context.colors.rival, fontSize: 9, fontWeight: FontWeight.w800),
    ),
  );
}

class _FamilyTile extends StatelessWidget {
  const _FamilyTile({required this.family, required this.value, required this.onTap});

  final AwardFamily family;
  final int value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final held = tierHeld(family, rewards.earned);
    final next = held + 1;
    final share = next > 4
        ? 1.0
        : (value / family.tiers[next]).clamp(0.0, 1.0);
    return Material(
      key: Key('award_${family.id}'),
      color: colors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 12, 6, 10),
              child: Column(
                children: [
                  AwardRing(
                    size: 76,
                    share: share,
                    colour: tierColour(math.min(next, 4)),
                    child: Medal(
                      tier: math.max(held, 0),
                      glyph: family.glyph,
                      size: 60,
                      locked: held < 0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    familyName(L.of(context), family),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: colors.text, fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  TierPips(reached: held + 1),
                ],
              ),
            ),
            if (family.isNew && held < 0) const Positioned(right: 7, top: 7, child: _NewChip()),
          ],
        ),
      ),
    );
  }
}

class _SpecialTile extends StatelessWidget {
  const _SpecialTile({required this.special, required this.onTap});

  final AwardSpecial special;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final has = rewards.has(special.id);
    return Material(
      key: Key('award_${special.id}'),
      color: colors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 12, 6, 10),
              child: Column(
                children: [
                  SizedBox(
                    width: 76,
                    height: 76,
                    child: Center(child: Medal(tier: special.tier, glyph: special.glyph, size: 64, locked: !has)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    specialName(L.of(context), special),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: colors.text, fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Icon(Icons.star_rounded, size: 12, color: has ? tierColour(special.tier) : colors.border),
                ],
              ),
            ),
            if (special.isNew && !has) const Positioned(right: 7, top: 7, child: _NewChip()),
          ],
        ),
      ),
    );
  }
}

String _rarityLine(L l, String id) {
  final p = awardRarity[id];
  if (p == null) return '';
  return p < 1 ? l.awHeldRare : l.awHeldBy('$p');
}

/// A family's own page: its medal, every tier, how far to the next.
Future<void> showFamilySheet(BuildContext context, AwardFamily family, int value) {
  final l = L.of(context);
  final held = tierHeld(family, rewards.earned);
  final shown = math.max(held, 0);
  final id = family.idOf(shown);
  final next = held + 1;
  return _awardSheet(
    context,
    id: held >= 0 ? id : null,
    medal: Medal(tier: shown, glyph: family.glyph, size: 170, locked: held < 0),
    eyebrow: held >= 0 ? '${tierWord(l, held).toUpperCase()} · ${awardName(l, id)!.toUpperCase()}' : l.awLocked.toUpperCase(),
    colour: tierColour(shown),
    title: familyLine(l, family, family.tiers[shown]),
    tiers: [
      for (var t = 0; t < 5; t++) Medal(tier: t, glyph: family.glyph, size: 50, locked: t > held),
    ],
    next: next > 4
        ? null
        : (
            label: l.momentNext('${tierWord(l, next)} · ${familyLine(l, family, family.tiers[next])}'),
            share: (value / family.tiers[next]).clamp(0.0, 1.0),
            colour: tierColour(next),
          ),
  );
}

/// A special's page.
Future<void> showSpecialSheet(BuildContext context, AwardSpecial special) {
  final l = L.of(context);
  final has = rewards.has(special.id);
  return _awardSheet(
    context,
    id: has ? special.id : null,
    medal: Medal(tier: special.tier, glyph: special.glyph, size: 170, locked: !has),
    eyebrow: (has ? specialName(l, special) : l.awLocked).toUpperCase(),
    colour: tierColour(special.tier),
    title: specialLine(l, special),
    tiers: const [],
    next: null,
  );
}

Future<void> _awardSheet(
  BuildContext context, {
  required String? id,
  required Widget medal,
  required String eyebrow,
  required Color colour,
  required String title,
  required List<Widget> tiers,
  required ({String label, double share, Color colour})? next,
}) => showModalBottomSheet<void>(
  context: context,
  showDragHandle: true,
  isScrollControlled: true,
  backgroundColor: context.colors.surface,
  builder: (sheet) {
    final l = L.of(sheet);
    final colors = sheet.colors;
    final rarity = id == null ? '' : _rarityLine(l, id);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: Column(
          key: const Key('awardSheet'),
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(colors: [colour.withValues(alpha: 0.3), Colors.transparent]),
              ),
              padding: const EdgeInsets.all(14),
              child: PopIn(from: 0.7, child: medal),
            ),
            Text(
              eyebrow,
              textAlign: TextAlign.center,
              style: TextStyle(color: colour, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 3),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.text, fontSize: 24, fontWeight: FontWeight.w900),
            ),
            if (rarity.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(rarity, style: TextStyle(color: colors.muted, fontSize: 14.5)),
            ],
            if (tiers.isNotEmpty) ...[
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: tiers),
            ],
            const SizedBox(height: 16),
            if (next != null)
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                decoration: BoxDecoration(color: colors.background, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(next.label, style: TextStyle(color: colors.text, fontSize: 14.5, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: next.share,
                        minHeight: 8,
                        color: next.colour,
                        backgroundColor: colors.surfaceRaised,
                      ),
                    ),
                  ],
                ),
              )
            else if (tiers.isNotEmpty)
              Text(l.awAllTiers, style: TextStyle(color: colour, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            if (id != null)
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      key: const Key('awardWear'),
                      onPressed: rewards.wearing == id
                          ? null
                          : () async {
                              await rewards.wear(id);
                              if (sheet.mounted) Navigator.of(sheet).pop();
                            },
                      child: Text(rewards.wearing == id ? l.awWearing : l.wearIt),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => SharePlus.instance.share(
                        ShareParams(
                          text: l.awShareText(
                            awardName(l, id) ?? id,
                            awardLine(l, id) ?? '',
                            'https://outrepd.com/u/${demoProfile.username}',
                          ),
                        ),
                      ),
                      child: Text(l.shareAction),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  },
);

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
                  localNumber(context, rewards.streak),
                  style: context.type.display.copyWith(color: context.colors.text, height: 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            L.of(context).dayStreak,
            style: context.type.label.copyWith(color: context.colors.muted),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _Stat(
                  label: L.of(context).bestEver,
                  value: localNumber(context, rewards.bestStreak),
                ),
              ),
              Expanded(
                child: _Stat(
                  label: L.of(context).restDaysLeft,
                  value: localNumber(context, restLeft),
                ),
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
                        context.type.label.copyWith(color: context.colors.muted),
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
          style: context.type.heading.copyWith(color: context.colors.text),
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
                        title.name(L.of(context)),
                        style: context.type.body.copyWith(color: owned
                              ? context.colors.text
                              : context.colors.muted),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        title.hintText(L.of(context)),
                        style: context.type.label.copyWith(color: context.colors.muted),
                      ),
                    ],
                  ),
                ),
                if (worn)
                  Text(
                    L.of(context).worn,
                    style: context.type.label.copyWith(color: colour),
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
            title.name(L.of(context)),
            style: TextStyle(
              color: colour,
              fontSize: compact ? 12 : 13,
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
          style: context.type.heading.copyWith(color: context.colors.text),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(title.icon, size: 44, color: title.colour ?? context.colors.brand),
            const SizedBox(height: 14),
            Text(
              title.name(L.of(context)),
              style: context.type.title.copyWith(color: context.colors.text),
            ),
            const SizedBox(height: 6),
            Text(
              title.hintText(L.of(context)),
              textAlign: TextAlign.center,
              style: context.type.label.copyWith(color: context.colors.muted),
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
