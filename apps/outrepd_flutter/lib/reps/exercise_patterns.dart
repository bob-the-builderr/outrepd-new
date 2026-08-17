/// Turns the exercise catalogue into something the camera can count.
///
/// Eighty exercises do not need eighty definitions. Almost all of them are one
/// of a handful of movement patterns wearing different equipment: a bench
/// press, an incline press and a machine press are the same elbow opening and
/// closing, and the counter cannot tell — or care — which bar is in the way.
///
/// So the patterns are defined, and names are matched to them. Adding a
/// exercise usually means adding nothing at all.
///
/// Deliberately no form rules. A wrong threshold here would silently reject
/// good reps across the whole catalogue, and nothing has been measured yet.
/// These make every exercise *countable*; judging comes after the numbers say
/// the counting is sound.
library;

import 'package:flutter/material.dart' show Icons;

import 'exercise.dart';
import 'pose.dart';

const _shoulder = Joint.leftShoulder;
const _elbow = Joint.leftElbow;
const _wrist = Joint.leftWrist;
const _hip = Joint.leftHip;
const _knee = Joint.leftKnee;
const _ankle = Joint.leftAnkle;

/// How a movement folds, and roughly how far. The range only has to be in the
/// right neighbourhood — the engine narrows it to the lifter within a few reps.
class MovementPattern {
  const MovementPattern(this.driver, this.bottom, this.top, this.cue);

  final AngleSpec driver;
  final double bottom;
  final double top;
  final String cue;
}

/// The elbow opening and closing: every press, row, pulldown, curl and
/// extension in the catalogue.
const _elbowBend = MovementPattern(
  AngleSpec(_shoulder, _elbow, _wrist),
  60,
  165,
  'Phone in front of you, side on to the working arm',
);

/// The arm swinging at the shoulder with the elbow fairly fixed: raises,
/// flyes, crossovers, pullovers.
const _shoulderSwing = MovementPattern(
  AngleSpec(_elbow, _shoulder, _hip),
  15,
  95,
  'Phone in front of you, far enough back to catch both arms',
);

/// The knee bending under load: squats, presses, lunges, extensions.
const _kneeBend = MovementPattern(
  AngleSpec(_hip, _knee, _ankle),
  90,
  168,
  'Phone in front of you at hip height, two steps back',
);

/// Folding at the hip with the legs fairly straight: deadlifts, hinges,
/// bridges, thrusts, and most ab work.
const _hipHinge = MovementPattern(
  AngleSpec(_shoulder, _hip, _knee),
  75,
  170,
  'Phone in front of you, low down, your whole body in frame',
);

/// Rising onto the toes.
const _ankleRaise = MovementPattern(
  AngleSpec(_knee, _ankle, Joint.leftShoulder),
  95,
  135,
  'Phone in front of you, low down, feet clearly in frame',
);

/// Matched in order, so the more specific words win. "Close Grip Bench Press"
/// has to reach the press rule, not be caught by "grip" or "close".
const _rules = <(List<String>, MovementPattern)>[
  // Legs before arms: "Leg Press" contains "press".
  (['calf raise'], _ankleRaise),
  (
    [
      'squat',
      'leg press',
      'lunge',
      'leg extension',
      'leg curl',
      'hack',
      'step up',
    ],
    _kneeBend
  ),
  (
    [
      'deadlift',
      'good morning',
      'glute bridge',
      'hip thrust',
      'crunch',
      'sit-up',
      'situp',
      'leg raise',
      'russian twist',
      'ab wheel',
      'rollout',
      'dead bug',
      'mountain climber',
      'plank',
      'hyperextension',
      'back extension',
    ],
    _hipHinge
  ),
  (
    [
      'flye',
      'fly',
      'crossover',
      'lateral raise',
      'front raise',
      'rear delt',
      'reverse pec',
      'pec deck',
      'upright row',
      'shrug',
      'face pull',
      'pullover',
      'kickback',
    ],
    _shoulderSwing
  ),
  (
    [
      'press',
      'row',
      'pulldown',
      'pull-up',
      'pullup',
      'chin-up',
      'chinup',
      'push-up',
      'pushup',
      'dip',
      'curl',
      'extension',
      'pushdown',
      'skull crusher',
      'pull down',
    ],
    _elbowBend
  ),
];

/// The pattern a named exercise moves in, or null when nothing matched — in
/// which case the app watches the lifter and works it out instead, which is
/// the better answer than forcing a guess.
MovementPattern? patternFor(String exerciseName) {
  final name = exerciseName.toLowerCase();
  for (final (keywords, pattern) in _rules) {
    for (final word in keywords) {
      if (name.contains(word)) return pattern;
    }
  }
  return null;
}

/// A definition the counting engine can run for any named exercise.
ExerciseDef? cameraDefFor(String exerciseName) {
  // Anything with a hand-written definition keeps it: those carry form rules,
  // which a pattern cannot.
  for (final defined in kExercises) {
    if (defined.name.toLowerCase() == exerciseName.toLowerCase()) return defined;
  }

  final pattern = patternFor(exerciseName);
  if (pattern == null) return null;

  return ExerciseDef(
    id: 'pattern:${exerciseName.toLowerCase()}',
    name: exerciseName,
    icon: Icons.fitness_center,
    driver: pattern.driver,
    bottomAngle: pattern.bottom,
    topAngle: pattern.top,
    gates: const [],
    cue: pattern.cue,
  );
}
