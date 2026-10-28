/// The adventure: a hundred and forty fights that each ask for more than the
/// last, stars for time to spare, weapons for stars that open each world —
/// the camera screen stopping the moment the monster is down, and the stars
/// kept on the account.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/adventure/adventure.dart';
import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/reps/pose.dart';
import 'package:outrepd/reps/pose_source.dart';
import 'package:outrepd/reps/pushup_counter.dart';
import 'package:outrepd/screens/adventure_fight.dart';
import 'package:outrepd/screens/adventure_map.dart';
import 'package:outrepd/screens/trainer.dart';
import 'package:outrepd/theme.dart';

import 'support/synthetic_poses.dart';

Widget _app(Widget home, {Locale locale = const Locale('en')}) => MaterialApp(
  theme: buildTheme(Brightness.dark),
  locale: locale,
  localizationsDelegates: const [
    L.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: L.supportedLocales,
  home: home,
);

/// An account on a server that keeps adventure stars the way save_adventure
/// does: the best of what it held and what it was sent.
class _Account extends NoBackend {
  _Account(this.held);

  List<int> held;
  int saves = 0;

  @override
  bool get available => true;

  @override
  RemoteProfile? get me => const RemoteProfile(
    id: 'acct',
    username: 'lifter',
    tierIdx: 0,
    divIdx: 0,
    lp: 0,
    friendCode: 'ABC123',
  );

  @override
  Future<List<int>> myAdventure() async => held;

  @override
  Future<List<int>> saveAdventure(List<int> stars) async {
    saves++;
    held = Adventure.merge(held, stars);
    return held;
  }
}

void main() {
  test('a new form every five levels, the Warden the first sight of the '
      'next, the King the last', () {
    final forms = [
      for (final n in [1, 4, 5, 6, 9, 10, 11, 14, 15, 16, 19, 20])
        AdventureLevel.of(n).form,
    ];
    expect(forms, [1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5]);
    // The same in every world.
    expect(AdventureLevel.of(125).form, 2);
    expect(AdventureLevel.of(140).form, 5);
  });

  group('the levels', () {
    final levels = AdventureLevel.all;

    test('seven worlds of twenty', () {
      expect(levels.length, 140);
      expect(levels.first.world, 0);
      expect(levels.last.world, 6);
      expect(AdventureLevel.of(21).world, 1);
      expect(AdventureLevel.of(21).inWorld, 1);
    });

    test('every fifth a bigger fight, every twentieth a boss', () {
      expect(AdventureLevel.of(5).kind, FightKind.elite);
      expect(AdventureLevel.of(20).kind, FightKind.boss);
      expect(AdventureLevel.of(40).kind, FightKind.boss);
      expect(AdventureLevel.of(41).kind, FightKind.regular);
    });

    test('each one can take more than the one before it', () {
      for (var i = 1; i < levels.length; i++) {
        expect(
          levels[i].hp,
          greaterThan(levels[i - 1].hp),
          reason: 'level ${i + 1} is no harder than level $i',
        );
      }
    });

    test('five push-ups to start, sixty a minute at the end', () {
      expect(parReps(1), closeTo(5, 0.001));
      expect(parReps(140), closeTo(60, 0.001));
      expect(levels.first.repsWith(kWeapons.first), 5);
      expect(levels.last.repsWith(levels.last.weaponNeeded), 60);
    });

    test("with each world's own weapon the push-ups never go down", () {
      var last = 0;
      for (final level in levels) {
        final reps = level.repsWith(level.weaponNeeded)!;
        expect(reps, greaterThanOrEqualTo(last), reason: 'level ${level.number}');
        last = reps;
      }
    });

    test("a world's monsters feel only its own weapon or better", () {
      final bronze = AdventureLevel.of(21);
      expect(bronze.weaponNeeded.index, 1);
      expect(bronze.canBeHurtBy(kWeapons[0]), isFalse);
      expect(bronze.damageFrom(kWeapons[0]), 0);
      expect(bronze.repsWith(kWeapons[0]), isNull);
      expect(bronze.canBeHurtBy(kWeapons[1]), isTrue);
      expect(AdventureLevel.of(140).weaponNeeded.index, 6);
    });

    test('a better weapon than needed helps, but only a little', () {
      for (final level in levels) {
        final needed = level.weaponNeeded;
        final withIt = level.repsWith(needed)!;
        final better = level.repsWith(kWeapons[needed.index + 1])!;
        expect(better, lessThanOrEqualTo(withIt));
        // Never much more than a fifth off.
        expect(
          better,
          greaterThanOrEqualTo((withIt * 0.74).floor()),
          reason: 'level ${level.number}: $withIt with its own, $better better',
        );
      }
    });
  });

  group('stars and weapons', () {
    test('stars come from time to spare', () {
      const minute = Duration(seconds: 60);
      expect(starsFor(const Duration(seconds: 1), minute), 1);
      expect(starsFor(const Duration(seconds: 12), minute), 2);
      expect(starsFor(const Duration(seconds: 24), minute), 3);
      expect(leftFor(3, minute), const Duration(seconds: 24));
    });

    test('stars unlock weapons, and each hits harder', () {
      expect(weaponFor(0).index, 0);
      expect(weaponFor(29).index, 0);
      expect(weaponFor(30).index, 1);
      expect(weaponFor(kMaxStars).index, kWeapons.length - 1);
      for (var i = 1; i < kWeapons.length; i++) {
        expect(kWeapons[i].damage, greaterThan(kWeapons[i - 1].damage));
        expect(kWeapons[i].stars, greaterThan(kWeapons[i - 1].stars));
      }
    });

    test("each world's weapon takes more than a star a level to earn", () {
      for (var world = 1; world < kWorlds; world++) {
        final before = world * kLevelsPerWorld;
        // Reachable on the levels before it, but not on one star apiece.
        expect(kWeapons[world].stars, lessThanOrEqualTo(before * 3));
        expect(kWeapons[world].stars, greaterThan(before));
      }
    });
  });

  group('progress', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      Adventure.instance.debugSet(const []);
    });
    tearDown(() => backend = const NoBackend());

    test('a new phone starts at level one with the gauntlets', () async {
      await Adventure.instance.load();
      expect(Adventure.instance.current, 1);
      expect(Adventure.instance.totalStars, 0);
      expect(Adventure.instance.weapon.index, 0);
      expect(Adventure.instance.playable(1), isTrue);
      expect(Adventure.instance.playable(2), isFalse);
    });

    test('keeps the best stars, and says when a weapon unlocks', () async {
      final a = Adventure.instance;
      expect(await a.record(1, 2), isNull);
      expect(await a.record(1, 1), isNull, reason: 'a worse result keeps the old');
      expect(a.starsAt(1), 2);
      expect(a.current, 2);

      for (var n = 2; n <= 10; n++) {
        await a.record(n, 3);
      }
      // Twenty-nine: one short of the knuckles.
      expect(a.totalStars, 29);
      expect(a.weapon.index, 0);
      expect(await a.record(1, 3), isNotNull, reason: '30 stars unlock weapon 1');
      expect(a.weapon.index, 1);
    });

    test('a world stays shut until its weapon is won', () {
      final a = Adventure.instance;
      // Every Iron level won on one star: twenty, short of thirty.
      a.debugSet(List.filled(20, 1));
      expect(a.current, 21);
      expect(a.playable(21), isTrue);
      expect(a.canFight(21), isFalse);
      // Five of them fought again for three stars each.
      a.debugSet([...List.filled(5, 3), ...List.filled(15, 1)]);
      expect(a.totalStars, 30);
      expect(a.canFight(21), isTrue);
    });

    test('is still there after a restart', () async {
      await Adventure.instance.record(1, 3);
      await Adventure.instance.record(2, 1);
      Adventure.instance.debugSet(const []);
      await Adventure.instance.load();
      expect(Adventure.instance.starsAt(1), 3);
      expect(Adventure.instance.starsAt(2), 1);
      expect(Adventure.instance.current, 3);
    });

    test('merging keeps the best of each level', () {
      expect(Adventure.merge([3, 1], [1, 2, 3]), [3, 2, 3]);
      expect(Adventure.merge([], [2]), [2]);
      expect(Adventure.merge([5], []), [3]);
    });

    test('the phone and the account end up with the best of both', () async {
      final account = _Account([1, 3]);
      backend = account;
      Adventure.instance.debugSet([3, 0, 2]);
      await Adventure.instance.sync();
      expect(account.held, [3, 3, 2]);
      expect(
        [for (var n = 1; n <= 3; n++) Adventure.instance.starsAt(n)],
        [3, 3, 2],
      );
    });

    test("another account's stars on this phone stay with it", () async {
      final account = _Account([1]);
      backend = account;
      Adventure.instance.debugSet([3, 3, 3], owner: 'somebody-else');
      await Adventure.instance.sync();
      expect(Adventure.instance.totalStars, 1);
      expect(account.held, [1]);
      expect(account.saves, 0);
    });

    test('a won fight reaches the account', () async {
      final account = _Account([]);
      backend = account;
      Adventure.instance.debugSet(const [], owner: 'acct');
      await Adventure.instance.record(1, 2);
      await pumpEventQueue();
      expect(account.held, [2]);
    });
  });

  group('the fight on camera', () {
    testWidgets('the card shows the monster, the clock and what it has left',
        (tester) async {
      await tester.pumpWidget(_app(Scaffold(
        body: FightCard(
          level: AdventureLevel.of(1),
          weapon: kWeapons.first,
          reps: 2,
          remaining: const Duration(seconds: 41),
          counting: true,
          onStop: () {},
        ),
      )));
      expect(find.text('Pebble Golem'), findsOneWidget);
      expect(find.text('0:41'), findsOneWidget);
      expect(find.text('30 / 50'), findsOneWidget);
      expect(find.text('Give up'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('the round stops on the rep that finishes the monster',
        (tester) async {
      tester.view.physicalSize = const Size(400, 880);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final source = _ScriptedSource();
      addTearDown(source.dispose);
      PushupCount? result;
      var closed = false;

      // Level one takes 50 and the gauntlets hit for 10: five push-ups.
      await tester.pumpWidget(_app(_Launcher(
        screen: TrainerScreen(
          autoStart: true,
          forMatch: true,
          limit: kFightLength,
          game: FightGame(level: AdventureLevel.of(1), weapon: kWeapons.first),
          poseSource: () => source,
        ),
        onResult: (count) {
          result = count;
          closed = true;
        },
      )));
      await tester.pumpAndSettle();

      for (var i = 0; i < 4000 ~/ kFrameMs; i++) {
        source.emit(pushUpPose(1));
        await tester.pump(const Duration(milliseconds: kFrameMs));
      }
      expect(find.byKey(const Key('fightCard')), findsOneWidget);

      // Seven push-ups' worth of movement; the fight is over at five.
      for (final pose in pushUpSet(7, lead: 0)) {
        if (closed) break;
        source.emit(pose);
        await tester.pump(const Duration(milliseconds: kFrameMs));
      }
      await tester.pumpAndSettle();

      expect(closed, isTrue, reason: 'the camera never closed');
      expect(result?.reps, 5);
      // Stopped on the winning rep, well inside the minute.
      expect(result!.durationMs, lessThan(10000));
    });
  });

  group('the screens around it', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      Adventure.instance.debugSet(const [3, 2, 3, 1, 3, 3]);
    });

    void phone(WidgetTester tester) {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
    }

    testWidgets('the Match tab card says where the climb is', (tester) async {
      await tester.pumpWidget(_app(const Scaffold(body: AdventureCard())));
      await tester.pumpAndSettle();
      expect(find.text('Adventure'), findsOneWidget);
      expect(find.text('Level 7 · Iron Mines'), findsOneWidget);
      expect(find.text('6 of 140 cleared · no rank'), findsOneWidget);
    });

    testWidgets('the map opens on the next fight', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(const AdventureMapScreen()));
      await tester.pumpAndSettle();
      expect(find.text('Fight level 7'), findsOneWidget);
      expect(find.byKey(const Key('level-7')), findsOneWidget);
      expect(find.text('Iron Mines'), findsWidgets);
      expect(tester.takeException(), isNull);

      // A level past the next one waits.
      await tester.tap(find.byKey(const Key('level-9')));
      await tester.pump();
      expect(find.text('Win level 7 first'), findsOneWidget);

      // A won one can be fought again.
      await tester.tap(find.byKey(const Key('level-4')));
      await tester.pump();
      expect(find.text('Fight level 4'), findsOneWidget);
    });

    testWidgets("at a world's door without its weapon, the fight waits",
        (tester) async {
      phone(tester);
      // All twenty Iron levels on one star: twenty of the thirty needed.
      Adventure.instance.debugSet(List.filled(20, 1));
      await tester.pumpWidget(_app(const AdventureMapScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Needs Bronze Knuckles'), findsOneWidget);
      expect(find.text('Only Bronze Knuckles or better can hurt it'),
          findsOneWidget);
      final fight = tester.widget<FilledButton>(
        find.byKey(const Key('fightLevel')),
      );
      expect(fight.onPressed, isNull);

      await tester.pumpWidget(_app(const Scaffold(body: AdventureCard())));
      await tester.pumpAndSettle();
      expect(find.text('Needs Bronze Knuckles · 10 more stars'), findsOneWidget);
    });

    testWidgets('the armory lists every weapon', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(const AdventureMapScreen()));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('weaponChip')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('armory')), findsOneWidget);
      expect(find.text('Bronze Knuckles'), findsOneWidget);
      expect(find.text('Crownbreaker'), findsOneWidget);
      expect(find.text('EQUIPPED'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a win at the last level of a world points at its weapon',
        (tester) async {
      phone(tester);
      Adventure.instance.debugSet(List.filled(20, 1));
      await tester.pumpWidget(_app(Scaffold(
        body: AdventureResultView(
          outcome: FightOutcome(
            level: AdventureLevel.of(20),
            weapon: kWeapons.first,
            reps: 20,
            timeLeft: const Duration(seconds: 3),
            starsBefore: 0,
          ),
          xp: null,
          onNext: () {},
          onAgain: () {},
          onMap: () {},
        ),
      )));
      await tester.pumpAndSettle();
      expect(
        find.text('Bronze Dunes needs Bronze Knuckles · 10 more stars'),
        findsOneWidget,
      );
      expect(find.text('Next level'), findsNothing);
    });

    for (final code in ['de', 'hi', 'ja', 'ru']) {
      testWidgets('the result lays out in $code', (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(_app(
          Scaffold(
            body: AdventureResultView(
              outcome: FightOutcome(
                level: AdventureLevel.of(7),
                weapon: kWeapons.first,
                reps: 9,
                timeLeft: const Duration(seconds: 19),
                starsBefore: 0,
              ),
              xp: null,
              onNext: () {},
              onAgain: () {},
              onMap: () {},
            ),
          ),
          locale: Locale(code),
        ));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('adventureResult')), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });
}

/// Pushes [screen] once it is up, and hands back what it closes with.
class _Launcher extends StatefulWidget {
  const _Launcher({required this.screen, required this.onResult});

  final Widget screen;
  final void Function(PushupCount?) onResult;

  @override
  State<_Launcher> createState() => _LauncherState();
}

class _LauncherState extends State<_Launcher> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final result = await Navigator.of(context).push<PushupCount>(
        MaterialPageRoute(builder: (_) => widget.screen),
      );
      widget.onResult(result);
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold();
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
