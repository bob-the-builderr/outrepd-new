/// What does identity checking COST on honest work?
///
/// The signatures were tightened today to stop wrong movements scoring, and
/// the leak count fell from 21 to 12. This asks the other half of the question,
/// which is the half that matters when somebody is standing in a gym: how many
/// of their real reps did that tightening throw away?
///
/// A counter that returns zero for a real set is not a strict counter. It is a
/// broken one.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/exercise_patterns.dart';
import 'package:outrepd/reps/recording.dart';
import 'package:outrepd/reps/set_scorer.dart';

const _folder = String.fromEnvironment(
  'RECORDINGS',
  defaultValue: 'D:/outrepd-recordings',
);

const _clips = <String, String>{
  'squat_demo.json': 'Barbell Squat',
  'squat_series.json': 'Barbell Squat',
  'deadlift_demo.json': 'Deadlift',
  'bench_dumbbell.json': 'Barbell Bench Press',
  'bench_demo.json': 'Barbell Bench Press',
  'incline_demo.json': 'Incline Barbell Bench Press',
  'ohp_dumbbell.json': 'Overhead Press',
  'ohp_demo.json': 'Overhead Press',
  'row_tbar.json': 'Barbell Row',
  'row_demo.json': 'Barbell Row',
  'curl_ezbar.json': 'Barbell Curl',
  'pullup_marine.json': 'Pull-Ups',
  'pushup_interval.json': 'Push-Ups',
  'pushup_tcount.json': 'Push-Ups',
  'crunch_demo.json': 'Hanging Leg Raises',
};

void main() {
  test('identity checking must not empty an honest set', () {
    final dir = Directory(_folder);
    if (!dir.existsSync()) return;

    final rows = <String>[];
    var zeroed = 0;
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
      final checked = scoreSet(def, poses).reps;
      final blind = scoreSet(def, poses, checkMovement: false).reps;

      judged++;
      // The failure that matters: work happened, and the check erased all of
      // it. A set scored down is a judgement call; a set scored to nothing is
      // the app telling somebody they did not train.
      final erased = blind >= 3 && checked == 0;
      if (erased) zeroed++;

      rows.add('${entry.key.replaceAll('.json', '').padRight(18)}'
          ' checked ${checked.toString().padLeft(3)}'
          '   unchecked ${blind.toString().padLeft(3)}'
          '${erased ? '   ERASED' : ''}');
    }

    // ignore: avoid_print
    print('\n${rows.join('\n')}\n'
        'sets emptied by the identity check: $zeroed/$judged\n');

    expect(zeroed, 0,
        reason: 'the identity check erased a set that had real reps in it');
  });
}
