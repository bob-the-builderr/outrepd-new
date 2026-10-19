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

/// Arms and torso, ending at the hips. No legs: with the phone on the floor
/// facing the lifter the knees and ankles are hidden in most frames, so the
/// tracker guesses at them and their bones swung about over the floor; and
/// the counter never reads them.
const _bones = <List<Joint>>[
  [Joint.leftShoulder, Joint.rightShoulder],
  [Joint.leftShoulder, Joint.leftElbow],
  [Joint.leftElbow, Joint.leftWrist],
  [Joint.rightShoulder, Joint.rightElbow],
  [Joint.rightElbow, Joint.rightWrist],
  [Joint.leftShoulder, Joint.leftHip],
  [Joint.rightShoulder, Joint.rightHip],
  [Joint.leftHip, Joint.rightHip],
];

/// The joints given a dot: those the bones above join. The nose feeds the
/// counter but has no bone to it, so its dot would float on the face; the
/// legs are not drawn at all.
final _dotted = {for (final bone in _bones) ...bone};

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

    final bone = Paint()
      ..color = colour.withValues(alpha: 0.9 * strength)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final glow = Paint()
      ..color = colour.withValues(alpha: 0.3 * strength)
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    for (final pair in _bones) {
      final a = at(pair[0]);
      final b = at(pair[1]);
      if (a == null || b == null) continue;
      canvas.drawLine(a, b, glow);
      canvas.drawLine(a, b, bone);
    }

    final dot = Paint()..color = Colors.white.withValues(alpha: strength);
    final ring = Paint()..color = colour.withValues(alpha: strength);

    for (final joint in _dotted) {
      final p = at(joint);
      if (p == null) continue;
      canvas.drawCircle(p, 8, ring);
      canvas.drawCircle(p, 4.5, dot);
    }
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
