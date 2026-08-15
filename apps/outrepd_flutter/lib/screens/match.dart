import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../data.dart';
import '../theme.dart';
import '../widgets.dart';
import 'match_entry.dart';
import 'notifications.dart';

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = demoProfile;
    final unread = demoNotifications.where((n) => n.unread).length;

    return Scaffold(
      appBar: AppBar(
        // Home tab — never show a back arrow, whatever pushed us here.
        automaticallyImplyLeading: false,
        title: const Text('OUTREPD'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const NotificationsScreen(),
                  ),
                ),
              ),
              if (unread > 0)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: AppColors.loss,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _RankCard(p: p),
          const SizedBox(height: 24),
          const _StartMatchActions(),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Recent matches',
            trailing: Text(
              '${p.wins}W · ${p.losses}L',
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
          ),
          ...demoMatches.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MatchRow(m: m),
              )),
        ],
      ),
    );
  }
}

class _RankCard extends StatelessWidget {
  const _RankCard({required this.p});
  final Profile p;

  @override
  Widget build(BuildContext context) {
    final tierColor = kTiers[p.tierIdx.clamp(0, kTiers.length - 1)].color;
    // The badge dominates the screen, so size it off the viewport rather than
    // a fixed number. The halo hugs it closely — a wide one washed the glow
    // out into a haze instead of rimming the badge.
    final badge = MediaQuery.of(context).size.width * 0.74;
    // Room for the blur to bleed past the crest; a tight box would clip it
    // back into a hard square.
    final halo = badge * 1.22;

    // No card behind it: the badge and its halo sit straight on the page.
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Column(
        children: [
          SizedBox(
            width: halo,
            height: halo,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Blurred, tinted copies of the badge itself sit behind it, so
                // the light follows the crest's own silhouette instead of
                // haloing it with a plain circle.
                _BadgeGlow(
                  tierIdx: p.tierIdx,
                  color: tierColor,
                  size: badge,
                  blur: 26,
                  opacity: 0.5,
                ),
                _BadgeGlow(
                  tierIdx: p.tierIdx,
                  color: tierColor,
                  size: badge,
                  blur: 9,
                  opacity: 0.65,
                ),
                TierBadge(tierIdx: p.tierIdx, size: badge),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            tierLabel(p.tierIdx, p.divIdx),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (p.lp / 100).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppColors.surfaceRaised,
              valueColor: const AlwaysStoppedAnimation(AppColors.brand),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${p.lp} / 100 LP · ${100 - p.lp} to promotion',
            style: const TextStyle(color: AppColors.muted, fontSize: 11.5),
          ),
          if (p.winStreak > 0) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.win.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.local_fire_department,
                      color: AppColors.win, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '${p.winStreak} win streak',
                    style: const TextStyle(
                      color: AppColors.win,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A soft, tinted copy of the tier badge used to light its own edges.
class _BadgeGlow extends StatelessWidget {
  const _BadgeGlow({
    required this.tierIdx,
    required this.color,
    required this.size,
    required this.blur,
    required this.opacity,
  });

  final int tierIdx;
  final Color color;
  final double size;
  final double blur;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: ColorFiltered(
          // Paints every opaque pixel of the crest in the tier colour while
          // keeping its alpha, so the blur spreads the shape, not a box.
          colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
          child: TierBadge(tierIdx: tierIdx, size: size),
        ),
      ),
    );
  }
}

const muscleIcons = <String, IconData>{
  'Chest': Icons.fitness_center,
  'Back': Icons.rowing,
  'Legs': Icons.directions_run,
  'Shoulders': Icons.accessibility_new,
  'Arms': Icons.sports_gymnastics,
  'Core': Icons.self_improvement,
};

/// The three ways into a match: ranked search up top, then the two social
/// routes side by side beneath it.
class _StartMatchActions extends StatelessWidget {
  const _StartMatchActions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _PrimaryAction(
          icon: Icons.search,
          label: 'Search for opponent',
          caption: 'Get matched with a lifter at your rank',
          onTap: () => pickMuscle(context, mode: MatchMode.ranked),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _SecondaryAction(
                icon: Icons.person_add_alt_1,
                label: 'Challenge friend',
                onTap: () => showFriendRoomSheet(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SecondaryAction(
                icon: Icons.groups_2,
                label: 'Crew',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CrewScreen()),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  const _PrimaryAction({
    required this.icon,
    required this.label,
    required this.caption,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String caption;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            // Keep both stops bright: mixing towards black turned the button
            // a muddy grey next to the rest of the blue UI.
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.lerp(AppColors.brand, Colors.white, 0.12)!,
                AppColors.brand,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.brand.withValues(alpha: 0.3),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      caption,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryAction extends StatelessWidget {
  const _SecondaryAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Stacked so both cards keep the same height and weight no matter how
    // long the label is.
    return Panel(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        children: [
          Icon(icon, color: AppColors.brand, size: 26),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _MatchRow extends StatelessWidget {
  const _MatchRow({required this.m});
  final MatchRecord m;

  @override
  Widget build(BuildContext context) {
    final color = m.won ? AppColors.win : AppColors.loss;
    return Panel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              m.won ? 'W' : 'L',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${m.muscleGroup} vs ${m.opponent}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${formatVolume(m.userVolume)} · ${formatVolume(m.opponentVolume)} · ${relativeDays(m.daysAgo)}',
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '${m.lpChange > 0 ? '+' : ''}${m.lpChange}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
