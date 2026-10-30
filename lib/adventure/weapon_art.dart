/// The eight weapons, drawn the way the crests are: flat planes of metal, a
/// lit facet and a dark one, a leather grip.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'adventure.dart';

/// The metal of each weapon, lit and in shadow, in [kWeapons] order.
const _metal = <(Color, Color)>[
  (Color(0xFFB9BEC6), Color(0xFF4A4E55)), // Iron Gauntlets
  (Color(0xFFE7AE84), Color(0xFF7A4527)), // Bronze Knuckles
  (Color(0xFFEEF2F7), Color(0xFF7D8794)), // Silver Fang
  (Color(0xFFF6D98A), Color(0xFF8A6618)), // Gold Hammer
  (Color(0xFFE4ECF3), Color(0xFF6E7C8A)), // Platinum Axe
  (Color(0xFF8FF0E4), Color(0xFF1F6E68)), // Diamond Spear
  (Color(0xFFFFF6E6), Color(0xFF9C8E78)), // Master Sword
  (Color(0xFFFFE08A), Color(0xFFB3462F)), // Crownbreaker
];

class WeaponArt extends StatelessWidget {
  const WeaponArt({
    super.key,
    required this.weapon,
    required this.size,
    this.locked = false,
  });

  final Weapon weapon;
  final double size;

  /// Not unlocked yet: the same shape, dark and grey.
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _WeaponPainter(index: weapon.index, locked: locked),
      ),
    );
  }
}

class _WeaponPainter extends CustomPainter {
  _WeaponPainter({required this.index, required this.locked});

  final int index;
  final bool locked;

  @override
  void paint(Canvas canvas, Size size) {
    final (lightColour, darkColour) = _metal[index.clamp(0, _metal.length - 1)];
    final light = locked ? const Color(0xFF4A4642) : lightColour;
    final dark = locked ? const Color(0xFF1E1C1A) : darkColour;
    final grip = Paint()
      ..color = locked ? const Color(0xFF2A2724) : const Color(0xFF5B3A26);
    final metal = Paint()
      ..shader = LinearGradient(
        begin: const Alignment(-1, -1),
        end: const Alignment(0.4, 1),
        colors: [light, dark],
      ).createShader(const Rect.fromLTWH(0, 0, 100, 100));
    final lit = Paint()
      ..color = Colors.white.withValues(alpha: locked ? 0.06 : 0.26);

    // Drawn on a 100 square.
    canvas.save();
    canvas.scale(size.shortestSide / 100);

    void turned(double degrees, void Function() draw) {
      canvas.save();
      canvas.translate(50, 50);
      canvas.rotate(degrees * math.pi / 180);
      canvas.translate(-50, -50);
      draw();
      canvas.restore();
    }

    Path poly(List<double> xy) {
      final path = Path()..moveTo(xy[0], xy[1]);
      for (var i = 2; i < xy.length; i += 2) {
        path.lineTo(xy[i], xy[i + 1]);
      }
      return path..close();
    }

    switch (index) {
      case 0: // Gauntlets: a fist in plate.
        for (final (left, top, right) in const [
          (38.0, 13.0, 50.0),
          (50.0, 9.0, 62.0),
          (62.0, 14.0, 73.0),
        ]) {
          canvas.drawRRect(
            RRect.fromLTRBR(left, top, right, 34, const Radius.circular(6)),
            metal,
          );
        }
        canvas.drawRRect(
          RRect.fromLTRBR(30, 28, 74, 74, const Radius.circular(12)),
          metal,
        );
        canvas.drawPath(poly([30, 38, 74, 36, 74, 46, 30, 48]), lit);
        canvas.drawRRect(
          RRect.fromLTRBR(32, 74, 72, 90, const Radius.circular(4)),
          grip,
        );
      case 1: // Knuckles: four rings on a bar.
        final ring = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..shader = metal.shader;
        for (final x in const [24.0, 40.0, 56.0, 72.0]) {
          canvas.drawCircle(Offset(x, 36), 10, ring);
        }
        canvas.drawRRect(
          RRect.fromLTRBR(16, 44, 84, 62, const Radius.circular(9)),
          metal,
        );
        canvas.drawPath(
          Path()
            ..moveTo(22, 62)
            ..quadraticBezierTo(50, 92, 78, 62)
            ..close(),
          metal,
        );
        canvas.drawRect(const Rect.fromLTRB(16, 50, 84, 53), lit);
      case 2: // Fang: a short blade.
        turned(45, () {
          canvas.drawPath(poly([50, 8, 60, 26, 58, 60, 42, 60, 40, 26]), metal);
          canvas.drawPath(poly([50, 8, 50, 60, 42, 60, 40, 26]), lit);
          canvas.drawRRect(
            RRect.fromLTRBR(32, 60, 68, 67, const Radius.circular(3)),
            metal,
          );
          canvas.drawRRect(
            RRect.fromLTRBR(45, 67, 55, 89, const Radius.circular(3)),
            grip,
          );
          canvas.drawCircle(const Offset(50, 92), 5, metal);
        });
      case 3: // Hammer.
        turned(40, () {
          canvas.drawRRect(
            RRect.fromLTRBR(46, 30, 54, 94, const Radius.circular(3)),
            grip,
          );
          canvas.drawPath(
            poly([26, 10, 74, 10, 78, 18, 78, 32, 74, 38, 26, 38, 22, 32, 22, 18]),
            metal,
          );
          canvas.drawPath(poly([26, 10, 74, 10, 78, 18, 22, 18]), lit);
        });
      case 4: // Axe: a double head on a long haft.
        turned(35, () {
          canvas.drawRRect(
            RRect.fromLTRBR(46, 12, 54, 94, const Radius.circular(3)),
            grip,
          );
          canvas.drawPath(
            Path()
              ..moveTo(54, 16)
              ..quadraticBezierTo(88, 14, 92, 44)
              ..quadraticBezierTo(78, 40, 54, 44)
              ..close(),
            metal,
          );
          canvas.drawPath(
            Path()
              ..moveTo(46, 20)
              ..quadraticBezierTo(22, 22, 18, 38)
              ..quadraticBezierTo(32, 36, 46, 38)
              ..close(),
            metal,
          );
          canvas.drawPath(
            Path()
              ..moveTo(54, 16)
              ..quadraticBezierTo(88, 14, 92, 44)
              ..lineTo(86, 42)
              ..quadraticBezierTo(80, 22, 54, 24)
              ..close(),
            lit,
          );
        });
      case 5: // Spear: a leaf of crystal on a shaft.
        turned(42, () {
          canvas.drawRRect(
            RRect.fromLTRBR(47, 30, 53, 96, const Radius.circular(3)),
            grip,
          );
          canvas.drawPath(poly([50, 2, 62, 22, 56, 36, 44, 36, 38, 22]), metal);
          canvas.drawPath(poly([50, 2, 50, 36, 44, 36, 38, 22]), lit);
          canvas.drawPath(poly([40, 38, 60, 38, 56, 44, 44, 44]), metal);
        });
      case 6: // Master Sword.
        turned(45, () {
          canvas.drawPath(poly([50, 0, 57, 10, 57, 66, 43, 66, 43, 10]), metal);
          canvas.drawPath(poly([50, 0, 50, 66, 43, 66, 43, 10]), lit);
          canvas.drawPath(poly([28, 66, 72, 66, 66, 74, 34, 74]), metal);
          canvas.drawRRect(
            RRect.fromLTRBR(46, 74, 54, 92, const Radius.circular(3)),
            grip,
          );
          canvas.drawPath(poly([50, 92, 56, 98, 50, 104, 44, 98]), metal);
        });
      default: // Crownbreaker: a greatsword with a crown for a guard.
        turned(45, () {
          canvas.drawPath(poly([50, -6, 61, 8, 61, 64, 39, 64, 39, 8]), metal);
          canvas.drawPath(poly([50, -6, 50, 64, 39, 64, 39, 8]), lit);
          if (!locked) {
            canvas.drawRect(
              const Rect.fromLTRB(44, 20, 56, 52),
              Paint()..color = const Color(0x8CB3462F),
            );
          }
          canvas.drawPath(poly([22, 64, 78, 64, 72, 74, 28, 74]), metal);
          canvas.drawPath(poly([24, 64, 30, 56, 36, 64]), metal);
          canvas.drawPath(poly([64, 64, 70, 56, 76, 64]), metal);
          canvas.drawRRect(
            RRect.fromLTRBR(45, 74, 55, 92, const Radius.circular(3)),
            grip,
          );
          canvas.drawPath(poly([42, 92, 46, 100, 50, 94, 54, 100, 58, 92]), metal);
        });
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_WeaponPainter old) =>
      old.index != index || old.locked != locked;
}
