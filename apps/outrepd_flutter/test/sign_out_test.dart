/// Signing out: offered only where there is a way back in, asked before it
/// happens, and it leaves the phone where a fresh install starts — as does
/// deleting the account.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/onboarding.dart';
import 'package:outrepd/screens/settings.dart';
import 'package:outrepd/screens/settings_account.dart';
import 'package:outrepd/theme.dart';

/// An account with an email on it, on a server that is not really there.
class _SignedIn extends NoBackend {
  bool signedIn = true;
  int signOuts = 0;
  int newSessions = 0;
  int deletes = 0;

  @override
  bool get hasRealAccount => signedIn;

  @override
  String? get accountEmail => signedIn ? 'lifter@example.com' : null;

  @override
  Future<void> signOut() async {
    signOuts++;
    signedIn = false;
  }

  @override
  Future<void> deleteAccount() async {
    deletes++;
    signedIn = false;
  }

  @override
  Future<RemoteProfile> signIn({required String username}) async {
    newSessions++;
    throw StateError('no server in a test');
  }
}

Widget _app({Widget home = const SettingsScreen()}) => MaterialApp(
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
  setUp(() => SharedPreferences.setMockInitialValues({'onboarded': true}));
  tearDown(() => backend = const NoBackend());

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('an account with no email is not offered a sign-out',
      (tester) async {
    // Signing out of it would be losing it: there is nothing to sign back in
    // with.
    phone(tester);
    backend = const NoBackend();
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('signOut')), findsNothing);
  });

  testWidgets('changing your mind leaves you signed in', (tester) async {
    phone(tester);
    final fake = _SignedIn();
    backend = fake;
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('signOut')));
    await tester.pumpAndSettle();
    expect(find.text('Sign out?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(fake.signOuts, 0);
    expect(find.byType(SettingsScreen), findsOneWidget);
  });

  testWidgets('signing out lands on the welcome screen, like a fresh install',
      (tester) async {
    phone(tester);
    final fake = _SignedIn();
    backend = fake;
    onboarded = true;
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('signOut')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('confirmSignOut')));
    await tester.pumpAndSettle();

    expect(fake.signOuts, 1);
    // A new session is asked for, so signing up again works — and a server
    // that does not answer does not stop the sign-out.
    expect(fake.newSessions, 1);
    expect(onboarded, isFalse);
    final stored = await SharedPreferences.getInstance();
    expect(stored.getBool('onboarded'), isFalse);
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.byType(SettingsScreen), findsNothing);
  });

  testWidgets('deleting the account lands on the welcome screen too, not '
      'inside with no account', (tester) async {
    // It used to go back to the home screen still marked as set up, and the
    // next launch opened the paywall to a guest session with no email.
    phone(tester);
    final fake = _SignedIn();
    backend = fake;
    onboarded = true;
    await tester.pumpWidget(_app(home: const DeleteAccountScreen()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'DELETE');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete permanently'));
    await tester.pumpAndSettle();
    // And once more in the dialog that asks.
    await tester.tap(find.text('Delete permanently').last);
    await tester.pumpAndSettle();

    expect(fake.deletes, 1);
    expect(fake.newSessions, 1);
    expect(onboarded, isFalse);
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.byType(DeleteAccountScreen), findsNothing);
  });
}
