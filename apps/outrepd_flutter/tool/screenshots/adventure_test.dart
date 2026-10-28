/// Screenshots of the adventure: the map, the armory, a fight on the camera
/// over the store photo, the result and a weapon unlocking — to set beside
/// the mockups the user picked from. See shots.dart for how these are run and
/// published.
library;

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/adventure/adventure.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/reps/pose.dart';
import 'package:outrepd/reps/pose_source.dart';
import 'package:outrepd/screens/adventure_fight.dart';
import 'package:outrepd/screens/adventure_map.dart';
import 'package:outrepd/screens/trainer.dart';
import 'package:outrepd/settings.dart';
import 'package:outrepd/theme.dart';
import 'package:outrepd/xp.dart';

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

Widget _app(Widget home) => MaterialApp(
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
  home: home,
);

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

  // A test in all but folder: it lives in tool/ so `flutter test` skips it.
  setUp(() {
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
    // Six won, the knuckles in hand (twelve stars), level seven next: the
    // state the mockups were drawn in.
    // ignore: invalid_use_of_visible_for_testing_member
    Adventure.instance.debugSet(const [3, 2, 3, 1, 3, 3]);
  });

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(412 * 2, 915 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
  }

  testWidgets('map', (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(const AdventureMapScreen()));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/adventure_map.png'),
    );
  });

  testWidgets('map at a world gate', (tester) async {
    phone(tester);
    // Every Iron level won on one star: twenty of the thirty the knuckles
    // need, and Bronze Dunes shut until they are won.
    // ignore: invalid_use_of_visible_for_testing_member
    Adventure.instance.debugSet(List.filled(20, 1));
    await tester.pumpWidget(_app(const AdventureMapScreen()));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/adventure_map_gate.png'),
    );
  });

  testWidgets('armory', (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(const AdventureMapScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('weaponChip')));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/adventure_armory.png'),
    );
  });

  testWidgets('match tab card', (tester) async {
    phone(tester);
    await tester.pumpWidget(
      _app(
        const Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: AdventureCard()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/adventure_card.png'),
    );
  });

  testWidgets('fight', (tester) async {
    tester.view.physicalSize = const Size(1320, 2868);
    tester.view.devicePixelRatio = 3;
    const insets = FakeViewPadding(top: 62 * 3, bottom: 34 * 3);
    tester.view.padding = insets;
    tester.view.viewPadding = insets;
    addTearDown(tester.view.reset);

    final bytes = File(
      'tool/screenshots/photos/live_1320x2868.jpg',
    ).readAsBytesSync();
    final photo = (await tester.runAsync(() => decodeImageFromList(bytes)))!;
    settings.showSkeleton = false;
    addTearDown(() => settings.showSkeleton = true);
    final source = _Photo(photo);

    await tester.pumpWidget(
      _app(
        TrainerScreen(
          autoStart: true,
          forMatch: true,
          limit: kFightLength,
          game: FightGame(
            level: AdventureLevel.of(7),
            weapon: Adventure.instance.weapon,
          ),
          poseSource: () => source,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    Future<void> frame(BodyPose pose) async {
      source.emit(pose);
      await tester.pump(const Duration(milliseconds: kFrameMs));
    }

    // Through the ten second count down to the start.
    for (var i = 0; i < 11000 ~/ kFrameMs; i++) {
      await frame(pushUpPose(1));
    }
    // Three push-ups a second apart, and the fourth landing as the shot is
    // taken: the combo up, the damage rising off the monster.
    for (var rep = 1; rep <= 4; rep++) {
      for (var f = 0; f < 30; f++) {
        await frame(pushUpPose(repShape(f / 30)));
      }
    }
    await tester.pump(const Duration(milliseconds: 120));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/adventure_fight.png'),
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('cleared', (tester) async {
    phone(tester);
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: AdventureResultView(
            outcome: FightOutcome(
              level: AdventureLevel.of(7),
              weapon: kWeapons[1],
              reps: 10,
              timeLeft: const Duration(seconds: 19),
              starsBefore: 0,
            ),
            xp: const XpGain(before: 4480, after: 4490, reps: 10),
            onNext: () {},
            onAgain: () {},
            onMap: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/adventure_cleared.png'),
    );
  });

  testWidgets('out of time', (tester) async {
    phone(tester);
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: AdventureResultView(
            outcome: FightOutcome(
              level: AdventureLevel.of(20),
              weapon: kWeapons[1],
              reps: 9,
              timeLeft: Duration.zero,
              starsBefore: 0,
            ),
            xp: const XpGain(before: 4480, after: 4489, reps: 9),
            onNext: null,
            onAgain: () {},
            onMap: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/adventure_out_of_time.png'),
    );
  });

  testWidgets('new weapon', (tester) async {
    phone(tester);
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: WeaponUnlockedView(
            weapon: kWeapons[2],
            previous: kWeapons[1],
            onContinue: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/adventure_new_weapon.png'),
    );
  });
}
