/// The twelve-step onboarding.
///
/// The order is the design: the camera is asked for only after the app has
/// said what it is for, and the account only after the lifter has three reps
/// of their own to lose. A test that only checks the screens render would miss
/// that entirely, so these walk the flow.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/reps/pose.dart';
import 'package:outrepd/reps/pose_source.dart';
import 'package:outrepd/screens/onboarding.dart';
import 'package:outrepd/theme.dart';

import 'support/synthetic_poses.dart';

/// Answers the email flow the way a real server would for a brand new
/// address: the code is always accepted, since these tests are about the
/// onboarding steps around it, not about the server itself.
class _FakeBackend extends NoBackend {
  @override
  Future<RenameResult> renameUsername(String name) async => RenameResult.ok;

  @override
  Future<EmailSignUpResult> startEmailSignUp({
    required String email,
  }) async => EmailSignUpResult.ok;

  @override
  Future<bool> verifyEmailCode({
    required String email,
    required String code,
  }) async => true;
}

Widget _app(
  PoseSource Function()? source, {
  double scale = 1.0,
  Locale locale = const Locale('en'),
}) =>
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
      home: OnboardingScreen(poseSource: source),
    );

void main() {
  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Future<void> tap(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  testWidgets('opens on the brand, not on a permission prompt',
      (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(null));
    await tester.pumpAndSettle();

    // The wordmark is part of the logo asset, so there is no text to find.
    final logo = tester.widget<Image>(find.byType(Image));
    expect((logo.image as AssetImage).assetName,
        'assets/images/logo-wordmark.png');
    expect(find.text('Get started'), findsOneWidget);
    expect(find.text('I already have an account'), findsOneWidget);

    // Nothing is asked for on the first screen.
    expect(find.text('Allow camera'), findsNothing);
  });

  testWidgets('back goes to the step before, not out of the app',
      (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(null));
    await tester.pumpAndSettle();

    await tap(tester, 'Get started');
    expect(find.textContaining('Three things'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('Get started'), findsOneWidget);
  });

  testWidgets('says what the camera is for before asking for it',
      (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(null));
    await tester.pumpAndSettle();

    await tap(tester, 'Get started');
    expect(find.textContaining('Three things'), findsOneWidget);

    // What a duel is and what there is to climb, before anything is asked.
    await tap(tester, 'Continue');
    expect(find.text('You race a real person’s minute'), findsOneWidget);
    expect(find.text('+7 LP'), findsOneWidget);

    await tap(tester, 'Continue');
    expect(find.text('Seven tiers to climb'), findsOneWidget);
    expect(find.text('Master'), findsOneWidget);
    expect(find.text('Iron'), findsOneWidget);

    await tap(tester, 'Continue');
    expect(find.text('Two quick things.'), findsOneWidget);

    // Both answers are needed, so Continue is dead until they are given.
    await tap(tester, '16 or over');
    expect(find.text('Two quick things.'), findsOneWidget);

    await tap(tester, 'I understand outrepd counts reps and does not give '
        'medical or training advice. I’ll stop if something hurts.');
    await tap(tester, 'Continue');

    expect(find.text('outrepd needs your camera'), findsOneWidget);
    // The promise is on the screen that asks, not in a policy nobody opens.
    expect(find.text('Nothing leaves your phone'), findsOneWidget);
    expect(find.text('Allow camera'), findsOneWidget);
  });

  testWidgets('under sixteen is turned away without a way around it',
      (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(null));
    await tester.pumpAndSettle();

    await tap(tester, 'Get started');
    await tap(tester, 'Continue');
    await tap(tester, 'Continue');
    await tap(tester, 'Continue');
    await tap(tester, 'Under 16');

    expect(find.textContaining('outrepd is for 16 and over'), findsOneWidget);
    // No health box to tick, so the gate cannot be satisfied.
    expect(find.textContaining('I understand outrepd counts reps'),
        findsNothing);

    await tap(tester, 'Continue');
    expect(find.text('outrepd needs your camera'), findsNothing);
  });

  testWidgets('the framing check waits for both ends of the body',
      (tester) async {
    phone(tester);
    final source = _ScriptedSource();
    addTearDown(source.dispose);

    await tester.pumpWidget(_app(() => source));
    await tester.pumpAndSettle();

    await tap(tester, 'Get started');
    await tap(tester, 'Continue');
    await tap(tester, 'Continue');
    await tap(tester, 'Continue');
    await tap(tester, '16 or over');
    await tap(tester, 'I understand outrepd counts reps and does not give '
        'medical or training advice. I’ll stop if something hurts.');
    await tap(tester, 'Continue');
    await tap(tester, 'Allow camera');
    await tap(tester, 'I’m set up');

    expect(find.text('Get into a push-up position'), findsOneWidget);
    for (final mark in ['Shoulders and hips', 'Wrists', 'Ankles']) {
      expect(find.text(mark), findsOneWidget);
    }

    // Feet out of shot: the step will not let anybody past.
    source.emit(_feetOutOfShot());
    await tester.pump();
    await tester.pump();
    await tap(tester, 'Looks good');
    expect(find.text('Get into a push-up position'), findsOneWidget);

    // Whole body, and it moves on.
    source.emit(_framedBody());
    await tester.pump();
    await tester.pump();
    await tap(tester, 'Looks good');
    expect(find.text('Get into a push-up position'), findsNothing);
    expect(find.text('CALIBRATING'), findsOneWidget);
  });

  testWidgets('held in frame a moment, the framing check moves on by itself',
      (tester) async {
    // The lifter is on the floor a metre from the phone; the button is out
    // of reach.
    phone(tester);
    final source = _ScriptedSource();
    addTearDown(source.dispose);
    await tester.pumpWidget(_app(() => source));
    await tester.pumpAndSettle();

    await tap(tester, 'Get started');
    await tap(tester, 'Continue');
    await tap(tester, 'Continue');
    await tap(tester, 'Continue');
    await tap(tester, '16 or over');
    await tap(tester, 'I understand outrepd counts reps and does not give '
        'medical or training advice. I’ll stop if something hurts.');
    await tap(tester, 'Continue');
    await tap(tester, 'Allow camera');
    await tap(tester, 'I’m set up');
    expect(find.text('Get into a push-up position'), findsOneWidget);

    for (var i = 0; i < 50; i++) {
      source.emit(_framedBody());
      await tester.pump(const Duration(milliseconds: kFrameMs));
    }
    await tester.pumpAndSettle();
    expect(find.text('Get into a push-up position'), findsNothing);
    expect(find.text('CALIBRATING'), findsOneWidget);
  });

  testWidgets('three push-ups finish the calibration', (tester) async {
    // The step a new lifter cannot get past if the counter does not count.
    // It was scored from an elbow angle, which a phone on the floor reads
    // worst of all, and there was no test that ever finished it — so a dead
    // end in the first two minutes of the app passed every suite.
    phone(tester);

    // Each camera step opens its own source and closes it on the way out, so
    // the test hands out a new one per step and always drives the live one.
    final sources = <_ScriptedSource>[];
    _ScriptedSource open() {
      final source = _ScriptedSource();
      sources.add(source);
      addTearDown(source.dispose);
      return source;
    }

    await tester.pumpWidget(_app(open));
    await tester.pumpAndSettle();

    await tap(tester, 'Get started');
    await tap(tester, 'Continue');
    await tap(tester, 'Continue');
    await tap(tester, 'Continue');
    await tap(tester, '16 or over');
    await tap(tester, 'I understand outrepd counts reps and does not give '
        'medical or training advice. I’ll stop if something hurts.');
    await tap(tester, 'Continue');
    await tap(tester, 'Allow camera');
    await tap(tester, 'I’m set up');

    sources.last.emit(_framedBody());
    await tester.pump();
    await tester.pump();
    await tap(tester, 'Looks good');
    expect(find.text('CALIBRATING'), findsOneWidget);

    // Four unhurried push-ups, thirty poses a second. The step asks for three.
    for (final pose in pushUpSet(4)) {
      sources.last.emit(pose);
      await tester.pump(const Duration(milliseconds: kFrameMs));
    }
    await tester.pumpAndSettle();

    expect(find.text('Calibrated.'), findsOneWidget,
        reason: 'four push-ups went in and the step did not complete');
  });

  testWidgets('going straight to log in skips the camera and calibration',
      (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(null));
    await tester.pumpAndSettle();

    // A returning lifter's account already has its own range on file, so
    // this route skips straight past everything the rest of onboarding
    // exists to set up for the first time.
    await tap(tester, 'I already have an account');

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Log in to keep your rank.'), findsOneWidget);
    expect(find.text('Send code'), findsOneWidget);
    expect(find.text('Allow camera'), findsNothing);
  });

  testWidgets('ends unranked, with placements still to play', (tester) async {
    final was = demoProfile.placementsDone;
    addTearDown(() => demoProfile.placementsDone = was);
    backend = _FakeBackend();
    addTearDown(() => backend = const NoBackend());

    phone(tester);
    final sources = <_ScriptedSource>[];
    _ScriptedSource open() {
      final source = _ScriptedSource();
      sources.add(source);
      addTearDown(source.dispose);
      return source;
    }

    await tester.pumpWidget(_app(open));
    await tester.pumpAndSettle();

    await tap(tester, 'Get started');
    await tap(tester, 'Continue');
    await tap(tester, 'Continue');
    await tap(tester, 'Continue');
    await tap(tester, '16 or over');
    await tap(tester, 'I understand outrepd counts reps and does not give '
        'medical or training advice. I’ll stop if something hurts.');
    await tap(tester, 'Continue');
    await tap(tester, 'Allow camera');
    await tap(tester, 'I’m set up');

    sources.last.emit(_framedBody());
    await tester.pump();
    await tester.pump();
    await tap(tester, 'Looks good');

    for (final pose in pushUpSet(4)) {
      sources.last.emit(pose);
      await tester.pump(const Duration(milliseconds: kFrameMs));
    }
    await tester.pumpAndSettle();

    expect(find.text('Calibrated.'), findsOneWidget);
    // Straight on to placements. There is no notifications step: the app
    // sends no push, so it has no permission to ask for.
    await tap(tester, 'Continue');
    expect(find.textContaining('Five duels'), findsOneWidget);

    // The account gate at the very end: nothing past here is reachable
    // without going through it.
    await tap(tester, 'Find my first opponent');
    await tap(tester, 'Sign up with email');

    await tester.enterText(find.byType(TextField).at(0), 'lifter_one');
    await tester.enterText(find.byType(TextField).at(1), 'lifter@example.com');
    await tester.pump();
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    // The code stage: six boxes over one field. Typed a digit at a time, a
    // mistake deleted straight back across a box — which six separate fields
    // could not do from a phone keyboard — and the sixth digit submits on
    // its own rather than waiting on a button.
    final code = find.byKey(const Key('codeField'));
    await tester.enterText(code, '1239');
    await tester.pump();
    expect(find.text('9'), findsOneWidget);
    await tester.enterText(code, '12');
    await tester.pump();
    expect(find.text('9'), findsNothing);
    expect(find.text('3'), findsNothing);
    await tester.enterText(code, '123456');
    await tester.pumpAndSettle();

    expect(find.text('Unranked'), findsOneWidget);
    expect(find.textContaining('Five duels'), findsOneWidget);
    expect(find.text('0 of 5 · 60 seconds each'), findsOneWidget);
  });

  for (final scale in [1.3, 1.6]) {
    testWidgets('every step lays out at ${scale}x', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(null, scale: scale));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tap(tester, 'Get started');
      expect(tester.takeException(), isNull);
      for (var i = 0; i < 3; i++) {
        await tap(tester, 'Continue');
        expect(tester.takeException(), isNull);
      }
      await tap(tester, '16 or over');
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('lays out in Hindi', (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(null, scale: 1.3, locale: const Locale('hi')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  // German is the long one. "Wiederholungen" is fourteen characters where
  // English says "reps", and the first thing a new lifter sees is the worst
  // place to find that out.
  testWidgets('lays out in German at 1.6x', (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(null, scale: 1.6, locale: const Locale('de')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tap(tester, 'Los geht’s');
    expect(tester.takeException(), isNull);
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

  /// Dropped once the screen has let the camera go — which it does the moment
  /// a step is satisfied. A real camera keeps producing frames into the void
  /// too; only a test double would throw about it.
  void emit(BodyPose pose) {
    if (_controller.isClosed) return;
    _controller.add(pose);
  }
}

BodyPose _framedBody() {
  PosePoint at(double x, double y) => PosePoint(x, y, 0.95);
  return BodyPose({
    Joint.nose: at(240, 120),
    Joint.leftShoulder: at(200, 200),
    Joint.rightShoulder: at(280, 200),
    Joint.leftElbow: at(190, 260),
    Joint.rightElbow: at(290, 260),
    Joint.leftWrist: at(185, 320),
    Joint.rightWrist: at(295, 320),
    Joint.leftHip: at(210, 340),
    Joint.rightHip: at(270, 340),
    Joint.leftKnee: at(210, 440),
    Joint.rightKnee: at(270, 440),
    Joint.leftAnkle: at(210, 540),
    Joint.rightAnkle: at(270, 540),
  });
}

BodyPose _feetOutOfShot() {
  final full = _framedBody().points;
  return BodyPose({
    for (final e in full.entries)
      if (e.key != Joint.leftAnkle && e.key != Joint.rightAnkle) e.key: e.value,
  });
}
