/// Does a round actually refuse the wrong movement?
///
/// The user's report is the sharpest test there is: "it counts any movement —
/// it makes no difference which exercise". So this scores every recording
/// against every OTHER exercise in the catalogue and asks how much of it gets
/// through. A round of bench press fed a set of squats must not score.
///
/// This is the anti-cheat claim stated as a number, and until it holds the
/// match is not a contest.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/exercise_patterns.dart';
import 'package:outrepd/reps/pose.dart';
import 'package:outrepd/reps/recording.dart';
import 'package:outrepd/reps/set_scorer.dart';

const _folder = String.fromEnvironment(
  'RECORDINGS',
  defaultValue: 'D:/outrepd-recordings',
);

/// One clip per movement, and what it really shows.
const _clips = <String, String>{
  'squat_demo.json': 'Barbell Squat',
  'deadlift_demo.json': 'Deadlift',
  'bench_dumbbell.json': 'Barbell Bench Press',
  'ohp_dumbbell.json': 'Overhead Press',
  'row_tbar.json': 'Barbell Row',
  'curl_ezbar.json': 'Barbell Curl',
  'pullup_marine.json': 'Pull-Ups',
  'pushup_interval.json': 'Push-Ups',
};

/// Movements that genuinely share a signature, where refusing is not expected.
/// A push-up and a bench press are the same press to the catalogue; so are a
/// squat and a leg press. Counting those as failures would be measuring the
/// catalogue's coarseness rather than the check.
const _sameFamily = <String, Set<String>>{
  'Barbell Bench Press': {'Push-Ups'},
  'Push-Ups': {'Barbell Bench Press'},
  'Barbell Squat': {'Deadlift'},
  'Deadlift': {'Barbell Squat'},
};

void main() {
  test('a round refuses the movement it was not asked for', () {
    final dir = Directory(_folder);
    if (!dir.existsSync()) {
      // ignore: avoid_print
      print('No recordings at $_folder — nothing to measure.');
      return;
    }

    final loaded = <String, List<BodyPose>>{};
    for (final entry in _clips.entries) {
      final file = File('$_folder/${entry.key}');
      if (!file.existsSync()) continue;
      final recording = PoseRecording.fromJson(
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
      );
      loaded[entry.value] = [for (final f in recording.frames) f.pose];
    }

    final rows = <String>[];
    var leaks = 0;
    var pairs = 0;

    for (final performed in loaded.keys) {
      final poses = loaded[performed]!;
      final own = scoreSet(cameraDefFor(performed)!, poses).reps;
      final leaked = <String>[];

      for (final asked in loaded.keys) {
        if (asked == performed) continue;
        if (_sameFamily[asked]?.contains(performed) ?? false) continue;

        pairs++;
        final scored = scoreSet(cameraDefFor(asked)!, poses).reps;
        // A handful of frames of a squat can look like anything. What must not
        // happen is a wrong movement scoring like a right one.
        if (scored > own * 0.4) {
          leaks++;
          leaked.add('$asked:$scored');
        }
      }

      rows.add('${performed.padRight(22)} as itself ${own.toString().padLeft(3)}'
          '${leaked.isEmpty ? '   clean' : '   LEAKS ${leaked.join(', ')}'}');
    }

    // ignore: avoid_print
    print('\n${rows.join('\n')}\n'
        'wrong-movement pairs tested: $pairs   leaked: $leaks\n');

    // A ratchet, not an aspiration. Zero leaks is not reachable from 2D pose
    // at arbitrary camera angles, and a test that always fails is a test
    // everyone learns to ignore. This holds the line at what has been achieved
    // — 21 leaks before the signatures were rewritten from measurement, 12
    // after — so a change that makes identity worse fails here loudly.
    //
    // Some of the 12 are the material rather than the check: the clips are
    // instructional videos containing walking, gesturing and talking, and a
    // real 90-second round contains none of that.
    expect(leaks, lessThanOrEqualTo(12),
        reason: 'identity checking got worse: a movement scored on a round '
            'that did not ask for it');
  });
}
