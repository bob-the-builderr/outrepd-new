/// Does the number on the screen move when somebody does push-ups — and only
/// when they do a whole one?
///
/// Nothing in this suite asked the first question until a lifter did four and
/// was shown zero: every counting test scored a list of poses through a
/// function, the screen was wired to a different function, and no test
/// crossed the gap. So these drive poses into the actual screen, stamped at a
/// phone's thirty a second, and read the actual number and the actual bar.
///
/// The second question is the one a lifter asked from the floor: the bar did
/// not follow the body, most reps landed late, and getting up at the end
/// scored one more.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/reps/pose.dart';
import 'package:outrepd/reps/pose_source.dart';
import 'package:outrepd/reps/posture.dart';
import 'package:outrepd/reps/pushup_counter.dart';
import 'package:outrepd/screens/trainer.dart';
import 'package:outrepd/theme.dart';

import 'support/synthetic_poses.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('the screen', () {
    testWidgets('shows every push-up, and only those', (tester) async {
      final source = await _startRound(tester);

      // Eight push-ups at a rep a second. The number on the screen is the
      // number the round ends with — one tracker for both — so this pins it
      // exactly: a screen that shows seven while the verdict says eight is
      // the bug this design exists to remove.
      await _emitAll(tester, source, pushUpSet(8, lead: 0));
      expect(_count(tester), 8);
    });

    testWidgets('the number moves on the rep, not a rep later',
        (tester) async {
      // Reported from a phone: "most reps are counted late". The old count
      // was re-scored every eighth frame and waited on its slowest signal.
      final source = await _startRound(tester);

      for (var rep = 1; rep <= 3; rep++) {
        await _emitAll(tester, source, [
          for (var f = 0; f < 30; f++) pushUpPose(repShape(f / 30)),
        ]);
        // Straight after the rep's last frame — the body back at the top —
        // with nothing after it.
        expect(_count(tester), rep,
            reason: 'rep $rep had finished and the screen still said '
                '${_count(tester)}');
      }
    });

    testWidgets('the bar goes down and up with the body', (tester) async {
      // Reported from a phone: "the bar is completely broken". It is the
      // nose's height above the hands as a share of lockout, so it has to sit
      // near the bottom at the bottom of a rep and full at the top — a frame
      // or two behind the body, not drifting toward it over seconds.
      final source = await _startRound(tester);

      final bottoms = <double>[];
      final tops = <double>[];
      for (var rep = 0; rep < 3; rep++) {
        for (var f = 0; f < 30; f++) {
          await _emit(tester, source, pushUpPose(repShape(f / 30)));
          // The body is lowest at frame 15 and back at the top by frame 0 of
          // the next rep; one frame after each is where the bar should be.
          if (f == 16) bottoms.add(_bar(tester));
          if (f == 1) tops.add(_bar(tester));
        }
      }
      await _emit(tester, source, pushUpPose(1));
      await _emit(tester, source, pushUpPose(1));
      tops.add(_bar(tester));
      // Drawn from the bottom of a real rep: empty there, full at the top.
      for (final b in bottoms) {
        expect(b, lessThanOrEqualTo(barFill(0.25)),
            reason: 'at the bottom the bar read $b');
      }
      for (final t in tops) {
        expect(t, greaterThan(barFill(0.9)),
            reason: 'at the top the bar read $t');
      }
    });

    testWidgets('half reps move the bar and not the number', (tester) async {
      final source = await _startRound(tester);

      // Down to just over halfway, eight times.
      var lowest = 1.0;
      for (final pose in pushUpSet(8, depth: 0.45, lead: 0)) {
        await _emit(tester, source, pose);
        final bar = _bar(tester);
        if (bar < lowest) lowest = bar;
      }
      expect(_count(tester), 0);
      // And the bar showed the dip, so the lifter can see why.
      expect(lowest, lessThan(barFill(0.7)));
      expect(lowest, greaterThan(barFill(kBottomShare)));
    });

    testWidgets('getting up at the end does not add one', (tester) async {
      // Reported from a phone: "when I finish and get up, it counts a rep".
      final source = await _startRound(tester);

      await _emitAll(tester, source, pushUpSet(5, lead: 0));
      expect(_count(tester), 5);
      await _emitAll(tester, source, gettingUp());
      expect(_count(tester), 5);
    });

    testWidgets('stays at zero when nobody is moving', (tester) async {
      final source = await _startRound(tester);

      // Held at the top for the length of a set. A counter that counts this
      // is worse than one that counts nothing.
      await _emitAll(tester, source, [
        for (var i = 0; i < 200; i++) pushUpPose(1),
      ]);
      expect(_count(tester), 0);
    });

    testWidgets('the line to reach next is the one lit', (tester) async {
      // Two lines across the bar, where the counter's own are: down past the
      // bottom one, back up past the top one. Gold is the next to reach.
      final source = await _startRound(tester);
      expect(_line(tester, 'depthLineBottom'), AppColors.gold);

      var upNext = false;
      for (final pose in pushUpSet(1, lead: 0)) {
        await _emit(tester, source, pose);
        if (_line(tester, 'depthLineTop') == AppColors.gold) {
          upNext = true;
          expect(_line(tester, 'depthLineBottom'), AppColors.win);
        }
      }
      expect(upNext, isTrue, reason: 'the top line never lit on the way up');
      expect(_count(tester), 1);
      // Counted: the way down is next again.
      expect(_line(tester, 'depthLineBottom'), AppColors.gold);
    });

    testWidgets('the depth bar is big enough to read from the floor',
        (tester) async {
      // The phone is on the floor and the lifter is looking down the screen
      // at it from a push-up. The bar used to be 6 pixels wide, high up under
      // the score card — legible sitting at a desk, and not from down there.
      final source = await _startRound(tester);
      await _emit(tester, source, pushUpPose(1));

      final bar = find.byKey(const Key('depthBar'));
      expect(bar, findsOneWidget);

      final size = tester.getSize(bar);
      expect(size.width, greaterThanOrEqualTo(12));
      expect(size.height, greaterThanOrEqualTo(200));

      // Low on the left, not tucked under the clock.
      final corner = tester.getTopLeft(bar);
      expect(corner.dx, lessThan(40));
      expect(corner.dy, greaterThanOrEqualTo(200));
      // And still on screen at the bottom.
      expect(corner.dy + size.height, lessThanOrEqualTo(880));
    });
  });

  group('getting into position', () {
    test('standing in front of the camera is not a push-up position', () {
      // The old rule asked whether the body was in a straight line, and a
      // person standing up answers yes. That is why the skeleton went green
      // before anybody had got onto the floor.
      expect(isPushUpPosition(standingPose()), isFalse);
      expect(isPushUpPosition(pushUpPose(1)), isTrue);
      expect(isPushUpPosition(pushUpPose(0)), isTrue);
    });

    test('lowering yourself onto the floor does not score a rep', () {
      // Reported from a phone: "it counted one and I hadn't got down yet."
      // The descent is a bigger fall than any rep in the set, which is
      // exactly why a counter reading the whole stream scored it.
      final frames = timed([
        for (var i = 0; i < 40; i++) standingPose(),
        ...gettingDown(),
        ...pushUpSet(5),
      ]);
      expect(countPushups(frames).reps, 5);
    });

    test('starting the moment you are down loses nothing', () {
      // The hands take most of a second to read as settled after the walk
      // down. Somebody who starts straight away is already on the way down
      // by then, and that first rep used to be dropped — at a half-second
      // pause, one rep in five.
      for (final pause in [0, 5, 10, 15, 20, 30]) {
        final frames = timed([
          for (var i = 0; i < 40; i++) standingPose(),
          ...gettingDown(),
          ...pushUpSet(5, lead: pause),
        ]);
        expect(countPushups(frames).reps, 5,
            reason: 'a pause of $pause frames after getting down');
      }
    });

    test('a set of nothing but standing scores nothing', () {
      final frames = timed([for (var i = 0; i < 200; i++) standingPose()]);
      expect(countPushups(frames).reps, 0);
    });

    test('bobbing up and down on your feet is not a push-up', () {
      // Reported from a phone: "it counts going up and down in any position,
      // not a push-up." The hands go up and down with you.
      final poses = [
        for (var rep = 0; rep < 8; rep++)
          for (var f = 0; f < 30; f++) squatPose(repShape(f / 30)),
      ];
      expect(inPushUpPosition(poses).any((ok) => ok), isFalse,
          reason: 'a body on its feet read as a push-up position');
      expect(countPushups(timed(poses)).reps, 0);
    });

    test('on their feet, bowing toward hands held still, is not a rep', () {
      // Found on a phone: stood in front of the camera, hands still in front
      // of the chest, head lowered toward them and back. The hands test reads
      // those hands as planted and the nose travels as it does in a push-up;
      // the torso, long and upright, is what says otherwise.
      final bows = [
        for (var i = 0; i < 20; i++) bowPose(1),
        for (var rep = 0; rep < 5; rep++)
          for (var f = 0; f < 30; f++) bowPose(repShape(f / 30)),
        for (var i = 0; i < 10; i++) bowPose(1),
      ];
      expect(isStoodUp(bowPose(1)), isTrue);
      expect(isStoodUp(bowPose(0)), isTrue);
      expect(isStoodUp(pushUpPose(1)), isFalse);
      expect(isStoodUp(pushUpPose(0)), isFalse);
      expect(countPushups(timed(bows)).reps, 0);
    });

    test('a hip nobody can see is no reason to refuse a rep', () {
      // Head-on, the hips often hide behind the shoulders. Not seeing them is
      // not seeing somebody stand.
      BodyPose noHips(BodyPose pose) => BodyPose({
        for (final MapEntry(:key, :value) in pose.points.entries)
          if (key != Joint.leftHip && key != Joint.rightHip) key: value,
      });
      expect(isStoodUp(noHips(pushUpPose(1))), isNull);
      final set = [for (final pose in pushUpSet(6)) noHips(pose)];
      expect(countPushups(timed(set)).reps, 6);
    });

    test('a set that begins already in position loses nothing off the front',
        () {
      // The round starts once the lifter is down, so the first frame is
      // usually already at the top.
      expect(countPushups(timed(pushUpSet(6, lead: 0))).reps, 6);
    });

    test('reps before the round starts do not count', () {
      // The screen runs the tracker from the moment the camera opens, so it
      // knows the lifter's hands and lockout before the clock starts. A rep
      // done while the countdown runs is not in the round.
      final frames = timed([...pushUpSet(3, tail: 0), ...pushUpSet(4)]);
      final start = frames[15 + 3 * 30].atMs;
      final counted = countPushups(frames, startMs: start);
      expect(counted.reps, 4);
      expect(counted.repTimes.first, greaterThan(0));
    });
  });

  group('whole reps, not half reps', () {
    test('a set of half reps scores nothing', () {
      expect(countPushups(timed(pushUpSet(10, depth: 0.45))).reps, 0);
    });

    test('half reps in the middle of a set are left out of it', () {
      final frames = timed([
        ...pushUpSet(3, tail: 0),
        ...pushUpSet(3, depth: 0.45, lead: 0, tail: 0),
        ...pushUpSet(3, lead: 0),
      ]);
      expect(countPushups(frames).reps, 6);
    });

    test('a dip that only just stops short makes the set unsure', () {
      // Not counted — the line is the line — but close enough that a frame
      // either way would have changed it, so the confirm screen asks.
      final frames = timed([
        ...pushUpSet(3, tail: 0),
        ...pushUpSet(1, depth: 0.53, lead: 0, tail: 0),
        ...pushUpSet(3, lead: 0),
      ]);
      final counted = countPushups(frames);
      expect(counted.reps, 6);
      expect(counted.confident, isFalse);
      expect(counted.perSignal['nearMisses'], 1);
    });

    test('a clean set is a confident one', () {
      final counted = countPushups(timed(pushUpSet(8)));
      expect(counted.reps, 8);
      expect(counted.confident, isTrue);
    });

    test('getting up off the floor after the set is not a rep', () {
      final counted = countPushups(timed([...pushUpSet(5), ...gettingUp()]));
      expect(counted.reps, 5);
      // It happened after the last rep, so it is not a doubt about the set.
      expect(counted.confident, isTrue);
    });

    test('fast reps count', () {
      // The hundred-rep clip runs at 0.53 s a rep; sixteen frames.
      expect(countPushups(timed(pushUpSet(20, framesPerRep: 16))).reps, 20);
    });
  });

  group('the frame rate does not change the count', () {
    // A clip filmed at 120 frames a second counted six push-ups as twenty
    // under the old counter, whose every window was a fixed number of frames.
    for (final (fps, frameMs) in [(15, 66), (30, 33), (60, 16), (120, 8)]) {
      test('$fps frames a second', () {
        final perRep = 1000 ~/ frameMs;
        final set = pushUpSet(
          6,
          framesPerRep: perRep,
          lead: perRep ~/ 2,
          tail: perRep ~/ 3,
        );
        final counted = countPushups(timed(set, frameMs: frameMs));
        expect(counted.reps, 6);
        expect(counted.confident, isTrue);
      });
    }
  });
}

Widget _app(PoseSource source) => MaterialApp(
      theme: buildTheme(Brightness.dark),
      locale: const Locale('en'),
      localizationsDelegates: const [
        L.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L.supportedLocales,
      home: TrainerScreen(autoStart: true, poseSource: () => source),
    );

/// Opens the screen, gets into position at the top of a push-up, and waits
/// out the countdown. Returns with the round running.
Future<_ScriptedSource> _startRound(WidgetTester tester) async {
  tester.view.physicalSize = const Size(400, 880);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final source = _ScriptedSource();
  addTearDown(source.dispose);

  await tester.pumpWidget(_app(source));
  await tester.pumpAndSettle();

  // Into position and held there, through the three second countdown, the
  // way somebody waits for a start: at the top, still.
  for (var i = 0; i < 4000 ~/ kFrameMs; i++) {
    await _emit(tester, source, pushUpPose(1));
  }
  expect(find.text('GET READY'), findsNothing,
      reason: 'the round never started');
  expect(find.byKey(const Key('depthBar')), findsOneWidget);
  return source;
}

/// The biggest number on the HUD, which is the lifter's own count.
int _count(WidgetTester tester) {
  var best = 0;
  for (final text in tester.widgetList<Text>(find.byType(Text))) {
    final n = int.tryParse(text.data ?? '');
    if (n != null && n > best) best = n;
  }
  return best;
}

/// How full the depth bar is drawn, 0..1.
double _bar(WidgetTester tester) => tester
    .widget<FractionallySizedBox>(
      find.descendant(
        of: find.byKey(const Key('depthBar')),
        matching: find.byType(FractionallySizedBox),
      ),
    )
    .heightFactor!;

/// The colour one of the depth bar's two lines is drawn in.
Color? _line(WidgetTester tester, String key) =>
    (tester
                .widget<DecoratedBox>(
                  find.descendant(
                    of: find.byKey(Key(key)),
                    matching: find.byType(DecoratedBox),
                  ),
                )
                .decoration
            as BoxDecoration)
        .color;

/// One pose, and a frame's worth of time for the screen to take it in.
Future<void> _emit(
  WidgetTester tester,
  _ScriptedSource source,
  BodyPose pose,
) async {
  source.emit(pose);
  await tester.pump(const Duration(milliseconds: kFrameMs));
}

Future<void> _emitAll(
  WidgetTester tester,
  _ScriptedSource source,
  List<BodyPose> poses,
) async {
  for (final pose in poses) {
    await _emit(tester, source, pose);
  }
}

/// A pose source the test drives by hand.
class _ScriptedSource implements PoseSource {
  final _controller = StreamController<BodyPose>.broadcast();

  @override
  Stream<BodyPose> get poses => _controller.stream;

  @override
  Size? get sourceSize => const Size(480, 640);

  @override
  Widget? buildPreview(BuildContext context) =>
      const ColoredBox(color: Colors.black);

  @override
  bool get isLive => true;

  @override
  Future<void> start() async {}

  @override
  Future<void> dispose() async => _controller.close();

  /// Dropped once the screen has let the camera go. A real camera keeps
  /// producing frames into the void too; only a test double would throw.
  void emit(BodyPose pose) {
    if (_controller.isClosed) return;
    _controller.add(pose);
  }
}
