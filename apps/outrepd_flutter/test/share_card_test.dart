/// The share card: both shapes, the sheet that previews them, and the
/// copy-link fallback.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/share_card.dart';
import 'package:outrepd/theme.dart';

const _data = ShareCardData(
  username: 'mokhtar_y',
  tierIdx: 4,
  divIdx: 3,
  lp: 40,
  wins: 62,
  losses: 18,
  bestSet: 47,
  winStreak: 6,
  globalPlace: 412,
  country: 'EG',
  countryPlace: 6,
);

Widget _appWithShareButton({double scale = 1.0, Locale locale = const Locale('en')}) =>
    MaterialApp(
      theme: buildTheme(Brightness.dark),
      locale: locale,
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
      home: Scaffold(
        body: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () => showShareCardSheet(context, data: _data),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

void main() {
  const small = Size(360, 640);

  void phone(WidgetTester tester) {
    tester.view.physicalSize = small;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  testWidgets('opens on the story card, with the record and best set', (
    tester,
  ) async {
    phone(tester);
    await tester.pumpWidget(_appWithShareButton());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('mokhtar_y'), findsWidgets);
    expect(find.text('62–18'), findsWidgets);
    expect(find.text('47'), findsWidgets);
    expect(find.text('Story'), findsOneWidget);
    expect(find.text('Post'), findsOneWidget);
    // The cards and the copy-link row point at the site. They used to carry
    // outrepd.com/u/<name>, a page that does not exist.
    expect(find.text('outrepd.com'), findsWidgets);
    expect(find.textContaining('/u/'), findsNothing);
  });

  testWidgets('switching to Post keeps showing the same data', (
    tester,
  ) async {
    phone(tester);
    await tester.pumpWidget(_appWithShareButton());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Post'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    expect(find.text('mokhtar_y'), findsWidgets);
    expect(find.text('62–18'), findsWidgets);
  });

  testWidgets('copy link confirms with a snackbar', (tester) async {
    phone(tester);
    await tester.pumpWidget(_appWithShareButton());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Not pumpAndSettle: Clipboard.getData has no test default the way
    // setData does, and reading it back here once hung the whole suite
    // rather than failing. The snackbar is the outcome that actually
    // matters to somebody using the button.
    await tester.tap(find.text('Copy'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Link copied'), findsOneWidget);
  });

  // Actually tapping Share reaches SharePlus's real platform channel, which
  // has no listener under `flutter test` and hangs rather than failing —
  // not something to test here, and not this code's own behaviour to prove.
  // The image capture and hand-off are exercised on a real device instead.

  for (final scale in [1.0, 1.3, 1.6]) {
    testWidgets('share sheet lays out at ${scale}x text scale', (
      tester,
    ) async {
      phone(tester);
      await tester.pumpWidget(_appWithShareButton(scale: scale));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Post'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  for (final code in [
    'de', 'es', 'fr', 'hi', 'id', 'it', 'ja', 'ko', 'pt', 'ru', 'tr', 'zh',
  ]) {
    testWidgets('share sheet lays out in $code', (tester) async {
      phone(tester);
      await tester.pumpWidget(_appWithShareButton(locale: Locale(code)));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('an unranked account shows no tier badge crash', (
    tester,
  ) async {
    phone(tester);
    const unranked = ShareCardData(
      username: 'newbie',
      tierIdx: 0,
      divIdx: 4,
      lp: 0,
      wins: 0,
      losses: 0,
      bestSet: 0,
      winStreak: 0,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(Brightness.dark),
        localizationsDelegates: const [
          L.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () =>
                    showShareCardSheet(context, data: unranked),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('newbie'), findsWidgets);
  });
}
