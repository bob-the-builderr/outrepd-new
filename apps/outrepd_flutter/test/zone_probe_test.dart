/// Why a clip counts nothing.
///
/// A rep needs the meter to reach the bottom zone and then the top zone. When
/// a set counts zero, exactly one of three things is true: the driver angle
/// never moved, it moved but the assumed range put that movement in the middle
/// of the meter where no zone lives, or it reached the zones and something
/// downstream refused it. These are very different bugs and guessing between
/// them has cost more time than measuring would have.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/exercise_patterns.dart';
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
  test('where the meter actually travels', () {
    final dir = Directory(_folder);
    if (!dir.existsSync()) return;

    final lines = <String>[];

    for (final entry in _clips.entries) {
      final file = File('$_folder/${entry.key}');
      if (!file.existsSync()) continue;

      final recording = PoseRecording.fromJson(
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
      );
      final def = cameraDefFor(entry.value);
      if (def == null) continue;

      final engine = RepEngine(def);
      var minProgress = 2.0;
      var maxProgress = -1.0;
      var reachedBottom = 0;
      var reachedTop = 0;
      var trackedFrames = 0;
      var formOkFrames = 0;

      for (final frame in recording.frames) {
        final s = engine.update(frame.pose, Duration(milliseconds: frame.atMs));
        if (!s.tracked) continue;
        trackedFrames++;
        if (s.formOk) formOkFrames++;
        if (s.progress < minProgress) minProgress = s.progress;
        if (s.progress > maxProgress) maxProgress = s.progress;
        if (s.progress <= 0.22) reachedBottom++;
        if (s.progress >= 0.78) reachedTop++;
      }

      lines.add('${entry.key}  →  ${entry.value}');
      lines.add('  assumed range   ${def.bottomAngle.toStringAsFixed(0)}'
          '..${def.topAngle.toStringAsFixed(0)}'
          '   ended at ${engine.bottomAngle.toStringAsFixed(0)}'
          '..${engine.topAngle.toStringAsFixed(0)}');
      lines.add('  progress span   ${minProgress.toStringAsFixed(2)}'
          '..${maxProgress.toStringAsFixed(2)}');
      lines.add('  in bottom zone  $reachedBottom frames'
          '   in top zone $reachedTop frames');
      lines.add('  tracked         $trackedFrames/${recording.frames.length}'
          '   form ok $formOkFrames');
      lines.add('  rejections      ${engine.rejections}');
      lines.add('  counted         ${engine.reps}');
      lines.add('');
    }

    // ignore: avoid_print
    print('\n${lines.join('\n')}');
    expect(lines, isNotEmpty);
  });
}
