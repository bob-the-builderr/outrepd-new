/// Synthetic bodies for the counter tests, laid out the way the phone sees
/// one: propped on the floor a metre in front, the lifter facing it.
///
/// The proportions are the measured ones, because proportions are what the
/// counter reads. On every labelled set, at lockout the nose sits about one
/// shoulder width above the planted hands (0.9–1.1), and at the bottom of a
/// full rep about a tenth of one. The bodies these tests used to draw had the
/// nose nine shoulder widths above the hands — no person the counter has ever
/// been shown — so they tested a counter against a body that does not exist.
///
/// Coordinates are shares of the frame, as the app's own are.
library;

import 'dart:math' as math;

import 'package:outrepd/reps/pose.dart';
import 'package:outrepd/reps/recording.dart';

/// Thirty poses a second, what a phone delivers.
const kFrameMs = 33;

/// Shoulder width, as a share of the frame.
const _width = 0.30;

/// Where the hands are planted, top to bottom of the frame.
const _floor = 0.72;

/// The nose's height above the hands at lockout and at the bottom of a full
/// rep, in shoulder widths.
const kLockoutHeight = 1.0;
const kBottomHeight = 0.1;

PosePoint _at(double x, double y) => PosePoint(x, y, 0.95);

/// A body in a push-up, [up] running 0 at the bottom of a full rep to 1 at
/// lockout. [handShift] moves both hands sideways, in shoulder widths.
BodyPose pushUpPose(double up, {double handShift = 0}) {
  final height = kBottomHeight + (kLockoutHeight - kBottomHeight) * up;
  final nose = _floor - height * _width;
  final shoulders = nose + 0.05;
  // Head-on, the torso points away from the lens and foreshortens to almost
  // nothing: the hips sit just above the shoulders in the picture.
  final hips = shoulders - 0.06;
  final shift = handShift * _width;
  return BodyPose({
    Joint.nose: _at(0.50, nose),
    Joint.leftShoulder: _at(0.35, shoulders),
    Joint.rightShoulder: _at(0.65, shoulders),
    Joint.leftElbow: _at(0.27, (shoulders + _floor) / 2),
    Joint.rightElbow: _at(0.73, (shoulders + _floor) / 2),
    Joint.leftWrist: _at(0.33 + shift, _floor),
    Joint.rightWrist: _at(0.67 + shift, _floor),
    Joint.leftHip: _at(0.44, hips),
    Joint.rightHip: _at(0.56, hips),
    Joint.leftKnee: _at(0.46, hips - 0.03),
    Joint.rightKnee: _at(0.54, hips - 0.03),
    Joint.leftAnkle: _at(0.47, hips - 0.05),
    Joint.rightAnkle: _at(0.53, hips - 0.05),
  });
}

/// Somebody stood in front of the phone, arms at their sides.
BodyPose standingPose() => BodyPose({
  Joint.nose: _at(0.50, 0.10),
  Joint.leftShoulder: _at(0.42, 0.20),
  Joint.rightShoulder: _at(0.58, 0.20),
  Joint.leftElbow: _at(0.41, 0.34),
  Joint.rightElbow: _at(0.59, 0.34),
  Joint.leftWrist: _at(0.40, 0.48),
  Joint.rightWrist: _at(0.60, 0.48),
  Joint.leftHip: _at(0.44, 0.50),
  Joint.rightHip: _at(0.56, 0.50),
  Joint.leftKnee: _at(0.44, 0.70),
  Joint.rightKnee: _at(0.56, 0.70),
  Joint.leftAnkle: _at(0.44, 0.90),
  Joint.rightAnkle: _at(0.56, 0.90),
});

/// On their feet, arms held out in front, going up and down — a squat, a bob,
/// or somebody trying to see what the app will count. [up] is 1 standing tall
/// and 0 at the bottom. The hands go up and down with the body.
BodyPose squatPose(double up) {
  final drop = (1 - up) * 0.2;
  return BodyPose({
    Joint.nose: _at(0.50, 0.10 + drop),
    Joint.leftShoulder: _at(0.42, 0.20 + drop),
    Joint.rightShoulder: _at(0.58, 0.20 + drop),
    Joint.leftElbow: _at(0.36, 0.22 + drop),
    Joint.rightElbow: _at(0.64, 0.22 + drop),
    Joint.leftWrist: _at(0.30, 0.24 + drop),
    Joint.rightWrist: _at(0.70, 0.24 + drop),
    Joint.leftHip: _at(0.44, 0.50 + drop),
    Joint.rightHip: _at(0.56, 0.50 + drop),
    Joint.leftKnee: _at(0.44, 0.70 + drop * 0.3),
    Joint.rightKnee: _at(0.56, 0.70 + drop * 0.3),
    Joint.leftAnkle: _at(0.44, 0.90),
    Joint.rightAnkle: _at(0.56, 0.90),
  });
}

/// Every joint of [from] moved [t] of the way to [to].
BodyPose between(BodyPose from, BodyPose to, double t) => BodyPose({
  for (final joint in from.points.keys)
    if (to.points[joint] case final end?)
      joint: PosePoint(
        from.points[joint]!.x + (end.x - from.points[joint]!.x) * t,
        from.points[joint]!.y + (end.y - from.points[joint]!.y) * t,
        0.95,
      ),
});

/// The walk down onto the hands: the largest single movement in a session,
/// bigger than any rep, and the reason it used to be scored as one.
List<BodyPose> gettingDown({int frames = 25}) => [
  for (var i = 0; i < frames; i++)
    between(standingPose(), pushUpPose(1), i / (frames - 1)),
];

/// Getting up off the floor after the last rep, the way people do: down onto
/// the knees, hands up off the floor, then on to their feet. The head goes
/// down past the bottom line and back up past the top one — a full swing —
/// with the hands off the floor for the second half of it.
List<BodyPose> gettingUp() {
  // On the knees, hands come up off the floor toward the chest, head still
  // below the top line.
  final kneeling = BodyPose({
    Joint.nose: _at(0.50, 0.60),
    Joint.leftShoulder: _at(0.36, 0.64),
    Joint.rightShoulder: _at(0.64, 0.64),
    Joint.leftElbow: _at(0.30, 0.62),
    Joint.rightElbow: _at(0.70, 0.62),
    Joint.leftWrist: _at(0.38, 0.52),
    Joint.rightWrist: _at(0.62, 0.52),
    Joint.leftHip: _at(0.44, 0.70),
    Joint.rightHip: _at(0.56, 0.70),
    Joint.leftKnee: _at(0.44, 0.85),
    Joint.rightKnee: _at(0.56, 0.85),
    Joint.leftAnkle: _at(0.44, 0.90),
    Joint.rightAnkle: _at(0.56, 0.90),
  });
  return [
    for (var i = 0; i < 12; i++) pushUpPose(1 - i / 11),
    for (var i = 0; i < 8; i++) between(pushUpPose(0), kneeling, i / 7),
    for (var i = 0; i < 20; i++) between(kneeling, standingPose(), i / 19),
    for (var i = 0; i < 15; i++) standingPose(),
  ];
}

/// Where a rep is at [f] of the way through it: from the top, down, and back.
/// [depth] is how far down it goes — 1 all the way, 0.45 a half rep.
double repShape(double f, {double depth = 1}) =>
    1 - depth * (1 - math.cos(f * 2 * math.pi)) / 2;

/// A set of [reps] push-ups, [framesPerRep] frames each, with a moment at the
/// top before and after.
List<BodyPose> pushUpSet(
  int reps, {
  int framesPerRep = 30,
  double depth = 1,
  int lead = 15,
  int tail = 10,
}) => [
  for (var i = 0; i < lead; i++) pushUpPose(1),
  for (var rep = 0; rep < reps; rep++)
    for (var f = 0; f < framesPerRep; f++)
      pushUpPose(repShape(f / framesPerRep, depth: depth)),
  for (var i = 0; i < tail; i++) pushUpPose(1),
];

/// Poses stamped the way the screen stamps them, [frameMs] apart.
List<RecordedFrame> timed(List<BodyPose> poses, {int frameMs = kFrameMs}) => [
  for (var i = 0; i < poses.length; i++) RecordedFrame(i * frameMs, poses[i]),
];
