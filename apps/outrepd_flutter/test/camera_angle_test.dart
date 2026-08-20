/// Which way is the camera facing?
///
/// The app tells people to stand side on — every cue in the catalogue says so —
/// because a joint bending towards the lens barely changes angle in a 2D
/// projection. If the clips that count nothing turn out to be the ones filmed
/// from the front, then the counter is not broken so much as being asked to do
/// something it tells users not to ask.
///
/// Shoulder separation says it plainly: a body side on to the camera shows one
/// shoulder almost on top of the other, and a body facing it shows them a
/// torso-width apart.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/exercise_patterns.dart';
import 'package:outrepd/reps/pose.dart';
import 'package:outrepd/reps/recording.dart';
import 'package:outrepd/reps/rep_engine.dart';

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

void main() {
  test('camera orientation against whether the clip counts', () {
    final dir = Directory(_folder);
    if (!dir.existsSync()) return;

    final lines = <String>[];

    for (final entry in _clips.entries) {
      final file = File('$_folder/${entry.key}');
      if (!file.existsSync()) continue;

      final recording = PoseRecording.fromJson(
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
      );

      final widths = <double>[];
      for (final f in recording.frames) {
        final ls = f.pose.confident(Joint.leftShoulder);
        final rs = f.pose.confident(Joint.rightShoulder);
        final lh = f.pose.confident(Joint.leftHip);
        if (ls == null || rs == null || lh == null) continue;
        final dx = ls.x - rs.x;
        final dy = ls.y - rs.y;
        final across = math.sqrt(dx * dx + dy * dy);
        final tx = ls.x - lh.x;
        final ty = ls.y - lh.y;
        final along = math.sqrt(tx * tx + ty * ty);
        if (along > 0.02) widths.add(across / along);
      }
      if (widths.isEmpty) continue;
      widths.sort();
      final ratio = widths[widths.length ~/ 2];

      final def = cameraDefFor(entry.value);
      var counted = 0;
      if (def != null) {
        final engine = RepEngine(def);
        for (final f in recording.frames) {
          engine.update(f.pose, Duration(milliseconds: f.atMs));
        }
        counted = engine.reps;
      }

      // Shoulders half a torso apart or more is a body facing the lens.
      final facing = ratio > 0.5 ? 'FRONT ON' : 'side on';
      lines.add('${entry.key.replaceAll('.json', '').padRight(18)}'
          ' shoulders/torso ${ratio.toStringAsFixed(2)}'
          '   $facing'
          '   counted $counted');
    }

    // ignore: avoid_print
    print('\n${lines.join('\n')}\n');
    expect(lines, isNotEmpty);
  });
}
