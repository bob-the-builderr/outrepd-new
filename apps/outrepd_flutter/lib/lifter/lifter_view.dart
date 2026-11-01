/// The lifter on screen, as a picture file, and the one a name wears until
/// its account makes its own.
library;

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
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
