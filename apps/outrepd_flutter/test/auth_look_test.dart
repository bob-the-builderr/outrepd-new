/// The entry screen as it is since the email way in went (2026-10-27): the
/// badge hero, and Apple and Google as the only ways in — on a small phone
/// and at a large text size.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/auth_entry.dart';
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
      // No email way in, and nothing that leads to one.
      expect(find.text('Sign up with email'), findsNothing);
      expect(find.textContaining('Log in'), findsNothing);
      expect(find.byType(TextField), findsNothing);
      expect(tester.takeException(), isNull);
      debugDefaultTargetPlatformOverride = null;
    });
  }
}
