import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/driver_finder.dart';
import 'package:outrepd/reps/pose.dart';

/// A body where the elbow and the knee can be swung independently, so a test
/// can stage a movement that is clearly about one joint and check that the
/// finder picks that one out of all the candidates.
BodyPose limbs({required double elbow, required double knee}) {
  double rad(double deg) => deg * math.pi / 180;

  const shoulder = PosePoint(0.6, 0.4, 0.95);
  const elbowPt = PosePoint(0.5, 0.5, 0.95);
  const hip = PosePoint(0.75, 0.5, 0.95);
  const kneePt = PosePoint(0.85, 0.62, 0.95);

  // Wrist turned by the elbow angle, ankle turned by the knee angle.
  final wrist = PosePoint(
    elbowPt.x + 0.11 * math.cos(rad(elbow)),
    elbowPt.y + 0.11 * math.sin(rad(elbow)),
    0.95,
  );
  final ankle = PosePoint(
    kneePt.x + 0.13 * math.cos(rad(knee)),
    kneePt.y + 0.13 * math.sin(rad(knee)),
    0.95,
  );

  return BodyPose({
    Joint.nose: const PosePoint(0.55, 0.34, 0.9),
    Joint.leftShoulder: shoulder,
    Joint.rightShoulder: shoulder,
    Joint.leftElbow: elbowPt,
    Joint.leftWrist: wrist,
    Joint.leftHip: hip,
    Joint.rightHip: hip,
    Joint.leftKnee: kneePt,
    Joint.leftAnkle: ankle,
  });
}

/// [reps] cycles of a smooth swing, sampled the way a camera would.
List<BodyPose> swing({
  required int reps,
  required double elbowFrom,
  required double elbowTo,
  required double kneeFrom,
  required double kneeTo,
  int framesPerRep = 45,
}) {
  return [
    for (var i = 0; i < reps * framesPerRep; i++)
      () {
        final phase = (i % framesPerRep) / framesPerRep;
        final t = (1 - math.cos(phase * 2 * math.pi)) / 2;
        return limbs(
          elbow: elbowFrom + (elbowTo - elbowFrom) * t,
          knee: kneeFrom + (kneeTo - kneeFrom) * t,
        );
      }(),
  ];
}

void main() {
  group('the driver is whichever joint carries the rhythm', () {
    test('a movement at the elbow is found at the elbow', () {
      final guess = findDriver(swing(
        reps: 5,
        elbowFrom: 85,
        elbowTo: 170,
        kneeFrom: 175,
        kneeTo: 175, // legs still
      ));

      expect(guess, isNotNull);
      expect(guess!.spec.vertex, Joint.leftElbow);
      // Trimming pulls the ends in, so this is well short of the full swing —
      // it only has to show a real range was found, not the exact travel.
      expect(guess.high - guess.low, greaterThan(30));
    });

    test('a movement at the knee is found at the knee', () {
      final guess = findDriver(swing(
        reps: 5,
        elbowFrom: 160,
        elbowTo: 160, // arms still
        kneeFrom: 95,
        kneeTo: 170,
      ));

      expect(guess, isNotNull);
      expect(guess!.spec.vertex, Joint.leftKnee);
    });

    test('the joint with the steadier rhythm wins when both move', () {
      // The elbow swings once and stops; the knee keeps time throughout. Range
      // alone would pick the elbow, which is exactly the mistake to avoid.
      final frames = <BodyPose>[
        ...swing(
          reps: 1,
          elbowFrom: 60,
          elbowTo: 175,
          kneeFrom: 100,
          kneeTo: 168,
        ),
        ...swing(
          reps: 4,
          elbowFrom: 175,
          elbowTo: 175,
          kneeFrom: 100,
          kneeTo: 168,
        ),
      ];

      expect(findDriver(frames)!.spec.vertex, Joint.leftKnee);
    });
  });

  group('it refuses rather than guessing', () {
    test('standing still is not a movement', () {
      final guess = findDriver(swing(
        reps: 5,
        elbowFrom: 160,
        elbowTo: 160,
        kneeFrom: 175,
        kneeTo: 175,
      ));

      expect(guess, isNull);
    });

    test('too few frames to judge', () {
      expect(findDriver(swing(reps: 1, elbowFrom: 85, elbowTo: 170,
          kneeFrom: 175, kneeTo: 175, framesPerRep: 20)), isNull);
    });

    test('a body the camera cannot see is not scored', () {
      final blind = List.filled(200, BodyPose.empty);
      expect(findDriver(blind), isNull);
    });
  });

  test('the guess converts to a definition the engine can run', () {
    final guess = findDriver(swing(
      reps: 5,
      elbowFrom: 85,
      elbowTo: 170,
      kneeFrom: 175,
      kneeTo: 175,
    ))!;

    final def = guess.toDefinition(id: 'learned', name: 'My movement');

    expect(def.driver.vertex, Joint.leftElbow);
    expect(def.bottomAngle, lessThan(def.topAngle));
    // Form rules cannot be inferred from a rhythm, so it claims none.
    expect(def.gates, isEmpty);
  });
}
