/// The other phone, played by this one: answers the live match screen the
/// way the server and a real opponent's phone would, with the opponent's
/// count moving the way the plan says.
library;

import 'dart:async';
import 'dart:math' as math;

import 'package:clock/clock.dart';

import '../backend/backend.dart';
import '../reps/pushup_counter.dart';
import 'plan.dart';

class PromoBackend extends NoBackend {
  PromoBackend(this.plan);

  final PromoPlan plan;
  _PromoLink? _link;

  LiveOpponent get opponent => LiveOpponent(
    id: 'promo-opponent',
    username: plan.oppName,
    tierIdx: plan.oppTier,
    divIdx: plan.oppDiv,
  );

  /// The opponent's count as it stands.
  int get opponentReps => _link?.reps ?? 0;

  /// Theirs at the end, for the result. Following you, it is exactly the
  /// planned gap — a rep of yours in the last half second would otherwise
  /// end the round before their answer to it lands.
  int finalReps(PushupCount? yours) => switch (plan.mode) {
    OpponentMode.behind when yours != null && !yours.gaveUp =>
      math.max(0, yours.reps - plan.behindBy),
    _ => opponentReps,
  };

  /// When each of theirs landed, for the race chart, as many as [count].
  List<int> repTimes(int count) =>
      (_link?.landed ?? const <int>[]).take(count).toList();

  @override
  LiveLink openLiveLink(String matchId) {
    _link?.close();
    return _link = _PromoLink(plan);
  }

  /// Both "on camera": the round starts [PromoPlan.countdownSeconds] from now,
  /// and the opponent's reps are timed from that instant.
  @override
  Future<Duration?> liveReady(String matchId) async {
    final startsIn = Duration(seconds: plan.countdownSeconds);
    _link?.startAt(clock.now().add(startsIn));
    return startsIn;
  }

  @override
  Future<LiveState> liveState(String matchId) async => LiveState(
    status: LiveStatus.live,
    ranked: true,
    opponent: opponent,
    theyAreReady: true,
    theirReps: opponentReps,
  );

  @override
  Future<void> reportLiveCount(String matchId, int reps) async {}
}

class _PromoLink implements LiveLink {
  _PromoLink(this.plan) {
    // A word every 800 ms, as a real phone sends one every second: a line
    // that goes quiet reads on the screen as the opponent having gone.
    _heartbeat = Timer.periodic(
      const Duration(milliseconds: 800),
      (_) => _say(),
    );
  }

  final PromoPlan plan;
  final _messages = StreamController<LiveMessage>.broadcast();
  final _timers = <Timer>[];
  Timer? _heartbeat;
  final _random = math.Random();
  int reps = 0;
  int _yours = 0;
  bool _closed = false;
  DateTime? _start;

  /// When each rep landed, in milliseconds from the start of the round.
  final landed = <int>[];

  @override
  Stream<LiveMessage> get messages => _messages.stream;

  void _say() {
    if (_closed) return;
    _messages.add(LiveMessage(reps: reps));
  }

  void _land(int count) {
    if (_closed || count <= reps) return;
    final start = _start;
    if (start != null) {
      final at = clock.now().difference(start).inMilliseconds;
      for (var k = reps; k < count; k++) {
        landed.add(at.clamp(0, PromoPlan.roundMs));
      }
    }
    reps = count;
    _say();
  }

  /// The round starts at [start]: every planned rep is set to land on its
  /// second.
  void startAt(DateTime start) {
    _start = start;
    final times = plan.repTimesMs();
    for (var k = 0; k < times.length; k++) {
      final at = start.add(Duration(milliseconds: times[k]));
      final wait = at.difference(clock.now());
      final count = k + 1;
      _timers.add(Timer(wait.isNegative ? Duration.zero : wait, () => _land(count)));
    }
  }

  /// This phone's count, as the screen sends it. Following you, the opponent
  /// answers a moment later, the planned number of reps behind.
  @override
  Future<void> send(LiveMessage message) async {
    if (plan.mode != OpponentMode.behind) return;
    if (message.reps <= _yours) return;
    _yours = message.reps;
    final target = math.max(0, _yours - plan.behindBy);
    if (target <= reps) return;
    final delay = Duration(milliseconds: 250 + _random.nextInt(450));
    _timers.add(Timer(delay, () => _land(target)));
  }

  @override
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _heartbeat?.cancel();
    for (final t in _timers) {
      t.cancel();
    }
    await _messages.close();
  }
}
