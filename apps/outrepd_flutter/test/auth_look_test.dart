/// The entry and sign-up screens as redesigned (layout A): the badge hero,
/// Apple first on an iPhone, and the sign-up form with its invite code
/// behind a line — on a small phone and at a large text size.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/auth_entry.dart';
import 'package:outrepd/screens/social_sign_in.dart';
import 'package:outrepd/theme.dart';

Widget _app(Widget home, {double scale = 1.0}) => MaterialApp(
  theme: buildTheme(Brightness.dark),
  locale: const Locale('en'),
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

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  void smallPhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(375, 667);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  for (final scale in [1.0, 1.3]) {
    testWidgets('the entry screen fits a small iPhone at ${scale}x', (
      tester,
    ) async {
      smallPhone(tester);
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      await tester.pumpWidget(_app(const AuthEntryScreen(), scale: scale));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('authHeroTitle')), findsOneWidget);
      expect(find.byKey(const Key('continueWithApple')), findsOneWidget);
      expect(find.text('Sign up with email'), findsOneWidget);
      expect(tester.takeException(), isNull);
      debugDefaultTargetPlatformOverride = null;
    });
  }

  testWidgets('the invite code opens from its line', (tester) async {
    smallPhone(tester);
    await tester.pumpWidget(_app(const SignUpScreen()));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('inviteCode')), findsNothing);
    // The email alone: the name is chosen after it is confirmed.
    expect(find.byKey(const Key('signUpEmail')), findsOneWidget);
    expect(find.text('Spaces become _'), findsNothing);
    await tester.tap(find.byKey(const Key('showInviteCode')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('inviteCode')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('log in: email is a button to its own page', (tester) async {
    smallPhone(tester);
    debugOfferAllSocialSignIn = true;
    addTearDown(() => debugOfferAllSocialSignIn = false);
    await tester.pumpWidget(_app(const LoginScreen()));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsNothing);
    await tester.tap(find.byKey(const Key('continueWithEmail')));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Send code'), findsOneWidget);
  });

  testWidgets('the sign-up form fits at 1.3x', (tester) async {
    smallPhone(tester);
    await tester.pumpWidget(_app(const SignUpScreen(), scale: 1.3));
    await tester.pumpAndSettle();
    expect(find.text('Create account'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
