/// Screenshots of the way in, as an iPhone draws it: the entry screen with
/// Apple and Google, signing up with an email, and logging in. See shots.dart
/// for how these are run and published.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/auth_entry.dart';
import 'package:outrepd/screens/social_sign_in.dart';
import 'package:outrepd/theme.dart';

Future<void> _font(String family, String path) async {
  final file = File(path);
  if (!file.existsSync()) return;
  final bytes = file.readAsBytesSync();
  final loader = FontLoader(family)
    ..addFont(Future.value(ByteData.view(bytes.buffer)));
  await loader.load();
}

Widget _app(Widget home) => MaterialApp(
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
  home: home,
);

void main() {
  setUpAll(() async {
    final fonts = Platform.environment['SHOT_FONTS'] ?? 'tool/screenshots/fonts';
    await _font('Roboto', '$fonts/NotoSans.ttf');
    await _font('FlutterTest', '$fonts/NotoSans.ttf');
    final root = Platform.environment['FLUTTER_ROOT'];
    if (root != null) {
      await _font(
        'MaterialIcons',
        '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
      );
    }
  });

  final screens = <String, Widget>{
    'sign_in_entry': const AuthEntryScreen(),
    'sign_in_choose_name': const ChooseUsernameScreen(),
  };

  for (final MapEntry(key: name, value: screen) in screens.entries) {
    testWidgets(name, (tester) async {
      // An iPhone 15's screen, with both buttons. The platform stays
      // Android's: on iOS the theme asks for Apple's own font, which the
      // test engine does not have, and every letter came out a box.
      tester.view.physicalSize = const Size(393 * 3, 852 * 3);
      tester.view.devicePixelRatio = 3;
      tester.view.padding = const FakeViewPadding(top: 59 * 3, bottom: 34 * 3);
      addTearDown(tester.view.reset);
      debugOfferAllSocialSignIn = true;

      await tester.pumpWidget(_app(screen));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/$name.png'),
      );

      debugOfferAllSocialSignIn = false;
    });
  }
}
