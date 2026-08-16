import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/exercise.dart';
import 'package:outrepd/reps/pose.dart';
import 'package:outrepd/reps/rep_engine.dart';

/// Builds a pose with an exact elbow angle and an exact body line, so a test
/// can drive the engine through a movement without a camera.
///
/// Only left-side joints carry the measured angles; the right shoulder and hip
/// exist purely so the pose reads as tracked. The mirrored measurement finds
/// no right elbow or knee and falls back to the left side alone.
BodyPose makePose({
  required double elbowAngle,
  double bodyLine = 175,
  double confidence = 0.9,
}) {
  const elbow = PosePoint(0.5, 0.5, 0.9);
  const shoulder = PosePoint(0.6, 0.5, 0.9);
  const hip = PosePoint(0.8, 0.5, 0.9);

  double rad(double deg) => deg * math.pi / 180;

  // The wrist sits one forearm from the elbow, turned by the angle we want.
  final wrist = PosePoint(
    elbow.x + 0.1 * math.cos(rad(elbowAngle)),
    elbow.y + 0.1 * math.sin(rad(elbowAngle)),
    confidence,
  );

  // The shoulder lies along -x from the hip, so turning by the body line angle
  // puts the knee where angleBetween(shoulder, hip, knee) is exactly that.
  final knee = PosePoint(
    hip.x + 0.2 * math.cos(rad(180 - bodyLine)),
    hip.y + 0.2 * math.sin(rad(180 - bodyLine)),
    confidence,
  );

  return BodyPose({
    Joint.leftShoulder: shoulder,
    Joint.rightShoulder: shoulder,
    Joint.leftElbow: elbow,
    Joint.leftWrist: wrist,
    Joint.leftHip: hip,
    Joint.rightHip: hip,
    Joint.leftKnee: knee,
  });
}

/// Drives an engine through positions expressed as meter progress: 0 at the
/// bottom of the movement, 1 at the top.
class Rig {
  Rig(this.exercise) : engine = RepEngine(exercise);

  final ExerciseDef exercise;
  final RepEngine engine;

  Duration clock = Duration.zero;
  RepState? last;

  /// Lifters start at the top of the movement, not folded up.
  double _at = 1.0;

  double _angleFor(double progress) =>
      exercise.bottomAngle +
      progress * (exercise.topAngle - exercise.bottomAngle);

  /// Sit-ups and planks are measured at the hip, push-ups at the elbow. The
  /// rig drives whichever joint the definition names, so one set of helpers
  /// covers every exercise.
  bool get _drivesBodyLine => exercise.driver.vertex == Joint.leftHip;

  void _frame(double progress, double bodyLine, Duration step) {
    final angle = _angleFor(progress);
    clock += step;
    last = engine.update(
      makePose(
        elbowAngle: _drivesBodyLine ? 90 : angle,
        bodyLine: _drivesBodyLine ? angle : bodyLine,
      ),
      clock,
    );
  }

  /// Travels to a position the way a body does — gradually. Teleporting there
  /// and letting the filter catch up would fake a much faster rep than the
  /// timing rules are meant to allow.
  void moveTo(
    double target, {
    int frames = 12,
    Duration step = const Duration(milliseconds: 80),
    double bodyLine = 175,
  }) {
    final from = _at;
    for (var i = 1; i <= frames; i++) {
      _frame(from + (target - from) * (i / frames), bodyLine, step);
    }
    _at = target;
  }

  /// Stays put, for testing jitter and held positions.
  void hold(
    double progress, {
    int frames = 6,
    Duration step = const Duration(milliseconds: 80),
    double bodyLine = 175,
  }) {
    for (var i = 0; i < frames; i++) {
      _frame(progress, bodyLine, step);
    }
    _at = progress;
  }

  /// One clean repetition at a controlled tempo.
  void rep({double bodyLine = 175}) {
    moveTo(0.0, bodyLine: bodyLine);
    moveTo(1.0, bodyLine: bodyLine);
  }

  int get reps => engine.reps;
}

void main() {
  final pushup = kExercises.firstWhere((e) => e.id == 'pushup');
  final situp = kExercises.firstWhere((e) => e.id == 'situp');

  group('a rep only counts on a full, controlled trip', () {
    test('down then all the way up counts once', () {
      final rig = Rig(pushup)..rep();

      expect(rig.reps, 1);
      expect(rig.last!.rejection, isNull);
    });

    test('stopping half way up counts nothing', () {
      final rig = Rig(pushup);
      rig.moveTo(0.0);
      rig.moveTo(0.5);
      rig.moveTo(0.0);

      expect(rig.reps, 0);
    });

    test('never going down counts nothing', () {
      final rig = Rig(pushup);
      rig.moveTo(0.4);
      rig.moveTo(1.0);
      rig.moveTo(0.4);
      rig.moveTo(1.0);

      expect(rig.reps, 0);
    });

    test('three clean reps count three', () {
      final rig = Rig(pushup);
      for (var i = 0; i < 3; i++) {
        rig.rep();
      }

      expect(rig.reps, 3);
    });
  });

  group('the two zones stop double counting', () {
    test('shivering on the bottom boundary scores nothing', () {
      final rig = Rig(pushup);
      rig.moveTo(0.0);
      for (var i = 0; i < 6; i++) {
        rig.hold(0.02, frames: 3);
        rig.hold(0.18, frames: 3);
      }

      expect(rig.reps, 0);
    });

    test('shivering on the top boundary scores one, not many', () {
      final rig = Rig(pushup);
      rig.moveTo(0.0);
      rig.moveTo(0.9);
      for (var i = 0; i < 6; i++) {
        rig.hold(0.88, frames: 3);
        rig.hold(0.82, frames: 3);
      }

      expect(rig.reps, 1);
    });
  });

  test('a bounced rep is rejected as too fast', () {
    final rig = Rig(pushup);
    rig.moveTo(0.0);
    rig.moveTo(1.0, frames: 10, step: const Duration(milliseconds: 15));

    expect(rig.reps, 0);
    expect(rig.last!.rejection, RepRejection.tooFast);
  });

  test('resting at the bottom does not pay for a jerked rep', () {
    final rig = Rig(pushup);
    rig.moveTo(0.0);
    rig.hold(0.0, frames: 40); // a long breather down there
    rig.moveTo(1.0, frames: 10, step: const Duration(milliseconds: 15));

    expect(rig.reps, 0);
    expect(rig.last!.rejection, RepRejection.tooFast);
  });

  group('form gates', () {
    test('a sagging body at the bottom voids the rep', () {
      final rig = Rig(pushup);
      rig.moveTo(0.0, bodyLine: 120);
      rig.moveTo(1.0);

      expect(rig.reps, 0);
      expect(rig.last!.rejection, RepRejection.badForm);
    });

    test('a brief tracker flicker is forgiven', () {
      final rig = Rig(pushup);
      rig.moveTo(0.0);
      rig.moveTo(0.5);
      // 160ms of bad form, under the 300ms grace.
      rig.hold(0.5, frames: 2, bodyLine: 120);
      rig.moveTo(1.0);

      expect(rig.reps, 1);
    });

    test('sustained bad form mid-rep voids it', () {
      final rig = Rig(pushup);
      rig.moveTo(0.0);
      rig.moveTo(0.5);
      // 800ms of bad form, well past the grace.
      rig.hold(0.5, frames: 10, bodyLine: 120);
      rig.moveTo(1.0);

      expect(rig.reps, 0);
      expect(rig.last!.rejection, RepRejection.badForm);
    });

    test('the skeleton reports which rule is broken', () {
      final rig = Rig(pushup);
      rig.hold(0.5, bodyLine: 120);

      expect(rig.last!.formOk, isFalse);
      expect(rig.last!.formMessage, contains('straight line'));
    });
  });

  test('movements that fold the other way still count', () {
    // Sit-ups run from a wide angle at the bottom to a narrow one at the top,
    // the opposite of a push-up. The meter has to follow either direction.
    final rig = Rig(situp)
      ..rep()
      ..rep();

    expect(rig.reps, 2);
  });

  group('tracking', () {
    test('a body out of frame pauses instead of scoring', () {
      final engine = RepEngine(pushup);
      final state = engine.update(BodyPose.empty, const Duration(seconds: 1));

      expect(state.tracked, isFalse);
      expect(state.reps, 0);
      expect(state.formMessage, isNotNull);
    });

    test('reps survive a gap in tracking', () {
      final rig = Rig(pushup)..rep();
      expect(rig.reps, 1);

      // The camera loses the lifter for a moment.
      rig.clock += const Duration(seconds: 2);
      rig.engine.update(BodyPose.empty, rig.clock);

      rig.rep();
      expect(rig.reps, 2);
    });
  });

  group('calibration', () {
    test('one slow rep narrows the range to this lifter', () {
      final rig = Rig(pushup);
      rig.engine.startCalibration();
      rig.rep();
      final learned = rig.engine.finishCalibration();

      expect(learned, isTrue);
      // The trimmed range sits inside the raw travel it watched.
      expect(rig.engine.bottomAngle, greaterThan(pushup.bottomAngle));
      expect(rig.engine.topAngle, lessThan(pushup.topAngle));
    });

    test('standing still teaches nothing and is refused', () {
      final rig = Rig(pushup);
      rig.engine.startCalibration();
      rig.hold(0.5, frames: 20);

      expect(rig.engine.finishCalibration(), isFalse);
      // Falls back to the definition rather than a range of nothing.
      expect(rig.engine.bottomAngle, pushup.bottomAngle);
      expect(rig.engine.topAngle, pushup.topAngle);
    });
  });

  test('a hold scores seconds, and only while the shape is right', () {
    final plank = kExercises.firstWhere((e) => e.id == 'plank');
    final rig = Rig(plank);

    rig.hold(1.0, frames: 10); // 800ms of a good plank
    final good = rig.engine.holdSeconds;
    expect(good, greaterThan(0.5));

    rig.hold(0.0, frames: 10); // hips dropped
    expect(rig.engine.holdSeconds, closeTo(good, 0.001));
  });
}
