/// The skeleton over the camera: one line, wrist to wrist over the shoulders,
/// broken where the tracker cannot see a joint rather than cut straight
/// across it.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/pose.dart';
import 'package:outrepd/reps/skeleton.dart';

BodyPose _arms({bool leftElbow = true}) {
  PosePoint at(double x, double y) => PosePoint(x, y, 0.95);
  return BodyPose({
    Joint.nose: at(0.5, 0.45),
    Joint.leftShoulder: at(0.3, 0.55),
    Joint.rightShoulder: at(0.7, 0.55),
    if (leftElbow) Joint.leftElbow: at(0.15, 0.62),
    Joint.rightElbow: at(0.85, 0.62),
    Joint.leftWrist: at(0.12, 0.78),
    Joint.rightWrist: at(0.88, 0.78),
    Joint.leftHip: at(0.4, 0.62),
    Joint.rightHip: at(0.6, 0.62),
  });
}

Widget _paint(BodyPose pose) => Directionality(
  textDirection: TextDirection.ltr,
  child: Center(
    child: CustomPaint(
      size: const Size(400, 800),
      painter: SkeletonPainter(
        pose: pose,
        good: true,
        mirror: false,
        sourceSize: null,
      ),
    ),
  ),
);

void main() {
  testWidgets('one thick line and no dots', (tester) async {
    await tester.pumpWidget(_paint(_arms()));
    final painted = find.byType(CustomPaint).last;
    expect(painted, paints..path());
    expect(painted, isNot(paints..path()..path()));
    expect(painted, isNot(paints..circle()));
  });

  testWidgets('a joint it cannot see breaks the line', (tester) async {
    await tester.pumpWidget(_paint(_arms(leftElbow: false)));
    final painted = find.byType(CustomPaint).last;
    // The left wrist alone is no line; shoulders to the right wrist is one.
    expect(painted, paints..path());
    expect(painted, isNot(paints..path()..path()));
    expect(tester.takeException(), isNull);
  });
}
