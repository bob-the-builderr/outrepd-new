/// What the app opens on.
///
/// One decision, and it is destructive when it goes wrong: onboarding ends by
/// calling `Career.startFresh()`, which zeroes the rank, the record, the rep
/// total and the history. That is right for an account that does not exist
/// yet and it is the loss of everything for anybody else.
///
/// The app shipped opening on onboarding unconditionally, so every launch
/// offered to wipe the account and finishing it did. These tests exist so
/// that cannot come back quietly.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/career.dart';
import 'package:outrepd/data.dart';
import 'package:outrepd/main.dart';
import 'package:outrepd/screens/onboarding.dart';
import 'package:outrepd/screens/shell.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    onboarded = false;
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('a fresh install opens on onboarding', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await loadProfileStats();
    expect(onboarded, isFalse);

    await tester.pumpWidget(const OutrepdApp());
    await tester.pump();

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.byType(AppShell), findsNothing);
  });

  testWidgets('an account that already exists goes straight in', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({'onboarded': true});
    await loadProfileStats();
    expect(onboarded, isTrue);

    await tester.pumpWidget(const OutrepdApp());
    await tester.pump();

    // Straight past the screen whose last act is to clear the account.
    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.byType(AppShell), findsOneWidget);
  });

  test(
    'a career stored before the flag existed still counts as set up',
    () async {
      // The flag is newer than the installs it has to protect. Reading its
      // absence as "new account" would send exactly the people with something
      // to lose back through the screen that clears it.
      final career = Career.instance;
      await career.startFresh();
      await career.recordPractice(30);
      expect(demoProfile.totalReps, greaterThan(0));

      final stored = await SharedPreferences.getInstance();
      await stored.remove('onboarded');
      expect(stored.getString('career.profile'), isNotNull);

      onboarded = false;
      await loadProfileStats();

      expect(
        onboarded,
        isTrue,
        reason: 'a real career was treated as a new install',
      );
    },
  );
}
