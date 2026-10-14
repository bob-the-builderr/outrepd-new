/// The Terms and the Privacy Policy, named under onboarding and sign-in, open
/// when they are tapped.
///
/// They were coloured like links and were plain text: tapping either did
/// nothing. A test has no browser, so the opener is swapped for one that
/// writes down what it was asked to open.
library;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/legal_line.dart';
import 'package:outrepd/screens/paywall.dart' show kPrivacyUrl, kTermsUrl;

Widget _app(Widget child) => MaterialApp(
  locale: const Locale('en'),
  localizationsDelegates: const [
    L.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: L.supportedLocales,
  home: Scaffold(body: Center(child: child)),
);

/// Taps the span in the line that says [text], as a finger on it would.
void _tapSpan(WidgetTester tester, String text) {
  final rich = tester.widget<RichText>(find.byType(RichText).first);
  TextSpan? found;
  rich.text.visitChildren((span) {
    if (span is TextSpan && span.text == text) found = span;
    return found == null;
  });
  final recognizer = found!.recognizer;
  expect(recognizer, isA<TapGestureRecognizer>(), reason: '$text is not a link');
  (recognizer! as TapGestureRecognizer).onTap!();
}

void main() {
  final opened = <String>[];
  var answers = true;
  final browser = openInBrowser;

  setUp(() {
    opened.clear();
    answers = true;
    openInBrowser = (url) async {
      opened.add(url.toString());
      return answers;
    };
  });
  tearDown(() => openInBrowser = browser);

  const line = LegalLine(style: TextStyle(), linkStyle: TextStyle());

  for (final (name, url) in [('Terms', kTermsUrl), ('Privacy Policy', kPrivacyUrl)]) {
    testWidgets('$name opens its page', (tester) async {
      await tester.pumpWidget(_app(line));
      expect(
        find.textContaining('By continuing you agree to the'),
        findsOneWidget,
      );
      _tapSpan(tester, name);
      await tester.pumpAndSettle();
      expect(opened, [url]);
      expect(find.text('Could not open that link'), findsNothing);
    });
  }

  testWidgets('a page that cannot open says so', (tester) async {
    answers = false;
    await tester.pumpWidget(_app(line));
    _tapSpan(tester, 'Terms');
    await tester.pumpAndSettle();
    expect(find.text('Could not open that link'), findsOneWidget);
  });
}
