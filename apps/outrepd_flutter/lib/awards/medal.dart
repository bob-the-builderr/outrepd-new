/// A medal (the user's pick, 2026-11-09): a notched rim struck in its tier's
/// metal, a dark face, and the family's mark — drawn from the same SVG as
/// design/mockups/2026-11-10/awards/awards.js, so the app is the mockup.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'families.dart';

/// Bronze, Silver, Gold, Platinum, Diamond: light, middle and dark of each.
const _metal = <(String, String, String)>[
  ('#E9A57A', '#9A5A35', '#5C311A'),
  ('#F2F0EC', '#A9A49B', '#5E5A53'),
  ('#FBE59A', '#D9A94A', '#7A5714'),
  ('#D9FBFF', '#7FC9D6', '#2E6672'),
  ('#E7D4FF', '#9B7BEA', '#43307E'),
];

const _tierColours = [
  Color(0xFF9A5A35),
  Color(0xFFA9A49B),
  Color(0xFFD9A94A),
  Color(0xFF7FC9D6),
  Color(0xFF9B7BEA),
];

/// The tier's own colour, for rings and words.
Color tierColour(int tier) => _tierColours[tier.clamp(0, 4)];

const _glyphs = <AwardGlyph, String>{
  AwardGlyph.fist: '<path d="M14 22v-6a3 3 0 0 1 6 0v4m0-5a3 3 0 0 1 6 0v5m0-4a3 3 0 0 1 6 0v6m0-3a3 3 0 0 1 6 0v9c0 8-5 12-12 12h-2c-6 0-10-4-10-10v-4l4-4"/>',
  AwardGlyph.flame: '<path d="M24 6c2 7 10 11 10 21a10 10 0 0 1-20 0c0-5 2-8 5-10 0 4 2 6 4 7-1-7 0-13 1-18z"/>',
  AwardGlyph.crown: '<path d="M8 34h32M9 30l-1-16 9 8 7-12 7 12 9-8-1 16z"/>',
  AwardGlyph.bolt: '<path d="M27 5 11 27h12l-3 16 17-23H25z"/>',
  AwardGlyph.chart: '<path d="M8 38h32M12 32l8-9 7 5 11-14M32 14h6v6"/>',
  AwardGlyph.sword: '<path d="M10 38l8-8m-4 12-8-8M18 30 38 10l1-5-5 1-20 20"/>',
  AwardGlyph.shield: '<path d="M24 6l14 5v11c0 9-6 16-14 20-8-4-14-11-14-20V11z"/><path d="M17 23l5 5 9-10"/>',
  AwardGlyph.link: '<path d="M21 27a7 7 0 0 0 10 0l6-6a7 7 0 0 0-10-10l-2 2"/><path d="M27 21a7 7 0 0 0-10 0l-6 6a7 7 0 0 0 10 10l2-2"/>',
  AwardGlyph.ghost: '<path d="M12 40V22a12 12 0 0 1 24 0v18l-4-3-4 3-4-3-4 3-4-3z"/><circle cx="19" cy="22" r="1.5"/><circle cx="29" cy="22" r="1.5"/>',
  AwardGlyph.castle: '<path d="M8 40V18h6v5h5v-5h10v5h5v-5h6v22zM20 40v-8a4 4 0 0 1 8 0v8"/>',
  AwardGlyph.target: '<circle cx="24" cy="24" r="15"/><circle cx="24" cy="24" r="8"/><circle cx="24" cy="24" r="1.5"/>',
  AwardGlyph.sun: '<circle cx="24" cy="26" r="7"/><path d="M24 9v5M11 26H6m36 0h-5M14 16l-3-3m26 3 3-3M8 38h32"/>',
  AwardGlyph.moon: '<path d="M32 30A13 13 0 0 1 18 12a13 13 0 1 0 14 18z"/><path d="M34 9v6m-3-3h6"/>',
  AwardGlyph.people: '<circle cx="18" cy="17" r="5"/><circle cx="31" cy="19" r="4"/><path d="M8 38c0-6 4-10 10-10s10 4 10 10M28 38c0-5 2-8 6-8s6 3 6 8"/>',
  AwardGlyph.one: '<path d="M20 14l6-4v28m-8 0h16"/>',
  AwardGlyph.clock: '<circle cx="24" cy="25" r="14"/><path d="M24 17v8l5 4M20 7h8"/>',
};

final _svgs = <String, String>{};

/// The medal's SVG, made once for each tier, mark and state.
String medalSvg(int tier, AwardGlyph glyph, {bool locked = false}) =>
    _svgs.putIfAbsent('$tier/${glyph.name}/$locked', () {
      final (a, b, c) = _metal[tier.clamp(0, 4)];
      final rim = <String>[];
      for (var i = 0; i < 24; i++) {
        final r = i.isOdd ? 44.0 : 47.0;
        final t = i / 24 * math.pi * 2 - math.pi / 2;
        rim.add('${(50 + math.cos(t) * r).toStringAsFixed(2)},${(50 + math.sin(t) * r).toStringAsFixed(2)}');
      }
      final ink = locked ? '#6d675f' : a;
      return '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">'
          '<defs><linearGradient id="m" x1="0" y1="0" x2="1" y2="1">'
          '<stop offset="0" stop-color="$a"/><stop offset=".55" stop-color="$b"/>'
          '<stop offset="1" stop-color="$c"/></linearGradient>'
          '<radialGradient id="f" cx=".5" cy=".35" r=".7"><stop offset="0" stop-color="#2b2620"/>'
          '<stop offset="1" stop-color="#121110"/></radialGradient></defs>'
          '<polygon points="${rim.join(' ')}" fill="url(#m)"/>'
          '<circle cx="50" cy="50" r="34" fill="url(#f)" stroke="$a" stroke-opacity=".85" stroke-width="2"/>'
          '<path d="M22 32 A34 34 0 0 1 78 32" fill="none" stroke="#ffffff" stroke-opacity=".12" stroke-width="5"/>'
          '<g transform="translate(26 26)" fill="none" stroke="$ink" stroke-width="3.2" '
          'stroke-linecap="round" stroke-linejoin="round">${_glyphs[glyph]}</g></svg>';
    });

const _grey = ColorFilter.matrix([
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0, 0, 0, 0.5, 0,
]);

class Medal extends StatelessWidget {
  const Medal({
    super.key,
    required this.tier,
    required this.glyph,
    this.size = 92,
    this.locked = false,
  });

  final int tier;
  final AwardGlyph glyph;
  final double size;

  /// Not earned: the same medal, grey and dim.
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final picture = SvgPicture.string(
      medalSvg(tier, glyph, locked: locked),
      width: size,
      height: size,
    );
    if (locked) return ColorFiltered(colorFilter: _grey, child: picture);
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: tierColour(tier).withValues(alpha: 0.33), blurRadius: size / 6),
          BoxShadow(color: const Color(0x80000000), blurRadius: size / 8, offset: Offset(0, size / 16)),
        ],
      ),
      child: picture,
    );
  }
}

/// A ring round a medal: how far to the next tier.
class AwardRing extends StatelessWidget {
  const AwardRing({super.key, required this.size, required this.share, required this.colour, required this.child});

  final double size;
  final double share;
  final Color colour;
  final Widget child;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: size,
    height: size,
    child: CustomPaint(
      painter: _RingPainter(share: share.clamp(0.0, 1.0), colour: colour),
      child: Center(child: child),
    ),
  );
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.share, required this.colour});

  final double share;
  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(3);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, math.pi * 2, false, paint..color = const Color(0xFF2A2724));
    if (share > 0) {
      canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * share, false, paint..color = colour);
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.share != share || old.colour != colour;
}

/// Five dots, one for each tier, the reached ones in their metal.
class TierPips extends StatelessWidget {
  const TierPips({super.key, required this.reached});

  /// How many tiers are held, 0–5.
  final int reached;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (var t = 0; t < 5; t++) ...[
        if (t > 0) const SizedBox(width: 3),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: t < reached ? tierColour(t) : const Color(0xFF34302B),
          ),
        ),
      ],
    ],
  );
}
