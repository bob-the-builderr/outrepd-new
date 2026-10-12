/// Where each notification leads.
///
/// The lifter whose set was raced hears about the duel from a notification,
/// and can share it from there — the same card the other lifter shares from
/// their result screen. A friend request leads to the requests, a yes to the
/// new friend.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/friends.dart';
import 'package:outrepd/screens/notifications.dart';
import 'package:outrepd/screens/other_profile.dart';
import 'package:outrepd/theme.dart';

class _Notices extends NoBackend {
  _Notices(this.list);

  final List<Notice> list;

  @override
  bool get available => true;

  @override
  Future<List<Notice>> notices() async => list;
}

Widget _app({Widget home = const NotificationsScreen()}) => MaterialApp(
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
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('a raced set opens its result card to share', (tester) async {
    phone(tester);
    backend = _Notices([
      Notice(
        id: '1',
        kind: NoticeKind.raced,
        at: DateTime.now(),
        unread: true,
        actorName: 'iron_mike',
        actorId: 'x',
        youWon: true,
        yourReps: 18,
        theirReps: 11,
      ),
    ]);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('iron_mike').first);
    await tester.pumpAndSettle();

    // The share sheet, with this duel on its card — not the profile card.
    expect(find.text('Story'), findsOneWidget);
    expect(find.text('Post'), findsOneWidget);
    expect(find.textContaining('18–11'), findsWidgets);
    expect(find.textContaining('iron_mike'), findsWidgets);
  });

  testWidgets('a friend request goes back, asking for the requests',
      (tester) async {
    // Answered on the Friends tab, which is under the list: the list closes
    // and says so, and openNotifications takes it from there.
    phone(tester);
    backend = _Notices([
      Notice(
        id: '2',
        kind: NoticeKind.friendRequest,
        at: DateTime.now(),
        unread: true,
        actorName: 'squat_queen',
        actorId: 'q',
      ),
    ]);
    NoticeExit? exit;
    await tester.pumpWidget(_app(
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () async => exit = await Navigator.of(context).push(
            MaterialPageRoute<NoticeExit>(
              builder: (_) => const NotificationsScreen(),
            ),
          ),
          child: const Text('open'),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('squat_queen').first);
    await tester.pumpAndSettle();
    expect(find.byType(NotificationsScreen), findsNothing);
    expect(exit, NoticeExit.friendRequests);
  });

  testWidgets('the Friends tab opens its requests when asked from outside',
      (tester) async {
    phone(tester);
    backend = _Notices(const []);
    await tester.pumpWidget(_app(home: const FriendsScreen()));
    await tester.pumpAndSettle();
    // The sheet, not its title: the tab's own row is called the same.
    expect(find.byType(BottomSheet), findsNothing);

    FriendsScreen.showRequests();
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.text('Incoming requests'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('a yes opens the new friend', (tester) async {
    phone(tester);
    backend = _Notices([
      Notice(
        id: '3',
        kind: NoticeKind.friendAccepted,
        at: DateTime.now(),
        unread: true,
        actorName: 'squat_queen',
        actorId: 'q',
      ),
    ]);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('squat_queen').first);
    await tester.pumpAndSettle();
    final profile =
        tester.widget<OtherProfileScreen>(find.byType(OtherProfileScreen));
    expect(profile.id, 'q');
    expect(profile.username, 'squat_queen');
  });

  testWidgets('an arrow on each notice that opens something, and no other',
      (tester) async {
    phone(tester);
    backend = _Notices([
      Notice(
        id: '5',
        kind: NoticeKind.friendAccepted,
        at: DateTime.now(),
        unread: true,
        actorName: 'squat_queen',
        actorId: 'q',
      ),
      // The account is gone: nothing to open, so nothing pointing at it.
      Notice(
        id: '6',
        kind: NoticeKind.friendAccepted,
        at: DateTime.now(),
        unread: false,
        actorName: 'gone_lifter',
      ),
    ]);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('noticeOpens')), findsOneWidget);
    expect(
      find.descendant(
        of: find.ancestor(
          of: find.textContaining('gone_lifter'),
          matching: find.byType(Row),
        ),
        matching: find.byKey(const Key('noticeOpens')),
      ),
      findsNothing,
    );
  });

  testWidgets('an older result with no score opens the opponent',
      (tester) async {
    phone(tester);
    backend = _Notices([
      Notice(
        id: '4',
        kind: NoticeKind.raced,
        at: DateTime.now(),
        unread: false,
        actorName: 'iron_mike',
        actorId: 'x',
      ),
    ]);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('iron_mike').first);
    await tester.pumpAndSettle();
    expect(find.byType(OtherProfileScreen), findsOneWidget);
  });
}
