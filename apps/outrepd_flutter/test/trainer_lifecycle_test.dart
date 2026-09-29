/// The camera screen when the phone does something else mid-round: a call,
/// the notification shade. The camera is let go and opened again, and the
/// round still ends on its clock even if no pose ever arrives again.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/reps/pose.dart';
import 'package:outrepd/reps/pose_source.dart';
import 'package:outrepd/reps/pushup_counter.dart';
import 'package:outrepd/screens/trainer.dart';
import 'package:outrepd/theme.dart';

import 'support/synthetic_poses.dart';

class _Source implements PoseSource {
  final _controller = StreamController<BodyPose>.broadcast();
  bool started = false;
  bool disposed = false;

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
  Future<void> start() async => started = true;

  @override
  Future<void> dispose() async {
    disposed = true;
    await _controller.close();
  }

  void emit(BodyPose pose) {
    if (!_controller.isClosed) _controller.add(pose);
  }
}

Widget _app(Widget home) => MaterialApp(
      theme: buildTheme(Brightness.dark),
      locale: const Locale('en'),
      localizationsDelegates: const [
        L.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L.supportedLocales,
      home: home,
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(400, 880);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('the camera is let go when the app leaves, and reopened on return',
      (tester) async {
    phone(tester);
    // Each time the screen asks for a camera it gets the newest one here.
    final sources = <_Source>[_Source()];
    await tester.pumpWidget(_app(TrainerScreen(
      autoStart: true,
      poseSource: () => sources.last,
    )));
    // The first frame starts the camera.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(sources.single.started, isTrue);

    // A call comes in.
    sources.add(_Source());
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump(const Duration(milliseconds: 50));
    expect(sources.first.disposed, isTrue,
        reason: 'the camera was kept while the app was away');

    // And ends.
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump(const Duration(milliseconds: 50));
    expect(sources.last.started, isTrue,
        reason: 'the camera did not come back with the app');
    expect(sources.last.disposed, isFalse);

    // And the reopened camera is the one being read.
    for (var i = 0; i < 30; i++) {
      sources.last.emit(pushUpPose(1));
      await tester.pump(const Duration(milliseconds: kFrameMs));
    }
    expect(find.text('GET READY'), findsOneWidget,
        reason: 'poses from the reopened camera never reached the screen');

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a round ends on its clock when no pose comes to end it',
      (tester) async {
    phone(tester);
    final source = _Source();
    PushupCount? result;
    var ended = false;
    await tester.pumpWidget(_app(Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () async {
              result = await Navigator.of(context).push<PushupCount>(
                MaterialPageRoute(
                  builder: (_) => TrainerScreen(
                    autoStart: true,
                    forMatch: true,
                    limit: const Duration(seconds: 5),
                    poseSource: () => source,
                  ),
                ),
              );
              ended = true;
            },
            child: const Text('go'),
          ),
        ),
      ),
    )));
    await tester.tap(find.text('go'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Into position, through the countdown, then the camera falls silent.
    for (var i = 0; i < 4000 ~/ kFrameMs; i++) {
      source.emit(pushUpPose(1));
      await tester.pump(const Duration(milliseconds: kFrameMs));
    }
    expect(find.text('GET READY'), findsNothing);

    for (var i = 0; i < 16; i++) {
      await tester.pump(const Duration(milliseconds: 500));
    }
    await tester.pumpAndSettle();
    expect(ended, isTrue, reason: 'the round never ended without poses');
    expect(result, isNotNull);
  });
}
