/// One live match, as the camera screen sees the other phone: their count as
/// it moves, whether they are still there, and the one instant both rounds
/// start.
///
/// The counts travel phone to phone ([LiveLink]) because a number that lands
/// a second late is a number nobody can race. Nothing here decides who won:
/// the two sets do, on the server, at the end (supabase/live.sql).
library;

import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';

import 'backend/backend.dart';

class LiveSession extends ChangeNotifier {
  LiveSession(this.match);

  final LiveMatch match;

  LiveLink? _link;
  StreamSubscription<LiveMessage>? _sub;
  Timer? _heartbeat;
  Timer? _report;
  Timer? _checkIn;
  bool _closed = false;

  /// Their count, as far as this phone has heard.
  int opponentReps = 0;

  /// They pressed Give up; their count will not move again.
  bool opponentGaveUp = false;

  /// The match ended before a round was played: the other lifter never got
  /// into position, or left the pairing. Nothing is recorded.
  bool calledOff = false;

  /// When the round started on this phone, once it has.
  DateTime? startedAt;

  DateTime? _lastHeard;
  int _myReps = 0;

  /// How long their phone may go quiet before the screen says so. They send
  /// every second whether or not the count moved, so this is three missed.
  static const quietFor = Duration(milliseconds: 3500);

  /// Their phone has gone quiet mid-round. Their count stays where it was
  /// and the round carries on: it finishes on the clock.
  bool get opponentAway {
    if (startedAt == null || opponentGaveUp) return false;
    final since = clock.now().difference(_lastHeard ?? startedAt!);
    return since > quietFor;
  }

  /// Opens the line. Before the countdown, so the first rep of the round is
  /// not the first message either phone has tried to send.
  void open() {
    if (_link != null || _closed) return;
    try {
      final link = backend.openLiveLink(match.id);
      _link = link;
      _sub = link.messages.listen(_heard);
    } on Object catch (error) {
      debugPrint('Could not open the live line: $error');
    }
  }

  void _heard(LiveMessage message) {
    _lastHeard = clock.now();
    // A late message never takes the count backwards.
    if (message.reps > opponentReps) opponentReps = message.reps;
    if (message.gaveUp) opponentGaveUp = true;
    notifyListeners();
  }

  /// Tells the server this lifter is in position, and waits for the other.
  /// Returns the instant the round starts on this phone, or null when the
  /// match was called off instead.
  Future<DateTime?> ready() async {
    final waitUntil = clock.now().add(const Duration(seconds: 100));
    Duration? startsIn;
    try {
      startsIn = await backend.liveReady(match.id);
    } on Object catch (error) {
      debugPrint('Could not say ready: $error');
    }
    while (startsIn == null && !_closed) {
      if (clock.now().isAfter(waitUntil)) break;
      await Future<void>.delayed(const Duration(milliseconds: 700));
      try {
        final state = await backend.liveState(match.id);
        if (state.status.calledOff) break;
        startsIn = state.startsIn;
        // Said ready while the line to the server was down: say it again.
        if (startsIn == null && !state.theyAreReady) continue;
        startsIn ??= await backend.liveReady(match.id);
      } on Object catch (error) {
        debugPrint('Could not read the live match: $error');
      }
    }
    if (startsIn == null) {
      calledOff = true;
      notifyListeners();
      return null;
    }
    return clock.now().add(startsIn);
  }

  /// The round has started on this phone.
  void start() {
    startedAt = clock.now();
    _heartbeat = Timer.periodic(const Duration(seconds: 1), (_) => _send());
    // The server's copy, for a phone that drops out before the end.
    _report = Timer.periodic(const Duration(seconds: 3), (_) {
      unawaited(
        backend
            .reportLiveCount(match.id, _myReps)
            .catchError((Object error) => debugPrint('$error')),
      );
    });
    // If the line itself is what failed, the server still hears both phones.
    _checkIn = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (!opponentAway) return;
      try {
        final state = await backend.liveState(match.id);
        if (state.theirReps > opponentReps) {
          opponentReps = state.theirReps;
          notifyListeners();
        }
      } on Object catch (_) {
        // Nothing to add: the screen already says they have gone quiet.
      }
    });
    notifyListeners();
  }

  /// A rep landed on this phone.
  void counted(int reps) {
    _myReps = reps;
    _send();
  }

  /// This lifter pressed Give up.
  void gaveUp() => _send(gaveUp: true);

  void _send({bool gaveUp = false}) {
    final link = _link;
    if (link == null || _closed) return;
    unawaited(
      link
          .send(LiveMessage(reps: _myReps, gaveUp: gaveUp))
          .catchError((Object error) => debugPrint('Live send failed: $error')),
    );
  }

  /// The round is over on this phone.
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _heartbeat?.cancel();
    _report?.cancel();
    _checkIn?.cancel();
    // Not awaited: nothing to clean up when this listener leaves.
    final sub = _sub;
    if (sub != null) unawaited(sub.cancel());
    try {
      await _link?.close();
    } on Object catch (_) {}
  }

  @override
  void dispose() {
    unawaited(close());
    super.dispose();
  }
}
