/// Live matches: the other phone's count as it moves, the round starting when
/// both are ready, the ranked search that falls back to a saved set after
/// fifteen seconds, and the ways a friend is asked.
library;

import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/live.dart';
import 'package:outrepd/reps/pose.dart';
import 'package:outrepd/reps/pose_source.dart';
import 'package:outrepd/screens/live_invite.dart';
import 'package:outrepd/screens/match_entry.dart';
import 'package:outrepd/screens/match_flow.dart';
import 'package:outrepd/screens/trainer.dart';
import 'package:outrepd/screens/vs_screen.dart';
import 'package:outrepd/theme.dart';

import 'support/synthetic_poses.dart';

const _omar = LiveOpponent(
  id: 'omar',
  username: 'omar_fit',
  tierIdx: 2,
  divIdx: 1,
);

const _match = LiveMatch(id: 'm1', ranked: false, opponent: _omar);

/// The other phone, as far as this one can tell.
class _Link implements LiveLink {
  final _messages = StreamController<LiveMessage>.broadcast();
  final sent = <LiveMessage>[];

  @override
  Stream<LiveMessage> get messages => _messages.stream;

  @override
  Future<void> send(LiveMessage message) async => sent.add(message);

  @override
  Future<void> close() async {}

  void hear(int reps, {bool gaveUp = false}) =>
      _messages.add(LiveMessage(reps: reps, gaveUp: gaveUp));
}

class _Live extends NoBackend {
  _Live({
    _Link? link,
    this.savedSet,
    this.friendList = const [],
    this.startsIn = const Duration(milliseconds: 600),
    this.around,
  }) : link = link ?? _Link();

  /// Who else is around, for the search screen's count.
  final LiveOnline? around;

  final _Link link;

  /// Where the server puts the round's start once both are there.
  final Duration startsIn;
  final OpponentSet? savedSet;
  final List<RemoteFriend> friendList;

  bool leftQueue = false;
  int liveSearches = 0;

  @override
  bool get available => true;

  @override
  RemoteProfile? get me => const RemoteProfile(
    id: 'me',
    username: 'mokhtar',
    tierIdx: 2,
    divIdx: 2,
    lp: 10,
    friendCode: 'ABC123',
  );

  @override
  LiveLink openLiveLink(String matchId) => link;

  @override
  Future<Duration?> liveReady(String matchId) async => startsIn;

  @override
  Future<LiveState> liveState(String matchId) async => LiveState(
    status: LiveStatus.live,
    ranked: false,
    opponent: _omar,
    theyAreReady: true,
    theirReps: 0,
    startsIn: startsIn,
  );

  @override
  Future<LiveMatch?> findLiveOpponent() async {
    liveSearches++;
    return null;
  }

  @override
  Future<void> leaveLiveQueue() async => leftQueue = true;

  @override
  Future<LiveOnline?> liveOnline() async => around;

  @override
  Future<OpponentSet?> findOpponent() async => savedSet;

  @override
  Future<List<RemoteFriend>> friends() async => friendList;
}

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
  tearDown(() => backend = const NoBackend());

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(400, 880);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('their count moves with their phone, and freezes when it goes '
      'quiet', (tester) async {
    final fake = _Live();
    backend = fake;
    final session = LiveSession(_match)
      ..open()
      ..start();

    fake.link.hear(3);
    await tester.pump();
    expect(session.opponentReps, 3);

    // A message that arrives late never takes the count backwards.
    fake.link.hear(2);
    await tester.pump();
    expect(session.opponentReps, 3);
    expect(session.opponentAway, isFalse);

    await tester.pump(const Duration(seconds: 4));
    expect(session.opponentAway, isTrue, reason: 'four seconds of silence');

    fake.link.hear(4);
    await tester.pump();
    expect(session.opponentAway, isFalse);
    expect(session.opponentReps, 4);

    // And this phone's own count goes out as it lands.
    session.counted(5);
    await tester.pump();
    expect(fake.link.sent.last.reps, 5);

    await session.close();
    session.dispose();
  });

  testWidgets('a round starts once both are ready and shows their count as it '
      'moves', (tester) async {
    phone(tester);
    final fake = _Live();
    backend = fake;
    final session = LiveSession(_match);
    final source = _Source();

    await tester.pumpWidget(
      _app(
        TrainerScreen(
          autoStart: true,
          forMatch: true,
          limit: const Duration(seconds: 60),
          live: session,
          poseSource: () => source,
          duel: const DuelContext(
            opponentName: 'omar_fit',
            opponentReps: 0,
            opponentTierIdx: 2,
            opponentDivIdx: 1,
            rankLabel: 'Friendly · no rank',
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.text('Live'), findsOneWidget);

    // Into position and held there; the server gives a start 0.6 s out.
    for (var i = 0; i < 70; i++) {
      source.emit(pushUpPose(1));
      await tester.pump(const Duration(milliseconds: kFrameMs));
    }
    expect(find.text('GET READY'), findsNothing, reason: 'the round never began');
    expect(session.startedAt, isNotNull);

    // The card grew a Live tag and a Give up button; the depth bar hangs
    // under it rather than across its corner.
    expect(
      tester.getTopLeft(find.byKey(const Key('depthBar'))).dy,
      greaterThan(tester.getBottomLeft(find.byKey(const Key('scoreCard'))).dy),
    );

    // Two pumps: the first delivers the message, which marks the screen
    // dirty after that frame was already built; the second draws it.
    fake.link.hear(7);
    await tester.pump();
    await tester.pump();
    expect(find.text('7'), findsWidgets);

    await tester.pumpWidget(const SizedBox());
    await session.close();
  });

  testWidgets('the round starts ten seconds after both are there, down in '
      'position or not', (tester) async {
    phone(tester);
    backend = _Live(startsIn: const Duration(seconds: 10));
    final session = LiveSession(_match);
    final source = _Source();

    await tester.pumpWidget(
      _app(
        TrainerScreen(
          autoStart: true,
          forMatch: true,
          limit: const Duration(seconds: 60),
          live: session,
          poseSource: () => source,
          duel: const DuelContext(
            opponentName: 'omar_fit',
            opponentReps: 0,
            opponentTierIdx: 2,
            opponentDivIdx: 1,
            rankLabel: 'Friendly · no rank',
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // Still standing in front of the phone, and the count to the start is
    // already running — from ten, the same ten on both phones.
    source.emit(standingPose());
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('GET READY'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);

    // Nobody ever gets down, and it starts anyway, on time.
    for (var i = 0; i < 11 * 1000 ~/ kFrameMs; i++) {
      source.emit(standingPose());
      await tester.pump(const Duration(milliseconds: kFrameMs));
    }
    expect(find.text('GET READY'), findsNothing);
    expect(session.startedAt, isNotNull);

    await tester.pumpWidget(const SizedBox());
    await session.close();
  });

  testWidgets('ranked looks for somebody live for fifteen seconds, then offers '
      'a saved set', (tester) async {
    phone(tester);
    final fake = _Live(
      savedSet: const OpponentSet(
        setId: 's1',
        profileId: 'karim',
        username: 'karim.reps',
        tierIdx: 2,
        divIdx: 2,
        reps: 23,
      ),
    );
    backend = fake;

    await tester.pumpWidget(_app(const MatchFlowScreen()));
    await tester.pump();
    expect(find.text('Looking for a live opponent'), findsOneWidget);
    expect(find.byKey(const Key('liveSearchRing')), findsOneWidget);

    for (var i = 0; i < 18; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    expect(fake.liveSearches, greaterThan(5));
    expect(fake.leftQueue, isTrue);
    expect(find.text("Nobody's live right now"), findsOneWidget);
    expect(find.text('karim.reps'), findsOneWidget);
    expect(find.text('Did 23 in 60 seconds'), findsOneWidget);
    expect(find.text('Race it'), findsOneWidget);

    // Raced, it gets the VS screen a live match gets — tagged as a saved
    // set, not as somebody live (the user, 2026-11-04: it went straight to
    // the old versus view).
    await tester.tap(find.text('Race it'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.byType(VsScreen), findsOneWidget);
    expect(find.text('SAVED SET · RANKED'), findsOneWidget);
    expect(find.text('LIVE · RANKED'), findsNothing);
    expect(find.text('karim.reps'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the search says who else is around, and nothing when nobody is',
      (tester) async {
    phone(tester);
    backend = _Live(around: const LiveOnline(searching: 3, online: 23));
    await tester.pumpWidget(_app(const MatchFlowScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('23 online now · 3 searching'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
    // The search's own waits run out before the next screen goes up.
    await tester.pump(const Duration(seconds: 2));

    backend = _Live(around: const LiveOnline(searching: 0, online: 0));
    await tester.pumpWidget(_app(const MatchFlowScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byKey(const Key('liveOnline')), findsNothing);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('a friend online can be asked live; one who is not, sent a set',
      (tester) async {
    phone(tester);
    backend = _Live(
      friendList: [
        RemoteFriend(
          id: 'o',
          username: 'omar_fit',
          tierIdx: 2,
          divIdx: 1,
          lp: 0,
          placementsDone: 5,
          lastSeen: DateTime.now(),
          winsVsYou: 0,
          lossesVsYou: 0,
        ),
        RemoteFriend(
          id: 'y',
          username: 'youssef22',
          tierIdx: 1,
          divIdx: 3,
          lp: 0,
          placementsDone: 5,
          lastSeen: DateTime.now().subtract(const Duration(days: 2)),
          winsVsYou: 0,
          lossesVsYou: 0,
        ),
      ],
    );

    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => showFriendRoomSheet(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Every friend is asked to go live, online or not: the one online by
    // "Live", the one away by "Invite" — a push and a minute to join. No
    // set to race later between friends any more.
    expect(find.byKey(const Key('goLive-o')), findsOneWidget);
    expect(find.byKey(const Key('goLive-y')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('goLive-y')),
        matching: find.text('Invite'),
      ),
      findsOneWidget,
    );
    expect(find.text('Send a set'), findsNothing);
    expect(find.text('Online now'), findsOneWidget);
  });

  testWidgets('an invite across the top says who, how long, and joins',
      (tester) async {
    phone(tester);
    var joined = false;
    await tester.pumpWidget(
      _app(
        Scaffold(
          body: LiveInviteBanner(
            invite: const LiveInvite(
              matchId: 'm1',
              from: _omar,
              expiresIn: Duration(seconds: 42),
            ),
            readAt: clock.now(),
            onJoin: () => joined = true,
          ),
        ),
      ),
    );
    expect(find.text('omar_fit is live'), findsOneWidget);
    expect(find.text('0:42 left'), findsOneWidget);

    await tester.tap(find.byKey(const Key('joinLiveInvite')));
    expect(joined, isTrue);
  });

  test('a message between the phones survives the trip', () {
    const message = LiveMessage(reps: 12, gaveUp: true);
    final back = LiveMessage.fromJson(message.toJson());
    expect(back?.reps, 12);
    expect(back?.gaveUp, isTrue);
    expect(LiveMessage.fromJson({'nonsense': true}), isNull);
  });
}
