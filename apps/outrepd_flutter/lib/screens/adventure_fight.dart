/// The adventure's fight: the card over the camera while it runs, and the two
/// screens after it — the new weapon, when there is one, and the result.
library;

import 'dart:math' as math;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

import '../adventure/adventure.dart';
import '../adventure/golem.dart';
import '../adventure/names.dart';
import '../adventure/weapon_art.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets.dart';
import '../xp.dart';
import 'trainer.dart';

/// The game the camera plays: every push-up hits [level]'s monster with
/// [weapon], and the round ends the moment it is down.
class FightGame implements CameraGame {
  FightGame({required this.level, required this.weapon});

  final AdventureLevel level;
  final Weapon weapon;

  @override
  bool wonAt(int reps) => reps * weapon.damage >= level.hp;

  @override
  Widget card(
    BuildContext context, {
    required int reps,
    required Duration remaining,
    required bool counting,
    required VoidCallback onStop,
  }) => FightCard(
    key: const Key('fightCard'),
    level: level,
    weapon: weapon,
    reps: reps,
    remaining: remaining,
    counting: counting,
    onStop: onStop,
  );
}

/// Push-ups closer together than this keep a combo going.
const _comboGap = Duration(milliseconds: 2200);

/// The fight, on top of the camera the way the live match's score card sits:
/// the monster and what it has left, the clock, and the way out.
class FightCard extends StatefulWidget {
  const FightCard({
    super.key,
    required this.level,
    required this.weapon,
    required this.reps,
    required this.remaining,
    required this.counting,
    required this.onStop,
  });

  final AdventureLevel level;
  final Weapon weapon;
  final int reps;
  final Duration remaining;
  final bool counting;
  final VoidCallback onStop;

  @override
  State<FightCard> createState() => _FightCardState();
}

class _FightCardState extends State<FightCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hit = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );

  DateTime? _lastHit;

  /// Hits in a row, each within [_comboGap] of the one before.
  int _combo = 0;

  @override
  void didUpdateWidget(FightCard old) {
    super.didUpdateWidget(old);
    if (widget.reps > old.reps) {
      final now = clock.now();
      final last = _lastHit;
      _combo = last != null && now.difference(last) <= _comboGap
          ? _combo + 1
          : 1;
      _lastHit = now;
      _hit.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _hit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final level = widget.level;
    final look = WorldLook.of(level.world);
    final dealt = math.min(level.hp, widget.reps * widget.weapon.damage);
    final left = level.hp - dealt;

    return AnimatedBuilder(
      animation: _hit,
      builder: (context, _) {
        final t = _hit.value;
        final hitting = _hit.isAnimating;
        final flash = hitting ? 1 - t : 0.0;
        final shake = hitting ? math.sin(t * math.pi * 6) * (1 - t) * 6 : 0.0;

        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [look.sky, const Color(0xFF0E0F12)],
            ),
          ),
          child: Stack(
            children: [
              // The monster's own light, behind it.
              Positioned(
                left: -40,
                top: -30,
                width: 240,
                height: 210,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        look.eye.withValues(alpha: 0.28),
                        look.eye.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 10, 14, 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox.square(
                          dimension: 124,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Transform.translate(
                                offset: Offset(shake, 0),
                                child: Golem(
                                  level: level,
                                  size: 124,
                                  hurt: dealt / level.hp,
                                  flash: flash,
                                ),
                              ),
                              // The damage, rising off the hit.
                              if (hitting)
                                Positioned(
                                  right: -10,
                                  top: 6 - t * 26,
                                  child: Opacity(
                                    opacity: (1 - t * t).clamp(0.0, 1.0),
                                    child: Text(
                                      '−${localNumber(context, widget.weapon.damage)}',
                                      style: const TextStyle(
                                        color: AppColors.gold,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        shadows: [
                                          Shadow(
                                            color: Color(0xFF000000),
                                            offset: Offset(0, 2),
                                          ),
                                          Shadow(
                                            color: Color(0xB3E0B145),
                                            blurRadius: 14,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.stageNumber(localNumber(context, level.number)),
                                  style: const TextStyle(
                                    color: Color(0xFFA39B91),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.6,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  monsterName(l, level),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                    height: 1.15,
                                  ),
                                ),
                                if (_combo >= 3) ...[
                                  const SizedBox(height: 7),
                                  Container(
                                    key: const Key('combo'),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0x2EE8846B),
                                      borderRadius: BorderRadius.circular(99),
                                      border: Border.all(
                                        color: const Color(0x80E8846B),
                                      ),
                                    ),
                                    child: Text(
                                      l.comboTag(localNumber(context, _combo)),
                                      style: const TextStyle(
                                        color: Color(0xFFE8846B),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                formatClock(context, widget.remaining.inSeconds),
                                style: TextStyle(
                                  color: widget.counting
                                      ? Colors.white
                                      : const Color(0xFFA39B91),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              _GiveUpPill(
                                label: l.giveUp,
                                onTap: widget.onStop,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: _HpBar(left: left, of: level.hp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GiveUpPill extends StatelessWidget {
  const _GiveUpPill({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: const Key('fightGiveUp'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(99),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: const Color(0x99E24B4A)),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFF08A89),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

/// What the monster has left, as a number and a bar that empties.
class _HpBar extends StatelessWidget {
  const _HpBar({required this.left, required this.of});

  final int left;
  final int of;

  @override
  Widget build(BuildContext context) {
    final share = of == 0 ? 0.0 : left / of;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              L.of(context).hpShort,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              '${localNumber(context, left)} / ${localNumber(context, of)}',
              key: const Key('fightHp'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: 12,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: Color(0x80000000)),
                FractionallySizedBox(
                  alignment: AlignmentDirectional.centerStart,
                  widthFactor: share.clamp(0.0, 1.0),
                  child: const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFE8846B), Color(0xFFFF6A3D)],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// How a fight went, worked out once from the camera's count.
class FightOutcome {
  const FightOutcome({
    required this.level,
    required this.weapon,
    required this.reps,
    required this.timeLeft,
    required this.starsBefore,
  });

  final AdventureLevel level;
  final Weapon weapon;
  final int reps;

  /// On the clock when the monster went down, or zero when it did not.
  final Duration timeLeft;

  /// The best this level had before this fight.
  final int starsBefore;

  int get dealt => math.min(level.hp, reps * weapon.damage);

  bool get won => dealt >= level.hp;

  int get stars => won ? starsFor(timeLeft, level.time) : 0;
}

/// After the fight: won or not, the stars, and the way on.
class AdventureResultView extends StatelessWidget {
  const AdventureResultView({
    super.key,
    required this.outcome,
    required this.xp,
    required this.onNext,
    required this.onAgain,
    required this.onMap,
  });

  final FightOutcome outcome;
  final XpGain? xp;

  /// Null on the last level, or when the fight was lost.
  final VoidCallback? onNext;
  final VoidCallback onAgain;
  final VoidCallback onMap;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;
    final level = outcome.level;
    final won = outcome.won;
    final stars = outcome.stars;
    final next = level.isLast ? null : AdventureLevel.of(level.number + 1);

    // What would have earned one more star: seconds that had to be left.
    String? hint;
    if (won && stars < 3) {
      final need = leftFor(stars + 1, level.time).inSeconds;
      hint = stars == 1
          ? l.secondStarHint(localNumber(context, need))
          : l.thirdStarHint(localNumber(context, need));
    } else if (!won) {
      hint = l.fightLostHint;
    }

    Widget tile(String value, String label, {Key? key}) => Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border, width: 0.5),
        ),
        child: Column(
          children: [
            Text(
              value,
              key: key,
              style: TextStyle(
                color: colors.text,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            Text(label, style: TextStyle(color: colors.muted, fontSize: 13)),
          ],
        ),
      ),
    );

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Column(
                key: const Key('adventureResult'),
                children: [
                  Text(
                    l.adventureLevelIn(
                      localNumber(context, level.number),
                      worldName(l, level.world),
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: won ? AppColors.gold : colors.muted,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ShrinkText(
                    won ? l.levelCleared : l.outOfTime,
                    maxLines: 1,
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 46,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _StarRow(stars: stars, size: 52),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 190,
                    child: Center(
                      child: won
                          ? FallenGolem(level: level, size: 180)
                          : Golem(
                              level: level,
                              size: 180,
                              hurt: outcome.dealt / level.hp,
                            ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      tile(
                        localNumber(context, outcome.reps),
                        l.statPushUps,
                        key: const Key('adventureReps'),
                      ),
                      const SizedBox(width: 10),
                      won
                          ? tile(
                              formatClock(context, outcome.timeLeft.inSeconds),
                              l.statTimeLeft,
                            )
                          : tile(
                              localNumber(context, level.hp - outcome.dealt),
                              l.statHpLeft,
                            ),
                      const SizedBox(width: 10),
                      tile(
                        '+${localNumber(context, xp?.total ?? outcome.reps)}',
                        l.statXp,
                      ),
                    ],
                  ),
                  if (hint != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      hint,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: colors.muted,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ],
                  if (won && next != null) ...[
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colors.border, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          Golem(level: next, size: 44),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.nextKicker,
                                  style: TextStyle(
                                    color: colors.muted,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Text(
                                  l.nextLevelLine(
                                    localNumber(context, next.number),
                                    localNumber(context, next.hp),
                                  ),
                                  style: TextStyle(
                                    color: colors.text,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: Key(won && onNext != null ? 'adventureNext' : 'adventureAgain'),
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.rival,
                      foregroundColor: colors.background,
                    ),
                    onPressed: won && onNext != null ? onNext : onAgain,
                    child: Text(won && onNext != null ? l.nextLevel : l.tryAgain),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (won && onNext != null) ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onAgain,
                          child: Text(l.tryAgain),
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                    Expanded(
                      child: OutlinedButton(
                        key: const Key('adventureMap'),
                        onPressed: onMap,
                        child: Text(l.adventureMap),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.stars, required this.size});

  final int stars;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 3; i++)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size * 0.12),
            child: Icon(
              Icons.star_rounded,
              size: size,
              color: i < stars ? AppColors.gold : context.colors.surfaceRaised,
              shadows: i < stars
                  ? const [Shadow(color: Color(0x99E0B145), blurRadius: 24)]
                  : null,
            ),
          ),
      ],
    );
  }
}

/// A weapon just unlocked: once, after the fight that earned the stars.
class WeaponUnlockedView extends StatelessWidget {
  const WeaponUnlockedView({
    super.key,
    required this.weapon,
    required this.previous,
    required this.onContinue,
  });

  final Weapon weapon;
  final Weapon previous;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final colors = context.colors;

    return SafeArea(
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.2),
                  radius: 0.8,
                  colors: [
                    AppColors.gold.withValues(alpha: 0.22),
                    AppColors.gold.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          Column(
            key: const Key('weaponUnlocked'),
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 48, 24, 8),
                  child: Column(
                    children: [
                      Text(
                        l.starsKicker(localNumber(context, weapon.stars)),
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ShrinkText(
                        l.newWeapon,
                        maxLines: 1,
                        style: TextStyle(
                          color: colors.text,
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 36),
                      WeaponArt(weapon: weapon, size: 190),
                      const SizedBox(height: 30),
                      Text(
                        weaponName(l, weapon),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colors.text,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l.damagePerPushUp(localNumber(context, weapon.damage)),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.gold,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l.wasWith(
                          localNumber(context, previous.damage),
                          weaponName(l, previous),
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.muted, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: const Key('weaponContinue'),
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.rival,
                      foregroundColor: colors.background,
                    ),
                    onPressed: onContinue,
                    child: Text(l.continueAction),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
