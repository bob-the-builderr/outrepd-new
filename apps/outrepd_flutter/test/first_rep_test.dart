/// When does the first rep land?
///
/// The counter has no warm-up any more — that was removed once it turned out
/// a calibration pass before counting was swallowing the opening reps of every
/// set. But "no warm-up" is a claim about code, and what matters is a claim
/// about seconds: how long does somebody push before the number moves?
///
/// This prints the clock time of every counted rep, so the answer is measured
/// rather than reasoned about.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/driver_finder.dart';
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
  test('how long before the first rep counts', () {
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
      final at = <String>[];
      var last = 0;
      var firstMovementMs = -1;

      for (final frame in recording.frames) {
        final state = engine.update(frame.pose, Duration(milliseconds: frame.atMs));
        // The moment the meter leaves the bottom zone is the moment a human
        // would say the set started, so rep timings are quoted against it
        // rather than against the file, which opens with someone walking in.
        if (firstMovementMs < 0 && state.tracked && state.progress > 0.3) {
          firstMovementMs = frame.atMs;
        }
        if (engine.reps > last) {
          last = engine.reps;
          final since = firstMovementMs < 0 ? frame.atMs : frame.atMs - firstMovementMs;
          at.add('#$last at ${(frame.atMs / 1000).toStringAsFixed(1)}s '
              '(${(since / 1000).toStringAsFixed(1)}s into the set)');
        }
      }

      // The same clip counted with a driver worked out from the footage rather
      // than read from the catalogue. Where the two disagree, it is the
      // catalogue's fixed angles that do not fit this body, not the engine.
      final poses = [for (final fr in recording.frames) fr.pose];
      final guess = findDriver(poses);
      var learned = 0;
      if (guess != null) {
        final other = RepEngine(
          guess.toDefinition(id: 'learned', name: 'Learned'),
          checkMovement: false,
        );
        for (final fr in recording.frames) {
          other.update(fr.pose, Duration(milliseconds: fr.atMs));
        }
        learned = other.reps;
      }

      final total = recording.frames.isEmpty ? 0 : recording.frames.last.atMs;
      lines.add('${entry.key.padRight(22)} ${(total / 1000).toStringAsFixed(0)}s of video, '
          '${engine.reps} counted   (learned driver: $learned)');
      for (final a in at) {
        lines.add('    $a');
      }
      if (at.isEmpty) lines.add('    nothing counted');
    }

    // ignore: avoid_print
    print('\n${lines.join('\n')}\n');
    expect(lines, isNotEmpty);
  });
}
