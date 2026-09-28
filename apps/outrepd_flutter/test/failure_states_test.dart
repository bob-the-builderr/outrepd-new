/// The three ways the app can stop being able to do its job: the camera is
/// refused, the network is gone, or the lifter walks out of shot.
///
/// The first two used to surface as a raw exception string in red at the
/// bottom of a form. That is not a state anybody can act on, and the camera
/// one in particular is the very first thing a new install hits.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/reps/pose_source.dart';
import 'package:outrepd/theme.dart';
import 'package:outrepd/widgets.dart';

Widget _app(Widget home, {double scale = 1.0, Locale locale = const Locale('en')}) =>
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
      home: Scaffold(body: home),
    );

void main() {
  group('a camera failure is named, not printed', () {
    test('a refusal is told apart from a missing camera', () {
      // The plugin reports this only as a code on an exception, so this
      // mapping is the whole of what the UI has to go on.
      expect(poseFailureFor('CameraAccessDenied'),
          PoseSourceFailure.permissionDenied);
      expect(poseFailureFor('CameraAccessDeniedWithoutPrompt'),
          PoseSourceFailure.permissionDenied);
      expect(poseFailureFor('CameraAccessRestricted'),
          PoseSourceFailure.permissionDenied);
      expect(poseFailureFor('cameraPermission'),
          PoseSourceFailure.permissionDenied);
      expect(poseFailureFor('cameraNotFound'), PoseSourceFailure.noCamera);

      // Anything else must not be dressed up as a permission problem — that
      // sends people to a settings page where nothing is wrong.
      expect(poseFailureFor('CameraNotReadable'), PoseSourceFailure.unknown);
      expect(poseFailureFor(''), PoseSourceFailure.unknown);
    });

    test('an error carries a kind even when nobody sets one', () {
      expect(PoseSourceError('boom').kind, PoseSourceFailure.unknown);
    });
  });

  group('the blocking notice', () {
    testWidgets('always offers a way out as well as a way through',
        (tester) async {
      var acted = 0, dismissed = 0;
      await tester.pumpWidget(_app(BlockingNotice(
        icon: Icons.videocam_off_outlined,
        title: 'Camera access needed',
        body: 'Pose detection runs on your device and nothing is uploaded.',
        actionLabel: 'Open settings',
        onAction: () => acted++,
        secondaryLabel: 'Not now',
        onSecondary: () => dismissed++,
      )));

      expect(find.text('Camera access needed'), findsOneWidget);
      expect(find.textContaining('nothing is uploaded'), findsOneWidget);

      await tester.tap(find.text('Open settings'));
      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();

      // A screen with only "Open settings" traps anybody who does not want to
      // grant the permission.
      expect(acted, 1);
      expect(dismissed, 1);
    });

    testWidgets('survives long copy on a small phone at 1.6x', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      // German writes the camera explanation longest of the thirteen.
      await tester.pumpWidget(_app(
        Builder(
          builder: (context) => BlockingNotice(
            icon: Icons.videocam_off_outlined,
            title: L.of(context).cameraNeededTitle,
            body: L.of(context).cameraNeededBody,
            actionLabel: L.of(context).openSettings,
            onAction: () {},
            secondaryLabel: L.of(context).notNow,
            onSecondary: () {},
          ),
        ),
        scale: 1.6,
        locale: const Locale('de'),
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('a real alternative reads louder than a dismissal',
        (tester) async {
      await tester.pumpWidget(_app(Builder(
        builder: (context) => BlockingNotice(
          icon: Icons.wifi_off,
          title: L.of(context).noConnection,
          body: L.of(context).noConnectionBody,
          actionLabel: L.of(context).retry,
          onAction: () {},
          secondaryLabel: L.of(context).practiceOffline,
          secondaryProminent: true,
          onSecondary: () {},
        ),
      )));
      await tester.pumpAndSettle();

      final colours = tester
          .widgetList<Text>(find.byType(Text))
          .where((t) => t.data == 'Practice offline' || t.data == 'No connection')
          .map((t) => t.style?.color)
          .toSet();

      // "Practice offline" still gets you a workout, so it is not greyed out
      // the way "Not now" is.
      expect(colours.length, 1, reason: 'both should use the primary text colour');
    });
  });
}
