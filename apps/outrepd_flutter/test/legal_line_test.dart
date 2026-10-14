/// The Terms and the Privacy Policy, named under onboarding and sign-in, open
/// when they are tapped.
///
/// They were coloured like links and were plain text: tapping either did
/// nothing. The page itself cannot open in a test, so what is checked is
/// that each name answers a tap by trying to open it — here, with no browser
/// behind it, that try ends in the note saying the link could not open.
library;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/legal_line.dart';

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

/// The span in the line that says [text].
TextSpan _span(WidgetTester tester, String text) {
  final rich = tester.widget<RichText>(find.byType(RichText).first);
  TextSpan? found;
  rich.text.visitChildren((span) {
    if (span is TextSpan && span.text == text) found = span;
    return found == null;
  });
  return found!;
}

void main() {
  for (final name in ['Terms', 'Privacy Policy']) {
    testWidgets('$name answers a tap', (tester) async {
      await tester.pumpWidget(
        _app(const LegalLine(style: TextStyle(), linkStyle: TextStyle())),
      );
      expect(
        find.textContaining('By continuing you agree to the'),
        findsOneWidget,
      );

      final recognizer = _span(tester, name).recognizer;
      expect(recognizer, isA<TapGestureRecognizer>());
      (recognizer! as TapGestureRecognizer).onTap!();
      await tester.pumpAndSettle();
      expect(find.text('Could not open that link'), findsOneWidget);
    });
  }
}
