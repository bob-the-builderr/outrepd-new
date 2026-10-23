/// The promo copy, end to end: the plan, the staged opponent, and a whole
/// take from the setup to the result — through the app's own camera screen,
/// fed a scripted set.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd_promo/backend/backend.dart';
import 'package:outrepd_promo/l10n/app_localizations.dart';
import 'package:outrepd_promo/live.dart';
import 'package:outrepd_promo/promo/match_screen.dart';
import 'package:outrepd_promo/promo/plan.dart';
import 'package:outrepd_promo/promo/promo_backend.dart';
import 'package:outrepd_promo/promo/result_screen.dart';
import 'package:outrepd_promo/promo/setup_screen.dart';
import 'package:outrepd_promo/reps/pose.dart';
import 'package:outrepd_promo/reps/pose_source.dart';
import 'package:outrepd_promo/theme.dart';

import 'support/synthetic_poses.dart';

class _Source implements PoseSource {
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
  Future<void> dispose() async {
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
  tearDown(() {
    backend = const NoBackend();
    promoPoseSource = null;
  });

  void phone(WidgetTester tester, {Size size = const Size(400, 880)}) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  group('the plan', () {
    test('films each take unless told not to, and keeps the choice', () {
      expect(PromoPlan().record, isTrue);
      expect(PromoPlan.fromJson(const {}).record, isTrue);
      expect(PromoPlan.fromJson(const {'record': false}).record, isFalse);
      expect(PromoPlan(record: false).toJson()['record'], isFalse);
      // 1080p unless asked: 4K asks more of the pose detection.
      expect(PromoPlan().camera4k, isFalse);
      expect(PromoPlan.fromJson(const {'camera4k': true}).camera4k, isTrue);
    });

    test('a final count is paced across the minute, quick then slower', () {
      final times = PromoPlan.paced(20);
      expect(times, hasLength(20));
      // The first a few seconds in, as a lifter settling into twenty does.
      expect(times.first, inInclusiveRange(1500, 4000));
      expect(times.last, lessThan(60000));
      expect(times, orderedEquals([...times]..sort()));
      // Tiring: the last five take longer than the first five.
      expect(times[19] - times[15], greaterThan(times[4] - times[0]));
      // The same count paces the same way, so a retake matches.
      expect(PromoPlan.paced(20), times);
    });

    test('seconds are read however they are typed, inside the minute', () {
      expect(
        PromoPlan.parseSeconds('7, 2;4.5\n61 x -1 60'),
        [2000, 4500, 7000, 60000],
      );
      expect(PromoPlan.parseSeconds(''), isEmpty);
    });

    test('kept between launches', () async {
      final plan = PromoPlan(
        myName: 'Mokhtar',
        oppTier: 6,
        mode: OpponentMode.custom,
        customSeconds: '1, 2, 3',
      );
      await plan.save();
      final back = await PromoPlan.load();
      expect(back.myName, 'Mokhtar');
      expect(back.oppTier, 6);
      expect(back.mode, OpponentMode.custom);
      expect(back.repTimesMs(), [1000, 2000, 3000]);
    });
  });

  group('the opponent', () {
    testWidgets('ends on the final count, rep by rep through the minute', (
      tester,
    ) async {
      final plan = PromoPlan(
        mode: OpponentMode.finalCount,
        finalCount: 12,
        countdownSeconds: 3,
      );
      final promo = PromoBackend(plan);
      backend = promo;
      final session = LiveSession(
        LiveMatch(id: 'promo', ranked: true, opponent: promo.opponent),
      )..open();

      final start = await session.ready();
      expect(start, isNotNull);
      await tester.pump(const Duration(seconds: 3));
      session.start();

      await tester.pump(const Duration(seconds: 20));
      final early = session.opponentReps;
      expect(early, inInclusiveRange(1, 11));

      await tester.pump(const Duration(seconds: 41));
      expect(session.opponentReps, 12);
      // Never "gone quiet": the line keeps talking between reps.
      expect(session.opponentAway, isFalse);

      await session.close();
      session.dispose();
    });

    testWidgets('lands each rep on the second it was given', (tester) async {
      final plan = PromoPlan(
        mode: OpponentMode.custom,
        customSeconds: '1, 2, 10',
        countdownSeconds: 3,
      );
      final promo = PromoBackend(plan);
      backend = promo;
      final session = LiveSession(
        LiveMatch(id: 'promo', ranked: true, opponent: promo.opponent),
      )..open();
      await session.ready();
      await tester.pump(const Duration(seconds: 3));
      session.start();

      await tester.pump(const Duration(milliseconds: 2500));
      expect(session.opponentReps, 2);
      await tester.pump(const Duration(seconds: 7));
      expect(session.opponentReps, 2);
      await tester.pump(const Duration(seconds: 1));
      expect(session.opponentReps, 3);

      await session.close();
      session.dispose();
    });

    testWidgets('following you, always the planned number behind', (
      tester,
    ) async {
      final plan = PromoPlan(behindBy: 2, countdownSeconds: 3);
      final promo = PromoBackend(plan);
      backend = promo;
      final session = LiveSession(
        LiveMatch(id: 'promo', ranked: true, opponent: promo.opponent),
      )..open();
      await session.ready();
      session.start();

      session.counted(1);
      await tester.pump(const Duration(seconds: 1));
      expect(session.opponentReps, 0);
      session.counted(5);
      await tester.pump(const Duration(seconds: 1));
      expect(session.opponentReps, 3);

      await session.close();
      session.dispose();
    });
  });

  testWidgets('the setup fits a small iPhone', (tester) async {
    phone(tester, size: const Size(375, 667));
    await tester.pumpWidget(_app(SetupScreen(plan: PromoPlan())));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('OUTREPD Promo'), findsOneWidget);

    // Every mode has its fields, and none of them overflows.
    for (final mode in ['Ends on', 'Each rep', 'Behind me']) {
      await tester.scrollUntilVisible(
        find.text(mode),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(find.text(mode));
      await tester.pumpAndSettle();
      await tester.tap(find.text(mode));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: mode);
    }
  });

  testWidgets('a whole take: setup, the round, the result, and back', (
    tester,
  ) async {
    phone(tester);
    final source = _Source();
    promoPoseSource = () => source;
    final plan = PromoPlan(
      myName: 'Mokhtar',
      oppName: 'iron_mike',
      behindBy: 2,
      countdownSeconds: 3,
      myLp: 40,
      // Filming is ReplayKit's, and there is no iPhone here.
      record: false,
    );

    await tester.pumpWidget(_app(SetupScreen(plan: plan)));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('startPromo')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.byKey(const Key('startPromo')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('startPromo')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // The app's own live card, with both names as chosen.
    expect(find.text('Live'), findsOneWidget);
    expect(find.text('Mokhtar'), findsWidgets);
    expect(find.text('iron_mike'), findsWidgets);

    // Down in position through the countdown.
    for (var i = 0; i < 3500 ~/ kFrameMs; i++) {
      source.emit(pushUpPose(1));
      await tester.pump(const Duration(milliseconds: kFrameMs));
    }

    // Five push-ups; the opponent follows two behind.
    for (final pose in pushUpSet(5)) {
      source.emit(pose);
      await tester.pump(const Duration(milliseconds: kFrameMs));
    }
    await tester.pump(const Duration(seconds: 1));

    // The rest of the minute, still in position.
    for (var s = 0; s < 56; s++) {
      for (var i = 0; i < 4; i++) {
        source.emit(pushUpPose(1));
        await tester.pump(const Duration(milliseconds: 250));
      }
    }
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('YOU WON'), findsOneWidget);
    expect(find.text('2 reps ahead.'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    // Two reps ahead of a Diamond IV, from Gold III: weighed up, as the app
    // pays it.
    expect(find.text('+3 LP'), findsOneWidget);
    expect(find.text('+25 XP'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // The rank moved on the screen, not in the plan: a retake starts the same.
    expect(plan.myLp, 40);

    // Back on the setup, where it was left: scrolled down to Start.
    await tester.tap(find.byKey(const Key('done')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('startPromo')), findsOneWidget);
  });

  testWidgets('a promotion comes first, then the result', (tester) async {
    phone(tester);
    final plan = PromoPlan(myTier: 3, myDiv: 2, myLp: 98);
    await tester.pumpWidget(
      _app(PromoResultScreen(plan: plan, yours: 10, theirs: 5, gaveUp: false)),
    );
    await tester.pumpAndSettle();

    expect(find.text('PROMOTED'), findsOneWidget);
    expect(find.text('Gold II'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('continue')));
    await tester.pumpAndSettle();
    expect(find.text('YOU WON'), findsOneWidget);
    expect(find.text('+8 LP'), findsOneWidget);
  });

  testWidgets('a level-up, when planned, comes before the result', (
    tester,
  ) async {
    phone(tester);
    final plan = PromoPlan(myLevel: 12, levelUp: true);
    await tester.pumpWidget(
      _app(PromoResultScreen(plan: plan, yours: 10, theirs: 5, gaveUp: false)),
    );
    await tester.pumpAndSettle();

    expect(find.text('LEVEL UP'), findsOneWidget);
    expect(find.text('13'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('levelUpContinue')));
    await tester.pumpAndSettle();
    expect(find.text('YOU WON'), findsOneWidget);
    expect(find.text('+30 XP'), findsOneWidget);
  });

  testWidgets('giving up is a loss whatever the count', (tester) async {
    phone(tester);
    await tester.pumpWidget(
      _app(
        PromoResultScreen(plan: PromoPlan(), yours: 9, theirs: 4, gaveUp: true),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('YOU LOST'), findsOneWidget);
  });
}
