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
import '../motion.dart';
import '../settings.dart';
import '../ranking.dart';
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
  });

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

  final String rankLabel;
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
    this.poseSource,
  });

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

  /// Three seconds, so the start is a moment rather than an ambush.
  countdown,

  counting,
}

class _TrainerScreenState extends State<TrainerScreen> {
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
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _begin());
    }
  }

  @override
  void dispose() {
    keepScreenOn(false);
    _countdownTimer?.cancel();
    _graceTimer?.cancel();
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
      // Redraws the clock and the opponent between poses. Without this the
      // timer only moves when the lifter does, which stops dead at the top
      // of a rep.
      if (_stage == _Stage.counting && mounted) setState(() {});
    });

    _recorded.clear();
    _recent.clear();
    _graceTimer?.cancel();
    _graceTimer = null;
    _liveReps = 0;

    setState(() {
      _source = source;
      _tracker = tracker;
      _progress = null;
      _stage = _Stage.positioning;
      _error = null;
      _failure = null;
      _lastPoseAt = DateTime.now();
    });
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

  /// Whether the camera can see what the count is read from.
  ///
  /// Wrists, shoulders and hips — **not ankles**. Ankles were the test until a
  /// lifter filmed their own set: with the phone on the floor a metre away and
  /// the body pointing at it, the tracker saw their knees in 26% of frames and
  /// their ankles in 18%, while every joint the counter actually reads was
  /// there in 100%. The old gate was asking for the one part of the body that
  /// a correct setup hides.
  ///
  /// Either side of each pair will do — a body turned slightly to the camera
  /// hides one wrist and is still perfectly countable.
  bool _framed(BodyPose pose) {
    final wrist =
        pose.confident(Joint.leftWrist) ?? pose.confident(Joint.rightWrist);
    final shoulder =
        pose.confident(Joint.leftShoulder) ??
        pose.confident(Joint.rightShoulder);
    final hip = pose.confident(Joint.leftHip) ?? pose.confident(Joint.rightHip);
    return wrist != null && shoulder != null && hip != null;
  }

  /// The last second or so of poses, for the checks that need more than one
  /// frame — chiefly whether the hands are staying planted, which is what
  /// separates a push-up from any other movement up and down.
  final _recent = <BodyPose>[];
  static const _recentKeep = 40;

  /// Whether the lifter is down in position right now.
  ///
  /// A majority of the last few frames rather than the latest one: a single
  /// frame the tracker fumbled should not flick the skeleton's colour, and a
  /// colour that flickers is worse than one that is slightly late.
  bool get _inPosition {
    if (_recent.length < kPlantWindow + 5) return false;
    final marks = inPushUpPosition(_recent);
    final from = math.max(0, marks.length - 10);
    var yes = 0;
    for (var i = from; i < marks.length; i++) {
      if (marks[i]) yes++;
    }
    return yes >= (marks.length - from) * 0.6;
  }

  /// Running while a whole body is in shot but not yet in position.
  Timer? _graceTimer;

  /// How long a framed body waits for the position check before the round
  /// starts regardless.
  static const _positionGrace = Duration(seconds: 8);

  int _countdown = 3;
  Timer? _countdownTimer;

  void _startCountdown() {
    if (_stage != _Stage.positioning) return;
    setState(() {
      _stage = _Stage.countdown;
      _countdown = 3;
    });
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_countdown > 1) {
        setState(() => _countdown--);
        tap();
        return;
      }
      timer.cancel();
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
      tap(heavy: true);
    });
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

    // Every frame, from the moment the camera opens: the seconds spent
    // getting down are when the tracker learns where the hands are planted
    // and how high this lifter's lockout is, so the first rep of the round is
    // judged against them rather than against a guess.
    final atMs = _poseClock.elapsedMilliseconds;
    final reading = tracker.add(atMs, pose);
    _record(atMs, pose);

    if (_stage == _Stage.positioning) {
      setState(() => _pose = pose);
      if (!_framed(pose)) {
        _graceTimer?.cancel();
        _graceTimer = null;
        return;
      }

      // The clock waits for somebody to actually be down in position. Whole
      // body in shot is not the same thing — a person standing in front of
      // the phone passes it — and starting a sixty second round while they
      // are still walking to the floor costs them the seconds it takes to
      // get there.
      //
      // With an escape hatch. If the position never registers on somebody's
      // camera angle, being unable to start a match at all is a far worse
      // failure than a few seconds lost, so a framed body is counted in
      // anyway once it has waited.
      _graceTimer ??= Timer(_positionGrace, () {
        if (mounted && _stage == _Stage.positioning) _startCountdown();
      });

      if (_inPosition) _startCountdown();
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
      tap(heavy: true);
    }

    final limit = widget.limit;
    if (limit != null && _clock.elapsed >= limit) {
      _stop();
      return;
    }

    setState(() {
      _pose = pose;
      if (reading.progress != null) _progress = reading.progress;
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

  Future<void> _stop({bool gaveUp = false}) async {
    _gaveUp = gaveUp;
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
    await _sub?.cancel();
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
      _pose = BodyPose.empty;
      _stage = _Stage.setup;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        // No title. There is one movement, so naming it over a camera
        // already pointed at somebody doing it says nothing.
        titleTextStyle: context.type.title.copyWith(color: Colors.white),
        // Recalibrate and reset used to live here, and so did the back
        // button by default — three controls stacked over a screen meant to
        // hold nothing above the score card once the camera is actually
        // tracking somebody. Setup keeps its own way out; live tracking's
        // only way out is Give up, on the card itself.
        automaticallyImplyLeading: _stage == _Stage.setup,
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
          _source?.buildPreview(context) ??
              const ColoredBox(color: Colors.black),

          // The skeleton goes over whatever is behind it, green while the body
          // holds a straight line. It is feedback on form, not a gate on the
          // count: a rep with a sagging hip is still a rep somebody did, and a
          // count that silently withheld it would be the app calling them a liar.
          //
          // Half strength until the bout starts. Getting into position is the
          // one moment the overlay is the subject rather than the decoration —
          // it is how you know the camera can see you — and a faint one asks to
          // be looked at without claiming anything is being counted yet.
          //
          // Hidden when the lifter has turned it off in settings. The count
          // does not change either way — this is the picture, not the
          // reading — but some people find it easier to lift without a
          // figure drawn over them.
          if (settings.showSkeleton)
            Opacity(
              opacity: _stage == _Stage.positioning ? 0.5 : 1,
              child: CustomPaint(
                painter: SkeletonPainter(
                  pose: _pose,
                  good: ready,
                  mirror: live,
                  sourceSize: _source?.sourceSize,
                ),
              ),
            ),

          // The score, the clock, and the rival — pinned to the top from the
          // moment the camera opens, so the numbers are in the same place before
          // and during the bout instead of appearing when it starts.
          Positioned(
            left: 14,
            right: 14,
            top: 36,
            child: _ScoreCard(
              yours: _liveReps,
              theirs: _opponentReps,
              remaining: _remaining,
              duel: widget.duel,
              live: _stage == _Stage.counting,
            ),
          ),

          if (_stage == _Stage.positioning)
            Positioned(
              left: 0,
              right: 0,
              bottom: 60,
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
                      L.of(context).getIntoPosition,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
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
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          if (_stage == _Stage.countdown) ...[
            Positioned.fill(
              child: ColoredBox(
                color: const Color(0xFF121110).withValues(alpha: 0.55),
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
                      fontSize: 10,
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
                            fontSize: 16,
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
                            fontSize: 11,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // How deep this rep is, as a bar that fills from the bottom. On the
          // left, and low: the phone is on the floor and the lifter is looking
          // down the screen at it from a push-up, so the middle of the left edge
          // is where a glance actually lands. Wide enough to read at that angle
          // without turning the head.
          if (_stage == _Stage.counting)
            Positioned(
              left: 11,
              top: 260,
              child: _DepthBar(
                key: const Key('depthBar'),
                progress: _progress ?? 0,
                good: ready,
              ),
            ),

          // The meter is the part that goes wrong quietly: the angle can sit
          // still, or the calibrated ends can land somewhere unreachable, and
          // from the outside both just look like "it is not counting". One
          // screenshot of this answers which.
          if (_showNumbers)
            Positioned(
              left: 14,
              top: 110,
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
              bottom: 44,
              child: Center(child: _Cue(progress: _progress)),
            ),

          if (!live)
            Positioned(
              left: 0,
              right: 0,
              bottom: 82,
              child: Center(
                // Not translated on purpose: this only ever appears in the
                // web preview, where there is no camera to open. Nobody who
                // installs the app can reach it.
                child: const Text(
                  'Demo body — no camera in the browser',
                  style: TextStyle(color: Color(0xFFC9C1B6), fontSize: 11),
                ),
              ),
            ),

          // What is riding on this, and the way out of it. Both small: neither
          // is what anybody is here for, and the stop button in particular
          // should take a deliberate press rather than a panicked one.
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.duel case final duel?)
                  // Flexible, because the rank label runs long in several of
                  // the thirteen languages and this row also has to hold the
                  // way out.
                  Flexible(
                    child: Text(
                      duel.rankLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
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
                GestureDetector(
                  // In a duel this button is Give up, and giving up is a loss.
                  onTap: () => _stop(gaveUp: widget.duel != null),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      widget.duel == null
                          ? L.of(context).finish
                          : L.of(context).giveUp,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
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

class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.yours,
    required this.theirs,
    required this.remaining,
    required this.duel,
    required this.live,
  });

  final int yours;
  final int theirs;
  final Duration remaining;
  final DuelContext? duel;

  /// Whether the bout has started. The bar only appears once there is a real
  /// share to draw.
  final bool live;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final duel = this.duel;

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF121110),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.colors.border, width: 0.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // No IntrinsicHeight: the two sides are built from the same pieces
          // in the same order, so they come out the same height on their own —
          // and measuring them would mean asking a ShrinkText for an intrinsic
          // height, which a LayoutBuilder cannot answer.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _Fighter(
                  name: l.you,
                  reps: yours,
                  tierIdx: demoProfile.tierIdx,
                  divIdx: demoProfile.divIdx,
                  colour: Colors.white,
                ),
              ),
              // The clock takes only what it needs; the two lifters either
              // side share what is left. A fixed width here is what put a
              // long username through the edge of the card.
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 4, right: 4),
                child: Text(
                  formatClock(context, remaining.inSeconds),
                  style: TextStyle(
                    color: live ? Colors.white : context.colors.muted,
                    fontSize: 22,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              Expanded(
                child: duel == null
                    // Keeps the clock centred when there is nobody there.
                    ? const SizedBox.shrink()
                    : _Fighter(
                        name: duel.opponentName,
                        reps: theirs,
                        tierIdx: duel.opponentTierIdx,
                        divIdx: duel.opponentDivIdx,
                        colour: context.colors.rival,
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
              borderRadius: BorderRadius.circular(5),
              child: SizedBox(
                height: 9,
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
      ),
    );
  }
}

/// One side of the card: who they are, where they stand, and their count.
///
/// The picture and the badge are the same pairing the profile screen uses —
/// the badge hangs off the picture rather than sitting in a chip of its own,
/// because it belongs to the person.
class _Fighter extends StatelessWidget {
  const _Fighter({
    required this.name,
    required this.reps,
    required this.tierIdx,
    required this.divIdx,
    required this.colour,
  });

  final String name;
  final int reps;
  final int tierIdx;
  final int divIdx;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // One treatment everywhere somebody's picture appears.
        PlayerAvatar(
          name: name,
          tierIdx: tierIdx,
          size: 48,
          textColour: colour,
          // The card has its own background, so the badge is ringed with that
          // rather than the page behind it.
          ringColour: const Color(0xFF121110),
        ),
        const SizedBox(height: 6),
        ShrinkText(
          name,
          maxLines: 1,
          style: TextStyle(color: colour, fontSize: 12),
        ),
        ShrinkText(
          l.levelNumber(localNumber(context, ladderLevel(tierIdx, divIdx))),
          maxLines: 1,
          style: TextStyle(color: context.colors.muted, fontSize: 11),
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            localNumber(context, reps),
            style: TextStyle(
              color: colour,
              fontSize: 34,
              height: 1.05,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}

class _DepthBar extends StatelessWidget {
  const _DepthBar({super.key, required this.progress, required this.good});

  final double progress;
  final bool good;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 250,
      decoration: BoxDecoration(
        color: const Color(0xFF121110).withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: progress.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              // Same colour rule as the skeleton: it goes off when the shape
              // is wrong, so the two never disagree about whether this rep is
              // going to count.
              color: good ? context.colors.brand : context.colors.rival,
              borderRadius: BorderRadius.circular(8),
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
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ),
    );
  }
}
