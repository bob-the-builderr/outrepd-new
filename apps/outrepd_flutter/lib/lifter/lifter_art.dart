/// The lifter drawn as SVG, in the comic-ink style the user picked (style A,
/// 2026-11-01): thick ink outlines, a hard cel shadow on the right, a bold
/// flat background. 200 × 200 units; every part is an original drawing.
///
/// Built as a string so one drawing serves everything: [SvgPicture] on
/// screen, and the PNG uploaded as the account's picture so boards, older
/// builds and the website show the same lifter.
library;

import 'dart:math' as math;

import 'catalog.dart';

const _ink = '#16120F';
const _coral = '#FF8466';

/// How much of the lifter to draw.
enum LifterView {
  /// Background and lifter: a picture.
  full,

  /// The lifter alone: for a head that breaks out of its circle.
  noBackground,

  /// The background alone: a profile's cover.
  backgroundOnly,

  /// The head, close: for the face tabs of the maker.
  head,
}

/// The SVG of [l]. The same lifter always gives the same string, so a
/// drawing can be cached by it.
String lifterSvg(Lifter l, {LifterView view = LifterView.full}) {
  final sk = l.skinPart;
  final skin = sk.color!;
  final hc = sk.fx == 'cyborg' ? '#5c6f7d' : kHairColors[l.hairColor];
  final tc = kTopColors[l.topColor];
  final gearId = kGear[l.gear].id;
  final b = StringBuffer();
  if (view == LifterView.backgroundOnly) {
    b.write(_background(l.background, l.pattern));
    return _svg(b.toString(), view);
  }
  if (view != LifterView.noBackground) b.write(_background(l.background, l.pattern));
  final h = _hair(l.hair, hc);
  b
    ..write(_top(l.top, tc, skin))
    ..write(_cel('neck', _P.neck, _shade(skin, -0.06)))
    ..write(_inkLine(_P.neckLines))
    // A collar that wraps the neck sits in front of it.
    ..write(_topOver(l.top, tc))
    ..write(h.back)
    ..write(_cel('earL', _P.earL, skin))
    ..write(_cel('earR', _P.earR, skin))
    ..write(_cel('head', _P.head, skin))
    ..write(_skinFx(sk.fx))
    ..write(_inkLine(_P.jaw, w: 2.4, o: 0.6))
    ..write(_marks(l.marks))
    ..write(_brows(l.brows, hc))
    ..write(_eyes(l.eyes, sk))
    ..write(_inkLine('M100 82 L95 98 C98 101 103 101 106 98', w: 2.4, o: 1));
  if (gearId != 'face_mask') b..write(_mouth(l.mouth))..write(_beard(l.beard, hc));
  // Under a hat only hair that hangs below it is drawn.
  final hairId = kHair[l.hair].id;
  if (!l.wearsHat || hairId == 'long' || hairId == 'dreads') b.write(h.front);
  b.write(_gear(l.gear));
  return _svg(b.toString(), view);
}

String _svg(String body, LifterView view) {
  final vb = view == LifterView.head ? '30 -6 140 140' : '0 0 200 200';
  return '<svg viewBox="$vb" xmlns="http://www.w3.org/2000/svg">$body</svg>';
}

// ── helpers ──────────────────────────────────────────────────────────────────

/// A number as SVG wants it: short, no exponent.
String _n(num v) {
  if (v == v.roundToDouble()) return v.round().toString();
  return v.toStringAsFixed(2);
}

/// Lighter (f > 0) or darker (f < 0) by a fraction.
String _shade(String hex, double f) {
  final n = int.parse(hex.substring(1), radix: 16);
  final c = [n >> 16, (n >> 8) & 255, n & 255].map((v) {
    final out = f < 0 ? v * (1 + f) : v + (255 - v) * f;
    return out.round().clamp(0, 255);
  });
  return '#${c.map((v) => v.toRadixString(16).padLeft(2, '0')).join()}';
}

/// Dark print on a light garment, light print on a dark one.
String _onCloth(String hex) {
  final n = int.parse(hex.substring(1), radix: 16);
  final l = 0.299 * (n >> 16) + 0.587 * ((n >> 8) & 255) + 0.114 * (n & 255);
  return l > 150 ? '#141312' : '#F5EFE4';
}

/// A shape with a hard shadow on its right and an ink outline: the base of
/// the style. The shadow is the shape itself, darker, with the lit colour
/// drawn over it nudged up and left, clipped to the shape.
String _cel(String key, String d, String fill, {double dark = -0.28, double w = 3.4, String inner = ''}) =>
    '<defs><clipPath id="c$key"><path d="$d"/></clipPath></defs>'
    '<g clip-path="url(#c$key)"><path d="$d" fill="${_shade(fill, dark)}"/>'
    '<path d="$d" fill="$fill" transform="translate(-9 -6)"/>$inner</g>'
    '<path d="$d" fill="none" stroke="$_ink" stroke-width="${_n(w)}" stroke-linejoin="round"/>';

String _inkLine(String d, {double w = 2.6, double o = 0.75, String col = _ink}) =>
    '<path d="$d" fill="none" stroke="$col" stroke-width="${_n(w)}" stroke-linecap="round" '
    'stroke-linejoin="round" opacity="${_n(o)}"/>';

String _dot(num x, num y, num r, String fill, {double w = 2.4}) =>
    '<circle cx="${_n(x)}" cy="${_n(y)}" r="${_n(r)}" fill="$fill" stroke="$_ink" stroke-width="${_n(w)}"/>';

String _flat(String d, String fill, [double o = 1]) => '<path d="$d" fill="$fill" opacity="${_n(o)}"/>';

/// Text drawn twice: an ink outline under the fill.
String _text(num x, num y, String s, num size, String fill, {double stroke = 2}) =>
    '<text x="${_n(x)}" y="${_n(y)}" text-anchor="middle" font-family="Arial" font-weight="900" '
    'font-size="${_n(size)}" fill="none" stroke="$_ink" stroke-width="${_n(stroke * 2)}" stroke-linejoin="round">$s</text>'
    '<text x="${_n(x)}" y="${_n(y)}" text-anchor="middle" font-family="Arial" font-weight="900" '
    'font-size="${_n(size)}" fill="$fill">$s</text>';

// ── shapes ───────────────────────────────────────────────────────────────────

abstract final class _P {
  static const body = 'M-12 200 L-12 176 C-8 154 14 142 40 138 C56 136 70 128 79 116 L121 116 C130 128 144 136 160 138 C186 142 208 154 212 176 L212 200 Z';
  static const neck = 'M77 92 L75 124 C86 134 114 134 125 124 L123 92 Z';
  static const head = 'M65 66 C65 40 81 28 100 28 C119 28 135 40 135 66 L135 84 C135 99 127 109 115 115 L106 119 C102 120 98 120 94 119 L85 115 C73 109 65 99 65 84 Z';
  static const earL = 'M66 72 C56 70 55 90 66 92 Z';
  static const earR = 'M134 72 C144 70 145 90 134 92 Z';
  static const delts = 'M44 150 C36 162 34 182 38 200 M156 150 C164 162 166 182 162 200';
  static const pecs = 'M100 160 L100 200 M58 182 C76 194 94 192 100 182 M142 182 C124 194 106 192 100 182';
  static const traps = 'M80 118 C72 128 58 134 42 139 M120 118 C128 128 142 134 158 139 M70 140 C80 146 92 148 100 148 M130 140 C120 146 108 148 100 148';
  static const neckLines = 'M84 100 L95 126 M116 100 L105 126';
  static const jaw = 'M72 94 C76 104 80 108 86 110 M128 94 C124 104 120 108 114 110 M92 120 C96 122 104 122 108 120';
  static const sleeveL = 'M-12 200 L-12 176 C-8 154 14 142 40 138 L52 150 C46 168 44 184 44 200 Z';
  static const sleeveR = 'M212 200 L212 176 C208 154 186 142 160 138 L148 150 C154 168 156 184 156 200 Z';
  static const shoulderL = 'M-12 200 L-12 176 C-8 154 14 142 40 138 C56 136 70 128 79 116 L82 122 C76 140 66 160 62 200 Z';
  static const shoulderR = 'M212 200 L212 176 C208 154 186 142 160 138 C144 136 130 128 121 116 L118 122 C124 140 134 160 138 200 Z';
  static const rib = 'M74 114 C86 128 114 128 126 114 L128 124 C114 138 86 138 72 124 Z';
  static const hood = 'M56 134 C60 108 80 98 100 98 C120 98 140 108 144 134 C126 126 112 124 100 124 C88 124 74 126 56 134 Z';
  static const vNeck = 'M80 118 L100 146 L120 118 L114 118 L100 136 L86 118 Z';
  static const buzz = 'M66 64 C64 40 80 30 100 30 C120 30 136 40 134 64 C128 48 116 42 100 42 C84 42 72 48 66 64 Z';
  static const crew = 'M64 64 C62 38 80 26 100 26 C120 26 138 38 136 64 C130 50 118 44 100 46 C82 44 70 50 64 64 Z';
  static const chain = 'M64 132 C70 168 130 168 136 132';
  static const phones = 'M66 128 C64 146 136 146 134 128 C130 140 70 140 66 128 Z';
  static const cupL = 'M54 120 C46 120 44 138 54 140 C62 140 66 122 54 120 Z';
  static const cupR = 'M146 120 C154 120 156 138 146 140 C138 140 134 122 146 120 Z';
}

// ── hair ─────────────────────────────────────────────────────────────────────

class _Hair {
  const _Hair({this.f = '', this.b, this.faint = false, this.sides, this.lines, this.lineCol = _ink, this.lineOp = 0.5, this.curls, this.twists, this.bun = false, this.strands = false});
  final String f;
  final String? b;
  final bool faint;
  final String? sides;
  final String? lines;
  final String lineCol;
  final double lineOp;
  final List<(num, num)>? curls;
  final List<(num, num)>? twists;
  final bool bun;
  final bool strands;
}

const _hairs = <int, _Hair>{
  1: _Hair(f: _P.buzz, faint: true),
  2: _Hair(f: _P.crew),
  3: _Hair(f: 'M64 66 L64 28 L136 28 L136 66 C130 54 118 48 100 48 C82 48 70 54 64 66 Z'),
  4: _Hair(f: 'M68 58 C66 32 82 18 100 18 C118 18 134 32 132 58 C124 48 114 44 100 44 C86 44 76 48 68 58 Z', curls: [(80, 30), (92, 23), (105, 22), (118, 27), (127, 37), (86, 38), (100, 33), (114, 36), (72, 42)]),
  5: _Hair(b: 'M48 76 C38 30 70 4 100 4 C130 4 162 30 152 76 C146 58 134 48 118 46 L82 46 C66 48 54 58 48 76 Z', f: 'M66 62 C68 50 80 44 100 44 C120 44 132 50 134 62 C128 54 116 50 100 50 C84 50 72 54 66 62 Z'),
  6: _Hair(f: 'M90 46 L88 8 L100 0 L112 8 L110 46 C106 44 94 44 90 46 Z', sides: 'M66 66 C64 48 70 40 78 38 L80 50 C72 54 68 58 66 66 Z M134 66 C136 48 130 40 122 38 L120 50 C128 54 132 58 134 66 Z'),
  7: _Hair(f: 'M64 64 L58 34 L74 40 L72 18 L88 30 L96 6 L106 28 L120 12 L124 34 L142 30 L136 64 C128 50 116 44 100 44 C84 44 72 50 64 64 Z'),
  8: _Hair(f: 'M64 64 C60 34 78 20 100 20 C124 20 140 34 136 64 C132 50 124 40 112 38 C104 42 92 42 84 38 C74 42 68 50 64 64 Z', lines: 'M80 30 C90 26 110 26 122 32 M76 38 C90 32 112 32 128 40'),
  9: _Hair(f: 'M64 64 C62 38 80 28 100 28 C120 28 138 38 136 64 C128 50 116 44 100 44 C84 44 72 50 64 64 Z', bun: true),
  10: _Hair(strands: true, f: 'M64 62 C62 36 80 26 100 26 C120 26 138 36 136 62 C128 50 116 44 100 44 C84 44 72 50 64 62 Z'),
  11: _Hair(f: 'M64 66 C60 34 80 22 102 22 C124 22 140 36 136 66 C134 52 128 44 118 40 C104 46 84 44 74 40 C68 46 66 54 64 66 Z', lines: 'M112 24 C114 30 116 36 118 40'),
  12: _Hair(b: 'M56 124 C48 70 60 22 100 22 C140 22 152 70 144 124 L130 124 C134 92 132 62 120 50 L80 50 C68 62 66 92 70 124 Z', f: 'M64 64 C62 36 80 24 100 24 C120 24 138 36 136 64 C130 48 118 40 100 40 C82 40 70 48 64 64 Z'),
  13: _Hair(f: 'M70 54 C66 28 88 14 110 18 C130 22 140 36 134 54 C122 40 104 38 90 44 C82 48 74 50 70 54 Z', sides: 'M66 66 C64 54 66 48 70 54 C72 58 68 62 66 66 Z M134 66 C136 54 136 50 134 54 C132 58 132 62 134 66 Z', lines: 'M86 26 C100 22 118 26 128 34'),
  14: _Hair(f: _P.crew, lines: 'M72 44 C78 40 84 48 90 44 C96 40 102 48 108 44 C114 40 120 48 126 44 M70 54 C76 50 82 58 88 54 C94 50 100 58 106 54 C112 50 118 58 124 54 C128 52 130 54 132 56 M78 34 C84 30 90 38 96 34 C102 30 108 38 114 34 C118 32 120 32 122 34', lineCol: '#fff', lineOp: 0.35),
  15: _Hair(f: _P.crew, lines: 'M74 56 L80 32 M84 50 L88 28 M94 48 L96 27 M106 48 L104 27 M116 50 L112 28 M126 56 L120 32', lineCol: '#fff', lineOp: 0.45),
  16: _Hair(f: 'M64 62 C60 40 70 22 90 14 C112 6 136 16 138 34 C138 46 134 56 136 62 C128 50 116 46 100 46 C84 46 72 52 64 62 Z', lines: 'M84 20 C100 14 122 16 132 30 M80 30 C96 24 116 26 128 38'),
  17: _Hair(f: 'M72 56 L80 26 L90 36 L96 8 L104 32 L112 12 L118 36 L126 28 L130 56 C120 46 82 46 72 56 Z', sides: _P.buzz),
  18: _Hair(f: _P.crew, twists: [(78, 22), (88, 16), (100, 13), (112, 16), (122, 22), (70, 32), (130, 32)]),
  19: _Hair(f: 'M62 64 C58 44 66 26 82 22 C90 14 106 14 114 20 C130 20 142 34 138 52 L142 58 L132 56 C124 46 112 42 100 44 L96 36 L90 46 C80 46 70 52 62 64 Z'),
};

({String back, String front}) _hair(int i, String hc) {
  final h = _hairs[i];
  final back = StringBuffer(), front = StringBuffer();
  if (h != null) {
    if (h.b != null) back.write(_cel('hb', h.b!, hc));
    if (h.strands) {
      for (final x in [62, 70, 130, 138]) {
        final x2 = x < 100 ? x - 4 : x + 4;
        back.write('<path d="M$x 50 L$x2 122" stroke="$_ink" stroke-width="11" stroke-linecap="round"/>'
            '<path d="M$x 50 L$x2 122" stroke="$hc" stroke-width="6.5" stroke-linecap="round"/>');
      }
    }
    if (h.sides != null) front.write(_flat(h.sides!, hc, 0.5));
    front.write(h.faint ? _flat(h.f, hc, 0.6) : _cel('hf', h.f, hc));
    for (final (x, y) in h.curls ?? const <(num, num)>[]) {
      front.write(_dot(x, y, 6.5, hc));
    }
    for (final (x, y) in h.twists ?? const <(num, num)>[]) {
      front.write('<rect x="${_n(x - 4)}" y="${_n(y - 8)}" width="8" height="18" rx="4" fill="$hc" stroke="$_ink" stroke-width="2.2"/>');
    }
    if (h.lines != null) front.write(_inkLine(h.lines!, w: 2, o: h.lineOp, col: h.lineCol));
    if (h.bun) front.write(_dot(100, 20, 11, hc, w: 3));
  }
  if (i == 0) front.write(_inkLine('M84 40 C92 34 106 34 112 38', w: 4.5, o: 0.55, col: '#fff'));
  return (back: back.toString(), front: front.toString());
}

String _beard(int i, String hc) => switch (i) {
  1 => _flat('M68 88 C70 104 82 116 100 118 C118 116 130 104 132 88 C128 100 118 108 100 108 C82 108 72 100 68 88 Z', hc, 0.45),
  2 => _cel('bd', 'M66 80 C66 108 80 126 100 128 C120 126 134 108 134 80 C130 96 122 104 112 104 C106 100 94 100 88 104 C78 104 70 96 66 80 Z', hc),
  3 => _cel('bd', 'M91 114 C95 112 105 112 109 114 L107 126 C104 129 96 129 93 126 Z', hc, w: 2.6),
  4 => _cel('bd', 'M82 101 C90 95 110 95 118 101 C110 99 106 101 100 100 C94 101 90 99 82 101 Z', hc, w: 2.4),
  5 => _cel('bd', 'M66 80 C66 108 80 124 100 126 C120 124 134 108 134 80 L130 82 C130 104 118 118 100 120 C82 118 70 104 70 82 Z', hc, w: 2.4),
  6 => _cel('bd', 'M66 82 C66 116 82 150 100 158 C118 150 134 116 134 82 C130 98 122 106 112 106 C106 102 94 102 88 106 C78 106 70 98 66 82 Z', hc) + _inkLine('M92 130 L96 150 M108 130 L104 150', w: 2, o: 0.5),
  7 => _cel('bd', 'M66 74 C66 98 72 110 84 114 L86 100 C78 96 72 88 72 74 Z', hc, w: 2.4) + _cel('bd2', 'M134 74 C134 98 128 110 116 114 L114 100 C122 96 128 88 128 74 Z', hc, w: 2.4),
  8 => _cel('bd', 'M70 92 C70 108 80 122 100 124 C120 122 130 108 130 92 C126 102 118 106 112 104 C106 100 94 100 88 104 C82 106 74 102 70 92 Z', hc, w: 2.6),
  9 => _cel('bd', 'M82 101 C90 95 110 95 118 101 C110 99 106 101 100 100 C94 101 90 99 82 101 Z', hc, w: 2.2) + _cel('bd2', 'M88 116 C94 114 106 114 112 116 L104 130 L100 134 L96 130 Z', hc, w: 2.4),
  10 => _cel('bd', 'M78 108 C74 104 76 96 84 98 C92 96 108 96 116 98 C124 96 126 104 122 108 C118 102 108 100 100 101 C92 100 82 102 78 108 Z', hc, w: 2.4),
  11 => _cel('bd', 'M96 113 L104 113 L102 120 L98 120 Z', hc, w: 2),
  _ => '',
};

// ── the face ─────────────────────────────────────────────────────────────────

String _eyes(int i, LifterPart sk) {
  const white = '<path d="M77 82 C80 77 93 77 96 82 C92 86 81 86 77 82 Z M123 82 C120 77 107 77 104 82 C108 86 119 86 123 82 Z" fill="#fff" stroke="$_ink" stroke-width="2.2"/>';
  final glow = switch (sk.fx) {
    'cyborg' => '#FF3B3B',
    'lava' => '#FF8A3D',
    'crystal' => '#E8FFFC',
    'shadow' => '#B26BFF',
    _ => null,
  };
  String pupils([num r = 3.4, num dx = 0]) {
    final col = glow ?? '#1a1410';
    return '<circle cx="${_n(88 + dx)}" cy="82" r="${_n(r)}" fill="$col"/><circle cx="${_n(112 + dx)}" cy="82" r="${_n(r)}" fill="$col"/>';
  }

  final lids = _inkLine('M76 79 L96 80 M124 79 L104 80', w: 2.6, o: 1);
  String star(num x) => '<path d="M${_n(x)} 76 L${_n(x + 2)} 80 L${_n(x + 6)} 80.5 L${_n(x + 3)} 83.5 L${_n(x + 4)} 88 L${_n(x)} 85.5 L${_n(x - 4)} 88 L${_n(x - 3)} 83.5 L${_n(x - 6)} 80.5 L${_n(x - 2)} 80 Z" fill="#F2C14E" stroke="$_ink" stroke-width="1.2"/>';
  return switch (i) {
    1 => white + pupils(2.6) + _inkLine('M76 77 L96 82 M124 77 L104 82', w: 3, o: 1),
    2 => '$white${pupils()}<path d="M76 81 C82 78 92 78 96 81 L96 79 C90 76 82 76 76 79 Z M124 81 C118 78 108 78 104 81 L104 79 C110 76 118 76 124 79 Z" fill="${sk.color}"/>${_inkLine('M76 81 L96 81 M124 81 L104 81', w: 2.4, o: 1)}',
    3 => '<path d="M76 82 C80 75 93 75 97 82 C92 88 81 88 76 82 Z M124 82 C120 75 107 75 103 82 C108 88 119 88 124 82 Z" fill="#fff" stroke="$_ink" stroke-width="2.2"/>${pupils(2.4)}',
    4 => '${_inkLine('M77 82 C82 78 92 78 96 82', w: 2.8, o: 1)}<path d="M123 82 C120 77 107 77 104 82 C108 86 119 86 123 82 Z" fill="#fff" stroke="$_ink" stroke-width="2.2"/><circle cx="112" cy="82" r="3.4" fill="#1a1410"/>${_inkLine('M124 79 L104 80', w: 2.6, o: 1)}',
    5 => _inkLine('M77 81 C82 85 92 85 96 81 M123 81 C118 85 108 85 104 81', w: 2.8, o: 1),
    6 => white + pupils(3.2, 4) + lids,
    7 => '<path d="M77 82 C82 80 91 80 96 82 C91 84 82 84 77 82 Z M123 82 C118 80 109 80 104 82 C109 84 118 84 123 82 Z" fill="#1a1410" stroke="$_ink" stroke-width="2.2"/>${_inkLine('M75 79 L97 81 M125 79 L103 81', w: 2.8, o: 1)}',
    8 => '$white${pupils(3)}<path d="M76 82 C82 78 92 78 97 82 L97 77 L76 77 Z M124 82 C118 78 108 78 103 82 L103 77 L124 77 Z" fill="${_shade(sk.color!, -0.08)}" stroke="$_ink" stroke-width="2.2"/>',
    9 => '$white<circle cx="88" cy="82" r="3.8" fill="#FF8A1E"/><circle cx="112" cy="82" r="3.8" fill="#FF8A1E"/>'
        '<path d="M80 76 C82 66 86 70 88 62 C90 70 94 66 96 76 Z M104 76 C106 66 110 70 112 62 C114 70 118 66 120 76 Z" fill="#FF8A1E" stroke="$_ink" stroke-width="2"/>$lids',
    10 => white + star(88) + star(112) + lids,
    11 => '$white<path d="M88 82 L-10 96 L-10 104 Z M112 82 L210 96 L210 104 Z" fill="#FF2E2E" opacity=".85"/>'
        '<circle cx="88" cy="82" r="4" fill="#FF2E2E" stroke="#fff" stroke-width="1.5"/><circle cx="112" cy="82" r="4" fill="#FF2E2E" stroke="#fff" stroke-width="1.5"/>$lids',
    12 => '$white<circle cx="88" cy="82" r="6" fill="#B26BFF" opacity=".35"/><circle cx="112" cy="82" r="6" fill="#B26BFF" opacity=".35"/>'
        '<circle cx="88" cy="82" r="3.4" fill="#D9A8FF"/><circle cx="112" cy="82" r="3.4" fill="#D9A8FF"/>'
        '<circle cx="89" cy="81" r="1.2" fill="#fff"/><circle cx="113" cy="81" r="1.2" fill="#fff"/>$lids',
    _ => white + pupils() + lids,
  };
}

String _brows(int i, String hc) {
  const shapes = [
    'M74 66 L96 72 L96 78 L75 73 Z M126 66 L104 72 L104 78 L125 73 Z',
    'M76 70 L96 73 L96 75 L76 72 Z M124 70 L104 73 L104 75 L124 72 Z',
    'M74 62 C82 58 90 60 96 66 L96 71 C90 66 82 64 75 67 Z M126 66 L104 72 L104 78 L125 73 Z',
    'M74 66 L83 68.5 L82 74 L75 73 Z M86 69.5 L96 72 L96 78 L86 75.5 Z M126 66 L104 72 L104 78 L125 73 Z',
    'M74 70 C80 62 90 62 96 68 L96 72 C90 67 81 67 75 73 Z M126 70 C120 62 110 62 104 68 L104 72 C110 67 119 67 125 73 Z',
    'M72 68 C78 60 92 62 98 70 L97 79 C90 72 80 72 73 75 Z M128 68 C122 60 108 62 102 70 L103 79 C110 72 120 72 127 75 Z',
    'M74 66 L80 67.6 L79 73.4 L75 73 Z M83 68.4 L88 69.8 L87.5 75 L82 74 Z M91 70.6 L96 72 L96 78 L90.5 76 Z M126 66 L104 72 L104 78 L125 73 Z',
  ];
  return '<path d="${shapes[i]}" fill="${_shade(hc, -0.1)}" stroke="$_ink" stroke-width="2.2" stroke-linejoin="round"/>';
}

String _mouth(int i) {
  String teeth([String cap = '']) {
    final b = StringBuffer('<path d="M86 104 L114 104 L112 111 L88 111 Z" fill="#fff" stroke="$_ink" stroke-width="2.4" stroke-linejoin="round"/>');
    if (cap == 'gold') b.write('<rect x="100" y="104" width="7" height="7" fill="#F2C14E"/>');
    if (cap == 'grill') {
      b.write('<path d="M87 104 L113 104 L111.5 111 L88.5 111 Z" fill="#DDE6F0"/>');
      for (final x in [90, 96, 102, 108]) {
        b.write('<path d="M$x 105 L${x + 2} 107.5 L$x 110 L${x - 2} 107.5 Z" fill="#7FE3FF"/>');
      }
    }
    b.write(_inkLine('M93 104 L93 111 M100 104 L100 111 M107 104 L107 111', w: 1.4, o: 1));
    return b.toString();
  }

  return switch (i) {
    1 => teeth(),
    2 => '<path d="M86 102 C92 112 108 112 114 102 Z" fill="#fff" stroke="$_ink" stroke-width="2.6" stroke-linejoin="round"/>${_inkLine('M88 105 L112 105', w: 1.4, o: 1)}',
    3 => '<path d="M86 100 L114 100 L110 116 C104 120 96 120 90 116 Z" fill="#3a1410" stroke="$_ink" stroke-width="2.6" stroke-linejoin="round"/><path d="M88 100 L112 100 L111 104 L89 104 Z" fill="#fff"/><path d="M93 116 C96 112 104 112 107 116" fill="#C2452D"/>',
    4 => '<path d="M85 103 L115 103 L113 112 L87 112 Z" fill="#2F6FD6" stroke="$_ink" stroke-width="2.4" stroke-linejoin="round"/>${_inkLine('M88 107 L112 107', w: 1.6, o: 0.6, col: '#fff')}',
    5 => _inkLine('M90 107 L111 107', w: 3, o: 1),
    6 => '${_inkLine('M88 106 C96 109 106 109 112 105', w: 2.8, o: 1)}<path d="M96 107 C96 117 106 117 106 107 Z" fill="#E86A7A" stroke="$_ink" stroke-width="2.2"/>',
    7 => '<ellipse cx="100" cy="108" rx="8" ry="7" fill="#3a1410" stroke="$_ink" stroke-width="2.6"/><path d="M94 104 L106 104 L105 106 L95 106 Z" fill="#fff"/>',
    8 => '<path d="M84 104 C90 101 110 101 116 104 L114 111 C108 113 92 113 86 111 Z" fill="#fff" stroke="$_ink" stroke-width="2.4" stroke-linejoin="round"/>${_inkLine('M86 107.5 L114 107.5', w: 1.4, o: 1)}',
    9 => '${_inkLine('M88 104 C96 107 106 107 112 104', w: 2.6, o: 1)}<path d="M93 105 L107 105 L106 109 L94 109 Z" fill="#fff" stroke="$_ink" stroke-width="1.6"/>',
    10 => teeth('gold'),
    11 => teeth('grill'),
    _ => _inkLine('M88 106 C96 110 106 109 113 103', w: 2.8, o: 1),
  };
}

String _marks(int i) => switch (i) {
  1 => _inkLine('M118 90 L128 104', w: 2.6, o: 0.9, col: '#f4e7d8') + _inkLine('M118 90 L128 104', w: 0.8, o: 0.9),
  2 => _flat('M76 88 L94 88 L93 93 L77 93 Z M106 88 L124 88 L123 93 L107 93 Z', '#141210', 0.95),
  3 => _flat('M72 90 L90 92 L72 95 Z M72 97 L88 98 L72 101 Z M128 90 L110 92 L128 95 Z M128 97 L112 98 L128 101 Z', '#C2452D', 0.95),
  4 => [(80, 92), (84, 95), (77, 96), (120, 92), (116, 95), (123, 96), (96, 92), (104, 92)]
      .map((p) => '<circle cx="${p.$1}" cy="${p.$2}" r="1.3" fill="#7a3b1e" opacity=".75"/>')
      .join(),
  5 => _inkLine('M126 70 C130 74 128 80 132 84 M128 76 L134 74', w: 2, o: 0.85),
  6 => '<path d="M90 90 L110 90 L109 95 L91 95 Z" fill="#F4EDE0" stroke="$_ink" stroke-width="2"/>${_inkLine('M95 90 L95 95 M100 90 L100 95 M105 90 L105 95', w: 1, o: 0.5)}',
  7 => [(70, 56), (132, 62), (128, 98)]
      .map((p) {
        final (x, y) = p;
        return '<path d="M$x $y C${x - 4} ${y + 6} ${x - 3} ${y + 10} $x ${y + 10} C${x + 3} ${y + 10} ${x + 4} ${y + 6} $x $y Z" fill="#9FD8F5" stroke="$_ink" stroke-width="1.6"/>';
      })
      .join(),
  8 => '<rect x="114" y="92" width="16" height="9" rx="2" transform="rotate(-18 122 96)" fill="#F4EDE0" stroke="$_ink" stroke-width="2"/>${_inkLine('M116 95 L128 92 M117 99 L129 96', w: 1, o: 0.4)}',
  9 => '<circle cx="104" cy="99" r="3" fill="none" stroke="#C9CED6" stroke-width="1.8"/>',
  10 => _dot(122, 68, 1.8, '#C9CED6', w: 1) + _dot(124, 74, 1.8, '#C9CED6', w: 1),
  _ => '',
};

String _skinFx(String? fx) {
  switch (fx) {
    case 'stone':
      return _inkLine('M84 46 L92 58 L88 66 M118 92 L110 100 L114 108 M74 90 L80 96 M150 160 L160 172 L156 184 M40 160 L48 170', w: 2, o: 0.7);
    case 'metal':
      return _inkLine('M80 40 C86 34 96 32 104 34', w: 5, o: 0.7, col: '#fff') + _inkLine('M30 152 C40 146 52 144 60 146', w: 5, o: 0.55, col: '#fff');
    case 'ice':
      return _inkLine('M80 40 C86 34 96 32 104 34', w: 5, o: 0.8, col: '#fff') + _inkLine('M72 56 L80 60 L76 66 M124 100 L130 104 M40 160 L48 156 L46 166', w: 2, o: 0.6, col: '#5aa9c8');
    case 'crystal':
      return _inkLine('M100 28 L88 66 L100 119 L112 66 Z M65 66 L88 66 M135 66 L112 66', w: 1.6, o: 0.45, col: '#0b5e57') + _inkLine('M82 40 L94 34', w: 5, o: 0.7, col: '#fff');
    case 'lava':
      return _inkLine('M84 46 L92 58 L88 66 M118 92 L110 100 L114 108 M74 90 L80 96 M150 160 L160 172 L156 184 M40 160 L48 170 M100 140 L96 156', w: 3, o: 1, col: '#FF7A1A') +
          _inkLine('M84 46 L92 58 L88 66 M150 160 L160 172', w: 1.2, o: 1, col: '#FFE08A');
    case 'cyborg':
      return _inkLine('M100 28 L100 60 M70 66 L86 66 L92 72 M135 70 L120 70', w: 2.2, o: 0.9, col: '#5c6f7d') + _dot(126, 60, 3, '#FF3B3B', w: 1.4) +
          _inkLine('M40 156 L60 156 L64 162', w: 2, o: 0.8, col: '#5c6f7d');
    case 'holo':
      final b = StringBuffer();
      const cols = ['#FF7AB6', '#7AD7FF', '#B6FF7A', '#FFE07A'];
      for (var k = 0; k < cols.length; k++) {
        b.write(_inkLine('M${66 + k * 4} ${40 + k * 14} L134 ${30 + k * 14}', w: 6, o: 0.35, col: cols[k]));
      }
      return '$b${_inkLine('M82 40 L94 34', w: 4, o: 0.7, col: '#fff')}';
    case 'neon':
      return _inkLine('M66 66 C66 40 82 28 100 28 C118 28 134 40 134 66 L134 84 C134 99 126 109 114 115 L100 120 L86 115 C74 109 66 99 66 84 Z', w: 2.6, o: 1, col: '#4DF2FF') +
          _inkLine('M20 150 C40 140 60 136 78 120 M180 150 C160 140 140 136 122 120 M100 150 L100 200', w: 2.4, o: 0.9, col: '#FF4FD8');
    case 'obsidian':
      return _inkLine('M78 40 C88 32 100 30 108 32', w: 6, o: 0.55, col: '#B26BFF') + _inkLine('M24 156 C40 146 56 144 66 146', w: 6, o: 0.4, col: '#B26BFF') +
          _inkLine('M118 70 L124 90', w: 3, o: 0.35, col: '#fff');
    case 'cosmic':
      final r = LifterRandom(9), b = StringBuffer();
      for (var k = 0; k < 26; k++) {
        b.write('<circle cx="${_n(70 + r.next() * 60)}" cy="${_n(36 + r.next() * 76)}" r="${_n(r.next() * 1.3 + 0.4)}" fill="#fff" opacity="${_n(0.5 + r.next() * 0.5)}"/>');
      }
      for (var k = 0; k < 30; k++) {
        b.write('<circle cx="${_n(r.next() * 200)}" cy="${_n(140 + r.next() * 60)}" r="${_n(r.next() * 1.3 + 0.4)}" fill="#fff" opacity="${_n(0.5 + r.next() * 0.5)}"/>');
      }
      return '$b${_inkLine('M74 50 C90 44 110 46 126 56', w: 8, o: 0.25, col: '#F06292')}';
    case 'electric':
      return _inkLine('M84 40 L90 52 L84 60 L92 72 M118 88 L112 98 L118 104 L112 114 M40 156 L50 164 L44 172 L54 182 M160 150 L152 160 L160 168', w: 2.2, o: 1, col: '#E8F6FF') +
          _inkLine('M84 40 L90 52 L84 60 L92 72 M40 156 L50 164 L44 172 L54 182', w: 5, o: 0.25, col: '#9FE3FF');
    case 'shadow':
      return _inkLine('M66 66 C66 40 82 28 100 28 C118 28 134 40 134 66', w: 2.4, o: 0.9, col: '#B26BFF') +
          _inkLine('M20 150 C40 140 60 136 78 120 M180 150 C160 140 140 136 122 120', w: 2.4, o: 0.8, col: '#B26BFF');
    default:
      return '';
  }
}

// ── backgrounds ──────────────────────────────────────────────────────────────

String _background(int colour, int pattern) {
  final bg = kBackgroundColors[colour];
  final light = _shade(bg, 0.35), dark = _shade(bg, -0.18);
  String base(String fill) => '<rect x="-20" y="-20" width="240" height="240" fill="$fill"/>';
  String ray(num cx, num cy, num len, double a, double width) =>
      '<path d="M${_n(cx)} ${_n(cy)} L${_n(cx + len * math.cos(a))} ${_n(cy + len * math.sin(a))} '
      'L${_n(cx + len * math.cos(a + width))} ${_n(cy + len * math.sin(a + width))} Z"/>';
  final b = StringBuffer();
  switch (kPatterns[pattern].id) {
    case 'rays':
      b.write('${base(bg)}<g opacity=".18" fill="#fff">');
      for (var k = 0; k < 8; k++) {
        b.write(ray(100, 120, 260, k * 0.785, 0.3));
      }
      b.write('</g>');
    case 'halftone':
      b.write('${base(bg)}<g fill="$light" opacity=".55">');
      for (var y = 6; y < 200; y += 12) {
        for (var x = 12; x < 200; x += 12) {
          b.write('<circle cx="$x" cy="$y" r="${_n(1.2 + (200 - y) / 90)}"/>');
        }
      }
      b.write('</g>');
    case 'stripes':
      b.write('${base(bg)}<g stroke="$light" stroke-width="10" opacity=".4">');
      for (var x = -200; x <= 160; x += 40) {
        b.write('<path d="M$x 200 L${x + 200} 0"/>');
      }
      b.write('</g>');
    case 'grid':
      b.write('${base(bg)}<g stroke="$light" stroke-width="1.2" opacity=".45">');
      for (var v = 20; v < 200; v += 20) {
        b.write('<path d="M$v -10 L$v 210 M-10 $v L210 $v"/>');
      }
      b.write('</g>');
    case 'checkers':
      b.write('${base(bg)}<g fill="$dark" opacity=".5">');
      for (var j = 0; j < 10; j++) {
        for (var i = 0; i < 10; i++) {
          if ((i + j).isEven) b.write('<rect x="${-20 + i * 25}" y="${-20 + j * 25}" width="25" height="25"/>');
        }
      }
      b.write('</g>');
    case 'zigzag':
      b.write('${base(bg)}<g stroke="$light" stroke-width="6" fill="none" opacity=".45">');
      for (final y in [10, 50, 90, 130, 170]) {
        b.write('<path d="M-10 $y ${List.generate(12, (k) => 'L${k * 20} ${y + (k.isOdd ? 12 : 0)}').join(' ')}"/>');
      }
      b.write('</g>');
    case 'barbells':
      b.write('${base(bg)}<g fill="$dark" opacity=".55">');
      for (final (x, y) in [(30, 30), (150, 40), (40, 120), (170, 110), (100, 10)]) {
        b.write('<g transform="translate($x $y) rotate(-20)"><rect x="-22" y="-2" width="44" height="4" rx="2"/>'
            '<rect x="-26" y="-9" width="6" height="18" rx="2"/><rect x="20" y="-9" width="6" height="18" rx="2"/></g>');
      }
      b.write('</g>');
    case 'skyline':
      b.write('${base(bg)}<g fill="$dark">');
      for (final (x, y, w) in [(0, 120, 26), (26, 100, 20), (46, 130, 24), (70, 90, 22), (92, 112, 18), (110, 80, 26), (136, 118, 22), (158, 96, 20), (178, 126, 26)]) {
        b.write('<rect x="$x" y="$y" width="$w" height="${200 - y}"/>');
      }
      b.write('</g><g fill="$light" opacity=".7">');
      for (final (x, y) in [(30, 106), (76, 98), (116, 90), (116, 102), (162, 104), (52, 138)]) {
        b.write('<rect x="$x" y="$y" width="4" height="5"/>');
      }
      b.write('</g>');
    case 'spotlight':
      b.write('${base(bg)}<path d="M70 -20 L130 -20 L190 210 L10 210 Z" fill="#fff" opacity=".18"/><ellipse cx="100" cy="196" rx="90" ry="14" fill="#fff" opacity=".18"/>');
    case 'flames':
      b.write('${base('#2A0E08')}<g stroke="$_ink" stroke-width="2.5">');
      for (final (x, c) in [(20, '#FF7A1A'), (60, '#FFB13D'), (100, '#FF7A1A'), (140, '#FFB13D'), (180, '#FF7A1A')]) {
        b.write('<path d="M${x - 26} 210 C${x - 30} 160 ${x - 6} 150 ${x - 10} 110 C${x + 10} 130 ${x + 20} 100 ${x + 12} 70 C${x + 36} 110 ${x + 34} 160 ${x + 26} 210 Z" fill="$c"/>');
      }
      b.write('</g>');
    case 'lightning':
      b.write(base('#1B1640'));
      for (final (x, y) in [(30, 0), (150, 10), (90, 40)]) {
        b.write('<path d="M$x $y L${x - 14} ${y + 40} L${x + 2} ${y + 40} L${x - 10} ${y + 80} L${x + 22} ${y + 30} L${x + 6} ${y + 30} L${x + 16} $y" fill="#FFE04A" stroke="$_ink" stroke-width="2.4" stroke-linejoin="round"/>');
      }
    case 'gold_burst':
      b.write('${base('#7A4A00')}<g fill="#F2C14E">');
      for (var k = 0; k < 16; k++) {
        b.write(ray(100, 110, 280, k * 0.3927, 0.18));
      }
      b.write('</g><circle cx="100" cy="110" r="70" fill="#FFE08A" opacity=".35"/>');
    case 'galaxy':
      b.write('<defs><radialGradient id="gx" cx="30%" cy="30%" r="80%"><stop offset="0" stop-color="#7B3FC4"/>'
          '<stop offset=".55" stop-color="#2A1B5C"/><stop offset="1" stop-color="#0B0920"/></radialGradient></defs>'
          '${base('url(#gx)')}<ellipse cx="60" cy="60" rx="70" ry="22" transform="rotate(-25 60 60)" fill="#F06292" opacity=".25"/>');
      final r = LifterRandom(5);
      for (var k = 0; k < 60; k++) {
        b.write('<circle cx="${_n(r.next() * 200)}" cy="${_n(r.next() * 200)}" r="${_n(r.next() * 1.6 + 0.4)}" fill="#fff" opacity="${_n(0.5 + r.next() * 0.5)}"/>');
      }
    case 'aurora':
      b.write('${base('#071526')}<path d="M-20 40 C40 10 90 70 140 30 C170 6 200 20 220 10 L220 80 C180 90 150 60 110 90 C70 120 30 70 -20 100 Z" fill="#2EE6A8" opacity=".55"/>'
          '<path d="M-20 70 C50 40 100 110 160 60 C190 36 210 50 220 40 L220 110 C170 130 130 90 90 120 C50 150 20 110 -20 130 Z" fill="#8B5CF6" opacity=".45"/>');
      for (var k = 0; k < 30; k++) {
        b.write('<circle cx="${(k * 53) % 200}" cy="${(k * 37) % 120}" r="${k % 3 == 0 ? '1.4' : '0.8'}" fill="#fff" opacity=".8"/>');
      }
    case 'neon_city':
      b.write('<defs><linearGradient id="nc" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#2A0B4A"/><stop offset="1" stop-color="#FF4FD8"/></linearGradient></defs>'
          '${base('url(#nc)')}<circle cx="150" cy="60" r="26" fill="#FFB13D" opacity=".85"/><g fill="#120826">');
      for (final (x, y, w) in [(0, 110, 24), (24, 90, 22), (46, 120, 20), (66, 80, 26), (92, 104, 18), (110, 70, 28), (138, 112, 22), (160, 92, 20), (180, 118, 30)]) {
        b.write('<rect x="$x" y="$y" width="$w" height="${220 - y}"/>');
      }
      b.write('</g><g fill="#4DF2FF">');
      for (final (x, y) in [(30, 100), (74, 92), (118, 80), (118, 96), (166, 102), (52, 132), (96, 116), (186, 130)]) {
        b.write('<rect x="$x" y="$y" width="4" height="5"/>');
      }
      b.write('</g>');
    case 'holo_foil':
      b.write('<defs><linearGradient id="hf" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#7AD7FF"/><stop offset=".25" stop-color="#C9A8FF"/>'
          '<stop offset=".5" stop-color="#FF9FD6"/><stop offset=".75" stop-color="#FFE59F"/><stop offset="1" stop-color="#9FFFD8"/></linearGradient></defs>'
          '${base('url(#hf)')}<g stroke="#fff" stroke-width="14" opacity=".22">');
      for (var x = -120; x <= 180; x += 60) {
        b.write('<path d="M$x 220 L${x + 220} 0"/>');
      }
      b.write('</g>');
    case 'smoke':
      b.write(base('#151517'));
      for (final (x, y, r) in [(40, 170, 70), (160, 160, 80), (100, 40, 60), (20, 60, 50), (180, 40, 50)]) {
        b.write('<circle cx="$x" cy="$y" r="$r" fill="#8C8C99" opacity=".18"/><circle cx="${x + 12}" cy="${y - 10}" r="${_n(r * 0.6)}" fill="#B9B9C6" opacity=".12"/>');
      }
    default: // plain
      b.write(base(bg));
  }
  return b.toString();
}

// ── clothes ──────────────────────────────────────────────────────────────────
//
// Round two (the user's OK, 2026-11-01): the part of a garment the picture
// shows — collar, shoulders, the top of the chest — drawn so each reads on
// its own: its own collar, closure and texture, fabric folds and a
// highlight. No words, no logos on any of them.

/// A line in [col]; the order the clothes are written in.
String _line(String d, String col, [double w = 2.2, double o = 0.8]) => _inkLine(d, w: w, o: o, col: col);

const _metal = '#C9CED6';
const _gold = '#F2C14E';

/// Fabric on the body: a highlight on the near shoulder, folds at the chest
/// and under the arms.
String _fabric(String base, [String extra = '']) =>
    _line('M4 172 C14 156 32 148 54 146', _shade(base, 0.34), 5, 0.5) +
    _line('M60 180 C72 188 88 188 98 182 M102 182 C112 188 128 188 140 180', _shade(base, -0.34), 2.2, 0.5) +
    _line('M46 150 C52 166 52 184 50 200 M154 150 C148 166 148 184 150 200', _shade(base, -0.34), 2.2, 0.55) +
    extra;

String _seams(String col) => _line('M36 140 C28 158 26 180 28 200 M164 140 C172 158 174 180 172 200', col, 2.4, 0.75);

/// A zipper from [y0] down, its slider and pull at [at].
String _zipper(num y0, num at, [String col = _metal]) =>
    '<path d="M100 $y0 L100 200" stroke="$_ink" stroke-width="5.5"/><path d="M100 $y0 L100 200" stroke="$col" stroke-width="3" stroke-dasharray="1.6 1.6"/>'
    '<rect x="96" y="$at" width="8" height="9" rx="2" fill="$col" stroke="$_ink" stroke-width="1.8"/>'
    '<path d="M98 ${at + 9} L97 ${at + 20} L103 ${at + 20} L102 ${at + 9} Z" fill="$col" stroke="$_ink" stroke-width="1.6" stroke-linejoin="round"/>';

/// Knit ribbing along a band's middle line.
String _ribbing(String d, String col, [double w = 6]) =>
    '<path d="$d" fill="none" stroke="$col" stroke-width="${_n(w)}" stroke-dasharray="1.3 2.2" opacity=".75"/>';

String _hoodOf(String fill) =>
    _cel('hood', 'M46 142 C42 112 62 94 84 98 L86 120 C90 130 110 130 114 120 L116 98 C138 94 158 112 154 142 C136 132 118 130 100 130 C82 130 64 132 46 142 Z', fill, w: 3.2) +
    _line('M60 128 C66 112 76 104 86 104 M140 128 C134 112 124 104 114 104', _shade(fill, -0.45), 3, 0.7);

String _cords(String col) {
  const d = 'M90 132 C89 148 88 162 87 176 M110 132 C111 148 112 162 113 176';
  return '${_line(d, _ink, 4.6, 1)}${_line(d, col, 2.4, 1)}'
      '<rect x="84.5" y="175" width="5" height="9" rx="1.5" fill="$_metal" stroke="$_ink" stroke-width="1.5"/>'
      '<rect x="110.5" y="177" width="5" height="9" rx="1.5" fill="$_metal" stroke="$_ink" stroke-width="1.5"/>';
}

/// A jersey's mesh: rows of small holes.
String _mesh(String col, double o) {
  final b = StringBuffer('<g fill="$col" opacity="${_n(o)}">');
  for (var k = 0; k < 90; k++) {
    b.write('<circle cx="${(k % 15) * 14 + ((k ~/ 15) % 2) * 7}" cy="${140 + (k ~/ 15) * 11}" r="1.6"/>');
  }
  b.write('</g>');
  return b.toString();
}

String _top(int i, String tc, String skin) {
  final hi = _shade(tc, 0.34), lo = _shade(tc, -0.34), deep = _shade(tc, -0.55);
  final light = _onCloth(tc) == '#141312' ? _shade(tc, -0.62) : '#F5EFE4';
  final under = light == '#F5EFE4' ? '#E9E1D2' : '#2A2725';
  String body(String base, [String extra = '']) => _cel('body', _P.body, base, inner: _fabric(base, extra));
  const crewCollar = 'M74 116 C84 134 116 134 126 116 L130 124 C118 144 82 144 70 124 Z';
  const crewRib = 'M72 121 C84 140 116 140 128 121';
  const ribCollar = 'M70 112 C82 132 118 132 130 112 L134 124 C120 144 80 144 66 124 Z';
  const ribMiddle = 'M68 118 C82 138 118 138 132 118';
  const vNeck = 'M78 116 L100 150 L122 116 L130 120 L100 162 L70 120 Z';
  const shoulderStripes = 'M80 122 C64 132 40 140 16 156 M120 122 C136 132 160 140 184 156';
  String tankShoulders(bool deepCut) {
    final l = deepCut
        ? 'M-12 200 L-12 176 C-8 154 14 142 40 138 C56 136 70 128 79 116 L88 122 C88 150 84 176 82 200 Z'
        : 'M-12 200 L-12 176 C-8 154 14 142 40 138 C56 136 70 128 79 116 L82 122 C76 140 66 160 62 200 Z';
    final r = deepCut
        ? 'M212 200 L212 176 C208 154 186 142 160 138 C144 136 130 128 121 116 L112 122 C112 150 116 176 118 200 Z'
        : 'M212 200 L212 176 C208 154 186 142 160 138 C144 136 130 128 121 116 L118 122 C124 140 134 160 138 200 Z';
    return _cel('shL', l, skin) + _cel('shR', r, skin) + _inkLine(_P.delts) + _inkLine(_P.traps);
  }

  String stripes(String col, [bool edged = true]) {
    final b = StringBuffer();
    for (final off in [0, 7]) {
      final l = 'M${74 - off} ${126 + off} C${56 - off} ${138 + off} ${36 - off} ${146 + off} ${14 - off} ${164 + off}';
      final r = 'M${126 + off} ${126 + off} C${144 + off} ${138 + off} ${164 + off} ${146 + off} ${186 + off} ${164 + off}';
      if (edged) b.write(_line(l, _ink, 5, 1) + _line(r, _ink, 5, 1));
      b.write(_line(l, col, 3, 1) + _line(r, col, 3, 1));
    }
    return b.toString();
  }

  switch (kTops[i].id) {
    case 'shirtless':
      return _cel('body', _P.body, skin) + _inkLine(_P.delts) + _inkLine(_P.traps) + _inkLine(_P.pecs);
    case 'tank' || 'stringer' || 'gold_trim_tank':
      final deepCut = kTops[i].id == 'stringer';
      final gold = kTops[i].id == 'gold_trim_tank';
      final bind = gold ? _gold : _shade(tc, -0.22);
      final tankEdges = deepCut
          ? 'M86 122 C86 150 82 176 80 200 M114 122 C114 150 118 176 120 200 M86 124 C92 132 108 132 114 124'
          : 'M80 122 C74 140 64 160 60 200 M120 122 C126 140 136 160 140 200 M82 124 C90 140 110 140 118 124';
      return body(gold ? '#141312' : tc) + tankShoulders(deepCut) + _line(tankEdges, _ink, 6.5, 1) + _line(tankEdges, bind, 4, 1) +
          (gold ? '' : _ribbing(tankEdges, _shade(bind, -0.3), 4));
    case 'tee':
      return body(tc) + _seams(lo) + _cel('col', crewCollar, _shade(tc, -0.1), w: 2.6, inner: _ribbing(crewRib, lo));
    case 'ringer':
      final trim = light == '#F5EFE4' ? '#F5EFE4' : '#141312';
      const bands = 'M34 142 C26 160 24 182 26 200 M166 142 C174 160 176 182 174 200';
      return body(tc) + _line(bands, _ink, 10, 1) + _line(bands, trim, 6.5, 1) +
          _cel('col', crewCollar, trim, w: 2.6, inner: _ribbing(crewRib, _shade(trim, -0.25)));
    case 'muscle_tee':
      final rawEdge = '<path d="M40 138 L48 148 C40 166 38 184 40 200 M160 138 L152 148 C160 166 162 184 160 200" fill="none" stroke="$light" stroke-width="2" stroke-dasharray="2 3" opacity=".8"/>';
      return body(tc) +
          _cel('arL', 'M-12 200 L-12 176 C-8 154 14 142 40 138 L48 148 C40 166 38 184 40 200 Z', skin) +
          _cel('arR', 'M212 200 L212 176 C208 154 186 142 160 138 L152 148 C160 166 162 184 160 200 Z', skin) +
          _inkLine(_P.delts) +
          rawEdge +
          _cel('col', 'M76 116 C85 132 115 132 124 116 L128 123 C117 141 83 141 72 123 Z', _shade(tc, -0.12), w: 2.4, inner: _ribbing('M74 120 C85 138 115 138 126 120', lo, 5));
    case 'polo':
      final pique = StringBuffer('<g fill="$lo" opacity=".55">');
      for (var k = 0; k < 60; k++) {
        pique.write('<circle cx="${(k * 37) % 200}" cy="${142 + (k * 23) % 58}" r=".9"/>');
      }
      pique.write('</g>');
      final polo = StringBuffer(body(tc, pique.toString()) + _seams(lo))
        ..write(_cel('plk', 'M94 128 L106 128 L106 170 L94 170 Z', _shade(tc, -0.06), w: 2.2))
        ..write(_cel('pL', 'M80 114 L64 132 L92 142 L100 130 Z', _shade(tc, 0.1), w: 2.6))
        ..write(_cel('pR', 'M120 114 L136 132 L108 142 L100 130 Z', _shade(tc, 0.1), w: 2.6));
      for (final y in [145, 159]) {
        polo.write('<circle cx="100" cy="$y" r="3" fill="#F5EFE4" stroke="$_ink" stroke-width="1.6"/><circle cx="99" cy="$y" r=".7" fill="$_ink"/><circle cx="101" cy="$y" r=".7" fill="$_ink"/>');
      }
      return polo.toString();
    case 'compression':
      final flatlock = '<path d="M100 132 L100 200 M40 150 C56 160 74 164 92 162 M160 150 C144 160 126 164 108 162" fill="none" stroke="$hi" stroke-width="1.6" stroke-dasharray="3 2" opacity=".8"/>';
      return body(tc, _line(_P.pecs, lo, 2.4, 0.7) + _line(_P.delts, lo, 2.4, 0.7) + _line('M10 168 C24 152 46 146 66 146', '#fff', 6, 0.25) + flatlock);
    case 'jersey':
      return body(tc, _mesh(lo, 0.5)) + _line(shoulderStripes, _ink, 9, 1) + _line(shoulderStripes, light, 5.5, 1) +
          _cel('v', vNeck, light, w: 2.6) + _text(100, 192, '23', 30, light, stroke: 2.5);
    case 'camo':
      const blots = [
        (10, 150, 20, 10, '#3F4A22'), (52, 168, 24, 11, '#8C7A4A'), (96, 152, 16, 8, '#2C3318'), (134, 172, 22, 12, '#3F4A22'),
        (176, 150, 18, 9, '#8C7A4A'), (30, 192, 22, 9, '#2C3318'), (86, 194, 20, 9, '#3F4A22'), (150, 196, 20, 8, '#2C3318'),
        (118, 140, 12, 6, '#8C7A4A'), (64, 146, 10, 6, '#2C3318'),
      ];
      final shapes = StringBuffer();
      for (var k = 0; k < blots.length; k++) {
        final (x, y, rx, ry, c) = blots[k];
        shapes.write('<path d="M${x - rx} $y C${x - rx} ${_n(y - ry * 1.4)} ${_n(x + rx * 0.2)} ${y - ry} ${x + rx} ${_n(y - ry * 0.4)} '
            'C${_n(x + rx * 1.3)} ${_n(y + ry * 0.3)} ${_n(x + rx * 0.4)} ${_n(y + ry * 1.2)} ${_n(x - rx * 0.3)} ${y + ry} '
            'C${_n(x - rx * 0.9)} ${_n(y + ry * 0.9)} ${_n(x - rx * 1.1)} ${_n(y + ry * 0.4)} ${x - rx} $y Z" fill="$c" '
            'transform="rotate(${(k * 37) % 50 - 25} $x $y)"/>');
      }
      return _cel('body', _P.body, '#6B7A3A', inner: shapes.toString() + _fabric('#6B7A3A')) + _seams('#2C3318') +
          _cel('col', crewCollar, '#3F4A22', w: 2.6, inner: _ribbing(crewRib, '#2C3318'));
    case 'flannel':
      final dark = _shade(tc, -0.45);
      final plaid = StringBuffer();
      for (final x in [16, 46, 76, 124, 154, 184]) {
        plaid.write('<path d="M$x 120 L$x 200" stroke="$dark" stroke-width="8" opacity=".55"/>');
      }
      for (final y in [148, 170, 192]) {
        plaid.write('<path d="M-10 $y L210 $y" stroke="$dark" stroke-width="7" opacity=".5"/>');
      }
      for (final x in [31, 139]) {
        plaid.write('<path d="M$x 120 L$x 200" stroke="#fff" stroke-width="1.4" opacity=".4"/>');
      }
      plaid.write('<path d="M-10 159 L210 159" stroke="#fff" stroke-width="1.2" opacity=".35"/>');
      return _cel('body', _P.body, tc, inner: plaid.toString() + _fabric(tc)) +
          _cel('tee', 'M84 124 L116 124 L108 200 L92 200 Z', under, w: 2.4) +
          _line('M84 124 L92 200 M116 124 L108 200', _ink, 2.6, 1) +
          _cel('cl', 'M78 112 L92 134 L82 148 L64 124 Z', _shade(tc, 0.08), w: 2.4) +
          _cel('cr', 'M122 112 L108 134 L118 148 L136 124 Z', _shade(tc, 0.08), w: 2.4) +
          _cel('pk', 'M54 162 L78 162 L77 176 L66 180 L55 176 Z', _shade(tc, -0.08), w: 2.2) +
          _dot(66, 172, 2, '#F5EFE4', w: 1.2) + _dot(118, 160, 2.2, '#F5EFE4', w: 1.3) + _dot(118, 182, 2.2, '#F5EFE4', w: 1.3);
    case 'hoodie':
      return body(tc, _line('M54 200 L64 186 L136 186 L146 200', lo, 2.6, 0.8)) + _seams(lo) + _hoodOf(_shade(tc, -0.08)) + _cords(light);
    case 'windbreaker':
      final block = light == '#F5EFE4' ? _shade(tc, 0.55) : _shade(tc, -0.4);
      return body(tc, '<path d="M-12 172 L100 152 L212 172 L212 200 L-12 200 Z" fill="$block"/>${_line('M-12 168 L100 148 L212 168', _coral, 5, 1)}${_line('M20 160 C34 152 48 150 60 152', '#fff', 4, 0.3)}') +
          _zipper(130, 140);
    case 'zip_hoodie':
      return body(tc) + _seams(lo) + _hoodOf(_shade(tc, -0.08)) +
          _cel('v', 'M88 128 L100 152 L112 128 Z', light == '#F5EFE4' ? '#E9E1D2' : '#1E1C1A', w: 2.4) +
          _line('M100 152 L100 200', _ink, 2, 0.9) + _zipper(152, 154) + _cords(light);
    case 'track_jacket':
      return body(tc) + _zipper(118, 118) + stripes(light);
    case 'varsity':
      const cream = '#E9E1D2';
      final jacket = StringBuffer(body(tc))
        ..write(_cel('slL', _P.sleeveL, cream, inner: _line('M-6 178 C4 162 18 152 34 148', '#fff', 4, 0.5)))
        ..write(_cel('slR', _P.sleeveR, cream))
        ..write(_cel('rib', ribCollar, tc, w: 2.8, inner: _ribbing(ribMiddle, lo, 7) + _line('M68 120 C82 139 118 139 132 120', cream, 1.8, 1) + _line('M67 125 C81 144 119 144 133 125', cream, 1.8, 1)))
        ..write('<path d="M66 154 L70 164 L81 165 L72 172 L75 183 L66 177 L57 183 L60 172 L51 165 L62 164 Z" fill="$cream" stroke="$_ink" stroke-width="2.2" stroke-linejoin="round"/>')
        ..write('<path d="M66 158 L68.5 164.5 L75.5 165 L70 169.5 L72 176.5 L66 172.5 L60 176.5 L62 169.5 L56.5 165 L63.5 164.5 Z" fill="none" stroke="$lo" stroke-width="1" stroke-dasharray="1.5 1.5"/>')
        ..write(_line('M100 140 L100 200', _ink, 2, 0.6));
      for (final y in [150, 164, 178, 192]) {
        jacket.write(_dot(105, y, 2, cream, w: 1.2));
      }
      return jacket.toString();
    case 'bomber':
      return body(tc, _line('M26 162 C40 152 56 150 70 152', '#fff', 4, 0.3) + _line('M132 156 C146 152 160 154 172 160', '#fff', 3, 0.2)) +
          _zipper(136, 150) +
          _cel('rib', ribCollar, deep, w: 2.8, inner: _ribbing(ribMiddle, _shade(deep, -0.3), 7) + _line('M68 122 C82 141 118 141 132 122', _coral, 2, 0.95)) +
          _cel('pk', 'M18 168 L36 164 L38 180 L20 184 Z', _shade(tc, -0.12), w: 2) + _line('M22 170 L34 167', _metal, 2, 1);
    case 'denim':
      const d = '#3B6EA8', dd = '#2F5C8E', stitch = '#E3A94A';
      final twill = StringBuffer('<g stroke="$dd" stroke-width="1.2" opacity=".55">');
      for (var k = 0; k < 26; k++) {
        twill.write('<path d="M${-40 + k * 10} 200 L${k * 10} 140"/>');
      }
      twill.write('</g>');
      final denim = StringBuffer(_cel('body', _P.body, d, inner: twill.toString() + _fabric(d)))
        ..write(_line('M12 160 C50 150 150 150 188 160', _ink, 2.2, 0.8))
        ..write('<path d="M12 164 C50 154 150 154 188 164" fill="none" stroke="$stitch" stroke-width="1.4" stroke-dasharray="3 2.5"/>')
        ..write(_line('M100 136 L100 200', _ink, 2.4, 0.9))
        ..write('<path d="M104 136 L104 200" fill="none" stroke="$stitch" stroke-width="1.3" stroke-dasharray="3 2.5"/>');
      for (final x in [56, 118]) {
        denim
          ..write(_cel('pk$x', 'M$x 168 L${x + 26} 168 L${x + 25} 180 L${x + 13} 185 L${x + 1} 180 Z', dd, w: 2.2))
          ..write('<path d="M${x + 3} 171 L${x + 23} 171" stroke="$stitch" stroke-width="1.2" stroke-dasharray="2.5 2"/>')
          ..write(_dot(x + 13, 179, 2.2, '#C77B3A', w: 1.4));
      }
      denim
        ..write(_dot(100, 150, 2.8, '#C77B3A', w: 1.6))
        ..write(_dot(100, 192, 2.8, '#C77B3A', w: 1.6))
        ..write(_cel('dcL', 'M76 110 L58 150 L88 140 L98 128 Z', dd, w: 2.6, inner: '<path d="M74 118 L62 145 L86 137" fill="none" stroke="$stitch" stroke-width="1.3" stroke-dasharray="2.5 2"/>'))
        ..write(_cel('dcR', 'M124 110 L142 150 L112 140 L102 128 Z', dd, w: 2.6, inner: '<path d="M126 118 L138 145 L114 137" fill="none" stroke="$stitch" stroke-width="1.3" stroke-dasharray="2.5 2"/>'));
      return denim.toString();
    case 'leather':
      const lth = '#1A1817', lth2 = '#2A2725';
      final biker = StringBuffer(_cel('body', _P.body, lth, dark: 0.12, inner: _line('M24 158 C38 148 54 146 64 148', '#fff', 5, 0.35) + _line('M140 154 C152 150 166 152 176 158', '#fff', 3, 0.22)))
        ..write('<path d="M112 136 L120 200" stroke="$_ink" stroke-width="5"/><path d="M112 136 L120 200" stroke="$_metal" stroke-width="2.6" stroke-dasharray="1.6 1.6"/>')
        ..write(_cel('lpL', 'M76 114 L102 152 L86 172 L54 136 Z', lth2, w: 2.6, dark: 0.12, inner: _line('M70 130 L84 148', '#fff', 2, 0.25)))
        ..write(_cel('lpR', 'M124 114 L104 144 L122 168 L146 136 Z', lth2, w: 2.6, dark: 0.12));
      for (final (x, y) in [(62, 140), (138, 140), (88, 164), (118, 160)]) {
        biker.write(_dot(x, y, 2.4, _metal, w: 1.2));
      }
      biker
        ..write(_cel('epL', 'M20 152 L46 140 L50 148 L24 160 Z', lth2, w: 2, dark: 0.12))
        ..write(_cel('epR', 'M180 152 L154 140 L150 148 L176 160 Z', lth2, w: 2, dark: 0.12));
      return biker.toString();
    case 'puffer_vest':
      final vestBaffles = StringBuffer();
      for (final y in [146, 164, 182]) {
        vestBaffles
          ..write('<path d="M0 $y C60 ${y - 7} 140 ${y - 7} 200 $y" fill="none" stroke="$deep" stroke-width="2.6"/>')
          ..write('<path d="M20 ${y + 8} C70 ${y + 2} 130 ${y + 2} 180 ${y + 8}" fill="none" stroke="$hi" stroke-width="4" opacity=".5"/>');
      }
      return _cel('body', _P.body, under, inner: _fabric(under)) +
          _cel('vest', 'M10 200 L16 160 C26 150 42 146 58 144 L72 122 L128 122 L142 144 C158 146 174 150 184 160 L190 200 Z', tc, inner: vestBaffles.toString()) +
          _cel('col', 'M70 104 L130 104 L134 128 C118 138 82 138 66 128 Z', tc, w: 2.8, inner: _line('M70 114 C88 108 112 108 130 114', hi, 4, 0.45) + _line('M68 122 C86 130 114 130 132 122', deep, 2, 0.7)) +
          _zipper(104, 112);
    case 'gold_bomber' || 'satin_bomber':
      final goldOne = kTops[i].id == 'gold_bomber';
      final satin = goldOne ? '#E2B23C' : '#5B2A9E';
      final rib = goldOne ? '#141312' : _gold;
      final stripe = goldOne ? _gold : '#141312';
      return _cel('body', _P.body, satin, inner: _line('M-6 168 C20 146 50 140 86 150', '#fff', 10, 0.28) + _line('M118 150 C144 142 170 146 204 162', '#fff', 6, 0.18) + _fabric(satin)) +
          _zipper(136, 150, goldOne ? '#141312' : _gold) +
          _cel('rib', ribCollar, rib, w: 2.8, inner: _ribbing(ribMiddle, _shade(rib, -0.3), 7) + _line('M68 121 C82 140 118 140 132 121', stripe, 1.8, 1) + _line('M67 126 C81 145 119 145 133 126', stripe, 1.8, 1));
    case 'champion_robe':
      // A star, not a word: nothing written on any garment (the user's rule).
      const star = '<path d="M152 166 L156 176 L167 177 L158 184 L161 195 L152 189 L143 195 L146 184 L137 177 L148 176 Z" fill="$_gold" stroke="$_ink" stroke-width="2" stroke-linejoin="round"/>';
      return _cel('body', _P.body, '#B0182A', inner: _line('M-6 166 C20 146 48 140 80 146', '#fff', 9, 0.25) + _fabric('#B0182A')) +
          _cel('shawl', 'M70 112 C76 140 90 170 98 200 L82 200 C70 170 58 142 56 126 Z M130 112 C124 140 110 170 102 200 L118 200 C130 170 142 142 144 126 Z', _gold, w: 2.8, inner: _line('M66 120 C72 146 84 172 90 200 M134 120 C128 146 116 172 110 200', '#FFE08A', 2.4, 0.8)) +
          star;
    case 'pro_tracksuit':
      return _cel('body', _P.body, '#141312', dark: 0.15, inner: _line('M4 172 C14 156 32 148 54 146', '#fff', 5, 0.18)) + _zipper(118, 118, _gold) + stripes(_gold, false);
    case 'holo_jersey':
      // The user's pick D: a sleeveless basketball jersey in a dark oil-slick
      // finish — black that turns teal, violet and gold in the light — with
      // gold binding and a gold number.
      const jerseyEdges = 'M80 122 C74 140 64 160 60 200 M120 122 C126 140 136 160 140 200 M82 124 C90 142 110 142 118 124';
      return '<defs><linearGradient id="pj" gradientUnits="userSpaceOnUse" x1="0" y1="200" x2="200" y2="120"><stop offset="0" stop-color="#0E3B3F"/><stop offset=".3" stop-color="#14121A"/>'
          '<stop offset=".55" stop-color="#3B1F5C"/><stop offset=".78" stop-color="#14121A"/><stop offset="1" stop-color="#5C4410"/></linearGradient>'
          '<clipPath id="pjc"><path d="${_P.body}"/></clipPath></defs>'
          '<path d="${_P.body}" fill="url(#pj)"/><g clip-path="url(#pjc)">${_mesh('#fff', 0.12)}'
          '<path d="M30 210 L110 120" stroke="#7AD7FF" stroke-width="10" opacity=".22"/><path d="M90 214 L170 124" stroke="#FF9FD6" stroke-width="6" opacity=".2"/></g>'
          '<path d="${_P.body}" fill="none" stroke="$_ink" stroke-width="3.4"/>'
          '${tankShoulders(false)}${_line(jerseyEdges, _ink, 7, 1)}${_line(jerseyEdges, _gold, 4.4, 1)}${_text(100, 194, '00', 32, _gold, stroke: 3)}';
    case 'tie_dye_hoodie':
      return '<defs><radialGradient id="td" cx="50%" cy="85%" r="75%"><stop offset="0" stop-color="#FFE04A"/><stop offset=".28" stop-color="#FF6FB0"/>'
          '<stop offset=".52" stop-color="#7B5CFF"/><stop offset=".76" stop-color="#3FD3FF"/><stop offset="1" stop-color="#FF6FB0"/></radialGradient></defs>'
          '<path d="${_P.body}" fill="url(#td)"/>${_line('M4 172 C14 156 32 148 54 146', '#fff', 5, 0.35)}'
          '${_line('M60 180 C72 188 88 188 98 182 M102 182 C112 188 128 188 140 180', '#3A2A7A', 2.2, 0.4)}'
          '<path d="${_P.body}" fill="none" stroke="$_ink" stroke-width="3.4"/>${_hoodOf('#5B3FCF')}${_cords('#F5EFE4')}';
    case 'gloss_puffer':
      final glossBaffles = StringBuffer();
      for (final y in [146, 164, 182]) {
        glossBaffles
          ..write('<path d="M-10 $y C60 ${y - 8} 140 ${y - 8} 210 $y" fill="none" stroke="#000" stroke-width="3"/>')
          ..write('<path d="M14 ${y + 8} C70 ${y + 1} 130 ${y + 1} 186 ${y + 8}" fill="none" stroke="#fff" stroke-width="4" opacity=".28"/>');
      }
      return _cel('body', _P.body, '#121214', dark: 0.1, inner: glossBaffles.toString()) + _zipper(104, 112);
    default:
      return body(tc);
  }
}

/// Collars that wrap the neck, drawn after it so they sit in front.
String _topOver(int i, String tc) {
  final hi = _shade(tc, 0.34), deep = _shade(tc, -0.55);
  String pull([String col = _metal]) =>
      '<path d="M100 114 L100 140" stroke="$_ink" stroke-width="5"/><path d="M100 114 L100 140" stroke="$col" stroke-width="2.6" stroke-dasharray="1.6 1.6"/>'
      '<rect x="96" y="112" width="8" height="8" rx="2" fill="$col" stroke="$_ink" stroke-width="1.6"/><path d="M98 120 L97 129 L103 129 L102 120 Z" fill="$col" stroke="$_ink" stroke-width="1.4"/>';
  const stand = 'M76 110 C86 118 114 118 124 110 L127 132 C114 141 86 141 73 132 Z';
  const puffed = 'M72 106 C84 117 116 117 128 106 L132 132 C118 143 82 143 68 132 Z';
  switch (kTops[i].id) {
    case 'compression':
      return _cel('stand', 'M76 108 C86 116 114 116 124 108 L126 130 C114 138 86 138 74 130 Z', _shade(tc, -0.08), w: 2.8, inner: _line('M75 116 C88 124 112 124 125 116', hi, 2.4, 0.6));
    case 'windbreaker':
      const cord = 'M84 126 L82 140 M116 126 L118 140';
      return _cel('stand', stand, tc, w: 2.8, inner: _line('M75 118 C88 126 112 126 125 118', hi, 2.4, 0.6)) + pull() +
          _line(cord, _ink, 3.4, 1) + _line(cord, '#F5EFE4', 1.6, 1) + _dot(82, 142, 2.6, '#141312', w: 1.2) + _dot(118, 142, 2.6, '#141312', w: 1.2);
    case 'track_jacket':
      return _cel('stand', stand, tc, w: 2.8, inner: _line('M75 118 C88 126 112 126 125 118', hi, 2.4, 0.6)) + pull();
    case 'pro_tracksuit':
      return _cel('stand', stand, '#141312', w: 2.8, dark: 0.15, inner: _line('M75 118 C88 126 112 126 125 118', _gold, 2.4, 0.9)) + pull(_gold);
    case 'puffer_vest':
      return _cel('stand', puffed, tc, w: 2.8, inner: _line('M72 114 C86 122 114 122 128 114', hi, 4, 0.5) + _line('M70 125 C86 134 114 134 130 125', deep, 2, 0.7)) + pull();
    case 'gloss_puffer':
      return _cel('stand', puffed, '#121214', w: 2.8, dark: 0.1, inner: _line('M72 114 C86 122 114 122 128 114', '#fff', 4, 0.3)) + pull();
    default:
      return '';
  }
}

// ── gear ─────────────────────────────────────────────────────────────────────

String _chain(String col, double w, String dash) =>
    '<path d="${_P.chain}" fill="none" stroke="$_ink" stroke-width="${_n(w + 3.5)}" stroke-linecap="round"/>'
    '<path d="${_P.chain}" fill="none" stroke="$col" stroke-width="${_n(w)}" stroke-dasharray="$dash" stroke-linecap="round"/>';

String _gear(int i) {
  switch (kGear[i].id) {
    case 'shades':
      return _cel('sh', 'M70 74 L130 74 L128 88 C124 96 108 96 104 88 L100 82 L96 88 C92 96 76 96 72 88 Z', '#121212', dark: 0.15,
          inner: '<path d="M76 77 L92 77 L80 90 Z M108 77 L124 77 L112 90 Z" fill="#fff" opacity=".35"/>');
    case 'glasses':
      return '<rect x="75" y="74" width="22" height="16" rx="6" fill="#fff" fill-opacity=".18" stroke="$_ink" stroke-width="2.6"/>'
          '<rect x="103" y="74" width="22" height="16" rx="6" fill="#fff" fill-opacity=".18" stroke="$_ink" stroke-width="2.6"/>'
          '${_inkLine('M97 80 L103 80 M75 80 L66 78 M125 80 L134 78', w: 2.6, o: 1)}';
    case 'sweatband':
      return _cel('sb', 'M64 54 C80 46 120 46 136 54 L136 64 C120 56 80 56 64 64 Z', '#C2452D') + _inkLine('M70 58 L130 58', w: 1.4, o: 0.6, col: '#fff');
    case 'bandana':
      return _cel('bn', 'M62 60 C62 34 80 24 100 24 C120 24 138 34 138 60 C120 50 80 50 62 60 Z', '#2F6FD6') +
          _cel('kn', 'M136 56 L156 48 L152 62 L160 72 L140 64 Z', '#2F6FD6', w: 2.4) +
          [(80, 40), (100, 34), (120, 40), (90, 48), (110, 48)].map((p) => '<circle cx="${p.$1}" cy="${p.$2}" r="1.8" fill="#fff" opacity=".8"/>').join();
    case 'cap_back':
      return _cel('cp', 'M62 62 C60 32 80 22 100 22 C120 22 140 32 138 62 C124 52 76 52 62 62 Z', '#141312', dark: 0.2) +
          _cel('cb', 'M90 24 C94 18 106 18 110 24 L108 32 L92 32 Z', '#2F6FD6', w: 2.2);
    case 'cap':
      return _cel('cp', 'M62 60 C60 30 80 20 100 20 C120 20 140 30 138 60 C124 50 76 50 62 60 Z', '#C2452D') +
          _cel('brim', 'M58 60 C76 52 124 52 142 60 C150 64 150 70 140 70 C120 64 80 64 60 70 C50 70 50 64 58 60 Z', '#9A2E1C', w: 2.6) +
          _inkLine('M100 20 L100 50', w: 1.6, o: 0.5);
    case 'bucket_hat':
      return _cel('bk', 'M66 56 C66 32 82 22 100 22 C118 22 134 32 134 56 Z', '#C8B98A') +
          _cel('bkb', 'M52 64 C56 52 144 52 148 64 C150 70 138 72 100 70 C62 72 50 70 52 64 Z', '#B1A274', w: 2.6);
    case 'beanie':
      return _cel('be', 'M60 64 C58 30 80 16 100 16 C120 16 142 30 140 64 L140 56 C120 50 80 50 60 56 Z', '#7B3FC4') +
          _cel('cuff', 'M58 54 C80 46 120 46 142 54 L142 66 C120 58 80 58 58 66 Z', _shade('#7B3FC4', -0.15)) + _dot(100, 14, 8, '#F2B33D');
    case 'durag':
      return _cel('dr', 'M62 62 C60 30 80 20 100 20 C120 20 140 30 138 62 C124 54 76 54 62 62 Z', '#141312', dark: 0.2,
              inner: '<path d="M70 40 C90 30 112 30 132 40" stroke="#fff" stroke-width="3" opacity=".25" fill="none"/>') +
          _cel('tail', 'M132 52 C150 56 156 80 150 100 L142 98 C146 80 142 64 130 60 Z', '#141312', dark: 0.2, w: 2.4);
    case 'visor':
      return _cel('vi', 'M58 60 C76 52 124 52 142 60 C150 64 150 70 140 70 C120 64 80 64 60 70 C50 70 50 64 58 60 Z', '#2F6FD6', w: 2.6) +
          _cel('vb', 'M64 56 C80 48 120 48 136 56 L136 62 C120 56 80 56 64 62 Z', '#E9E1D2', w: 2.2);
    case 'headphones':
      return _cel('hp', _P.phones, '#202020', dark: 0.2) + _cel('cL', _P.cupL, '#2b2b2b', dark: 0.2) + _cel('cR', _P.cupR, '#2b2b2b', dark: 0.2);
    case 'earbuds':
      return _dot(62, 84, 4, '#F5F5F4', w: 1.6) + _dot(138, 84, 4, '#F5F5F4', w: 1.6) + _inkLine('M62 88 L62 96 M138 88 L138 96', w: 2.6, o: 1, col: '#F5F5F4');
    case 'earrings':
      return _dot(62, 96, 3.2, '#F2C14E', w: 1.6) + _dot(138, 96, 3.2, '#F2C14E', w: 1.6);
    case 'silver_chain':
      return _chain('#D7DDE4', 4, '3 2');
    case 'dog_tags':
      const tags = '<rect x="92" y="150" width="14" height="20" rx="3" fill="#C9CED6" stroke="$_ink" stroke-width="2" transform="rotate(-8 99 160)"/>'
          '<rect x="100" y="152" width="14" height="20" rx="3" fill="#B8C2CC" stroke="$_ink" stroke-width="2" transform="rotate(10 107 162)"/>';
      return _inkLine('M72 130 C80 156 120 156 128 130', w: 2, o: 1) + tags;
    case 'whistle':
      return '${_inkLine('M76 130 C84 152 116 152 124 130', w: 2.4, o: 1, col: '#C2452D')}'
          '<path d="M92 156 L108 156 L110 166 L94 168 Z" fill="#C9CED6" stroke="$_ink" stroke-width="2"/>${_dot(96, 160, 2, _ink, w: 1)}';
    case 'towel':
      return _cel('tw', 'M128 118 C150 120 176 132 190 150 L178 200 L152 200 C152 170 140 146 122 132 Z', '#F4EDE0', dark: -0.12) +
          _inkLine('M160 150 L150 200 M172 154 L164 200', w: 1.6, o: 0.4);
    case 'face_mask':
      return _cel('mk', 'M68 86 C78 90 122 90 132 86 C134 108 120 122 100 124 C80 122 66 108 68 86 Z', '#151413', dark: 0.15) +
          _inkLine('M76 96 L124 96', w: 1.4, o: 0.25, col: '#fff');
    case 'gold_chain':
      return _chain('#F2C14E', 5.5, '5 3') + _dot(100, 162, 8, '#F2C14E', w: 2.6);
    case 'medal':
      const second = '<text x="100" y="165" text-anchor="middle" font-family="Arial" font-size="12" font-weight="900" fill="$_ink">2</text>';
      return _inkLine('M84 126 L100 150 L116 126', w: 6, o: 1, col: '#2F6FD6') + _inkLine('M84 126 L100 150 L116 126', w: 2, o: 1) +
          _dot(100, 160, 11, '#C9CED6', w: 2.8) +
          second;
    case 'laurel':
      final b = StringBuffer();
      for (var k = 0; k < 6; k++) {
        final a = 3.6 - k * 0.22, x = 100 + 46 * math.cos(a), y = 70 - 40 * math.sin(a), x2 = 100 - 46 * math.cos(a);
        b.write('<ellipse cx="${_n(x)}" cy="${_n(y)}" rx="8" ry="4" transform="rotate(${-k * 14 + 30} ${_n(x)} ${_n(y)})" fill="#2E8B57" stroke="$_ink" stroke-width="2"/>'
            '<ellipse cx="${_n(x2)}" cy="${_n(y)}" rx="8" ry="4" transform="rotate(${k * 14 - 30} ${_n(x2)} ${_n(y)})" fill="#2E8B57" stroke="$_ink" stroke-width="2"/>');
      }
      return b.toString();
    case 'horns':
      return _cel('hnL', 'M70 44 C60 30 58 14 66 4 C68 16 74 28 82 34 Z', '#C2452D', w: 2.6) + _cel('hnR', 'M130 44 C140 30 142 14 134 4 C132 16 126 28 118 34 Z', '#C2452D', w: 2.6);
    case 'title_belt':
      return _cel('blt', 'M10 158 C60 140 140 140 190 158 L186 182 C140 166 60 166 14 182 Z', '#141312', dark: 0.15) +
          _cel('plate', 'M76 150 L124 150 L128 176 L72 176 Z', '#F2C14E') + _dot(100, 163, 7, '#C2452D', w: 2);
    case 'halo':
      return '<ellipse cx="100" cy="12" rx="30" ry="8" fill="none" stroke="$_ink" stroke-width="7"/>'
          '<ellipse cx="100" cy="12" rx="30" ry="8" fill="none" stroke="#FFE08A" stroke-width="4"/>'
          '<ellipse cx="100" cy="12" rx="38" ry="14" fill="#FFE08A" opacity=".22"/>';
    case 'crown':
      return _cel('crown', 'M66 40 L72 8 L86 26 L100 2 L114 26 L128 8 L134 40 Z', '#F2C14E') +
          _dot(100, 30, 4, '#C2452D', w: 1.8) + _dot(80, 34, 3, '#2F6FD6', w: 1.6) + _dot(120, 34, 3, '#2E8B57', w: 1.6);
    case 'gold_headphones':
      return _cel('hp', _P.phones, '#F2C14E') + _cel('cL', _P.cupL, '#E2B23C') + _cel('cR', _P.cupR, '#E2B23C');
    case 'diamond_studs':
      return [62, 138].map((x) => '<path d="M$x 90 L${x + 4} 95 L$x 100 L${x - 4} 95 Z" fill="#E8FDFF" stroke="$_ink" stroke-width="1.4"/>'
          '<path d="M${x - 1} 92 L${x + 1} 92" stroke="#fff" stroke-width="1"/>').join();
    case 'cyber_visor':
      return '<path d="M62 74 C80 70 120 70 138 74 L136 90 C118 86 82 86 64 90 Z" fill="#4DF2FF" fill-opacity=".55" stroke="$_ink" stroke-width="2.8"/>'
          '${_inkLine('M68 80 L132 80', w: 2, o: 0.8, col: '#fff')}';
    case 'iced_chain':
      return '${_chain('#E8FDFF', 6.5, '4 2')}<path d="M100 152 L110 162 L100 176 L90 162 Z" fill="#E8FDFF" stroke="$_ink" stroke-width="2.4"/>'
          '<path d="M94 162 L106 162" stroke="#9FE3FF" stroke-width="1.4"/>';
    case 'aura':
      final sparks = [(56, 30), (146, 40), (62, 108), (140, 104), (100, 6)].map((p) {
        final (x, y) = p;
        return '<path d="M$x ${y - 5} L${x + 1.5} ${y - 1.5} L${x + 5} $y L${x + 1.5} ${y + 1.5} L$x ${y + 5} L${x - 1.5} ${y + 1.5} L${x - 5} $y L${x - 1.5} ${y - 1.5} Z" fill="#fff"/>';
      }).join();
      return '<path d="M60 70 C60 30 80 16 100 16 C120 16 140 30 140 70 C140 100 126 124 100 128 C74 124 60 100 60 70 Z" fill="none" stroke="#B26BFF" stroke-width="10" opacity=".22"/>'
          '<path d="M56 70 C56 26 78 10 100 10 C122 10 144 26 144 70" fill="none" stroke="#FF4FD8" stroke-width="4" opacity=".35"/>$sparks';
    default:
      return '';
  }
}
