/// Works out which joint a movement is actually about, by watching it.
///
/// Hand-writing a definition per exercise does not scale past a handful, and
/// it leaves anything not on the list uncountable. This looks at every joint
/// the tracker reports and asks one question: which angle is swinging in a
/// regular rhythm? Whichever answers loudest is the movement's driver.
///
/// The answer is derived from frames already buffered, so the reps watched
/// while working it out are not lost — they are counted again afterwards.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart' show Icons;

import 'exercise.dart';
import 'pose.dart';

/// The joints worth testing, each as a three-point angle. Ordered so that on
/// a tie the larger, more reliably tracked joints win.
const kCandidateDrivers = <AngleSpec>[
  AngleSpec(Joint.leftHip, Joint.leftKnee, Joint.leftAnkle),
  AngleSpec(Joint.leftShoulder, Joint.leftElbow, Joint.leftWrist),
  AngleSpec(Joint.leftShoulder, Joint.leftHip, Joint.leftKnee),
  AngleSpec(Joint.leftElbow, Joint.leftShoulder, Joint.leftHip),
  AngleSpec(Joint.leftHip, Joint.leftShoulder, Joint.leftKnee),
];

class DriverGuess {
  const DriverGuess({
    required this.spec,
    required this.low,
    required this.high,
    required this.score,
  });

  final AngleSpec spec;

  /// The ends of the travel that was seen, already trimmed.
  final double low;
  final double high;

  /// How clearly this joint carried the movement. Higher is better; anything
  /// under [kMinDriverScore] is not worth trusting.
  final double score;

  /// A definition that can be handed straight to the engine. Form rules are
  /// left empty on purpose — "keep your back straight" is a human judgement
  /// about a specific movement, not something to be inferred from a rhythm.
  ExerciseDef toDefinition({required String id, required String name}) {
    return ExerciseDef(
      id: id,
      name: name,
      icon: Icons.fitness_center,
      driver: spec,
      bottomAngle: low,
      topAngle: high,
      gates: const [],
      cue: 'Keep your whole body in frame',
    );
  }
}

/// Below this the movement was not rhythmic enough to be believed — someone
/// shifting about, or a joint the camera could barely see.
const kMinDriverScore = 0.35;

/// The smallest travel worth calling a movement, in degrees.
const kMinDriverRange = 20.0;

/// Picks the driver from a run of poses. Null when nothing looked like an
/// exercise, which is a better answer than confidently counting fidgeting.
DriverGuess? findDriver(List<BodyPose> poses) {
  if (poses.length < 45) return null;

  DriverGuess? best;

  for (final spec in kCandidateDrivers) {
    final series = <double>[];
    for (final pose in poses) {
      final angle = spec.measure(pose);
      if (angle != null) series.add(angle);
    }

    // A joint the camera lost for most of the set cannot be the driver, even
    // if the little it did see looked convincing.
    if (series.length < poses.length * 0.7) continue;

    final guess = _score(spec, series);
    if (guess == null) continue;
    if (best == null || guess.score > best.score) best = guess;
  }

  return best != null && best.score >= kMinDriverScore ? best : null;
}

DriverGuess? _score(AngleSpec spec, List<double> series) {
  final sorted = List.of(series)..sort();
  double at(double f) =>
      sorted[(f * (sorted.length - 1)).round().clamp(0, sorted.length - 1)];

  // Trimmed the same way the range is elsewhere: outliers are the tracker
  // slipping, not the lifter moving.
  final low = at(0.1);
  final high = at(0.9);
  final range = high - low;
  if (range < kMinDriverRange) return null;

  // Rhythm, not just movement. Scratching your nose swings the elbow through a
  // wide arc once; a set of push-ups swings it the same way over and over, and
  // only the second of those should win. Correlating the series against itself
  // at a delay tells them apart — a repeating signal lines up with its own
  // past, a one-off does not.
  final score = _periodicity(series);

  return DriverGuess(spec: spec, low: low, high: high, score: score);
}

/// Best self-correlation across plausible rep lengths, 0..1.
double _periodicity(List<double> series) {
  // Against a moving average, not the overall one. Subtracting a single mean
  // leaves any slow drift in place — a body settling, a camera shifting — and
  // a drifting signal stays correlated with itself at every lag, so it scores
  // higher than a joint genuinely swinging back and forth. Measured that way,
  // every exercise looked like a hip movement, including push-ups.
  final window = math.min(60, math.max(9, series.length ~/ 6));
  final centred = <double>[];
  for (var i = 0; i < series.length; i++) {
    final from = math.max(0, i - window ~/ 2);
    final to = math.min(series.length, i + window ~/ 2 + 1);
    var sum = 0.0;
    for (var j = from; j < to; j++) {
      sum += series[j];
    }
    centred.add(series[i] - sum / (to - from));
  }

  var energy = 0.0;
  for (final v in centred) {
    energy += v * v;
  }
  if (energy == 0) return 0;

  // A rep somewhere between a third of a second and six seconds, at 30fps.
  final minLag = 10;
  final maxLag = math.min(180, centred.length ~/ 2);

  var best = 0.0;
  for (var lag = minLag; lag <= maxLag; lag++) {
    var sum = 0.0;
    for (var i = 0; i + lag < centred.length; i++) {
      sum += centred[i] * centred[i + lag];
    }
    final normalised = sum / energy;
    if (normalised > best) best = normalised;
  }
  return best.clamp(0.0, 1.0);
}
