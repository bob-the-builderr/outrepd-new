/// The lifter's own camera, second by second.
///
/// Two videos filmed with the phone where it actually sits during a set: one
/// of ten push-ups with a walk-up and a walk-away either side, and one of
/// somebody standing in front of the camera moving up and down — the movement
/// that was being counted and should not be.
///
/// This prints what every check reads through both, so the thresholds come
/// from this body at this angle rather than from footage off the internet.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/pose.dart';
import 'package:outrepd/reps/posture.dart';
import 'package:outrepd/reps/pushup_counter.dart';
import 'package:outrepd/reps/recording.dart';

const _folder = String.fromEnvironment(
  'USER_SETS',
  defaultValue: 'D:/outrepd-recordings/user',
);

const _pushUps = 'VID_20260921210358.json';
const _bobbing = 'VID_20260921210455.json';

void main() {
  test('what the checks read, second by second', () {
    for (final name in [_pushUps, _bobbing]) {
      final file = File('$_folder/$name');
      if (!file.existsSync()) {
        // ignore: avoid_print
        print('missing $name');
        continue;
      }

      final recording = PoseRecording.fromJson(
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
      );
      final poses = [for (final f in recording.frames) f.pose];
      final marks = inPushUpPosition(poses);
      final counted = countPushups(poses);

      final lines = <String>[];
      // A row a second: 25 frames per second in these recordings.
      for (var start = 0; start < poses.length; start += 25) {
        final end = math.min(start + 25, poses.length);
        final arms = <double>[];
        final hands = <double>[];
        final bodies = <double>[];
        var inPosition = 0;
        var tracked = 0;

        for (var i = start; i < end; i++) {
          if (poses[i].isTracked) tracked++;
          final a = _torsoRatio(poses[i]);
          if (a != null) arms.add(a);
          final h = handTravel([for (final p in poses) midpoint(p, Joint.leftWrist, Joint.rightWrist)], [for (final p in poses) shoulderWidth(p)], i);
          if (h != null) hands.add(h);
          final b = _bodyLine(poses[i]);
          if (b != null) bodies.add(b);
          if (marks[i]) inPosition++;
        }

        final handsVsFeet = <double>[];
        final headVsHands = <double>[];
        for (var i = start; i < end; i++) {
          final a = _hipVsShoulder(poses[i]);
          if (a != null) handsVsFeet.add(a);
          final b = _headVsHands(poses[i]);
          if (b != null) headVsHands.add(b);
        }

        lines.add('  ${(start / 25).toStringAsFixed(0).padLeft(3)}s  '
            'tracked ${tracked.toString().padLeft(2)}/25  '
            'torso ${_median(arms, digits: 2)}  '
            'hands ${_median(hands, digits: 2)}  '
            'body ${_median(bodies)}  '
            'hip-v-sh ${_median(handsVsFeet, digits: 2)}  '
            'head-hands ${_median(headVsHands, digits: 2)}  '
            'in ${inPosition.toString().padLeft(2)}/25');
      }

      // Which joints the tracker can actually see, over the whole recording.
      // A rule built on a joint that is not there is a rule that never fires.
      final seen = <Joint, int>{};
      for (final pose in poses) {
        for (final joint in const [
          Joint.nose,
          Joint.leftShoulder,
          Joint.leftElbow,
          Joint.leftWrist,
          Joint.leftHip,
          Joint.leftKnee,
          Joint.leftAnkle,
        ]) {
          if (pose.confident(joint) != null) {
            seen[joint] = (seen[joint] ?? 0) + 1;
          }
        }
      }

      // ignore: avoid_print
      print('\n=== $name (${poses.length} frames, '
          'lifter says ${recording.note ?? '?'}) ===\n'
          '  visible: ${[
        for (final e in seen.entries)
          '${e.key.name} ${(e.value * 100 / poses.length).round()}%'
      ].join('  ')}\n'
          '${lines.join('\n')}\n'
          '  counted ${counted.reps}  confident ${counted.confident}  '
          '${counted.perSignal}\n'
          '  start line ${setStartsAt(poses)}\n');
    }
  });
}

String _median(List<double> values, {int digits = 0}) {
  if (values.isEmpty) return '   —';
  final sorted = [...values]..sort();
  return sorted[sorted.length ~/ 2].toStringAsFixed(digits).padLeft(4);
}

/// Shoulder–hip–knee: a plank reads near straight, a fold reads low.
double? _bodyLine(BodyPose pose) {
  final shoulder = pose.confident(Joint.leftShoulder) ??
      pose.confident(Joint.rightShoulder);
  final hip = pose.confident(Joint.leftHip) ?? pose.confident(Joint.rightHip);
  final knee =
      pose.confident(Joint.leftKnee) ?? pose.confident(Joint.rightKnee);
  if (shoulder == null || hip == null || knee == null) return null;
  return angleBetween(shoulder, hip, knee);
}



/// How far the head is from the hands, in torso lengths. A push-up brings
/// them close; standing puts a whole body between them.
double? _headVsHands(BodyPose pose) {
  final nose = pose.confident(Joint.nose);
  final wrist = midpoint(pose, Joint.leftWrist, Joint.rightWrist);
  final shoulder = midpoint(pose, Joint.leftShoulder, Joint.rightShoulder);
  final hip = midpoint(pose, Joint.leftHip, Joint.rightHip);
  if (nose == null || wrist == null || shoulder == null || hip == null) {
    return null;
  }
  final torso = math.sqrt(math.pow(shoulder.$1 - hip.$1, 2) +
      math.pow(shoulder.$2 - hip.$2, 2));
  if (torso < 0.02) return null;
  return math.sqrt(math.pow(nose.x - wrist.$1, 2) +
          math.pow(nose.y - wrist.$2, 2)) /
      torso;
}


/// Where the hips sit against the shoulders, in torso lengths of image height.
///
/// Upright, the hips are a full torso below the shoulders. In a push-up they
/// are level with them, or — with the phone on the floor and the body pointing
/// away — above them, because further from the lens means higher in the frame.
double? _hipVsShoulder(BodyPose pose) {
  final shoulder = midpoint(pose, Joint.leftShoulder, Joint.rightShoulder);
  final hip = midpoint(pose, Joint.leftHip, Joint.rightHip);
  if (shoulder == null || hip == null) return null;
  final torso = math.sqrt(math.pow(shoulder.$1 - hip.$1, 2) +
      math.pow(shoulder.$2 - hip.$2, 2));
  if (torso < 0.02) return null;
  return (hip.$2 - shoulder.$2) / torso;
}

/// Torso length over shoulder width — under 0.6 the body points away from the
/// lens, which is what a push-up looks like on this camera.
double? _torsoRatio(BodyPose pose) {
  final shoulder = midpoint(pose, Joint.leftShoulder, Joint.rightShoulder);
  final hip = midpoint(pose, Joint.leftHip, Joint.rightHip);
  final width = shoulderWidth(pose);
  if (shoulder == null || hip == null || width == null) return null;
  return math.sqrt(math.pow(shoulder.$1 - hip.$1, 2) +
          math.pow(shoulder.$2 - hip.$2, 2)) /
      width;
}
