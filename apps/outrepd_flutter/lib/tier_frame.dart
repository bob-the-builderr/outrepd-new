/// The frame around a lifter's picture: their tier, worn.
///
/// It replaced the tier badge that hung off the picture's corner. The frame
/// is drawn in the badges' own language and from their own data
/// ([crestOf]): a metal ring shaded light to dark the way the shield's facets
/// are, the badge's feathers at either side — none on Iron, one more each
/// tier up to Diamond's five — Platinum's and Diamond's gem, the laurel from
/// Diamond up, Master's crown, and a glow that follows the frame's own edges
/// and grows with the tier. So a rank reads off a picture at any size, the
/// same way it reads off a badge: you count feathers.
///
/// The box is the same for every tier, so pictures in a list line up whoever
/// they belong to. The crown and the laurel reach a little past it, into the
/// row's own padding.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'theme.dart';
import 'tier_badge.dart';

class TierFrame extends StatelessWidget {
  const TierFrame({
    super.key,
    required this.tierIdx,
    required this.size,
    required this.child,
    this.onTap,
  });

  /// The tier to draw, or null for an account still in its placements: the
  /// box is kept, so the picture lines up with framed ones, but empty.
  final int? tierIdx;

  /// The picture's diameter. The frame is drawn around it.
  final double size;

  /// The picture, centred in the frame.
  final Widget child;

  /// A tap on the frame itself rather than the picture — the way into the
  /// rank, where there is one.
  final VoidCallback? onTap;

  /// The box a framed picture of [size] takes: wide enough for Master's
  /// longest feathers, tall enough for the ring.
  static double widthFor(double size) => size * 2.02;
  static double heightFor(double size) => size * 1.25;

  @override
  Widget build(BuildContext context) {
    final tier = tierIdx;
    return SizedBox(
      width: widthFor(size),
      height: heightFor(size),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          if (tier != null)
            Positioned.fill(
              child: GestureDetector(
                onTap: onTap,
                child: CustomPaint(
                  painter: _FramePainter(
                    tierIdx: tier,
                    radius: size / 2,
                    edge: context.colors.background,
                  ),
                ),
              ),
            ),
          child,
        ],
      ),
    );
  }
}

class _FramePainter extends CustomPainter {
  _FramePainter({
    required this.tierIdx,
    required this.radius,
    required this.edge,
  });

  final int tierIdx;

  /// The picture's radius; every measure below is a share of it.
  final double radius;

  /// The page colour, for the hairline that sets a gem or the crown off the
  /// metal behind it.
  final Color edge;

  /// How strongly each tier glows, Iron to Master.
  static const _glow = [0.0, 0.22, 0.28, 0.42, 0.5, 0.6, 0.7];

  /// Master's terracotta, lighter: the tips of its feathers and its leaves,
  /// where every other tier uses the light of its own metal.
  static const _masterLight = Color(0xFFF6B49F);

  @override
  void paint(Canvas canvas, Size size) {
    final crest = crestOf(tierIdx);
    final r = radius;
    final c = size.center(Offset.zero);
    final ringR = r * 1.1;
    final ringW = math.max(3.0, r * 0.17);
    final tip = crest.crown ? _masterLight : crest.light;

    final feathers = _feathers(crest.feathers, c, r, ringR, ringW);
    final leaves = crest.laurel == null ? const <Path>[] : _leaves(c, r, ringR, ringW);
    final crown = crest.crown ? _crown(c, r, ringR, ringW) : null;

    // The glow first, from the frame's own shapes: blurred, in the tier's
    // colour, so it rises off the edges rather than sitting in a circle.
    final strength = _glow[tierIdx.clamp(0, _glow.length - 1)];
    if (strength > 0) {
      final glow = Paint()
        ..color = crest.mid.withValues(alpha: strength)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.13);
      for (final feather in feathers) {
        canvas.drawPath(feather.path, glow);
      }
      for (final leaf in leaves) {
        canvas.drawPath(leaf, glow);
      }
      if (crown != null) canvas.drawPath(crown, glow);
      canvas.drawCircle(
        c,
        ringR,
        Paint()
          ..color = crest.mid.withValues(alpha: strength)
          ..style = PaintingStyle.stroke
          ..strokeWidth = ringW
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, r * 0.13),
      );
    }

    // The feathers: dark at the root, the tier's light at the tip, with a
    // light edge along the top of each.
    final reach = r * 2.02;
    final highlight = Paint()
      ..color = tip.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.6, r * 0.02);
    for (final (:path, :side, :root, :end) in feathers) {
      final inner = c.dx + side * ringR, outer = c.dx + side * reach;
      canvas.drawPath(
        path,
        Paint()
          ..shader = LinearGradient(
            colors: side > 0 ? [crest.wing, tip] : [tip, crest.wing],
          ).createShader(
            Rect.fromLTRB(
              math.min(inner, outer),
              c.dy - r,
              math.max(inner, outer),
              c.dy + r,
            ),
          ),
      );
      canvas.drawLine(root, end, highlight);
    }

    // The laurel, from Diamond up: a stem under the ring each side, and
    // leaves along it.
    if (crest.laurel case final laurel?) {
      final stemR = ringR + ringW * 0.5 + r * 0.1;
      final stem = Paint()
        ..color = laurel
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = math.max(0.8, r * 0.03);
      for (final side in const [-1, 1]) {
        canvas.drawArc(
          Rect.fromCircle(center: c, radius: stemR),
          _rad(90 + side * 8),
          _rad(side * 58),
          false,
          stem,
        );
      }
      final leafPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [tip, laurel],
        ).createShader(
          Rect.fromLTRB(c.dx - stemR, c.dy, c.dx + stemR, c.dy + stemR + r * 0.3),
        );
      for (final leaf in leaves) {
        canvas.drawPath(leaf, leafPaint);
      }
    }

    // The ring: metal, light at the top left and dark at the bottom right,
    // with a bright outer edge and a dark inner one.
    final ringBox = Rect.fromCircle(center: c, radius: ringR + ringW / 2);
    canvas.drawCircle(
      c,
      ringR,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = ringW
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [crest.light, crest.mid, crest.base],
          stops: const [0, 0.45, 1],
        ).createShader(ringBox),
    );
    canvas.drawCircle(
      c,
      ringR + ringW / 2 - 0.4,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8
        ..color = crest.light.withValues(alpha: 0.6),
    );
    canvas.drawCircle(
      c,
      ringR - ringW / 2 + 0.4,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = Colors.black.withValues(alpha: 0.55),
    );

    // Platinum's and Diamond's gem, cut, at the top of the ring.
    if (crest.gem case final gem? when !crest.crown) {
      final g = r * 0.17;
      final mid = Offset(c.dx, c.dy - ringR);
      final top = mid.translate(0, -g * 1.15);
      final right = mid.translate(g * 0.8, 0);
      final bottom = mid.translate(0, g * 1.15);
      final left = mid.translate(-g * 0.8, 0);
      final whole = Path()..addPolygon([top, right, bottom, left], true);
      canvas.drawPath(whole, Paint()..color = crest.base);
      canvas.drawPath(
        Path()..addPolygon([top, mid, left], true),
        Paint()..color = Colors.white.withValues(alpha: 0.85),
      );
      canvas.drawPath(Path()..addPolygon([top, right, mid], true), Paint()..color = gem);
      canvas.drawPath(
        Path()..addPolygon([left, mid, bottom], true),
        Paint()..color = crest.mid,
      );
      canvas.drawPath(
        whole,
        Paint()
          ..color = edge
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
    }

    // Master's crown, sitting on the ring, with three stones.
    if (crown != null) {
      final bounds = crown.getBounds();
      canvas.drawPath(
        crown,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_masterLight, Color(0xFFC9644B)],
          ).createShader(bounds),
      );
      canvas.drawPath(
        crown,
        Paint()
          ..color = edge
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = 1.2,
      );
      for (final stone in _crownStones(c, r, ringR, ringW)) {
        canvas.drawCircle(stone, r * 0.045, Paint()..color = crest.mid);
        canvas.drawCircle(
          stone,
          r * 0.045,
          Paint()
            ..color = edge
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.8,
        );
      }
    }
  }

  static double _rad(num degrees) => degrees * math.pi / 180;

  /// The badge's feathers, from its 140×120 space to either side of the
  /// ring: root on the ring, tip outwards. Each comes back with its side and
  /// the two ends of its top edge, which catches the light.
  static List<({Path path, int side, Offset root, Offset end})> _feathers(
    List<List<double>> feathers,
    Offset c,
    double r,
    double ringR,
    double ringW,
  ) {
    final scale = r * 0.86 / 42;
    final base = ringR + ringW * 0.2;
    final out = <({Path path, int side, Offset root, Offset end})>[];
    for (final side in const [-1, 1]) {
      Offset at(double x, double y) => Offset(
        c.dx + side * (base + (x - 98) * scale),
        c.dy + (y - 53) * scale * 1.08,
      );
      for (final [x1, y1, x2, y2, x3, y3] in feathers) {
        // The badge's blade, given a root as wide as its base, so it grows
        // out of the ring rather than touching it at a point.
        final root = at(x1, y1 - 1), end = at(x2, y2);
        final inner = at(x3, y3), foot = at(98, y3 + 1);
        out.add((
          path: Path()..addPolygon([root, end, inner, foot], true),
          side: side,
          root: root,
          end: end,
        ));
      }
    }
    return out;
  }

  /// Six leaves a side along the laurel's stem, growing away from the bottom
  /// and alternating out and in.
  static List<Path> _leaves(Offset c, double r, double ringR, double ringW) {
    final stemR = ringR + ringW * 0.5 + r * 0.1;
    final leaves = <Path>[];
    for (final side in const [-1, 1]) {
      for (var k = 0; k < 6; k++) {
        final th = _rad(90 + side * (12 + k * 10));
        final at = Offset(c.dx + stemR * math.cos(th), c.dy + stemR * math.sin(th));
        final along = math.atan2(math.cos(th) * side, -math.sin(th) * side);
        final angle = along + _rad((k.isOdd ? 42 : -42) * side.toDouble());
        final length = r * (0.27 - k * 0.012), width = r * 0.1;
        final cos = math.cos(angle), sin = math.sin(angle);
        Offset p(double x, double y) =>
            Offset(at.dx + x * cos - y * sin, at.dy + x * sin + y * cos);
        final upper = p(length / 2, -width), lower = p(length / 2, width);
        final point = p(length, 0);
        leaves.add(
          Path()
            ..moveTo(at.dx, at.dy)
            ..quadraticBezierTo(upper.dx, upper.dy, point.dx, point.dy)
            ..quadraticBezierTo(lower.dx, lower.dy, at.dx, at.dy)
            ..close(),
        );
      }
    }
    return leaves;
  }

  static double _crownBase(Offset c, double ringR, double ringW) =>
      c.dy - ringR + ringW * 0.25;

  static Path _crown(Offset c, double r, double ringR, double ringW) {
    final w = r * 0.7, h = r * 0.42, base = _crownBase(c, ringR, ringW);
    final left = c.dx - w / 2, right = c.dx + w / 2;
    return Path()
      ..moveTo(left, base)
      ..lineTo(left - w * 0.04, base - h * 0.75)
      ..lineTo(c.dx - w * 0.24, base - h * 0.38)
      ..lineTo(c.dx, base - h)
      ..lineTo(c.dx + w * 0.24, base - h * 0.38)
      ..lineTo(right + w * 0.04, base - h * 0.75)
      ..lineTo(right, base)
      ..close();
  }

  static List<Offset> _crownStones(Offset c, double r, double ringR, double ringW) {
    final w = r * 0.7, h = r * 0.42, base = _crownBase(c, ringR, ringW);
    return [
      Offset(c.dx - w / 2 - w * 0.04, base - h * 0.75),
      Offset(c.dx, base - h),
      Offset(c.dx + w / 2 + w * 0.04, base - h * 0.75),
    ];
  }

  @override
  bool shouldRepaint(covariant _FramePainter old) =>
      old.tierIdx != tierIdx || old.radius != radius || old.edge != edge;
}
