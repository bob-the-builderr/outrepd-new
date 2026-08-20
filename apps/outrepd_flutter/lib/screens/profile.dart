import 'package:flutter/material.dart';

import '../data.dart';
import '../profile_avatar.dart';
import '../rewards.dart';
import '../settings.dart';
import '../l10n/app_localizations.dart';
import '../type_scale.dart';
import '../theme.dart';
import '../widgets.dart';
import 'awards.dart';
import 'avatar_picker.dart';
import 'settings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
    // Units may have changed while we were away, so redraw the stats.
    if (mounted) setState(() {});
  }

  /// A name is how people pick you out of a leaderboard, so it does not change
  /// freely — twice for the life of the account, and the count is shown before
  /// anyone spends one rather than after.
  Future<void> _editName() async {
    if (!canChangeName) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(L.of(context).changeNameUsedUp),
        ),
      );
      return;
    }

    final field = TextEditingController(text: demoProfile.username);
    final left = kNameChangesAllowed - nameChangesUsed;

    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.colors.surface,
        title: Text(
          L.of(context).changeName,
          style: context.type.heading.copyWith(color: context.colors.text),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              left == 1
                  ? L.of(context).changeNameLast
                  : L.of(context).changeNameLeft(
                      localNumber(context, kNameChangesAllowed),
                      localNumber(context, left),
                    ),
              style: context.type.label.copyWith(color: context.colors.muted),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: field,
              autofocus: true,
              maxLength: 18,
              style: context.type.heading.copyWith(color: context.colors.text),
              decoration: const InputDecoration(counterText: ''),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(L.of(context).cancel,
                style: TextStyle(color: context.colors.muted)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(field.text.trim()),
            child: Text(
              L.of(context).save,
              style: TextStyle(
                color: context.colors.brand,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
    field.dispose();

    if (name == null || name.length < 3 || name == demoProfile.username) return;
    await changeUsername(name);
    if (mounted) setState(() {});
  }

  Future<void> _editStats() async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => const _EditStatsSheet(),
    );
    if (saved == true && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final p = demoProfile;

    return Scaffold(
      appBar: AppBar(
        title: Text(L.of(context).profile),
        actions: [
          IconButton(
            tooltip: L.of(context).settings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: _openSettings,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Column(
            children: [
              ProfileAvatar(
                tierIdx: p.tierIdx,
                size: 172,
                onTap: () async {
                  await showAvatarPicker(context, p.tierIdx);
                  if (mounted) setState(() {});
                },
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _editName,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Usernames are free text, so cap them rather than let a
                    // long one push the layout around.
                    Flexible(
                      child: Text(
                        p.username,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.type.title.copyWith(color: context.colors.text),
                      ),
                    ),
                    if (canChangeName) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.edit_outlined,
                        size: 17,
                        color: context.colors.muted,
                      ),
                    ],
                  ],
                ),
              ),
              if (rewards.worn case final title?) ...[
                const SizedBox(height: 8),
                TitleChip(title: title),
              ],
              const SizedBox(height: 4),
              Text(
                tierLabel(L.of(context), p.tierIdx, p.divIdx),
                style: context.type.body.copyWith(color: context.colors.brand),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Panel(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatTile(
                  label: L.of(context).wins,
                  value: localNumber(context, p.wins),
                  color: AppColors.win,
                ),
                StatTile(
                  label: L.of(context).losses,
                  value: localNumber(context, p.losses),
                  color: AppColors.loss,
                ),
                StatTile(
                  label: L.of(context).winRate,
                  value: '${localNumber(context, (p.winRate * 100).round())}%',
                ),
                StatTile(
                  label: L.of(context).streak,
                  value: localNumber(context, p.winStreak),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: L.of(context).stats,
            // Only the three body measurements are yours to set; everything
            // else on this list is earned in matches.
            trailing: TextButton.icon(
              onPressed: _editStats,
              icon: const Icon(Icons.edit_outlined, size: 17),
              label: Text(L.of(context).edit),
              style: TextButton.styleFrom(
                foregroundColor: context.colors.brand,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                textStyle: context.type.label,
              ),
            ),
          ),
          Panel(
            child: Column(
              children: [
                _Row(
                  label: L.of(context).totalMatches,
                  value: localNumber(context, p.totalMatches),
                ),
                _Row(
                  label: L.of(context).bestWinStreak,
                  value: localNumber(context, p.bestStreak),
                ),
                _Row(
                  label: L.of(context).totalVolume,
                  value: formatVolume(context, L.of(context), p.totalVolumeKg),
                ),
                _Row(
                  label: L.of(context).height,
                  value: formatHeight(context, L.of(context), p.heightCm),
                  editable: true,
                ),
                _Row(
                  label: L.of(context).bodyweight,
                  value: formatBodyWeight(context, L.of(context), p.weightKg),
                  editable: true,
                ),
                _Row(
                  label: L.of(context).age,
                  value: localNumber(context, p.age),
                  editable: true,
                  last: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Panel(
            padding: EdgeInsets.zero,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AwardsScreen()),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: const Icon(Icons.military_tech, color: AppColors.gold),
              title: Text(
                L.of(context).awards,
                style: TextStyle(
                  color: context.colors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                L.of(context).titlesAndStreak(
                  localNumber(
                      context, kTitles.where((t) => rewards.has(t.id)).length),
                  localNumber(context, kTitles.length),
                  localNumber(context, rewards.streak),
                ),
                style: context.type.label.copyWith(color: context.colors.muted),
              ),
              trailing: Icon(Icons.chevron_right, color: context.colors.muted),
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.last = false,
    this.editable = false,
  });

  final String label;
  final String value;
  final bool last;

  /// Marks the rows the Edit button reaches, so it is obvious which numbers
  /// are yours to change and which the app keeps score of.
  final bool editable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        border: last
            ? null
            : Border(bottom: BorderSide(color: context.colors.surfaceRaised)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: context.colors.muted)),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  color: context.colors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (editable) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.edit_outlined,
                  size: 13,
                  color: context.colors.muted.withValues(alpha: 0.7),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// Height, bodyweight and age — the only three numbers a lifter sets by hand.
class _EditStatsSheet extends StatefulWidget {
  const _EditStatsSheet();

  @override
  State<_EditStatsSheet> createState() => _EditStatsSheetState();
}

class _EditStatsSheetState extends State<_EditStatsSheet> {
  // Filled in didChangeDependencies rather than here: the digits depend on
  // the locale, and there is no context yet at field-initialiser time.
  final _height = TextEditingController();
  final _weight = TextEditingController();
  final _age = TextEditingController();
  bool _filled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_filled) return;
    _filled = true;
    _height.text = localNumber(context, demoProfile.heightCm);
    _weight.text =
        localNumber(context, _toDisplayWeight(demoProfile.weightKg));
    _age.text = localNumber(context, demoProfile.age);
  }

  String? _error;

  static int _toDisplayWeight(int kg) =>
      settings.weightUnit == WeightUnit.kg ? kg : (kg * 2.20462).round();

  static int _toKg(int shown) =>
      settings.weightUnit == WeightUnit.kg ? shown : (shown / 2.20462).round();

  @override
  void dispose() {
    _height.dispose();
    _weight.dispose();
    _age.dispose();
    super.dispose();
  }

  void _save() {
    // Accepts ١٧٥ as readily as 175 — the field shows localised digits, so an
    // Arabic keyboard's own output has to parse.
    final height = parseLocalNumber(_height.text);
    final shownWeight = parseLocalNumber(_weight.text);
    final age = parseLocalNumber(_age.text);

    if (height == null || shownWeight == null || age == null) {
      setState(() => _error = L.of(context).fillWholeNumbers);
      return;
    }
    if (height < 100 || height > 250) {
      setState(() => _error = L.of(context).heightRange(
            localNumber(context, 100),
            localNumber(context, 250),
            L.of(context).shortCm,
          ));
      return;
    }
    final weightKg = _toKg(shownWeight);
    if (weightKg < 30 || weightKg > 300) {
      setState(() => _error = L.of(context).weightRange(
            localNumber(context, 30),
            localNumber(context, 300),
            L.of(context).shortKg,
          ));
      return;
    }
    if (age < 13 || age > 100) {
      setState(() => _error = L.of(context).ageRange(
            localNumber(context, 13),
            localNumber(context, 100),
          ));
      return;
    }

    demoProfile
      ..heightCm = height
      ..weightKg = weightKg
      ..age = age;
    // Fire and forget — the sheet closes now, the write lands a moment later.
    saveProfileStats();
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                L.of(context).editYourStats,
                style: context.type.heading.copyWith(color: context.colors.text),
              ),
              const SizedBox(height: 4),
              Text(
                L.of(context).editStatsHint,
                style: context.type.label.copyWith(color: context.colors.muted),
              ),
              const SizedBox(height: 20),
              _Field(
                label: L.of(context).height,
                suffix: settings.heightUnit.short(L.of(context)),
                controller: _height,
              ),
              const SizedBox(height: 14),
              _Field(
                label: L.of(context).bodyweight,
                suffix: settings.weightUnit.short(L.of(context)),
                controller: _weight,
              ),
              const SizedBox(height: 14),
              _Field(
                label: L.of(context).age,
                suffix: L.of(context).yearsSuffix,
                controller: _age,
              ),
              if (_error != null) ...[
                const SizedBox(height: 14),
                Text(
                  _error!,
                  style: context.type.label.copyWith(color: AppColors.loss),
                ),
              ],
              const SizedBox(height: 22),
              FilledButton(
                onPressed: _save,
                child: Text(L.of(context).save),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    L.of(context).cancel,
                    style: TextStyle(color: context.colors.muted),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.suffix,
    required this.controller,
  });

  final String label;
  final String suffix;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: context.type.body.copyWith(color: context.colors.muted),
          ),
        ),
        SizedBox(
          width: 118,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: context.colors.text,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              suffixText: suffix,
              suffixStyle: context.type.label.copyWith(color: context.colors.muted),
            ),
          ),
        ),
      ],
    );
  }
}
