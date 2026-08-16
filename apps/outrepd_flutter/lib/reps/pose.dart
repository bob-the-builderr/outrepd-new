/// A body pose, independent of whatever produced it. The counting engine runs
/// on this rather than on ML Kit's types so it can be driven by test data and
/// by the on-screen demo without a camera attached.
library;

import 'dart:math' as math;

/// The joints the counter needs. ML Kit tracks more; these are the ones any of
/// our exercise definitions can reach for.
enum Joint {
  nose,
  leftShoulder,
  rightShoulder,
  leftElbow,
  rightElbow,
  leftWrist,
  rightWrist,
  leftHip,
  rightHip,
  leftKnee,
  rightKnee,
  leftAnkle,
  rightAnkle,
}

/// Left/right pairs, so an exercise can be defined once and measured on
/// whichever side the camera can actually see.
const jointMirror = <Joint, Joint>{
  Joint.leftShoulder: Joint.rightShoulder,
  Joint.rightShoulder: Joint.leftShoulder,
  Joint.leftElbow: Joint.rightElbow,
  Joint.rightElbow: Joint.leftElbow,
  Joint.leftWrist: Joint.rightWrist,
  Joint.rightWrist: Joint.leftWrist,
  Joint.leftHip: Joint.rightHip,
  Joint.rightHip: Joint.leftHip,
  Joint.leftKnee: Joint.rightKnee,
  Joint.rightKnee: Joint.leftKnee,
  Joint.leftAnkle: Joint.rightAnkle,
  Joint.rightAnkle: Joint.leftAnkle,
};

/// One tracked point, in normalised image space: 0,0 top-left to 1,1
/// bottom-right. Normalised so the maths does not care about resolution or
/// how the preview is letterboxed on screen.
class PosePoint {
  const PosePoint(this.x, this.y, this.confidence, [this.z = 0]);

  final double x;
  final double y;

  /// Depth, roughly relative to the hips, in the same units as [x]. Negative
  /// is toward the camera.
  ///
  /// This is what lets the phone stand in front of the lifter instead of off
  /// to one side: facing the camera, a pressing arm moves mostly toward the
  /// lens, and a flat picture squashes that motion into almost nothing. It is
  /// an estimate from a single lens, so it is noisier than [x] and [y] — good
  /// enough to keep an angle honest, not good enough to measure with.
  final double z;

  /// 0..1. Low values mean the joint is guessed rather than seen — usually
  /// because it is out of frame or behind the body.
  final double confidence;
}

class BodyPose {
  const BodyPose(this.points);

  final Map<Joint, PosePoint> points;

  static const empty = BodyPose({});

  PosePoint? operator [](Joint joint) => points[joint];

  /// A point is only usable if the tracker is reasonably sure of it. Counting
  /// off a guessed joint is how phantom reps happen.
  ///
  /// The bar is deliberately high for measurement. Drawing the skeleton passes
  /// a lower one — a limb that flickers out of the picture is better than one
  /// that flickers out of the score.
  PosePoint? confident(Joint joint, {double min = 0.7}) {
    final p = points[joint];
    return p != null && p.confidence >= min ? p : null;
  }

  /// Whether enough of the body is visible to judge anything at all. Used to
  /// pause the round rather than let a half-visible lifter score.
  bool get isTracked {
    const core = [
      Joint.leftShoulder,
      Joint.rightShoulder,
      Joint.leftHip,
      Joint.rightHip,
    ];
    return core.where((j) => confident(j) != null).length >= 3;
  }
}

/// Angle in degrees at [vertex], between the arms going out to [a] and [b].
/// 180 is a straight limb, 0 is folded shut.
///
/// Measured in three dimensions so it survives a limb pointing at the camera.
/// With depth left at zero this is the ordinary flat-picture angle.
double angleBetween(PosePoint a, PosePoint vertex, PosePoint b) {
  final abx = a.x - vertex.x;
  final aby = a.y - vertex.y;
  final abz = a.z - vertex.z;
  final cbx = b.x - vertex.x;
  final cby = b.y - vertex.y;
  final cbz = b.z - vertex.z;

  final dot = abx * cbx + aby * cby + abz * cbz;
  final magA = math.sqrt(abx * abx + aby * aby + abz * abz);
  final magB = math.sqrt(cbx * cbx + cby * cby + cbz * cbz);
  if (magA == 0 || magB == 0) return 180;

  final cos = (dot / (magA * magB)).clamp(-1.0, 1.0);
  return math.acos(cos) * 180 / math.pi;
}

/// Smooths a stream of readings so tracker jitter does not rattle the meter or
/// trip a zone boundary twice. A plain exponential filter — cheap, and it adds
/// only a frame or two of lag at this weight.
class Smoothed {
  Smoothed({this.weight = 0.4});

  /// How much of each new reading to take. Lower is steadier but laggier.
  final double weight;

  double? _value;

  double get value => _value ?? 0;
  bool get hasValue => _value != null;

  double add(double reading) {
    final v = _value;
    return _value = v == null ? reading : v + (reading - v) * weight;
  }

  void reset() => _value = null;
}
