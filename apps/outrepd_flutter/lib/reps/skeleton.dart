/// Draws the tracked body over the camera preview.
///
/// Shared rather than private to the camera screen: onboarding draws the same
/// skeleton during its framing check and its calibration set, and a second
/// copy would be a second place to keep the coordinate transform correct. That
/// transform is the part that goes wrong — ML Kit reports pixels *after* the
/// rotation it was handed, so width and height swap on most phones, and the
/// BoxFit.cover crop has to be applied to the overlay exactly as the preview
/// applies it or the skeleton slides off the lifter.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';
import 'pose.dart';

/// One line, wrist to wrist over the shoulders: the arms and the bar between
/// them, which is all a push-up is made of from the front (the user's pick,
/// 2026-10-27, after thin bones with dots and the chest drawn in). No dots, no
/// torso, no legs: with the phone on the floor facing the lifter the hips sit
/// behind the shoulders and the knees and ankles are hidden in most frames,
/// so the tracker guesses at them — and the counter never reads them.
const _line = <Joint>[
  Joint.leftWrist,
  Joint.leftElbow,
  Joint.leftShoulder,
  Joint.rightShoulder,
  Joint.rightElbow,
  Joint.rightWrist,
];

class SkeletonPainter extends CustomPainter {
  SkeletonPainter({
    required this.pose,
    required this.good,
    required this.mirror,
    required this.sourceSize,
  });

  final BodyPose pose;

  /// In position, or mid-round with the hands planted: drawn bright. Faint
  /// otherwise — the same colour, so not being there yet reads as "not yet"
  /// rather than as an error.
  final bool good;

  /// The front camera shows a mirror image, so the overlay has to be flipped
  /// to land on the body instead of beside it.
  final bool mirror;

  /// Shape of the picture the pose was measured in, or null to fill the box.
  final Size? sourceSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (pose.points.isEmpty) return;

    // The app's own cream, whatever the theme: it is drawn over a camera
    // picture, not over a page.
    final colour = kDarkPalette.brand;
    final strength = good ? 1.0 : 0.45;

    // The preview covers the screen: scaled until it fills, then centred and
    // clipped. The skeleton has to be put through the very same transform, or
    // it sits beside the body rather than on it.
    final source = sourceSize;
    final scale = source == null
        ? 1.0
        : math.max(size.width / source.width, size.height / source.height);
    final drawn = source == null
        ? size
        : Size(source.width * scale, source.height * scale);
    final dx = (size.width - drawn.width) / 2;
    final dy = (size.height - drawn.height) / 2;

    Offset? at(Joint joint) {
      final p = pose.confident(joint, min: 0.35);
      if (p == null) return null;
      final x = mirror ? 1 - p.x : p.x;
      return Offset(x * drawn.width + dx, p.y * drawn.height + dy);
    }

    // Thick enough to read from the floor a metre away: a thirtieth of the
    // screen, the way the line it was modelled on is drawn.
    final line = Paint()
      ..color = colour.withValues(alpha: 0.86 * strength)
      ..style = PaintingStyle.stroke
      ..strokeWidth = (size.shortestSide * 0.035).clamp(10.0, 26.0)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // One path through every joint the tracker can see, broken where it
    // cannot: a missing elbow leaves a gap rather than a line cut straight
    // across from shoulder to wrist.
    var path = Path();
    var length = 0;
    void flush() {
      if (length >= 2) canvas.drawPath(path, line);
      path = Path();
      length = 0;
    }

    for (final joint in _line) {
      final p = at(joint);
      if (p == null) {
        flush();
        continue;
      }
      if (length == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
      length++;
    }
    flush();
  }

  @override
  bool shouldRepaint(SkeletonPainter old) =>
      old.pose != pose ||
      old.good != good ||
      old.mirror != mirror ||
      old.sourceSize != sourceSize;
}

/// The score line: your count, the clock, and theirs.
///
/// Present before the bout as well as during it, showing zeroes and the full
/// duration. Numbers that appear when the countdown ends move the whole layout
/// at the exact moment somebody is trying to start lifting.
