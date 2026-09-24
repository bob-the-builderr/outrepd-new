/// The friends screen: layout at real text sizes, and the search actually
/// searching.
///
/// A friend row packs an avatar, a username, a rank, a head-to-head record and
/// a button into one line on a phone. It is the densest row in the app, so it
/// is the one most likely to overflow once somebody turns their type up or
/// switches to a language that writes "Never played you" in six words.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/friends.dart';
import 'package:outrepd/theme.dart';

Widget _app(double scale, Locale locale) => MaterialApp(
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
      home: const FriendsScreen(),
    );

void main() {
  const small = Size(360, 640);

  void phone(WidgetTester tester) {
    tester.view.physicalSize = small;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  for (final scale in [1.0, 1.3, 1.6]) {
    testWidgets('friends lays out at ${scale}x text scale', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(scale, const Locale('en')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  // Every language this app ships in, at a scale that has broken rows before.
  for (final code in ['ar', 'de', 'ja', 'ru', 'tr']) {
    testWidgets('friends lays out in $code', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(1.3, Locale(code)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('every friend shows a rank and a record', (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(1.0, const Locale('en')));
    await tester.pumpAndSettle();

    // The record is the reason to tap a row, so it is not allowed to go
    // missing behind an ellipsis or a null.
    expect(find.textContaining('3W 1L vs you'), findsOneWidget);
    expect(find.textContaining('0W 4L vs you'), findsOneWidget);

    // Somebody you have never faced says so rather than showing 0W 0L.
    final untested = demoFriends.firstWhere((f) => !f.hasPlayedYou);
    expect(find.textContaining('Never played you'), findsOneWidget);
    expect(find.text(untested.username), findsOneWidget);
  });

  testWidgets('online friends are challenged, offline ones invited',
      (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(1.0, const Locale('en')));
    await tester.pumpAndSettle();

    final online = demoFriends.where((f) => f.online).length;
    final offline = demoFriends.length - online;
    expect(find.text('Challenge'), findsNWidgets(online));
    expect(find.text('Invite'), findsNWidgets(offline));
  });

  testWidgets('the search box filters the list', (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(1.0, const Locale('en')));
    await tester.pumpAndSettle();

    expect(find.text('iron_mike'), findsOneWidget);
    expect(find.text('benchgod'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'bench');
    await tester.pumpAndSettle();

    expect(find.text('benchgod'), findsOneWidget);
    expect(find.text('iron_mike'), findsNothing);
  });

  testWidgets('a search that matches nobody says so', (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(1.0, const Locale('en')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'zzzz');
    await tester.pumpAndSettle();

    expect(find.text('Nobody by that name'), findsOneWidget);
    // Not the "no friends yet" empty state — the friends are still there.
    expect(find.text('No friends yet'), findsNothing);
  });
}
