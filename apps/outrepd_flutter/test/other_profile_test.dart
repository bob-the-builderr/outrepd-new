/// Somebody else's profile: the quick peek, the full card, and the
/// share/mute/block/report menu both of them open into.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/live_invite.dart';
import 'package:outrepd/screens/other_profile.dart';
import 'package:outrepd/screens/settings_privacy.dart';
import 'package:outrepd/theme.dart';

class _FakeBackend extends NoBackend {
  _FakeBackend(this.profile);

  final LifterProfile? profile;
  bool muteCalled = false;
  bool blockCalled = false;
  bool removeCalled = false;
  AskResult askResult = AskResult.asked;

  @override
  Future<void> removeFriend(String theirId) async => removeCalled = true;

  @override
  bool get available => true;

  @override
  Future<LifterProfile?> lifterProfile(String theirId) async => profile;

  @override
  Future<void> mute(String theirId) async => muteCalled = true;

  @override
  Future<void> block(String theirId) async => blockCalled = true;

  @override
  Future<AskResult> askFriend(String username) async => askResult;
}

LifterProfile _played({bool isFriend = false}) => LifterProfile(
  id: 'ayaan99-id',
  username: 'ayaan99',
  tierIdx: 5,
  divIdx: 4,
  lp: 72,
  placementsDone: 5,
  totalReps: 3140,
  bestSet: 31,
  wins: 41,
  losses: 12,
  winStreak: 22,
  globalPlace: 3,
  country: 'EG',
  countryPlace: 1,
  isFriend: isFriend,
  winsVsYou: 3,
  lossesVsYou: 1,
  yourBestVsThem: 16,
  lastDuelAt: DateTime.now().subtract(const Duration(days: 2)),
  lastYourReps: 14,
  lastTheirReps: 19,
);

const _unplayed = LifterProfile(
  id: 'newcomer-id',
  username: 'newcomer',
  tierIdx: 1,
  divIdx: 2,
  lp: 40,
  placementsDone: 5,
  totalReps: 200,
  bestSet: 12,
  wins: 3,
  losses: 2,
  winStreak: 1,
  // A friend you have not raced yet — the record only shows for friends.
  isFriend: true,
  winsVsYou: 0,
  lossesVsYou: 0,
);

/// A screen with one button that opens the quick peek — `showModalBottomSheet`
/// needs a `Navigator` and a page beneath it to sit over, same as the app
/// itself always has one.
Widget _appWithPeekButton() => MaterialApp(
  theme: buildTheme(Brightness.dark),
  localizationsDelegates: const [
    L.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: L.supportedLocales,
  home: Scaffold(
    body: Builder(
      builder: (context) => Center(
        child: ElevatedButton(
          onPressed: () =>
              showLifterPeek(context, id: 'ayaan99-id', username: 'ayaan99'),
          child: const Text('open'),
        ),
      ),
    ),
  ),
);

void main() {
  const small = Size(360, 640);

  void phone(WidgetTester tester) {
    tester.view.physicalSize = small;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  setUp(() => backend = const NoBackend());
  tearDown(() => backend = const NoBackend());

  group('quick peek', () {
    testWidgets('shows a couldn\'t-load state with no backend', (
      tester,
    ) async {
      phone(tester);
      await tester.pumpWidget(_appWithPeekButton());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('ayaan99'), findsOneWidget);
      expect(find.text("Couldn't load this profile"), findsOneWidget);
    });

    testWidgets('shows the record, best set and win rate once loaded', (
      tester,
    ) async {
      backend = _FakeBackend(_played(isFriend: true));
      phone(tester);
      await tester.pumpWidget(_appWithPeekButton());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      // The rating: 1,000 + 500 a tier + 100 a division + 72 (2026-11-02),
      // on the rank row under the name (the player card, 2026-11-03).
      expect(find.text('DIAMOND I'), findsOneWidget);
      expect(find.textContaining('3,972', findRichText: true), findsWidgets);
      // 3 of their wins, 1 of yours — headToHead()'s own {wins}W{losses}L
      // order, theirs first.
      expect(find.text('3W 1L'), findsOneWidget);
      expect(find.text('31'), findsOneWidget);
      // 41 wins of 53 total, rounded.
      expect(find.text('77%'), findsOneWidget);
      expect(find.text('Challenge'), findsOneWidget);
      expect(find.text('View full profile'), findsOneWidget);
    });

    testWidgets('a stranger\'s peek leaves out the record against you', (
      tester,
    ) async {
      backend = _FakeBackend(_played());
      phone(tester);
      await tester.pumpWidget(_appWithPeekButton());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('3W 1L'), findsNothing);
      expect(find.text('31'), findsOneWidget);
      expect(find.text('77%'), findsOneWidget);
    });

    testWidgets('an unranked account reads unranked, not tier zero', (
      tester,
    ) async {
      backend = _FakeBackend(
        LifterProfile(
          id: 'x',
          username: 'newbie',
          tierIdx: 0,
          divIdx: 0,
          lp: 0,
          placementsDone: 0,
          totalReps: 40,
          bestSet: 8,
          wins: 0,
          losses: 0,
          winStreak: 0,
          isFriend: false,
          winsVsYou: 0,
          lossesVsYou: 0,
        ),
      );
      phone(tester);
      await tester.pumpWidget(_appWithPeekButton());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Unranked'), findsOneWidget);
    });

    testWidgets('view full profile opens the full screen', (tester) async {
      backend = _FakeBackend(_played(isFriend: true));
      phone(tester);
      await tester.pumpWidget(_appWithPeekButton());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('View full profile'));
      await tester.pumpAndSettle();

      expect(find.byType(OtherProfileScreen), findsOneWidget);
      expect(find.text('HEAD TO HEAD'), findsOneWidget);
    });
  });

  group('sample rows', () {
    Widget appWithSamplePeek(String username) => MaterialApp(
      theme: buildTheme(Brightness.dark),
      localizationsDelegates: const [
        L.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () => showLifterPeek(
                context,
                id: '',
                username: username,
                initial: demoLifterProfile(username),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    testWidgets('a sample friend opens a card with the record against you', (
      tester,
    ) async {
      phone(tester);
      await tester.pumpWidget(appWithSamplePeek('iron_mike'));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text("Couldn't load this profile"), findsNothing);
      expect(find.text('3W 1L'), findsOneWidget);
      expect(find.text('Challenge'), findsOneWidget);
    });

    testWidgets('a sample stranger opens a card without one', (tester) async {
      phone(tester);
      await tester.pumpWidget(appWithSamplePeek('cardio_hater'));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text("Couldn't load this profile"), findsNothing);
      expect(find.textContaining('W '), findsNothing);
      expect(find.text('View full profile'), findsOneWidget);
      // Nobody but a friend is challenged.
      expect(find.byKey(const Key('challengeLive')), findsNothing);
    });

    testWidgets('challenging a sample card says it needs a server', (
      tester,
    ) async {
      phone(tester);
      await tester.pumpWidget(appWithSamplePeek('iron_mike'));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Challenge'));
      await tester.pump();

      expect(find.text("Couldn't connect. Check your internet and try again."), findsOneWidget);
    });
  });

  group('full profile', () {
    testWidgets('shows the head-to-head, stat grid and last score', (
      tester,
    ) async {
      backend = _FakeBackend(_played(isFriend: true));
      phone(tester);
      await tester.pumpWidget(
        _appDirect(const OtherProfileScreen(id: 'ayaan99-id', username: 'ayaan99')),
      );
      await tester.pumpAndSettle();

      expect(find.text('HEAD TO HEAD'), findsOneWidget);
      expect(find.textContaining('Last time: 14–19'), findsWidgets);
      expect(find.textContaining('Your best against them is 16'), findsWidgets);
      expect(find.text('31'), findsOneWidget); // best set
      expect(find.text('3,140'), findsOneWidget); // total reps
      expect(find.text('22'), findsOneWidget); // win streak

      // A Row's default center cross-axis alignment gives a flexible child
      // only a loose height, and a childless ColoredBox collapses to zero
      // under a loose one — this shipped invisible once already.
      for (final el in find.byType(ColoredBox).evaluate()) {
        final box = el.renderObject as RenderBox;
        if (box.size.height < 20) {
          expect(box.size.height, greaterThan(0), reason: 'the head-to-head bar segment must not collapse to zero height');
        }
      }

    });

    testWidgets('an account already friends shows Friends, not Add friend', (
      tester,
    ) async {
      backend = _FakeBackend(_played(isFriend: true));
      phone(tester);
      await tester.pumpWidget(
        _appDirect(const OtherProfileScreen(id: 'ayaan99-id', username: 'ayaan99')),
      );
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.text('Friends'), findsOneWidget);
      expect(find.text('Add friend'), findsNothing);
    });

    testWidgets('nobody played yet says so instead of a fake 0-0', (
      tester,
    ) async {
      backend = _FakeBackend(_unplayed);
      phone(tester);
      await tester.pumpWidget(
        _appDirect(
          const OtherProfileScreen(id: 'newcomer-id', username: 'newcomer'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining("haven't raced newcomer yet"), findsOneWidget);
    });

    testWidgets('a stranger shows no head-to-head, only their own numbers', (
      tester,
    ) async {
      backend = _FakeBackend(_played());
      phone(tester);
      await tester.pumpWidget(
        _appDirect(const OtherProfileScreen(id: 'ayaan99-id', username: 'ayaan99')),
      );
      await tester.pumpAndSettle();

      expect(find.text('HEAD TO HEAD'), findsNothing);
      expect(find.textContaining('Last time: 14–19'), findsNothing);
      expect(find.text('31'), findsOneWidget); // best set
      expect(find.text('3,140'), findsOneWidget); // total reps

      // The buttons sit below the fold on a phone-sized viewport, so the
      // list has to be scrolled before a finder can see them at all.
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(find.text('Add friend'), findsOneWidget);
      // A stranger is asked to be a friend, not challenged: live is between
      // friends, and nothing else is offered.
      expect(find.byKey(const Key('challengeLive')), findsNothing);
      expect(find.text('Challenge'), findsNothing);
    });

    testWidgets('a friend is challenged live', (tester) async {
      backend = _FakeBackend(_played(isFriend: true));
      phone(tester);
      await tester.pumpWidget(
        _appDirect(const OtherProfileScreen(id: 'ayaan99-id', username: 'ayaan99')),
      );
      await tester.pumpAndSettle();
      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('challengeLive')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      // The invite screen, waiting on them — not a camera for a set.
      expect(find.byType(LiveInviteScreen), findsOneWidget);
    });

    for (final scale in [1.0, 1.3, 1.6]) {
      testWidgets('full profile lays out at ${scale}x text scale', (
        tester,
      ) async {
        backend = _FakeBackend(_played());
        phone(tester);
        await tester.pumpWidget(
          _appDirect(
            const OtherProfileScreen(id: 'ayaan99-id', username: 'ayaan99'),
            scale: scale,
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }

    for (final code in ['hi', 'de', 'ja']) {
      testWidgets('full profile lays out in $code', (tester) async {
        backend = _FakeBackend(_played());
        phone(tester);
        await tester.pumpWidget(
          _appDirect(
            const OtherProfileScreen(id: 'ayaan99-id', username: 'ayaan99'),
            scale: 1.3,
            locale: Locale(code),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('the more menu', () {
    testWidgets('lists share, mute, block and report', (tester) async {
      backend = _FakeBackend(_played());
      phone(tester);
      await tester.pumpWidget(
        _appDirect(
          const OtherProfileScreen(id: 'ayaan99-id', username: 'ayaan99'),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();

      expect(find.text('Share profile'), findsOneWidget);
      expect(find.text('Mute challenges from ayaan99'), findsOneWidget);
      expect(find.text('Block'), findsOneWidget);
      expect(
        find.text("They can't challenge you or see your profile"),
        findsOneWidget,
      );
      expect(find.text('Report'), findsOneWidget);
      expect(find.text('Reviewed within 24 hours'), findsOneWidget);
    });

    testWidgets('mute calls the backend and closes the sheet', (
      tester,
    ) async {
      final fake = _FakeBackend(_played());
      backend = fake;
      phone(tester);
      await tester.pumpWidget(
        _appDirect(
          const OtherProfileScreen(id: 'ayaan99-id', username: 'ayaan99'),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mute challenges from ayaan99'));
      await tester.pumpAndSettle();

      expect(fake.muteCalled, isTrue);
      expect(find.text('Muted ayaan99'), findsOneWidget);
    });

    testWidgets('a stranger has no Remove friend; a friend does, and it asks '
        'first', (tester) async {
      phone(tester);
      backend = _FakeBackend(_played());
      await tester.pumpWidget(
        _appDirect(
          const OtherProfileScreen(id: 'ayaan99-id', username: 'ayaan99'),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('removeFriend')), findsNothing);

      final fake = _FakeBackend(_played(isFriend: true));
      backend = fake;
      await tester.pumpWidget(const SizedBox());
      await tester.pumpWidget(
        _appDirect(
          const OtherProfileScreen(id: 'ayaan99-id', username: 'ayaan99'),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('removeFriend')));
      await tester.pumpAndSettle();

      // Not yet: one tap only asks.
      expect(find.text('Remove ayaan99 from your friends?'), findsOneWidget);
      expect(fake.removeCalled, isFalse);

      await tester.tap(find.byKey(const Key('confirmRemoveFriend')));
      await tester.pumpAndSettle();
      expect(fake.removeCalled, isTrue);
      expect(find.text('Removed ayaan99 from your friends'), findsOneWidget);
    });

    testWidgets('block calls the backend and closes the sheet', (
      tester,
    ) async {
      final fake = _FakeBackend(_played());
      backend = fake;
      phone(tester);
      await tester.pumpWidget(
        _appDirect(
          const OtherProfileScreen(id: 'ayaan99-id', username: 'ayaan99'),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Block'));
      await tester.pumpAndSettle();

      expect(fake.blockCalled, isTrue);
      expect(find.text('Blocked ayaan99'), findsOneWidget);
    });

    testWidgets('report opens the report screen for this account', (
      tester,
    ) async {
      backend = _FakeBackend(_played());
      phone(tester);
      await tester.pumpWidget(
        _appDirect(
          const OtherProfileScreen(id: 'ayaan99-id', username: 'ayaan99'),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Report'));
      await tester.pumpAndSettle();

      expect(find.byType(ReportScreen), findsOneWidget);
      expect(find.text('ayaan99'), findsWidgets);
    });

    testWidgets('cancel dismisses without calling anything', (tester) async {
      final fake = _FakeBackend(_played());
      backend = fake;
      phone(tester);
      await tester.pumpWidget(
        _appDirect(
          const OtherProfileScreen(id: 'ayaan99-id', username: 'ayaan99'),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(fake.muteCalled, isFalse);
      expect(fake.blockCalled, isFalse);
      expect(find.text('Cancel'), findsNothing);
    });
  });
}

Widget _appDirect(
  Widget home, {
  double scale = 1.0,
  Locale locale = const Locale('en'),
}) => MaterialApp(
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
