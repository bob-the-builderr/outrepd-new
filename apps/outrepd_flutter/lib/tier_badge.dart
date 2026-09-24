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
library;

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
    feathers: [
      [98, 54, 132, 50, 118, 64],
    ],
  ),
  _Crest(
    base: Color(0xFF8894A0),
    mid: Color(0xFFAEBAC2),
    light: Color(0xFFD8E2E8),
    wing: Color(0xFF68747C),
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
    feathers: [
      [98, 40, 130, 32, 120, 48],
      [98, 54, 132, 50, 118, 64],
      [98, 68, 126, 70, 111, 80],
    ],
  ),
  _Crest(
    base: Color(0xFF8794A0),
    mid: Color(0xFFBCC8D0),
    light: Color(0xFFEDF4F8),
    wing: Color(0xFF6F7C88),
    feathers: [
      [98, 28, 128, 16, 121, 34],
      [98, 40, 132, 32, 121, 48],
      [98, 54, 134, 50, 119, 64],
      [98, 68, 127, 70, 112, 80],
    ],
    gem: Color(0xFFDCE8EF),
  ),
  _Crest(
    base: Color(0xFF2F8F88),
    mid: Color(0xFF5FC9C0),
    light: Color(0xFFA8EDE7),
    wing: Color(0xFF25716C),
    feathers: [
      [98, 26, 132, 12, 124, 32],
      [98, 40, 136, 30, 124, 48],
      [98, 54, 137, 50, 121, 65],
      [98, 68, 131, 70, 114, 81],
      [98, 80, 120, 88, 105, 92],
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
  ),
];

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

    // Wings first: the shield sits on top of where they meet it, so the
    // feathers appear to come out from behind it.
    final wing = Paint()..color = crest.wing;
    for (final f in crest.feathers) {
      canvas.drawPath(_triangle(f), wing);
      canvas.drawPath(_triangle(_mirror(f)), wing);
    }

    if (crest.crown) canvas.drawPath(_crown(), wing);
    if (crest.gem case final gem?) {
      canvas.drawPath(_gem(), Paint()..color = gem);
    }

    // Under the shield, so the arc reads as sitting behind it.
    if (crest.laurel case final laurel?) {
      canvas.drawPath(
        _laurel(dy),
        Paint()
          ..color = laurel
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5 + dy * 0.25
          ..strokeCap = StrokeCap.round,
      );
    }

    canvas.drawPath(_shield(dy), Paint()..color = crest.base);
    canvas.drawPath(_facetRight(dy), Paint()..color = crest.mid);
    canvas.drawPath(_facetLeft(dy), Paint()..color = crest.light);
    canvas.drawPath(
      _chevron(dy),
      Paint()..color = crest.chevron ?? crest.light,
    );
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

    for (final f in crest.feathers) {
      canvas.drawPath(_triangle(f), paint);
      canvas.drawPath(_triangle(_mirror(f)), paint);
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

  Path _crown() => Path()
    ..moveTo(50, 22)
    ..lineTo(57, 7)
    ..lineTo(64, 22)
    ..lineTo(70, 2)
    ..lineTo(76, 22)
    ..lineTo(83, 7)
    ..lineTo(90, 22)
    ..close();

  Path _laurel(double dy) => Path()
    ..moveTo(44 - dy, 98 + dy)
    ..quadraticBezierTo(70, 114 + dy * 2, 96 + dy, 98 + dy);

  Path _triangle(List<double> t) => Path()
    ..moveTo(t[0], t[1])
    ..lineTo(t[2], t[3])
    ..lineTo(t[4], t[5])
    ..close();

  /// The same feather on the other side. Mirrored rather than listed twice,
  /// so the two wings cannot drift apart.
  List<double> _mirror(List<double> t) => [
    _viewWidth - t[0],
    t[1],
    _viewWidth - t[2],
    t[3],
    _viewWidth - t[4],
    t[5],
  ];

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
