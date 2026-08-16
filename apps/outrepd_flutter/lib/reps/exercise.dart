/// Exercises are data, not code. The counting engine reads these definitions,
/// so adding a movement means adding an entry here rather than writing a new
/// counter — which is what lets the list grow past a handful.
library;

import 'package:flutter/material.dart';

import 'pose.dart';

/// Three joints whose angle drives a meter or guards a rule. Measured on
/// whichever side the camera can see; both sides are averaged when both are
/// visible, so a slightly turned body still reads correctly.
class AngleSpec {
  const AngleSpec(this.a, this.vertex, this.b);

  final Joint a;
  final Joint vertex;
  final Joint b;

  double? _one(BodyPose pose, Joint ja, Joint jv, Joint jb) {
    final pa = pose.confident(ja);
    final pv = pose.confident(jv);
    final pb = pose.confident(jb);
    if (pa == null || pv == null || pb == null) return null;
    return angleBetween(pa, pv, pb);
  }

  double? measure(BodyPose pose) {
    final near = _one(pose, a, vertex, b);
    final far = _one(
      pose,
      jointMirror[a] ?? a,
      jointMirror[vertex] ?? vertex,
      jointMirror[b] ?? b,
    );

    if (near != null && far != null) return (near + far) / 2;
    return near ?? far;
  }
}

/// When a rule is judged. Depth is already handled by the meter's zones, so
/// gates exist for the things depth cannot see — a sagging hip, a swinging
/// body, a chin that never cleared the bar.
enum GatePhase { always, bottom, top }

abstract class FormGate {
  const FormGate(this.message, this.phase);

  /// Shown to the lifter when this rule is the one being broken.
  final String message;
  final GatePhase phase;

  /// null when the joints needed are not visible — an unmeasurable rule must
  /// not fail the rep, or a half-framed lifter would score nothing.
  bool? check(BodyPose pose);
}

/// Keeps an angle inside a range, e.g. a straight body line during a push-up.
class AngleGate extends FormGate {
  const AngleGate({
    required this.spec,
    required String message,
    GatePhase phase = GatePhase.always,
    this.min,
    this.max,
  }) : super(message, phase);

  final AngleSpec spec;
  final double? min;
  final double? max;

  @override
  bool? check(BodyPose pose) {
    final angle = spec.measure(pose);
    if (angle == null) return null;
    if (min != null && angle < min!) return false;
    if (max != null && angle > max!) return false;
    return true;
  }
}

/// Requires one joint to sit above another on screen. Image space runs down,
/// so "above" means a smaller y.
class AboveGate extends FormGate {
  const AboveGate({
    required this.upper,
    required this.lower,
    required String message,
    GatePhase phase = GatePhase.top,
    this.margin = 0.0,
  }) : super(message, phase);

  final Joint upper;
  final Joint lower;

  /// Fraction of the frame the upper joint must clear the lower one by.
  final double margin;

  @override
  bool? check(BodyPose pose) {
    final u = pose.confident(upper);
    final l = pose.confident(lower);
    if (u == null || l == null) return null;
    return u.y < l.y - margin;
  }
}

enum ScoreMode {
  /// Count repetitions.
  reps,

  /// Hold a position; the score is seconds.
  hold,
}

class ExerciseDef {
  const ExerciseDef({
    required this.id,
    required this.name,
    required this.icon,
    required this.driver,
    required this.bottomAngle,
    required this.topAngle,
    required this.gates,
    required this.cue,
    this.loadFactor,
    this.mode = ScoreMode.reps,
  });

  final String id;
  final String name;
  final IconData icon;

  /// The angle the meter follows.
  final AngleSpec driver;

  /// Driver angle at the bottom of the movement, and at the top. Bottom is
  /// usually the smaller number — a folded joint — but not always, so the
  /// engine maps between them rather than assuming an order.
  final double bottomAngle;
  final double topAngle;

  final List<FormGate> gates;

  /// One line telling the lifter how to stand so the camera can see them.
  final String cue;

  /// Load as a multiple of bodyweight, or null for pure bodyweight work.
  /// Fixing the load this way is what makes two different lifters comparable.
  final double? loadFactor;

  final ScoreMode mode;
}

const _shoulder = Joint.leftShoulder;
const _elbow = Joint.leftElbow;
const _wrist = Joint.leftWrist;
const _hip = Joint.leftHip;
const _knee = Joint.leftKnee;
const _ankle = Joint.leftAnkle;

/// The first five. Chosen because the camera reads them reliably, they need no
/// spotter, and they can be done almost anywhere.
const kExercises = <ExerciseDef>[
  ExerciseDef(
    id: 'pushup',
    name: 'Push-ups',
    icon: Icons.fitness_center,
    driver: AngleSpec(_shoulder, _elbow, _wrist),
    bottomAngle: 90,
    topAngle: 165,
    cue: 'Prop the phone in front of you so it sees you head to hips',
    gates: [
      AngleGate(
        spec: AngleSpec(_shoulder, _hip, _knee),
        message: 'Keep your body in a straight line',
        min: 155,
      ),
    ],
  ),
  ExerciseDef(
    id: 'squat',
    name: 'Squats',
    icon: Icons.airline_seat_legroom_extra,
    driver: AngleSpec(_hip, _knee, _ankle),
    bottomAngle: 95,
    topAngle: 168,
    cue: 'Phone in front of you at hip height, two steps back',
    gates: [
      AngleGate(
        spec: AngleSpec(_shoulder, _hip, _knee),
        message: 'Chest up — do not fold forward',
        phase: GatePhase.bottom,
        min: 55,
      ),
    ],
  ),
  ExerciseDef(
    id: 'situp',
    name: 'Sit-ups',
    icon: Icons.self_improvement,
    driver: AngleSpec(_shoulder, _hip, _knee),
    bottomAngle: 150,
    topAngle: 75,
    cue: 'Phone in front of you on the floor, knees bent',
    gates: [
      AngleGate(
        spec: AngleSpec(_hip, _knee, _ankle),
        message: 'Keep your knees bent',
        max: 130,
      ),
    ],
  ),
  ExerciseDef(
    id: 'pullup',
    name: 'Pull-ups',
    icon: Icons.rowing,
    driver: AngleSpec(_shoulder, _elbow, _wrist),
    bottomAngle: 160,
    topAngle: 70,
    cue: 'Phone in front of you, far enough back to catch the bar',
    gates: [
      AboveGate(
        upper: Joint.nose,
        lower: Joint.leftWrist,
        message: 'Chin has to clear your hands',
      ),
      AngleGate(
        spec: AngleSpec(_shoulder, _hip, _knee),
        message: 'No swinging — keep your body still',
        min: 150,
      ),
    ],
  ),
  ExerciseDef(
    id: 'plank',
    name: 'Plank',
    icon: Icons.horizontal_rule,
    driver: AngleSpec(_shoulder, _hip, _knee),
    bottomAngle: 150,
    topAngle: 180,
    mode: ScoreMode.hold,
    cue: 'Phone in front of you, low down, so it sees head to feet',
    gates: [
      AngleGate(
        spec: AngleSpec(_shoulder, _hip, _knee),
        message: 'Hips are dropping',
        min: 155,
      ),
    ],
  ),
];

ExerciseDef exerciseById(String id) =>
    kExercises.firstWhere((e) => e.id == id, orElse: () => kExercises.first);
