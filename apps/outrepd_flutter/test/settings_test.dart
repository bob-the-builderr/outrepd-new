/// The settings tree.
///
/// Seven screens that mostly consist of rows of text, which is exactly the
/// shape that breaks at a large text size and in a language whose script runs
/// tall. These walk each one at 1.0x, at 1.6x and in Hindi, because a
/// settings screen that overflows is one nobody can finish reading — and the
/// screens behind it are the ones somebody opens when they want to be left
/// alone or to leave.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/settings.dart';
import 'package:outrepd/screens/settings_account.dart';
import 'package:outrepd/screens/settings_notices.dart';
import 'package:outrepd/screens/settings_privacy.dart';
import 'package:outrepd/theme.dart';

Widget _app(
  Widget home, {
  double scale = 1.0,
  Locale locale = const Locale('en'),
}) => MaterialApp(
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
  home: home,
);

void main() {
  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(400, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  /// Every screen in the tree, each with the label that proves it drew.
  final screens = <String, (Widget, String)>{
    'settings': (const SettingsScreen(), 'Settings'),
    'notifications': (const NoticeSettingsScreen(), 'Social'),
    'privacy': (const PrivacyScreen(), 'Visibility'),
    'blocked': (const BlockedScreen(), 'Nobody blocked'),
    'download': (const DownloadDataScreen(), "What's included"),
    'delete': (const DeleteAccountScreen(), 'Keep my account'),
    'report': (const ReportScreen(), 'What happened'),
  };

  for (final entry in screens.entries) {
    testWidgets('${entry.key} lays out', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(entry.value.$1));
      await tester.pumpAndSettle();

      expect(find.text(entry.value.$2), findsWidgets);
      expect(tester.takeException(), isNull);
    });

    testWidgets('${entry.key} lays out at 1.6x', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(entry.value.$1, scale: 1.6));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('${entry.key} lays out in Hindi', (tester) async {
      phone(tester);
      await tester.pumpWidget(_app(entry.value.$1, locale: const Locale('hi')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('deleting says it does not cancel the subscription',
      (tester) async {
    // The store bills it, so the account going does not stop it. The stores
    // expect an app with subscriptions to say so before the account goes.
    phone(tester);
    await tester.pumpWidget(_app(const DeleteAccountScreen()));
    await tester.pumpAndSettle();
    expect(
      find.textContaining("doesn't cancel your subscription"),
      findsOneWidget,
    );
  });

  testWidgets('support and rating are real rows, not a "needs a server" note',
      (tester) async {
    // Both used to answer every tap with the same apology.
    phone(tester);
    await tester.pumpWidget(_app(const SettingsScreen()));
    await tester.pumpAndSettle();
    for (final label in ['Contact support', 'Rate OUTREPD']) {
      final row = find.text(label);
      await tester.scrollUntilVisible(row, 200,
          scrollable: find.byType(Scrollable).first);
      await tester.tap(row);
      await tester.pumpAndSettle();
      expect(find.text('This needs a server — not wired up yet'), findsNothing,
          reason: '$label still says it needs a server');
    }
  });

  testWidgets('deleting is armed only by typing the word', (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(const DeleteAccountScreen()));
    await tester.pumpAndSettle();

    // The button exists from the start and does nothing, which is the whole
    // point of the confirmation: the screen can be reached by accident and
    // the last step cannot.
    final button = find.widgetWithText(FilledButton, 'Delete permanently');
    expect(button, findsOneWidget);
    expect(tester.widget<FilledButton>(button).onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'delete me');
    await tester.pumpAndSettle();
    expect(
      tester.widget<FilledButton>(button).onPressed,
      isNull,
      reason: 'anything other than the word armed the delete',
    );

    await tester.enterText(find.byType(TextField), 'DELETE');
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(button).onPressed, isNotNull);
  });

  testWidgets('a report cannot be sent without a reason', (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(const ReportScreen()));
    await tester.pumpAndSettle();

    final send = find.widgetWithText(FilledButton, 'Send report');
    expect(tester.widget<FilledButton>(send).onPressed, isNull);

    await tester.tap(find.text('Cheating or fake reps'));
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(send).onPressed, isNotNull);
  });
}
