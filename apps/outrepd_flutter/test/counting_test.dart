/// Does the number on the screen move when somebody does push-ups?
///
/// Nothing in this suite asked that until a lifter did four and was shown
/// zero. Every counting test scored a list of poses through a function; the
/// screen was wired to a different function, and no test crossed the gap. So
/// this one drives poses into the actual screen and reads the actual meter.
library;

import 'dart:async';
import 'dart:math' as math;

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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('the meter moves when the body does', (tester) async {
    tester.view.physicalSize = const Size(400, 880);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final source = _ScriptedSource();
    addTearDown(source.dispose);

    await tester.pumpWidget(_app(source));
    await tester.pumpAndSettle();

    // Into position and held there. One frame cannot say whether the hands
    // are staying planted, and that is the test that separates a push-up from
    // any other movement — so the screen waits for a few.
    await _settle(tester, source);
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(seconds: 1));
    }

    // Eight push-ups, thirty frames each — an unhurried tempo, and the shape
    // the three body signals are read from.
    await _emitSet(tester, source, reps: 8);

    // The meter carries a number a person would recognise as their set. Not
    // exact: this is a screen test, and demanding an exact count here would
    // make it a counter test that breaks whenever the counter is tuned. What
    // it guards is the thing that was broken — a screen that shows nothing
    // while somebody works.
    // Measured at exactly 8 when this was written. The band is deliberately
    // wider than that: this is a screen test, and pinning it to the exact
    // number would turn it into a counter test that breaks on every tuning
    // pass. What it guards is the thing that was actually broken — a meter
    // that sat at zero while somebody worked.
    expect(_meter(tester), greaterThanOrEqualTo(6),
        reason: 'eight push-ups went in and the screen showed ${_meter(tester)}');
    expect(_meter(tester), lessThanOrEqualTo(10));
  });

  testWidgets('the depth bar is big enough to read from the floor',
      (tester) async {
    // The phone is on the floor and the lifter is looking down the screen at
    // it from a push-up. The bar used to be 6 pixels wide, high up under the
    // score card — legible sitting at a desk, and not from down there.
    tester.view.physicalSize = const Size(400, 880);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final source = _ScriptedSource();
    addTearDown(source.dispose);

    await tester.pumpWidget(_app(source));
    await tester.pumpAndSettle();
    await _settle(tester, source);
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    await _emit(tester, source, _pushUp(1));

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

  testWidgets('and stays at zero when nobody is moving', (tester) async {
    tester.view.physicalSize = const Size(400, 880);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final source = _ScriptedSource();
    addTearDown(source.dispose);

    await tester.pumpWidget(_app(source));
    await tester.pumpAndSettle();

    await _settle(tester, source);
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(seconds: 1));
    }

    // Held at the top for the length of a set. A counter that counts this is
    // worse than one that counts nothing.
    for (var i = 0; i < 200; i++) {
      await _emit(tester, source, _pushUp(1));
    }

    expect(_meter(tester), 0);
  });

  group('getting into position', () {
    test('standing in front of the camera is not a push-up position', () {
      // The old rule asked whether the body was in a straight line, and a
      // person standing up answers yes. That is why the skeleton went green
      // before anybody had got onto the floor.
      expect(isPushUpPosition(_standing()), isFalse);
      expect(isPushUpPosition(_pushUp(1)), isTrue);
      expect(isPushUpPosition(_pushUp(0)), isTrue);
    });

    test('lowering yourself onto the floor does not score a rep', () {
      // Reported from a phone: "it counted one and I hadn't got down yet."
      // Standing, then the descent onto the hands, then five real push-ups.
      // The descent is a bigger fall than any rep in the set, which is
      // exactly why a counter reading the whole stream scores it.
      final frames = <BodyPose>[
        for (var i = 0; i < 40; i++) _standing(),
        for (var i = 0; i < 25; i++) _gettingDown(i / 24),
        for (var i = 0; i < 10; i++) _pushUp(1),
        for (var rep = 0; rep < 5; rep++)
          for (var f = 0; f < 30; f++)
            _pushUp((1 + math.cos(f / 30 * 2 * math.pi)) / 2),
        for (var i = 0; i < 10; i++) _pushUp(1),
      ];

      expect(countPushups(frames).reps, 5);
    });

    test('a set of nothing but standing scores nothing', () {
      final frames = [for (var i = 0; i < 200; i++) _standing()];
      expect(countPushups(frames).reps, 0);
    });

    test('bobbing up and down on your feet is not a push-up', () {
      // Reported from a phone: "it counts going up and down in any position,
      // not a push-up." With the arms held out — which is how anybody tries
      // this — the arm-to-body angle alone is satisfied, and squatting is a
      // perfectly good oscillation. What it is not is a movement with the
      // hands planted: they go up and down with you.
      final frames = <BodyPose>[
        for (var rep = 0; rep < 8; rep++)
          for (var f = 0; f < 30; f++)
            _squat((1 + math.cos(f / 30 * 2 * math.pi)) / 2),
      ];

      expect(inPushUpPosition(frames).any((ok) => ok), isFalse,
          reason: 'a body on its feet read as a push-up position');
      expect(countPushups(frames).reps, 0);
    });

    test('a set that begins already in position loses nothing off the front',
        () {
      // The app starts recording once the lifter is down, so the first frame
      // is usually already in position. The start line must not trim a set
      // that has nothing in front of it — that would cost a rep to fix a
      // problem this session does not have.
      final frames = <BodyPose>[
        for (var rep = 0; rep < 6; rep++)
          for (var f = 0; f < 30; f++)
            _pushUp((1 + math.cos(f / 30 * 2 * math.pi)) / 2),
        for (var i = 0; i < 10; i++) _pushUp(1),
      ];

      expect(setStartsAt(frames), 0);
      expect(countPushups(frames).reps, 6);
    });
  });

  test('the same poses score the same through the counter alone', () {
    // The screen and the bench must agree, because the accuracy record
    // compares one against the other. Same set, both paths.
    final frames = <BodyPose>[
      for (var i = 0; i < 10; i++) _pushUp(1),
      for (var rep = 0; rep < 8; rep++)
        for (var f = 0; f < 30; f++)
          _pushUp((1 + math.cos(f / 30 * 2 * math.pi)) / 2),
      for (var i = 0; i < 10; i++) _pushUp(1),
    ];

    final counted = countPushups(frames);
    expect(counted.reps, 8);
    expect(counted.confident, isTrue);
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

/// The biggest number on the HUD, which is the lifter's own count.
int _meter(WidgetTester tester) {
  var best = 0;
  for (final text in tester.widgetList<Text>(find.byType(Text))) {
    final n = int.tryParse(text.data ?? '');
    if (n != null && n > best) best = n;
  }
  return best;
}

Future<void> _emit(
  WidgetTester tester,
  _ScriptedSource source,
  BodyPose pose,
) async {
  source.emit(pose);
  await tester.pump();
}

/// Held at the top of a push-up long enough for the screen to see that the
/// hands are planted.
Future<void> _settle(WidgetTester tester, _ScriptedSource source) async {
  for (var i = 0; i < 25; i++) {
    await _emit(tester, source, _pushUp(1));
  }
}

Future<void> _emitSet(
  WidgetTester tester,
  _ScriptedSource source, {
  required int reps,
  int framesPerRep = 30,
}) async {
  for (var rep = 0; rep < reps; rep++) {
    for (var f = 0; f < framesPerRep; f++) {
      // Starts at the top and comes back to it, the way a push-up does.
      await _emit(
        tester,
        source,
        _pushUp((1 + math.cos(f / framesPerRep * 2 * math.pi)) / 2),
      );
    }
  }
  // A moment at the top afterwards, as anybody finishing a set does.
  for (var i = 0; i < 10; i++) {
    await _emit(tester, source, _pushUp(1));
  }
}

/// A body in a push-up, [up] running 0 at the bottom to 1 at the top.
///
/// Laid out the way a camera on the floor sees one: the body runs across the
/// frame from the shoulders to the ankles, and the hands are planted under the
/// shoulders — so the arm crosses the body line rather than lying along it.
/// A body drawn standing up, however straight, is not a push-up, and the
/// position check is there to say so.
BodyPose _pushUp(double up) {
  PosePoint at(double x, double y) => PosePoint(x, y, 0.95);
  final drop = (1 - up) * 90;

  return BodyPose({
    Joint.nose: at(150, 190 + drop),
    Joint.leftShoulder: at(200, 200 + drop),
    Joint.rightShoulder: at(205, 215 + drop),
    // The forearm folds as the body drops, which is what an elbow does.
    Joint.leftElbow: at(175, 265 + drop * 0.4),
    Joint.rightElbow: at(180, 275 + drop * 0.4),
    // Planted on the floor, wherever the body goes.
    Joint.leftWrist: at(190, 330),
    Joint.rightWrist: at(195, 336),
    // The hips travel less than the shoulders, the feet not at all.
    Joint.leftHip: at(330, 214 + drop * 0.7),
    Joint.rightHip: at(335, 228 + drop * 0.7),
    Joint.leftKnee: at(430, 218 + drop * 0.4),
    Joint.rightKnee: at(435, 232 + drop * 0.4),
    Joint.leftAnkle: at(520, 222),
    Joint.rightAnkle: at(525, 236),
  });
}

/// Somebody stood in front of the phone, arms at their sides.
BodyPose _standing() {
  PosePoint at(double x, double y) => PosePoint(x, y, 0.95);
  return BodyPose({
    Joint.nose: at(240, 60),
    Joint.leftShoulder: at(210, 120),
    Joint.rightShoulder: at(270, 120),
    Joint.leftElbow: at(205, 185),
    Joint.rightElbow: at(275, 185),
    Joint.leftWrist: at(200, 245),
    Joint.rightWrist: at(280, 245),
    Joint.leftHip: at(215, 250),
    Joint.rightHip: at(265, 250),
    Joint.leftKnee: at(215, 380),
    Joint.rightKnee: at(265, 380),
    Joint.leftAnkle: at(215, 500),
    Joint.rightAnkle: at(265, 500),
  });
}

/// On their feet, arms held out in front, going up and down — a squat, a bob,
/// or somebody trying to see what the app will count. [up] is 1 standing tall
/// and 0 at the bottom.
///
/// The arms are out rather than at the sides on purpose: that satisfies the
/// arm-to-body angle, so nothing but the planted hands separates this from a
/// push-up.
BodyPose _squat(double up) {
  PosePoint at(double x, double y) => PosePoint(x, y, 0.95);
  final drop = (1 - up) * 120;

  return BodyPose({
    Joint.nose: at(240, 60 + drop),
    Joint.leftShoulder: at(210, 120 + drop),
    Joint.rightShoulder: at(270, 120 + drop),
    // Arms forward: elbows and wrists ahead of the body, not along it.
    Joint.leftElbow: at(160, 130 + drop),
    Joint.rightElbow: at(320, 130 + drop),
    Joint.leftWrist: at(110, 140 + drop),
    Joint.rightWrist: at(370, 140 + drop),
    Joint.leftHip: at(215, 250 + drop),
    Joint.rightHip: at(265, 250 + drop),
    Joint.leftKnee: at(215, 380 + drop * 0.3),
    Joint.rightKnee: at(265, 380 + drop * 0.3),
    Joint.leftAnkle: at(215, 500),
    Joint.rightAnkle: at(265, 500),
  });
}

/// The walk down onto the hands, [t] running 0 (standing) to 1 (in position).
///
/// Every landmark travels between the two, which makes it the largest single
/// movement in a session — bigger than any rep, and the reason it used to be
/// scored as one.
BodyPose _gettingDown(double t) {
  final from = _standing().points;
  final to = _pushUp(1).points;
  return BodyPose({
    for (final joint in from.keys)
      if (to[joint] case final end?)
        joint: PosePoint(
          from[joint]!.x + (end.x - from[joint]!.x) * t,
          from[joint]!.y + (end.y - from[joint]!.y) * t,
          0.95,
        ),
  });
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
