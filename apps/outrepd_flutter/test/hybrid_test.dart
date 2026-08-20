/// The decisive experiment for one idea: keep the catalogue's joint, take the
/// range from the body.
///
/// The joint is domain knowledge — a squat is the knee, a deadlift is the hip —
/// and the driver finder gets it wrong more often than the catalogue does: it
/// called a bent-over row a leg movement and a deadlift an arm one. The range
/// is the opposite: it is a fact about this lifter at this camera distance, and
/// the catalogue cannot know it. An incline press listed as 60..165 is really
/// 92..138, so every rep lives between the zones and nothing counts.
///
/// This applies the measured range from the very first frame, which is what a
/// live engine cannot do. If it counts where the live engine does not, the
/// architecture is right and the live path needs to reach it sooner. If it
/// does not count either, the idea is wrong and no amount of plumbing saves it.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/exercise.dart';
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

/// The travel of one joint across a whole recording, read from its turning
/// points so a slow tempo cannot shrink it.
(double, double)? _travelOf(List<RecordedFrame> frames, AngleSpec spec) {
  final series = <double>[];
  for (final f in frames) {
    final v = spec.measure(f.pose);
    if (v != null) series.add(v);
  }
  if (series.length < 10) return null;

  const prominence = 8.0;
  final troughs = <double>[];
  final peaks = <double>[];
  var candidate = series.first;
  var rising = true;
  for (final v in series) {
    if (rising) {
      if (v > candidate) {
        candidate = v;
      } else if (candidate - v > prominence) {
        peaks.add(candidate);
        rising = false;
        candidate = v;
      }
    } else {
      if (v < candidate) {
        candidate = v;
      } else if (v - candidate > prominence) {
        troughs.add(candidate);
        rising = true;
        candidate = v;
      }
    }
  }
  if (troughs.isEmpty || peaks.isEmpty) return null;
  troughs.sort();
  peaks.sort();
  return (troughs[troughs.length ~/ 2], peaks[peaks.length ~/ 2]);
}

void main() {
  test('catalogue joint, measured range, applied from the first frame', () {
    final dir = Directory(_folder);
    if (!dir.existsSync()) return;

    final lines = <String>[];
    var hybridCounts = 0;
    var liveCounts = 0;
    var judged = 0;

    for (final entry in _clips.entries) {
      final file = File('$_folder/${entry.key}');
      if (!file.existsSync()) continue;

      final recording = PoseRecording.fromJson(
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
      );
      final def = cameraDefFor(entry.value);
      if (def == null) continue;

      final live = RepEngine(def);
      for (final f in recording.frames) {
        live.update(f.pose, Duration(milliseconds: f.atMs));
      }

      final travel = _travelOf(recording.frames, def.driver);
      var hybrid = 0;
      var window = '—';
      if (travel != null) {
        final (lo, hi) = travel;
        final bottomIsSmaller = def.bottomAngle < def.topAngle;
        final fitted = ExerciseDef(
          id: def.id,
          name: def.name,
          icon: def.icon,
          driver: def.driver,
          bottomAngle: bottomIsSmaller ? lo : hi,
          topAngle: bottomIsSmaller ? hi : lo,
          gates: def.gates,
          cue: def.cue,
        );
        final engine = RepEngine(fitted);
        for (final f in recording.frames) {
          engine.update(f.pose, Duration(milliseconds: f.atMs));
        }
        hybrid = engine.reps;
        window = '${lo.toStringAsFixed(0)}..${hi.toStringAsFixed(0)}';
      }

      judged++;
      if (hybrid > 0) hybridCounts++;
      if (live.reps > 0) liveCounts++;

      lines.add('${entry.key.replaceAll('.json', '').padRight(18)}'
          ' live ${live.reps.toString().padLeft(3)}'
          '   fitted ${hybrid.toString().padLeft(3)}'
          '   window ${window.padLeft(9)}'
          '   catalogue ${def.bottomAngle.toStringAsFixed(0)}'
          '..${def.topAngle.toStringAsFixed(0)}');
    }

    // ignore: avoid_print
    print('\n${lines.join('\n')}\n'
        'clips counting: live $liveCounts/$judged   fitted $hybridCounts/$judged\n');
    expect(lines, isNotEmpty);
  });
}
