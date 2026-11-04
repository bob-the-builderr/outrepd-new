import 'dart:async';
import 'dart:math' as math;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'
    show openAppSettings;

import '../reps/exercise_type.dart';
import '../reps/pose.dart';
import '../reps/pose_source.dart';
import '../reps/posture.dart';
import '../reps/skeleton.dart';
import '../reps/pushup_counter.dart';
import '../reps/recording.dart';
import '../data.dart';
import '../keep_awake.dart';
import '../live.dart';
import '../motion.dart';
import '../settings.dart';
import '../sounds.dart';
import '../avatar.dart';
import '../player_avatar.dart';
import '../l10n/app_localizations.dart';
import '../type_scale.dart';
import '../theme.dart';
import '../widgets.dart';

/// Everything the camera screen needs to know about the duel it is part of.
///
/// Null for practice. The opponent's count is their *final* number: it is paced
/// out across the clock so the bar moves, because a rival score that appears
/// all at once at the end is not something anybody can race.
class DuelContext {
  const DuelContext({
    required this.opponentName,
    required this.opponentReps,
    this.opponentRepTimes = const [],
    required this.opponentTierIdx,
    required this.opponentDivIdx,
    required this.rankLabel,
    this.opponentImage,
    this.opponentXp,
  });

  /// Their picture, when they have uploaded one; the drawn initial when not.
  final ImageProvider? opponentImage;

  final String opponentName;
  final int opponentReps;

  /// When each of the opponent's reps actually landed, milliseconds from the
  /// start of their set — read straight off their stored set. Empty when the
  /// opponent came from somewhere that never recorded it (a demo bout, or a
  /// set uploaded before this column existed), in which case the bar falls
  /// back to spreading the total evenly.
  final List<int> opponentRepTimes;

  /// Where they stand on the ladder, for the badge and the level on the score
  /// card. A label alone cannot draw a badge.
  final int opponentTierIdx;
  final int opponentDivIdx;

  /// Their experience, for the level beside the rank; null when unknown.
  final int? opponentXp;

  final String rankLabel;
}

/// A game played on the count: the adventure's fight. It draws the card over
/// the camera in place of the score card, and it may end the round early —
/// the moment the monster is down there is nothing left to count towards.
///
/// The camera counts exactly as it always does; the game only reads the
/// number.
abstract class CameraGame {
  Widget card(
    BuildContext context, {
    required int reps,
    required Duration remaining,
    required bool counting,
    required VoidCallback onStop,
  });

  /// Whether [reps] finish it.
  bool wonAt(int reps);

  /// What stands beside the camera in place of the depth bar: [progress] is
  /// the rep's reading, as the bar would show it, and [pastBottom] whether
  /// this rep has been down past the bottom line.
  Widget track(
    BuildContext context, {
    required double progress,
    required bool pastBottom,
  });

  /// The count down to the start, drawn over the camera's own box.
  Widget countdown(BuildContext context, int seconds);
}

/// The camera. Counts push-ups, and — when it is part of a duel — carries the
/// score, the clock and what is riding on them.
class TrainerScreen extends StatefulWidget {
  const TrainerScreen({
    super.key,
    this.autoStart = false,
    this.forMatch = false,
    this.limit,
    this.duel,
    this.game,
    this.poseSource,
    this.live,
  });

  /// The adventure's fight, drawn over the camera instead of the score card.
  /// Null for everything else.
  final CameraGame? game;

  /// A live match: the other lifter is on camera right now, their count comes
  /// from their phone as it moves, and the round starts ten seconds after
  /// both are on this screen — the same instant on both phones, in position
  /// or not. Null for everything else.
  final LiveSession? live;

  /// Where poses come from. Defaults to the camera; a test hands in a scripted
  /// stream, which is the only way to reach the stages that live behind a
  /// working camera — the framing gate, the countdown and the live HUD.
  final PoseSource Function()? poseSource;

  /// The duel this session belongs to, or null when nobody is on the other
  /// side.
  final DuelContext? duel;

  /// Opens straight into a session rather than waiting for a tap. There is no
  /// longer a picker to skip; what is left is whether the lifter gets a moment
  /// to prop the phone up first.
  final bool autoStart;

  /// Opened from inside a duel. Finishing hands the count back to the match
  /// rather than returning here.
  final bool forMatch;

  /// Ends the session by itself after this long. A match round is a fixed
  /// window — the same question put to both lifters — so it cannot be left to
  /// whoever remembers to press finish.
  final Duration? limit;

  @override
  State<TrainerScreen> createState() => _TrainerScreenState();
}

enum _Stage {
  setup,

  /// Camera open, clock not started. Nothing counts until the lifter is
  /// actually in shot — starting a 60 second duel while somebody is still
  /// propping their phone against a water bottle loses them the match before
  /// they have touched the floor.
  positioning,

  /// Three seconds, so the start is a moment rather than an ambush. Ten in a
  /// live match, counted from both lifters arriving, to get down in.
  countdown,

  counting,
}

class _TrainerScreenState extends State<TrainerScreen>
    with WidgetsBindingObserver {
  PoseSource? _source;
  StreamSubscription<BodyPose>? _sub;

  /// The bout's clock: stopped until the countdown ends.
  final _clock = clock.stopwatch();

  /// Time since the camera opened, which is what the counter is fed. Poses
  /// carry no timestamp, and the counter judges everything in milliseconds —
  /// phones deliver poses at whatever rate they manage.
  final _poseClock = clock.stopwatch();

  /// Where on [_poseClock] the round began. Null before it has.
  int? _boutStartMs;

  Timer? _watchdog;

  _Stage _stage = _Stage.setup;
  BodyPose _pose = BodyPose.empty;
  String? _error;
  PoseSourceFailure? _failure;

  /// The count, the bar and the cue — one tracker for all three, so the bar
  /// reaching the top and the number moving are the same event. It runs from
  /// the moment the camera opens, so by the time the round starts it already
  /// knows where the hands are and how high this lifter's lockout is; the
  /// count itself restarts from zero when the countdown ends.
  PushupTracker? _tracker;

  /// How far through a rep the body is, 1 at the top. Null until the tracker
  /// has a floor and a head to measure between.
  double? _progress;

  /// Down past the bottom line this rep: the top line is the one lit.
  bool _pastBottom = false;

  /// Hidden by default — it is for working out why the counter is misbehaving,
  /// not something to have on screen while lifting. A long press on the count
  /// reveals it.
  bool _showNumbers = false;

  /// Every pose of the session, kept so the set can be replayed against a
  /// changed threshold instead of being performed again — the round, and the
  /// last few seconds before it that the tracker warmed up on.
  final _recorded = <RecordedFrame>[];

  /// How much of the time before the round is kept in the recording, ms. The
  /// tracker's longest memory is three seconds of shoulder width; this is
  /// comfortably more, and bounded however long somebody takes to get down.
  static const _warmupKeptMs = 8000;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.live?.addListener(_liveChanged);
    widget.live?.open();
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _begin());
    }
  }

  /// Their count moved, or their phone went quiet.
  void _liveChanged() {
    if (mounted) setState(() {});
  }

  /// Whether the camera was let go because the app left the screen, and is
  /// owed a restart when it comes back.
  bool _suspended = false;

  /// A call, the notification shade, switching apps: the camera goes, and it
  /// does not come back by itself — the preview stays black and the count
  /// stops while the round's clock runs on. So it is let go on the way out
  /// and opened again on the way back. The clock is not paused: stepping away
  /// is not a way to rest mid-round, and the "get back in frame" banner
  /// already says the clock is still running.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive || AppLifecycleState.paused:
        _releaseCamera();
      case AppLifecycleState.resumed:
        _resumeCamera();
      default:
        break;
    }
  }

  /// Stops listening to the camera. Not awaited: the pose stream has nothing
  /// to clean up when a listener leaves, and a cancel on a broadcast stream
  /// hands back a future from outside the screen's zone, which a widget
  /// test's fake clock never runs — the round would never end there.
  void _dropPoses() {
    final sub = _sub;
    _sub = null;
    if (sub != null) unawaited(sub.cancel());
  }

  Future<void> _releaseCamera() async {
    final source = _source;
    if (source == null || _suspended || _stage == _Stage.setup) return;
    _suspended = true;
    _dropPoses();
    if (mounted) setState(() => _source = null);
    await source.dispose();
  }

  Future<void> _resumeCamera() async {
    if (!_suspended || _stage == _Stage.setup) return;
    _suspended = false;
    final source = widget.poseSource?.call() ?? createPoseSource();
    try {
      await source.start();
    } on Object catch (error) {
      debugPrint('Could not reopen the camera: $error');
      if (mounted) {
        setState(() {
          _error = error.toString();
          _failure = error is PoseSourceError
              ? error.kind
              : PoseSourceFailure.unknown;
        });
      }
      return;
    }
    if (!mounted || _stage == _Stage.setup) {
      await source.dispose();
      return;
    }
    _sub = source.poses.listen(_onPose);
    setState(() => _source = source);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.live?.removeListener(_liveChanged);
    keepScreenOn(false);
    _countdownTimer?.cancel();
    _watchdog?.cancel();
    _sub?.cancel();
    _source?.dispose();
    super.dispose();
  }

  Future<void> _begin() async {
    final source = widget.poseSource?.call() ?? createPoseSource();
    try {
      await source.start();
    } on Object catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _failure = e is PoseSourceError ? e.kind : PoseSourceFailure.unknown;
        });
      }
      return;
    }
    if (!mounted) {
      await source.dispose();
      return;
    }

    final tracker = PushupTracker();
    // Reset but not started: the clock belongs to the bout, and the bout has
    // not begun.
    _clock
      ..stop()
      ..reset();
    _poseClock
      ..reset()
      ..start();
    _boutStartMs = null;

    // On until the round is over: nobody touches the phone during one.
    keepScreenOn(true);
    _sub = source.poses.listen(_onPose);
    _watchdog?.cancel();
    _watchdog = Timer.periodic(const Duration(milliseconds: 250), (_) {
      _watchForLostBody();
      // The round ends on the clock, not on a pose: a camera that stopped
      // delivering — gone with the app to the background, or simply lost —
      // must not leave a duel running forever.
      final limit = widget.limit;
      if (_stage == _Stage.counting &&
          limit != null &&
          _clock.elapsed >= limit) {
        _stop();
        return;
      }
      // Redraws the clock and the opponent between poses. Without this the
      // timer only moves when the lifter does, which stops dead at the top
      // of a rep.
      if (_stage == _Stage.counting && mounted) setState(() {});
    });

    _recorded.clear();
    _recent.clear();
    _liveReps = 0;
    _stopping = false;
    _won = false;
    _suspended = false;

    setState(() {
      _source = source;
      _tracker = tracker;
      _progress = null;
      _pastBottom = false;
      _stage = _Stage.positioning;
      _error = null;
      _failure = null;
      _lastPoseAt = DateTime.now();
    });

    // The count down starts the moment the camera is up, whether or not the
    // lifter is down yet: ten seconds to get into position, then the clock
    // runs (the user, 2026-10-29 — waiting for the position read as the
    // match not starting). Live, the server picks the instant, a fixed time
    // after both lifters reach this screen, so it starts for both at once.
    _startCountdown();
  }

  /// The number on the card: the tracker's count, moved on the frame the rep
  /// completes. It is the same number the round ends with — the verdict is
  /// read off this tracker, not re-scored afterwards.
  int _liveReps = 0;

  /// How many poses a second the phone is actually delivering. The counter
  /// works in milliseconds and does not need it; it goes on the diagnostics
  /// panel because a slow phone is worth knowing about.
  double? get _framesPerSecond {
    if (_recorded.length < 20) return null;
    final last = _recorded.last.atMs;
    final first = _recorded[_recorded.length - 20].atMs;
    final span = last - first;
    return span <= 0 ? null : 19 * 1000 / span;
  }

  void _record(int atMs, BodyPose pose) {
    _recorded.add(RecordedFrame(atMs, pose));
    if (_boutStartMs != null) return;
    var drop = 0;
    while (drop < _recorded.length &&
        atMs - _recorded[drop].atMs > _warmupKeptMs) {
      drop++;
    }
    if (drop > 0) _recorded.removeRange(0, drop);
  }

  /// When a usable pose last arrived. The stream keeps delivering frames when
  /// somebody steps out of shot — they just have nothing in them — so silence
  /// is not the signal. Absence of a *body* is.
  DateTime? _lastPoseAt;
  bool _lostBody = false;

  /// Long enough that turning to reach a towel does not put a banner on the
  /// screen, short enough that somebody who has walked off is told before they
  /// lose a round to it.
  static const _lostAfter = Duration(milliseconds: 1200);

  void _watchForLostBody() {
    final last = _lastPoseAt;
    if (last == null || _stage != _Stage.counting) return;
    final lost = DateTime.now().difference(last) > _lostAfter;
    if (lost != _lostBody && mounted) setState(() => _lostBody = lost);
  }

  /// The last second or so of poses, for the checks that need more than one
  /// frame — chiefly whether the hands are staying planted, which is what
  /// separates a push-up from any other movement up and down.
  final _recent = <BodyPose>[];
  static const _recentKeep = 40;

  /// Whether the lifter is down in position right now: [downInPosition],
  /// shared with the onboarding's calibration.
  bool get _inPosition => downInPosition(_recent);

  /// Seconds from the camera opening to the clock starting: room to get down
  /// into position, which the round no longer waits for.
  static const _countFrom = 10;

  int _countdown = _countFrom;
  Timer? _countdownTimer;

  /// In a live match, and waiting for the other lifter to reach this screen.
  bool _waitingForOpponent = false;

  void _startCountdown() {
    if (_stage != _Stage.positioning) return;
    final live = widget.live;
    if (live == null) {
      _countDownTo(null);
      return;
    }
    // Live: this phone being here is half of it. The server gives the round
    // one start once both are, and both phones count down to that instant.
    if (_waitingForOpponent) return;
    setState(() => _waitingForOpponent = true);
    live.ready().then((start) {
      if (!mounted) return;
      setState(() => _waitingForOpponent = false);
      if (start == null) {
        _callOff();
        return;
      }
      _countDownTo(start);
    });
  }

  /// Ten seconds down to the start. On this phone's own second when [start]
  /// is null; ending exactly at [start] when there is one, so two phones end
  /// theirs together — the server puts a live start ten seconds out too.
  void _countDownTo(DateTime? start) {
    setState(() {
      _stage = _Stage.countdown;
      _countdown = start == null ? _countFrom : _secondsTo(start);
    });
    Sounds.instance.play(Cue.count);
    _countdownTimer?.cancel();

    if (start != null) {
      _countdownTimer = Timer.periodic(const Duration(milliseconds: 100), (
        timer,
      ) {
        if (!mounted) return;
        final left = start.difference(clock.now());
        if (left <= Duration.zero) {
          timer.cancel();
          _beginRound();
          return;
        }
        final shown = _secondsTo(start);
        if (shown != _countdown) {
          setState(() => _countdown = shown);
          // A beep a second for ten seconds is noise: the first, then the
          // last three, which are the ones anybody counts along to.
          if (shown <= 3) {
            tap();
            Sounds.instance.play(Cue.count);
          }
        }
      });
      return;
    }

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_countdown > 1) {
        setState(() => _countdown--);
        // As live: the first beep, then the last three.
        if (_countdown <= 3) {
          tap();
          Sounds.instance.play(Cue.count);
        }
        return;
      }
      timer.cancel();
      _beginRound();
    });
  }

  /// Whole seconds until [start], rounded up: 10 at ten seconds out, 1 in
  /// the last.
  int _secondsTo(DateTime start) =>
      ((start.difference(clock.now()).inMilliseconds + 999) ~/ 1000).clamp(
        1,
        10,
      );

  void _beginRound() {
    // The bout starts here, and not one frame earlier. The tracker keeps
    // what it learned while the lifter got into position and starts its
    // count from nothing.
    final startMs = _poseClock.elapsedMilliseconds;
    _boutStartMs = startMs;
    _tracker?.restartCount(startMs);
    setState(() {
      _stage = _Stage.counting;
      _liveReps = 0;
    });
    _clock.start();
    _lastPoseAt = DateTime.now();
    widget.live?.start();
    tap(heavy: true);
    Sounds.instance.play(Cue.go);
  }

  /// Give up, after saying what it costs. A big red button on the score card
  /// is easy to find, which is the point, and easy to hit by mistake, which
  /// is not: one tap used to end the round as a loss on the spot.
  Future<void> _confirmGiveUp() async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (_) => _GiveUpCard(
        yours: () => _liveReps,
        theirs: () => _opponentReps,
        remaining: () => _remaining,
      ),
    );
    if (sure == true && mounted) await _stop(gaveUp: true);
  }

  /// A live match that never started: the other lifter never turned up.
  /// Nothing was lifted, so nothing goes back but the fact.
  Future<void> _callOff() async {
    if (_stopping) return;
    _stopping = true;
    _watchdog?.cancel();
    _dropPoses();
    await _source?.dispose();
    keepScreenOn(false);
    if (mounted) Navigator.of(context).pop();
  }

  /// How many the opponent is supposed to have by now.
  ///
  /// Real timings when their set has them: however many of their reps landed
  /// at or before this point on the clock, so the bar moves the way they
  /// actually moved — pausing where they paused, surging where they surged.
  ///
  /// Otherwise their final count spread evenly across the clock. Evenly is a
  /// lie — no lifter is metronomic, and the last ten seconds of a minute of
  /// push-ups are nothing like the first — but it is the only fallback for a
  /// set that never recorded when its reps landed, and a rival number that
  /// only appears at the end is not something anybody can race.
  int get _opponentReps {
    // Live: what their phone last said, as it said it.
    if (widget.live case final live?) return live.opponentReps;
    final duel = widget.duel;
    final limit = widget.limit;
    if (duel == null || limit == null || limit.inMilliseconds == 0) return 0;
    final elapsed = _clock.elapsedMilliseconds;

    final times = duel.opponentRepTimes;
    if (times.isNotEmpty) {
      var done = 0;
      for (final t in times) {
        if (t > elapsed) break;
        done++;
      }
      return done;
    }

    final share = elapsed / limit.inMilliseconds;
    return (duel.opponentReps * share.clamp(0.0, 1.0)).floor();
  }

  Duration get _remaining {
    final limit = widget.limit;
    if (limit == null) return Duration.zero;
    final left = limit - _clock.elapsed;
    return left.isNegative ? Duration.zero : left;
  }

  void _onPose(BodyPose pose) {
    final tracker = _tracker;
    if (tracker == null || !mounted) return;

    _lastPoseAt = DateTime.now();
    if (_lostBody) setState(() => _lostBody = false);

    _recent.add(pose);
    if (_recent.length > _recentKeep) _recent.removeAt(0);

    // The monster is down and the round is closing: the clock stopped on the
    // winning rep, and the tracker stops with it. A rep done in the moment
    // the round takes to close was never on the screen, and the number that
    // leaves this screen is the number that was on it.
    if (_won) return;

    // Every frame, from the moment the camera opens: the seconds spent
    // getting down are when the tracker learns where the hands are planted
    // and how high this lifter's lockout is, so the first rep of the round is
    // judged against them rather than against a guess.
    final atMs = _poseClock.elapsedMilliseconds;
    final reading = tracker.add(atMs, pose);
    _record(atMs, pose);

    // Waiting on nothing but the start: the other phone, live, and nobody's
    // position anywhere (the count down began as the camera opened). It used
    // to wait for the lifter to be down in position, and a round that did not
    // start until then read as one that would not start at all.
    if (_stage == _Stage.positioning) {
      setState(() => _pose = pose);
      return;
    }
    if (_stage == _Stage.countdown) {
      setState(() => _pose = pose);
      return;
    }

    // The number moves on the frame the rep completes — the frame the bar
    // gets back up to the top line — and never otherwise.
    if (reading.counted) {
      _liveReps = reading.reps;
      widget.live?.counted(reading.reps);
      tap(heavy: true);
      Sounds.instance.play(Cue.rep);

      // The rep that finishes the fight: the clock stops on it, and the
      // round closes a moment later so the last hit is seen landing and the
      // monster going down.
      if (widget.game?.wonAt(reading.reps) ?? false) {
        _won = true;
        _clock.stop();
        setState(() => _pose = pose);
        Timer(const Duration(milliseconds: 1600), () {
          if (mounted) _stop();
        });
        return;
      }
    }

    final limit = widget.limit;
    if (limit != null && _clock.elapsed >= limit) {
      _stop();
      return;
    }

    setState(() {
      _pose = pose;
      if (reading.progress != null) _progress = reading.progress;
      _pastBottom = reading.pastBottom;
    });
  }

  /// Saving must never lose the session it is trying to preserve, so a
  /// failure here is reported and swallowed rather than thrown.
  /// A recording without the real count proves nothing — there is no truth to
  /// measure the counter against. Asking here, while the set is still in mind,
  /// is the only moment anyone actually knows the answer.
  Future<int?> _askTrueCount() async {
    final field = TextEditingController();
    final answer = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _panel,
        title: Text(
          L.of(context).howManyReally,
          style: context.type.heading.copyWith(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L.of(context).howManyReallyHint,
              style: context.type.label.copyWith(color: _dim),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: field,
              autofocus: true,
              keyboardType: TextInputType.number,
              style: context.type.title.copyWith(color: Colors.white),
              decoration: InputDecoration(hintText: L.of(context).trueCountHint),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              L.of(context).skip,
              style: const TextStyle(color: _dim),
            ),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(int.tryParse(field.text.trim())),
            child: Text(
              L.of(context).save,
              style: const TextStyle(color: _accent),
            ),
          ),
        ],
      ),
    );
    field.dispose();
    return answer;
  }

  /// Saves the session and returns where it went, so the confirmed count can
  /// be written onto it once somebody has given one.
  Future<String?> _saveRecording() async {
    if (_recorded.length < 30) return null;

    // Never in a match. This prompt exists to label recordings for tuning the
    // counter, and the match already asks the same question in a form built
    // for a lifter rather than for research — asking twice in one round is how
    // people learn to dismiss both.
    final trueCount = widget.forMatch ? null : await _askTrueCount();
    if (!mounted) return null;
    try {
      final path = await PoseRecording(
        exerciseId: ExerciseType.pushUp.wireName,
        frames: List.of(_recorded),
        startMs: _boutStartMs,
        note: trueCount?.toString(),
      ).save();
      return path;
    } on Object catch (error) {
      // The path and the raw exception are for whoever pulls this recording
      // off the device to look at later, not for the lifter staring at this
      // screen — they get told plainly that saving failed, nothing more.
      debugPrint('Could not save the session: $error');
      if (mounted) {
        setState(() => _error = L.of(context).couldNotSaveSession);
      }
      return null;
    }
  }

  /// True when the lifter pressed Give up rather than finishing the round.
  /// It travels back with the count, because a duel that ends this way is a
  /// loss whatever the count says.
  bool _gaveUp = false;

  /// Set while a round is being wrapped up, so the clock and a late pose
  /// cannot both end it.
  bool _stopping = false;

  /// The game was won on the last rep counted and the round is closing.
  bool _won = false;

  Future<void> _stop({bool gaveUp = false}) async {
    if (_stopping) return;
    _stopping = true;
    _watchdog?.cancel();
    _gaveUp = gaveUp;
    // The other phone freezes this count and says why.
    if (gaveUp) widget.live?.gaveUp();
    // The number that leaves this screen is the number that was on it. The
    // old design re-scored the whole set at the end with a different counter,
    // and lifters watched one number all round and were handed another.
    //
    // Stopped before the countdown finished, nothing was done in the round.
    final tracker = _tracker;
    final counted = tracker == null || _boutStartMs == null
        ? const PushupCount(reps: 0, confident: false)
        : PushupCount.from(tracker, durationMs: _clock.elapsedMilliseconds);

    // The whole verdict travels back, not just the number: a set with a close
    // call in it — a rep only just deep enough, a dip only just short — goes
    // back marked unsure, and the confirm screen asks rather than presenting
    // a guess as a fact.
    final verdict = counted.surrendered(_gaveUp);
    // A round that ran and finished, not one abandoned before it began or
    // given up: nobody wants a fanfare for walking away.
    if (_boutStartMs != null && !_gaveUp) Sounds.instance.play(Cue.end);
    _dropPoses();
    await _source?.dispose();
    keepScreenOn(false);
    final recording = await _saveRecording();
    if (!mounted) return;

    // In a match the screen exists to produce one number. Handing it back and
    // closing is the whole contract; dropping the lifter on a picker mid-round
    // would be the app losing the thread of what they were doing.
    if (widget.forMatch) {
      Navigator.of(context).pop(verdict.withRecording(recording));
      return;
    }

    setState(() {
      _sub = null;
      _source = null;
      _tracker = null;
      _progress = null;
      _pastBottom = false;
      _pose = BodyPose.empty;
      _stage = _Stage.setup;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Empty and see-through once the camera is tracking, and it lets taps
      // through: the adventure's card puts Give up at its top line, where
      // this bar lies over it, and the bar was swallowing the tap.
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: IgnorePointer(
          ignoring: _stage != _Stage.setup,
          child: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            // No title. There is one movement, so naming it over a camera
            // already pointed at somebody doing it says nothing.
            titleTextStyle: context.type.title.copyWith(color: Colors.white),
            // Recalibrate and reset used to live here, and so did the back
            // button by default — three controls stacked over a screen meant
            // to hold nothing above the score card once the camera is
            // actually tracking somebody. Setup keeps its own way out; live
            // tracking's only way out is Give up, on the card itself.
            automaticallyImplyLeading: _stage == _Stage.setup,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: switch (_failure) {
        // A refused camera is not an error message to print at the bottom of a
        // form — it is the whole screen, because nothing on that form works
        // until it is resolved.
        PoseSourceFailure.permissionDenied => _cameraRefused(),
        PoseSourceFailure.noCamera => _noCamera(),
        _ => _stage == _Stage.setup ? _buildSetup() : _buildSession(),
      },
    );
  }

  Widget _cameraRefused() => BlockingNotice(
    icon: Icons.videocam_off_outlined,
    title: L.of(context).cameraNeededTitle,
    // Says where the video goes before asking for it. "Nothing is
    // uploaded" is the answer to the question everyone actually has when
    // an app wants their camera, and it is true here.
    body: L.of(context).cameraNeededBody,
    actionLabel: L.of(context).openSettings,
    onAction: () async {
      await openAppSettings();
      if (mounted) setState(() => _failure = null);
    },
    secondaryLabel: L.of(context).notNow,
    onSecondary: () => Navigator.of(context).maybePop(),
  );

  Widget _noCamera() => BlockingNotice(
    icon: Icons.videocam_off_outlined,
    title: L.of(context).noCameraTitle,
    // No settings to open and nothing to retry, so the only honest button
    // is the way back out.
    body: L.of(context).noCameraBody,
    actionLabel: L.of(context).backToHome,
    onAction: () => Navigator.of(context).maybePop(),
  );

  /// What is on screen before the camera opens: the framing hint, anything
  /// that went wrong last time, and the way in.
  ///
  /// This used to be the picker — a catch-all "any exercise" tile, then eighty
  /// named movements under six muscle headings. All of it is gone.
  Widget _buildSetup() {
    // Opening the camera by itself: nothing to read or press while it does.
    // The framing panel and Start used to flash up here before every match,
    // a black screen about wrists and ankles between the match and the
    // camera. Unless the last try failed, and there is something to say.
    if (widget.autoStart && _error == null) return const SizedBox.expand();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 110, 16, 24),
      children: [
        _DarkPanel(
          child: Row(
            children: [
              const Icon(Icons.videocam_outlined, color: _accent),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  L.of(context).framingHint,
                  style: context.type.label.copyWith(color: _dim),
                ),
              ),
            ],
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 14),
          Text(
            _error!,
            style: context.type.label.copyWith(color: AppColors.loss),
          ),
        ],
        const SizedBox(height: 22),
        FilledButton.icon(
          onPressed: _begin,
          icon: const Icon(Icons.play_arrow),
          label: Text(L.of(context).start),
        ),
      ],
    );
  }

  Widget _buildSession() {
    final live = _source?.isLive ?? false;

    // Green means "you are down in position and counting". It used to mean
    // "your body is in a straight line", which a person standing in front of
    // the phone satisfies perfectly — so it went green before anybody had got
    // onto the floor, and told them reps were being watched for when they
    // were not.
    //
    // Once the round is on, it is the one thing the count itself requires:
    // the hands on the floor. A body-shape check here used to turn the bar
    // red through reps that were counting — at the bottom of a rep filmed
    // head-on the torso reads as upright — and a colour that disagrees with
    // the number is worse than none.
    final ready = _stage == _Stage.counting
        ? (_tracker?.planted ?? false)
        : _inPosition;

    // The camera fills the whole screen; what is drawn over it keeps clear of
    // the phone's own furniture. On an iPhone with a Dynamic Island the
    // status bar is about sixty points tall, so a card at a fixed 36 sat
    // under the clock and the island, and a label 12 from the bottom sat
    // under the home bar and the rounded corner. [top] and [bottom] are where
    // the screen's free space starts, never less than the old fixed margins.
    final insets = MediaQuery.paddingOf(context);
    final top = math.max(36.0, insets.top + 8);
    final bottom = insets.bottom;

    // A game (the adventure's fight) frames the camera under its card, with
    // its own track beside it, as the reference the user picked does; the
    // camera fills the screen everywhere else.
    final game = widget.game;

    // The camera, and the skeleton over it, in whatever box they are given:
    // the preview covers it and the painter crops the same way.
    final cameraView = Stack(
      fit: StackFit.expand,
      children: [
        _source?.buildPreview(context) ?? const ColoredBox(color: Colors.black),

        // The skeleton goes over whatever is behind it, in the app's cream:
        // faint while the lifter is getting into position, bright once they
        // are in it (and, mid-round, while the hands stay planted). It is
        // feedback, not a gate on the count: a rep with a sagging hip is
        // still a rep somebody did, and a count that silently withheld it
        // would be the app calling them a liar. One colour throughout — red
        // for "not yet" read as an error before anything had gone wrong.
        //
        // Hidden when the lifter has turned it off in settings. The count
        // does not change either way — this is the picture, not the
        // reading — but some people find it easier to lift without a
        // figure drawn over them.
        if (settings.showSkeleton)
          CustomPaint(
            painter: SkeletonPainter(
              pose: _pose,
              good: ready,
              mirror: live,
              sourceSize: _source?.sourceSize,
            ),
          ),
      ],
    );

    // A long press anywhere shows the numbers behind the position check.
    // It used to be a hidden sixty-pixel box in the corner of practice mode,
    // which is no use to somebody on the floor wondering why the skeleton is
    // not green — and that question is the one this panel exists to answer.
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: () => setState(() => _showNumbers = !_showNumbers),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (game == null)
            cameraView
          else
            const ColoredBox(color: Color(0xFF121110)),

          // The score sits straight on the camera now (design B, 2026-11-02),
          // with no card behind it: this shade from the top is what keeps the
          // numbers readable over a bright room.
          if (game == null)
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: top + 260,
              child: const IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xC7000000),
                        Color(0x80000000),
                        Color(0x00000000),
                      ],
                      stops: [0, 0.55, 1],
                    ),
                  ),
                ),
              ),
            ),

          // The score, the clock, and the rival — pinned to the top from the
          // moment the camera opens, so the numbers are in the same place before
          // and during the bout instead of appearing when it starts.
          //
          // Down to just above the cue, because the depth bar hangs under the
          // card in the same column: how tall the card is depends on what it
          // holds, and a bar pinned at a fixed height once ended up drawn
          // across its corner.
          Positioned(
            left: 14,
            right: 14,
            top: top,
            bottom: 96 + bottom,
            child: game != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      game.card(
                        context,
                        reps: _liveReps,
                        remaining: _remaining,
                        counting: _stage == _Stage.counting,
                        // Nothing on the ladder to lose, so no question
                        // first: the fight is simply not won.
                        onStop: () => _stop(gaveUp: true),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                // The count down over the camera, letting
                                // taps through: the card above, and its Give
                                // up, are the fight's own from the start.
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    cameraView,
                                    if (_stage == _Stage.countdown)
                                      IgnorePointer(
                                        child: game.countdown(
                                          context,
                                          _countdown,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // At rest at the top until the round is on.
                            SizedBox(
                              width: 44,
                              child: game.track(
                                context,
                                progress: _stage == _Stage.counting
                                    ? (_progress ?? 0)
                                    : 1,
                                pastBottom: _pastBottom,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                    _ScoreCard(
                      key: const Key('scoreCard'),
                      yours: _liveReps,
                      theirs: _opponentReps,
                      remaining: _remaining,
                      limit: widget.limit,
                      duel: widget.duel,
                      live: _stage == _Stage.counting,
                      session: widget.live,
                      onStop: widget.duel == null
                          ? () => _stop()
                          : _confirmGiveUp,
                    ),
                // Live, when the other phone has gone quiet or given up: the
                // number that stopped moving needs a reason beside it, or it
                // reads as the lifter having simply stopped.
                if (widget.live case final live?
                    when live.opponentGaveUp || live.opponentAway)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121110),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: context.colors.border,
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      live.opponentGaveUp
                          ? L.of(context).opponentGaveUp(
                              live.match.opponent.username,
                            )
                          : L.of(context).opponentDropped(
                              live.match.opponent.username,
                            ),
                      style: const TextStyle(
                        color: Color(0xFFC9C1B6),
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ),

                // How deep this rep is, as a bar that fills from the bottom. On
                // the left, under the card: the phone is on the floor and the
                // lifter is looking down the screen at it from a push-up, so
                // the upper left edge is where a glance actually lands. Wide
                // enough to read at that angle without turning the head, and
                // shorter on a short phone rather than running into the cue.
                if (_stage == _Stage.counting)
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 14),
                      child: Align(
                        alignment: Alignment.topLeft,
                        // Three points further out than the card, where it
                        // has always sat: as near the edge as a thumb allows.
                        child: Transform.translate(
                          offset: const Offset(-3, 0),
                          child: DepthBar(
                            key: const Key('depthBar'),
                            progress: _progress ?? 0,
                            good: ready,
                            pastBottom: _pastBottom,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          if (_stage == _Stage.positioning)
            Positioned(
              left: 0,
              right: 0,
              bottom: 60 + bottom,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121110).withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      // Live, and this lifter is here: the wait is the other
                      // one now, and the screen says whose.
                      _waitingForOpponent
                          ? L.of(context).waitingToJoin(
                              widget.live!.match.opponent.username,
                            )
                          : L.of(context).getIntoPosition,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Text(
                      L.of(context).framingHint,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFC9C1B6),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // A game counts down over its camera (above); everything else over
          // the whole screen.
          if (_stage == _Stage.countdown && game == null) ...[
            // Drawn over the card but not in its way: its Give up stays
            // tappable through the count down.
            const Positioned.fill(
              child: IgnorePointer(
                child: ColoredBox(color: Color(0x8C121110)),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height * 0.34,
              child: Column(
                children: [
                  Text(
                    L.of(context).getReady,
                    style: const TextStyle(
                      color: Color(0xFFC9C1B6),
                      fontSize: 12,
                      letterSpacing: 3,
                    ),
                  ),
                  Text(
                    localNumber(context, _countdown),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 74,
                      fontWeight: FontWeight.w500,
                      height: 1.1,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Over everything, because it is the only thing worth reading while
          // it is up. The scrim lifts the camera image so white text on a bright
          // gym wall stays legible.
          if (_lostBody)
            Positioned.fill(
              child: ColoredBox(
                color: const Color(0xFF2E2A26).withValues(alpha: 0.82),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.person_off_outlined,
                          size: 28,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          L.of(context).getBackInFrame,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Says the cost out loud. Somebody who thinks the app
                        // paused when they stepped away comes back to a round
                        // they have already lost and blames the counter.
                        Text(
                          L.of(context).clockStillRunning,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFFC9C1B6),
                            fontSize: 13,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // The meter is the part that goes wrong quietly: the angle can sit
          // still, or the calibrated ends can land somewhere unreachable, and
          // from the outside both just look like "it is not counting". One
          // screenshot of this answers which.
          if (_showNumbers)
            Positioned(
              left: 14,
              top: top + 74,
              child: _Diagnostics(
                recent: _recent,
                inPosition: _inPosition,
                planted: _tracker?.planted ?? false,
                lockout: _tracker?.lockout,
                framesPerSecond: _framesPerSecond,
                progress: _progress,
                reps: _liveReps,
              ),
            ),

          // One line at a time, and only when there is something to say. The
          // count moved to the top card, so what is left down here is the thing
          // the lifter should do differently — a broken form rule if there is
          // one, otherwise which way to move next.
          if (_stage == _Stage.counting)
            Positioned(
              left: 0,
              right: 0,
              bottom: 44 + bottom,
              child: Center(child: _Cue(progress: _progress)),
            ),

          if (!live)
            Positioned(
              left: 0,
              right: 0,
              bottom: 82 + bottom,
              child: Center(
                // Not translated on purpose: this only ever appears in the
                // web preview, where there is no camera to open. Nobody who
                // installs the app can reach it.
                child: const Text(
                  'Demo body — no camera in the browser',
                  style: TextStyle(color: Color(0xFFC9C1B6), fontSize: 13),
                ),
              ),
            ),

          // What is riding on this. Small: it is not what anybody is here for.
          // The way out is on the score card, where it can be found.
          Positioned(
            left: 12,
            right: 12,
            bottom: 12 + bottom,
            child: Row(
              children: [
                if (widget.duel case final duel?)
                  // Flexible, because the rank label runs long in several of
                  // the thirteen languages.
                  Flexible(
                    child: Text(
                      duel.rankLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
                else
                  // Practice has nothing at stake, so the corner holds the way
                  // into the diagnostics instead.
                  GestureDetector(
                    onLongPress: () =>
                        setState(() => _showNumbers = !_showNumbers),
                    child: const SizedBox(width: 60, height: 20),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// This screen keeps its own dark surfaces rather than the app's themed ones.
/// It is a viewfinder: a white page behind a camera feed would blind the
/// lifter and wash out the overlay, whichever theme the rest of the app is in.
const _accent = Color(0xFF4BB8FA);
const _dim = Color(0xFF9AA6B4);
const _panel = Color(0xFF11161C);
const _panelEdge = Color(0xFF232C36);

/// Giving up: the one red thing on the camera screen, because it is the one
/// thing on it that costs a match.
const _giveUpRed = Color(0xFFE24B4A);

class _DarkPanel extends StatelessWidget {
  const _DarkPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _panelEdge),
      ),
      child: child,
    );
    return content;
  }
}

/// What the counter is actually seeing, in numbers.
class _Diagnostics extends StatelessWidget {
  const _Diagnostics({
    required this.recent,
    required this.inPosition,
    required this.planted,
    required this.lockout,
    required this.framesPerSecond,
    required this.progress,
    required this.reps,
  });

  /// Poses a second, measured. A slow phone is worth knowing about.
  final double? framesPerSecond;

  /// The last second of poses, so the position check can be shown with the
  /// number behind it rather than as a yes or no.
  final List<BodyPose> recent;

  /// The check that starts the countdown.
  final bool inPosition;

  /// Whether the counter has the hands on the floor — without it, nothing
  /// counts.
  final bool planted;

  /// What a full bar means: the nose's height above the hands at lockout, in
  /// shoulder widths. Near 1.0 on every set measured.
  final double? lockout;

  final double? progress;
  final int reps;

  @override
  Widget build(BuildContext context) {
    // Why the screen says what it says. This is the panel to read out when
    // the skeleton will not go green or a rep did not count: it shows which
    // check is failing and by how much, which is the difference between
    // tuning a threshold and guessing at one.
    final shape = _torsoOverShoulders(recent.isEmpty ? null : recent.last);
    final tracked = recent.isNotEmpty && recent.last.isTracked;

    final lines = <String>[
      'position ${inPosition ? 'IN' : 'no'}',
      'hands    ${planted ? 'planted' : 'moving'}',
      'torso    ${shape == null ? '—' : shape.toStringAsFixed(2)}'
          '  (needs ${kUprightTorso.toStringAsFixed(2)} or less)',
      'fps      ${framesPerSecond == null ? '—' : framesPerSecond!.toStringAsFixed(1)}',
      'bar      ${progress == null ? '—' : '${(progress! * 100).round()}%'}'
          '  (down ${(kBottomShare * 100).round()}%, up ${(kTopShare * 100).round()}%)',
      'lockout  ${lockout == null ? '—' : lockout!.toStringAsFixed(2)}',
      'reps     $reps',
      if (!tracked) 'lost the body',
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final line in lines)
              Text(
                line,
                style: context.type.label.copyWith(
                  color: Colors.white,
                  height: 1.5,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Torso length over shoulder width: under the threshold the body is pointing
/// away from the lens, which is what a push-up looks like head-on.
double? _torsoOverShoulders(BodyPose? pose) {
  if (pose == null) return null;
  final shoulder = midpoint(pose, Joint.leftShoulder, Joint.rightShoulder);
  final hip = midpoint(pose, Joint.leftHip, Joint.rightHip);
  final width = shoulderWidth(pose);
  if (shoulder == null || hip == null || width == null) return null;
  return math.sqrt(
        math.pow(shoulder.$1 - hip.$1, 2) + math.pow(shoulder.$2 - hip.$2, 2),
      ) /
      width;
}

/// The score over the camera (design B, the user's pick 2026-11-02): no card,
/// the two counts as giant glowing numbers at the two sides, the clock in a
/// ring between them that runs out as the minute does, and one thin bar of
/// who is ahead under it all. It replaced a black card that took a third of
/// the screen, with the red Give up the loudest thing on it.
class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    super.key,
    required this.yours,
    required this.theirs,
    required this.remaining,
    required this.duel,
    required this.live,
    this.limit,
    this.session,
    this.onStop,
  });

  final int yours;
  final int theirs;
  final Duration remaining;

  /// The round's length, for the ring; null leaves the ring full.
  final Duration? limit;
  final DuelContext? duel;

  /// Whether the bout has started. The bar only appears once there is a real
  /// share to draw.
  final bool live;

  /// A live match, when this is one: the tag under the clock, and the other
  /// side dimmed while their phone is quiet.
  final LiveSession? session;

  /// The way out: Give up in a match, a small red flag under the clock;
  /// Finish in practice, where nothing is lost by stopping.
  final VoidCallback? onStop;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final duel = this.duel;
    final away = session?.opponentAway ?? false;
    final limit = this.limit;
    final left = limit == null || limit.inMilliseconds == 0
        ? 1.0
        : (remaining.inMilliseconds / limit.inMilliseconds).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Each side leans out towards its own edge, halfway: centred,
            // the faces crowded the clock; pinned, the names ran off the rim.
            Expanded(
              child: Align(
                alignment: const AlignmentDirectional(-0.5, -1),
                child: _Fighter(
                  name: l.you,
                  reps: yours,
                  tierIdx: demoProfile.tierIdx,
                  colour: context.colors.brand,
                  image: avatar.picture,
                ),
              ),
            ),
            // The middle: the clock, whether this is live, and the way out —
            // taking only what it needs, so the two counts share the rest.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ClockRing(
                    left: left,
                    child: Text(
                      formatClock(context, remaining.inSeconds),
                      style: TextStyle(
                        color: live ? Colors.white : const Color(0xFFC9C1B6),
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                  if (session != null) ...[
                    const SizedBox(height: 6),
                    LiveTag(reconnecting: away),
                  ],
                  if (onStop case final stop?) ...[
                    const SizedBox(height: 8),
                    _StopButton(inMatch: duel != null, onTap: stop),
                  ],
                ],
              ),
            ),
            Expanded(
              child: duel == null
                  // Keeps the clock centred when there is nobody there.
                  ? const SizedBox.shrink()
                  : Align(
                      alignment: const AlignmentDirectional(0.5, -1),
                      child: Opacity(
                        opacity: away ? 0.45 : 1,
                        child: _Fighter(
                          name: duel.opponentName,
                          reps: theirs,
                          tierIdx: duel.opponentTierIdx,
                          colour: context.colors.rival,
                          image: duel.opponentImage,
                        ),
                      ),
                    ),
            ),
          ],
        ),
        if (duel != null && live) ...[
          const SizedBox(height: 10),
          // One bar, two counts: your share of the reps done so far. It is
          // the same information as the two numbers above and it is the one
          // anybody actually reads while moving.
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: SizedBox(
              height: 6,
              child: Row(
                // Stretch, not the default centre: a ColoredBox with no
                // child has no height of its own, so a centred one collapses
                // to nothing and the bar draws at zero pixels tall.
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: yours + theirs == 0 ? 1 : yours,
                    child: ColoredBox(color: context.colors.brand),
                  ),
                  Expanded(
                    flex: yours + theirs == 0 ? 1 : theirs,
                    child: ColoredBox(color: context.colors.rival),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// The clock as a ring that runs out with the minute, the time inside it.
class _ClockRing extends StatelessWidget {
  const _ClockRing({required this.left, required this.child});

  /// How much of the round is still to go, 0–1.
  final double left;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const Key('clockRing'),
      width: 76,
      height: 76,
      child: CustomPaint(
        painter: _RingPainter(left: left, colour: context.colors.brand),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: FittedBox(fit: BoxFit.scaleDown, child: child),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.left, required this.colour});

  final double left;
  final Color colour;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 6.0;
    final centre = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - stroke / 2;
    canvas.drawCircle(centre, radius, Paint()..color = const Color(0xBF0E0D0C));
    canvas.drawCircle(
      centre,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..color = Colors.white.withValues(alpha: 0.16),
    );
    if (left <= 0) return;
    canvas.drawArc(
      Rect.fromCircle(center: centre, radius: radius),
      -math.pi / 2,
      2 * math.pi * left,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = colour,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.left != left || old.colour != colour;
}

/// Give up, under the clock: a small round flag ringed in red, found where
/// the eye already is and no longer the loudest thing on the screen (design
/// B). Finish in practice, a plain pill, since nothing is lost.
class _StopButton extends StatelessWidget {
  const _StopButton({required this.inMatch, required this.onTap});

  final bool inMatch;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    if (inMatch) {
      return Semantics(
        button: true,
        label: l.giveUp,
        child: Material(
          color: const Color(0xB30E0D0C),
          shape: CircleBorder(
            side: BorderSide(color: _giveUpRed.withValues(alpha: 0.75)),
          ),
          child: InkWell(
            key: const Key('stopButton'),
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.flag_rounded, size: 19, color: Color(0xFFFF8A8D)),
            ),
          ),
        ),
      );
    }
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        key: const Key('stopButton'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 132),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              l.finish,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// What giving up throws away: the score as it stands and the time still on
/// the clock, kept live — the round does not stop while this is open. Keep
/// going is the big button; giving up is there, in red, and harder to hit.
class _GiveUpCard extends StatefulWidget {
  const _GiveUpCard({
    required this.yours,
    required this.theirs,
    required this.remaining,
  });

  final int Function() yours;
  final int Function() theirs;
  final Duration Function() remaining;

  @override
  State<_GiveUpCard> createState() => _GiveUpCardState();
}

class _GiveUpCardState extends State<_GiveUpCard> {
  Timer? _tick;
  (int, int, int)? _shown;

  @override
  void initState() {
    super.initState();
    // Redrawn only when a number on it moves, so a card left open on a
    // clock that is not running asks for no frames at all.
    _tick = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (mounted && _now != _shown) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  (int, int, int) get _now =>
      (widget.yours(), widget.theirs(), widget.remaining().inSeconds);

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final now = _shown = _now;
    final (yours, theirs, seconds) = now;
    final gap = yours - theirs;
    final (status, statusColour) = gap > 0
        ? (l.giveUpAhead(localNumber(context, gap)), AppColors.win)
        : gap < 0
        ? (l.giveUpBehind(localNumber(context, -gap)), context.colors.rival)
        : (l.giveUpTied, const Color(0xFF8F8880));
    const cream = Color(0xFFF5EFE4);
    const muted = Color(0xFF8F8880);
    const big = TextStyle(
      fontSize: 46,
      fontWeight: FontWeight.w800,
      height: 1.1,
      fontFeatures: [FontFeature.tabularFigures()],
    );

    return Dialog(
      backgroundColor: const Color(0xFF121110),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: Color(0xFF2C2926), width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l.giveUpQuestion,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: cream,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    localNumber(context, yours),
                    style: big.copyWith(color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  const Text('–', style: TextStyle(color: muted, fontSize: 22)),
                  const SizedBox(width: 14),
                  Text(
                    localNumber(context, theirs),
                    style: big.copyWith(color: context.colors.rival),
                  ),
                ],
              ),
            ),
            Text(
              '$status · ${l.timeLeft(formatClock(context, seconds))}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: statusColour,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              l.giveUpBody,
              textAlign: TextAlign.center,
              style: const TextStyle(color: muted, fontSize: 15, height: 1.45),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                key: const Key('keepGoing'),
                onPressed: () => Navigator.of(context).pop(false),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE8DCC8),
                  foregroundColor: const Color(0xFF121110),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  l.keepGoing,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                key: const Key('confirmGiveUp'),
                onPressed: () => Navigator.of(context).pop(true),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _giveUpRed,
                  side: const BorderSide(color: _giveUpRed, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  l.giveUp,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One side of the score: the picture and the name, then the count as a
/// giant number glowing in its own colour, against its own edge of the
/// screen (design B).
class _Fighter extends StatelessWidget {
  const _Fighter({
    required this.name,
    required this.reps,
    required this.tierIdx,
    required this.colour,
    this.image,
  });

  final ImageProvider? image;

  final String name;
  final int reps;
  final int tierIdx;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    // Centred under the face on both sides: pinned to the outer edges, the
    // names and counts sat against the screen's rim and read as cut off.
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // One treatment everywhere somebody's picture appears.
        PlayerAvatar(
          name: name,
          tierIdx: tierIdx,
          image: image,
          size: 50,
          textColour: colour,
        ),
        const SizedBox(height: 4),
        ShrinkText(
          name,
          maxLines: 1,
          style: TextStyle(
            color: colour,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            shadows: const [Shadow(color: Color(0x99000000), blurRadius: 6)],
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            localNumber(context, reps),
            style: TextStyle(
              color: colour,
              fontSize: 96,
              fontWeight: FontWeight.w800,
              height: 1.0,
              fontFeatures: const [FontFeature.tabularFigures()],
              shadows: [
                Shadow(color: colour.withValues(alpha: 0.55), blurRadius: 28),
                const Shadow(color: Color(0x66000000), blurRadius: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// How far through this rep the body is, as one simple bar (the user's call,
/// 2026-11-02): empty at the counter's bottom line ([kBottomShare]), full at
/// its top one ([kTopShare]) — so down to its bottom and back up to its top
/// is exactly a rep. It turns green once the bottom is reached, for the way
/// back up, and is the bar the counter counts off ([repFill]), so it never
/// promises a rep the counter will not give, or asks for more than it does.
/// It replaced a thin bar with two lines across it that had to be learned.
/// The onboarding's three reps draw this same bar, so what is learnt there is
/// the match (the user, 2026-11-04).
class DepthBar extends StatelessWidget {
  const DepthBar({
    super.key,
    required this.progress,
    required this.good,
    this.pastBottom = false,
  });

  final double progress;
  final bool good;
  final bool pastBottom;

  @override
  Widget build(BuildContext context) {
    // Same colour rule as the skeleton: it goes off when the shape is wrong,
    // so the two never disagree about whether this rep is going to count.
    final fill = !good
        ? context.colors.rival
        : pastBottom
        ? AppColors.win
        : context.colors.brand;
    return SizedBox(
      width: 26,
      height: 250,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF121110).withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: repFill(progress),
              widthFactor: 1,
              child: DecoratedBox(
                key: const Key('depthFill'),
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The one thing to do differently, or which way to move next.
class _Cue extends StatelessWidget {
  const _Cue({required this.progress});

  /// How far through a rep the body is, 1 at the top.
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    // Below halfway the lifter is on the way down or at the bottom, so the
    // next thing they owe the rep is the push.
    final text = (progress ?? 1) < 0.5 ? l.goUp : l.goDown;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF121110).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }
}
