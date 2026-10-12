/// Today's goal on the Match tab: how far along it is, picking another, and
/// done once today's reps reach it.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/career.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/daily_goal.dart';
import 'package:outrepd/settings.dart';
import 'package:outrepd/theme.dart';

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
  home: const Scaffold(
    body: Padding(padding: EdgeInsets.all(16), child: DailyGoalCard()),
  ),
);

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await settings.load();
    await Career.instance.load();
  });
  tearDown(() => settings.dailyGoal = 50);

  testWidgets('says how far today is from the goal', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    final today = Career.instance.repsToday;
    expect(find.text("Today's goal"), findsOneWidget);
    expect(
      find.text('${today < 50 ? today : 50} / 50 push-ups · ${50 - today} to go'),
      findsOneWidget,
    );
  });

  testWidgets('another goal can be picked, and is kept', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('dailyGoal')));
    await tester.pumpAndSettle();
    expect(find.text('Your daily goal'), findsOneWidget);
    await tester.tap(find.byKey(const Key('goal100')));
    await tester.pumpAndSettle();

    expect(settings.dailyGoal, 100);
    final stored = await SharedPreferences.getInstance();
    expect(stored.getInt('dailyGoal'), 100);
  });

  testWidgets('a set finished while the card is up moves it at once',
      (tester) async {
    // The card stays on the Match tab underneath the match, so it has to
    // hear about the reps rather than wait to be built again.
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    final before = Career.instance.repsToday;

    await Career.instance.recordPractice(12);
    await tester.pumpAndSettle();

    final now = before + 12;
    expect(
      find.text('${now < 50 ? now : 50} / 50 push-ups · ${50 - now} to go'),
      findsOneWidget,
    );
  });

  testWidgets('a met goal says done for today', (tester) async {
    settings.dailyGoal = 25;
    await Career.instance.recordPractice(30);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('Done for today'), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
  });
}
