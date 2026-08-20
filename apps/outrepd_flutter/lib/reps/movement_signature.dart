/// Telling one movement from another.
///
/// The counter watches a single driver angle, and that is enough to *count* —
/// but not enough to know *what* was counted. A bicep curl and an overhead
/// press both open and close the elbow. A leg extension and a squat both bend
/// the knee. If the round says bench press, a player can curl through it and
/// the meter fills exactly the same way.
///
/// So a rep has to prove its identity, not just its shape. Every exercise
/// carries a signature: a handful of constraints on channels the driver angle
/// cannot see — where the torso is pointing, whether the shoulder swept or
/// stayed put, whether the hands finished above the head or at the chest.
///
/// And passing is not enough on its own. A curl satisfies most of what a press
/// asks for, so the prescribed movement must also fit **better than every
/// other movement in the catalogue**. Counting only when the right answer wins
/// is what stops a round being farmed with the easiest exercise that happens
/// to move the same joint.
library;

import 'dart:math' as math;

import 'exercise.dart';
import 'pose.dart';

/// A scalar read off the body each frame. These are the things that separate
/// movements sharing a driver joint.
enum Channel {
  /// Shoulder–elbow–wrist. Closed at the bottom of a curl, open at lockout.
  elbow,

  /// Elbow–shoulder–hip. Near zero with the arm by your side, ~90 with it
  /// straight out, ~170 overhead. The single most discriminating channel for
  /// upper body work: it is what separates a curl from a press.
  shoulder,

  /// Hip–knee–ankle.
  knee,

  /// Shoulder–hip–knee. Folded in a hinge, open when standing.
  hip,

  /// How far the torso is tipped from vertical, in degrees. 0 standing, ~90
  /// lying or in a push-up. Separates a squat from a deadlift, and a press
  /// from a push-up, without either sharing a joint constraint.
  torsoPitch,

  /// Where the hands are relative to the shoulders, as a fraction of torso
  /// length. Negative is above. An overhead press ends near -1; a curl never
  /// goes positive-to-negative at all.
  wristHeight,
}

/// One requirement a rep must meet. Each is deliberately loose — these are
/// meant to separate a press from a curl, not to grade technique.
sealed class SignatureRule {
  const SignatureRule(this.channel);
  final Channel channel;

  /// Whether the observed series satisfies this rule.
  bool satisfied(ChannelReading s);

  /// What to tell the lifter when this is the rule that failed.
  String get complaint;
}

/// The channel has to travel. A press whose shoulder never moves is a curl.
class Moves extends SignatureRule {
  const Moves(super.channel, this.minRange, this.complaint);
  final double minRange;
  @override
  final String complaint;

  @override
  bool satisfied(ChannelReading s) => s.range >= minRange;
}

/// The channel has to stay put. A curl whose shoulder swings is a cheat curl,
/// and more usefully, it is probably a press.
class Holds extends SignatureRule {
  const Holds(super.channel, this.maxRange, this.complaint);
  final double maxRange;
  @override
  final String complaint;

  @override
  bool satisfied(ChannelReading s) => s.range <= maxRange;
}

/// The channel has to sit inside a band for most of the rep. Judged on the
/// median rather than every frame, so one bad tracking frame cannot veto a
/// good rep.
class Within extends SignatureRule {
  const Within(super.channel, this.min, this.max, this.complaint);
  final double min;
  final double max;
  @override
  final String complaint;

  @override
  bool satisfied(ChannelReading s) => s.median >= min && s.median <= max;
}

/// Everything that makes a movement itself rather than its neighbour.
class MovementSignature {
  const MovementSignature(this.id, this.rules);

  /// Stable name, used to say which movement was recognised instead.
  final String id;
  final List<SignatureRule> rules;
}

/// What the verifier decided about one rep.
class SignatureVerdict {
  const SignatureVerdict({
    required this.accepted,
    this.complaint,
    this.lookedLike,
  });

  final bool accepted;

  /// Why it was turned down, in words a lifter would use.
  final String? complaint;

  /// The movement that fitted better, when that is why it was turned down.
  final String? lookedLike;
}

/// One channel's readings across a single rep. Public because the rules take
/// it — a rule is a small thing anyone can add, and it should not have to
/// live in this file to do so.
class ChannelReading {
  ChannelReading(List<double> values)
      : range = values.isEmpty
            ? 0
            : values.reduce(math.max) - values.reduce(math.min),
        median = values.isEmpty ? 0 : _medianOf(values);

  final double range;
  final double median;

  static double _medianOf(List<double> values) {
    final sorted = [...values]..sort();
    return sorted[sorted.length ~/ 2];
  }
}

/// Reads the channels off a run of frames and decides whether they show the
/// movement that was asked for.
class SignatureVerifier {
  SignatureVerifier(this.expected, this.alternatives);

  /// The movement the round is about.
  final MovementSignature expected;

  /// Everything else it might be confused with. The prescribed movement has to
  /// beat these, not merely satisfy itself.
  final List<MovementSignature> alternatives;

  /// Below this many frames there is not enough of a rep to judge, and a rep
  /// must never be refused for want of data — the lifter did the work.
  static const minFrames = 6;

  SignatureVerdict verify(List<BodyPose> frames) {
    // A movement with no signature is one the catalogue does not recognise, or
    // the free-training mode where any movement is the point. Judging it
    // against rules it was never given would refuse everything.
    if (expected.rules.isEmpty || frames.length < minFrames) {
      return const SignatureVerdict(accepted: true);
    }

    final series = _measure(frames);

    // A channel with no readings at all — the joint was out of frame for the
    // whole rep — cannot judge anything, so its rules are skipped rather than
    // failed. Half a body in shot should cost precision, not the rep.
    final failed = expected.rules
        .where((r) => series.containsKey(r.channel))
        .where((r) => !r.satisfied(series[r.channel]!))
        .toList();

    if (failed.isNotEmpty) {
      // Say what it looked like instead, when something else fits cleanly —
      // "that was a curl" is worth more than "wrong movement".
      final better = _bestAlternative(series);
      return SignatureVerdict(
        accepted: false,
        complaint: failed.first.complaint,
        lookedLike: better,
      );
    }

    // It satisfied its own rules. But so might a neighbour, and a movement
    // that fits the neighbour strictly better is the neighbour.
    final mine = _score(expected, series);
    for (final other in alternatives) {
      if (other.id == expected.id) continue;
      if (_score(other, series) > mine + _margin) {
        return SignatureVerdict(
          accepted: false,
          complaint: 'That is not the movement for this round',
          lookedLike: other.id,
        );
      }
    }

    return const SignatureVerdict(accepted: true);
  }

  /// How much better a rival has to fit before the rep is refused. Zero would
  /// make every near-tie a rejection, and a lifter whose reps are thrown out
  /// for reasons they cannot see stops using the app.
  static const _margin = 0.15;

  double _score(MovementSignature signature, Map<Channel, ChannelReading> series) {
    final judged =
        signature.rules.where((r) => series.containsKey(r.channel)).toList();
    if (judged.isEmpty) return 0;
    final passed =
        judged.where((r) => r.satisfied(series[r.channel]!)).length;
    return passed / judged.length;
  }

  String? _bestAlternative(Map<Channel, ChannelReading> series) {
    String? best;
    var bestScore = 0.75; // below this it is not a confident call
    for (final other in alternatives) {
      if (other.id == expected.id) continue;
      final score = _score(other, series);
      if (score > bestScore) {
        bestScore = score;
        best = other.id;
      }
    }
    return best;
  }

  Map<Channel, ChannelReading> _measure(List<BodyPose> frames) {
    final collected = <Channel, List<double>>{};
    for (final pose in frames) {
      for (final channel in Channel.values) {
        final value = readChannel(pose, channel);
        if (value != null) {
          collected.putIfAbsent(channel, () => []).add(value);
        }
      }
    }
    return {
      for (final entry in collected.entries)
        if (entry.value.length >= minFrames) entry.key: ChannelReading(entry.value),
    };
  }
}

const _elbowSpec = AngleSpec(
  Joint.leftShoulder,
  Joint.leftElbow,
  Joint.leftWrist,
);
const _shoulderSpec = AngleSpec(
  Joint.leftElbow,
  Joint.leftShoulder,
  Joint.leftHip,
);
const _kneeSpec = AngleSpec(Joint.leftHip, Joint.leftKnee, Joint.leftAnkle);
const _hipSpec = AngleSpec(Joint.leftShoulder, Joint.leftHip, Joint.leftKnee);

/// One channel's value for one frame, or null when the joints it needs are not
/// visible.
double? readChannel(BodyPose pose, Channel channel) => switch (channel) {
      Channel.elbow => _elbowSpec.measure(pose),
      Channel.shoulder => _shoulderSpec.measure(pose),
      Channel.knee => _kneeSpec.measure(pose),
      Channel.hip => _hipSpec.measure(pose),
      Channel.torsoPitch => _torsoPitch(pose),
      Channel.wristHeight => _wristHeight(pose),
    };

/// Degrees away from standing upright. Uses image y, which is why it survives
/// a phone propped at an angle better than anything depth-based would.
double? _torsoPitch(BodyPose pose) {
  final shoulder = _midpoint(pose, Joint.leftShoulder, Joint.rightShoulder);
  final hip = _midpoint(pose, Joint.leftHip, Joint.rightHip);
  if (shoulder == null || hip == null) return null;

  final dx = (hip.$1 - shoulder.$1).abs();
  final dy = (hip.$2 - shoulder.$2).abs();
  if (dx == 0 && dy == 0) return null;
  return math.atan2(dx, dy) * 180 / math.pi;
}

/// How far the hands sit above the shoulders, as a fraction of torso length.
/// Negative is above.
///
/// Divided by the torso's **full** length, not its vertical extent. The
/// vertical extent is what a first version used, and it collapses towards zero
/// the moment the body goes horizontal — which is exactly when a push-up is
/// happening. Dividing by it turned a hand at shoulder height into a reading
/// of twenty, and every push-up rep was refused for it.
double? _wristHeight(BodyPose pose) {
  final shoulder = _midpoint(pose, Joint.leftShoulder, Joint.rightShoulder);
  final hip = _midpoint(pose, Joint.leftHip, Joint.rightHip);
  final wrist = _midpoint(pose, Joint.leftWrist, Joint.rightWrist);
  if (shoulder == null || hip == null || wrist == null) return null;

  final dx = hip.$1 - shoulder.$1;
  final dy = hip.$2 - shoulder.$2;
  final torso = math.sqrt(dx * dx + dy * dy);
  if (torso < 0.02) return null; // whole body too small in frame to trust
  return (wrist.$2 - shoulder.$2) / torso;
}

(double, double)? _midpoint(BodyPose pose, Joint a, Joint b) {
  final pa = pose.confident(a);
  final pb = pose.confident(b);
  if (pa != null && pb != null) {
    return ((pa.x + pb.x) / 2, (pa.y + pb.y) / 2);
  }
  final one = pa ?? pb;
  return one == null ? null : (one.x, one.y);
}
