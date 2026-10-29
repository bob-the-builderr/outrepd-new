/// The adventure's fight: the card over the camera while it runs, and the two
/// screens after it — the new weapon, when there is one, and the result.
library;

import 'dart:math' as math;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

import '../ads.dart';
import '../adventure/adventure.dart';
import '../adventure/golem.dart';
import '../adventure/names.dart';
import '../adventure/weapon_art.dart';
import '../l10n/app_localizations.dart';
import '../reps/pushup_counter.dart';
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
  bool wonAt(int reps) => reps * level.damageFrom(weapon) >= level.hp;

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

  @override
  Widget track(
    BuildContext context, {
    required double progress,
    required bool pastBottom,
  }) => WeaponTrack(
    key: const Key('weaponTrack'),
    weapon: weapon,
    progress: progress,
    pastBottom: pastBottom,
  );

  @override
  Widget countdown(BuildContext context, int seconds) =>
      FightCountdown(key: const Key('fightIntro'), seconds: seconds);
}

/// Push-ups closer together than this keep a combo going.
const _comboGap = Duration(milliseconds: 2200);

/// Where in a hit the weapon lands: before it, the weapon is flying from the
/// track at the monster; after it, the blow — the flash, the rings, the
/// damage rising.
const _impact = 0.4;

/// The fight, over the camera (the user's pick, 2026-10-28, from the video
/// the adventure came from): the monster's name, the clock and the way out
/// on a line, and the monster in its world under them, its HP along the
/// bottom. Every rep, the weapon flies up off the track beside the camera
/// and strikes; at 0 HP the monster goes down.
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
    duration: const Duration(milliseconds: 700),
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
    final damage = level.damageFrom(widget.weapon);
    final dealt = math.min(level.hp, widget.reps * damage);
    final left = level.hp - dealt;

    return AnimatedBuilder(
      animation: _hit,
      builder: (context, _) {
        final t = _hit.value;
        final hitting = _hit.isAnimating;
        final flying = hitting && t < _impact;
        final landed = hitting && !flying;
        // 0 to 1 over the blow, after the weapon arrives.
        final after = landed ? (t - _impact) / (1 - _impact) : 1.0;
        final flash = landed ? 1 - after : 0.0;
        final shake = landed ? math.sin(after * math.pi * 6) * (1 - after) * 6 : 0.0;
        // Down only once the last blow has landed.
        final down = left == 0 && !flying;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    monsterName(l, level),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Text(
                  formatClock(context, widget.remaining.inSeconds),
                  style: TextStyle(
                    color: widget.counting
                        ? Colors.white
                        : const Color(0xFFA39B91),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(width: 12),
                _GiveUpPill(label: l.giveUp, onTap: widget.onStop),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: SizedBox(
                height: 190,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(painter: _LandscapePainter(look)),
                    ),
                    if (landed)
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _RingsPainter(after, look.eye),
                        ),
                      ),
                    Align(
                      alignment: const Alignment(0, -0.15),
                      child: Transform.translate(
                        offset: Offset(shake, 0),
                        child: down
                            ? FallenGolem(level: level, size: 120)
                            : Golem(
                                level: level,
                                size: 120,
                                hurt: dealt / level.hp,
                                flash: flash,
                              ),
                      ),
                    ),
                    Positioned(
                      left: 14,
                      top: 10,
                      child: Text(
                        l.adventureLevelIn(
                          localNumber(context, level.number),
                          worldName(l, level.world),
                        ),
                        style: const TextStyle(
                          color: Color(0xD9FFFFFF),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (_combo >= 3)
                      Positioned(
                        left: 14,
                        top: 32,
                        child: Container(
                          key: const Key('combo'),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x2EE8846B),
                            borderRadius: BorderRadius.circular(99),
                            border: Border.all(color: const Color(0x80E8846B)),
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
                      ),
                    // The weapon, up off the track below the card's right
                    // corner and in at the monster.
                    if (flying)
                      Align(
                        alignment: Alignment.lerp(
                          const Alignment(1.2, 1.3),
                          const Alignment(0.12, -0.2),
                          Curves.easeIn.transform(t / _impact),
                        )!,
                        child: Transform.rotate(
                          angle: -0.5 - t / _impact * 0.9,
                          child: WeaponArt(weapon: widget.weapon, size: 46),
                        ),
                      ),
                    // The damage, rising off the blow.
                    if (landed)
                      Align(
                        alignment: Alignment(0.45, -0.55 - after * 0.3),
                        child: Opacity(
                          opacity: (1 - after * after).clamp(0.0, 1.0),
                          child: Text(
                            '−${localNumber(context, damage)}',
                            style: const TextStyle(
                              color: AppColors.gold,
                              fontSize: 30,
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
                    if (down)
                      Align(
                        alignment: const Alignment(0, -0.62),
                        child: Text(
                          l.fightDefeated,
                          key: const Key('fightDefeated'),
                          style: const TextStyle(
                            color: AppColors.gold,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            shadows: [
                              Shadow(
                                color: Color(0xFF000000),
                                offset: Offset(0, 2),
                              ),
                              Shadow(color: Color(0x99E0B145), blurRadius: 18),
                            ],
                          ),
                        ),
                      ),
                    Positioned(
                      left: 14,
                      right: 14,
                      bottom: 12,
                      child: _HpBar(left: left, of: level.hp),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// The monster's world behind it: the sky in its light, a pale sun, two
/// hills and a few trees.
class _LandscapePainter extends CustomPainter {
  _LandscapePainter(this.look);

  final WorldLook look;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color.lerp(look.sky, const Color(0xFF8A96A6), 0.45)!, look.sky],
        ).createShader(rect),
    );
    canvas.drawCircle(
      Offset(w * 0.82, h * 0.2),
      h * 0.09,
      Paint()..color = const Color(0x59FFFFFF),
    );
    final far = Path()
      ..moveTo(0, h * 0.72)
      ..quadraticBezierTo(w * 0.25, h * 0.6, w * 0.5, h * 0.7)
      ..quadraticBezierTo(w * 0.75, h * 0.8, w, h * 0.66)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      far,
      Paint()..color = Color.lerp(look.sky, const Color(0xFF000000), 0.2)!,
    );
    final near = Path()
      ..moveTo(0, h * 0.84)
      ..quadraticBezierTo(w * 0.3, h * 0.74, w * 0.62, h * 0.82)
      ..quadraticBezierTo(w * 0.85, h * 0.88, w, h * 0.8)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      near,
      Paint()..color = Color.lerp(look.sky, const Color(0xFF000000), 0.5)!,
    );
    final tree = Paint()..color = Color.lerp(look.sky, const Color(0xFF000000), 0.6)!;
    for (final (x, y, s) in [(0.14, 0.74, 16.0), (0.86, 0.7, 13.0)]) {
      canvas.drawPath(
        Path()
          ..moveTo(w * x - s * 0.4, h * y)
          ..lineTo(w * x, h * y - s)
          ..lineTo(w * x + s * 0.4, h * y)
          ..close(),
        tree,
      );
    }
  }

  @override
  bool shouldRepaint(_LandscapePainter old) => old.look != look;
}

/// The blow landing: three rings opening out from the monster, fading.
class _RingsPainter extends CustomPainter {
  _RingsPainter(this.progress, this.colour);

  /// 0 as the weapon lands, 1 when the rings are gone.
  final double progress;
  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    final centre = Offset(size.width / 2, size.height * 0.42);
    for (var i = 0; i < 3; i++) {
      final alpha = ((0.7 - i * 0.2) * (1 - progress)).clamp(0.0, 1.0);
      canvas.drawCircle(
        centre,
        36 + i * 18 + progress * 40,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = colour.withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(_RingsPainter old) => old.progress != progress;
}

/// Beside the camera, in place of the depth bar: a line of ticks, the two
/// lines a rep has to cross as longer ticks — the next one lit — and the
/// weapon riding it with the lifter, down with them and back up. The
/// counter's own lines, where the depth bar has them ([barFill]), so the
/// weapon never promises a rep the counter will not give.
class WeaponTrack extends StatelessWidget {
  const WeaponTrack({
    super.key,
    required this.weapon,
    required this.progress,
    required this.pastBottom,
  });

  final Weapon weapon;
  final double progress;
  final bool pastBottom;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        const room = 24.0;
        final w = box.maxWidth;
        final rail = math.max(0.0, box.maxHeight - room * 2);
        // From the top of the box, where a reading of [share] sits.
        double at(double share) => room + rail * (1 - barFill(share));
        final ticks = math.max(2, rail ~/ 24);

        Widget line(String key, double share, Color colour) => Positioned(
          key: Key(key),
          left: (w - 30) / 2,
          width: 30,
          top: at(share) - 2,
          height: 4,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colour,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );

        return Stack(
          clipBehavior: Clip.none,
          children: [
            for (var i = 0; i <= ticks; i++)
              Positioned(
                left: (w - 14) / 2,
                width: 14,
                top: room + rail * i / ticks - 1.5,
                height: 3,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFF3A3531),
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
              ),
            line(
              'trackLineBottom',
              kBottomShare,
              pastBottom ? AppColors.win : AppColors.gold,
            ),
            line(
              'trackLineTop',
              kTopShare,
              pastBottom ? AppColors.gold : const Color(0xB38F8880),
            ),
            Positioned(
              left: (w - 40) / 2,
              top: at(progress) - 20,
              child: WeaponArt(weapon: weapon, size: 40),
            ),
          ],
        );
      },
    );
  }
}

/// The count down before a fight, over the camera: the fight's own card is
/// already up above it, the monster at full HP, and the lifter can still see
/// themselves getting into place through the dimmed picture. When it ends the
/// number goes and nothing else on the screen moves.
class FightCountdown extends StatelessWidget {
  const FightCountdown({super.key, required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0x8C121110),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                L.of(context).getReady,
                style: const TextStyle(
                  color: Color(0xD9E8DCC8),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                ),
              ),
              Text(
                localNumber(context, seconds),
                key: const Key('fightCountdown'),
                style: const TextStyle(
                  color: AppColors.gold,
                  fontSize: 160,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(color: Color(0xFF121110), offset: Offset(0, 5)),
                    Shadow(color: Color(0x80D9A94A), blurRadius: 40),
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
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      // Red while it is mostly there, amber past half,
                      // green near the end — as the video's bar does.
                      gradient: LinearGradient(
                        colors: share > 0.6
                            ? const [Color(0xFFE8846B), Color(0xFFFF6A3D)]
                            : share > 0.3
                            ? const [Color(0xFFE0A33A), Color(0xFFF2C14E)]
                            : const [Color(0xFF2FB56A), Color(0xFF5BD98A)],
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

  int get dealt => math.min(level.hp, reps * level.damageFrom(weapon));

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
    final adventure = Adventure.instance;

    // Won, but the next world's monsters do not feel the weapon in hand:
    // the way on is more stars, not the next fight.
    final nextShut =
        won && next != null && !next.canBeHurtBy(adventure.weapon);
    final canNext = won && onNext != null && !nextShut;

    // What would have earned one more star: seconds that had to be left.
    String? hint;
    if (nextShut) {
      final shut = next;
      hint = l.worldNeedsWeapon(
        worldName(l, shut.world),
        weaponName(l, shut.weaponNeeded),
        localNumber(context, shut.weaponNeeded.stars - adventure.totalStars),
      );
    } else if (won && stars < 3) {
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
                  if (canNext && next != null) ...[
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
                    key: Key(canNext ? 'adventureNext' : 'adventureAgain'),
                    style: FilledButton.styleFrom(
                      backgroundColor: colors.rival,
                      foregroundColor: colors.background,
                    ),
                    onPressed: canNext ? onNext : onAgain,
                    child: Text(canNext ? l.nextLevel : l.tryAgain),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    if (canNext) ...[
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
                const AdNotice(),
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
    // The weapon's own metal, the colour of the world it belongs to.
    final metal = WorldLook.of(weapon.index).light;
    final next = weapon.index + 1 < kWeapons.length
        ? kWeapons[weapon.index + 1]
        : null;
    final what = [
      // The last weapon opens nothing: it is past Master.
      if (weapon.index < kWorlds) l.opensWorld(worldName(l, weapon.index)),
      l.wasWith(
        localNumber(context, previous.damage),
        weaponName(l, previous),
      ),
    ].join(' · ');

    return SafeArea(
      child: Column(
        key: const Key('weaponUnlocked'),
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 40, 22, 8),
              child: Column(
                children: [
                  ShrinkText(
                    l.newWeapon,
                    maxLines: 1,
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 220,
                    height: 220,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.surfaceRaised,
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: metal.withValues(alpha: 0.25),
                          blurRadius: 60,
                        ),
                      ],
                    ),
                    child: WeaponArt(weapon: weapon, size: 160),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    weaponName(l, weapon),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: metal,
                      fontSize: 34,
                      height: 1.15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l.damagePerPushUp(localNumber(context, weapon.damage)),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.gold,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    what,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colors.muted, fontSize: 14.5),
                  ),
                  if (next != null) ...[
                    const SizedBox(height: 30),
                    Container(
                      key: const Key('nextWeapon'),
                      padding: const EdgeInsets.fromLTRB(16, 14, 18, 14),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: colors.border, width: 0.5),
                      ),
                      child: Row(
                        children: [
                          Opacity(
                            opacity: 0.7,
                            child: WeaponArt(
                              weapon: next,
                              size: 56,
                              locked: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l.nextWeapon,
                                  style: TextStyle(
                                    color: colors.muted,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  weaponName(l, next),
                                  style: TextStyle(
                                    color: colors.text,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${l.perPushUp(localNumber(context, next.damage))} · '
                                  '${l.weaponAtStars(localNumber(context, next.stars))}',
                                  style: TextStyle(
                                    color: colors.muted,
                                    fontSize: 14,
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
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: const Key('weaponContinue'),
                style: FilledButton.styleFrom(
                  backgroundColor: colors.brand,
                  foregroundColor: colors.background,
                ),
                onPressed: onContinue,
                child: Text(l.continueAction),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
