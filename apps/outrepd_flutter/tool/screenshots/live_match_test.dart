/// The store's first screenshot: a live match on the camera screen, drawn by
/// the real screen over a photo of a lifter mid push-up, at the App Store's
/// size and Google Play's. See shots.dart for how these are run and published.
///
/// The photos in photos/ already carry the lifter's skeleton, so the screen's
/// own is switched off; everything else — the card with its Live tag and Give
/// up, the depth bar, the cue, the rank — is the app's, from a round actually
/// played through: the reps below are counted by the real counter.
library;

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/live.dart';
import 'package:outrepd/reps/pose.dart';
import 'package:outrepd/reps/pose_source.dart';
import 'package:outrepd/screens/trainer.dart';
import 'package:outrepd/settings.dart';
import 'package:outrepd/theme.dart';

import '../../test/support/synthetic_poses.dart';

Future<void> _font(String family, List<String> paths) async {
  final loader = FontLoader(family);
  var any = false;
  for (final path in paths) {
    final file = File(path);
    if (!file.existsSync()) continue;
    final bytes = file.readAsBytesSync();
    loader.addFont(Future.value(ByteData.view(bytes.buffer)));
    any = true;
  }
  if (any) await loader.load();
}

final _rival = demoOpponents.first;

/// The other phone: it says what it has counted when asked to.
class _Link implements LiveLink {
  final _messages = StreamController<LiveMessage>.broadcast();

  @override
  Stream<LiveMessage> get messages => _messages.stream;

  @override
  Future<void> send(LiveMessage message) async {}

  @override
  Future<void> close() async {}

  void hear(int reps) => _messages.add(LiveMessage(reps: reps, gaveUp: false));
}

class _Live extends NoBackend {
  final link = _Link();

  @override
  bool get available => true;

  @override
  LiveLink openLiveLink(String matchId) => link;

  @override
  Future<Duration?> liveReady(String matchId) async =>
      const Duration(milliseconds: 600);

  @override
  Future<LiveState> liveState(String matchId) async => LiveState(
    status: LiveStatus.live,
    ranked: true,
    opponent: LiveOpponent(
      id: 'rival',
      username: _rival.username,
      tierIdx: _rival.tierIdx,
      divIdx: _rival.divIdx,
    ),
    theyAreReady: true,
    theirReps: 0,
    startsIn: const Duration(milliseconds: 600),
  );
}

/// The camera, as a photo.
class _Photo implements PoseSource {
  _Photo(this.image);

  final ui.Image image;
  final _controller = StreamController<BodyPose>.broadcast();

  @override
  Stream<BodyPose> get poses => _controller.stream;

  @override
  Size? get sourceSize => Size(image.width.toDouble(), image.height.toDouble());

  @override
  Widget? buildPreview(BuildContext context) =>
      SizedBox.expand(child: RawImage(image: image, fit: BoxFit.cover));

  @override
  bool get isLive => true;

  @override
  Future<void> start() async {}

  @override
  Future<void> dispose() async => _controller.close();

  void emit(BodyPose pose) {
    if (!_controller.isClosed) _controller.add(pose);
  }
}

void main() {
  setUpAll(() async {
    final fonts = Platform.environment['SHOT_FONTS'] ?? 'tool/screenshots/fonts';
    // Roboto, the face the app is set in on Android, in the weights the
    // screen uses; Noto Sans where the runner has no Roboto.
    final roboto = [
      for (final w in ['Regular', 'Medium', 'Bold']) '$fonts/Roboto-$w.ttf',
    ];
    final face = File(roboto.first).existsSync()
        ? roboto
        : ['$fonts/NotoSans.ttf'];
    await _font('Roboto', face);
    await _font('FlutterTest', face);
    final root = Platform.environment['FLUTTER_ROOT'];
    if (root != null) {
      await _font('MaterialIcons', [
        '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
      ]);
    }
  });

  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(() => backend = const NoBackend());

  // Both drawn at three pixels to the point, as the phones they stand for.
  for (final (width, height) in [(1320, 2868), (1080, 1920)]) {
    testWidgets('store live match ${width}x$height', (tester) async {
      tester.view.physicalSize = Size(width.toDouble(), height.toDouble());
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);

      final bytes = File(
        'tool/screenshots/photos/live_${width}x$height.jpg',
      ).readAsBytesSync();
      final photo = (await tester.runAsync(() => decodeImageFromList(bytes)))!;

      // The skeleton is in the photo already.
      settings.showSkeleton = false;
      addTearDown(() => settings.showSkeleton = true);

      final fake = _Live();
      backend = fake;
      final session = LiveSession(
        LiveMatch(
          id: 'store',
          ranked: true,
          opponent: LiveOpponent(
            id: 'rival',
            username: _rival.username,
            tierIdx: _rival.tierIdx,
            divIdx: _rival.divIdx,
          ),
        ),
      );
      final source = _Photo(photo);

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildTheme(Brightness.dark),
          locale: const Locale('en'),
          localizationsDelegates: const [
            L.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: L.supportedLocales,
          home: TrainerScreen(
            autoStart: true,
            forMatch: true,
            limit: const Duration(seconds: 60),
            live: session,
            poseSource: () => source,
            duel: DuelContext(
              opponentName: _rival.username,
              opponentReps: 0,
              opponentTierIdx: _rival.tierIdx,
              opponentDivIdx: _rival.divIdx,
              rankLabel: 'Gold III',
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      Future<void> frame(BodyPose pose) async {
        source.emit(pose);
        await tester.pump(const Duration(milliseconds: kFrameMs));
      }

      // Into position, and held through the start.
      for (var i = 0; i < 70; i++) {
        await frame(pushUpPose(1));
      }
      expect(find.text('GET READY'), findsNothing, reason: 'no round began');

      // Ten push-ups, the other phone a few behind.
      for (var rep = 1; rep <= 10; rep++) {
        for (var f = 0; f < 30; f++) {
          await frame(pushUpPose(repShape(f / 30)));
        }
        fake.link.hear((rep * 0.7).floor());
      }
      expect(find.text('10'), findsOneWidget, reason: 'the counter missed');

      // At the top until the clock says 0:18, the other phone still talking.
      for (var i = 0; i < 2000 && find.text('0:18').evaluate().isEmpty; i++) {
        await frame(pushUpPose(1));
        if (i % 30 == 0) fake.link.hear(7);
      }
      expect(find.text('0:18'), findsOneWidget);

      // And on the way down into the next one, so the cue says to push.
      for (var i = 1; i <= 10; i++) {
        await frame(pushUpPose(1 - 0.7 * i / 10));
      }
      fake.link.hear(7);
      await tester.pump();
      await tester.pump();
      expect(find.text('Go up'), findsOneWidget);
      expect(find.text('Live'), findsOneWidget);

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/store_live_match_${width}x$height.png'),
      );

      await tester.pumpWidget(const SizedBox());
      await session.close();
    });
  }
}
