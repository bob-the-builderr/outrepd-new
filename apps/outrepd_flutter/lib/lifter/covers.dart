/// The moving covers over a Pro profile: nine full scenes, each with
/// something that moves (the user's picks, 2026-11-01; drawn first in the
/// mockup covers2.html, ported here line for line).
///
/// Every scene is drawn at 824 × 560 and scaled to cover the box it is given,
/// so the same scene fills a profile's top and a square tile in the picker.
library;

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// The scenes by the id saved on the account, in the picker's order.
const kCovers = [
  'neon_city',
  'iron_gym',
  'rooftop_sunset',
  'stadium_lights',
  'silver_peaks',
  'bronze_dunes',
  'volcano',
  'palm_beach',
  'winter_city',
];

/// Whether [cover] is one of the scenes rather than a photo's URL.
bool isScene(String? cover) => cover != null && kCovers.contains(cover);

/// A scene, moving. Still where the phone asks for less motion, or when
/// [moving] is false.
class CoverScene extends StatefulWidget {
  const CoverScene(this.id, {super.key, this.moving = true});

  final String id;
  final bool moving;

  @override
  State<CoverScene> createState() => _CoverSceneState();
}

class _CoverSceneState extends State<CoverScene> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final _t = ValueNotifier<double>(1);
  Duration _last = Duration.zero;

  @override
  void initState() {
    super.initState();
    // Thirty pictures a second is all a background needs.
    _ticker = createTicker((elapsed) {
      if (elapsed - _last < const Duration(milliseconds: 33)) return;
      _last = elapsed;
      _t.value = 1 + elapsed.inMicroseconds / 1e6;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _run();
  }

  @override
  void didUpdateWidget(CoverScene old) {
    super.didUpdateWidget(old);
    _run();
  }

  void _run() {
    final still = !widget.moving || (MediaQuery.maybeDisableAnimationsOf(context) ?? false);
    if (still) {
      if (_ticker.isActive) _ticker.stop();
    } else if (!_ticker.isActive) {
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _t.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox.expand(
    child: CustomPaint(painter: CoverPainter(widget.id, _t)),
  );
}

/// Paints the scene [id] at the time [t] holds, in seconds.
class CoverPainter extends CustomPainter {
  CoverPainter(this.id, this.t) : super(repaint: t);

  final String id;
  final ValueListenable<double> t;

  static const width = 824.0;
  static const height = 560.0;

  @override
  void paint(Canvas canvas, Size size) {
    final scene = _scenes[id];
    if (scene == null) return;
    final scale = math.max(size.width / width, size.height / height);
    canvas
      ..save()
      ..clipRect(Offset.zero & size)
      ..translate((size.width - width * scale) / 2, (size.height - height * scale) / 2)
      ..scale(scale);
    scene(canvas, width, height, t.value);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CoverPainter old) => old.id != id || old.t != t;
}

typedef _Scene = void Function(Canvas g, double w, double h, double t);

const _scenes = <String, _Scene>{
  'neon_city': _neonCity,
  'iron_gym': _ironGym,
  'rooftop_sunset': _rooftopSunset,
  'stadium_lights': _stadiumLights,
  'silver_peaks': _silverPeaks,
  'bronze_dunes': _bronzeDunes,
  'volcano': _volcano,
  'palm_beach': _palmBeach,
  'winter_city': _winterCity,
};

// ── pieces ───────────────────────────────────────────────────────────────────

/// The mockup's generator, so every scene comes out the same.
class _Rnd {
  _Rnd(this._s);
  int _s;

  double call() {
    _s = (_s * 1664525 + 1013904223) % 4294967296;
    return _s / 4294967296;
  }
}

Paint _fill(Color c) => Paint()..color = c;

Color _rgba(int r, int g, int b, double a) => Color.fromRGBO(r, g, b, a.clamp(0.0, 1.0));

Paint _down(double y0, double y1, List<(double, Color)> stops) => Paint()
  ..shader = ui.Gradient.linear(
    Offset(0, y0),
    Offset(0, y1),
    [for (final s in stops) s.$2],
    [for (final s in stops) s.$1],
  );

Paint _glow(Offset c, double radius, List<(double, Color)> stops) => Paint()
  ..shader = ui.Gradient.radial(
    c,
    radius,
    [for (final s in stops) s.$2],
    [for (final s in stops) s.$1],
  );

Rect _oval(double cx, double cy, double rx, double ry) =>
    Rect.fromCenter(center: Offset(cx, cy), width: rx * 2, height: ry * 2);

/// A ridge: jagged peaks above [base].
void _range(Canvas g, double w, double base, double amp, Color col, int seed, [double step = 60]) {
  final r = _Rnd(seed);
  final p = Path()..moveTo(0, 600);
  var x = -20.0;
  p.lineTo(x, base);
  while (x < w + 40) {
    x += step * (0.6 + r() * 0.8);
    p.lineTo(x, base - amp * (0.3 + r() * 0.7));
    x += step * (0.4 + r() * 0.6);
    p.lineTo(x, base - amp * r() * 0.3);
  }
  p
    ..lineTo(w + 40, 600)
    ..close();
  g.drawPath(p, _fill(col));
}

void _dunes(Canvas g, double w, double base, double amp, Color col, double phase) {
  final p = Path()
    ..moveTo(0, 600)
    ..lineTo(0, base);
  for (var x = 0.0; x <= w; x += 8) {
    p.lineTo(x, base - math.sin(x / 140 + phase) * amp - math.sin(x / 61 + phase * 2) * amp * 0.25);
  }
  p
    ..lineTo(w, 600)
    ..close();
  g.drawPath(p, _fill(col));
}

List<Rect> _skyline(
  Canvas g,
  double w,
  double base,
  int seed,
  Color col,
  double minH,
  double maxH,
  bool windows,
  double t, [
  List<Color> winCols = const [Color(0xFFFFD27A)],
]) {
  final r = _Rnd(seed);
  final out = <Rect>[];
  final paint = _fill(col);
  for (var x = -10.0; x < w + 10;) {
    final bw = 34 + r() * 64, bh = minH + r() * (maxH - minH);
    g.drawRect(Rect.fromLTWH(x, base - bh, bw, bh + 200), paint);
    if (r() > 0.6) g.drawRect(Rect.fromLTWH(x + bw * 0.4, base - bh - 18, 4, 18), paint);
    out.add(Rect.fromLTWH(x, base - bh, bw, bh));
    x += bw + 2 + r() * 6;
  }
  if (windows) {
    final r2 = _Rnd(seed + 99);
    for (final b in out) {
      for (var wy = b.top + 10; wy < base - 8; wy += 18) {
        for (var wx = b.left + 6; wx < b.right - 8; wx += 13) {
          final lit = r2() > 0.62 && math.sin(t * 1.3 + r2() * 30) > -0.6;
          if (lit) {
            final c = winCols[(r2() * winCols.length).floor()];
            g.drawRect(Rect.fromLTWH(wx, wy, 6, 8), _fill(c.withValues(alpha: 0.85)));
          }
        }
      }
    }
  }
  return out;
}

void _stars(Canvas g, double w, double h, int n, int seed, double t, [double maxY = 1]) {
  final r = _Rnd(seed);
  for (var k = 0; k < n; k++) {
    final x = r() * w, y = r() * h * maxY, s = r() * 1.6 + 0.4;
    g.drawCircle(Offset(x, y), s, _fill(_rgba(255, 255, 255, 0.35 + 0.65 * math.sin(t * 1.2 + k * 2.3).abs())));
  }
}

void _palm(Canvas g, double x, double base, double s, double sway, Color col) {
  final trunk = Paint()
    ..color = col
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 14 * s;
  g.drawPath(
    Path()
      ..moveTo(x, base)
      ..quadraticBezierTo(x + 30 * s, base - 160 * s, x + 16 * s + sway * 6, base - 300 * s),
    trunk,
  );
  final tx = x + 16 * s + sway * 6, ty = base - 300 * s;
  final leaf = _fill(col);
  for (var k = 0; k < 7; k++) {
    final a = -math.pi + k * (math.pi / 6) + sway * 0.05;
    final len = 120 * s * (k == 0 || k == 6 ? 0.8 : 1);
    final mx = tx + math.cos(a) * len * 0.5, my = ty + math.sin(a) * len * 0.3 - 20 * s;
    final ex = tx + math.cos(a) * len, ey = ty + math.sin(a) * len * 0.55 + 40 * s;
    g.drawPath(
      Path()
        ..moveTo(tx, ty)
        ..quadraticBezierTo(mx, my, ex, ey)
        ..quadraticBezierTo(mx, my + 14 * s, tx, ty),
      leaf,
    );
  }
}

/// [paint] with a soft light of [colour] behind it, [blur] wide.
void _lit(Canvas g, Color colour, double blur, void Function(Paint) draw, Paint paint) {
  draw(Paint()
    ..color = colour
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur / 2));
  draw(paint);
}

// ── the scenes ───────────────────────────────────────────────────────────────

/// Windows flicker.
void _neonCity(Canvas g, double w, double h, double t) {
  g.drawRect(Rect.fromLTWH(0, 0, w, h), _down(0, h, const [(0, Color(0xFF1A0633)), (1, Color(0xFFC2357F))]));
  g.drawCircle(Offset(w * 0.72, h * 0.42), h * 0.16, _fill(const Color(0xFFFFB13D).withValues(alpha: 0.9)));
  final r = _Rnd(4);
  final dark = _fill(const Color(0xFF12061F));
  final buildings = <Rect>[];
  for (var x = 0.0; x < w;) {
    final bw = 40 + r() * 70, bh = h * (0.3 + r() * 0.45);
    final b = Rect.fromLTWH(x, h - bh, bw, bh);
    buildings.add(b);
    g.drawRect(b, dark);
    x += bw + 4;
  }
  final r2 = _Rnd(9);
  for (final b in buildings) {
    for (var wy = b.top + 12; wy < h - 10; wy += 22) {
      for (var wx = b.left + 8; wx < b.right - 8; wx += 16) {
        final on = math.sin(t * 2 + r2() * 40) > 0.2;
        if (r2() > 0.45 && on) {
          g.drawRect(
            Rect.fromLTWH(wx, wy, 7, 9),
            _fill(r2() > 0.5 ? const Color(0xFF4DF2FF) : const Color(0xFFFF79C6)),
          );
        }
      }
    }
  }
}

/// The lamps swing.
void _ironGym(Canvas g, double w, double h, double t) {
  g.drawRect(Rect.fromLTWH(0, 0, w, h), _down(0, h, const [(0, Color(0xFF0E1A1F)), (1, Color(0xFF06090B))]));
  // Tall windows at the back, the city behind them.
  for (var k = 0; k < 4; k++) {
    final x = 70.0 + k * 180, y = 60.0, ww = 140.0, wh = 300.0;
    final pane = Rect.fromLTWH(x, y, ww, wh);
    g.drawRect(pane, _down(y, y + wh, const [(0, Color(0xFF1C3B57)), (1, Color(0xFF2C5470))]));
    g
      ..save()
      ..clipRect(pane);
    _skyline(g, w, y + wh, 30 + k, const Color(0xFF0F2234), 60, 170, true, t, const [Color(0xFFFFD27A), Color(0xFF7AD7FF)]);
    g.restore();
    final frame = Paint()
      ..color = const Color(0xFF05080A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    g.drawRect(pane, frame);
    frame.strokeWidth = 4;
    g
      ..drawLine(Offset(x + ww / 2, y), Offset(x + ww / 2, y + wh), frame)
      ..drawLine(Offset(x, y + wh / 2), Offset(x + ww, y + wh / 2), frame);
  }
  // Pendant lamps and their light.
  for (final x0 in const [140.0, 412.0, 684.0]) {
    final a = math.sin(t * 1.4 + x0) * 0.08;
    final lx = x0 + math.sin(a) * 90, ly = 10 + math.cos(a) * 90;
    g.drawLine(Offset(x0, 0), Offset(lx, ly), Paint()
      ..color = const Color(0xFF000000)
      ..strokeWidth = 2);
    g.drawPath(
      Path()
        ..moveTo(lx - 14, ly + 10)
        ..lineTo(lx + 14, ly + 10)
        ..lineTo(lx + 150 + a * 300, h)
        ..lineTo(lx - 150 + a * 300, h)
        ..close(),
      _down(ly, h, [(0, _rgba(255, 214, 140, 0.45)), (1, _rgba(255, 214, 140, 0))]),
    );
    g.drawPath(
      Path()
        ..moveTo(lx - 22, ly + 12)
        ..lineTo(lx + 22, ly + 12)
        ..lineTo(lx + 10, ly - 4)
        ..lineTo(lx - 10, ly - 4)
        ..close(),
      _fill(const Color(0xFF11181C)),
    );
    g.drawOval(_oval(lx, ly + 12, 14, 4), _fill(const Color(0xFFFFE3A8)));
  }
  // Racks with loaded bars, either side; the floor.
  final black = _fill(const Color(0xFF05080A));
  g.drawRect(Rect.fromLTWH(0, h - 70, w, 70), black);
  for (final (x, flip) in [(40.0, 1.0), (w - 40, -1.0)]) {
    g
      ..drawRect(Rect.fromLTWH(x - 6, h - 330, 12, 260), black)
      ..drawRect(Rect.fromLTWH(x + flip * 110 - 6, h - 330, 12, 260), black)
      ..drawRect(Rect.fromLTWH(math.min(x, x + flip * 110) - 30, h - 250, 170, 8), black);
    for (final px in [x - flip * 18, x + flip * 128]) {
      final plate = _oval(px, h - 246, 10, 46);
      g
        ..drawOval(plate, _fill(const Color(0xFF0A0F12)))
        ..drawOval(plate, Paint()
          ..color = const Color(0xFF2A3A42)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2);
    }
  }
}

/// Birds pass.
void _rooftopSunset(Canvas g, double w, double h, double t) {
  final all = Rect.fromLTWH(0, 0, w, h);
  g
    ..drawRect(all, _down(0, h, const [(0, Color(0xFF2B1055)), (0.45, Color(0xFFD53369)), (0.75, Color(0xFFFF8E53)), (1, Color(0xFFFFC371))]))
    ..drawRect(all, _glow(Offset(w * 0.3, h * 0.66), 240, [
      (0, _rgba(255, 240, 180, 1)),
      (0.25, _rgba(255, 200, 120, 0.9)),
      (1, _rgba(255, 160, 90, 0)),
    ]));
  for (var k = 0; k < 4; k++) {
    final cx = ((k * 260 + t * 14) % (w + 300)) - 150, cy = 90.0 + k * 34;
    g.drawPath(
      Path()
        ..addOval(_oval(cx, cy, 130, 16))
        ..addOval(_oval(cx + 60, cy - 8, 80, 14)),
      _fill(_rgba(255, 190, 170, 0.22 + k * 0.05)),
    );
  }
  _skyline(g, w, h - 70, 12, const Color(0xFF5B2245), 80, 220, false, t);
  _skyline(g, w, h - 40, 13, const Color(0xFF3A1530), 40, 150, false, t);
  // The roof: a ledge, a water tower, an antenna.
  final roof = _fill(const Color(0xFF1A0B17));
  g
    ..drawRect(Rect.fromLTWH(0, h - 60, w, 60), roof)
    ..drawRect(Rect.fromLTWH(w - 190, h - 230, 110, 120), roof)
    ..drawPath(
      Path()
        ..moveTo(w - 200, h - 230)
        ..lineTo(w - 135, h - 280)
        ..lineTo(w - 70, h - 230)
        ..close(),
      roof,
    )
    ..drawRect(Rect.fromLTWH(w - 180, h - 112, 8, 52), roof)
    ..drawRect(Rect.fromLTWH(w - 98, h - 112, 8, 52), roof)
    ..drawRect(Rect.fromLTWH(70, h - 270, 6, 210), roof)
    ..drawRect(Rect.fromLTWH(50, h - 230, 46, 4), roof)
    ..drawRect(Rect.fromLTWH(56, h - 200, 34, 4), roof);
  final wing = Paint()
    ..color = const Color(0xFF1A0B17)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;
  for (var k = 0; k < 6; k++) {
    final bx = ((k * 140 + t * 60) % (w + 200)) - 100;
    final by = 150 + math.sin(k * 3.0) * 40 + math.sin(t * 2 + k) * 6;
    final f = math.sin(t * 8 + k) * 5;
    g.drawPath(
      Path()
        ..moveTo(bx - 12, by - f)
        ..quadraticBezierTo(bx - 5, by - 2, bx, by + 2)
        ..quadraticBezierTo(bx + 5, by - 2, bx + 12, by - f),
      wing,
    );
  }
}

/// Beams sweep.
void _stadiumLights(Canvas g, double w, double h, double t) {
  g.drawRect(Rect.fromLTWH(0, 0, w, h), _down(0, h, const [(0, Color(0xFF050B1F)), (1, Color(0xFF13265A))]));
  _stars(g, w, h, 50, 3, t, 0.5);
  for (final (x, k) in const [(90.0, 0), (300.0, 1), (524.0, 2), (734.0, 3)]) {
    final a = math.sin(t * 0.8 + k * 1.3) * 0.35 + (k < 2 ? 0.25 : -0.25);
    const by = 190.0;
    final beam = Paint()
      ..shader = ui.Gradient.linear(
        Offset(x, by),
        Offset(x + math.sin(a) * 500, 0),
        [_rgba(220, 235, 255, 0.55), _rgba(220, 235, 255, 0)],
      );
    g.drawPath(
      Path()
        ..moveTo(x - 10, by)
        ..lineTo(x + 10, by)
        ..lineTo(x + math.sin(a) * 600 + 90, by - math.cos(a) * 600)
        ..lineTo(x + math.sin(a) * 600 - 90, by - math.cos(a) * 600)
        ..close(),
      beam,
    );
  }
  // The bowl and its rows of people, phones lit.
  g.drawPath(
    Path()
      ..moveTo(0, h)
      ..lineTo(0, 300)
      ..quadraticBezierTo(w / 2, 220, w, 300)
      ..lineTo(w, h)
      ..close(),
    _fill(const Color(0xFF0A1330)),
  );
  final r = _Rnd(6);
  final crowd = _fill(const Color(0xFF060C22)), phone = _fill(const Color(0xFFFFFFFF));
  for (var row = 0; row < 7; row++) {
    final y = 300.0 + row * 36;
    for (var x = 10.0; x < w; x += 14) {
      final yy = y - math.sin((x / w) * math.pi) * (70 - row * 8);
      g.drawCircle(Offset(x + r() * 4, yy), 6, crowd);
      if (r() > 0.93 && math.sin(t * 3 + x) > 0) g.drawRect(Rect.fromLTWH(x + 3, yy - 10, 3, 3), phone);
    }
  }
  for (final x in const [90.0, 300.0, 524.0, 734.0]) {
    g.drawRect(Rect.fromLTWH(x - 4, 190, 8, 140), _fill(const Color(0xFF0A1330)));
    final lamp = Rect.fromLTWH(x - 26, 176, 52, 18);
    _lit(g, const Color(0xFFBFD9FF), 24, (p) => g.drawRect(lamp, p), _fill(const Color(0xFFEAF2FF)));
  }
}

/// Mist drifts.
void _silverPeaks(Canvas g, double w, double h, double t) {
  final all = Rect.fromLTWH(0, 0, w, h);
  g.drawRect(all, _down(0, h, const [(0, Color(0xFF0B1D3A)), (0.55, Color(0xFF5B6FA8)), (0.8, Color(0xFFF2A07B)), (1, Color(0xFFFFD6A5))]));
  _stars(g, w, h, 40, 11, t, 0.35);
  g.drawRect(all, _glow(Offset(w * 0.62, h * 0.72), 200, [
    (0, _rgba(255, 244, 214, 1)),
    (0.2, _rgba(255, 220, 170, 0.8)),
    (1, _rgba(255, 200, 150, 0)),
  ]));
  _range(g, w, 420, 240, const Color(0xFF6A76A8), 21, 70);
  _range(g, w, 470, 200, const Color(0xFF3E4A7C), 22, 60);
  for (var k = 0; k < 3; k++) {
    g.drawOval(_oval(((k * 330 + t * 18) % (w + 400)) - 200, 430.0 + k * 24, 220, 18), _fill(_rgba(255, 255, 255, 0.16)));
  }
  _range(g, w, 530, 160, const Color(0xFF1F2648), 23, 55);
  _range(g, w, 585, 100, const Color(0xFF0B0F22), 24, 50);
}

/// Stars fall.
void _bronzeDunes(Canvas g, double w, double h, double t) {
  g.drawRect(Rect.fromLTWH(0, 0, w, h), _down(0, h, const [(0, Color(0xFF0A0F2C)), (0.7, Color(0xFF3B2A5C)), (1, Color(0xFFA2614A))]));
  _stars(g, w, h, 110, 14, t, 0.7);
  final p = (t % 4) / 4;
  if (p < 0.35) {
    final q = p / 0.35, sx = w * 0.15 + q * 340, sy = 50 + q * 120;
    g.drawLine(
      Offset(sx - 120, sy - 60),
      Offset(sx, sy),
      Paint()
        ..strokeWidth = 3
        ..shader = ui.Gradient.linear(
          Offset(sx - 120, sy - 60),
          Offset(sx, sy),
          [_rgba(255, 255, 255, 0), _rgba(255, 255, 255, 0.9)],
        ),
    );
  }
  final moon = Offset(w * 0.78, 130);
  g.drawCircle(moon, 110, _glow(moon, 110, [
    (0, _rgba(255, 240, 215, 1)),
    (0.55, _rgba(255, 230, 200, 1)),
    (0.6, _rgba(255, 220, 190, 0.25)),
    (1, _rgba(255, 220, 190, 0)),
  ]));
  final crater = _fill(_rgba(200, 180, 160, 0.35));
  for (final (x, y, r) in [(w * 0.76, 112.0, 12.0), (w * 0.8, 150.0, 8.0), (w * 0.75, 152.0, 6.0)]) {
    g.drawCircle(Offset(x, y), r, crater);
  }
  _dunes(g, w, 400, 46, const Color(0xFFC08457), 0.5);
  _dunes(g, w, 455, 38, const Color(0xFF9A5F3D), 2.1);
  _dunes(g, w, 510, 30, const Color(0xFF6B3B25), 4.0);
  _dunes(g, w, 555, 20, const Color(0xFF3A1F14), 5.2);
}

/// Embers rise.
void _volcano(Canvas g, double w, double h, double t) {
  final all = Rect.fromLTWH(0, 0, w, h);
  g.drawRect(all, _down(0, h, const [(0, Color(0xFF0D0405)), (0.6, Color(0xFF3A0A0A)), (1, Color(0xFF8A1F0B))]));
  for (var k = 0; k < 5; k++) {
    g.drawOval(_oval(((k * 210 + t * 8) % (w + 300)) - 120, 80.0 + k * 26, 170, 40), _fill(_rgba(60, 30, 30, 0.35 + k * 0.08)));
  }
  final flick = 0.85 + 0.15 * math.sin(t * 6);
  g.drawRect(all, _glow(Offset(w * 0.66, 250), 300, [(0, _rgba(255, 140, 40, 0.75 * flick)), (1, _rgba(255, 90, 20, 0))]));
  g.drawPath(
    Path()
      ..moveTo(w * 0.25, h)
      ..lineTo(w * 0.58, 250)
      ..lineTo(w * 0.74, 250)
      ..lineTo(w * 1.05, h)
      ..close(),
    _fill(const Color(0xFF140507)),
  );
  final lava = Path()
    ..moveTo(w * 0.62, 252)
    ..lineTo(w * 0.6, 330)
    ..lineTo(w * 0.64, 410)
    ..lineTo(w * 0.6, 520)
    ..moveTo(w * 0.7, 252)
    ..lineTo(w * 0.73, 350)
    ..lineTo(w * 0.79, 470);
  Paint flow(Color c) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = 6;
  g
    ..drawPath(lava, flow(const Color(0xFFFF7A1A))..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9))
    ..drawPath(lava, flow(_rgba(255, 122, 26, flick)))
    ..drawOval(_oval(w * 0.66, 252, 66, 8), _fill(const Color(0xFFFFB13D)));
  _range(g, w, 560, 160, const Color(0xFF0A0304), 31, 70);
  final r = _Rnd(2);
  for (var k = 0; k < 50; k++) {
    final sp = 40 + r() * 80;
    final x = w * 0.5 + r() * w * 0.4 + math.sin(t * 2 + k) * 14;
    final y = 260 - ((r() * 300 + t * sp) % 300);
    final s = 1.5 + r() * 2.5;
    final green = (120 + r() * 100).floor();
    g.drawCircle(Offset(x, y), s, _fill(_rgba(255, green, 40, 0.6 + r() * 0.4)));
  }
}

/// Waves shimmer.
void _palmBeach(Canvas g, double w, double h, double t) {
  g.drawRect(Rect.fromLTWH(0, 0, w, 380), _down(0, 380, const [(0, Color(0xFF120A3A)), (0.6, Color(0xFF6A1B6E)), (1, Color(0xFFFF6A88))]));
  _stars(g, w, 380, 40, 8, t, 0.6);
  final moon = Offset(w * 0.74, 250);
  _lit(g, const Color(0xFFFFB3C7), 40, (p) => g.drawCircle(moon, 62, p), _fill(const Color(0xFFFFE7C7)));
  g.drawRect(Rect.fromLTWH(0, 380, w, h - 380), _down(380, h, const [(0, Color(0xFF3A1150)), (1, Color(0xFF0B0620))]));
  for (var k = 0; k < 16; k++) {
    final y = 392.0 + k * 11, wdt = 120 - k * 5 + math.sin(t * 3 + k) * 18;
    g.drawRect(
      Rect.fromLTWH(w * 0.74 - wdt / 2 + math.sin(t * 2 + k * 1.7) * 8, y, wdt, 3),
      _fill(_rgba(255, 220, 190, 0.55 - k * 0.03)),
    );
  }
  final sparkle = _fill(_rgba(255, 255, 255, 0.12));
  for (var k = 0; k < 12; k++) {
    g.drawRect(Rect.fromLTWH((k * 97 + t * 30) % w, 420.0 + (k % 4) * 30, 40, 2), sparkle);
  }
  final sw = math.sin(t * 1.2);
  const ink = Color(0xFF07031A);
  _palm(g, 60, h, 1.15, sw, ink);
  _palm(g, 170, h + 30, 0.8, -sw, ink);
  _palm(g, w - 80, h, 1.25, -sw * 0.8, ink);
  g.drawOval(_oval(w / 2, h + 30, w * 0.7, 60), _fill(ink));
}

/// Snow falls.
void _winterCity(Canvas g, double w, double h, double t) {
  g.drawRect(Rect.fromLTWH(0, 0, w, h), _down(0, h, const [(0, Color(0xFF0A1430)), (1, Color(0xFF3A4D7A))]));
  final moon = Offset(w * 0.2, 110);
  g.drawCircle(moon, 90, _glow(moon, 90, [
    (0, _rgba(240, 246, 255, 1)),
    (0.5, _rgba(240, 246, 255, 1)),
    (0.55, _rgba(200, 220, 255, 0.2)),
    (1, _rgba(200, 220, 255, 0)),
  ]));
  _skyline(g, w, h - 60, 41, const Color(0xFF1C2747), 120, 300, true, t, const [Color(0xFFFFD27A), Color(0xFFFFB86B)]);
  // Snow on every roof: the same buildings, walked again.
  final r0 = _Rnd(41);
  final snow = _fill(const Color(0xFFEAF2FF));
  for (var x = -10.0; x < w + 10;) {
    final bw = 34 + r0() * 64, bh = 120 + r0() * 180;
    g.drawRect(Rect.fromLTWH(x, h - 60 - bh - 2, bw, 5), snow);
    r0();
    x += bw + 2 + r0() * 6;
  }
  g.drawRect(Rect.fromLTWH(0, h - 60, w, 60), snow);
  final r = _Rnd(5);
  for (var k = 0; k < 120; k++) {
    final sp = 20 + r() * 40;
    final x = (r() * w + math.sin(t + k) * 20) % w;
    final y = (r() * h + t * sp) % h;
    final s = 1 + r() * 2.6;
    g.drawCircle(Offset(x, y), s, _fill(_rgba(255, 255, 255, 0.6 + r() * 0.4)));
  }
}
