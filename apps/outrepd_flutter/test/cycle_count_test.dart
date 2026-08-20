/// Counting a rep as a cycle rather than as a journey between two known ends.
///
/// Everything that went wrong today came from one place: a rep is defined as a
/// trip from a bottom angle to a top angle, so both numbers have to be known
/// before anything can be counted. They come from a table that cannot know this
/// body, the engine spends the opening of a set learning them, and where the
/// table is far enough out the zones are never reached at all and a good set
/// scores nothing.
///
/// But a rep is not really a journey between two thresholds. It is one cycle of
/// an oscillating signal, and a cycle can be counted without knowing where its
/// ends are — they are wherever the signal turns around. Depth still matters,
/// so a turn only counts when it swings a decent fraction of what this set's
/// swings usually are: the bar is set by the lifter's own reps rather than by
/// a table.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/exercise_patterns.dart';
import 'package:outrepd/reps/recording.dart';
import 'package:outrepd/reps/set_scorer.dart';
import 'package:outrepd/reps/rep_engine.dart';

const _folder = String.fromEnvironment(
  'RECORDINGS',
  defaultValue: 'D:/outrepd-recordings',
);

const _clips = <String, String>{
  'row_tbar.json': 'Barbell Row',
  'ohp_dumbbell.json': 'Overhead Press',
  'pullup_marine.json': 'Pull-Ups',
  'curl_ezbar.json': 'Barbell Curl',
  'bench_dumbbell.json': 'Barbell Bench Press',
  'pushup_interval.json': 'Push-Ups',
  'pushup_tcount.json': 'Push-Ups',
  'squat_demo.json': 'Barbell Squat',
  'deadlift_demo.json': 'Deadlift',
  'bench_demo.json': 'Barbell Bench Press',
  'incline_demo.json': 'Incline Barbell Bench Press',
  'ohp_demo.json': 'Overhead Press',
  'row_demo.json': 'Barbell Row',
  'crunch_demo.json': 'Hanging Leg Raises',
};

/// Counts full swings of a signal.
///
/// A turn is only a turn once the signal has come back a real distance, and
/// "real" is measured against this set's own swings — the median of them, so
/// one wild excursion cannot raise the bar for every honest rep after it.
int cyclesIn(List<double> series) {
  if (series.length < 10) return 0;

  // A generous first pass, to find out how big this lifter's swings are.
  final rough = _turns(series, 5, 0);
  if (rough.length < 3) return 0;
  final swings = <double>[];
  for (var i = 1; i < rough.length; i++) {
    swings.add((rough[i] - rough[i - 1]).abs());
  }
  swings.sort();
  final typical = swings[swings.length ~/ 2];

  // Then at half a typical swing: deep enough to throw out a shuffle, shallow
  // enough to keep the rep somebody did not quite finish.
  // Half a typical swing deep, and no faster than a person moves. Without
  // the time floor a tracker jitter of the right size reads as a rep, and
  // three and a half minutes of shoulder press came out at 380.
  return _turns(series, typical * 0.5, minFramesBetweenTurns).length ~/ 2;
}

/// Roughly a third of a second at the rate the recordings run: half of the
/// fastest turnaround a person makes, so it throws out jitter without
/// threatening anybody fast.
const minFramesBetweenTurns = 8;

List<double> _turns(List<double> series, double prominence, int minGap) {
  final out = <double>[];
  var lastTurnAt = -minGap;
  var candidate = series.first;
  var rising = true;
  for (var i = 0; i < series.length; i++) {
    final v = series[i];
    if (rising) {
      if (v > candidate) {
        candidate = v;
      } else if (candidate - v > prominence && i - lastTurnAt >= minGap) {
        lastTurnAt = i;
        out.add(candidate);
        rising = false;
        candidate = v;
      }
    } else {
      if (v < candidate) {
        candidate = v;
      } else if (v - candidate > prominence && i - lastTurnAt >= minGap) {
        lastTurnAt = i;
        out.add(candidate);
        rising = true;
        candidate = v;
      }
    }
  }
  return out;
}

void main() {
  test('cycles against zones', () {
    final dir = Directory(_folder);
    if (!dir.existsSync()) return;

    final lines = <String>[];
    var zonesCounting = 0;
    var cyclesCounting = 0;
    var judged = 0;

    for (final entry in _clips.entries) {
      final file = File('$_folder/${entry.key}');
      if (!file.existsSync()) continue;

      final recording = PoseRecording.fromJson(
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
      );
      final def = cameraDefFor(entry.value);
      if (def == null) continue;

      final engine = RepEngine(def);
      for (final f in recording.frames) {
        engine.update(f.pose, Duration(milliseconds: f.atMs));
      }

      final series = <double>[];
      for (final f in recording.frames) {
        final v = def.driver.measure(f.pose);
        if (v != null) series.add(v);
      }
      final cycles = cyclesIn(series);
      final poses = [for (final f in recording.frames) f.pose];
      final scored = scoreSet(def, poses);

      judged++;
      if (engine.reps > 0) zonesCounting++;
      if (cycles > 0) cyclesCounting++;

      final seconds =
          recording.frames.isEmpty ? 0 : recording.frames.last.atMs ~/ 1000;
      lines.add('${entry.key.replaceAll('.json', '').padRight(18)}'
          '${seconds.toString().padLeft(4)}s'
          '   zones ${engine.reps.toString().padLeft(3)}'
          '   cycles ${cycles.toString().padLeft(3)}'
          '   scored ${scored.reps.toString().padLeft(3)}'
          '   refused ${scored.refused.toString().padLeft(3)}');
    }

    // ignore: avoid_print
    print('\n${lines.join('\n')}\n'
        'clips counting:  zones $zonesCounting/$judged   '
        'cycles $cyclesCounting/$judged\n');
    expect(lines, isNotEmpty);
  });
}
