/// A rank card wearing its tier (the user's pick A, 2026-11-03), on the
/// Match tab and the profile: edged in the tier's metal, with the badge's own
/// feathers growing out of its sides, and more of it each tier up — none on
/// Iron, a feather more each tier to Diamond's five, a bright line inside
/// the edge from Silver, Platinum's and Diamond's gem at the top, the laurel
/// from Diamond hanging under it, Master's crown — and a glow off the whole
/// silhouette that grows with the tier and, from Gold up, breathes slowly.
///
/// Drawn from the badge's data ([crestOf]), as the frame round a picture is
/// (lib/tier_frame.dart), so a card can never wear a feather its tier has
/// not earned.
///
/// The box is the same for every tier: the card sits inside it, [sideRoom]
/// in from either side for the wings, with room above for the gem or crown
/// and below for the laurel, so the screen does not move when the tier does.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'motion.dart';
import 'theme.dart';
import 'tier_badge.dart';

class TierCardFrame extends StatefulWidget {
  const TierCardFrame({
    super.key,
    required this.tierIdx,
    required this.child,
    this.radius = 18,
    this.fill = true,
  });

  final int tierIdx;

  /// The card's contents, laid out inside the frame's edge.
  final Widget child;

  final double radius;

  /// Whether the frame paints the card's surface. Off where the child paints
  /// its own (the profile's lit card).
  final bool fill;

  /// Room either side of the card for the wings. Master's longest feathers
  /// reach a little past it, into the page's own margin.
  static const sideRoom = 30.0;

  /// Room above the card for the gem or the crown.
  static const topRoom = 14.0;

  /// Room below the card for the laurel.
  static const bottomRoom = 20.0;

  @override
  State<TierCardFrame> createState() => _TierCardFrameState();
}

class _TierCardFrameState extends State<TierCardFrame>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
    value: 0.5,
  );

  /// The glow breathes from Gold up; below that it is too faint to.
  bool get _breathes => widget.tierIdx >= 3;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _run();
  }

  @override
  void didUpdateWidget(TierCardFrame old) {
    super.didUpdateWidget(old);
    if (old.tierIdx != widget.tierIdx) _run();
  }

  void _run() {
    if (_breathes && loopsAllowed(context)) {
      if (!_controller.isAnimating) _controller.repeat(reverse: true);
    } else {
      _controller
        ..stop()
        ..value = 0.5;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnimatedBuilder(
      animation: _controller,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          TierCardFrame.sideRoom,
          TierCardFrame.topRoom,
          TierCardFrame.sideRoom,
          TierCardFrame.bottomRoom,
        ),
        child: widget.child,
      ),
      builder: (context, child) => CustomPaint(
        painter: _BackPainter(
          tierIdx: widget.tierIdx,
          radius: widget.radius,
          surface: widget.fill ? colors.surface : null,
          breath: Curves.easeInOut.transform(_controller.value),
        ),
        foregroundPainter: _FrontPainter(
          tierIdx: widget.tierIdx,
          radius: widget.radius,
          edge: colors.background,
        ),
        child: child,
      ),
    );
  }
}

/// How strongly each tier glows, Iron to Master: the picture frame's own.
const _glow = [0.0, 0.22, 0.28, 0.42, 0.5, 0.6, 0.7];

/// The edge's width, Iron to Master.
const _edgeWidth = [1.0, 1.2, 1.4, 1.7, 1.9, 2.1, 2.4];

/// Master's terracotta, lighter: the tips of its feathers and its leaves,
/// where every other tier uses the light of its own metal.
const _masterLight = Color(0xFFF6B49F);

/// The badge's feathers are drawn this much smaller beside a card.
const _featherScale = 0.8;

/// The laurel, from the badge's space: this much larger, and hung this far
/// under the card's bottom edge.
const _laurelScale = 1.2;
const _laurelDrop = 14.0;

Rect _cardOf(Size size) => Rect.fromLTRB(
  TierCardFrame.sideRoom,
  TierCardFrame.topRoom,
  size.width - TierCardFrame.sideRoom,
  size.height - TierCardFrame.bottomRoom,
);

/// The badge's wing, from its 140×120 space to either side of the card: the
/// same feathers the tier's badge wears, tips outwards, the roots — the
/// points the badge puts on its shield — on the card's straight side, just
/// inside it so the card covers them. Each comes back with its side and the
/// two ends of its top edge, which catches the light.
List<({Path path, int side, Offset root, Offset end})> _feathers(
  List<List<Offset>> shapes,
  Rect card,
) {
  final out = <({Path path, int side, Offset root, Offset end})>[];
  for (final side in const [-1, 1]) {
    final edge = side > 0 ? card.right - 1 : card.left + 1;
    Offset at(Offset p) => Offset(
      edge + side * (p.dx - 98) * _featherScale,
      card.center.dy + (p.dy - 53) * _featherScale,
    );
    for (final shape in shapes) {
      final points = [for (final p in shape) at(p)];
      out.add((
        path: Path()..addPolygon(points, true),
        side: side,
        root: points[0],
        end: points[1],
      ));
    }
  }
  return out;
}

/// From the badge's space to under the middle of the card's bottom edge.
Offset _laurelAt(Rect card, double x, double y) => Offset(
  card.center.dx + (x - 70) * _laurelScale,
  card.bottom + _laurelDrop + (y - 101) * _laurelScale,
);

/// The badge's laurel stem (lib/tier_badge.dart), moved under the card.
Path _stem(Rect card) {
  final from = _laurelAt(card, 46, 96);
  final control = _laurelAt(card, 70, 113);
  final to = _laurelAt(card, 94, 96);
  return Path()
    ..moveTo(from.dx, from.dy)
    ..quadraticBezierTo(control.dx, control.dy, to.dx, to.dy);
}

/// The badge's five leaves a side, as its painter places them, moved under
/// the card.
List<Path> _leaves(bool master, Rect card) {
  final leaves = <Path>[];
  for (final side in const [-1, 1]) {
    for (var k = 0; k < 5; k++) {
      final u = (master ? 0.1 : 0.12) + k * 0.17;
      final atX = 70 + side * ((master ? 25 : 24) * u + 2);
      final atY = 104.5 - (master ? 9.5 : 9.0) * u * u - 4 * u;
      final degrees =
          (side > 0 ? -25 : 205) + (k.isOdd ? 1 : -1) * 38 * side - side * k * 9;
      final angle = degrees * math.pi / 180;
      final length = (master ? 15 : 13) - k * 0.8;
      final width = master ? 4.8 : 4.2;
      final cos = math.cos(angle), sin = math.sin(angle);
      Offset p(double x, double y) =>
          _laurelAt(card, atX + x * cos - y * sin, atY + x * sin + y * cos);
      final at = p(0, 0);
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

/// The badge's crown (lib/tier_badge.dart), smaller, sitting on the middle of
/// the card's top edge.
const _crownScale = 0.75;

Offset _crownAt(Rect card, double x, double y) => Offset(
  card.center.dx + (x - 70) * _crownScale,
  card.top + 2 + (y - 21) * _crownScale,
);

Path _crown(Rect card) {
  const points = [
    (52.0, 21.0), (52.0, 17.0), (57.0, 3.0), (63.0, 16.0), (70.0, -1.0),
    (77.0, 16.0), (83.0, 3.0), (88.0, 17.0), (88.0, 21.0),
  ];
  final path = Path();
  for (final (i, (x, y)) in points.indexed) {
    final p = _crownAt(card, x, y);
    if (i == 0) {
      path.moveTo(p.dx, p.dy);
    } else {
      path.lineTo(p.dx, p.dy);
    }
  }
  final control = _crownAt(card, 70, 24);
  final start = _crownAt(card, 52, 21);
  return path
    ..quadraticBezierTo(control.dx, control.dy, start.dx, start.dy)
    ..close();
}

/// Behind the card: the glow, the feathers, and the card's own surface over
/// their roots.
class _BackPainter extends CustomPainter {
  const _BackPainter({
    required this.tierIdx,
    required this.radius,
    required this.surface,
    required this.breath,
  });

  final int tierIdx;
  final double radius;

  /// Null where the child paints the card's surface itself.
  final Color? surface;

  /// 0 to 1, the glow's slow swell; 0.5 when still.
  final double breath;

  @override
  void paint(Canvas canvas, Size size) {
    final t = tierIdx.clamp(0, _glow.length - 1);
    final crest = crestOf(t);
    final card = _cardOf(size);
    final rrect = RRect.fromRectAndRadius(card, Radius.circular(radius));
    final feathers = _feathers(crest.wingShapes, card);
    final tip = crest.crown ? _masterLight : crest.light;

    // The glow first, from the card's and the feathers' own shapes, blurred
    // in the tier's colour so it rises off their edges.
    final strength = _glow[t] * (0.8 + 0.4 * breath);
    if (strength > 0) {
      final glow = Paint()
        ..color = crest.mid.withValues(alpha: strength)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 5.0 + t);
      for (final feather in feathers) {
        canvas.drawPath(feather.path, glow);
      }
      canvas.drawRRect(rrect, glow);
    }

    // The feathers: dark at the root, the tier's light at the tip, with a
    // light edge along the top of each. A fan's bottom feather first, so
    // each lies over the one below, as on the badge.
    final highlight = Paint()
      ..color = tip.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    final ordered = crest.fanned ? feathers.reversed : feathers;
    for (final (:path, :side, :root, :end) in ordered) {
      final inner = side > 0 ? card.right : card.left;
      final outer = inner + side * 34;
      canvas.drawPath(
        path,
        Paint()
          ..shader = LinearGradient(
            colors: side > 0 ? [crest.wing, tip] : [tip, crest.wing],
          ).createShader(
            Rect.fromLTRB(
              math.min(inner, outer),
              card.top,
              math.max(inner, outer),
              card.bottom,
            ),
          ),
      );
      canvas.drawLine(root, end, highlight);
    }

    // The card, over the feathers' roots, with a touch of the metal from the
    // start side that grows a little each tier.
    if (surface case final surface?) {
      canvas.drawRRect(rrect, Paint()..color = surface);
      canvas.drawRRect(
        rrect,
        Paint()
          ..shader = LinearGradient(
            colors: [
              crest.mid.withValues(alpha: 0.07 + t * 0.012),
              crest.mid.withValues(alpha: 0),
            ],
            stops: const [0, 0.6],
          ).createShader(card),
      );
    }
  }

  @override
  bool shouldRepaint(_BackPainter old) =>
      old.tierIdx != tierIdx ||
      old.radius != radius ||
      old.surface != surface ||
      old.breath != breath;
}

/// Over the card: its metal edge, the bright line inside it, the laurel, the
/// gem and the crown.
class _FrontPainter extends CustomPainter {
  const _FrontPainter({
    required this.tierIdx,
    required this.radius,
    required this.edge,
  });

  final int tierIdx;
  final double radius;

  /// The page colour, for the hairline that sets a gem or the crown off the
  /// metal behind it.
  final Color edge;

  @override
  void paint(Canvas canvas, Size size) {
    final t = tierIdx.clamp(0, _glow.length - 1);
    final crest = crestOf(t);
    final card = _cardOf(size);
    final rrect = RRect.fromRectAndRadius(card, Radius.circular(radius));
    final tip = crest.crown ? _masterLight : crest.light;

    // The edge: metal, light at the top left and dark at the bottom right.
    canvas.drawRRect(
      rrect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = _edgeWidth[t]
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [crest.light, crest.mid, crest.base],
          stops: const [0, 0.45, 1],
        ).createShader(card),
    );
    // From Silver up, a bright line just inside it.
    if (t >= 2) {
      canvas.drawRRect(
        rrect.deflate(4),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8
          ..color = crest.light.withValues(alpha: t >= 4 ? 0.28 : 0.16),
      );
    }

    // The laurel, from Diamond up, hung under the middle of the card.
    if (crest.laurel case final laurel?) {
      final leaves = _leaves(crest.crown, card);
      canvas.drawPath(
        _stem(card),
        Paint()
          ..color = laurel
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 1.4,
      );
      final bounds = leaves
          .map((leaf) => leaf.getBounds())
          .reduce((a, b) => a.expandToInclude(b));
      final leafPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [tip, laurel],
        ).createShader(bounds);
      for (final leaf in leaves) {
        canvas.drawPath(leaf, leafPaint);
      }
    }

    // Platinum's and Diamond's gem, cut, set in the middle of the top edge.
    if (crest.gem case final gem? when !crest.crown) {
      const g = 7.0;
      final mid = Offset(card.center.dx, card.top);
      final top = mid.translate(0, -g * 1.3);
      final right = mid.translate(g, 0);
      final bottom = mid.translate(0, g * 1.3);
      final left = mid.translate(-g, 0);
      final whole = Path()..addPolygon([top, right, bottom, left], true);
      canvas.drawPath(whole, Paint()..color = crest.base);
      canvas.drawPath(
        Path()..addPolygon([top, mid, left], true),
        Paint()..color = Colors.white.withValues(alpha: 0.85),
      );
      canvas.drawPath(
        Path()..addPolygon([top, right, mid], true),
        Paint()..color = gem,
      );
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

    // Master's crown, sitting on the middle of the top edge.
    if (crest.crown) {
      final crown = _crown(card);
      canvas.drawPath(
        crown,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_masterLight, Color(0xFFC9644B)],
          ).createShader(crown.getBounds()),
      );
      canvas.drawPath(
        crown,
        Paint()
          ..color = edge
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = 1.2,
      );
      for (final (x, y) in const [(57.0, 3.0), (70.0, -1.0), (83.0, 3.0)]) {
        final stone = _crownAt(card, x, y);
        canvas.drawCircle(stone, 2, Paint()..color = crest.mid);
        canvas.drawCircle(
          stone,
          2,
          Paint()
            ..color = edge
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.8,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_FrontPainter old) =>
      old.tierIdx != tierIdx || old.radius != radius || old.edge != edge;
}
