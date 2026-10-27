/// The adventure's map: seven worlds of twenty levels climbing up the screen,
/// the weapon in hand, and the next fight. Plus the card on the Match tab
/// that leads here.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../adventure/adventure.dart';
import '../adventure/golem.dart';
import '../adventure/names.dart';
import '../adventure/weapon_art.dart';
import '../l10n/app_localizations.dart';
import '../motion.dart';
import '../theme.dart';
import '../widgets.dart';
import 'match_entry.dart';
import 'match_flow.dart';

/// Into a fight on [level].
Future<void> startAdventure(BuildContext context, AdventureLevel level) {
  return Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) =>
          MatchFlowScreen(mode: MatchMode.practice, adventure: level),
    ),
  );
}

Future<void> openAdventureMap(BuildContext context) {
  return Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const AdventureMapScreen()),
  );
}

// ─────────────────────────────── Match tab ───────────────────────────────────

/// On the Match tab, where the friend button and the practice link were: the
/// next monster, the level, and how far through the hundred and forty.
class AdventureCard extends StatelessWidget {
  const AdventureCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Adventure.instance,
      builder: (context, _) {
        final l = L.of(context);
        final colors = context.colors;
        final adventure = Adventure.instance;
        final level = AdventureLevel.of(adventure.current);
        final look = WorldLook.of(level.world);

        return PressScale(
          child: Material(
            key: const Key('adventureCard'),
            color: colors.surface,
            borderRadius: BorderRadius.circular(18),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => openAdventureMap(context),
              child: Container(
                padding: const EdgeInsets.fromLTRB(4, 8, 14, 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: colors.border, width: 0.5),
                  gradient: RadialGradient(
                    center: const Alignment(-0.78, 0.1),
                    radius: 0.9,
                    colors: [
                      look.eye.withValues(alpha: 0.22),
                      look.eye.withValues(alpha: 0),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Golem(level: level, size: 88),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.adventure,
                            style: TextStyle(
                              color: colors.rival,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l.adventureLevelIn(
                              localNumber(context, level.number),
                              worldName(l, level.world),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors.text,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _Track(
                            share: adventure.clearedCount / kAdventureLevels,
                            colour: colors.rival,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            l.adventureClearedOf(
                              localNumber(context, adventure.clearedCount),
                              localNumber(context, kAdventureLevels),
                            ),
                            style: TextStyle(color: colors.muted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: colors.muted),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A thin bar, [share] of it filled.
class _Track extends StatelessWidget {
  const _Track({required this.share, required this.colour, this.height = 6});

  final double share;
  final Color colour;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: context.colors.surfaceRaised),
            FractionallySizedBox(
              alignment: AlignmentDirectional.centerStart,
              // A sliver at the very start, so an empty bar still reads as a
              // bar with somewhere to go.
              widthFactor: share <= 0 ? 0.02 : share.clamp(0.0, 1.0),
              child: ColoredBox(color: colour),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────── the map ────────────────────────────────────

/// One level's step up the path.
const _step = 74.0;

/// Room at the bottom of each world for its gate.
const _gate = 56.0;

const _worldHeight = kLevelsPerWorld * _step + _gate;

class AdventureMapScreen extends StatefulWidget {
  const AdventureMapScreen({super.key});

  @override
  State<AdventureMapScreen> createState() => _AdventureMapScreenState();
}

class _AdventureMapScreenState extends State<AdventureMapScreen> {
  final _scroll = ScrollController();

  /// The level the panel at the bottom offers. The next one to win unless
  /// the lifter has picked a won one to fight again.
  late int _selected = Adventure.instance.current;

  /// The world the banner names: the one in the middle of the view.
  late int _world = AdventureLevel.of(_selected).world;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
    Adventure.instance.addListener(_onProgress);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollTo(_selected));
  }

  @override
  void dispose() {
    Adventure.instance.removeListener(_onProgress);
    _scroll.dispose();
    super.dispose();
  }

  /// Back from a fight: if it was won, the panel moves on to the next one.
  void _onProgress() {
    if (!mounted) return;
    setState(() {
      final current = Adventure.instance.current;
      if (!Adventure.instance.playable(_selected) ||
          Adventure.instance.cleared(_selected)) {
        _selected = current;
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollTo(_selected));
  }

  /// How far up the list [level]'s node sits, from the bottom.
  static double _nodeOffset(int level) {
    final world = (level - 1) ~/ kLevelsPerWorld;
    final i = (level - 1) % kLevelsPerWorld;
    return world * _worldHeight + _gate + i * _step + _step / 2;
  }

  void _scrollTo(int level) {
    if (!_scroll.hasClients) return;
    final position = _scroll.position;
    final target = (_nodeOffset(level) - position.viewportDimension / 2).clamp(
      0.0,
      position.maxScrollExtent,
    );
    _scroll.jumpTo(target);
    _onScroll();
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    final middle =
        _scroll.offset + _scroll.position.viewportDimension / 2;
    final world = (middle / _worldHeight).floor().clamp(0, kWorlds - 1);
    if (world != _world) setState(() => _world = world);
  }

  void _pick(int level) {
    final l = L.of(context);
    if (!Adventure.instance.playable(level)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              l.clearFirst(localNumber(context, Adventure.instance.current)),
            ),
          ),
        );
      return;
    }
    setState(() => _selected = level);
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final adventure = Adventure.instance;
    final level = AdventureLevel.of(_selected);
    final cleared = [
      for (var n = _world * kLevelsPerWorld + 1;
          n <= (_world + 1) * kLevelsPerWorld;
          n++)
        if (adventure.cleared(n)) n,
    ].length;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: colors.text,
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  Expanded(
                    child: Text(
                      l.adventure,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colors.text,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Icon(Icons.star_rounded, color: AppColors.gold, size: 18),
                  const SizedBox(width: 3),
                  Text(
                    localNumber(context, adventure.totalStars),
                    key: const Key('adventureStars'),
                    style: TextStyle(
                      color: colors.muted,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _WeaponChip(
                    weapon: adventure.weapon,
                    onTap: () => showArmory(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: _WorldBanner(world: _world, cleared: cleared),
            ),
            Expanded(
              child: ListView(
                key: const Key('adventurePath'),
                controller: _scroll,
                // Level one at the bottom: the climb goes up.
                reverse: true,
                padding: EdgeInsets.zero,
                children: [
                  for (var world = 0; world < kWorlds; world++)
                    _WorldPath(
                      world: world,
                      selected: _selected,
                      onPick: _pick,
                    ),
                ],
              ),
            ),
            _Panel(
              level: level,
              onFight: () => startAdventure(context, level),
              onArmory: () => showArmory(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeaponChip extends StatelessWidget {
  const _WeaponChip({required this.weapon, required this.onTap});

  final Weapon weapon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surface,
      shape: StadiumBorder(side: BorderSide(color: colors.border)),
      child: InkWell(
        key: const Key('weaponChip'),
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 5, 12, 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              WeaponArt(weapon: weapon, size: 26),
              const SizedBox(width: 6),
              Text(
                localNumber(context, weapon.damage),
                style: TextStyle(
                  color: colors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorldBanner extends StatelessWidget {
  const _WorldBanner({required this.world, required this.cleared});

  final int world;
  final int cleared;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final look = WorldLook.of(world);
    return Container(
      key: const Key('worldBanner'),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border, width: 0.5),
        // The world's metal washing into the card from the left. A gradient
        // replaces a box's colour rather than sitting on it, so the card's
        // own colour is the gradient's far end.
        gradient: LinearGradient(
          colors: [
            Color.alphaBlend(
              look.light.withValues(alpha: 0.16),
              colors.surface,
            ),
            colors.surface,
          ],
        ),
      ),
      child: Row(
        children: [
          Text(
            l.worldNumber(localNumber(context, world + 1)),
            style: TextStyle(
              color: colors.muted,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              worldName(l, world),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colors.text,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            '${localNumber(context, cleared)} / ${localNumber(context, kLevelsPerWorld)}',
            style: TextStyle(color: colors.muted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

/// One world's twenty levels, bottom to top, on a dotted path, with its gate
/// at the foot.
class _WorldPath extends StatelessWidget {
  const _WorldPath({
    required this.world,
    required this.selected,
    required this.onPick,
  });

  final int world;
  final int selected;
  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;

    return LayoutBuilder(
      builder: (context, box) {
        final width = box.maxWidth;
        final amp = width * 0.24;

        // Centre of level i (0 at the bottom of this world), measured from
        // the top of this world's box.
        Offset centre(int i) => Offset(
          width / 2 + amp * math.sin(i * 0.9 + world * 1.3),
          _worldHeight - _gate - i * _step - _step / 2,
        );

        return SizedBox(
          height: _worldHeight,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _PathPainter(
                    points: [for (var i = 0; i < kLevelsPerWorld; i++) centre(i)],
                    colour: colors.border,
                  ),
                ),
              ),
              // The gate: where this world starts.
              Positioned(
                left: 24,
                right: 24,
                bottom: 10,
                child: Row(
                  children: [
                    Expanded(child: Divider(color: colors.border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        '${l.worldNumber(localNumber(context, world + 1))} · ${worldName(l, world)}',
                        style: TextStyle(color: colors.faint, fontSize: 12),
                      ),
                    ),
                    Expanded(child: Divider(color: colors.border)),
                  ],
                ),
              ),
              for (var i = 0; i < kLevelsPerWorld; i++)
                _placed(
                  centre(i),
                  AdventureLevel.of(world * kLevelsPerWorld + i + 1),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _placed(Offset at, AdventureLevel level) {
    final size = switch (level.kind) {
      FightKind.boss => 66.0,
      FightKind.elite => 54.0,
      FightKind.regular => 46.0,
    };
    return Positioned(
      left: at.dx - size / 2,
      top: at.dy - size / 2,
      child: _LevelNode(
        level: level,
        size: size,
        selected: level.number == selected,
        onTap: () => onPick(level.number),
      ),
    );
  }
}

class _PathPainter extends CustomPainter {
  _PathPainter({required this.points, required this.colour});

  final List<Offset> points;
  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    final dot = Paint()..color = colour;
    // Dots every few pixels along each leg, so the path reads as a trail.
    for (var i = 0; i + 1 < points.length; i++) {
      final a = points[i];
      final b = points[i + 1];
      final length = (b - a).distance;
      final count = (length / 13).floor();
      for (var k = 1; k < count; k++) {
        canvas.drawCircle(Offset.lerp(a, b, k / count)!, 3, dot);
      }
    }
    // And down from the first level to the gate.
    if (points.isNotEmpty) {
      final first = points.first;
      for (var y = first.dy + 20; y < size.height - 30; y += 13) {
        canvas.drawCircle(Offset(first.dx, y), 3, dot);
      }
    }
  }

  @override
  bool shouldRepaint(_PathPainter old) {
    if (old.colour != colour || old.points.length != points.length) return true;
    for (var i = 0; i < points.length; i++) {
      if (old.points[i] != points[i]) return true;
    }
    return false;
  }
}

class _LevelNode extends StatelessWidget {
  const _LevelNode({
    required this.level,
    required this.size,
    required this.selected,
    required this.onTap,
  });

  final AdventureLevel level;
  final double size;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final adventure = Adventure.instance;
    final stars = adventure.starsAt(level.number);
    final won = stars > 0;
    final current = level.number == adventure.current && !won;
    final open = adventure.playable(level.number);
    final big = level.kind != FightKind.regular;

    final Color fill = won
        ? colors.brand
        : current
        ? colors.rival
        : colors.surfaceRaised;
    final Widget face = won || current
        ? Text(
            localNumber(context, level.number),
            style: TextStyle(
              color: colors.background,
              fontSize: big ? 18 : 16,
              fontWeight: FontWeight.w800,
            ),
          )
        : big
        ? Opacity(
            opacity: 0.55,
            child: Golem(level: level, size: size * 0.78),
          )
        : Icon(Icons.lock_outline, size: 18, color: colors.faint);

    return GestureDetector(
      key: Key('level-${level.number}'),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: fill,
              border: selected && open
                  ? Border.all(
                      color: current ? colors.background : colors.rival,
                      width: 3,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    )
                  : won || current
                  ? null
                  : Border.all(color: colors.border),
              boxShadow: current
                  ? [
                      BoxShadow(
                        color: colors.rival.withValues(alpha: 0.55),
                        blurRadius: 26,
                        spreadRadius: 4,
                      ),
                    ]
                  : null,
            ),
            child: face,
          ),
          if (won)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < 3; i++)
                    Icon(
                      Icons.star_rounded,
                      size: 12,
                      color: i < stars ? AppColors.gold : colors.surfaceRaised,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Under the map: the level picked, the weapon to earn next, and the fight.
class _Panel extends StatelessWidget {
  const _Panel({
    required this.level,
    required this.onFight,
    required this.onArmory,
  });

  final AdventureLevel level;
  final VoidCallback onFight;
  final VoidCallback onArmory;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final adventure = Adventure.instance;
    final weapon = adventure.weapon;
    final next = adventure.nextWeapon;

    BoxDecoration card() => BoxDecoration(
      color: colors.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: colors.border, width: 0.5),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
      decoration: BoxDecoration(
        color: colors.background,
        boxShadow: [
          BoxShadow(
            color: colors.background,
            blurRadius: 24,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            key: const Key('levelPanel'),
            padding: const EdgeInsets.fromLTRB(8, 8, 14, 8),
            decoration: card(),
            child: Row(
              children: [
                Golem(level: level, size: 56),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l.stageNumber(localNumber(context, level.number))}'
                        ' · ${monsterName(l, level)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.text,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.levelHpLine(
                          localNumber(context, level.hp),
                          localNumber(context, level.repsWith(weapon)),
                        ),
                        style: TextStyle(color: colors.muted, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (next != null) ...[
            const SizedBox(height: 8),
            Material(
              color: Colors.transparent,
              child: InkWell(
                key: const Key('nextWeapon'),
                onTap: onArmory,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: card(),
                  child: Row(
                    children: [
                      WeaponArt(weapon: next, size: 34, locked: true),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${weaponName(l, next)} · ${l.perPushUp(localNumber(context, next.damage))}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colors.text,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              l.moreStars(
                                localNumber(
                                  context,
                                  next.stars - adventure.totalStars,
                                ),
                              ),
                              style: TextStyle(
                                color: colors.muted,
                                fontSize: 12.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 72,
                        child: _Track(
                          share:
                              (adventure.totalStars - weapon.stars) /
                              (next.stars - weapon.stars),
                          colour: AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              key: const Key('fightLevel'),
              style: FilledButton.styleFrom(
                backgroundColor: colors.rival,
                foregroundColor: colors.background,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: onFight,
              child: Text(l.fightLevel(localNumber(context, level.number))),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────── the armory ──────────────────────────────────

Future<void> showArmory(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) => const _Armory(),
  );
}

/// Every weapon: the ones unlocked with what they hit for, the rest with the
/// stars they wait on.
class _Armory extends StatelessWidget {
  const _Armory();

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final adventure = Adventure.instance;
    final inHand = adventure.weapon;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Column(
          key: const Key('armory'),
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: colors.surfaceRaised,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Expanded(
                  child: Text(
                    l.armory,
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.gold,
                  size: 16,
                ),
                const SizedBox(width: 3),
                Text(
                  '${localNumber(context, adventure.totalStars)} / ${localNumber(context, kMaxStars)}',
                  style: TextStyle(color: colors.muted, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l.armoryBody,
              style: TextStyle(color: colors.muted, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.9,
              children: [
                for (final weapon in kWeapons)
                  _ArmoryTile(
                    weapon: weapon,
                    owned: adventure.totalStars >= weapon.stars,
                    inHand: weapon.index == inHand.index,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ArmoryTile extends StatelessWidget {
  const _ArmoryTile({
    required this.weapon,
    required this.owned,
    required this.inHand,
  });

  final Weapon weapon;
  final bool owned;
  final bool inHand;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: inHand ? colors.surfaceRaised : colors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: inHand ? colors.rival : colors.border,
          width: inHand ? 1.5 : 0.5,
        ),
      ),
      child: Row(
        children: [
          WeaponArt(weapon: weapon, size: 46, locked: !owned),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShrinkText(
                  weaponName(l, weapon),
                  maxLines: 2,
                  style: TextStyle(
                    color: owned ? colors.text : colors.faint,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (!owned) ...[
                      Icon(Icons.lock_outline, size: 13, color: colors.faint),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.star_rounded,
                        size: 13,
                        color: AppColors.gold,
                      ),
                      const SizedBox(width: 2),
                    ],
                    Flexible(
                      child: Text(
                        owned
                            ? l.perPushUp(localNumber(context, weapon.damage))
                            : localNumber(context, weapon.stars),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: owned ? AppColors.gold : colors.faint,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                if (inHand)
                  Text(
                    l.equipped,
                    style: TextStyle(
                      color: colors.rival,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
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
