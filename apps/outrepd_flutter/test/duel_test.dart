/// The duel: what it pays, and how the camera screen gets from "open" to
/// "counting".
///
/// The stage machine matters because it decides when the clock starts. Start
/// it when the camera opens and a lifter loses part of a sixty second bout to
/// propping their phone against a water bottle.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/career.dart';
import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/reps/pose.dart';
import 'package:outrepd/reps/pose_source.dart';
import 'package:outrepd/reps/exercise_type.dart';
import 'package:outrepd/screens/match_flow.dart';
import 'package:outrepd/screens/trainer.dart';
import 'package:outrepd/theme.dart';

Widget _app(Widget home, {Locale locale = const Locale('en'), double scale = 1.0}) =>
    MaterialApp(
      theme: buildTheme(Brightness.dark),
      locale: locale,
      localizationsDelegates: const [
        L.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L.supportedLocales,
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        minScaleFactor: scale,
        maxScaleFactor: scale,
        child: child!,
      ),
      home: home,
    );

void main() {
  const small = Size(360, 640);

  void phone(WidgetTester tester) {
    tester.view.physicalSize = small;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  group('the duel', () {
    test('is one bout of a fixed length', () {
      // Both lifters answer the same question in the same time. The six-round
      // card this replaced could not say that: the rounds were built out of
      // two different sets of exercise picks.
      expect(kDuelLength, const Duration(seconds: 60));
    });

    test('counts push-ups and nothing else', () {
      expect(ExerciseType.values, [ExerciseType.pushUp]);
      // Fixed on purpose: renaming the enum must not silently rewrite what
      // past sessions claim to be.
      expect(ExerciseType.pushUp.wireName, 'pushUp');
    });

    testWidgets('a stored record says what it measured', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await Career.instance.startFresh();
      await Career.instance.recordDuel(
        yourReps: 12,
        theirReps: 9,
        opponent: 'kickk',
        opponentTier: 2,
      );

      // One movement today, written down anyway: a record that does not say
      // what it measured cannot be read once a second one exists.
      expect(matchHistory.first.exerciseType, ExerciseType.pushUp);
    });
  });

  group('the camera screen', () {
    /// Opens the screen on a scripted source and returns it, already past the
    /// camera handshake and sitting in the framing stage.
    Future<_ScriptedSource> open(
      WidgetTester tester, {
      DuelContext? duel,
      Locale locale = const Locale('en'),
      double scale = 1.0,
    }) async {
      phone(tester);
      final source = _ScriptedSource();
      addTearDown(source.dispose);

      await tester.pumpWidget(_app(
        TrainerScreen(
          autoStart: true,
          forMatch: duel != null,
          limit: kDuelLength,
          duel: duel,
          poseSource: () => source,
        ),
        locale: locale,
        scale: scale,
      ));

      // The camera handshake is asynchronous and the pose stream is a
      // broadcast one, so anything emitted before the listener attaches is
      // dropped on the floor. Wait for the framing prompt, which is only on
      // screen once the subscription exists.
      for (var i = 0; i < 20; i++) {
        await tester.pump(const Duration(milliseconds: 10));
        if (tester.any(find.text('Get into position'))) break;
      }
      return source;
    }

    /// Feeds one pose and lets the screen react to it.
    ///
    /// Two pumps, not one: the first delivers the event to the listener, which
    /// marks the widget dirty — but that frame has already been built, so the
    /// rebuild lands on the second.
    Future<void> show(WidgetTester tester, _ScriptedSource source, BodyPose p) async {
      source.emit(p);
      await tester.pump();
      await tester.pump();
    }

    /// The same pose held for a moment. One frame cannot say whether the
    /// hands are staying planted, which is the test that separates a push-up
    /// from any other movement, so the screen waits for a few before it
    /// accepts somebody as being in position.
    Future<void> hold(
        WidgetTester tester, _ScriptedSource source, BodyPose p) async {
      for (var i = 0; i < 25; i++) {
        source.emit(p);
        await tester.pump();
      }
      await tester.pump();
    }

    const duel = DuelContext(
      opponentName: 'kickk',
      opponentReps: 14,
      opponentTierIdx: 2,
      opponentDivIdx: 3,
      rankLabel: 'Gold III',
    );

    testWidgets('waits for the whole body before counting anything',
        (tester) async {
      final source = await open(tester, duel: duel);

      expect(find.text('Get into position'), findsOneWidget);
      expect(find.text('Wrists and ankles must be in frame'), findsOneWidget);

      // A body with its feet out of shot is not ready. Starting the clock here
      // costs the lifter part of a sixty second bout.
      await show(tester, source, _feetOutOfShot());
      expect(find.text('GET READY'), findsNothing);
      expect(find.text('Get into position'), findsOneWidget);

      // Nor is a body standing in front of the phone, whole and in shot.
      // Reported from a phone: the skeleton went green and a rep landed
      // before the lifter had got down onto the floor.
      await show(tester, source, _standingBody());
      expect(find.text('GET READY'), findsNothing);

      // Down in position, and it counts them in.
      await hold(tester, source, _framedBody());
      expect(find.text('GET READY'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('a position it cannot read still lets the round start',
        (tester) async {
      // The other half of the trade. Waiting for the push-up position is
      // right, but if a camera angle never satisfies it, being unable to
      // start a match at all is the worse failure by a distance — so a framed
      // body that never reads as in position is counted in anyway.
      final source = await open(tester, duel: duel);

      await show(tester, source, _standingBody());
      expect(find.text('GET READY'), findsNothing);

      await tester.pump(const Duration(seconds: 9));
      await show(tester, source, _standingBody());
      expect(find.text('GET READY'), findsOneWidget);
    });

    testWidgets('counts down three, then starts the clock', (tester) async {
      final source = await open(tester, duel: duel);
      await hold(tester, source, _framedBody());

      expect(find.text('3'), findsOneWidget);
      // The clock is still full while the countdown runs: the bout has not
      // started, so no time has been spent.
      expect(find.text('1:00'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
      expect(find.text('2'), findsOneWidget);
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('1'), findsOneWidget);
      expect(find.text('1:00'), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
      expect(find.text('GET READY'), findsNothing);

      // Now it runs.
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('1:00'), findsNothing);
    });

    testWidgets('shows the clock, both counts and the rank', (tester) async {
      await open(tester, duel: duel);

      // The card is up before the bout starts, showing zeroes and the full
      // duration — numbers that appear at the countdown's end would shift the
      // layout at the exact moment somebody starts lifting.
      expect(find.text('1:00'), findsOneWidget);
      expect(find.text('You'), findsOneWidget);
      expect(find.text('kickk'), findsOneWidget);
      // No LP promise any more — nothing about the score is known yet, so
      // there is nothing here to promise a number for.
      expect(find.text('Gold III'), findsOneWidget);
      expect(find.text('Give up'), findsOneWidget);
    });

    testWidgets('the score bar has height once the bout is running',
        (tester) async {
      final source = await open(tester, duel: duel);
      await hold(tester, source, _framedBody());
      await tester.pump(const Duration(seconds: 4));

      // A ColoredBox with no child has no height of its own, so the bar is
      // only as tall as whatever the Row gives it. Centred, that is nothing —
      // and a bar drawn at zero pixels looks exactly like no bar at all.
      final bars = tester.widgetList<ColoredBox>(find.byType(ColoredBox));
      expect(bars, isNotEmpty);
      for (final box in find.byType(ColoredBox).evaluate()) {
        final size = box.size;
        if (size == null) continue;
        if (size.width > 0 && size.width < 400) {
          expect(size.height, greaterThan(0),
              reason: 'a bar segment collapsed to zero height');
        }
      }
    });

    testWidgets('a solo session has nothing at stake on screen',
        (tester) async {
      await open(tester);

      // No opponent, no LP line, and the way out says finish rather than give
      // up — there is nobody to give up against.
      expect(find.text('kickk'), findsNothing);
      expect(find.textContaining('LP'), findsNothing);
      expect(find.text('Give up'), findsNothing);
      expect(find.text('1:00'), findsOneWidget);
    });

    testWidgets('never names the movement', (tester) async {
      final source = await open(tester, duel: duel);
      await hold(tester, source, _framedBody());
      await tester.pump(const Duration(seconds: 4));

      for (final word in [
        'Push-ups',
        'PUSH-UPS',
        'Push-Ups',
        'Pick a movement',
        'Any exercise',
      ]) {
        expect(find.text(word), findsNothing, reason: '"$word" reached the UI');
      }
    });

    for (final code in ['ar', 'de', 'ja']) {
      testWidgets('the duel HUD lays out in $code', (tester) async {
        final source = await open(
          tester,
          duel: const DuelContext(
            opponentName: 'kickk.a.niqq',
            opponentReps: 14,
            opponentTierIdx: 3,
            opponentDivIdx: 2,
            rankLabel: 'Gold III',
          ),
          locale: Locale(code),
          scale: 1.3,
        );
        expect(tester.takeException(), isNull);

        await hold(tester, source, _framedBody());
        await tester.pump(const Duration(seconds: 4));
        expect(tester.takeException(), isNull);
      });
    }
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

  void emit(BodyPose pose) => _controller.add(pose);
}

/// A body the camera can see all of, including both ends.
/// Somebody down on the floor in a push-up position, as a camera on the floor
/// sees them: the body across the frame, the hands planted under the
/// shoulders. The round waits for this shape — a body merely in shot can be
/// standing up, and counting them in then spends their bout walking to the
/// floor.
BodyPose _framedBody() {
  PosePoint at(double x, double y) => PosePoint(x, y, 0.95);
  return BodyPose({
    Joint.nose: at(150, 190),
    Joint.leftShoulder: at(200, 200),
    Joint.rightShoulder: at(205, 215),
    Joint.leftElbow: at(175, 265),
    Joint.rightElbow: at(180, 275),
    Joint.leftWrist: at(190, 330),
    Joint.rightWrist: at(195, 336),
    Joint.leftHip: at(330, 214),
    Joint.rightHip: at(335, 228),
    Joint.leftKnee: at(430, 218),
    Joint.rightKnee: at(435, 232),
    Joint.leftAnkle: at(520, 222),
    Joint.rightAnkle: at(525, 236),
  });
}

/// The same person still on their feet in front of the phone.
BodyPose _standingBody() {
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

/// The same body with its feet out of shot.
BodyPose _feetOutOfShot() {
  final full = _framedBody().points;
  return BodyPose({
    for (final e in full.entries)
      if (e.key != Joint.leftAnkle && e.key != Joint.rightAnkle) e.key: e.value,
  });
}
