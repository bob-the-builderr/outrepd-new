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
  ///
  /// Head-on, the way the phone sees a lifter: propped on the floor in front
  /// of them. The counter reads the nose's height above the planted hands in
  /// shoulder widths, so the proportions are the measured ones, the same as
  /// the counter tests' bodies: about one shoulder width at lockout and a
  /// tenth of one at the bottom of a full rep. A side-on figure has both
  /// shoulders on one point and no width at all, and was never counted.
  BodyPose _poseAt(double t) {
    const width = 0.30;
    const floor = 0.72;
    final height = 0.1 + 0.9 * t;
    final nose = floor - height * width;
    final shoulders = nose + 0.05;
    // The torso points away from the lens and foreshortens to almost nothing.
    final hips = shoulders - 0.06;

    PosePoint at(double x, double y) => PosePoint(x, y, 0.95);

    return BodyPose({
      Joint.nose: at(0.50, nose),
      Joint.leftShoulder: at(0.35, shoulders),
      Joint.rightShoulder: at(0.65, shoulders),
      Joint.leftElbow: at(0.27, (shoulders + floor) / 2),
      Joint.rightElbow: at(0.73, (shoulders + floor) / 2),
      Joint.leftWrist: at(0.33, floor),
      Joint.rightWrist: at(0.67, floor),
      Joint.leftHip: at(0.44, hips),
      Joint.rightHip: at(0.56, hips),
      Joint.leftKnee: at(0.46, hips - 0.03),
      Joint.rightKnee: at(0.54, hips - 0.03),
      Joint.leftAnkle: at(0.47, hips - 0.05),
      Joint.rightAnkle: at(0.53, hips - 0.05),
    });
  }
}

PoseSource createPoseSource() => DemoPoseSource();
