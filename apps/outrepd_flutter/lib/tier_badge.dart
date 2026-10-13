/// The rank badge: a winged crest, drawn rather than loaded.
///
/// Seven tiers, and the wings are the ladder. Iron has none, and every tier
/// adds a feather to each side until Diamond's five; Platinum earns a gem,
/// Diamond a laurel under the shield, and Master a crown and the only
/// terracotta wings on the ladder. So the rank reads at a glance, before the
/// name or the colour: you count feathers.
///
/// It replaces a set of regular polygons — a triangle for the first tier up to
/// a circle for the last — which had the same idea (a shape that grows) and
/// none of the weight. It also replaces the PNG crest that came before that.
/// One painter covers every tier at every size, which is what lets the same
/// badge sit at 15dp inside a chip and 110dp on the home screen without
/// anything being exported twice.
///
/// Geometry is the mock's own, in its 140×120 space, fitted to whatever box
/// the caller gives. Master's shield sits two units lower than the rest to
/// make room for the crown; the mock also widens its chevron by a unit, which
/// is below anything visible and is not reproduced here.
///
/// Drawn as metal rather than flat colour: the shield shaded light at the top
/// to dark at the point, with a bevel inside its rim and a dark edge round
/// it; a chevron raised off it by its own shadow; feathers rooted on the
/// shield's edge wherever they meet it, dark at the root and lit at the tip
/// and along their top; a cut gem; a laurel of leaves; and a glow off the
/// whole silhouette that grows with the tier. From Gold up the wings are one
/// closed fan a side rather than separate blades — the same count of
/// feathers, lying over each other — and Master's crown sits on the shield.
library;

import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'theme.dart';

/// The mock's coordinate space. Every number below is in it.
const _viewWidth = 140.0;
const _viewHeight = 120.0;

/// One tier's crest: the colours, and what it has earned.
class _Crest {
  const _Crest({
    required this.base,
    required this.mid,
    required this.light,
    required this.wing,
    this.feathers = const [],
    this.chevron,
    this.gem,
    this.laurel,
    this.crown = false,
    this.shieldDy = 0,
    this.fan = const [],
    this.glow = 0,
  });

  /// The shield, front to back: the body, the right facet, and the left facet
  /// that catches the light.
  final Color base;
  final Color mid;
  final Color light;

  /// The feathers, and the crown when there is one.
  final Color wing;

  /// Right-side feathers as triangles — `[x1,y1, x2,y2, x3,y3]` each. The
  /// left side is these mirrored, so a feather can never be added to one wing
  /// and forgotten on the other.
  final List<List<double>> feathers;

  /// Defaults to [light]; Diamond and Master lift it off the shield.
  final Color? chevron;

  /// Platinum and above.
  final Color? gem;

  /// Diamond and above: the arc beneath the shield.
  final Color? laurel;

  final bool crown;

  /// Master's shield drops to make room for the crown.
  final double shieldDy;

  /// The wing from Gold up, in place of [feathers]: one fan a side, each
  /// feather as `[root height, angle from level in degrees (negative is up),
  /// length]`, rooted close together so they lie over each other as one
  /// wing. As many feathers as [feathers] has, spreading wider each tier.
  final List<List<double>> fan;

  /// How strongly the silhouette glows: nothing on Iron, more each tier.
  final double glow;
}

/// Iron to Master, in ladder order. The index is the tier index.
const _crests = <_Crest>[
  // Iron — no wings. The bottom of the ladder is a bare shield, and the
  // absence is the point: there is nothing on it yet.
  _Crest(
    base: Color(0xFF5E5E5B),
    mid: Color(0xFF82827D),
    light: Color(0xFF9A9A94),
    wing: Color(0xFF5E5E5B),
  ),
  _Crest(
    base: Color(0xFFA8663A),
    mid: Color(0xFFC9834E),
    light: Color(0xFFE3A272),
    wing: Color(0xFF7E4A28),
    glow: 0.3,
    feathers: [
      [98, 54, 132, 50, 118, 64],
    ],
  ),
  _Crest(
    base: Color(0xFF8894A0),
    mid: Color(0xFFAEBAC2),
    light: Color(0xFFD8E2E8),
    wing: Color(0xFF68747C),
    glow: 0.35,
    feathers: [
      [98, 40, 130, 32, 120, 48],
      [98, 54, 132, 50, 118, 64],
    ],
  ),
  _Crest(
    base: Color(0xFFB8912F),
    mid: Color(0xFFE0B145),
    light: Color(0xFFF7D87F),
    wing: Color(0xFF8A6518),
    glow: 0.5,
    feathers: [
      [98, 40, 130, 32, 120, 48],
      [98, 54, 132, 50, 118, 64],
      [98, 68, 126, 70, 111, 80],
    ],
    fan: [
      [43, -15, 47],
      [51, -4, 45],
      [59, 7, 40],
    ],
  ),
  _Crest(
    base: Color(0xFF8794A0),
    mid: Color(0xFFBCC8D0),
    light: Color(0xFFEDF4F8),
    wing: Color(0xFF6F7C88),
    glow: 0.55,
    feathers: [
      [98, 28, 128, 16, 121, 34],
      [98, 40, 132, 32, 121, 48],
      [98, 54, 134, 50, 119, 64],
      [98, 68, 127, 70, 112, 80],
    ],
    fan: [
      [40, -19, 49],
      [48, -9, 47],
      [56, 1, 44],
      [64, 11, 39],
    ],
    gem: Color(0xFFDCE8EF),
  ),
  _Crest(
    base: Color(0xFF2F8F88),
    mid: Color(0xFF5FC9C0),
    light: Color(0xFFA8EDE7),
    wing: Color(0xFF25716C),
    glow: 0.65,
    feathers: [
      [98, 26, 132, 12, 124, 32],
      [98, 40, 136, 30, 124, 48],
      [98, 54, 137, 50, 121, 65],
      [98, 68, 131, 70, 114, 81],
      [98, 80, 120, 88, 105, 92],
    ],
    fan: [
      [37, -22, 50],
      [45, -12, 49],
      [53, -2, 46],
      [61, 8, 42],
      [69, 18, 36],
    ],
    chevron: Color(0xFFCFF7F3),
    gem: Color(0xFFA8EDE7),
    laurel: Color(0xFF5FC9C0),
  ),
  // Master — the only terracotta on the ladder, and the only crown. The
  // shield turns to cream so the wings are what carries the colour.
  _Crest(
    base: Color(0xFFCFC3B0),
    mid: Color(0xFFF0E9DC),
    light: Color(0xFFFFFFFF),
    wing: Color(0xFFE8846B),
    feathers: [
      [98, 24, 138, 8, 128, 30],
      [98, 38, 140, 26, 127, 46],
      [98, 52, 140, 48, 123, 64],
      [98, 66, 134, 70, 116, 81],
      [98, 80, 124, 89, 107, 93],
    ],
    chevron: Color(0xFFE8846B),
    laurel: Color(0xFFE8846B),
    crown: true,
    shieldDy: 2,
    glow: 0.75,
    fan: [
      [37, -22, 50],
      [45, -12, 49],
      [53, -2, 46],
      [61, 8, 42],
      [69, 18, 36],
    ],
  ),
];

/// A tier's crest, for what is drawn to match its badge — the frame around a
/// lifter's picture (lib/tier_frame.dart). Read from here so the two can
/// never disagree about a tier's colours or how many feathers it has earned.
({
  Color base,
  Color mid,
  Color light,
  Color wing,
  List<List<Offset>> wingShapes,
  Color? gem,
  Color? laurel,
  bool crown,
  bool fanned,
})
crestOf(int tierIdx) {
  final c = _crests[tierIdx.clamp(0, _crests.length - 1)];
  return (
    base: c.base,
    mid: c.mid,
    light: c.light,
    wing: c.wing,
    wingShapes: _wingShapes(c),
    gem: c.gem,
    laurel: c.laurel,
    crown: c.crown,
    fanned: c.fan.isNotEmpty,
  );
}

/// A crest's right wing, feather by feather, as shapes in the badge's space
/// with their roots at x 98 — the shield's straight side — for whatever
/// draws them to move onto its own edge: the shield's (this file) or the
/// frame's ring (tier_frame.dart).
List<List<Offset>> _wingShapes(_Crest c) {
  if (c.fan.isNotEmpty) {
    return [
      for (final [rootY, degrees, length] in c.fan)
        _blade(rootY + c.shieldDy, degrees, length),
    ];
  }
  // The badge's own triangles, given a root as wide as their base so each
  // grows out of the shield rather than touching it at a point.
  return [
    for (final [_, y1, x2, y2, x3, y3] in c.feathers)
      [Offset(98, y1 - 1), Offset(x2, y2), Offset(x3, y3), Offset(98, y3 + 1)],
  ];
}

/// One of Master's feathers: wide at the root, a long top edge to its
/// point, and a cut back underneath the way the other tiers' feathers end.
List<Offset> _blade(double y, double degrees, double length) {
  final a = degrees * math.pi / 180;
  final cos = math.cos(a), sin = math.sin(a);
  return [
    Offset(98, y - 8),
    Offset(94 + length * cos, y + length * sin),
    Offset(94 + length * 0.7 * cos - sin * 9, y + length * 0.7 * sin + cos * 9),
    Offset(98, y + 8),
  ];
}

class TierBadge extends StatelessWidget {
  const TierBadge({
    super.key,
    required this.tierIndex,
    required this.size,
    this.locked = false,
  }) : unranked = false;

  /// The badge for an account that has no tier yet: the crest's outline with
  /// nothing inside it and no wings.
  ///
  /// Deliberately not the first tier's badge. Showing a new lifter the bottom
  /// rung says the app has judged them and put them last; an empty outline
  /// says the app does not know yet, which is the truth.
  const TierBadge.unranked({super.key, required this.size})
    : tierIndex = 0,
      locked = false,
      unranked = true;

  final int tierIndex;
  final double size;

  /// A tier not yet reached: the same silhouette, hollow, so the shape of
  /// what is ahead is still readable.
  final bool locked;

  final bool unranked;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CrestPainter(
          crest: _crests[tierIndex.clamp(0, _crests.length - 1)],
          hollow: locked || unranked,
          dashed: unranked,
          outline: locked
              ? context.colors.muted.withValues(alpha: 0.35)
              : context.colors.faint,
        ),
      ),
    );
  }
}

/// The badge as a PNG [size] logical pixels square, for a place Flutter does
/// not draw: the home-screen widgets show a picture the app saved for them.
/// A null [tierIdx] is the unranked outline.
///
/// The widgets sit on the dark page whatever the app's theme, so the outline
/// is the dark theme's.
Future<Uint8List> tierBadgePng({
  required int? tierIdx,
  required double size,
  required double pixelRatio,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)..scale(pixelRatio);
  _CrestPainter(
    crest: _crests[(tierIdx ?? 0).clamp(0, _crests.length - 1)],
    hollow: tierIdx == null,
    dashed: tierIdx == null,
    outline: kDarkPalette.faint,
  ).paint(canvas, Size.square(size));
  final picture = recorder.endRecording();
  final side = (size * pixelRatio).round();
  final image = await picture.toImage(side, side);
  try {
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  } finally {
    image.dispose();
    picture.dispose();
  }
}

class _CrestPainter extends CustomPainter {
  const _CrestPainter({
    required this.crest,
    required this.hollow,
    required this.dashed,
    required this.outline,
  });

  final _Crest crest;

  /// Draw the silhouette only — a locked tier, or an account with no tier.
  final bool hollow;

  /// Dashes rather than a solid outline: a rank still being decided, not one
  /// that happens to be empty.
  final bool dashed;

  final Color outline;

  /// Just the shield, with a little room for its stroke. What the unranked
  /// badge is fitted to.
  static const _shieldBounds = Rect.fromLTRB(40, 20, 100, 104);

  @override
  void paint(Canvas canvas, Size size) {
    // Every ranked crest is fitted to the same frame, so a wing that grows
    // reads as growth rather than as a badge that was drawn bigger. The
    // unranked one has no wings and never sits in a row being compared with
    // them — it is the hero on the home screen — so it is fitted to the
    // shield alone instead of rendering at a third of the space it was
    // given.
    final source = dashed
        ? _shieldBounds
        : const Rect.fromLTRB(0, 0, _viewWidth, _viewHeight);
    final scale = (size.width / source.width).clamp(
      0.0,
      size.height / source.height,
    );

    canvas.save();
    canvas.translate(
      (size.width - source.width * scale) / 2 - source.left * scale,
      (size.height - source.height * scale) / 2 - source.top * scale,
    );
    canvas.scale(scale);

    if (hollow) {
      _paintHollow(canvas);
    } else {
      _paintCrest(canvas);
    }

    canvas.restore();
  }

  void _paintCrest(Canvas canvas) {
    final dy = crest.shieldDy;
    final master = crest.crown;
    final tip = master ? _masterLight : crest.light;
    final wings = [
      for (final shape in _wingShapes(crest)) ...[
        _anchored(shape, dy, 1),
        _anchored(shape, dy, -1),
      ],
    ];
    final leaves = crest.laurel == null ? const <Path>[] : _leaves(dy);
    final shield = _shield(dy);

    // The glow, off the whole silhouette and in the tier's own colour.
    if (crest.glow > 0) {
      final glow = Paint()
        ..color = crest.mid.withValues(alpha: crest.glow)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
      for (final feather in wings) {
        canvas.drawPath(feather.path, glow);
      }
      for (final leaf in leaves) {
        canvas.drawPath(leaf, glow);
      }
      canvas.drawPath(shield, glow);
      if (master) canvas.drawPath(_crown(dy), glow);
      if (crest.gem != null && !master) canvas.drawPath(_gem(), glow);
    }

    // Wings first: the shield sits on top of where they meet it, so the
    // feathers come out from behind it. A fan is drawn bottom feather
    // first, so each lies over the one below, with a dark hairline that
    // keeps the count readable where they overlap.
    final fanned = crest.fan.isNotEmpty;
    final ordered = fanned ? wings.reversed.toList() : wings;
    final hairline = master
        ? const Color(0xFF9E4733)
        : _darken(crest.wing, 0.45);
    for (final (:path, :side, :root, :end) in ordered) {
      final bounds = path.getBounds();
      canvas.drawPath(
        path,
        Paint()
          ..shader = LinearGradient(
            colors: side > 0 ? [crest.wing, tip] : [tip, crest.wing],
          ).createShader(bounds),
      );
      if (fanned) {
        canvas.drawPath(
          path,
          Paint()
            ..color = hairline.withValues(alpha: 0.45)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.6
            ..strokeJoin = StrokeJoin.round,
        );
      }
      canvas.drawLine(
        root,
        end,
        Paint()
          ..color = tip.withValues(alpha: master ? 0.8 : 0.7)
          ..strokeWidth = 1,
      );
    }

    // The laurel: a stem under the shield and leaves along it.
    if (crest.laurel case final laurel?) {
      canvas.drawPath(
        Path()
          ..moveTo(46 - dy, 96 + dy)
          ..quadraticBezierTo(70, 113 + dy * 2, 94 + dy, 96 + dy),
        Paint()
          ..color = laurel
          ..style = PaintingStyle.stroke
          ..strokeWidth = master ? 1.7 : 1.6
          ..strokeCap = StrokeCap.round,
      );
      final leafPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [tip, laurel],
        ).createShader(Rect.fromLTRB(40, 86 + dy, 100, 112 + dy * 2));
      for (final leaf in leaves) {
        canvas.drawPath(leaf, leafPaint);
      }
    }

    // Platinum's and Diamond's gem, cut into facets.
    if (crest.gem case final gem? when !master) {
      canvas.drawPath(_gem(), Paint()..color = crest.base);
      canvas.drawPath(
        Path()..addPolygon(const [Offset(70, 5), Offset(70, 14.5), Offset(63.5, 14.5)], true),
        Paint()..color = Colors.white.withValues(alpha: 0.9),
      );
      canvas.drawPath(
        Path()..addPolygon(const [Offset(70, 5), Offset(76.5, 14.5), Offset(70, 14.5)], true),
        Paint()..color = gem,
      );
      canvas.drawPath(
        Path()..addPolygon(const [Offset(63.5, 14.5), Offset(70, 14.5), Offset(70, 24)], true),
        Paint()..color = crest.mid,
      );
      canvas.drawPath(
        _gem(),
        Paint()
          ..color = _edge
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.7,
      );
    }

    // The shield: shaded body and a dark edge, the two lit facets, and a
    // bevel inside the rim.
    final body = Rect.fromLTRB(42, 22 + dy, 98, 102 + dy);
    canvas.drawPath(
      shield,
      Paint()
        ..shader = LinearGradient(
          begin: const Alignment(-0.7, -1),
          end: const Alignment(0.7, 1),
          colors: master
              ? const [Colors.white, Color(0xFFEDE4D4), Color(0xFFB3A48B)]
              : [crest.mid, crest.base, _darken(crest.base, 0.28)],
          stops: const [0, 0.5, 1],
        ).createShader(body),
    );
    canvas.drawPath(
      shield,
      Paint()
        ..color = const Color(0xFF0B0A09).withValues(alpha: master ? 0.65 : 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = master ? 1.7 : 1.6
        ..strokeJoin = StrokeJoin.round,
    );
    final facetBox = Rect.fromLTRB(42, 22 + dy, 98, 48 + dy);
    canvas.drawPath(
      _facetRight(dy),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: master
              ? const [Colors.white, Color(0xFFF0E9DC)]
              : [crest.light, crest.mid],
        ).createShader(facetBox),
    );
    canvas.drawPath(
      _facetLeft(dy),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: master
              ? [Colors.white, Colors.white.withValues(alpha: 0.85)]
              : [Colors.white.withValues(alpha: 0.9), crest.light],
        ).createShader(facetBox),
    );
    // The bevel: the shield's own outline, a tenth smaller, inside it.
    canvas.save();
    canvas.translate(70, 62 + dy);
    canvas.scale(0.9);
    canvas.translate(-70, -(62 + dy));
    canvas.drawPath(
      shield,
      Paint()
        ..color = master
            ? crest.wing.withValues(alpha: 0.85)
            : crest.light.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = master ? 1.3 : 1.1,
    );
    canvas.restore();

    // The chevron, raised: its shadow, its body lit from above, a bright
    // top edge.
    final chevron = _chevron(dy);
    final chevronColour = crest.chevron ?? crest.light;
    canvas.drawPath(
      chevron.shift(const Offset(0, 2)),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.2),
    );
    canvas.drawPath(
      chevron,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            crest.chevron == null ? Colors.white : _lighten(chevronColour, 0.25),
            chevronColour,
          ],
        ).createShader(Rect.fromLTRB(56, 64 + dy, 84, 80 + dy)),
    );
    canvas.drawPath(
      Path()
        ..moveTo(56, 74 + dy)
        ..lineTo(70, 64 + dy)
        ..lineTo(84, 74 + dy),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    // Master's crown, set on the shield's point.
    if (master) {
      final crown = _crown(dy);
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
          ..color = _edge
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.9
          ..strokeJoin = StrokeJoin.round,
      );
      final band = 22 + dy - 5;
      canvas.drawLine(
        Offset(52, band),
        Offset(88, band),
        Paint()
          ..color = _edge.withValues(alpha: 0.5)
          ..strokeWidth = 0.7,
      );
      for (final orb in [
        Offset(57, 22 + dy - 19),
        Offset(70, 22 + dy - 23),
        Offset(83, 22 + dy - 19),
      ]) {
        canvas.drawCircle(orb, 2.1, Paint()..color = crest.mid);
        canvas.drawCircle(
          orb,
          2.1,
          Paint()
            ..color = _edge
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.6,
        );
      }
    }
  }

  /// The hairline that sets a gem or the crown off what is behind it.
  static const _edge = Color(0xFF121110);

  /// Master's terracotta, lighter: its feather tips and its leaves, where
  /// every other tier uses the light of its own metal.
  static const _masterLight = Color(0xFFF6B49F);

  static Color _lighten(Color c, double t) => Color.lerp(c, Colors.white, t)!;
  static Color _darken(Color c, double t) => Color.lerp(c, Colors.black, t)!;

  /// Where the shield's right edge is at height [y]: the slope of its top,
  /// the straight side, or the curve down to its point.
  static double _edgeX(double y, double dy) {
    if (y <= 34 + dy) return 70 + math.max(0.0, y - (22 + dy)) * 28 / 12;
    if (y <= 62 + dy) return 98;
    if (y >= 102 + dy) return 70;
    double curve(double t, double a, double b, double c, double d) {
      final u = 1 - t;
      return u * u * u * a + 3 * u * u * t * b + 3 * u * t * t * c + t * t * t * d;
    }
    var lo = 0.0, hi = 1.0;
    for (var i = 0; i < 30; i++) {
      final mid = (lo + hi) / 2;
      if (curve(mid, 62 + dy, 86 + dy, 102 + dy, 102 + dy) < y) {
        lo = mid;
      } else {
        hi = mid;
      }
    }
    return curve((lo + hi) / 2, 98, 98, 70, 70);
  }

  /// A right-side wing shape placed on [side]: its root points — the ones at
  /// x 98 — moved onto the shield's edge at their own height, just behind
  /// it, and the whole mirrored for the left. Comes back with the two ends
  /// of its top edge, which catches the light.
  static ({Path path, int side, Offset root, Offset end}) _anchored(
    List<Offset> shape,
    double dy,
    int side,
  ) {
    final points = [
      for (final p in shape)
        Offset(
          p.dx == 98 ? _edgeX(p.dy, dy) - 5 : p.dx,
          p.dy,
        ),
    ].map((p) => side > 0 ? p : Offset(_viewWidth - p.dx, p.dy)).toList();
    return (
      path: Path()..addPolygon(points, true),
      side: side,
      root: points[0],
      end: points[1],
    );
  }

  /// Five leaves a side along the laurel's stem, alternating out and in.
  List<Path> _leaves(double dy) {
    final master = crest.crown;
    final leaves = <Path>[];
    for (final side in const [-1, 1]) {
      for (var k = 0; k < 5; k++) {
        final u = (master ? 0.1 : 0.12) + k * 0.17;
        final at = Offset(
          70 + side * ((master ? 25 : 24) * u + 2),
          104.5 + dy * 2 - (master ? 9.5 : 9.0) * u * u - 4 * u,
        );
        final degrees =
            (side > 0 ? -25 : 205) + (k.isOdd ? 1 : -1) * 38 * side - side * k * 9;
        final angle = degrees * math.pi / 180;
        final length = (master ? 15 : 13) - k * 0.8;
        final width = master ? 4.8 : 4.2;
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

  /// The silhouette alone: shield and wings, no facets and no chevron. What
  /// is ahead, or what has not been decided — in both cases the shape is the
  /// whole message.
  void _paintHollow(Canvas canvas) {
    final paint = Paint()
      ..color = outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeJoin = StrokeJoin.round;

    final shield = _shield(0);
    canvas.drawPath(dashed ? _dashes(shield) : shield, paint);
    if (dashed) return;

    for (final shape in _wingShapes(crest)) {
      canvas.drawPath(_anchored(shape, 0, 1).path, paint);
      canvas.drawPath(_anchored(shape, 0, -1).path, paint);
    }
  }

  // ─────────────────────────────── the parts ───────────────────────────────

  Path _shield(double dy) => Path()
    ..moveTo(70, 22 + dy)
    ..lineTo(98, 34 + dy)
    ..lineTo(98, 62 + dy)
    ..cubicTo(98, 86 + dy, 70, 102 + dy, 70, 102 + dy)
    ..cubicTo(70, 102 + dy, 42, 86 + dy, 42, 62 + dy)
    ..lineTo(42, 34 + dy)
    ..close();

  Path _facetRight(double dy) => Path()
    ..moveTo(70, 22 + dy)
    ..lineTo(98, 34 + dy)
    ..lineTo(70, 48 + dy)
    ..close();

  Path _facetLeft(double dy) => Path()
    ..moveTo(42, 34 + dy)
    ..lineTo(70, 22 + dy)
    ..lineTo(70, 48 + dy)
    ..close();

  /// The bar seen end on — the one shape that means "lifting" without
  /// becoming clip-art. It survived every version of this badge.
  Path _chevron(double dy) => Path()
    ..moveTo(56, 74 + dy)
    ..lineTo(70, 64 + dy)
    ..lineTo(84, 74 + dy)
    ..lineTo(84, 80 + dy)
    ..lineTo(70, 70 + dy)
    ..lineTo(56, 80 + dy)
    ..close();

  Path _gem() => Path()
    ..moveTo(70, 5)
    ..lineTo(76.5, 14.5)
    ..lineTo(70, 24)
    ..lineTo(63.5, 14.5)
    ..close();

  /// Master's crown: the three terracotta points on a band that sits on
  /// the shield's point.
  Path _crown(double dy) {
    final by = 22 + dy;
    return Path()
      ..moveTo(52, by - 1)
      ..lineTo(52, by - 5)
      ..lineTo(57, by - 19)
      ..lineTo(63, by - 6)
      ..lineTo(70, by - 23)
      ..lineTo(77, by - 6)
      ..lineTo(83, by - 19)
      ..lineTo(88, by - 5)
      ..lineTo(88, by - 1)
      ..quadraticBezierTo(70, by + 2, 52, by - 1)
      ..close();
  }

  /// Cuts a path into dashes. Flutter has no dash support on Paint, so they
  /// are built into the path itself.
  Path _dashes(Path source) {
    const on = 7.0, off = 5.0;
    final out = Path();
    for (final metric in source.computeMetrics()) {
      var at = 0.0;
      while (at < metric.length) {
        final end = (at + on).clamp(0.0, metric.length);
        out.addPath(metric.extractPath(at, end), Offset.zero);
        at = end + off;
      }
    }
    return out;
  }

  @override
  bool shouldRepaint(_CrestPainter old) =>
      old.crest != crest ||
      old.hollow != hollow ||
      old.dashed != dashed ||
      old.outline != outline;
}
