/// The lifter on screen, as a picture file, and the one a name wears until
/// its account makes its own.
library;

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'catalog.dart';
import 'lifter_art.dart';

/// [lifter], square, at [size].
class LifterImage extends StatelessWidget {
  const LifterImage(
    this.lifter, {
    super.key,
    this.size,
    this.view = LifterView.full,
  });

  final Lifter lifter;
  final double? size;
  final LifterView view;

  @override
  Widget build(BuildContext context) => SvgPicture.string(
    lifterSvg(lifter, view: view),
    width: size,
    height: size,
    fit: BoxFit.cover,
    excludeFromSemantics: true,
  );
}

/// The same number for the same name on every phone: the seed of the lifter
/// an account wears before it makes its own. Kept small, so it is exact on
/// every platform.
int lifterSeed(String name) {
  var h = 7;
  for (final c in name.toLowerCase().codeUnits) {
    h = (h * 31 + c) % 1000003;
  }
  return h;
}

/// The lifter [name] wears until its account makes one: free parts only.
Lifter lifterFor(String name) => Lifter.random(lifterSeed(name));

/// [lifter] as a PNG, [size] pixels square: the picture uploaded as the
/// account's photo, so boards, older builds and the website show it too.
Future<Uint8List> lifterPng(Lifter lifter, {int size = 512}) async {
  final info = await vg.loadPicture(SvgStringLoader(lifterSvg(lifter)), null);
  try {
    final recorder = ui.PictureRecorder();
    ui.Canvas(recorder)
      ..scale(size / info.size.width, size / info.size.height)
      ..drawPicture(info.picture);
    final image = await recorder.endRecording().toImage(size, size);
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      return data!.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  } finally {
    info.picture.dispose();
  }
}

/// A lifter in a circle: what a picture is when there is no photo. [lifter]
/// is the one to draw; without one, the one [name] gives.
class LifterCircle extends StatelessWidget {
  const LifterCircle({
    super.key,
    required this.name,
    required this.size,
    this.lifter,
    this.border,
  });

  final String name;
  final double size;
  final Lifter? lifter;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, border: border),
    child: ClipOval(child: LifterImage(lifter ?? lifterFor(name), size: size)),
  );
}

/// How long one breath in, or out, takes.
const _breathTime = Duration(milliseconds: 2000);

/// A Pro lifter, alive inside its frame (the user's pick, 2026-11-01): it
/// blinks every few seconds and its chest rises and falls. Nothing moves
/// outside the frame and nothing glows around it. Still when [on] is false,
/// and where the phone asks for less motion.
///
/// [builder] draws [lifter] as it is this moment — eyes shut for a blink —
/// and is handed the breath as a scale to grow the art by from its foot.
class AliveLifter extends StatefulWidget {
  const AliveLifter({
    super.key,
    required this.lifter,
    required this.builder,
    this.on = true,
  });

  final Lifter lifter;
  final bool on;
  final Widget Function(BuildContext context, Lifter shown, double breath) builder;

  @override
  State<AliveLifter> createState() => _AliveLifterState();
}

class _AliveLifterState extends State<AliveLifter> {
  Timer? _blinks;
  Timer? _breaths;
  Timer? _open;
  bool _shut = false;
  bool _in = false;

  bool get _still =>
      !widget.on || (MediaQuery.maybeDisableAnimationsOf(context) ?? false);

  @override
  void initState() {
    super.initState();
    // Timers, not a looping animation: between a blink and a breath nothing
    // is drawn at all.
    _blinks = Timer.periodic(const Duration(milliseconds: 4300), (_) {
      if (!mounted || _still) return;
      setState(() => _shut = true);
      _open = Timer(const Duration(milliseconds: 150), () {
        if (mounted) setState(() => _shut = false);
      });
    });
    _breaths = Timer.periodic(_breathTime + const Duration(milliseconds: 400), (_) {
      if (!mounted || _still) return;
      setState(() => _in = !_in);
    });
  }

  @override
  void dispose() {
    _blinks?.cancel();
    _breaths?.cancel();
    _open?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final still = _still;
    final shown = !still && _shut
        ? widget.lifter.copyWith(eyes: kEyesShut)
        : widget.lifter;
    return widget.builder(context, shown, !still && _in ? 1.025 : 1);
  }
}

/// [child] grown to [breath] from its foot, smoothly.
Widget breathing(double breath, Widget child) => AnimatedScale(
  scale: breath,
  duration: _breathTime,
  curve: Curves.easeInOut,
  alignment: Alignment.bottomCenter,
  child: child,
);

/// A Pro lifter's picture on a board: the lifter big in its circle, its
/// head out over the top of the ring (the user's pick, 2026-11-01). Sized
/// like the circle it replaces; the head reaches above it.
class PopOutLifter extends StatelessWidget {
  const PopOutLifter(this.lifter, {super.key, required this.size, this.alive = true});

  final Lifter lifter;
  final double size;
  final bool alive;

  @override
  Widget build(BuildContext context) {
    final r = size / 2;
    // The art half again as big as the circle and lower in it, so the head
    // sits above the circle's top edge.
    final s = size * 1.5;
    final left = r - s / 2;
    final top = r - r * 1.3 - s * 0.14;
    return AliveLifter(
      lifter: lifter,
      on: alive,
      builder: (context, shown, breath) => SizedBox.square(
        dimension: size,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipOval(
              child: SizedBox.square(
                dimension: size,
                child: Stack(
                  children: [
                    Positioned(
                      left: left,
                      top: top,
                      width: s,
                      height: s,
                      child: breathing(breath, LifterImage(shown, size: s)),
                    ),
                  ],
                ),
              ),
            ),
            // The lifter alone, above the circle's middle: the head in front
            // of the ring.
            Positioned(
              left: left,
              top: top,
              width: s,
              height: s,
              child: ClipRect(
                clipper: _Above(r - top),
                child: breathing(
                  breath,
                  LifterImage(shown, size: s, view: LifterView.noBackground),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Everything above [y].
class _Above extends CustomClipper<Rect> {
  const _Above(this.y);

  final double y;

  @override
  Rect getClip(Size size) => Rect.fromLTRB(-size.width, -size.height, size.width * 2, y);

  @override
  bool shouldReclip(_Above old) => old.y != y;
}
