/// A counter built for one movement.
///
/// Everything else in this folder is general: eighty exercises, a signature
/// apparatus to tell them apart, thresholds that have to hold for a curl and a
/// deadlift at once. That generality is what made it hard, and measuring it is
/// what showed how hard — twelve of fifty-two wrong-movement pairs still score,
/// and honest sets were being emptied until a floor went in under them.
///
/// A push-up is one movement, and that changes the problem completely. There is
/// nothing to tell it apart from, so no signature is needed. Better: several
/// independent things about a push-up all oscillate together, and a general
/// counter cannot lean on any of them because they mean nothing for a squat.
///
/// So this counts THREE signals and makes them agree:
///
///   1. the elbow bending and straightening,
///   2. the shoulder's height above the wrist line — the body actually rising,
///   3. the nose's distance from the floor line through the wrists.
///
/// Three readings of the same event, from different joints. Where they agree
/// the count is solid; where they disagree the disagreement is itself the
/// signal, and the set is flagged rather than guessed at. One camera angle can
/// ruin any one of them — an elbow pointing at the lens, a shoulder occluded —
/// and it is unlikely to ruin all three.
library;

import 'dart:math' as math;

import 'pose.dart';

/// How far below the median swing a turn has to travel to count as one.
///
/// Half, measured against this set's own swings rather than a table, so a tall
/// lifter travelling ninety degrees and a stiff one travelling forty are each
/// judged against themselves.
const kSwingShare = 0.5;

/// Under this many frames a cycle is a tracker shiver, not a person. About half
/// a second at the rate poses arrive.
const kMinFramesPerRep = 14;

/// A signal needs this many turns before its rhythm means anything.
const kMinTurns = 4;

/// How far apart the signals may fall before the set is called uncertain,
/// as a share of the count.
///
/// Relative, not absolute, because the same gap means different things at
/// different sizes: two reps apart on a set of twenty-two is close agreement,
/// and two apart on a set of four is the signals telling entirely different
/// stories. A floor of one rep keeps short sets from being held to an
/// impossible standard.
const kAgreementShare = 0.15;

class PushupCount {
  const PushupCount({
    required this.reps,
    required this.confident,
    required this.perSignal,
  });

  /// The count, taken as the median of whichever signals were readable.
  final int reps;

  /// True when the readable signals agreed within [kAgreementSlack]. False is
  /// not a failure — it is the counter saying so, which is worth more to the
  /// person than a confident wrong number.
  final bool confident;

  /// What each signal made of it, for diagnostics and for the accuracy
  /// harness. Keys are stable names.
  final Map<String, int> perSignal;
}

/// Counts a whole set of push-ups from its recorded poses.
///
/// Scored at the end rather than live, deliberately. A live counter decides
/// each rep knowing only what came before it, and at the start of a set that is
/// nothing — which is how a range learned on the fly ends up refusing the reps
/// that would have taught it. With the set in hand, every rep is judged against
/// the same evidence as every other.
PushupCount countPushups(List<BodyPose> frames) {
  if (frames.length < 20) {
    return const PushupCount(reps: 0, confident: false, perSignal: {});
  }

  // Three readings of the body's height above its own hands, from three
  // different landmarks. The elbow is measured too but deliberately kept OUT
  // of the count — see [_elbowAngle].
  final signals = <String, List<double>>{
    'shoulderHeight': _series(frames, _shoulderAboveWrists),
    'noseHeight': _series(frames, _noseAboveWrists),
    'hipHeight': _series(frames, _hipAboveWrists),
  };

  final counts = <String, int>{};
  signals.forEach((name, series) {
    final n = _cyclesIn(series);
    if (n > 0) counts[name] = n;
  });

  // Reported for diagnostics, never counted.
  final elbow = _cyclesIn(_series(frames, _elbowAngle));

  if (counts.isEmpty) {
    return const PushupCount(reps: 0, confident: false, perSignal: {});
  }

  final values = counts.values.toList()..sort();
  final median = values[values.length ~/ 2];
  final spread = values.last - values.first;

  return PushupCount(
    reps: median,
    confident: counts.length >= 2 &&
        spread <= math.max(1, (median * kAgreementShare).round()),
    perSignal: {...counts, 'elbow(unused)': elbow},
  );
}

// ─────────────────────────────── the three signals ───────────────────────────

/// Shoulder–elbow–wrist, averaged over whichever arms are visible.
///
/// **Measured but not counted**, and that is the finding this file exists to
/// record. The elbow is the obvious signal for a push-up and it is the worst
/// one by a distance: across eight clips it over-counted every time, twenty-five
/// against six on an army fitness test, forty-two against twelve on a SEAL
/// training clip. The arms are the most foreshortened and most self-occluded
/// part of a body in a push-up position, and the angle jitters accordingly.
///
/// It stays in the diagnostics because a huge gap between it and the body
/// signals is informative — but it never touches the number.
double? _elbowAngle(BodyPose pose) {
  double? side(Joint s, Joint e, Joint w) {
    final a = pose.confident(s), b = pose.confident(e), c = pose.confident(w);
    if (a == null || b == null || c == null) return null;
    return angleBetween(a, b, c);
  }

  final left = side(Joint.leftShoulder, Joint.leftElbow, Joint.leftWrist);
  final right = side(Joint.rightShoulder, Joint.rightElbow, Joint.rightWrist);
  if (left != null && right != null) return (left + right) / 2;
  return left ?? right;
}

/// How far the shoulders sit above the hands, scaled by the torso.
///
/// This is the push-up as a bystander sees it: the body goes down, the body
/// comes up. It survives the camera angle that ruins the elbow, because it
/// measures the thing that actually moves rather than the joint that bends —
/// and the hands are planted, so they make a stable line to measure from.
double? _shoulderAboveWrists(BodyPose pose) {
  final shoulder = _mid(pose, Joint.leftShoulder, Joint.rightShoulder);
  final wrist = _mid(pose, Joint.leftWrist, Joint.rightWrist);
  final hip = _mid(pose, Joint.leftHip, Joint.rightHip);
  if (shoulder == null || wrist == null || hip == null) return null;

  final torso = _distance(shoulder, hip);
  if (torso < 0.02) return null;

  // Image y grows downward, so a shoulder above the wrists is a negative
  // difference; negated here so the signal rises as the body rises, which
  // makes every reading in this file read the same way round.
  return -(shoulder.$2 - wrist.$2) / torso;
}

/// The head's height above the hand line, scaled the same way.
///
/// The third opinion, and the one that holds up when the shoulders are hidden
/// behind the arms — which is exactly what a camera placed in front of someone
/// doing push-ups sees. The nose is a single landmark rather than a midpoint,
/// so it is noisier; it earns its place by failing in different circumstances
/// from the other two.
double? _noseAboveWrists(BodyPose pose) {
  final nose = pose.confident(Joint.nose);
  final wrist = _mid(pose, Joint.leftWrist, Joint.rightWrist);
  final shoulder = _mid(pose, Joint.leftShoulder, Joint.rightShoulder);
  final hip = _mid(pose, Joint.leftHip, Joint.rightHip);
  if (nose == null || wrist == null || shoulder == null || hip == null) {
    return null;
  }

  final torso = _distance(shoulder, hip);
  if (torso < 0.02) return null;
  return -(nose.y - wrist.$2) / torso;
}

/// The hips' height above the hand line.
///
/// The third body reading. The hips are the best-tracked landmarks in a
/// push-up — big, central, rarely occluded — and they rise and fall with the
/// whole body. Where the shoulders vanish behind the arms and the nose turns
/// away from the lens, the hips are usually still there.
double? _hipAboveWrists(BodyPose pose) {
  final hip = _mid(pose, Joint.leftHip, Joint.rightHip);
  final wrist = _mid(pose, Joint.leftWrist, Joint.rightWrist);
  final shoulder = _mid(pose, Joint.leftShoulder, Joint.rightShoulder);
  if (hip == null || wrist == null || shoulder == null) return null;

  final torso = _distance(shoulder, hip);
  if (torso < 0.02) return null;
  return -(hip.$2 - wrist.$2) / torso;
}

// ──────────────────────────────── the counting ───────────────────────────────

/// How much of each new reading the filter takes. Higher is more responsive.
double kSmoothing = 0.4;

List<double> _series(List<BodyPose> frames, double? Function(BodyPose) read) {
  final out = <double>[];
  final filter = Smoothed(weight: kSmoothing);
  for (final f in frames) {
    if (!f.isTracked) continue;
    final v = read(f);
    if (v == null) continue;
    out.add(filter.add(v));
  }
  return out;
}

/// Full swings of a signal.
///
/// A rep is one cycle — a turn and a turn back — not a journey between two
/// angles that have to be known in advance. Nothing is looked up: the ends of a
/// cycle are wherever the signal turns around. Depth is kept by asking a turn
/// to travel half of what this set's turns usually travel.
int _cyclesIn(List<double> series) {
  if (series.length < 20) return 0;

  // A generous first pass to learn the scale of this person's movement, and a
  // second at half of it. The threshold comes from the set, never from a table.
  final rough = _turns(series, _spread(series) * 0.08);
  if (rough.length < kMinTurns) return 0;

  final swings = <double>[
    for (var i = 1; i < rough.length; i++)
      (rough[i].value - rough[i - 1].value).abs(),
  ]..sort();
  final typical = swings[swings.length ~/ 2];
  if (typical <= 0) return 0;

  final turns = _turns(series, typical * kSwingShare);

  // Pairs of turns, each pair long enough to be a person rather than a shiver.
  // Length is judged on the finished cycle rather than between turns: an
  // earlier version refused turns that arrived too soon and, in doing so, left
  // the detector hunting for a peak while the body was already descending —
  // losing not just that turn but the whole of the next descent. Ten reps came
  // out as two.
  var reps = 0;
  for (var i = 0; i + 2 < turns.length; i += 2) {
    if (turns[i + 2].index - turns[i].index >= kMinFramesPerRep) reps++;
  }
  return reps;
}

class _Turn {
  const _Turn(this.value, this.index);
  final double value;
  final int index;
}

List<_Turn> _turns(List<double> series, double prominence) {
  final out = <_Turn>[];
  if (series.isEmpty || prominence <= 0) return out;

  var candidate = series.first;
  var candidateAt = 0;
  var rising = true;

  for (var i = 0; i < series.length; i++) {
    final v = series[i];
    if (rising) {
      if (v > candidate) {
        candidate = v;
        candidateAt = i;
      } else if (candidate - v > prominence) {
        out.add(_Turn(candidate, candidateAt));
        rising = false;
        candidate = v;
        candidateAt = i;
      }
    } else {
      if (v < candidate) {
        candidate = v;
        candidateAt = i;
      } else if (v - candidate > prominence) {
        out.add(_Turn(candidate, candidateAt));
        rising = true;
        candidate = v;
        candidateAt = i;
      }
    }
  }
  return out;
}

/// The signal's range, trimmed at both ends so one lost frame cannot set it.
double _spread(List<double> series) {
  final sorted = [...series]..sort();
  double at(double f) =>
      sorted[(f * (sorted.length - 1)).round().clamp(0, sorted.length - 1)];
  return at(0.95) - at(0.05);
}

(double, double)? _mid(BodyPose pose, Joint a, Joint b) {
  final pa = pose.confident(a);
  final pb = pose.confident(b);
  if (pa != null && pb != null) {
    return ((pa.x + pb.x) / 2, (pa.y + pb.y) / 2);
  }
  final one = pa ?? pb;
  return one == null ? null : (one.x, one.y);
}

double _distance((double, double) a, (double, double) b) =>
    math.sqrt(math.pow(a.$1 - b.$1, 2) + math.pow(a.$2 - b.$2, 2));
