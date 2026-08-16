/// Counts repetitions from a stream of poses.
///
/// The meter the lifter sees and the rule that counts a rep are the same
/// thing: the ball is the driver angle mapped to 0..1, and a rep is a trip
/// from the bottom zone to the top zone made with the body in the right shape.
/// Two zones rather than one threshold is what stops a shiver at the boundary
/// from scoring twice.
library;


import 'exercise.dart';
import 'pose.dart';

/// How much of the travel counts as "all the way down" and "all the way up".
const kBottomZone = 0.15;
const kTopZone = 0.85;

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

/// A sanity floor, not a quality bar: below this the lifter did not really
/// move, and the definition's own thresholds are a better guess than anything
/// learned from stillness. Kept low because the trimming above already pulls
/// the ends in, and refusing a real calibration is worse than accepting a
/// slightly tight one.
const kMinCalibrationRange = 15.0;

enum RepRejection { halfRep, tooFast, badForm }

extension RepRejectionMessage on RepRejection {
  String get message => switch (this) {
        RepRejection.halfRep => 'Go all the way down',
        RepRejection.tooFast => 'Too fast — control it',
        RepRejection.badForm => 'Form broke — that one did not count',
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
  RepEngine(this.exercise);

  final ExerciseDef exercise;

  final _angle = Smoothed();

  double? _calBottom;
  double? _calTop;
  bool _calibrating = false;

  /// Every angle seen while calibrating, rather than just the two extremes.
  /// Getting down onto the floor throws angles far outside the movement, and
  /// a min/max taken over those learns a range the actual reps only travel the
  /// middle of — so the ball never reaches either zone and nothing counts.
  final _calSamples = <double>[];

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

    if (progress <= kBottomZone) {
      if (!_armed) {
        // Bottom of a fresh rep: start the clock and remember the shape here,
        // since the top checkpoint alone cannot tell a deep rep from a dip.
        _armed = true;
        _repStart = now;
        _formAtBottom = formOk;
        _spoiled = false;
        _rejection = null;
      } else {
        // Still down here. Only the clock restarts: whether the shape was
        // right at the bottom is already decided, and letting it be rewritten
        // would hand a rep to anyone who sagged, tidied up, then pushed.
        _repStart = now;
      }
    } else if (_armed && progress >= kTopZone) {
      final took = now - (_repStart ?? now);

      if (took < kMinRepTime) {
        _rejection = RepRejection.tooFast;
        rejections.update(RepRejection.tooFast, (n) => n + 1, ifAbsent: () => 1);
      } else if (!_formAtBottom || !formOk || _spoiled) {
        _rejection = RepRejection.badForm;
        rejections.update(RepRejection.badForm, (n) => n + 1, ifAbsent: () => 1);
      } else {
        _reps++;
        counted = true;
        _rejection = null;
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
