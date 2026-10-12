/// The bottom bar.
///
/// Four tabs and one badge. The badge is the only part with logic in it, and
/// it is the only route by which a friend request reaches somebody who is not
/// already looking at the friends list.
library;

import 'package:flutter/foundation.dart' show LicenseRegistry;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/app_bottom_nav.dart';
import 'package:outrepd/screens/shell.dart';
import 'package:outrepd/theme.dart';

Widget _app({double scale = 1.0, Locale locale = const Locale('en')}) =>
    MaterialApp(
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
      home: const AppShell(),
    );

void main() {
  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  testWidgets('has four tabs and opens on Match', (tester) async {
    phone(tester);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    for (final tab in ['Match', 'Friends', 'Ranks', 'Profile']) {
      expect(find.text(tab), findsWidgets, reason: '$tab is missing');
    }
    // Match is where the app opens: everything else on these screens is a
    // record of duels, and this is the one that starts one.
    expect(AppShell.matchTabIndex, 0);
  });

  testWidgets(
      'shows no request badge offline, matching the empty demo Friends list',
      (tester) async {
    phone(tester);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    // Demo mode never seeds a pending request, so a badge here would be a
    // number the Friends tab itself cannot back up. PositionedDirectional is
    // used nowhere else in the bar — it only wraps the request-count pill.
    expect(
      find.descendant(
        of: find.byType(AppBottomNav),
        matching: find.byType(PositionedDirectional),
      ),
      findsNothing,
    );
  });

  testWidgets('floats: inset from the edges, with rounded corners',
      (tester) async {
    phone(tester);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    final bar = tester.getRect(find.byType(AppBottomNav));
    final card = tester.getRect(find.descendant(
      of: find.byType(AppBottomNav),
      matching: find.byType(DecoratedBox),
    ).first);

    // A gap on three sides is what makes it read as lifted rather than welded
    // to the bottom edge.
    expect(card.left - bar.left, greaterThan(0));
    expect(bar.right - card.right, greaterThan(0));
    expect(bar.bottom - card.bottom, greaterThan(0));

    final decoration = tester
        .widget<DecoratedBox>(find.descendant(
          of: find.byType(AppBottomNav),
          matching: find.byType(DecoratedBox),
        ).first)
        .decoration as BoxDecoration;
    expect(decoration.borderRadius, isNotNull);
    // All four sides, not just the top: a hairline across the top alone is a
    // bar, and the outline is the whole of what says otherwise.
    expect(decoration.border, isA<Border>());
    expect((decoration.border! as Border).bottom.width, greaterThan(0));
  });

  testWidgets('switching tabs changes the screen', (tester) async {
    phone(tester);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('Find a match'), findsOneWidget);

    // The icon: only the open tab shows its name, the others are icons.
    await tester.tap(
      find.descendant(
        of: find.byType(AppBottomNav),
        matching: find.byWidgetPredicate(
          (w) => w is TablerIcon && identical(w.paths, TablerIcon.trophy),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('RANKS'), findsOneWidget);
    expect(find.text('Find a match'), findsNothing);
  });

  for (final scale in [1.3, 1.6]) {
    for (final code in ['en', 'hi', 'ja']) {
      testWidgets('the bar survives $code at ${scale}x', (tester) async {
        phone(tester);
        await tester.pumpWidget(_app(scale: scale, locale: Locale(code)));
        await tester.pumpAndSettle();

        // Four fixed-width tabs holding a word in thirteen languages, plus a
        // badge hanging off one of them.
        expect(tester.takeException(), isNull);
      });
    }
  }

  test("the bar's icons credit Tabler Icons on the licences page", () async {
    // The bar's icons are Tabler's, copied under MIT, which asks for its
    // notice wherever the work goes. Only this entry is read: the app's
    // own notices come from an asset the test does not have.
    LicenseRegistry.reset();
    registerIconLicences();
    final entries = await LicenseRegistry.licenses.toList();
    expect(
      entries.any((e) =>
          e.packages.contains('Tabler Icons') &&
          e.paragraphs.any((p) => p.text.contains('Paweł Kuna'))),
      isTrue,
    );
  });
}
