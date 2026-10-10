/// What a lifter sees when the server refuses because they did the same
/// thing too often: a reason to wait, not "can't reach the server".
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/settings_privacy.dart';
import 'package:outrepd/theme.dart';

class _LimitedBackend extends NoBackend {
  @override
  bool get available => true;

  @override
  Future<void> report({
    String? aboutId,
    required ReportReason reason,
    String details = '',
  }) async => throw const RateLimited();
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    backend = _LimitedBackend();
  });
  tearDown(() => backend = const NoBackend());

  testWidgets('a refused report says to wait, not that the server is gone', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(Brightness.dark),
        locale: const Locale('en'),
        localizationsDelegates: const [
          L.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L.supportedLocales,
        home: const ReportScreen(aboutId: 'someone', aboutName: 'someone'),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cheating or fake reps'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Send report'));
    await tester.pumpAndSettle();

    expect(find.textContaining('doing that too often'), findsOneWidget);
    expect(find.textContaining("Couldn't reach the server"), findsNothing);
  });
}
