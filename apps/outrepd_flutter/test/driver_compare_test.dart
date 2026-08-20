/// Is it the joint or the range?
///
/// The catalogue counts nothing on six of fourteen clips where a driver worked
/// out from the footage counts two, and there are only two ways that can be
/// true: the catalogue is watching the wrong joint, or it is watching the right
/// joint through the wrong window. The fix for one is nothing like the fix for
/// the other, so this prints both side by side rather than letting anyone pick
/// by intuition.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/driver_finder.dart';
import 'package:outrepd/reps/exercise.dart';
import 'package:outrepd/reps/exercise_patterns.dart';
import 'package:outrepd/reps/recording.dart';

const _folder = String.fromEnvironment(
  'RECORDINGS',
  defaultValue: 'D:/outrepd-recordings',
);

const _clips = <String, String>{
  'squat_demo.json': 'Barbell Squat',
  'squat_series.json': 'Barbell Squat',
  'deadlift_demo.json': 'Deadlift',
  'deadlift_series.json': 'Deadlift',
  'pushup_interval.json': 'Push-Ups',
  'pushup_tcount.json': 'Push-Ups',
  'bench_dumbbell.json': 'Barbell Bench Press',
  'bench_demo.json': 'Barbell Bench Press',
  'incline_demo.json': 'Incline Barbell Bench Press',
  'ohp_demo.json': 'Overhead Press',
  'row_demo.json': 'Barbell Row',
  'pullup_demo.json': 'Pull-Ups',
  'crunch_demo.json': 'Hanging Leg Raises',
  'legraise_demo.json': 'Hanging Leg Raises',
};

String _jointOf(AngleSpec spec) => '${spec.a}-${spec.vertex}-${spec.b}'
    .replaceAll('Joint.', '')
    .replaceAll('left', '')
    .replaceAll('right', '');

void main() {
  test('catalogue driver against the one the footage suggests', () {
    final dir = Directory(_folder);
    if (!dir.existsSync()) return;

    final lines = <String>[];
    var sameJoint = 0;
    var judged = 0;

    for (final entry in _clips.entries) {
      final file = File('$_folder/${entry.key}');
      if (!file.existsSync()) continue;

      final recording = PoseRecording.fromJson(
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
      );
      final def = cameraDefFor(entry.value);
      if (def == null) continue;

      final poses = [for (final f in recording.frames) f.pose];
      final guess = findDriver(poses);

      judged++;
      final catalogueJoint = _jointOf(def.driver);
      final learnedJoint = guess == null ? '—' : _jointOf(guess.spec);
      final agree = catalogueJoint == learnedJoint;
      if (agree) sameJoint++;

      lines.add(
        '${entry.key.replaceAll('.json', '').padRight(18)}'
        ' catalogue ${catalogueJoint.padRight(22)}'
        '${def.bottomAngle.toStringAsFixed(0).padLeft(4)}'
        '..${def.topAngle.toStringAsFixed(0).padRight(5)}'
        '   footage ${learnedJoint.padRight(22)}'
        '${guess == null ? "  —" : guess.low.toStringAsFixed(0).padLeft(4)}'
        '${guess == null ? "" : "..${guess.high.toStringAsFixed(0)}"}'
        '   ${agree ? "same joint" : "DIFFERENT"}',
      );
    }

    // ignore: avoid_print
    print('\n${lines.join('\n')}\n'
        'same joint: $sameJoint/$judged\n');
    expect(lines, isNotEmpty);
  });
}
