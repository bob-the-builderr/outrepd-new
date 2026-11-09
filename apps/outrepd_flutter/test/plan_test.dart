/// Beat your past self (lib/plan.dart): the weeks, the day's sets, the race,
/// and today's goal turning into today's plan.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/plan.dart';
import 'package:outrepd/screens/daily_goal.dart';
import 'package:outrepd/theme.dart';

Widget _app(Widget child) => MaterialApp(
  theme: buildTheme(Brightness.dark),
  localizationsDelegates: const [
    L.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: L.supportedLocales,
  home: Scaffold(body: Center(child: child)),
);

void main() {
  // Tuesday 10 November 2026.
  final began = dayNumber(DateTime(2026, 11, 10));
  final plan = TrainingPlan(start: 24, goal: 36, days: 3, began: began);

  setUp(() {
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
  });
  tearDown(() => trainingPlan = PlanStore());

  test('three goals above the start: steady, recommended, hard', () {
    expect(planGoals(24), [30, 36, 42]);
    expect(planGoals(2), [4, 6, 8]);
  });

  test('weeks run Monday to Sunday, from the week it began', () {
    expect(plan.weekOf(began), 1);
    expect(plan.weekOf(dayNumber(DateTime(2026, 11, 15))), 1);
    expect(plan.weekOf(dayNumber(DateTime(2026, 11, 16))), 2);
    expect(plan.overOn(dayNumber(DateTime(2026, 12, 20))), isFalse);
    expect(plan.overOn(dayNumber(DateTime(2026, 12, 21))), isTrue);
  });

  test('the week\'s target climbs from the start to the goal', () {
    expect(plan.targetFor(1), 24);
    expect(plan.targetFor(2), 26);
    expect(plan.targetFor(6), 36);
    expect(plan.repsPerSet(2), 12);
  });

  test('three days a week is Monday, Wednesday and Friday, racing Sunday', () {
    final monday = dayNumber(DateTime(2026, 11, 16));
    expect([for (var d = monday; d < monday + 7; d++) plan.trainsOn(d)],
        [true, false, true, false, true, false, false]);
    expect(plan.racesOn(monday + 6), isTrue);
  });

  test('kept and read back the same', () {
    final full = plan.copyWith(sets: {began: 3}, races: {1: 26});
    expect(TrainingPlan.fromJson(full.toJson()), full);
    expect(TrainingPlan.fromJson({'start': 24, 'goal': 20, 'days': 3, 'began': 1}),
        isNull);
  });

  test('a set counts when it reaches the day\'s number; a race keeps its best',
      () async {
    final store = PlanStore(clock: () => DateTime(2026, 11, 18, 9));
    await store.begin(start: 24, goal: 36, days: 3);
    final today = store.today;
    expect(await store.recordSet(8), isFalse);
    expect(await store.recordSet(11), isTrue);
    await store.recordSet(14);
    await store.recordSet(11);
    expect(store.plan!.doneOn(today), isTrue);
    await store.recordRace(29);
    await store.recordRace(27);
    expect(store.plan!.raceOf(today), 29);
    await store.stop();
    expect(store.plan, isNull);
  });

  testWidgets('on a plan, today\'s goal is today\'s plan', (tester) async {
    trainingPlan = PlanStore(clock: () => DateTime(2026, 11, 18, 9));
    await tester.pumpWidget(_app(const DailyGoalCard()));
    expect(find.byKey(const Key('dailyGoal')), findsOneWidget);
    // ignore: invalid_use_of_visible_for_testing_member
    trainingPlan.debugPlan = plan.copyWith(
      sets: {dayNumber(DateTime(2026, 11, 18)): 1},
    );
    await tester.pump();
    expect(find.byKey(const Key('dailyGoal')), findsNothing);
    expect(find.byKey(const Key('planCard')), findsOneWidget);
    expect(find.textContaining('3 sets of 12'), findsOneWidget);
  });

  testWidgets('the goal sheet offers a plan instead', (tester) async {
    await tester.pumpWidget(_app(const DailyGoalCard()));
    await tester.tap(find.byKey(const Key('dailyGoal')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('goalPlan')), findsOneWidget);
  });
}
