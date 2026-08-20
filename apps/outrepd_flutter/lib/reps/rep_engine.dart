/// Counts repetitions from a stream of poses.
///
/// The meter the lifter sees and the rule that counts a rep are the same
/// thing: the ball is the driver angle mapped to 0..1, and a rep is a trip
/// from the bottom zone to the top zone made with the body in the right shape.
/// Two zones rather than one threshold is what stops a shiver at the boundary
/// from scoring twice.
library;


import 'exercise.dart';
import 'movement_signature.dart';
import 'pose.dart';
import 'signature_catalogue.dart';

/// How much of the travel counts as "all the way down" and "all the way up".
///
/// Set so a rep needs a clear trip, not a maximal one. Nobody hits their
/// absolute deepest position on every rep of a working set, and demanding it
/// threw away most of them. Half a rep still cannot reach both ends.
const kBottomZone = 0.22;
const kTopZone = 0.78;

/// Minimum time for the climb out of the bottom zone up to the top one. Timed
/// from the last moment spent at the bottom, so resting down there does not
/// buy credit for a rep that was then jerked up.
///
/// Deliberately low. A competitive push-up test runs near a rep a second, so
/// the climb alone can be half that — anything stricter throws away honest
/// reps. Crossing the whole calibrated range faster than this is not a person
/// moving, it is a bounce or a shaken phone, and the range requirement is what
/// does the real work here.
const kMinRepTime = Duration(milliseconds: 300);

/// Bad form shorter than this is tracker noise and is forgiven. Longer, and
/// the rep is spoiled even if the shape is right again by the top.
const kFormGrace = Duration(milliseconds: 300);

/// A rep in progress this long was never a rep. Giving up on it lets the range
/// re-derive, which is usually what was wrong in the first place.
const kAbandonedRep = Duration(seconds: 8);

/// A sanity floor, not a quality bar: below this the lifter did not really
/// move, and the definition's own thresholds are a better guess than anything
/// learned from stillness. Kept low because the trimming above already pulls
/// the ends in, and refusing a real calibration is worse than accepting a
/// slightly tight one.
const kMinCalibrationRange = 15.0;

enum RepRejection { halfRep, tooFast, badForm, wrongMovement }

extension RepRejectionMessage on RepRejection {
  String get message => switch (this) {
        RepRejection.halfRep => 'Go all the way down',
        RepRejection.tooFast => 'Too fast — control it',
        RepRejection.badForm => 'Form broke — that one did not count',
        RepRejection.wrongMovement =>
          'That is not the movement for this round',
      };
}

class RepState {
  const RepState({
    required this.progress,
    required this.formOk,
    required this.tracked,
    required this.reps,
    required this.holdSeconds,
    this.angle,
    this.armed = false,
    this.formMessage,
    this.countedNow = false,
    this.rejection,
  });

  /// The smoothed driver angle behind the meter, in degrees. Shown on the
  /// diagnostics panel — when the meter misbehaves, the question is always
  /// whether the angle is moving and where the calibrated ends landed.
  final double? angle;

  /// True once the bottom has been reached and a rep is in progress.
  final bool armed;

  /// Where the ball sits, 0 at the bottom of the movement, 1 at the top.
  final double progress;

  /// Whether the skeleton should be drawn green right now.
  final bool formOk;

  /// False when too little of the body is visible to judge anything. The round
  /// clock stops here rather than letting a bad camera angle cost the match.
  final bool tracked;

  final int reps;
  final double holdSeconds;

  /// Which rule is being broken, for the line under the meter.
  final String? formMessage;

  /// True on the single frame a rep lands, so the UI can flash and buzz.
  final bool countedNow;

  /// Why the last completed attempt was thrown away.
  final RepRejection? rejection;
}

class RepEngine {
  RepEngine(this.exercise, {this.checkMovement = true});

  /// Whether a rep must prove it was the prescribed movement. On for matches,
  /// where the round is about one exercise. Off for the mechanics tests, whose
  /// stick figures articulate one joint and were never meant to be a body.
  final bool checkMovement;

  final ExerciseDef exercise;

  /// Judges whether each rep was the movement the round asked for. A round is
  /// about one exercise, and a meter that fills for any movement bending the
  /// same joint is a round anyone can farm with whichever one is easiest.
  late final SignatureVerifier _verifier = SignatureVerifier(
    signatureFor(exercise.name),
    kAllSignatures,
  );

  /// The poses of the rep currently underway, kept so its identity can be
  /// judged on the whole movement rather than on the single frame that
  /// happened to finish it.
  final _repFrames = <BodyPose>[];

  /// Set when the last rep was refused because it was a different exercise,
  /// so the screen can say which one it looked like.
  String? lookedLike;

  /// The signature's own words for what was wrong — more useful than the
  /// generic rejection message, because it names the thing to change.
  String? _wrongMovementComplaint;

  /// What to tell the lifter about the last refused rep.
  String? get wrongMovementMessage => lookedLike == null
      ? _wrongMovementComplaint
      : 'That looked like a $lookedLike';

  final _angle = Smoothed();

  double? _calBottom;
  double? _calTop;
  bool _calibrating = false;

  /// Every angle seen while calibrating, rather than just the two extremes.
  /// Getting down onto the floor throws angles far outside the movement, and
  /// a min/max taken over those learns a range the actual reps only travel the
  /// middle of — so the ball never reaches either zone and nothing counts.
  final _calSamples = <double>[];

  /// A rolling window of recent angles, about twenty seconds of them, from
  /// which the range is re-derived as the set goes on.
  ///
  /// This replaces asking for a calibration ritual first. A warm-up phase
  /// demands the lifter perform to a script before anything counts, discards
  /// the reps they do during it, and silently poisons the whole session if
  /// they stray from it. Learning from the reps themselves has none of those
  /// problems: counting starts on the first rep, and the range corrects itself
  /// if they settle into a different depth.
  final _recent = <double>[];
  int _sinceAdapt = 0;

  static const _windowFrames = 600;
  static const _adaptEvery = 30;
  static const _minSamplesToAdapt = 90;

  /// One filter per gate, so form is judged on a steadied reading rather than
  /// a single frame of a depth estimate.
  final _gateFilters = <int, Smoothed>{};

  /// Why reps have been thrown away this session. Two rejected for form and
  /// two for speed are different problems; the count says which.
  final rejections = <RepRejection, int>{};

  int _reps = 0;
  double _holdSeconds = 0;

  /// True once the lifter has reached the bottom zone and is on their way up.
  bool _armed = false;
  Duration? _repStart;

  /// When the lifter last rose out of the bottom zone on this attempt.
  ///
  /// Separate from [_repStart], which refreshes on every frame spent at the
  /// bottom so resting down there cannot buy credit for a jerked rep. Timing
  /// the abandon window off that refreshing clock meant it never reached eight
  /// seconds for anyone who kept dipping back down: the engine stayed armed for
  /// the whole session, and since the range only re-derives between reps, the
  /// wrong range that caused it could never correct itself.
  Duration? _leftBottomAt;
  bool _formAtBottom = true;
  bool _spoiled = false;
  Duration? _badSince;
  RepRejection? _rejection;

  Duration? _lastFrame;

  int get reps => _reps;
  double get holdSeconds => _holdSeconds;

  /// The angle at the bottom of this lifter's range, once calibrated.
  double get bottomAngle => _calBottom ?? exercise.bottomAngle;
  double get topAngle => _calTop ?? exercise.topAngle;

  /// Watch one slow rep and learn this lifter's real range. Camera distance
  /// and limb length move the raw angles enough that fixed thresholds either
  /// reject good reps or accept short ones.
  void startCalibration() {
    _calibrating = true;
    _calSamples.clear();
    _angle.reset();
  }

  /// Returns false when the movement was too small to learn anything, in which
  /// case the definition's own thresholds stay in force.
  bool finishCalibration() {
    _calibrating = false;
    if (_calSamples.length < 10) return false;

    // Percentiles, not the extremes. Settling into position, a hand crossing
    // the lens, one bad frame — those all sit outside the movement, and the
    // extremes would take the range from them rather than from the reps.
    //
    // Trimmed hard, and deliberately so: the two failures are not equal. A
    // range slightly too narrow means the ball saturates at the ends and reps
    // count anyway. A range too wide means the reps travel only its middle,
    // the ball never reaches a zone, and nothing counts at all. So when in
    // doubt, be too narrow.
    _calSamples.sort();
    final low = _percentile(0.2);
    final high = _percentile(0.8);

    if (high - low < kMinCalibrationRange) return false;

    // Which end is "bottom" depends on the movement — a push-up folds shut at
    // the bottom, a sit-up folds shut at the top.
    final bottomIsSmaller = exercise.bottomAngle < exercise.topAngle;
    _calBottom = bottomIsSmaller ? low : high;
    _calTop = bottomIsSmaller ? high : low;
    return true;
  }

  void reset() {
    _reps = 0;
    _holdSeconds = 0;
    _armed = false;
    _repStart = null;
    _spoiled = false;
    _badSince = null;
    _rejection = null;
    _lastFrame = null;
    _angle.reset();
    _recent.clear();
    _sinceAdapt = 0;
    for (final f in _gateFilters.values) {
      f.reset();
    }
    rejections.clear();
  }

  RepState update(BodyPose pose, Duration now) {
    final elapsed = _lastFrame == null ? Duration.zero : now - _lastFrame!;
    _lastFrame = now;

    if (!pose.isTracked) {
      // Freeze rather than guess. Everything resumes where it left off.
      _badSince = null;
      return RepState(
        progress: _angle.hasValue ? _progressOf(_angle.value) : 0,
        formOk: false,
        tracked: false,
        reps: _reps,
        holdSeconds: _holdSeconds,
        formMessage: 'Step back so your whole body is in frame',
      );
    }

    final raw = exercise.driver.measure(pose);
    if (raw == null) {
      return RepState(
        progress: _angle.hasValue ? _progressOf(_angle.value) : 0,
        formOk: false,
        tracked: false,
        reps: _reps,
        holdSeconds: _holdSeconds,
        formMessage: 'Turn side on to the camera',
      );
    }

    final angle = _angle.add(raw);

    if (_calibrating) _calSamples.add(angle);

    _recent.add(angle);
    if (_recent.length > _windowFrames) _recent.removeAt(0);
    // Only between reps: moving the ends underneath a rep in flight could put
    // the lifter past a zone they never travelled to.
    if (!_calibrating && !_armed && ++_sinceAdapt >= _adaptEvery) {
      _sinceAdapt = 0;
      _adaptRange();
    }

    final progress = _progressOf(angle);
    final broken = _firstBrokenGate(pose, progress);
    final formOk = broken == null;

    _trackBadForm(formOk, now);

    if (exercise.mode == ScoreMode.hold) {
      if (formOk) _holdSeconds += elapsed.inMicroseconds / 1e6;
      return RepState(
        progress: progress,
        formOk: formOk,
        tracked: true,
        reps: _reps,
        holdSeconds: _holdSeconds,
        angle: angle,
        formMessage: broken?.message,
      );
    }

    var counted = false;

    // Everything between the bottom and the top is what the rep was. Capped
    // so a lifter who stalls at the bottom for a minute cannot grow the
    // buffer without bound.
    if (_armed && _repFrames.length < 600) _repFrames.add(pose);

    if (progress <= kBottomZone) {
      if (!_armed) {
        // Bottom of a fresh rep: start the clock and remember the shape here,
        // since the top checkpoint alone cannot tell a deep rep from a dip.
        _armed = true;
        _repStart = now;
        _formAtBottom = formOk;
        _spoiled = false;
        _rejection = null;
        _repFrames
          ..clear()
          ..add(pose);
      } else {
        // Still down here. Only the clock restarts: whether the shape was
        // right at the bottom is already decided, and letting it be rewritten
        // would hand a rep to anyone who sagged, tidied up, then pushed.
        _repStart = now;
      }
      // Back at the bottom, so the ascent that never arrived is owed no more
      // patience — the next one starts a fresh window.
      _leftBottomAt = null;
    } else if (_armed && now - (_leftBottomAt ??= now) > kAbandonedRep) {
      // Went down, never came back up. Whatever that was, it was not a rep —
      // most likely the range is wrong and the top is out of reach.
      //
      // Letting it stay armed was quietly fatal: the range only re-derives
      // between reps, so one unfinished rep froze the range that caused it and
      // the rest of the session counted nothing.
      _armed = false;
      _repStart = null;
      _spoiled = false;
    } else if (_armed && progress >= kTopZone) {
      final took = now - (_repStart ?? now);

      if (took < kMinRepTime) {
        _rejection = RepRejection.tooFast;
        rejections.update(RepRejection.tooFast, (n) => n + 1, ifAbsent: () => 1);
      } else if (!_formAtBottom || !formOk || _spoiled) {
        _rejection = RepRejection.badForm;
        rejections.update(RepRejection.badForm, (n) => n + 1, ifAbsent: () => 1);
      } else {
        // The shape was right. Now: was it the right movement?
        final verdict = checkMovement
            ? _verifier.verify(_repFrames)
            : const SignatureVerdict(accepted: true);
        if (verdict.accepted) {
          _reps++;
          counted = true;
          _rejection = null;
          lookedLike = null;
        } else {
          _rejection = RepRejection.wrongMovement;
          _wrongMovementComplaint = verdict.complaint;
          lookedLike = verdict.lookedLike;
          rejections.update(
            RepRejection.wrongMovement,
            (n) => n + 1,
            ifAbsent: () => 1,
          );
        }
      }

      _armed = false;
      _repStart = null;
      _spoiled = false;
    }

    return RepState(
      progress: progress,
      formOk: formOk,
      tracked: true,
      reps: _reps,
      holdSeconds: _holdSeconds,
      angle: angle,
      armed: _armed,
      formMessage: broken?.message,
      countedNow: counted,
      rejection: _rejection,
    );
  }

  /// Re-derives the ends from the last few seconds of movement. Runs quietly
  /// while the set goes on, so the first reps count on the definition's own
  /// thresholds and later ones on this lifter's actual travel.
  /// The typical bottom and top of the recent excursions, read from the
  /// turning points of the signal.
  ///
  /// Percentiles of the sample window measure where the body *spends time*,
  /// which is a different quantity from how far it travels — and for a
  /// bottom-heavy tempo the two disagree badly. A push-up set that pauses at
  /// the chest and snaps through the lockout puts four hundred frames near the
  /// bottom and nine at the top, so the interquartile band reads a fraction of
  /// the real movement. Adapting to that either collapses the meter or, once
  /// the narrowing guard refuses the collapse, freezes the range at a guess
  /// that never fitted. Both were happening, in different clips.
  ///
  /// Turning points measure the travel itself, and the median of them ignores
  /// the one rep somebody bailed out of.
  (double low, double high)? _excursions() {
    if (_recent.isEmpty) return null;

    // Below this a wobble counts as a turn; far above it a shallow rep stops
    // registering at all. It sits nearer tracker noise than rep depth.
    const prominence = 8.0;

    final troughs = <double>[];
    final peaks = <double>[];
    var candidate = _recent.first;
    var rising = true;

    for (final v in _recent) {
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

    // Two of each is a full cycle plus corroboration. One of each could be
    // somebody lying down.
    if (troughs.length < 2 || peaks.length < 2) return null;
    troughs.sort();
    peaks.sort();
    return (troughs[troughs.length ~/ 2], peaks[peaks.length ~/ 2]);
  }

  void _adaptRange() {
    if (_recent.length < _minSamplesToAdapt) return;

    final double low;
    final double high;

    if (_excursions() case (final l, final h)) {
      low = l;
      high = h;
    } else {
      // Not enough turning points to read a rhythm — someone setting up, or
      // resting. Percentiles are the weaker measure, but they are all there is,
      // and the guard below stops a resting window collapsing the meter.
      final sorted = List.of(_recent)..sort();
      double at(double f) =>
          sorted[(f * (sorted.length - 1)).round().clamp(0, sorted.length - 1)];
      low = at(0.25);
      high = at(0.75);
    }

    if (high - low < kMinCalibrationRange) return;

    // Refuse a range far narrower than the one in use. Widening is usually the
    // truth arriving — someone finally going deep — but a sudden narrowing is
    // almost always the window filling with something that is not the
    // exercise, and accepting it strands every later rep outside the meter.
    final current = (topAngle - bottomAngle).abs();
    if (current > 0 && (high - low) < current * 0.7) return;

    final bottomIsSmaller = exercise.bottomAngle < exercise.topAngle;
    final candidateBottom = bottomIsSmaller ? low : high;
    final candidateTop = bottomIsSmaller ? high : low;

    // Eased towards, never jumped to. A window holding a rest, a walk to the
    // rack or someone talking to camera describes a range far narrower than
    // the movement, and taking it outright collapsed the meter around standing
    // still — after which the reps fell outside it entirely and nothing
    // counted. Sustained change still moves it; a quiet twenty seconds barely
    // does.
    const pull = 0.15;
    _calBottom = (_calBottom ?? candidateBottom) * (1 - pull) + candidateBottom * pull;
    _calTop = (_calTop ?? candidateTop) * (1 - pull) + candidateTop * pull;
  }

  /// Sorted samples only. Nearest-rank, which is plenty at this sample count.
  double _percentile(double fraction) {
    final i = (fraction * (_calSamples.length - 1)).round();
    return _calSamples[i.clamp(0, _calSamples.length - 1)];
  }

  /// Maps the driver angle onto the meter. Written as a ratio between the two
  /// ends so it works whichever way round the movement folds.
  double _progressOf(double angle) {
    final span = topAngle - bottomAngle;
    if (span == 0) return 0;
    return ((angle - bottomAngle) / span).clamp(0.0, 1.0);
  }

  /// Only rules that apply where the lifter is right now. Depth is the meter's
  /// job, so a gate never has to restate it.
  ///
  /// Every gate is measured and smoothed on every frame, whether or not it is
  /// being judged, so its filter is already settled by the time the lifter
  /// reaches the part of the movement where it matters.
  FormGate? _firstBrokenGate(BodyPose pose, double progress) {
    FormGate? broken;

    for (var i = 0; i < exercise.gates.length; i++) {
      final gate = exercise.gates[i];
      final reading = gate.measure(pose);
      if (reading == null) continue;

      final smoothed =
          (_gateFilters[i] ??= Smoothed(weight: 0.25)).add(reading);

      final applies = switch (gate.phase) {
        GatePhase.always => true,
        GatePhase.bottom => progress <= kBottomZone,
        GatePhase.top => progress >= kTopZone,
      };
      if (applies && broken == null && !gate.passes(smoothed)) broken = gate;
    }
    return broken;
  }

  void _trackBadForm(bool formOk, Duration now) {
    if (formOk) {
      _badSince = null;
      return;
    }
    final since = _badSince ??= now;
    if (_armed && now - since >= kFormGrace) _spoiled = true;
  }
}
