/// A stand-in body that does push-ups on its own.
///
/// The web build has no ML Kit, so this drives the counter and the overlay
/// with a synthetic figure. It is how the screen gets reviewed in a browser
/// without a phone in hand, and it exercises the same code path a camera does.
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'pose.dart';
import 'pose_source.dart';

class DemoPoseSource implements PoseSource {
  final _controller = StreamController<BodyPose>.broadcast();
  Timer? _timer;
  double _phase = 0;

  @override
  Stream<BodyPose> get poses => _controller.stream;

  @override
  bool get isLive => false;

  /// No picture behind it, so the skeleton simply fills whatever box it gets.
  @override
  Size? get sourceSize => null;

  @override
  Widget? buildPreview(BuildContext context) => null;

  @override
  Future<void> start() async {
    _timer?.cancel();
    // 30fps, the rate a mid-range phone manages with pose detection running.
    _timer = Timer.periodic(const Duration(milliseconds: 33), (_) {
      // A rep every four seconds — a deliberate tempo, so the demo shows reps
      // landing rather than tripping the too-fast guard.
      // one is rather than sweeping through like a metronome.
      _phase += 0.033 / 4.0;
      final eased = (1 - math.cos(_phase * 2 * math.pi)) / 2;
      _controller.add(_poseAt(eased));
    });
  }

  @override
  Future<void> dispose() async {
    _timer?.cancel();
    await _controller.close();
  }

  /// [t] runs 0 at the bottom of the push-up to 1 at the top.
  BodyPose _poseAt(double t) {
    double rad(double deg) => deg * math.pi / 180;

    // Elbow angle sweeps the range a real push-up covers.
    final elbow = 80 + t * 95;

    const shoulder = PosePoint(0.55, 0.40, 0.95);
    const elbowPoint = PosePoint(0.42, 0.50, 0.95);
    const hip = PosePoint(0.72, 0.45, 0.95);
    const knee = PosePoint(0.85, 0.50, 0.9);
    const ankle = PosePoint(0.95, 0.54, 0.8);

    final wrist = PosePoint(
      elbowPoint.x + 0.11 * math.cos(rad(elbow)),
      elbowPoint.y + 0.11 * math.sin(rad(elbow)),
      0.95,
    );

    return BodyPose({
      Joint.nose: const PosePoint(0.47, 0.35, 0.9),
      Joint.leftShoulder: shoulder,
      Joint.rightShoulder: shoulder,
      Joint.leftElbow: elbowPoint,
      Joint.rightElbow: elbowPoint,
      Joint.leftWrist: wrist,
      Joint.rightWrist: wrist,
      Joint.leftHip: hip,
      Joint.rightHip: hip,
      Joint.leftKnee: knee,
      Joint.rightKnee: knee,
      Joint.leftAnkle: ankle,
      Joint.rightAnkle: ankle,
    });
  }
}

PoseSource createPoseSource() => DemoPoseSource();
