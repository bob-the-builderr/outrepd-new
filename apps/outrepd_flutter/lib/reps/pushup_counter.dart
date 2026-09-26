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
import 'posture.dart';
import 'recording.dart';

/// How far below the median swing a turn has to travel to count as one.
///
/// Half, measured against this set's own swings rather than a table, so a tall
/// lifter travelling ninety degrees and a stiff one travelling forty are each
/// judged against themselves.
const kSwingShare = 0.5;

/// Under this many frames a cycle is a tracker shiver, not a person.
///
/// Was 14 (about half a second) until a max-effort set of 100 measured real
/// push-ups landing faster than that — a lifter speeding up mid-set had
/// individual reps as short as 10-odd frames, and the old floor silently
/// merged them into their neighbour. Lowered against the full labelled set in
/// `test/recordings/`: 10 recovers those reps and does not admit a single
/// extra false one on any other recording, real or synthetic. 8 recovered
/// nothing further, so this is the lowest floor the evidence asks for.
const kMinFramesPerRep = 10;

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

/// How little a signal may travel, against the widest-travelling signal in
/// the same set, before it is dropped from the vote rather than trusted.
///
/// A camera angle that flattens one landmark's motion does not flatten the
/// others equally, so the widest signal in a given set is the one closest to
/// seeing the real thing — and a signal that barely moved next to it is
/// reading tracker noise, not push-ups.
const kMinRelativeSpread = 0.44;

/// How close to the typical candidate's own depth a rep has to travel,
/// against the other candidates in the same set rather than a table.
const kMinCycleDepth = 0.5;

class PushupCount {
  const PushupCount({
    required this.reps,
    required this.confident,
    required this.perSignal,
    this.depth = 0,
    this.gaveUp = false,
    this.recordingPath,
    this.repTimes = const [],
    this.durationMs = 0,
  });

  /// When each rep bottomed out, milliseconds from the start of the set. Fed
  /// to the backend on upload, and what lets a future opponent's bar move at
  /// this lifter's actual pace instead of their total spread evenly across
  /// the clock.
  final List<int> repTimes;

  /// How long the set actually ran, milliseconds. The clock's own count, not
  /// the round's fixed limit — a set that ended in a surrender ran for less
  /// than the sixty seconds a duel allows, and the upload should say so
  /// rather than claim the full round happened.
  final int durationMs;

  /// Where this set's poses were saved, when they were.
  ///
  /// The caller writes the confirmed count onto it. Without that the file is a
  /// minute of joint positions with no answer attached, which is the state
  /// every recording was in before the lifter was asked.
  final String? recordingPath;

  /// The lifter walked out rather than finishing the round.
  ///
  /// It rides along with the count because the count alone cannot say it, and
  /// the screen that records the result needs to know: a duel left early is a
  /// loss whatever the number was at the moment they left.
  final bool gaveUp;

  /// The same verdict, remembering which file it came from.
  PushupCount withRecording(String? path) => PushupCount(
    reps: reps,
    confident: confident,
    perSignal: perSignal,
    depth: depth,
    gaveUp: gaveUp,
    recordingPath: path,
    repTimes: repTimes,
    durationMs: durationMs,
  );

  /// The same verdict, with when each rep landed and how long the set ran
  /// attached.
  ///
  /// Kept separate from the constructor call in [countPushups] because that
  /// function only ever sees bare poses — no timestamps — while the timings
  /// are read off the recorded frames themselves, by [repTimes].
  PushupCount withTimes(List<int> times, {required int durationMs}) =>
      PushupCount(
        reps: reps,
        confident: confident,
        perSignal: perSignal,
        depth: depth,
        gaveUp: gaveUp,
        recordingPath: recordingPath,
        repTimes: times,
        durationMs: durationMs,
      );

  /// The same verdict, remembering that it was abandoned.
  PushupCount surrendered(bool gaveUp) => PushupCount(
    reps: reps,
    confident: confident,
    perSignal: perSignal,
    depth: depth,
    gaveUp: gaveUp,
    recordingPath: recordingPath,
    repTimes: repTimes,
    durationMs: durationMs,
  );

  /// How deep a typical rep went, as a share of the deepest rep in the set.
  ///
  /// Against the lifter rather than against a table of angles: 1 means every
  /// rep travelled as far as their best one, and 0.6 means the typical rep
  /// stopped well short of it. A number measured in degrees would need to know
  /// what a full push-up is for this body at this camera angle, which is
  /// exactly the thing no fixed threshold has ever got right here.
  final double depth;

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

  // The set starts when the lifter is down in position, not when the camera
  // opened. What comes before is them walking up and lowering onto their
  // hands — one descent, bigger than any rep, and scored as one until this
  // line existed. Reported from a phone: "it counted one and I hadn't got
  // down yet."
  //
  // And if nobody was ever down in position, nothing here is a push-up. The
  // count goes back as zero and *unsure*, not as zero and certain: the confirm
  // screen asks the lifter for the number, which is the right way to end a set
  // the camera could not read.
  final start = setStartsAt(frames);
  if (start == null) {
    return const PushupCount(reps: 0, confident: false, perSignal: {});
  }
  final set = frames.sublist(start);
  if (set.length < 20) {
    return const PushupCount(reps: 0, confident: false, perSignal: {});
  }

  // Three readings of the body's height above its own hands, from three
  // different landmarks. The elbow is measured too but deliberately kept OUT
  // of the count — see [_elbowAngle].
  final signals = <String, List<double>>{
    'shoulderHeight': _series(set, _shoulderAboveWrists),
    'noseHeight': _series(set, _noseAboveWrists),
    'hipHeight': _series(set, _hipAboveWrists),
  };

  // Against each other rather than a table: a camera angle that leaves the
  // shoulders and hips barely rising above the wrists — the rest of the body
  // still reads the set fine, this landmark just is not moving on this
  // camera angle — turns that flat line's own tracker noise into turns of
  // its own, well short of the range the readable signals actually saw. A
  // signal is trusted only once it has covered a real share of whatever the
  // best-travelled signal covered.
  final spreads = signals.map((name, s) => MapEntry(name, _spread(s)));
  final widestSpread = spreads.values.fold(0.0, math.max);

  final counts = <String, int>{};
  signals.forEach((name, series) {
    if (widestSpread > 0 &&
        spreads[name]! < widestSpread * kMinRelativeSpread) {
      return;
    }
    final n = _cyclesIn(series);
    if (n > 0) counts[name] = n;
  });

  // Reported for diagnostics, never counted.
  final elbow = _cyclesIn(_series(set, _elbowAngle));

  if (counts.isEmpty) {
    return const PushupCount(reps: 0, confident: false, perSignal: {});
  }

  final values = counts.values.toList()..sort();
  final median = values[values.length ~/ 2];
  final spread = values.last - values.first;

  return PushupCount(
    reps: median,
    confident:
        counts.length >= 2 &&
        spread <= math.max(1, (median * kAgreementShare).round()),
    perSignal: {...counts, 'elbow(unused)': elbow},
    // Read off the shoulders, the steadiest of the three.
    depth: _depthOf(signals['shoulderHeight'] ?? const []),
  );
}

/// The depth share at which a set counts as clean.
///
/// Eight tenths: the typical rep travelled at least eighty per cent of what
/// the deepest one did. Not a verdict on technique — the camera cannot give
/// one — but it can see a set getting shallower as the minute wears on, which
/// is the thing a lifter can act on.
const kCleanDepth = 0.8;

/// How fast the meter's remembered top and bottom ease back toward what it
/// is actually seeing, once nothing new has stretched them further.
///
/// The bar used to track an all-time low and an all-time high that only ever
/// grew. Measured on a clean 28-rep set filmed the way the app is actually
/// used: the top crept from 2.36 to 3.17 over the set — the moment the
/// lifter stood up at the very end, held forever after — so every rep in
/// between read as barely reaching the top even though it was, by its own
/// standard, a full one. Swept against three real multi-rep sets and two
/// adversarial recordings (a single rep held for fifteen seconds, and
/// someone bobbing on their feet): 0.006 roughly triples how often the bar
/// actually reaches its own ends on a real set, and is the highest rate that
/// does not also make it swing on the held single rep — 0.01 does.
const kRangeDecay = 0.006;

/// How far through a rep the body is, right now.
///
/// The meter on screen and the bar beside it used to be driven by a separate
/// engine reading the elbow angle against a calibrated range — a second
/// opinion that disagreed with the count constantly, and on a phone propped on
/// the floor was reading a joint it could barely see. This reads the same
/// signal the count is scored from, so the bar and the number can no longer
/// tell the lifter different things.
///
/// The range is the set's own: whatever this body has covered so far, rather
/// than a table of angles it might never reach.
class PushupMeter {
  final _filter = Smoothed(weight: kSmoothing);

  double? _low;
  double? _high;

  /// 1 at the top of the range seen so far, 0 at the bottom, or null until
  /// there is enough travel to mean anything.
  double? add(BodyPose pose) {
    if (!pose.isTracked) return null;
    final raw = _shoulderAboveWrists(pose);
    if (raw == null) return null;

    final value = _filter.add(raw);
    if (_low == null || _high == null) {
      _low = value;
      _high = value;
    } else {
      _low = value < _low! ? value : _low! + (value - _low!) * kRangeDecay;
      _high = value > _high! ? value : _high! - (_high! - value) * kRangeDecay;
    }

    final span = _high! - _low!;
    // Under a tenth of the body's height above its hands, nobody has moved
    // enough for a fraction of it to mean anything.
    if (span < 0.1) return null;
    return ((value - _low!) / span).clamp(0.0, 1.0);
  }

  /// Forgets the range. For a restart, where the last set's travel says
  /// nothing about this one.
  void reset() {
    _low = null;
    _high = null;
  }
}

/// How far a typical rep travelled, against the furthest one in the set.
///
/// The set is its own yardstick. A lifter who goes all the way down every time
/// reads 1; one whose reps get shallower as they tire reads lower, and the
/// number says something true about the set rather than about a threshold
/// somebody guessed at.
double _depthOf(List<double> series) {
  if (series.length < 20) return 0;

  final rough = _turns(series, _spread(series) * 0.08);
  if (rough.length < kMinTurns) return 0;

  final swings = <double>[
    for (var i = 1; i < rough.length; i++)
      (rough[i].value - rough[i - 1].value).abs(),
  ]..sort();
  if (swings.isEmpty) return 0;

  final deepest = swings.last;
  if (deepest <= 0) return 0;
  return (swings[swings.length ~/ 2] / deepest).clamp(0.0, 1.0);
}

/// When each rep bottomed out, in milliseconds from the start of the set.
///
/// Read off the shoulder-height signal, which is the steadiest of the three and
/// the one whose low point lands exactly where a person would say "that is the
/// bottom of a press-up". Used by the report so somebody checking the count can
/// scrub a video to a named second rather than counting it from the beginning.
List<int> repTimes(List<RecordedFrame> frames) {
  final kept = <RecordedFrame>[];
  final series = <double>[];
  final filter = Smoothed(weight: kSmoothing);

  // The same start line the count uses, so the times line up with the reps.
  final from = setStartsAt([for (final f in frames) f.pose]);
  if (from == null) return const [];
  for (var i = from; i < frames.length; i++) {
    final f = frames[i];
    if (!f.pose.isTracked) continue;
    final v = _shoulderAboveWrists(f.pose);
    if (v == null) continue;
    series.add(filter.add(v));
    kept.add(f);
  }
  if (series.length < 20) return const [];

  final rough = _turns(series, _spread(series) * 0.08);
  if (rough.length < kMinTurns) return const [];

  final swings = <double>[
    for (var i = 1; i < rough.length; i++)
      (rough[i].value - rough[i - 1].value).abs(),
  ]..sort();
  final typical = swings[swings.length ~/ 2];
  if (typical <= 0) return const [];

  final turns = _turns(series, typical * kSwingShare);

  // Only the troughs — the body at its lowest — and only those belonging to a
  // cycle long enough to have been a rep.
  final out = <int>[];
  for (var i = 0; i + 2 < turns.length; i += 2) {
    if (turns[i + 2].index - turns[i].index < kMinFramesPerRep) continue;
    final a = turns[i], b = turns[i + 1];
    final low = a.value <= b.value ? a : b;
    out.add(kept[low.index].atMs);
  }
  return out;
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
  final candidates = <int>[]; // indices into `turns`, each i is one candidate
  for (var i = 0; i + 2 < turns.length; i += 2) {
    if (turns[i + 2].index - turns[i].index >= kMinFramesPerRep) {
      candidates.add(i);
    }
  }
  if (candidates.isEmpty) return 0;

  // And a real way down, judged against the other candidates in this same
  // set rather than against the raw swings the threshold above was set
  // from — those include the half-turns either side of a rep as well as the
  // rep itself, and a hand settling into place at the very start can swing
  // wider than any push-up that follows. The candidates that already made it
  // this far are cleaner company: mostly real reps, so the one among them
  // that barely moved is the one worth doubting.
  final depths = [
    for (final i in candidates) (turns[i + 1].value - turns[i].value).abs(),
  ]..sort();
  final typicalDepth = depths[depths.length ~/ 2];

  return candidates
      .where(
        (i) =>
            (turns[i + 1].value - turns[i].value).abs() >=
            typicalDepth * kMinCycleDepth,
      )
      .length;
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

  // The turn the set ends on.
  //
  // A turn is only emitted above once the signal has reversed away from it,
  // and the last one never gets that — the set stops. So the closing extreme
  // sits in `candidate` and is thrown away, taking the last rep with it.
  //
  // Conditional on the signal having actually travelled to reach it: somebody
  // who stops halfway down has not finished a rep, and the same prominence
  // that judged every other turn judges this one.
  if (out.isEmpty || (candidate - out.last.value).abs() > prominence) {
    out.add(_Turn(candidate, candidateAt));
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
