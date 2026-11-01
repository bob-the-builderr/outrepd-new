/// The lifter maker: a Pro part can be put on and looked at, with a quiet
/// way to Pro, but Done keeps only what the account has; a locked earned
/// part says what earns it; at sign-up Skip leaves the name's lifter.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/lifter/catalog.dart';
import 'package:outrepd/lifter/my_lifter.dart';
import 'package:outrepd/screens/lifter_maker.dart';
import 'package:outrepd/theme.dart';

Widget _app({bool firstTime = false}) => MaterialApp(
  theme: buildTheme(Brightness.dark),
  locale: const Locale('en'),
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
        child: TextButton(
          onPressed: () => openLifterMaker(context, firstTime: firstTime),
          child: const Text('open'),
        ),
      ),
    ),
  ),
);

Future<void> _open(WidgetTester tester, {bool firstTime = false}) async {
  tester.view.physicalSize = const Size(1179, 2556);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_app(firstTime: firstTime));
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await MyLifter.instance.forget();
  });

  testWidgets('a Pro skin is tried on, and Done keeps what the account has', (tester) async {
    await _open(tester);
    expect(find.text('Your lifter'), findsOneWidget);

    await tester.scrollUntilVisible(find.byKey(const Key('part_neon')), 200,
        scrollable: find.byType(Scrollable).last);
    await tester.tap(find.byKey(const Key('part_neon')));
    await tester.pump();
    expect(find.byKey(const Key('makerUnlockPro')), findsOneWidget);
    expect(find.text('Unlock with Pro'), findsOneWidget);

    await tester.tap(find.byKey(const Key('makerDone')));
    await tester.pumpAndSettle();
    final saved = MyLifter.instance.built;
    expect(saved, isNotNull);
    expect(kSkins[saved!.skin].pro, isFalse);
    expect(MyLifter.instance.isPicture, isTrue);
  });

  testWidgets('a free part is worn, and saved', (tester) async {
    await _open(tester);
    await tester.tap(find.byKey(const Key('part_ebony')));
    await tester.pump();
    expect(find.byKey(const Key('makerUnlockPro')), findsNothing);

    await tester.tap(find.byKey(const Key('makerDone')));
    await tester.pumpAndSettle();
    expect(kSkins[MyLifter.instance.built!.skin].id, 'ebony');
  });

  testWidgets('a locked earned part says what earns it', (tester) async {
    await _open(tester);
    await tester.scrollUntilVisible(find.byKey(const Key('part_stone')), 200,
        scrollable: find.byType(Scrollable).last);
    await tester.tap(find.byKey(const Key('part_stone')));
    await tester.pump();
    expect(find.text('Clear Iron Mines'), findsOneWidget);
  });

  testWidgets('every tab opens', (tester) async {
    await _open(tester);
    for (final tab in ['skin', 'hair', 'face', 'beard', 'top', 'gear', 'background']) {
      await tester.ensureVisible(find.byKey(Key('makerTab_$tab')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('makerTab_$tab')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: tab);
    }
    expect(find.text('Eyes'), findsNothing);
    await tester.ensureVisible(find.byKey(const Key('makerTab_face')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('makerTab_face')));
    await tester.pumpAndSettle();
    expect(find.text('Eyes'), findsOneWidget);
  });

  testWidgets('at sign-up, Skip leaves the lifter the name gives', (tester) async {
    await _open(tester, firstTime: true);
    expect(find.text('Make your lifter'), findsOneWidget);
    expect(find.text('This is you on every board and in every match.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('makerSkip')));
    await tester.pumpAndSettle();
    expect(MyLifter.instance.built, isNull);
    expect(MyLifter.instance.asked, isTrue);
    expect(find.text('open'), findsOneWidget);
  });
}
