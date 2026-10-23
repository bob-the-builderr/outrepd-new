/// The push-up counter, and the bar beside it — one thing, not two.
///
/// It reads a single quantity: how high the nose is above the hands on the
/// floor, in shoulder widths. Across fourteen labelled sets, filmed on a dozen
/// cameras from floor level and at angles, that reading sits near **1.0 at
/// lockout** and near the floor at the bottom of a real rep, whoever is
/// lifting. It is a measure of the body, not of the set, so it can say
/// something the old counter never could: whether a rep went *far enough*.
///
/// A rep is that height falling to **half** the lifter's own lockout height
/// or lower, and coming back to three quarters of it, with the hands still on
/// the floor. The bar is the same height as a share of lockout. The number
/// and the bar come off the same reading at the same moment, so the bar
/// reaching the top is exactly when the number moves, and a dip that never
/// reached the bottom line never counts.
///
/// Everything is timed in seconds, not frames. A clip filmed at 120 frames a
/// second counted six push-ups as twenty under the old counter, whose every
/// window was a fixed number of frames; phones deliver poses at whatever
/// rate they manage.
///
/// What each piece is for, and what it was measured against, is on it.
library;

import 'dart:collection';
import 'dart:math' as math;

import 'pose.dart';
import 'posture.dart';
import 'recording.dart';

/// The bottom line: at or below this share of lockout height, the lifter has
/// gone at least halfway down to their hands.
///
/// Half, because a half-way dip is a half rep. Measured: every labelled rep in
/// the fourteen sets bottomed at 0.05–0.44 of lockout but one (0.50), and the
/// lifter's own recorded half reps — filmed on purpose to test exactly this —
/// stopped at 0.59–0.79. Roughly where "upper arms parallel to the floor"
/// puts the head, the usual standard for a push-up that counts.
const kBottomShare = 0.5;

/// The top line: back up to this share of lockout height completes the rep.
///
/// Below lockout on purpose. Tired arms stop short of locking out, and a rep
/// that went all the way down and most of the way up was a rep.
const kTopShare = 0.75;

/// Where the drawn bar is empty: a quarter of lockout height, about the
/// bottom of a real push-up, not the floor nobody's head reaches. Drawn from
/// the floor, the bar never got below a quarter full in a real set, and its
/// two lines sat squeezed into the middle; drawn from here it empties and
/// fills with every rep, and [kBottomShare] and [kTopShare] land on a third
/// and two thirds of it. Drawing only — nothing is counted off this.
const kBarFloor = 0.25;

/// How full to draw the bar for a [PushupReading.progress].
double barFill(double share) =>
    ((share - kBarFloor) / (1 - kBarFloor)).clamp(0.0, 1.0);

/// Time constant of the smoothing on the reading, seconds.
///
/// Short, because fast sets are fast: a hundred-rep set runs at 1.9 reps a
/// second, and anything slower than this starts rounding the bottoms off.
const kSmoothingSeconds = 0.05;

/// How long the nose's position is taken the median of, seconds. Removes a
/// single frame the tracker throws somewhere wrong without delaying anything.
const kHeadMedianSeconds = 0.12;

/// A full push-up cannot be quicker than this, seconds. A second count inside
/// it is the tracker shivering on the line, not a person.
const kMinRepSeconds = 0.35;

/// Shoulder width is taken as this percentile of this many seconds of it.
///
/// A high percentile, because shoulder width only ever reads *wrong* low: at
/// the bottom of a rep filmed at an angle one shoulder hides behind the other
/// and the width collapses from 0.45 to 0.05 for a moment.
const kShoulderWidthSeconds = 3.0;
const kShoulderWidthPercentile = 80;

/// Lockout height is the median of this many recent tops, starting from
/// [kLockoutSeeds] priors of [kLockoutPrior] shoulder widths so one bad
/// reading while somebody gets into position cannot become the reference.
const kLockoutKeep = 5;
const kLockoutSeeds = 2;
const kLockoutPrior = 1.0;

/// A top outside this band of the current reference is not a lockout
/// reading — crouching on the way in, or standing up — and is ignored.
const kLockoutBandLow = 0.6;
const kLockoutBandHigh = 1.8;

/// The depth share at which a set counts as clean: the typical rep travelled
/// at least eighty per cent of what the deepest one did.
const kCleanDepth = 0.8;

/// A counted rep that bottomed within this much of the bottom line is
/// borderline, and a dip that stopped within [kNearMissBand] above it is a
/// near miss. Either makes the set unsure — see [PushupCount.confident].
///
/// About the tracker's own wobble on the reading, so "close" means "could
/// have gone the other way on a different frame", not a judgement of form.
const kBorderlineBand = 0.05;
const kNearMissBand = 0.05;

/// Stood up rather than down: judged over this long, seconds, and true when
/// at least [kStoodUpShare] of the frames in it that could be measured say
/// so ([isStoodUp] in posture.dart — the torso long against the shoulders
/// and running down the frame).
///
/// The hands test alone let a lifter on their feet count reps: hands held
/// still in front of them, bobbing the head down toward them and back, reads
/// exactly like a push-up's head travelling to planted hands. On the
/// lifter's own camera the torso measured 0.16–0.53 shoulder widths through
/// real reps and 0.68–0.91 standing. Over a window, never one frame, so a
/// hip the tracker throws somewhere for a moment cannot cost a real rep; and
/// frames where the hips cannot be seen — often, head-on — say nothing.
const kStoodUpSeconds = 0.5;
const kStoodUpShare = 0.6;

// ─────────────────────────────── the hands ───────────────────────────────

/// A wrist this close to where its hand is planted is on it, in shoulder
/// widths. Real reps: 0.01–0.11. Standing up, flexing an arm: well over half.
const kHandNear = 0.35;

/// A floor point is the median of its hand's readings over this long, seconds.
const kFloorPointSeconds = 1.5;

/// A hand out of sight this long is re-planted where it reappears, seconds,
/// instead of being judged against a point nobody has confirmed since.
const kHandUnseenSeconds = 1.0;

/// Only floor points confirmed this recently set the floor line, seconds.
const kFloorFreshSeconds = 1.0;

/// A hand that has settled somewhere new for this long has been re-planted
/// there, seconds — "settled" meaning within [kReplantSettle] shoulder widths.
const kReplantSeconds = 0.8;
const kReplantSettle = 0.12;

/// The hands are judged over this long, seconds, and count as planted while
/// no more than [kHandsAwayShare] of it had a hand off its point.
///
/// A share rather than every frame: at the bottom of a rep the tracker loses
/// or swaps a hand for a moment, and that is not a hand leaving the floor.
const kHandsWindowSeconds = 0.4;
const kHandsAwayShare = 0.35;

enum _Hand { left, right }

class _Stamped {
  const _Stamped(this.atMs, this.x, this.y);
  final int atMs;
  final double x;
  final double y;
}

/// Where each hand is planted on the floor.
///
/// A reading of one hand that lands on the *other* hand's point is tolerated:
/// filmed at an angle, the head hides a hand at the bottom of every rep and
/// the tracker swaps or merges the two. Measured on such a set: the right
/// wrist was below the confidence floor 29% of the time, and the "left" one
/// jumped onto the right hand at every bottom. A label swap is not a move.
class _Hands {
  final _points = <_Hand, (double, double)?>{_Hand.left: null, _Hand.right: null};
  final _history = <_Hand, Queue<_Stamped>>{
    _Hand.left: Queue(),
    _Hand.right: Queue(),
  };
  final _stray = <_Hand, Queue<_Stamped>>{
    _Hand.left: Queue(),
    _Hand.right: Queue(),
  };
  final _lastSeen = <_Hand, int?>{_Hand.left: null, _Hand.right: null};
  final _lastOnPoint = <_Hand, int?>{_Hand.left: null, _Hand.right: null};
  final _away = Queue<(int, bool)>();
  int _now = 0;

  void add(int atMs, PosePoint? left, PosePoint? right, double width) {
    _now = atMs;
    final near = kHandNear * width;
    var anyAway = false;

    for (final (hand, p) in [(_Hand.left, left), (_Hand.right, right)]) {
      if (p == null) continue;
      final other = hand == _Hand.left ? _Hand.right : _Hand.left;
      final own = _points[hand];
      final theirs = _points[other];
      final dOwn = own == null ? double.infinity : _dist(p.x, p.y, own);
      final dTheirs = theirs == null ? double.infinity : _dist(p.x, p.y, theirs);
      final seen = _lastSeen[hand];
      final unseen = seen == null || atMs - seen > kHandUnseenSeconds * 1000;

      if (dOwn <= near) {
        _history[hand]!.add(_Stamped(atMs, p.x, p.y));
        _lastOnPoint[hand] = atMs;
      } else if (dTheirs <= near) {
        // Swapped or merged with the other hand.
      } else if (own == null || unseen) {
        _plant(hand, atMs, p.x, p.y);
      } else {
        anyAway = true;
        _stray[hand]!.add(_Stamped(atMs, p.x, p.y));
      }
      _lastSeen[hand] = atMs;
    }

    for (final hand in _Hand.values) {
      final history = _history[hand]!;
      while (history.isNotEmpty &&
          atMs - history.first.atMs > kFloorPointSeconds * 1000) {
        history.removeFirst();
      }
      if (history.isNotEmpty) {
        _points[hand] = (
          _median(history.map((s) => s.x)),
          _median(history.map((s) => s.y)),
        );
      }

      final stray = _stray[hand]!;
      while (stray.isNotEmpty &&
          atMs - stray.first.atMs > kReplantSeconds * 1000) {
        stray.removeFirst();
      }
      if (stray.length >= 5 &&
          atMs - stray.first.atMs >= kReplantSeconds * 800) {
        final mx = _median(stray.map((s) => s.x));
        final my = _median(stray.map((s) => s.y));
        final spread = _percentile(
          [for (final s in stray) _dist(s.x, s.y, (mx, my))],
          80,
        );
        if (spread <= kReplantSettle * width) {
          _points[hand] = (mx, my);
          _history[hand] = Queue.of(stray);
          _lastOnPoint[hand] = atMs;
          stray.clear();
        }
      }
    }

    _away.add((atMs, anyAway));
    while (_away.isNotEmpty &&
        atMs - _away.first.$1 > kHandsWindowSeconds * 1000) {
      _away.removeFirst();
    }
  }

  void _plant(_Hand hand, int atMs, double x, double y) {
    _points[hand] = (x, y);
    _history[hand] = Queue.of([_Stamped(atMs, x, y)]);
    _lastOnPoint[hand] = atMs;
    _stray[hand]!.clear();
  }

  bool get planted {
    if (_points.values.every((p) => p == null) || _away.isEmpty) return false;
    final away = _away.where((a) => a.$2).length;
    return away / _away.length <= kHandsAwayShare;
  }

  /// The floor line: where the hands are planted, from points confirmed
  /// recently. A hand out of sight for a while says nothing current about
  /// where the floor is.
  double? get floorY {
    final fresh = [
      for (final hand in _Hand.values)
        if (_points[hand] != null &&
            _lastOnPoint[hand] != null &&
            _now - _lastOnPoint[hand]! <= kFloorFreshSeconds * 1000)
          _points[hand]!.$2,
    ];
    if (fresh.isNotEmpty) return fresh.reduce((a, b) => a + b) / fresh.length;
    _Hand? latest;
    for (final hand in _Hand.values) {
      if (_points[hand] == null) continue;
      if (latest == null ||
          (_lastOnPoint[hand] ?? -1) > (_lastOnPoint[latest] ?? -1)) {
        latest = hand;
      }
    }
    return latest == null ? null : _points[latest]!.$2;
  }
}

// ─────────────────────────────── the tracker ─────────────────────────────

enum _Phase {
  /// Not yet seen at the top with the hands down. Nothing counts from here:
  /// lowering yourself onto the floor is one big descent and is not a rep.
  idle,

  /// At or through the top, watching for the way down.
  up,

  /// Past the bottom line, watching for the way back up.
  down,
}

/// What the tracker makes of one frame.
class PushupReading {
  const PushupReading({
    required this.progress,
    required this.counted,
    required this.reps,
    required this.planted,
    this.pastBottom = false,
  });

  /// The bar: the nose's height above the hands as a share of lockout, 0 at
  /// the floor and 1 at the top. Null until there is a floor and a head.
  final double? progress;

  /// A rep landed on this frame.
  final bool counted;

  final int reps;

  /// The hands are on the floor — the one thing a push-up cannot do without.
  final bool planted;

  /// This rep has been down past the bottom line, and the top line is the
  /// one left to reach. What the bar lights, so the lifter sees which line
  /// is next — read off the same tracker as the count, never guessed.
  final bool pastBottom;
}

/// Counts push-ups one frame at a time, and drives the bar.
///
/// The same object is the live number on the screen and the final score: a
/// lifter watching one number and being handed another at the end is how the
/// old two-counter design lost people's trust.
class PushupTracker {
  final _hands = _Hands();
  final _heads = Queue<(int, double)>();
  final _widths = Queue<(int, double)>();
  final _tops = Queue<double>.of(List.filled(kLockoutSeeds, kLockoutPrior));

  /// Recent frames' say on whether the body is stood up; see
  /// [kStoodUpSeconds].
  final _stances = Queue<(int, bool)>();

  double? _smooth;
  int? _lastAt;
  _Phase _phase = _Phase.idle;
  double? _excursionTop;
  double? _dipLow;
  int? _lastRepAt;
  int _reps = 0;
  final _repTimes = <int>[];
  final _repBottoms = <double>[];
  final _refusedAt = <int>[];
  final _nearMissAt = <int>[];
  int _origin = 0;
  double? _progress;
  bool _planted = false;

  int get reps => _reps;

  /// When each rep completed, milliseconds from the start of the count.
  List<int> get repTimes => List.unmodifiable(_repTimes);

  /// The bar as of the last frame.
  double? get progress => _progress;

  bool get planted => _planted;

  /// How deep the typical rep went against the deepest one, 0..1.
  double get depth {
    if (_repBottoms.isEmpty) return 0;
    final travel = [for (final b in _repBottoms) (1 - b).clamp(0.0, 1.0)];
    final deepest = travel.reduce(math.max);
    if (deepest <= 0) return 0;
    return (_median(travel) / deepest).clamp(0.0, 1.0);
  }

  /// Reps counted with the head only just past the bottom line.
  int get borderline =>
      _repBottoms.where((b) => b > kBottomShare - kBorderlineBand).length;

  /// Dips inside the set that stopped just short of the bottom line and came
  /// back up.
  int get nearMisses => _insideSet(_nearMissAt);

  /// Full swings inside the set that finished with a hand off the floor, and
  /// were refused.
  int get refused => _insideSet(_refusedAt);

  /// Only between the first rep and the last: a close call before the first
  /// is somebody getting into position, and after the last, getting up —
  /// on the recorded sets, exactly where those two turned up.
  int _insideSet(List<int> times) {
    if (_repTimes.isEmpty) return 0;
    final first = _repTimes.first;
    final last = _repTimes.last;
    return times.where((t) => t > first && t < last).length;
  }

  /// True when nothing about the set was a close call. See
  /// [PushupCount.confident].
  bool get confident =>
      _reps > 0 && refused == 0 && nearMisses == 0 && borderline == 0;

  /// Starts the count over from [atMs], keeping everything learned about the
  /// hands, the floor and this lifter's lockout — for the moment a countdown
  /// ends and the round begins.
  ///
  /// A rep already on its way back up when the clock starts went down before
  /// it, so it is not this round's: the lifter has to be seen at the top again
  /// first.
  void restartCount(int atMs) {
    _reps = 0;
    _repTimes.clear();
    _repBottoms.clear();
    _refusedAt.clear();
    _nearMissAt.clear();
    _lastRepAt = null;
    _origin = atMs;
    if (_phase == _Phase.down) _phase = _Phase.idle;
  }

  /// Lockout height in shoulder widths — what a full bar means. For the
  /// diagnostics panel.
  double get lockout => _lockout;

  double get _lockout => _median(_tops);

  /// Whether the body has been stood up over the last [kStoodUpSeconds].
  /// False without enough frames to say — no evidence is not evidence.
  bool get standing {
    if (_stances.length < 3) return false;
    final up = _stances.where((s) => s.$2).length;
    return up >= _stances.length * kStoodUpShare;
  }

  PushupReading add(int atMs, BodyPose pose) {
    final stance = isStoodUp(pose);
    if (stance != null) _stances.add((atMs, stance));
    while (_stances.isNotEmpty &&
        atMs - _stances.first.$1 > kStoodUpSeconds * 1000) {
      _stances.removeFirst();
    }

    final head = pose.confident(Joint.nose);
    if (head != null) _heads.add((atMs, head.y));
    final width = _shoulderWidth(pose);
    if (width != null) _widths.add((atMs, width));
    while (_heads.isNotEmpty && atMs - _heads.first.$1 > kHeadMedianSeconds * 1000) {
      _heads.removeFirst();
    }
    while (_widths.isNotEmpty &&
        atMs - _widths.first.$1 > kShoulderWidthSeconds * 1000) {
      _widths.removeFirst();
    }
    if (_widths.isEmpty) return _reading(false);
    final scale = _percentile([for (final w in _widths) w.$2], kShoulderWidthPercentile);

    _hands.add(
      atMs,
      pose.confident(Joint.leftWrist),
      pose.confident(Joint.rightWrist),
      scale,
    );
    _planted = _hands.planted;
    final floor = _hands.floorY;
    if (floor == null || _heads.isEmpty) return _reading(false);

    final raw = (floor - _median(_heads.map((h) => h.$2))) / scale;
    final last = _lastAt;
    if (_smooth == null || last == null) {
      _smooth = raw;
    } else {
      final dt = (atMs - last) / 1000;
      final a = 1 - math.exp(-dt / kSmoothingSeconds);
      _smooth = _smooth! + (raw - _smooth!) * a;
    }
    _lastAt = atMs;
    final h = _smooth!;
    final share = h / _lockout;
    _progress = share.clamp(0.0, 1.0);

    var counted = false;
    _dipLow = _dipLow == null ? share : math.min(_dipLow!, share);
    switch (_phase) {
      case _Phase.idle || _Phase.up:
        _excursionTop = _excursionTop == null ? h : math.max(_excursionTop!, h);
        if (_phase == _Phase.up && share >= kTopShare) {
          // Back at the top without ever crossing the bottom line.
          final dip = _dipLow!;
          if (dip > kBottomShare && dip <= kBottomShare + kNearMissBand) {
            _nearMissAt.add(atMs - _origin);
          }
          _dipLow = share;
        }
        // Armed by the top with the hands down — or by the hands settling
        // after the body has already been at the top, as long as it has not
        // yet reached the bottom. Hands finish settling a moment after
        // somebody gets down, and a lifter who starts straight away is
        // already on the way down by then: that first rep was being lost.
        final top = _excursionTop;
        final seenTop = share >= kTopShare ||
            (share > kBottomShare &&
                top != null &&
                top / _lockout >= kTopShare);
        // And not on their feet: somebody standing with their hands still
        // is not at the top of a push-up.
        if (_phase == _Phase.idle && seenTop && _planted && !standing) {
          _phase = _Phase.up;
          _dipLow = share;
        }
        if (share <= kBottomShare) {
          // Whatever this excursion topped out at is a lockout reading,
          // recorded whether or not it cleared the top line — a wrong
          // reference then corrects itself instead of locking the count
          // out. Only plausible ones: an excursion that never came near
          // lockout, crouching on the way in, is not a top.
          final top = _excursionTop;
          final ref = _lockout;
          if (top != null &&
              top >= kLockoutBandLow * ref &&
              top <= kLockoutBandHigh * ref) {
            _tops.addLast(top);
            while (_tops.length > kLockoutKeep) {
              _tops.removeFirst();
            }
          }
          _excursionTop = null;
          if (_phase == _Phase.up) _phase = _Phase.down;
        }
      case _Phase.down:
        if (share >= kTopShare) {
          final lastRep = _lastRepAt;
          final quickEnough =
              lastRep == null || atMs - lastRep >= kMinRepSeconds * 1000;
          final stoodUp = standing;
          if (_planted && quickEnough && !stoodUp) {
            _reps++;
            _repTimes.add(atMs - _origin);
            _repBottoms.add(_dipLow!);
            _lastRepAt = atMs;
            counted = true;
          } else if (!_planted || stoodUp) {
            // A full swing that finished with a hand off the floor — standing
            // up at the end of a set, or an arm lifted to flex — or with the
            // body on its feet, bobbing toward hands held still. Not a rep,
            // and nothing to build the next one on.
            _refusedAt.add(atMs - _origin);
          }
          _phase = _planted && !stoodUp ? _Phase.up : _Phase.idle;
          _excursionTop = h;
          _dipLow = share;
        }
    }
    return _reading(counted);
  }

  PushupReading _reading(bool counted) => PushupReading(
    progress: _progress,
    counted: counted,
    reps: _reps,
    planted: _planted,
    pastBottom: _phase == _Phase.down,
  );
}

// ─────────────────────────────── the verdict ─────────────────────────────

class PushupCount {
  const PushupCount({
    required this.reps,
    required this.confident,
    this.perSignal = const {},
    this.depth = 0,
    this.gaveUp = false,
    this.recordingPath,
    this.repTimes = const [],
    this.durationMs = 0,
  });

  /// The verdict of a tracker that watched the whole set.
  factory PushupCount.from(PushupTracker tracker, {int durationMs = 0}) =>
      PushupCount(
        reps: tracker.reps,
        confident: tracker.confident,
        perSignal: {
          'refused': tracker.refused,
          'nearMisses': tracker.nearMisses,
          'borderline': tracker.borderline,
        },
        depth: tracker.depth,
        repTimes: tracker.repTimes,
        durationMs: durationMs,
      );

  /// When each rep completed, milliseconds from the start of the set. Fed to
  /// the backend on upload, and what lets a future opponent's bar move at
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
  /// stopped well short of it.
  final double depth;

  final int reps;

  /// False when the set had a close call in it: a rep counted with the head
  /// only just past the bottom line, a dip that stopped just short of it, or
  /// a full swing refused because a hand was off the floor. Each is a place
  /// the count could honestly have gone the other way, and the confirm screen
  /// asks the lifter rather than presenting a guess as a fact.
  final bool confident;

  /// What went into [confident], for diagnostics and the accuracy harness.
  final Map<String, int> perSignal;
}

/// Counts a whole recorded set, with the same tracker the screen runs live.
///
/// [startMs] is when the round began, for a recording that also holds the
/// seconds before it: those frames teach the tracker the lifter's hands and
/// lockout, exactly as they did on the phone, and nothing in them counts.
PushupCount countPushups(List<RecordedFrame> frames, {int? startMs}) {
  final tracker = PushupTracker();
  var started = startMs == null;
  for (final f in frames) {
    if (!started && f.atMs >= startMs!) {
      tracker.restartCount(startMs);
      started = true;
    }
    tracker.add(f.atMs, f.pose);
  }
  // Stopped before the round began: nothing counts.
  if (!started) tracker.restartCount(startMs!);
  final from = startMs ?? (frames.isEmpty ? 0 : frames.first.atMs);
  final duration = frames.isEmpty ? 0 : math.max(0, frames.last.atMs - from);
  return PushupCount.from(tracker, durationMs: duration);
}

// ─────────────────────────────── helpers ─────────────────────────────────

double? _shoulderWidth(BodyPose pose) {
  final l = pose.confident(Joint.leftShoulder);
  final r = pose.confident(Joint.rightShoulder);
  if (l == null || r == null) return null;
  final w = math.sqrt(math.pow(l.x - r.x, 2) + math.pow(l.y - r.y, 2));
  return w < 0.02 ? null : w;
}

double _dist(double x, double y, (double, double) p) =>
    math.sqrt(math.pow(x - p.$1, 2) + math.pow(y - p.$2, 2));

double _median(Iterable<double> values) {
  final s = values.toList()..sort();
  final n = s.length;
  if (n == 0) return double.nan;
  return n.isOdd ? s[n ~/ 2] : (s[n ~/ 2 - 1] + s[n ~/ 2]) / 2;
}

/// Linear-interpolated percentile, the same definition numpy uses, so the
/// numbers measured on the bench and the ones the phone computes agree.
double _percentile(List<double> values, int q) {
  final s = [...values]..sort();
  if (s.length == 1) return s.first;
  final pos = (s.length - 1) * q / 100;
  final lo = pos.floor();
  final hi = pos.ceil();
  return s[lo] + (s[hi] - s[lo]) * (pos - lo);
}
