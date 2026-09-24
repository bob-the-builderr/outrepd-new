/// Renaming yourself: availability checks, validation, and what happens on
/// save.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/username_editor.dart';
import 'package:outrepd/theme.dart';

class _FakeBackend extends NoBackend {
  _FakeBackend({
    this.taken = const {},
    this.renameResult = RenameResult.ok,
    this.alreadyChanged = false,
  });

  final Set<String> taken;
  final RenameResult renameResult;

  /// Mimics an account that already spent its one rename — [me] answers
  /// with a non-null [RemoteProfile.usernameChangedAt].
  final bool alreadyChanged;

  String? lastRenameTo;

  @override
  bool get available => true;

  @override
  RemoteProfile? get me => RemoteProfile(
    id: 'fake',
    username: demoProfile.username,
    tierIdx: 0,
    divIdx: 0,
    lp: 0,
    usernameChangedAt: alreadyChanged ? DateTime(2026, 1, 1) : null,
  );

  @override
  Future<bool> usernameAvailable(String name) async =>
      !taken.contains(name.toLowerCase());

  @override
  Future<RenameResult> renameUsername(String name) async {
    lastRenameTo = name;
    return renameResult;
  }
}

Widget _appWithButton() => MaterialApp(
  theme: buildTheme(Brightness.dark),
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
        child: ElevatedButton(
          onPressed: () => showUsernameEditor(context),
          child: const Text('open'),
        ),
      ),
    ),
  ),
);

void main() {
  const small = Size(360, 640);

  void phone(WidgetTester tester) {
    tester.view.physicalSize = small;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  final originalUsername = demoProfile.username;

  setUp(() => backend = const NoBackend());
  tearDown(() {
    backend = const NoBackend();
    demoProfile.username = originalUsername;
  });

  testWidgets('opens with the current name already filled in', (
    tester,
  ) async {
    phone(tester);
    await tester.pumpWidget(_appWithButton());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text(originalUsername), findsOneWidget);
    expect(find.text('Change username'), findsOneWidget);
  });

  testWidgets('the save button is disabled until the name actually changes', (
    tester,
  ) async {
    backend = _FakeBackend();
    phone(tester);
    await tester.pumpWidget(_appWithButton());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final save = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(save.onPressed, isNull);
  });

  testWidgets('a name that is free shows available and can be saved', (
    tester,
  ) async {
    final fake = _FakeBackend();
    backend = fake;
    phone(tester);
    await tester.pumpWidget(_appWithButton());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'brandnewname');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Available'), findsOneWidget);

    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(fake.lastRenameTo, 'brandnewname');
    expect(demoProfile.username, 'brandnewname');
    expect(find.text('Username changed'), findsOneWidget);
  });

  testWidgets('a name somebody else already has shows taken', (tester) async {
    backend = _FakeBackend(taken: {'squatqueen'});
    phone(tester);
    await tester.pumpWidget(_appWithButton());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'squatqueen');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Taken'), findsOneWidget);
    final save = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(save.onPressed, isNull);
  });

  testWidgets('a single character never even asks the server', (
    tester,
  ) async {
    backend = _FakeBackend();
    phone(tester);
    await tester.pumpWidget(_appWithButton());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Available'), findsNothing);
    expect(find.text('Taken'), findsNothing);
    final save = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(save.onPressed, isNull);
  });

  testWidgets('under four characters never even asks the server', (
    tester,
  ) async {
    backend = _FakeBackend();
    phone(tester);
    await tester.pumpWidget(_appWithButton());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'abc');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Available'), findsNothing);
    final save = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(save.onPressed, isNull);
  });

  testWidgets('a symbol or space never even asks the server', (tester) async {
    backend = _FakeBackend();
    phone(tester);
    await tester.pumpWidget(_appWithButton());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'brand new!');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Available'), findsNothing);
    final save = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(save.onPressed, isNull);
  });

  testWidgets('the server saying taken after the screen said available '
      'still refuses to save', (tester) async {
    backend = _FakeBackend(renameResult: RenameResult.taken);
    phone(tester);
    await tester.pumpWidget(_appWithButton());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'brandnewname');
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.text('Available'), findsOneWidget);

    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(find.text('Taken'), findsOneWidget);
    expect(demoProfile.username, originalUsername);
    // Still open, not popped as if it had succeeded.
    expect(find.text('Change username'), findsOneWidget);
  });

  testWidgets(
    'an account that already renamed sees the locked message, not a field',
    (tester) async {
      backend = _FakeBackend(alreadyChanged: true);
      phone(tester);
      await tester.pumpWidget(_appWithButton());
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNothing);
      expect(find.byType(FilledButton), findsOneWidget);

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      // Closed, not saved — there was nothing to save.
      expect(find.text('Change username'), findsNothing);
    },
  );

  testWidgets('with no backend, saving shows it needs one rather than '
      'silently doing nothing', (tester) async {
    phone(tester);
    await tester.pumpWidget(_appWithButton());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'brandnewname');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(find.text("This needs a server — not wired up yet"), findsOneWidget);
    expect(demoProfile.username, originalUsername);
  });

  for (final scale in [1.0, 1.3, 1.6]) {
    testWidgets('username editor lays out at ${scale}x text scale', (
      tester,
    ) async {
      backend = _FakeBackend();
      phone(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(Brightness.dark),
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
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () => showUsernameEditor(context),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  for (final code in ['ar', 'de', 'ja']) {
    testWidgets('username editor lays out in $code', (tester) async {
      backend = _FakeBackend();
      phone(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: buildTheme(Brightness.dark),
          locale: Locale(code),
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
                child: ElevatedButton(
                  onPressed: () => showUsernameEditor(context),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
