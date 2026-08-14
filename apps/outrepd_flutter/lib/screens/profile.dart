import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'achievements.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = demoProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              backgroundColor: AppColors.surface,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => const _SettingsSheet(),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Column(
            children: [
              TierBadge(tierIdx: p.tierIdx, size: 96),
              const SizedBox(height: 12),
              // Usernames are free text, so cap them rather than let a long
              // one push the layout around.
              Text(
                p.username,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                tierLabel(p.tierIdx, p.divIdx),
                style: const TextStyle(
                  color: AppColors.brand,
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
          const SectionHeader(title: 'Stats'),
          Panel(
            child: Column(
              children: [
                _Row(label: 'Total matches', value: '${p.totalMatches}'),
                _Row(label: 'Best win streak', value: '${p.bestStreak}'),
                _Row(
                  label: 'Total volume lifted',
                  value: formatVolume(p.totalVolumeKg),
                ),
                _Row(label: 'Height', value: '${p.heightCm} cm'),
                _Row(label: 'Bodyweight', value: '${p.weightKg} kg'),
                _Row(label: 'Age', value: '${p.age}', last: true),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Panel(
            padding: EdgeInsets.zero,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const AchievementsScreen()),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              leading: const Icon(Icons.military_tech, color: AppColors.gold),
              title: const Text(
                'Awards',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                '${demoAchievements.where((a) => a.earned).length} of ${demoAchievements.length} unlocked',
                style: const TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              trailing: const Icon(Icons.chevron_right, color: AppColors.muted),
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, this.last = false});
  final String label;
  final String value;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        border: last
            ? null
            : const Border(
                bottom: BorderSide(color: AppColors.surfaceRaised),
              ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.muted)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSheet extends StatelessWidget {
  const _SettingsSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: true,
              onChanged: (_) {},
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Allow match invites',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SwitchListTile(
              value: true,
              onChanged: (_) {},
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Allow friend requests',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Units',
                style: TextStyle(color: Colors.white),
              ),
              trailing: const Text(
                'kg',
                style: TextStyle(color: AppColors.brand),
              ),
              onTap: () {},
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
