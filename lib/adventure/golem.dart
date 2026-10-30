/// The adventure's monsters: a different creature in every world, and five
/// forms of it on the way to the King.
///
/// A rock golem in the mines, a scarab in the dunes, a yeti on the peaks, a
/// knight in the citadel, a wraith on the glacier, a crystal dragon in the
/// caverns, and the Master on the throne. Each evolves as its world goes on:
/// a new form every five levels, each a size up on the last and keeping all
/// it had — armour, horns, a weapon, wings — and the King at the end
/// crowned, with its world's light around it. The Warden at levels 5, 10
/// and 15 is the first sight of the next form, standing in a glow. They
/// were one golem recoloured for each world, then one creature per world
/// that only grew; a lifter climbing them could not feel it evolve (the
/// user, 2026-10-28).
///
/// Drawn, not bundled: it scales to any size and costs nothing to ship.
library;

import 'dart:math' as math;
import 'dart:ui' as ui;

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
    final form = level.form;
    final warden = level.kind == FightKind.elite;
    // Each form stands a size up on the last, to the King's.
    const sizes = [0.64, 0.74, 0.84, 0.93, 1.02];

    // Drawn on a 200 square, its feet on the ground and grown from there.
    canvas.save();
    canvas.scale(size.shortestSide / 200);
    canvas.translate(100, 182);
    canvas.scale(sizes[form - 1] * 200 / 210);
    canvas.translate(-100, -188);

    // The shadow first, outside the layer the hit flash whitens.
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(100, 190), width: 132, height: 16),
      Paint()..color = const Color(0x80000000),
    );
    final draw = _Draw(canvas, look);
    // A Warden: the next form, first seen, standing in its world's light.
    if (warden) {
      draw.glow(100, 110, 100, look.eye, 0.3);
      canvas.drawOval(
        Rect.fromCenter(center: const Offset(100, 190), width: 140, height: 20),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = look.eye.withValues(alpha: 0.7),
      );
    }
    canvas.saveLayer(const Rect.fromLTWH(-40, -40, 280, 280), Paint());

    switch (level.world.clamp(0, kWorlds - 1)) {
      case 0:
        _rockGolem(draw, form);
      case 1:
        _scarab(draw, form);
      case 2:
        _yeti(draw, form);
      case 3:
        _knight(draw, form);
      case 4:
        _wraith(draw, form);
      case 5:
        _dragon(draw, form);
      default:
        _shadowKing(draw, form);
    }

    // Cracks open across the body as the HP drops.
    if (hurt > 0.3) draw.crack('M88 90 L96 102 L90 112 L98 124');
    if (hurt > 0.6) {
      draw.crack('M128 84 L118 96 L126 106');
      draw.crack('M62 106 L72 116 L66 130');
    }
    if (hurt > 0.85) draw.crack('M110 148 L104 156 L110 162');

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

  @override
  bool shouldRepaint(GolemPainter old) =>
      old.level.number != level.number ||
      old.hurt != hurt ||
      old.flash != flash;
}

// ─────────────────────────── the seven creatures ────────────────────────────
//
// [form] is 1 to 5 (AdventureLevel.form). Each form keeps everything the one
// before it had and adds to it, so the climb through a world shows in the
// monster: armour, horns, a weapon, wings, then a crown and its world's light.

/// Iron Mines: a golem of rock with ore glowing in its cracks. A miner's
/// lamp and shoulders of boulder, then spikes and more ore, then a pick;
/// the King grows horns and burns all over.
void _rockGolem(_Draw d, int form) {
  final l = d.look;
  d.both(() => d.part('M72 146 L64 186 L96 186 L98 150 Z'));
  d.both(() {
    d.part('M60 76 L34 90 L24 126 L44 134 L58 104 Z');
    d.part('M24 122 L14 150 L26 172 L54 170 L56 142 L44 130 Z');
  });
  d.part(
    'M62 64 L88 50 L116 52 L142 66 L156 102 L148 142 L118 162 L82 162 '
    'L52 142 L44 102 Z',
    width: 2.2,
  );
  d.stroke(
    'M62 64 L80 92 L74 126 L52 142 M142 66 L122 90 L128 126 L148 142 '
    'M80 92 L122 90 M74 126 L128 126',
    const Color(0x40000000),
    1.6,
  );
  d.lit('M84 98 L94 110 L88 120 L98 132', l.eye, form == 1 ? 1.6 : 2.6);
  if (form >= 3) {
    d.lit('M126 98 L116 112 L124 124', l.eye, 2.4);
    d.lit('M60 108 L70 118 L64 132', l.eye, 2.4);
  }
  if (form >= 5) {
    d.lit('M104 140 L112 150 L106 158', l.eye, 2.4);
    d.lit('M30 140 L40 150', l.eye, 2.2);
    d.lit('M170 140 L160 150', l.eye, 2.2);
  }
  if (form >= 2) d.both(() => d.part('M42 70 L58 56 L74 62 L74 82 L56 92 L40 86 Z'));
  if (form >= 3) d.both(() => d.part('M48 62 L42 40 L60 56 Z'));
  if (form >= 5) d.both(() => d.part('M84 42 L64 10 L92 32 Z'));
  d.part('M80 40 L100 28 L120 40 L122 58 L100 68 L78 58 Z', width: 2);
  if (form >= 2) {
    // The miner's helmet and its lamp.
    d.fill('M78 42 Q100 12 122 42 Z', const Color(0xFF4A4033));
    d.stroke('M78 42 Q100 12 122 42 Z', l.edge.withValues(alpha: 0.8), 1.5);
    d.glow(100, 28, 22, l.eye, 0.65);
    d.dot(100, 28, 5, const Color(0xFFFFF6E0));
  }
  final eye = form == 1 ? 4.0 : 5.0;
  d.eye(91, 52, eye, l.eye);
  d.eye(109, 52, eye, l.eye);
  if (form >= 4) {
    d.stroke('M150 176 L182 66', const Color(0xFF5B3D22), 7);
    d.part('M154 76 Q182 52 210 80 L200 84 Q184 68 166 84 Z');
  }
}

/// Bronze Dunes: a scarab standing up. Its shell comes in, then the top
/// pair of arms and a horn, then a longer horn and a blade in each top hand;
/// the King wears a pharaoh's headdress under the sun.
void _scarab(_Draw d, int form) {
  final l = d.look;
  final canvas = d.canvas;
  if (form >= 5) {
    const nemes = 'M76 40 L124 40 L138 92 L62 92 Z';
    final headdress = d.fill(nemes, const Color(0xFF24406E));
    canvas.save();
    canvas.clipPath(headdress);
    for (var y = 44.0; y < 92; y += 9) {
      canvas.drawRect(Rect.fromLTWH(50, y, 100, 4.5), Paint()..color = l.light);
    }
    canvas.restore();
    d.stroke(nemes, l.edge.withValues(alpha: 0.8), 1.5);
    d.glow(100, 12, 22, l.eye, 0.8);
    d.dot(100, 12, 9, l.eye);
    d.ring(100, 12, 9, const Color(0xFFFFF6E0), 1.5);
  }
  // The wing cases, behind.
  if (form >= 2) {
    d.both(
      () => d.part(
        'M98 58 C56 56 34 96 42 136 C48 162 78 174 98 170 Z',
        paint: d.deep,
      ),
    );
  }
  d.both(() {
    d.stroke('M90 140 L80 162 L68 186', l.dark, 8);
    d.stroke('M68 186 L60 186', l.dark, 6);
  });
  d.both(() {
    d.stroke('M82 108 L58 126 L50 152', l.dark, 7);
    d.stroke('M50 152 L46 162', l.edge, 3);
    if (form >= 3) {
      d.stroke('M80 84 L54 94 L38 118', l.dark, 8);
      d.stroke('M38 118 L32 128', l.edge, 3);
    }
  });
  if (form >= 4) {
    d.both(() => d.part('M38 120 L30 104 Q20 78 40 64 Q36 84 46 100 L44 116 Z'));
  }
  d.part('M78 70 Q100 58 122 70 L128 118 Q100 144 72 118 Z', width: 2);
  d.stroke(
    'M76 92 Q100 102 124 92 M74 110 Q100 122 126 110',
    l.edge.withValues(alpha: 0.5),
    1.5,
  );
  d.part('M80 48 Q100 28 120 48 L116 66 Q100 74 84 66 Z', width: 2);
  d.both(() => d.part('M90 66 Q78 76 88 90 L93 86 Q88 76 96 70 Z', width: 1));
  if (form == 3) d.part('M96 40 Q93 24 101 14 Q106 26 104 40 Z');
  if (form >= 4) d.part('M95 40 Q90 16 102 0 Q109 20 105 40 Z');
  final r = form == 1 ? 5.0 : 6.5;
  for (final x in const [89.0, 111.0]) {
    d.glow(x, 52, 14, l.eye, 0.5);
    canvas.save();
    canvas.translate(x, 52);
    canvas.scale(1, 1.35);
    canvas.drawCircle(
      Offset.zero,
      r,
      Paint()
        ..shader = ui.Gradient.radial(
          Offset.zero,
          r,
          [const Color(0xFFFFF6E0), l.eye, l.eye.withValues(alpha: 0.2)],
          const [0, 0.5, 1],
        ),
    );
    canvas.restore();
  }
}

/// Silver Peaks: a yeti. Claws and fangs come in, then horns, then ice on
/// its shoulders and arms; the King wears a crown of ice and breathes frost.
void _yeti(_Draw d, int form) {
  final l = d.look;
  const left = [
    (100, 34), (86, 36), (76, 42), (70, 52), (60, 56), (54, 64), (46, 66), //
    (42, 76), (34, 82), (32, 94), (26, 104), (28, 116), (22, 128), //
    (26, 138), (20, 150), (30, 154), (34, 148), (38, 158), (46, 150), //
    (50, 156), (56, 146), (58, 158), (66, 166), (62, 186), (88, 186), //
    (92, 170), (100, 172),
  ];
  final points = [
    ...left,
    for (final (x, y) in left.sublist(1, left.length - 1).reversed) (200 - x, y),
  ];
  final fur = 'M${points.map((p) => '${p.$1} ${p.$2}').join(' L')} Z';
  d.part(fur, width: 2);
  d.both(() => d.stroke('M58 82 L56 142', const Color(0x38000000), 2.5));
  d.canvas.drawOval(
    Rect.fromCenter(center: const Offset(100, 124), width: 52, height: 64),
    Paint()..color = l.edge.withValues(alpha: 0.32),
  );
  if (form >= 2) {
    d.both(() {
      for (final (x, y) in const [(24.0, 152.0), (32.0, 156.0), (40.0, 154.0)]) {
        d.fill('M${x - 3} $y L$x ${y + 9} L${x + 3} $y Z', const Color(0xFFEAF6FF));
      }
    });
  }
  if (form >= 3) {
    d.both(() => d.stroke('M80 46 Q54 30 56 58 Q60 74 76 62', const Color(0xFFD9E4EE), 6));
  }
  if (form >= 4) {
    d.both(() {
      d.ice('M44 74 L62 64 L68 84 L50 90 Z');
      d.ice('M30 100 L44 94 L46 112 L32 116 Z');
    });
  }
  if (form >= 5) {
    for (final (x, h) in const [(82.0, 16.0), (91.0, 24.0), (100.0, 30.0), (109.0, 24.0), (118.0, 16.0)]) {
      d.crystal(x, 32 - h * 0.5, h * 0.6, l.eye, 0.7);
    }
    d.glow(100, 80, 26, l.eye, 0.45);
  }
  d.fill('M84 50 Q100 42 116 50 L114 70 Q100 80 86 70 Z', const Color(0xFF2C3440));
  d.eye(93, 58, 4.5, l.eye);
  d.eye(107, 58, 4.5, l.eye);
  d.stroke('M90 70 Q100 76 110 70', const Color(0xFF0B0D12), 3);
  if (form >= 2) d.both(() => d.fill('M93 70 L95 78 L97 71 Z', const Color(0xFFF5FAFF)));
}

/// Gold Citadel: a knight in gold plate. A shield with the crest's chevron
/// comes in, then broad shoulders and a plume, then a sword; the King wears
/// a cape and a crown and his blade burns.
void _knight(_Draw d, int form) {
  final l = d.look;
  if (form >= 5) {
    d.part(
      'M62 70 L34 186 L166 186 L138 70 Z',
      paint: Paint()
        ..shader = ui.Gradient.linear(
          const Offset(0, 70),
          const Offset(0, 190),
          const [Color(0xFF8E1D1D), Color(0xFF3E0A0A)],
        ),
      width: 1.2,
    );
  }
  d.both(() {
    d.part('M78 146 L72 186 L96 186 L98 150 Z');
    d.dot(84, 160, 6, l.light);
    d.ring(84, 160, 6, l.edge.withValues(alpha: 0.8), 1.2);
  });
  d.both(() {
    d.part('M46 88 L40 128 L54 132 L62 94 Z');
    d.part('M38 128 L54 132 L52 148 L38 146 Z');
  });
  d.part('M64 66 L136 66 L140 104 Q138 140 100 158 Q62 140 60 104 Z', width: 2.2);
  d.stroke('M100 70 L100 152 M66 108 Q100 118 134 108', l.edge.withValues(alpha: 0.55), 1.6);
  d.fill('M66 132 Q100 144 134 132 L134 140 Q100 152 66 140 Z', const Color(0xFF5A3D10));
  d.both(
    () => d.part(
      form >= 3
          ? 'M68 64 Q44 56 36 80 Q42 94 64 92 Z'
          : 'M68 64 Q54 60 50 76 Q54 86 64 86 Z',
    ),
  );
  if (form >= 2) {
    // The shield on its left arm, with the crest's chevron.
    d.part('M10 94 L52 94 L52 126 Q50 156 31 170 Q12 156 10 126 Z', width: 2);
    d.fill('M20 128 L31 116 L42 128 L42 136 L31 124 L20 136 Z', l.eye);
  }
  if (form >= 4) {
    final burning = form >= 5;
    const blade = 'M156 30 L166 30 L164 148 L158 148 Z';
    if (burning) d.glowFill(blade, l.eye, sigma: 8);
    d.fill(blade, burning ? const Color(0xFFFFF1E0) : const Color(0xFFE9EEF4));
    d.stroke(blade, burning ? l.eye : Colors.white, 1.4);
    d.part('M144 146 L178 146 L178 154 L144 154 Z', paint: Paint()..color = const Color(0xFF7A5A18), width: 1);
    d.fill('M158 154 L164 154 L164 172 L158 172 Z', const Color(0xFF3A2A10));
    if (burning) d.glow(161, 70, 26, l.eye, 0.45);
  }
  if (form >= 3) {
    d.fill('M100 22 Q122 2 140 18 Q124 16 112 28 Z', l.eye);
    d.stroke('M100 22 Q122 2 140 18 Q124 16 112 28 Z', const Color(0x80FFFFFF), 1);
  }
  d.part('M82 26 Q100 16 118 26 L122 56 L100 68 L78 56 Z', width: 2);
  d.fill('M84 42 L116 42 L114 47 L86 47 Z', const Color(0xFF140C06));
  d.lit('M88 44.5 L112 44.5', l.eye, 2.6);
  if (form >= 5) d.crown(24, width: 40);
}

/// Platinum Glacier: a hooded wraith floating over its shadow. Sleeves and
/// claws come in, then chains and ice shards circling it, then ice on its
/// shoulders; the King carries a scythe under a crown of ice.
void _wraith(_Draw d, int form) {
  final l = d.look;
  final canvas = d.canvas;
  // Lifted off its shadow, less for the King, whose crown and scythe need
  // the room above.
  final lift = form >= 5 ? 2.0 : -10.0;
  canvas.translate(0, lift);
  const around = [(36.0, 46.0), (166.0, 56.0), (26.0, 132.0), (174.0, 124.0), (52.0, 176.0), (150.0, 176.0)];
  for (final (x, y) in around.take(const [0, 0, 2, 4, 6][form - 1])) {
    d.crystal(x, y, 9, l.eye, 0.7);
  }
  if (form >= 5) {
    d.stroke('M160 22 L150 182', const Color(0xFF3B3146), 5);
    d.part('M160 24 Q120 2 92 24 Q124 22 152 44 Z', width: 1.4);
  }
  d.part(
    form == 1
        ? 'M100 30 Q78 32 72 62 L66 120 L58 150 L68 142 L74 158 L82 146 '
              'L90 162 L100 150 L110 162 L118 146 L126 158 L132 142 L142 150 '
              'L134 120 L128 62 Q122 32 100 30 Z'
        : 'M100 24 Q74 26 66 60 L56 120 L44 162 L54 152 L58 172 L66 158 '
              'L72 178 L80 162 L86 180 L92 164 L100 178 L108 164 L114 180 '
              'L120 162 L128 178 L134 158 L142 172 L146 152 L156 162 L144 120 '
              'L134 60 Q126 26 100 24 Z',
    width: 2,
  );
  d.stroke('M100 30 L100 160', const Color(0x1F000000), 2);
  if (form >= 3) d.both(() => d.stroke('M66 96 L134 128', l.edge.withValues(alpha: 0.7), 3));
  if (form >= 2) {
    d.both(() {
      d.part('M70 70 L32 104 L46 114 L74 92 Z');
      d.stroke('M36 108 L22 122 M40 111 L28 128 M45 113 L38 132', const Color(0xFFF5FAFF), 2.4);
    });
  }
  if (form >= 4) d.both(() => d.crystal(66, 62, 11, l.eye, 0.8));
  d.fill('M100 38 Q80 40 80 62 Q82 82 100 86 Q118 82 120 62 Q120 40 100 38 Z', const Color(0xFF06070B));
  final eye = form == 1 ? 4.5 : 5.5;
  d.eye(92, 62, eye, l.eye);
  d.eye(108, 62, eye, l.eye);
  if (form >= 5) {
    for (final (x, h) in const [(84.0, 12.0), (92.0, 18.0), (100.0, 24.0), (108.0, 18.0), (116.0, 12.0)]) {
      d.crystal(x, 30 - h * 0.5, h * 0.5, l.eye, 0.75);
    }
  }
  canvas.translate(0, -lift);
}

/// Diamond Caverns: a crystal dragon, hatched without wings. They grow out
/// and spread wider form by form, crystals push through its shoulders and
/// its horns lengthen; the King breathes light under a crystal crown.
void _dragon(_Draw d, int form) {
  final l = d.look;
  final canvas = d.canvas;
  if (form == 1) {
    d.both(() => d.part('M74 80 L56 66 L60 84 L52 92 L70 96 Z', paint: d.deep, width: 1.2));
  } else {
    final span = const [0.0, 0.6, 0.8, 0.95, 1.1][form - 1];
    d.both(() {
      canvas.save();
      canvas.translate(76, 74);
      canvas.scale(span);
      canvas.translate(-76, -74);
      d.part('M76 74 L18 22 L28 56 L4 62 L26 84 L8 104 L44 102 L62 118 Z', paint: d.deep, width: 1.4);
      d.stroke('M76 74 L28 56 M76 74 L26 84 M76 74 L44 102', l.edge.withValues(alpha: 0.5), 1.2);
      canvas.restore();
    });
  }
  d.stroke('M118 170 Q172 178 178 148 Q180 138 168 136', l.dark, 9);
  d.fill('M168 136 L176 124 L174 140 Z', l.edge);
  d.both(() {
    d.part('M76 140 L66 184 L96 184 L98 146 Z');
    for (final x in const [70.0, 80.0, 90.0]) {
      d.fill('M$x 184 L${x + 3} 190 L${x + 6} 184 Z', const Color(0xFFF5FFFD));
    }
  });
  d.part('M70 70 Q100 56 130 70 L138 120 Q128 160 100 168 Q72 160 62 120 Z', width: 2);
  for (var y = 96.0; y < 160; y += 12) {
    final inset = (y - 96) * 0.15;
    d.stroke('M${80 + inset} $y Q100 ${y + 5} ${120 - inset} $y', l.edge.withValues(alpha: 0.55), 1.5);
  }
  d.both(() => d.part('M68 92 L50 116 L60 124 L74 104 Z'));
  final crystals = <(double, double, double)>[
    if (form >= 2) ...const [(58.0, 68.0, 12.0), (142.0, 68.0, 12.0)],
    if (form >= 3) ...const [(50.0, 84.0, 9.0), (150.0, 84.0, 9.0)],
    if (form >= 4) ...const [(64.0, 54.0, 10.0), (136.0, 54.0, 10.0)],
  ];
  for (final (x, y, s) in crystals) {
    d.crystal(x, y, s, l.eye, 0.8);
  }
  d.both(
    () => d.part(
      form == 1 ? 'M88 32 L80 18 L94 28 Z' : 'M86 32 L68 4 L92 26 Z',
      paint: Paint()..color = l.edge.withValues(alpha: 0.9),
      width: 1.2,
    ),
  );
  d.part('M84 28 L116 28 L126 50 L116 70 L84 70 L74 50 Z', width: 2);
  d.fill('M84 56 L116 56 L116 70 L84 70 Z', l.edge.withValues(alpha: 0.25));
  d.dot(94, 63, 2.4, const Color(0xFF0B1B1A));
  d.dot(106, 63, 2.4, const Color(0xFF0B1B1A));
  d.eye(89, 44, 4.5, l.eye);
  d.eye(111, 44, 4.5, l.eye);
  d.both(() => d.fill('M82 40 L95 46 L82 48 Z', const Color(0xFFFFF6E0)));
  if (form >= 5) {
    d.glow(100, 78, 24, l.eye, 0.6);
    for (final (x, h) in const [(88.0, 12.0), (100.0, 18.0), (112.0, 12.0)]) {
      d.crystal(x, 26 - h * 0.5, h * 0.55, l.eye, 0.8);
    }
  }
}

/// Master's Throne: a horned knight in ivory and red. A glowing chevron and
/// shoulder spikes come in, then a cape and longer horns, then a greatsword
/// planted in front; the King is the Master — a crown, a blade alight and
/// embers in the air.
void _shadowKing(_Draw d, int form) {
  final l = d.look;
  if (form >= 5) {
    d.glow(100, 96, 96, l.eye, 0.32);
    for (final (x, y) in const [(30.0, 60.0), (170.0, 50.0), (24.0, 120.0), (178.0, 116.0), (44.0, 30.0), (158.0, 150.0)]) {
      d.glow(x, y, 4, l.eye, 0.9);
    }
  }
  if (form >= 3) {
    d.part(
      'M62 68 L28 186 L48 178 L60 188 L80 180 L100 190 L120 180 L140 188 '
      'L152 178 L172 186 L138 68 Z',
      paint: Paint()
        ..shader = ui.Gradient.linear(
          const Offset(0, 70),
          const Offset(0, 190),
          const [Color(0xFF6A1414), Color(0xFF1E0606)],
        ),
      width: 1.2,
    );
  }
  d.both(() => d.part('M76 146 L68 186 L96 186 L98 150 Z'));
  d.part('M64 66 L136 66 L140 104 Q138 140 100 158 Q62 140 60 104 Z', width: 2.2);
  if (form >= 2) d.glowFill('M82 108 L100 94 L118 108 L118 118 L100 104 L82 118 Z', l.eye);
  d.both(() {
    d.part('M66 64 Q40 54 32 80 Q40 94 64 92 Z');
    if (form >= 2) d.part('M44 64 L30 42 L52 58 Z');
  });
  if (form >= 4) {
    // Both hands on a greatsword planted in front, the arms down and in
    // from the shoulders to its hilt.
    final burning = form >= 5;
    const blade = 'M96 112 L104 112 L103 186 L97 186 Z';
    if (burning) d.glowFill(blade, l.eye, sigma: 7);
    d.fill(blade, const Color(0xFFF3ECE2));
    d.stroke(blade, burning ? l.eye : Colors.white, 1.2);
    d.part('M80 110 L120 110 L120 116 L80 116 Z', paint: Paint()..color = const Color(0xFF3A2F28), width: 1);
    d.fill('M97 96 L103 96 L103 110 L97 110 Z', const Color(0xFF2A1A14));
    d.both(() {
      d.part('M40 82 L60 76 L72 98 L58 104 Z');
      d.part('M58 98 L72 96 L88 96 L88 108 L66 110 Z');
    });
    d.both(() => d.part('M84 94 L98 96 L98 108 L84 108 Z'));
  } else {
    d.both(() {
      d.part('M44 90 L40 128 L54 132 L62 94 Z');
      d.part('M38 128 L54 132 L52 146 L38 144 Z');
    });
  }
  const horns = [
    'M86 32 Q76 30 74 22 Q80 26 88 28 Z',
    'M84 34 Q66 32 62 18 Q72 26 88 28 Z',
    'M84 34 Q60 30 56 12 Q70 24 88 27 Z',
    'M84 34 Q58 30 52 8 Q68 22 88 26 Z',
    'M84 34 Q50 32 42 6 Q64 20 88 26 Z',
  ];
  d.both(() => d.part(horns[form - 1]));
  d.part('M82 26 Q100 16 118 26 L122 56 L100 70 L78 56 Z', paint: Paint()..color = const Color(0xFF2A2420), width: 2);
  d.lit('M86 42 L114 42 M100 42 L100 58', l.eye, 3);
  if (form >= 5) d.crown(24, width: 42);
}

// ───────────────────────────── drawing helpers ──────────────────────────────

/// The pen the creatures are drawn with, on the 200 square: paths written
/// the way an SVG writes them, so each shape reads as its coordinates.
class _Draw {
  _Draw(this.canvas, this.look);

  final Canvas canvas;
  final WorldLook look;

  /// The world's metal, lit at the top left and dark at the bottom right.
  late final Paint metal = Paint()
    ..shader = ui.Gradient.linear(
      const Offset(40, 0),
      const Offset(150, 200),
      [look.light, look.dark],
    );

  /// The same metal in shadow: wings, shells, what stands behind.
  late final Paint deep = Paint()
    ..shader = ui.Gradient.linear(
      const Offset(40, 0),
      const Offset(150, 200),
      [look.dark, const Color(0xFF0D0D10)],
    );

  Path fill(String d, Color colour) {
    final path = _svg(d);
    canvas.drawPath(path, Paint()..color = colour);
    return path;
  }

  void stroke(String d, Color colour, double width) => canvas.drawPath(
    _svg(d),
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = colour,
  );

  /// A body part: filled (the metal unless [paint] says otherwise), shaded on
  /// its right half, and rimmed in the world's edge.
  void part(String d, {Paint? paint, double width = 1.6}) {
    final path = _svg(d);
    canvas.drawPath(path, paint ?? metal);
    canvas.save();
    canvas.clipPath(path);
    canvas.drawRect(
      const Rect.fromLTWH(100, -60, 220, 320),
      Paint()..color = const Color(0x2E000000),
    );
    canvas.restore();
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeJoin = StrokeJoin.round
        ..color = look.edge.withValues(alpha: 0.75),
    );
  }

  /// [draw] as given, then mirrored across the middle.
  void both(void Function() draw) {
    draw();
    canvas.save();
    canvas.translate(200, 0);
    canvas.scale(-1, 1);
    draw();
    canvas.restore();
  }

  void dot(double x, double y, double r, Color colour) =>
      canvas.drawCircle(Offset(x, y), r, Paint()..color = colour);

  void ring(double x, double y, double r, Color colour, double width) =>
      canvas.drawCircle(
        Offset(x, y),
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..color = colour,
      );

  void glow(double x, double y, double r, Color colour, [double alpha = 0.6]) =>
      canvas.drawCircle(
        Offset(x, y),
        r,
        Paint()
          ..shader = ui.Gradient.radial(
            Offset(x, y),
            r,
            [colour.withValues(alpha: alpha), colour.withValues(alpha: 0)],
          ),
      );

  void eye(double x, double y, double r, Color colour) {
    glow(x, y, r * 2.4, colour, 0.5);
    canvas.drawCircle(
      Offset(x, y),
      r,
      Paint()
        ..shader = ui.Gradient.radial(
          Offset(x, y),
          r,
          [const Color(0xFFFFF6E0), colour, colour.withValues(alpha: 0)],
          const [0, 0.45, 1],
        ),
    );
  }

  /// A line of light: ore in a crack, a visor's slit.
  void lit(String d, Color colour, double width) {
    final path = _svg(d);
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = colour;
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round
        ..color = colour
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );
    canvas.drawPath(path, line);
  }

  /// A shape filled with light, glowing past its edge.
  void glowFill(String d, Color colour, {double sigma = 6}) {
    final path = _svg(d);
    canvas.drawPath(path, Paint()..color = colour..maskFilter = MaskFilter.blur(BlurStyle.normal, sigma));
    canvas.drawPath(path, Paint()..color = colour);
  }

  /// A plate of ice: see-through, lit from inside.
  void ice(String d) {
    final path = _svg(d);
    canvas.drawPath(path, Paint()..color = look.eye.withValues(alpha: 0.6)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    canvas.drawPath(path, Paint()..color = look.eye.withValues(alpha: 0.55));
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = const Color(0xFFEAF6FF),
    );
  }

  void crystal(double x, double y, double s, Color colour, [double alpha = 0.8]) {
    final d = 'M$x ${y - s} L${x + s * 0.55} $y L$x ${y + s * 0.7} L${x - s * 0.55} $y Z';
    final path = _svg(d);
    canvas.drawPath(path, Paint()..color = colour.withValues(alpha: 0.7)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4));
    canvas.drawPath(path, Paint()..color = colour.withValues(alpha: alpha));
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = const Color(0xD9FFFFFF),
    );
    stroke('M$x ${y - s} L$x ${y + s * 0.7}', const Color(0x73FFFFFF), 0.8);
  }

  /// A gold crown with three red stones, its band at [y].
  void crown(double y, {double width = 44}) {
    final x0 = 100 - width / 2, x1 = 100 + width / 2;
    final d =
        'M$x0 $y L${x0 - 2} ${y - 18} L${x0 + width * 0.25} ${y - 8} '
        'L100 ${y - 24} L${x1 - width * 0.25} ${y - 8} L${x1 + 2} ${y - 18} '
        'L$x1 $y Z';
    glowFill(d, const Color(0xFFE0B145), sigma: 5);
    stroke(d, const Color(0xFFFFE8A8), 1.5);
    for (final (cx, cy) in [(x0 - 2, y - 18), (100.0, y - 24), (x1 + 2, y - 18)]) {
      dot(cx, cy, 3, const Color(0xFFFF3B3B));
    }
  }

  void crack(String d) => stroke(d, const Color(0xFF0B0A09), 2.6);
}

/// A path from SVG's absolute commands — M, L, Q, C and Z — which is all the
/// creatures above are written in.
Path _svg(String d) {
  final tokens = RegExp(r'[MLQCZ]|-?\d*\.?\d+').allMatches(d).map((m) => m[0]!).toList();
  final path = Path();
  var i = 0;
  var command = 'M';
  double next() => double.parse(tokens[i++]);
  while (i < tokens.length) {
    final token = tokens[i];
    if ('MLQCZ'.contains(token)) {
      command = token;
      i++;
      if (command == 'Z') path.close();
      continue;
    }
    switch (command) {
      case 'M':
        path.moveTo(next(), next());
        // Pairs after a move are lines, as in SVG.
        command = 'L';
      case 'L':
        path.lineTo(next(), next());
      case 'Q':
        path.quadraticBezierTo(next(), next(), next(), next());
      case 'C':
        path.cubicTo(next(), next(), next(), next(), next(), next());
      default:
        i++;
    }
  }
  return path;
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
