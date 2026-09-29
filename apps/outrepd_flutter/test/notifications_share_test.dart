/// The lifter whose set was raced hears about the duel from a notification,
/// and can share it from there — the same card the other lifter shares from
/// their result screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/notifications.dart';
import 'package:outrepd/theme.dart';

class _Notices extends NoBackend {
  _Notices(this.list);

  final List<Notice> list;

  @override
  bool get available => true;

  @override
  Future<List<Notice>> notices() async => list;
}

Widget _app() => MaterialApp(
      theme: buildTheme(Brightness.dark),
      locale: const Locale('en'),
      localizationsDelegates: const [
        L.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L.supportedLocales,
      home: const NotificationsScreen(),
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(() => backend = const NoBackend());

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('a raced set opens its result card to share', (tester) async {
    phone(tester);
    backend = _Notices([
      Notice(
        id: '1',
        kind: NoticeKind.raced,
        at: DateTime.now(),
        unread: true,
        actorName: 'iron_mike',
        actorId: 'x',
        youWon: true,
        yourReps: 18,
        theirReps: 11,
      ),
    ]);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('iron_mike').first);
    await tester.pumpAndSettle();

    // The share sheet, with this duel on its card — not the profile card.
    expect(find.text('Story'), findsOneWidget);
    expect(find.text('Post'), findsOneWidget);
    expect(find.textContaining('18–11'), findsWidgets);
    expect(find.textContaining('iron_mike'), findsWidgets);
  });

  testWidgets('a friend request opens nothing', (tester) async {
    phone(tester);
    backend = _Notices([
      Notice(
        id: '2',
        kind: NoticeKind.friendRequest,
        at: DateTime.now(),
        unread: true,
        actorName: 'squat_queen',
      ),
    ]);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('squat_queen').first);
    await tester.pumpAndSettle();
    expect(find.text('Story'), findsNothing);
  });
}
