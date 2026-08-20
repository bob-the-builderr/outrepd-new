import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../exercises.dart';
import '../reps/exercise.dart';
import '../reps/exercise_patterns.dart';
import '../reps/pose.dart';
import '../reps/driver_finder.dart';
import '../reps/pose_source.dart';
import '../reps/recording.dart';
import '../reps/rep_engine.dart';
import '../motion.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets.dart';

/// Solo counting. No opponent, no server — the whole point of this screen is
/// to get the counter trustworthy before a match is ever built on top of it.
class TrainerScreen extends StatefulWidget {
  const TrainerScreen({
    super.key,
    this.exercise,
    this.autoStart = false,
    this.forMatch = false,
  });

  final ExerciseDef? exercise;

  /// Skips the picker and opens straight into a session. Used by the web
  /// preview route, where tapping through the canvas is unreliable.
  final bool autoStart;

  /// Opened from inside a match. Finishing hands the count back to the round
  /// rather than returning to the picker, and the exercise is fixed: the round
  /// decides what is being counted, not the lifter.
  final bool forMatch;

  @override
  State<TrainerScreen> createState() => _TrainerScreenState();
}

enum _Stage { setup, learning, counting }

/// Stands in for an exercise the app has never been told about. Picking it
/// starts a session that works out the movement from the lifter's own reps.
const kLearnExercise = ExerciseDef(
  id: 'learn',
  name: 'Any exercise',
  icon: Icons.auto_awesome,
  driver: AngleSpec(Joint.leftShoulder, Joint.leftElbow, Joint.leftWrist),
  bottomAngle: 90,
  topAngle: 165,
  gates: [],
  cue: 'Start your set — it works the movement out as you go',
);

/// Exercise names are gym vocabulary and stay as they are; the catch-all
/// entry is the one exception, because it is a sentence rather than a name.
String exerciseLabel(BuildContext context, ExerciseDef e) =>
    e.id == kLearnExercise.id ? L.of(context).anyExercise : e.name;

class _TrainerScreenState extends State<TrainerScreen> {
  late ExerciseDef _exercise = widget.exercise ?? kExercises.first;

  PoseSource? _source;
  StreamSubscription<BodyPose>? _sub;
  RepEngine? _engine;

  final _clock = Stopwatch();

  _Stage _stage = _Stage.setup;
  BodyPose _pose = BodyPose.empty;
  RepState? _state;
  String? _error;

  /// Hidden by default — it is for working out why the counter is misbehaving,
  /// not something to have on screen while lifting. A long press on the count
  /// reveals it.
  bool _showNumbers = false;

  /// Every pose of the session, kept so the set can be replayed against a
  /// changed threshold instead of being performed again.
  final _recorded = <RecordedFrame>[];
  String? _savedTo;


  @override
  void initState() {
    super.initState();
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _begin());
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _source?.dispose();
    super.dispose();
  }

  Future<void> _begin() async {
    final source = createPoseSource();
    try {
      await source.start();
    } on Object catch (e) {
      if (mounted) setState(() => _error = e.toString());
      return;
    }
    if (!mounted) {
      await source.dispose();
      return;
    }

    final engine = RepEngine(_exercise);
    _clock
      ..reset()
      ..start();

    _sub = source.poses.listen(_onPose);

    _recorded.clear();
    _savedTo = null;

    setState(() {
      _source = source;
      _engine = engine;
      _stage =
          _exercise.id == 'learn' ? _Stage.learning : _Stage.counting;
      _error = null;
    });
  }

  void _onPose(BodyPose pose) {
    final engine = _engine;
    if (engine == null || !mounted) return;

    _recorded.add(RecordedFrame(_clock.elapsedMilliseconds, pose));

    if (_stage == _Stage.learning) {
      _tryToLearn();
      setState(() => _pose = pose);
      return;
    }

    final state = engine.update(pose, _clock.elapsed);
    if (state.countedNow) tap(heavy: true);

    setState(() {
      _pose = pose;
      _state = state;
    });
  }

  /// Looks for the movement every so often rather than on every frame; the
  /// search walks the whole buffer and there is nothing to gain from running
  /// it thirty times a second.
  void _tryToLearn() {
    if (_recorded.length % 15 != 0) return;

    final guess = findDriver([for (final f in _recorded) f.pose]);
    if (guess == null) return;

    final learned = guess.toDefinition(id: 'learn', name: _exercise.name);
    final engine = RepEngine(learned);

    // Replay everything already buffered, so the reps performed while it was
    // working the movement out are counted rather than thrown away. The
    // counter visibly catches up instead of starting from zero.
    RepState? state;
    for (final frame in _recorded) {
      state = engine.update(frame.pose, Duration(milliseconds: frame.atMs));
    }

    setState(() {
      _engine = engine;
      _state = state;
      _stage = _Stage.counting;
    });
  }

  void _restart() {
    _engine?.reset();
    setState(() {});
  }

  /// Throws away what the range has learned and starts picking it up again.
  /// Useful after moving the phone, or switching to a different depth.
  void _recalibrate() {
    _engine?.reset();
    _clock
      ..reset()
      ..start();
    setState(() {});
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
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              L.of(context).howManyReallyHint,
              style: const TextStyle(color: _dim, fontSize: 12.5),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: field,
              autofocus: true,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 20),
              decoration: const InputDecoration(hintText: 'e.g. 12'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(L.of(context).skip,
                style: const TextStyle(color: _dim)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context)
                .pop(int.tryParse(field.text.trim())),
            child: Text(L.of(context).save,
                style: const TextStyle(color: _accent)),
          ),
        ],
      ),
    );
    field.dispose();
    return answer;
  }

  Future<void> _saveRecording() async {
    if (_recorded.length < 30) return;
    final trueCount = await _askTrueCount();
    if (!mounted) return;
    try {
      final path = await PoseRecording(
        exerciseId: _exercise.id,
        frames: List.of(_recorded),
        note: trueCount?.toString(),
      ).save();
      if (mounted) setState(() => _savedTo = path);
    } on Object catch (error) {
      if (mounted) setState(() => _error = 'Could not save the session: $error');
    }
  }

  Future<void> _stop() async {
    final counted = _engine?.reps ?? 0;
    await _sub?.cancel();
    await _source?.dispose();
    await _saveRecording();
    if (!mounted) return;

    // In a match the screen exists to produce one number. Handing it back and
    // closing is the whole contract; dropping the lifter on a picker mid-round
    // would be the app losing the thread of what they were doing.
    if (widget.forMatch) {
      Navigator.of(context).pop(counted);
      return;
    }

    setState(() {
      _sub = null;
      _source = null;
      _engine = null;
      _state = null;
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
        // The app's own title style is dark in the light theme, and this
        // screen is always dark behind it.
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
        title: Text(exerciseLabel(context, _exercise)),
        actions: [
          if (_stage != _Stage.setup) ...[
            IconButton(
              tooltip: L.of(context).recalibrate,
              icon: const Icon(Icons.straighten),
              onPressed: _recalibrate,
            ),
            IconButton(
              tooltip: L.of(context).resetCount,
              icon: const Icon(Icons.refresh),
              onPressed: _restart,
            ),
          ],
        ],
      ),
      extendBodyBehindAppBar: true,
      body: _stage == _Stage.setup ? _buildSetup() : _buildSession(),
    );
  }

  Widget _buildSetup() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 100, 16, 24),
      children: [
        Text(
          L.of(context).pickMovement,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        // Anything the camera has never been told about still works, so it
        // leads rather than being buried under eighty named movements.
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _ExerciseTile(
            exercise: kLearnExercise,
            selected: kLearnExercise.id == _exercise.id,
            onTap: () => setState(() => _exercise = kLearnExercise),
          ),
        ),
        for (final group in exercisesByMuscle.entries) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 18, 4, 10),
            child: Text(
              group.key.toUpperCase(),
              style: const TextStyle(
                color: _dim,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
          for (final listed in group.value)
            if (cameraDefFor(listed.name) case final def?)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ExerciseTile(
                  exercise: def,
                  selected: def.id == _exercise.id,
                  onTap: () => setState(() => _exercise = def),
                ),
              ),
        ],
        const SizedBox(height: 18),
        _DarkPanel(
          child: Row(
            children: [
              const Icon(Icons.videocam_outlined, color: _accent),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _exercise.cue,
                  style: const TextStyle(color: _dim, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        if (_savedTo != null) ...[
          const SizedBox(height: 14),
          Text(
            'Session saved for tuning:\n$_savedTo',
            style: const TextStyle(color: _dim, fontSize: 11.5),
          ),
        ],
        if (_error != null) ...[
          const SizedBox(height: 14),
          Text(
            _error!,
            style: const TextStyle(color: AppColors.loss, fontSize: 12.5),
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
    final state = _state;
    final engine = _engine!;
    final live = _source?.isLive ?? false;
    final formOk = state?.formOk ?? false;

    return Stack(
      fit: StackFit.expand,
      children: [
        _source?.buildPreview(context) ?? const ColoredBox(color: Colors.black),

        // The skeleton goes over whatever is behind it, green only while the
        // shape is right — the same condition that lets a rep count.
        CustomPaint(
          painter: _SkeletonPainter(
            pose: _pose,
            good: formOk,
            mirror: live,
            sourceSize: _source?.sourceSize,
          ),
        ),

        Positioned(
          right: 18,
          top: 110,
          bottom: 130,
          child: _RomMeter(
            progress: state?.progress ?? 0,
            good: formOk,
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
            child: _Diagnostics(state: state, engine: engine),
          ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _Readout(
            exercise: _exercise,
            state: state,
            holdSeconds: engine.holdSeconds,
            stage: _stage,
            demo: !live,
            onStop: _stop,
            onRevealNumbers: () =>
                setState(() => _showNumbers = !_showNumbers),
          ),
        ),
      ],
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
  const _DarkPanel({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

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

    if (onTap == null) return content;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: content,
    );
  }
}

class _ExerciseTile extends StatelessWidget {
  const _ExerciseTile({
    required this.exercise,
    required this.selected,
    required this.onTap,
  });

  final ExerciseDef exercise;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _DarkPanel(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            exercise.icon,
            color: selected ? _accent : _dim,
            size: 24,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              exerciseLabel(context, exercise),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            exercise.gates.isNotEmpty
                ? L.of(context).checksForm
                : (exercise.mode == ScoreMode.hold
                    ? L.of(context).time
                    : L.of(context).counts),
            style: TextStyle(
              color: exercise.gates.isNotEmpty ? _accent : _dim,
              fontSize: 11.5,
            ),
          ),
          if (selected) ...[
            const SizedBox(width: 10),
            const Icon(Icons.check_circle, color: _accent, size: 20),
          ],
        ],
      ),
    );
  }
}

/// The bar down the side. The ball is the driver angle, and the shaded ends
/// are the two zones a rep has to travel between.
class _RomMeter extends StatelessWidget {
  const _RomMeter({required this.progress, required this.good});

  final double progress;
  final bool good;

  @override
  Widget build(BuildContext context) {
    const width = 46.0;
    final tint = good ? AppColors.win : AppColors.loss;

    return SizedBox(
      width: width,
      child: LayoutBuilder(
        builder: (context, box) {
          const ball = 30.0;
          final travel = box.maxHeight - ball;
          // Progress runs 0 at the bottom of the movement, and the meter is
          // drawn the same way up as the body moves.
          final top = travel * (1 - progress.clamp(0.0, 1.0));

          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(width / 2),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                ),
              ),
              _zone(box, top: true),
              _zone(box, top: false),
              Positioned(
                left: (width - ball) / 2,
                top: top,
                child: Container(
                  width: ball,
                  height: ball,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: tint.withValues(alpha: 0.85),
                        blurRadius: 16,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _zone(BoxConstraints box, {required bool top}) {
    final height = box.maxHeight * (top ? 1 - kTopZone : kBottomZone);
    final radius = Radius.circular(box.maxWidth / 2);

    return Positioned(
      top: top ? 0 : null,
      bottom: top ? null : 0,
      left: 0,
      right: 0,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.win.withValues(alpha: 0.22),
          borderRadius: BorderRadius.vertical(
            top: top ? radius : Radius.zero,
            bottom: top ? Radius.zero : radius,
          ),
        ),
      ),
    );
  }
}

/// What the counter is actually seeing, in numbers.
class _Diagnostics extends StatelessWidget {
  const _Diagnostics({required this.state, required this.engine});

  final RepState? state;
  final RepEngine engine;

  @override
  Widget build(BuildContext context) {
    final s = state;
    String deg(double? v) => v == null ? '—' : '${v.round()}°';

    final lines = <String>[
      'angle   ${deg(s?.angle)}',
      'range   ${deg(engine.bottomAngle)} → ${deg(engine.topAngle)}',
      'ball    ${((s?.progress ?? 0) * 100).round()}%',
      'form    ${s == null ? '—' : (s.formOk ? 'ok' : 'BAD')}',
      'state   ${s?.armed ?? false ? 'going up' : 'waiting'}',
      for (final entry in engine.rejections.entries)
        'lost    ${entry.value} to ${entry.key.name}',
      if (s?.tracked == false) 'lost the body',
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
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

/// The count, and the one line telling you why a rep did not land.
class _Readout extends StatelessWidget {
  const _Readout({
    required this.exercise,
    required this.state,
    required this.holdSeconds,
    required this.stage,
    required this.demo,
    required this.onStop,
    required this.onRevealNumbers,
  });

  final ExerciseDef exercise;
  final RepState? state;
  final double holdSeconds;
  final _Stage stage;
  final bool demo;
  final VoidCallback onStop;
  final VoidCallback onRevealNumbers;

  @override
  Widget build(BuildContext context) {
    final s = state;
    final hold = exercise.mode == ScoreMode.hold;
    final value = hold
        ? holdSeconds.toStringAsFixed(1)
        : localNumber(context, s?.reps ?? 0);

    final learning = stage == _Stage.learning;
    final message = learning
        ? L.of(context).learningMovement
        : (s?.formMessage ?? s?.rejection?.message);
    final bad = !learning && message != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.75),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (demo)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'Demo body — no camera in the browser',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 11.5,
                ),
              ),
            ),
          GestureDetector(
            onLongPress: onRevealNumbers,
            child: PopOnChange(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 76,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ),
          Text(
            hold ? L.of(context).secondsHeld : L.of(context).reps,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          // Height is reserved either way so the count does not jump around
          // every time a cue appears.
          SizedBox(
            height: 22,
            child: message == null
                ? null
                : Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: bad ? AppColors.loss : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onStop,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withValues(alpha: 0.35)),
              minimumSize: const Size.fromHeight(46),
            ),
            child: Text(L.of(context).finish),
          ),
        ],
      ),
    );
  }
}

const _bones = <List<Joint>>[
  [Joint.leftShoulder, Joint.rightShoulder],
  [Joint.leftShoulder, Joint.leftElbow],
  [Joint.leftElbow, Joint.leftWrist],
  [Joint.rightShoulder, Joint.rightElbow],
  [Joint.rightElbow, Joint.rightWrist],
  [Joint.leftShoulder, Joint.leftHip],
  [Joint.rightShoulder, Joint.rightHip],
  [Joint.leftHip, Joint.rightHip],
  [Joint.leftHip, Joint.leftKnee],
  [Joint.leftKnee, Joint.leftAnkle],
  [Joint.rightHip, Joint.rightKnee],
  [Joint.rightKnee, Joint.rightAnkle],
];

class _SkeletonPainter extends CustomPainter {
  _SkeletonPainter({
    required this.pose,
    required this.good,
    required this.mirror,
    required this.sourceSize,
  });

  final BodyPose pose;
  final bool good;

  /// The front camera shows a mirror image, so the overlay has to be flipped
  /// to land on the body instead of beside it.
  final bool mirror;

  /// Shape of the picture the pose was measured in, or null to fill the box.
  final Size? sourceSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (pose.points.isEmpty) return;

    final colour = good ? AppColors.win : AppColors.loss;

    // The preview covers the screen: scaled until it fills, then centred and
    // clipped. The skeleton has to be put through the very same transform, or
    // it sits beside the body rather than on it.
    final source = sourceSize;
    final scale = source == null
        ? 1.0
        : math.max(size.width / source.width, size.height / source.height);
    final drawn = source == null
        ? size
        : Size(source.width * scale, source.height * scale);
    final dx = (size.width - drawn.width) / 2;
    final dy = (size.height - drawn.height) / 2;

    Offset? at(Joint joint) {
      final p = pose.confident(joint, min: 0.35);
      if (p == null) return null;
      final x = mirror ? 1 - p.x : p.x;
      return Offset(x * drawn.width + dx, p.y * drawn.height + dy);
    }

    final bone = Paint()
      ..color = colour.withValues(alpha: 0.85)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final glow = Paint()
      ..color = colour.withValues(alpha: 0.28)
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    for (final pair in _bones) {
      final a = at(pair[0]);
      final b = at(pair[1]);
      if (a == null || b == null) continue;
      canvas.drawLine(a, b, glow);
      canvas.drawLine(a, b, bone);
    }

    final dot = Paint()..color = Colors.white;
    final ring = Paint()..color = colour;

    for (final joint in Joint.values) {
      final p = at(joint);
      if (p == null) continue;
      canvas.drawCircle(p, 8, ring);
      canvas.drawCircle(p, 4.5, dot);
    }
  }

  @override
  bool shouldRepaint(_SkeletonPainter old) =>
      old.pose != pose ||
      old.good != good ||
      old.mirror != mirror ||
      old.sourceSize != sourceSize;
}
