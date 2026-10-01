/// The screenshot App Review asks for beside each subscription: the paywall
/// as an iPhone shows it — Apple's wording, at the 6.9" size — with
/// the two plans at the prices set in App Store Connect. See shots.dart for
/// how these are run and published.
library;

import 'dart:io';

import 'package:flutter/foundation.dart';
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

Future<void> _font(String family, List<String> paths) async {
  final loader = FontLoader(family);
  var any = false;
  for (final path in paths) {
    final file = File(path);
    if (!file.existsSync()) continue;
    final bytes = file.readAsBytesSync();
    loader.addFont(Future.value(ByteData.view(bytes.buffer)));
    any = true;
  }
  if (any) await loader.load();
}

void main() {
  setUpAll(() async {
    final fonts = Platform.environment['SHOT_FONTS'] ?? 'tool/screenshots/fonts';
    final roboto = [
      for (final w in ['Regular', 'Medium', 'Bold']) '$fonts/Roboto-$w.ttf',
    ];
    final face = File(roboto.first).existsSync()
        ? roboto
        : ['$fonts/NotoSans.ttf'];
    // Every name an iPhone's text asks the engine for, plus the test
    // engine's own fallback — the one a style with no family at all gets,
    // which otherwise draws every letter as a box.
    for (final family in [
      'Roboto',
      'FlutterTest',
      'CupertinoSystemText',
      'CupertinoSystemDisplay',
      '.SF Pro Text',
      '.SF Pro Display',
      '.SF UI Text',
      '.SF UI Display',
    ]) {
      await _font(family, face);
    }
    final root = Platform.environment['FLUTTER_ROOT'];
    if (root != null) {
      await _font('MaterialIcons', [
        '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
      ]);
    }
  });

  tearDown(() => Subscription.instance.use(null));

  testWidgets('app review paywall 1320x2868', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    tester.view.physicalSize = const Size(1320, 2868);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    Subscription.instance.use(_Store());

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildTheme(Brightness.dark),
        locale: const Locale('en'),
        localizationsDelegates: const [
          L.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L.supportedLocales,
        home: const PaywallGate(child: SizedBox()),
      ),
    );
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    // Apple's wording, not Google Play's.
    expect(find.textContaining('Apple account'), findsWidgets);

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/app_review_paywall_1320x2868.png'),
    );
  });
}
