/// Scores a finished set, rather than a rep at a time.
///
/// The live engine counts as it goes, because the meter and the skeleton have
/// to move while somebody lifts — a screen that waits until the end tells them
/// nothing about the rep they are in. But counting live means deciding each rep
/// with only the past available, and the past at the start of a set is nothing
/// at all: the range is still the catalogue's guess, and where that guess is
/// wide of this body the zones are unreachable and the opening reps score
/// nothing. Measured across the recordings, that cost whole sets.
///
/// At the end of a set none of that is true. The whole movement is in hand, so
/// the range is a measurement rather than a guess, and every rep is judged with
/// the same information as every other. So the meter stays live and the *score*
/// waits.
///
/// A rep here is one cycle of the driver signal — a turn down and a turn back —
/// rather than a journey between two known ends. Nothing has to be known in
/// advance for that, which is the point: the ends of a cycle are wherever the
/// signal turns around, and depth is kept by asking a turn to swing a decent
/// share of what this set's own swings usually are.
library;

import 'exercise.dart';
import 'movement_signature.dart';
import 'pose.dart';
import 'signature_catalogue.dart';

/// The shortest thing that can be a rep. Around half a second at the rate poses
/// arrive — faster than that is a shiver, and it is also fewer frames than the
/// signature verifier needs before it will judge anything at all.
const kMinFramesPerRep = 14;

/// How much of a typical swing a turn has to travel to count as one. Half,
/// which is deep enough to throw out a shuffle between reps and shallow enough
/// to keep the last rep of a set that somebody barely finished.
const kSwingShare = 0.5;

/// A rep needs a cycle either side of it to know what typical looks like.
const kMinTurnsToJudge = 3;

class ScoredSet {
  const ScoredSet({
    required this.reps,
    required this.refused,
    this.lookedLike,
  });

  /// Cycles that were the prescribed movement.
  final int reps;

  /// Cycles that were a movement, but not this one.
  final int refused;

  /// What the refused ones looked like instead, when they agreed.
  final String? lookedLike;

  int get attempted => reps + refused;
}

/// One turning point of the signal: where it turned, and when.
class _Turn {
  const _Turn(this.value, this.index);
  final double value;
  final int index;
}

/// Reads a set and says how much of it counts.
ScoredSet scoreSet(
  ExerciseDef exercise,
  List<BodyPose> frames, {
  bool checkMovement = true,
}) {
  if (frames.length < 10) return const ScoredSet(reps: 0, refused: 0);

  // The driver, sampled where it is visible. Frames where the joint is out of
  // shot are skipped rather than guessed at, and the index kept alongside so a
  // cycle can be traced back to the poses that made it.
  final series = <double>[];
  final sourceIndex = <int>[];
  for (var i = 0; i < frames.length; i++) {
    final v = exercise.driver.measure(frames[i]);
    if (v == null) continue;
    series.add(v);
    sourceIndex.add(i);
  }
  if (series.length < 10) return const ScoredSet(reps: 0, refused: 0);

  // A generous first pass to learn how big this lifter's swings are, then a
  // second at half of that. The bar comes from the set itself: a tall lifter
  // pressing through ninety degrees and a stiff one through forty both get
  // judged against their own movement rather than against a table.
  final rough = _turnsIn(series, 5);
  if (rough.length < kMinTurnsToJudge) return const ScoredSet(reps: 0, refused: 0);

  final swings = <double>[
    for (var i = 1; i < rough.length; i++)
      (rough[i].value - rough[i - 1].value).abs(),
  ]..sort();
  final typical = swings[swings.length ~/ 2];
  if (typical <= 0) return const ScoredSet(reps: 0, refused: 0);

  final turns = _turnsIn(series, typical * kSwingShare);

  // Two turns make a rep: down and back, or up and back, depending on which
  // end the lifter started from. Pairing them from the first turn means a set
  // that began mid-movement loses at most a half rep, and losing half a rep to
  // the lifter's own late start is fairer than inventing one.
  final verifier = SignatureVerifier(signatureFor(exercise.name), kAllSignatures);

  var reps = 0;
  var refused = 0;
  String? lookedLike;

  for (var i = 0; i + 2 < turns.length; i += 2) {
    if (!checkMovement) {
      reps++;
      continue;
    }

    // The poses spanning this cycle, so identity is judged on the whole rep
    // rather than on whichever frame happened to end it.
    final from = sourceIndex[turns[i].index];
    final to = sourceIndex[turns[i + 2].index];

    // Too brief to be a rep, and — worse — too brief to be judged: the
    // verifier waves through anything it has fewer than a handful of frames of,
    // on the principle that a rep must never be refused for want of data. That
    // principle is right for a rep and wrong for a flicker, and counting cycles
    // produces flickers by the hundred. So the length test comes first, and
    // anything under it is thrown out rather than handed to a verifier that
    // will let it pass.
    if (to - from < kMinFramesPerRep) {
      refused++;
      continue;
    }

    final verdict = verifier.verify(frames.sublist(from, to + 1));

    if (verdict.accepted) {
      reps++;
    } else {
      refused++;
      lookedLike ??= verdict.lookedLike;
    }
  }

  return ScoredSet(reps: reps, refused: refused, lookedLike: lookedLike);
}

/// Every place the signal changed direction by more than [prominence].
///
/// No minimum spacing here, deliberately. An earlier version refused a turn
/// that arrived too soon after the last one — and refusing it left the detector
/// still looking for a peak while the body was already on its way down, so it
/// missed not just that turn but the whole of the next descent. A lifter doing
/// ten reps was scored two. Spacing is a property of a *rep*, so it is judged
/// on the finished cycle further down, where dropping one costs one.
List<_Turn> _turnsIn(List<double> series, double prominence) {
  final out = <_Turn>[];
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
