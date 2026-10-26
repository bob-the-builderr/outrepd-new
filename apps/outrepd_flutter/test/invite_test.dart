/// A friend's code: typed at sign-up, and offered on the Friends tab only to
/// a yearly subscriber.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/auth_entry.dart';
import 'package:outrepd/screens/friends.dart';
import 'package:outrepd/theme.dart';

class _Server extends NoBackend {
  _Server({this.claim = InviteResult.claimed, this.invites});

  final InviteResult claim;
  final MyInvites? invites;
  final claimed = <String>[];
  int codesSent = 0;

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
  Future<RenameResult> renameUsername(String username) async =>
      RenameResult.ok;

  @override
  Future<EmailSignUpResult> startEmailSignUp({required String email}) async {
    codesSent++;
    return EmailSignUpResult.ok;
  }

  @override
  Future<InviteResult> claimInvite(String code) async {
    claimed.add(code);
    return claim;
  }

  @override
  Future<MyInvites?> myInvites() async => invites;

  @override
  Future<List<RemoteFriend>> friends() async => const [];

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

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  Future<void> fillIn(WidgetTester tester, {String code = ''}) async {
    await tester.enterText(
      find.byKey(const Key('signUpEmail')),
      'one@example.com',
    );
    if (code.isNotEmpty) {
      // The code's field opens from its line; most people have none.
      await tester.tap(find.byKey(const Key('showInviteCode')));
      await tester.pump();
      await tester.enterText(find.byKey(const Key('inviteCode')), code);
    }
    await tester.pump();
  }

  testWidgets('a wrong code is caught before the email code goes out', (
    tester,
  ) async {
    phone(tester);
    final server = _Server(claim: InviteResult.notYearly);
    backend = server;
    await tester.pumpWidget(_app(const SignUpScreen()));
    await fillIn(tester, code: '#111111');
    await tester.tap(find.text('Create account'));
    await tester.pump();

    expect(server.claimed, ['#111111']);
    expect(server.codesSent, 0);
    expect(find.text("That code can't give free days right now"), findsOneWidget);
  });

  testWidgets('a good code says so, and sign-up goes on', (tester) async {
    phone(tester);
    final server = _Server();
    backend = server;
    await tester.pumpWidget(_app(const SignUpScreen()));
    await fillIn(tester, code: '482000');
    await tester.tap(find.text('Create account'));
    await tester.pump();

    expect(server.codesSent, 1);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('no code, no claim', (tester) async {
    phone(tester);
    final server = _Server();
    backend = server;
    await tester.pumpWidget(_app(const SignUpScreen()));
    await fillIn(tester);
    await tester.tap(find.text('Create account'));
    await tester.pump();

    expect(server.claimed, isEmpty);
    expect(server.codesSent, 1);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('the Friends tab offers the code only on the yearly plan', (
    tester,
  ) async {
    phone(tester);
    backend = _Server(invites: const MyInvites(canInvite: true, joined: 2));
    await tester.pumpWidget(_app(const FriendsScreen()));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('inviteCard')), findsOneWidget);
    expect(find.text('#482913'), findsOneWidget);
    expect(find.text('2 joined'), findsOneWidget);

    backend = _Server(invites: const MyInvites(canInvite: false, joined: 0));
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(_app(const FriendsScreen()));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('inviteCard')), findsNothing);
  });
}
