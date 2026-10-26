/// The username as it is typed: spaces become underscores, and what is wrong
/// is said in red the moment it is, on the sign-up screen too.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/auth_entry.dart';
import 'package:outrepd/theme.dart';
import 'package:outrepd/username_rules.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  TextEditingValue typed(String text) => usernameFormatters.fold(
    TextEditingValue(text: text),
    (value, f) => f.formatEditUpdate(TextEditingValue.empty, value),
  );

  test('spaces become underscores, and the name stops at twenty', () {
    expect(typed('iron mike').text, 'iron_mike');
    expect(typed('a' * 30).text, hasLength(kUsernameMax));
  });

  test('the rule is the server\'s', () {
    expect(usernameValid('iron_mike'), isTrue);
    expect(usernameValid('abc'), isFalse);
    expect(usernameValid('____'), isFalse);
    expect(usernameValid('mo#ktar'), isFalse);
    expect(usernameValid('a' * 21), isFalse);
  });

  test('a name chosen is kept fourteen days', () {
    final now = DateTime(2026, 10, 19);
    expect(usernameNextChange(null, now: now), isNull);
    expect(
      usernameNextChange(DateTime(2026, 10, 10), now: now),
      DateTime(2026, 10, 24),
    );
    expect(usernameNextChange(DateTime(2026, 10, 1), now: now), isNull);
  });

  testWidgets('sign-up says what is wrong with the name as it is typed', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(Brightness.dark),
        locale: const Locale('en'),
        localizationsDelegates: const [
          L.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L.supportedLocales,
        home: const ChooseUsernameScreen(),
      ),
    );
    await tester.pumpAndSettle();
    final field = find.descendant(
      of: find.byKey(const Key('signUpUsername')),
      matching: find.byType(TextField),
    );

    await tester.enterText(field, 'mo');
    await tester.pump();
    expect(find.text('Too short: at least 4 characters'), findsOneWidget);

    await tester.enterText(field, 'mo#ktar');
    await tester.pump();
    expect(find.text('Only letters, numbers and _'), findsOneWidget);

    await tester.enterText(field, 'iron mike');
    await tester.pump();
    expect(find.text('iron_mike'), findsOneWidget);
    expect(find.text('Only letters, numbers and _'), findsNothing);
    expect(find.text('Too short: at least 4 characters'), findsNothing);
  });
}
