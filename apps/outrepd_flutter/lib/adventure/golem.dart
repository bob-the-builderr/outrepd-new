/// The adventure's monsters: the app's crest stood up and given eyes.
///
/// One body — a shield for a chest, the crest's lit and shaded planes, its
/// feathers turned into plates for arms, the chevron glowing where a heart
/// would be — recoloured for each world and varied from level to level, so
/// a hundred and forty fights are not one picture a hundred and forty times.
/// Drawn, not bundled: it scales to any size and costs nothing to ship.
library;

import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'adventure.dart';

/// A world's metal and the light in its monsters' eyes.
class WorldLook {
  const WorldLook({
    required this.light,
    required this.dark,
    required this.edge,
    required this.eye,
    required this.sky,
  });

  /// The metal, lit and in shadow.
  final Color light;
  final Color dark;

  /// The bright rim along every plate.
  final Color edge;

  /// Eyes and the chevron on the chest.
  final Color eye;

  /// The top of the fight card's sky; it fades to near black under it.
  final Color sky;

  static const all = <WorldLook>[
    // Iron Mines: grey iron, ember eyes.
    WorldLook(
      light: Color(0xFFA7ADB6),
      dark: Color(0xFF3B3F46),
      edge: Color(0xFFC9CED6),
      eye: Color(0xFFFF7A45),
      sky: Color(0xFF2A2F38),
    ),
    // Bronze Dunes.
    WorldLook(
      light: Color(0xFFE0A27A),
      dark: Color(0xFF6A3B22),
      edge: Color(0xFFF2C3A0),
      eye: Color(0xFFFFD25E),
      sky: Color(0xFF3B2618),
    ),
    // Silver Peaks.
    WorldLook(
      light: Color(0xFFEEF2F7),
      dark: Color(0xFF6F7A86),
      edge: Color(0xFFFFFFFF),
      eye: Color(0xFF6FD0FF),
      sky: Color(0xFF283240),
    ),
    // Gold Citadel.
    WorldLook(
      light: Color(0xFFF4D27A),
      dark: Color(0xFF7A5A18),
      edge: Color(0xFFFFE8A8),
      eye: Color(0xFFFF5A5A),
      sky: Color(0xFF3A2E12),
    ),
    // Platinum Glacier.
    WorldLook(
      light: Color(0xFFE4ECF3),
      dark: Color(0xFF5F6E7C),
      edge: Color(0xFFF5FAFF),
      eye: Color(0xFFB78CFF),
      sky: Color(0xFF26303C),
    ),
    // Diamond Caverns.
    WorldLook(
      light: Color(0xFF8FF0E4),
      dark: Color(0xFF1F6E68),
      edge: Color(0xFFC8FFF6),
      eye: Color(0xFFFF6FB1),
      sky: Color(0xFF123332),
    ),
    // Master's Throne: ivory and red.
    WorldLook(
      light: Color(0xFFFFF6E6),
      dark: Color(0xFF9C8E78),
      edge: Color(0xFFFFFFFF),
      eye: Color(0xFFFF3B3B),
      sky: Color(0xFF3A1A18),
    ),
  ];

  static WorldLook of(int world) => all[world.clamp(0, all.length - 1)];
}

/// One monster, at [size] square.
class Golem extends StatelessWidget {
  const Golem({
    super.key,
    required this.level,
    required this.size,
    this.hurt = 0,
    this.flash = 0,
  });

  final AdventureLevel level;
  final double size;

  /// 0 untouched to 1 beaten: cracks open across the plates as it drops.
  final double hurt;

  /// 0 to 1: the white of a hit landing, fading over a few frames.
  final double flash;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: GolemPainter(level: level, hurt: hurt, flash: flash),
      ),
    );
  }
}

class GolemPainter extends CustomPainter {
  GolemPainter({required this.level, this.hurt = 0, this.flash = 0});

  final AdventureLevel level;
  final double hurt;
  final double flash;

  @override
  void paint(Canvas canvas, Size size) {
    final look = WorldLook.of(level.world);
    final kind = level.kind;
    // Drawn on a 200 square; bosses stand a little taller in it.
    final scale = size.shortestSide / 200;
    canvas.save();
    canvas.scale(scale);
    if (kind == FightKind.boss) {
      canvas.translate(100, 200);
      canvas.scale(1.06);
      canvas.translate(-100, -200);
    }

    final metal = Paint()
      ..shader = LinearGradient(
        begin: const Alignment(-0.6, -1),
        end: const Alignment(0.4, 1),
        colors: [look.light, look.dark],
      ).createShader(const Rect.fromLTWH(0, 0, 200, 200));
    final edge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round
      ..color = look.edge;
    final softEdge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeJoin = StrokeJoin.round
      ..color = look.edge.withValues(alpha: 0.6);
    final lit = Paint()..color = const Color(0x38FFFFFF);
    final shade = Paint()..color = const Color(0x29000000);

    // The shadow first, outside the layer the hit flash whitens.
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(100, 188), width: 128, height: 16),
      Paint()..color = const Color(0x80000000),
    );

    canvas.saveLayer(const Rect.fromLTWH(-20, -20, 240, 240), Paint());

    // Variety within a world, fixed per level so a level always looks the
    // same: two or three plates to an arm, a flat or a peaked head, two eyes
    // or one.
    final n = level.inWorld;
    final threePlates = n.isOdd;
    final peaked = (n ~/ 2).isOdd;
    final oneEye = n % 3 == 0 && kind == FightKind.regular;

    // Legs.
    for (final mirror in [false, true]) {
      canvas.drawPath(
        _mirror(
          Path()
            ..moveTo(74, 148)
            ..lineTo(66, 184)
            ..lineTo(90, 184)
            ..lineTo(92, 152)
            ..close(),
          mirror,
        ),
        metal,
      );
    }

    // Arms: the crest's feathers as plates.
    for (final mirror in [false, true]) {
      final arm = threePlates
          ? (Path()
              ..moveTo(56, 80)
              ..lineTo(16, 90)
              ..lineTo(30, 100)
              ..lineTo(10, 112)
              ..lineTo(28, 118)
              ..lineTo(14, 132)
              ..lineTo(50, 128)
              ..close())
          : (Path()
              ..moveTo(56, 80)
              ..lineTo(18, 94)
              ..lineTo(32, 106)
              ..lineTo(14, 124)
              ..lineTo(50, 126)
              ..close());
      final path = _mirror(arm, mirror);
      canvas.drawPath(path, metal);
      canvas.drawPath(path, softEdge);
    }

    // Elites and bosses wear spikes on the shoulders.
    if (kind != FightKind.regular) {
      for (final mirror in [false, true]) {
        final spike = _mirror(
          Path()
            ..moveTo(54, 74)
            ..lineTo(36, 54)
            ..lineTo(64, 70)
            ..close(),
          mirror,
        );
        canvas.drawPath(spike, metal);
        canvas.drawPath(spike, softEdge);
      }
    }

    // The chest: the crest's shield.
    final chest = Path()
      ..moveTo(100, 58)
      ..lineTo(148, 72)
      ..lineTo(148, 118)
      ..quadraticBezierTo(148, 150, 100, 170)
      ..quadraticBezierTo(52, 150, 52, 118)
      ..lineTo(52, 72)
      ..close();
    canvas.drawPath(chest, metal);
    canvas.drawPath(
      Path()
        ..moveTo(100, 58)
        ..lineTo(148, 72)
        ..lineTo(100, 86)
        ..lineTo(52, 72)
        ..close(),
      lit,
    );
    canvas.drawPath(
      Path()
        ..moveTo(100, 86)
        ..lineTo(148, 72)
        ..lineTo(148, 118)
        ..quadraticBezierTo(148, 150, 100, 170)
        ..close(),
      shade,
    );
    canvas.drawPath(chest, edge);

    // The chevron, glowing.
    canvas.drawCircle(
      const Offset(100, 132),
      24,
      Paint()
        ..shader = RadialGradient(
          colors: [look.eye.withValues(alpha: 0.55), look.eye.withValues(alpha: 0)],
        ).createShader(Rect.fromCircle(center: const Offset(100, 132), radius: 24)),
    );
    canvas.drawPath(
      Path()
        ..moveTo(82, 132)
        ..lineTo(100, 118)
        ..lineTo(118, 132)
        ..lineTo(118, 142)
        ..lineTo(100, 128)
        ..lineTo(82, 142)
        ..close(),
      Paint()..color = look.eye,
    );

    // Cracks open as the HP drops.
    final crack = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = const Color(0xFF0B0A09);
    if (hurt > 0.3) {
      canvas.drawPath(
        Path()
          ..moveTo(88, 90)
          ..lineTo(96, 102)
          ..lineTo(90, 112)
          ..lineTo(98, 124),
        crack,
      );
    }
    if (hurt > 0.6) {
      canvas.drawPath(
        Path()
          ..moveTo(128, 84)
          ..lineTo(118, 96)
          ..lineTo(126, 106),
        crack,
      );
      canvas.drawPath(
        Path()
          ..moveTo(62, 106)
          ..lineTo(72, 116)
          ..lineTo(66, 130),
        crack,
      );
    }
    if (hurt > 0.85) {
      canvas.drawPath(
        Path()
          ..moveTo(110, 148)
          ..lineTo(104, 156)
          ..lineTo(110, 162),
        crack,
      );
    }

    // Horns for a boss.
    if (kind == FightKind.boss) {
      for (final mirror in [false, true]) {
        final horn = _mirror(
          Path()
            ..moveTo(80, 30)
            ..lineTo(60, 0)
            ..lineTo(88, 24)
            ..close(),
          mirror,
        );
        canvas.drawPath(horn, metal);
        canvas.drawPath(horn, softEdge);
      }
    }

    // The head.
    final head = Path()..moveTo(100, peaked ? 8 : 18);
    head
      ..lineTo(126, 27)
      ..lineTo(126, 48)
      ..quadraticBezierTo(126, 60, 100, 66)
      ..quadraticBezierTo(74, 60, 74, 48)
      ..lineTo(74, 27)
      ..close();
    canvas.drawPath(head, metal);
    canvas.drawPath(
      Path()
        ..moveTo(100, peaked ? 8 : 18)
        ..lineTo(126, 27)
        ..lineTo(100, 35)
        ..lineTo(74, 27)
        ..close(),
      lit,
    );
    canvas.drawPath(head, edge);

    // A crown on Master's last boss.
    if (kind == FightKind.boss && level.world == kWorlds - 1) {
      final crown = Path()
        ..moveTo(78, 22)
        ..lineTo(82, 4)
        ..lineTo(92, 14)
        ..lineTo(100, -2)
        ..lineTo(108, 14)
        ..lineTo(118, 4)
        ..lineTo(122, 22)
        ..close();
      canvas.drawPath(crown, Paint()..color = const Color(0xFFE0B145));
      canvas.drawPath(
        crown,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = const Color(0xFFFFE8A8),
      );
    }

    // Eyes: a glow and a slit of light in each.
    final eyes = oneEye ? const [Offset(100, 44)] : const [Offset(89, 44), Offset(111, 44)];
    for (final eye in eyes) {
      final r = oneEye ? 14.0 : 11.0;
      canvas.drawCircle(
        eye,
        r,
        Paint()
          ..shader = RadialGradient(
            colors: [
              const Color(0xFFFFF6E0),
              look.eye,
              look.eye.withValues(alpha: 0),
            ],
            stops: const [0, 0.35, 1],
          ).createShader(Rect.fromCircle(center: eye, radius: r)),
      );
    }
    final slit = Paint()..color = const Color(0xFFFFF6E0);
    if (oneEye) {
      canvas.drawPath(
        Path()
          ..moveTo(92, 44)
          ..lineTo(100, 41)
          ..lineTo(108, 44)
          ..lineTo(100, 47)
          ..close(),
        slit,
      );
    } else {
      canvas.drawPath(
        Path()
          ..moveTo(82, 42)
          ..lineTo(96, 44)
          ..lineTo(82, 47)
          ..close(),
        slit,
      );
      canvas.drawPath(
        Path()
          ..moveTo(118, 42)
          ..lineTo(104, 44)
          ..lineTo(118, 47)
          ..close(),
        slit,
      );
    }

    // A hit: everything drawn above goes briefly white.
    if (flash > 0) {
      canvas.drawColor(
        Colors.white.withValues(alpha: (flash * 0.75).clamp(0.0, 1.0)),
        BlendMode.srcATop,
      );
    }
    canvas.restore();
    canvas.restore();
  }

  /// Left-right across the middle of the 200 square, as a column-major
  /// matrix: x becomes 200 − x.
  static final _flip = Float64List.fromList([
    -1, 0, 0, 0, //
    0, 1, 0, 0, //
    0, 0, 1, 0, //
    200, 0, 0, 1, //
  ]);

  static Path _mirror(Path path, bool mirror) =>
      mirror ? path.transform(_flip) : path;

  @override
  bool shouldRepaint(GolemPainter old) =>
      old.level.number != level.number ||
      old.hurt != hurt ||
      old.flash != flash;
}

/// A monster that has gone down: grey, tipped over.
class FallenGolem extends StatelessWidget {
  const FallenGolem({super.key, required this.level, required this.size});

  final AdventureLevel level;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.6,
      child: ColorFiltered(
        colorFilter: const ColorFilter.matrix([
          0.33, 0.33, 0.33, 0, 0, //
          0.33, 0.33, 0.33, 0, 0, //
          0.33, 0.33, 0.33, 0, 0, //
          0, 0, 0, 1, 0, //
        ]),
        child: Transform.rotate(
          angle: -14 * math.pi / 180,
          child: Golem(level: level, size: size, hurt: 1),
        ),
      ),
    );
  }
}
