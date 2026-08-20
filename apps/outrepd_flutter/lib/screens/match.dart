import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../data.dart';
import '../motion.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets.dart';
import 'match_entry.dart';
import 'match_history.dart';
import 'roadmap.dart';
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
          IconButton(
            tooltip: L.of(context).matchHistory,
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const MatchHistoryScreen()),
            ),
          ),
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
    // The box only reserves layout space — the glow is free to spill past it
    // because the stack does not clip. Padding it out just pushed the buttons
    // below the fold.
    final halo = badge;

    void openRoad() => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => RoadmapScreen(profile: p)),
        );

    // No card behind it: the badge and its halo sit straight on the page.
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Column(
        children: [
          GestureDetector(
            onTap: openRoad,
            child: SizedBox(
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
                  Breathe(child: TierBadge(tierIdx: p.tierIdx, size: badge)),
                ],
              ),
            ),
          ),
          // Pulled up into the crest's own transparent margin, which otherwise
          // reads as dead space between the artwork and the text.
          Transform.translate(
            offset: Offset(0, -badge * 0.12),
            child: Column(
              children: [
                // Without a cue the tappable badge goes undiscovered. It sits
                // above the rank so the two read as one block, and is itself
                // tappable — people reach for the words, not just the crest.
                GestureDetector(
                  onTap: openRoad,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          L.of(context).viewRoadmap,
                          style: TextStyle(
                            color: context.colors.brand.withValues(alpha: 0.9),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 15,
                          color: context.colors.brand.withValues(alpha: 0.9),
                        ),
                      ],
                    ),
                  ),
                ),
                // Equal air above and below so the rank reads as centred
                // between the cue and the LP bar.
                const SizedBox(height: 10),
                Text(
                  tierLabel(L.of(context), p.tierIdx, p.divIdx),
                  style: TextStyle(
                    color: context.colors.text,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          GrowingBar(
            value: p.lp / 100,
            colour: context.colors.brand,
            background: context.colors.surfaceRaised,
          ),
          const SizedBox(height: 8),
          Text(
            L.of(context).lpProgress(
              localNumber(context, p.lp),
              localNumber(context, 100 - p.lp),
            ),
            style: TextStyle(color: context.colors.muted, fontSize: 11.5),
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
                    L.of(context).winStreak(localNumber(context, p.winStreak)),
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
          label: L.of(context).searchOpponent,
          caption: L.of(context).searchOpponentHint,
          onTap: () => pickMuscle(context, mode: MatchMode.ranked),
        ),
        const SizedBox(height: 12),
        // Crews have their own tab now, so this row is just the friend route.
        _SecondaryAction(
          icon: Icons.person_add_alt_1,
          label: L.of(context).challengeFriend,
          onTap: () => showFriendRoomSheet(context),
        ),
        // No separate "train with the camera" route. The camera is not a mode
        // you opt into any more — it is how a match is judged, so a button
        // beside the match button offering the same thing without an opponent
        // only invited people to practise counting instead of competing.
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
                Color.lerp(context.colors.brand, Colors.white, 0.12)!,
                context.colors.brand,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: context.colors.brand.withValues(alpha: 0.3),
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
                      style: TextStyle(
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
          Icon(icon, color: context.colors.brand, size: 26),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.colors.text,
              fontWeight: FontWeight.w700,
              fontSize: 13.5,
            ),
          ),
        ],
      ),
    );
  }
}
