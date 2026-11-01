/// Screenshots of the paywall, for looking at rather than for asserting.
///
/// Not part of `flutter test` (they live outside test/). CI runs the
/// `*_test.dart` files here with `--update-goldens`, which writes the PNGs to
/// `goldens/`, and publishes them with the test results — the way to see a
/// screen when no machine with Flutter on it is to hand.
///
/// Each language is its own file because fonts are loaded once per test
/// process, and each file gets its own. Real fonts are loaded when they are
/// there — `SHOT_FONTS` for the text, the Flutter SDK's own icon font —
/// because the test engine otherwise draws every glyph as a box.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/paywall.dart';
import 'package:outrepd/subscription.dart';
import 'package:outrepd/theme.dart';

class _Store implements Storefront {
  @override
  Future<bool> start(String? userId) async => false;
  @override
  Future<bool> identify(String userId) async => false;
  @override
  Future<bool> check() async => false;
  @override
  Future<bool> checkFresh() async => false;
  @override
  Future<List<Plan>> plans() async => const [
        Plan(
          period: PlanPeriod.weekly,
          price: 4.99,
          priceString: r'$4.99',
          currencyCode: 'USD',
        ),
        Plan(
          period: PlanPeriod.yearly,
          price: 39.99,
          priceString: r'$39.99',
          currencyCode: 'USD',
          pricePerWeekString: r'$0.77',
        ),
      ];
  @override
  Future<({BuyOutcome outcome, bool active})> buy(Plan plan) async =>
      (outcome: BuyOutcome.cancelled, active: false);
  @override
  Future<bool> restore() async => false;
  @override
  void onChange(void Function(bool active) listener) {}
  @override
  Future<void> forget() async {}
}

Future<void> _font(String family, String path) async {
  final file = File(path);
  if (!file.existsSync()) return;
  final bytes = file.readAsBytesSync();
  final loader = FontLoader(family)
    ..addFont(Future.value(ByteData.view(bytes.buffer)));
  await loader.load();
}

/// Screenshots of the paywall in [locale], drawn with [fontFile] from
/// `SHOT_FONTS`, on a small phone and a tall one.
void paywallShots(String locale, String fontFile) {
  setUpAll(() async {
    final fonts = Platform.environment['SHOT_FONTS'] ?? 'tool/screenshots/fonts';
    // The theme names no font, so on Android it asks for Roboto — and a
    // style that sets no family at all (the button theme's) gets the test
    // engine's own, which draws boxes unless it is replaced too.
    await _font('Roboto', '$fonts/$fontFile');
    await _font('FlutterTest', '$fonts/$fontFile');
    final root = Platform.environment['FLUTTER_ROOT'];
    if (root != null) {
      await _font(
        'MaterialIcons',
        '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
      );
    }
  });

  tearDown(() => Subscription.instance.use(null));

  for (final (name, size) in [
    ('small', const Size(360, 720)),
    ('tall', const Size(412, 915)),
  ]) {
    testWidgets('paywall $locale $name', (tester) async {
      tester.view.physicalSize = size * 2;
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      final store = _Store();
      Subscription.instance.use(store);

      await tester.pumpWidget(
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: buildTheme(Brightness.dark),
          locale: Locale(locale),
          localizationsDelegates: const [
            L.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: L.supportedLocales,
          // Pro as it opens over the app.
          home: PaywallScreen(store: store, onUnlocked: (_) {}),
        ),
      );
      for (var i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/paywall_${locale}_$name.png'),
      );
    });
  }
}
