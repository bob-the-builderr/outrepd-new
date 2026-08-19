import 'package:flutter/material.dart';

import '../data.dart';
import '../profile_avatar.dart';
import '../rewards.dart';
import '../settings.dart';
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
        const SnackBar(
          content: Text('You have used both of your name changes'),
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
          'Change your name',
          style: TextStyle(color: context.colors.text, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              left == 1
                  ? 'This is your last change. It cannot be undone.'
                  : 'You get $kNameChangesAllowed changes in total. '
                      '$left left after this one.',
              style: TextStyle(color: context.colors.muted, fontSize: 12.5),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: field,
              autofocus: true,
              maxLength: 18,
              style: TextStyle(color: context.colors.text, fontSize: 17),
              decoration: const InputDecoration(counterText: ''),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel',
                style: TextStyle(color: context.colors.muted)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(field.text.trim()),
            child: Text(
              'Save',
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
        title: const Text('Profile'),
        actions: [
          IconButton(
            tooltip: 'Settings',
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
                        style: TextStyle(
                          color: context.colors.text,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
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
                tierLabel(p.tierIdx, p.divIdx),
                style: TextStyle(
                  color: context.colors.brand,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
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
                  label: 'Wins',
                  value: '${p.wins}',
                  color: AppColors.win,
                ),
                StatTile(
                  label: 'Losses',
                  value: '${p.losses}',
                  color: AppColors.loss,
                ),
                StatTile(
                  label: 'Win rate',
                  value: '${(p.winRate * 100).round()}%',
                ),
                StatTile(label: 'Streak', value: '${p.winStreak}'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Stats',
            // Only the three body measurements are yours to set; everything
            // else on this list is earned in matches.
            trailing: TextButton.icon(
              onPressed: _editStats,
              icon: const Icon(Icons.edit_outlined, size: 17),
              label: const Text('Edit'),
              style: TextButton.styleFrom(
                foregroundColor: context.colors.brand,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                textStyle: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Panel(
            child: Column(
              children: [
                _Row(label: 'Total matches', value: '${p.totalMatches}'),
                _Row(label: 'Best win streak', value: '${p.bestStreak}'),
                _Row(
                  label: 'Total volume lifted',
                  value: formatVolume(p.totalVolumeKg),
                ),
                _Row(
                  label: 'Height',
                  value: formatHeight(p.heightCm),
                  editable: true,
                ),
                _Row(
                  label: 'Bodyweight',
                  value: formatBodyWeight(p.weightKg),
                  editable: true,
                ),
                _Row(
                  label: 'Age',
                  value: '${p.age}',
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
                'Awards',
                style: TextStyle(
                  color: context.colors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
              subtitle: Text(
                '${kTitles.where((t) => rewards.has(t.id)).length} of ${kTitles.length} titles · ${rewards.streak} day streak',
                style: TextStyle(color: context.colors.muted, fontSize: 13),
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
  late final _height = TextEditingController(text: '${demoProfile.heightCm}');
  late final _weight = TextEditingController(
    text: '${_toDisplayWeight(demoProfile.weightKg)}',
  );
  late final _age = TextEditingController(text: '${demoProfile.age}');

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
    final height = int.tryParse(_height.text.trim());
    final shownWeight = int.tryParse(_weight.text.trim());
    final age = int.tryParse(_age.text.trim());

    if (height == null || shownWeight == null || age == null) {
      setState(() => _error = 'Fill all three with whole numbers');
      return;
    }
    if (height < 100 || height > 250) {
      setState(() => _error = 'Height should be between 100 and 250 cm');
      return;
    }
    final weightKg = _toKg(shownWeight);
    if (weightKg < 30 || weightKg > 300) {
      setState(() => _error = 'Bodyweight should be between 30 and 300 kg');
      return;
    }
    if (age < 13 || age > 100) {
      setState(() => _error = 'Age should be between 13 and 100');
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
                'Edit your stats',
                style: TextStyle(
                  color: context.colors.text,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Wins, volume and rank are earned — they cannot be edited.',
                style: TextStyle(color: context.colors.muted, fontSize: 12),
              ),
              const SizedBox(height: 20),
              _Field(label: 'Height', suffix: 'cm', controller: _height),
              const SizedBox(height: 14),
              _Field(
                label: 'Bodyweight',
                suffix: settings.weightUnit.short,
                controller: _weight,
              ),
              const SizedBox(height: 14),
              _Field(label: 'Age', suffix: 'years', controller: _age),
              if (_error != null) ...[
                const SizedBox(height: 14),
                Text(
                  _error!,
                  style: const TextStyle(color: AppColors.loss, fontSize: 12.5),
                ),
              ],
              const SizedBox(height: 22),
              FilledButton(onPressed: _save, child: const Text('Save')),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                    'Cancel',
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
            style: TextStyle(
              color: context.colors.muted,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
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
              suffixStyle: TextStyle(color: context.colors.muted, fontSize: 12.5),
            ),
          ),
        ),
      ],
    );
  }
}
