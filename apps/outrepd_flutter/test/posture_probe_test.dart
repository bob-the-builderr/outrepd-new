/// What a body on the floor reads like, against a body standing up.
///
/// The green skeleton and the count were both gated on "is the body in a
/// straight line" — which a person standing in front of the camera passes
/// perfectly. This prints candidate measurements over the real push-up
/// recordings so the threshold that replaces it comes from numbers.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/pose.dart';
import 'package:outrepd/reps/recording.dart';

const _folder = String.fromEnvironment(
  'PUSHUPS',
  defaultValue: 'D:/pushup-poses',
);

void main() {
  test('how a push-up reads, and how standing reads', () {
    final dir = Directory(_folder);
    if (!dir.existsSync()) return;

    final rows = <String>[];
    for (final file in dir.listSync().whereType<File>()) {
      if (!file.path.endsWith('.json')) continue;

      final recording = PoseRecording.fromJson(
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
      );

      final arms = <double>[];
      for (final frame in recording.frames) {
        final a = _armToBody(frame.pose);
        if (a != null) arms.add(a);
      }
      if (arms.isEmpty) continue;

      final poses = [for (final f in recording.frames) f.pose];
      rows.add('${file.uri.pathSegments.last.padRight(22)}'
          'armToBody ${_quantiles(arms)}   '
          'handsMove ${_quantiles(_handMotion(poses))}');
    }

    // ignore: avoid_print
    print('\n--- shoulder-to-ankle drop, in torso lengths ---\n'
        '${rows.join('\n')}\n'
        'standing (synthetic): armToBody '
        '${_armToBody(_standing())!.toStringAsFixed(0)}  handsVsFeet '
        '${_handsVsFeet(_standing())!.toStringAsFixed(2)}\n'
        'push-up (synthetic):  armToBody '
        '${_armToBody(_onTheFloor())!.toStringAsFixed(0)}  handsVsFeet '
        '${_handsVsFeet(_onTheFloor())!.toStringAsFixed(2)}\n');
  });
}

String _quantiles(List<double> values) {
  if (values.isEmpty) return 'none';
  final sorted = [...values]..sort();
  double at(double f) =>
      sorted[(f * (sorted.length - 1)).round().clamp(0, sorted.length - 1)];
  return 'p05 ${at(0.05).toStringAsFixed(2)}  '
      'med ${at(0.5).toStringAsFixed(2)}  '
      'p95 ${at(0.95).toStringAsFixed(2)}';
}

/// The angle between the arm and the body, at the shoulder, in degrees.
///
/// A push-up holds the arms across the body line to carry it: near ninety.
/// Standing with the arms at the sides, arm and body point the same way: near
/// zero. It is a shape rather than a position, so tilting the camera does not
/// move it the way every image-height measure moves.
double? _armToBody(BodyPose pose) {
  final shoulder = _mid(pose, Joint.leftShoulder, Joint.rightShoulder);
  final wrist = _mid(pose, Joint.leftWrist, Joint.rightWrist);
  final hip = _mid(pose, Joint.leftHip, Joint.rightHip);
  if (shoulder == null || wrist == null || hip == null) return null;

  final arm = (wrist.$1 - shoulder.$1, wrist.$2 - shoulder.$2);
  final body = (hip.$1 - shoulder.$1, hip.$2 - shoulder.$2);
  final armLen = math.sqrt(arm.$1 * arm.$1 + arm.$2 * arm.$2);
  final bodyLen = math.sqrt(body.$1 * body.$1 + body.$2 * body.$2);
  if (armLen < 0.01 || bodyLen < 0.01) return null;

  final cos =
      ((arm.$1 * body.$1 + arm.$2 * body.$2) / (armLen * bodyLen)).clamp(-1.0, 1.0);
  return math.acos(cos) * 180 / math.pi;
}

/// How far the hands travel over a short window, in torso lengths.
///
/// A push-up plants them: whatever the camera angle, the wrists barely move
/// while the body does. Standing, walking up to the phone and lowering onto
/// the floor all move them a long way.
List<double> _handMotion(List<BodyPose> poses, {int window = 10}) {
  final wrists = [
    for (final p in poses) _mid(p, Joint.leftWrist, Joint.rightWrist),
  ];
  final torsos = <double?>[
    for (final p in poses)
      () {
        final s = _mid(p, Joint.leftShoulder, Joint.rightShoulder);
        final h = _mid(p, Joint.leftHip, Joint.rightHip);
        if (s == null || h == null) return null;
        final t = _distance(s, h);
        return t < 0.02 ? null : t;
      }(),
  ];

  final out = <double>[];
  for (var i = window; i < poses.length; i++) {
    final now = wrists[i], then = wrists[i - window], torso = torsos[i];
    if (now == null || then == null || torso == null) continue;
    out.add(_distance(now, then) / torso);
  }
  return out;
}

/// Where the hands are against the feet, in torso lengths.
///
/// In a push-up both are on the floor, so this sits near zero whatever angle
/// the camera has. Standing, the hands hang about two torso lengths above the
/// feet — and that gap is the thing a straight-body rule could never see.
double? _handsVsFeet(BodyPose pose) {
  final shoulder = _mid(pose, Joint.leftShoulder, Joint.rightShoulder);
  final hip = _mid(pose, Joint.leftHip, Joint.rightHip);
  final wrist = _mid(pose, Joint.leftWrist, Joint.rightWrist);
  final ankle = _mid(pose, Joint.leftAnkle, Joint.rightAnkle);
  if (shoulder == null || hip == null || wrist == null || ankle == null) {
    return null;
  }

  final torso = _distance(shoulder, hip);
  if (torso < 0.02) return null;
  return (wrist.$2 - ankle.$2) / torso;
}

(double, double)? _mid(BodyPose pose, Joint a, Joint b) {
  final pa = pose.confident(a);
  final pb = pose.confident(b);
  if (pa != null && pb != null) return ((pa.x + pb.x) / 2, (pa.y + pb.y) / 2);
  final one = pa ?? pb;
  return one == null ? null : (one.x, one.y);
}

double _distance((double, double) a, (double, double) b) =>
    math.sqrt(math.pow(a.$1 - b.$1, 2) + math.pow(a.$2 - b.$2, 2));

/// A person standing in front of the phone, arms at their sides.
BodyPose _standing() {
  PosePoint at(double x, double y) => PosePoint(x, y, 0.95);
  return BodyPose({
    Joint.nose: at(240, 60),
    Joint.leftShoulder: at(210, 120),
    Joint.rightShoulder: at(270, 120),
    Joint.leftElbow: at(205, 180),
    Joint.rightElbow: at(275, 180),
    Joint.leftWrist: at(200, 240),
    Joint.rightWrist: at(280, 240),
    Joint.leftHip: at(215, 250),
    Joint.rightHip: at(265, 250),
    Joint.leftKnee: at(215, 380),
    Joint.rightKnee: at(265, 380),
    Joint.leftAnkle: at(215, 500),
    Joint.rightAnkle: at(265, 500),
  });
}

/// The same person in a push-up, seen from the floor.
BodyPose _onTheFloor() {
  PosePoint at(double x, double y) => PosePoint(x, y, 0.95);
  return BodyPose({
    Joint.nose: at(240, 120),
    Joint.leftShoulder: at(200, 200),
    Joint.rightShoulder: at(280, 200),
    Joint.leftElbow: at(190, 260),
    Joint.rightElbow: at(290, 260),
    Joint.leftWrist: at(185, 320),
    Joint.rightWrist: at(295, 320),
    Joint.leftHip: at(210, 340),
    Joint.rightHip: at(270, 340),
    Joint.leftKnee: at(210, 440),
    Joint.rightKnee: at(270, 440),
    Joint.leftAnkle: at(210, 540),
    Joint.rightAnkle: at(270, 540),
  });
}
