/// Counts the oscillations in a recording a second way, on purpose.
///
/// The engine and the videos cannot both be checked at once: a count that
/// looks wrong is either a bug or a clip that genuinely holds few reps, and
/// from the number alone those are identical.
///
/// So this counts the same recording by a method that shares nothing with the
/// engine — no zones, no timing rules, no form. It smooths the driving angle
/// and counts how many times it crosses its own midpoint. Two crossings is one
/// trip down and back, so crossings over two is roughly the rep count.
///
/// It is cruder than the engine and would never ship. That is the point: when
/// two unrelated methods disagree badly, the fault is in the one with all the
/// rules, not in the footage.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/driver_finder.dart';
import 'package:outrepd/reps/pose.dart';
import 'package:outrepd/reps/recording.dart';
import 'package:outrepd/reps/rep_engine.dart';

import 'accuracy_test.dart' show countOf;

const _folder = String.fromEnvironment(
  'RECORDINGS',
  defaultValue: 'D:/outrepd-recordings',
);

/// Crossings of the midpoint, ignoring wobble smaller than a fifth of the
/// travel so tracker noise around the middle does not read as movement.
int crossings(List<double> series) {
  if (series.isEmpty) return 0;

  var low = series.first;
  var high = series.first;
  for (final v in series) {
    if (v < low) low = v;
    if (v > high) high = v;
  }

  final middle = (low + high) / 2;
  final deadband = (high - low) * 0.2;

  var count = 0;
  bool? above;
  for (final v in series) {
    if (v > middle + deadband) {
      if (above == false) count++;
      above = true;
    } else if (v < middle - deadband) {
      if (above == true) count++;
      above = false;
    }
  }
  return count;
}

void main() {
  test('a second opinion on every recording', () {
    final dir = Directory(_folder);
    if (!dir.existsSync()) return;

    for (final file in dir.listSync().whereType<File>()) {
      final name = file.uri.pathSegments.last;
      if (!name.endsWith('.json') || name == 'truth.json') continue;

      final recording = PoseRecording.fromJson(
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
      );
      final poses = [for (final f in recording.frames) f.pose];

      final guess = findDriver(poses);
      if (guess == null) {
        // ignore: avoid_print
        print('$name — no driver found');
        continue;
      }

      final series = <double>[];
      for (final pose in poses) {
        final angle = guess.spec.measure(pose);
        if (angle != null) series.add(angle);
      }

      final smooth = Smoothed();
      final smoothed = [for (final v in series) smooth.add(v)];

      final seconds = recording.frames.last.atMs / 1000;
      final swings = crossings(smoothed) ~/ 2;

      // ignore: avoid_print
      print('$name\n'
          '  joint            ${guess.spec.vertex.name}\n'
          '  seconds          ${seconds.toStringAsFixed(1)}\n'
          '  angle range      ${series.reduce((a, b) => a < b ? a : b).round()}'
          '..${series.reduce((a, b) => a > b ? a : b).round()}\n'
          '  swings seen      $swings\n'
          '  engine counted   ${countOf(recording)}');
    }
  });
}
