/// A friend's code. It was typed at the email sign-up, and the yearly plan's
/// card on the Friends tab told people to type it there; since that sign-up
/// went (2026-10-27) there is nowhere to type one, so the card does not offer
/// it any more — the Friends tab has the same "Bring a friend" for everyone.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/friends.dart';
import 'package:outrepd/theme.dart';

class _Server extends NoBackend {
  _Server({this.invites});

  final MyInvites? invites;

  @override
  bool get available => true;

  @override
  RemoteProfile? get me => const RemoteProfile(
    id: 'me',
    username: 'mokhtar',
    tierIdx: 2,
    divIdx: 2,
    lp: 10,
    friendCode: '482913',
  );

  @override
  Future<MyInvites?> myInvites() async => invites;

  /// One friend, so the list is drawn rather than the empty state.
  @override
  Future<List<RemoteFriend>> friends() async => [
    RemoteFriend(
      id: 'karim-id',
      username: 'karimfit',
      tierIdx: 3,
      divIdx: 2,
      lp: 40,
      placementsDone: 5,
      lastSeen: DateTime.now().subtract(const Duration(days: 2)),
      winsVsYou: 1,
      lossesVsYou: 2,
    ),
  ];

  @override
  Future<List<FriendRequest>> friendRequests() async => const [];
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

  testWidgets('no code to give, even on the yearly plan: a friend is brought '
      'the same way by everyone', (tester) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    backend = _Server(invites: const MyInvites(canInvite: true, joined: 2));
    await tester.pumpWidget(_app(const FriendsScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('inviteCard')), findsNothing);
    await tester.scrollUntilVisible(
      find.byKey(const Key('bringFriendCard')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(const Key('bringFriendCard')), findsOneWidget);
  });
}
