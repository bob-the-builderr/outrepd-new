/// Signing in or up with no connection.
///
/// The failure this guards against: a network error came back as "no account
/// with that email", and somebody who already had an account was told it did
/// not exist.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/auth_entry.dart';
import 'package:outrepd/theme.dart';

class _OfflineBackend extends NoBackend {
  @override
  bool get available => true;

  @override
  Future<RenameResult> renameUsername(String name) async => RenameResult.ok;

  @override
  Future<EmailLoginCodeResult> requestLoginCode(String email) async =>
      EmailLoginCodeResult.offline;

  @override
  Future<EmailSignUpResult> startEmailSignUp({required String email}) async =>
      EmailSignUpResult.offline;
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

const _cantReach =
    "Couldn't reach the server. Check your connection and try again.";

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    backend = _OfflineBackend();
  });
  tearDown(() => backend = const NoBackend());

  testWidgets('logging in offline says so, not that the account is missing', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const LoginScreen()));
    await tester.enterText(find.byType(TextField), 'me@example.com');
    await tester.pump();
    await tester.tap(find.text('Send code'));
    await tester.pumpAndSettle();

    expect(find.text(_cantReach), findsOneWidget);
    expect(
      find.text("We couldn't find an account with that email."),
      findsNothing,
    );
  });

  testWidgets('signing up offline says so, not that the email is invalid', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const SignUpScreen()));
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'mokhtar');
    await tester.enterText(fields.at(1), 'me@example.com');
    await tester.pump();
    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.text(_cantReach), findsOneWidget);
  });
}
