/// The card shared from a duel's result: the count, who it was against, and
/// what it did to the rank.
library;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/post_match.dart';
import 'package:outrepd/screens/share_card.dart';
import 'package:outrepd/theme.dart';

const _win = MatchShareData(
  username: 'mokhtar_y',
  won: true,
  yourReps: 18,
  theirReps: 11,
  opponent: 'iron_mike',
  seconds: 60,
  tierIdx: 3,
  divIdx: 2,
  lpDelta: 7,
  newBest: true,
);

const _loss = MatchShareData(
  username: 'mokhtar_y',
  won: false,
  yourReps: 14,
  theirReps: 19,
  opponent: 'squat_queen',
  seconds: 60,
  tierIdx: 3,
  divIdx: 2,
  lpDelta: -5,
);

Widget _app(Widget home, {Locale locale = const Locale('en')}) => MaterialApp(
  theme: buildTheme(Brightness.dark),
  locale: locale,
  localizationsDelegates: const [
    L.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: L.supportedLocales,
  home: Scaffold(body: home),
);

Widget _opener(MatchShareData data) => Builder(
  builder: (context) => Center(
    child: ElevatedButton(
      onPressed: () => showMatchShareSheet(context, data: data),
      child: const Text('open'),
    ),
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Future<void> open(
    WidgetTester tester,
    MatchShareData data, {
    Locale locale = const Locale('en'),
  }) async {
    phone(tester);
    await tester.pumpWidget(_app(_opener(data), locale: locale));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('a win shows the count, who it beat, and the LP it paid', (
    tester,
  ) async {
    await open(tester, _win);
    expect(find.text('18'), findsWidgets);
    expect(find.text('PUSH-UPS IN 60 SECONDS'), findsWidgets);
    expect(
      find.textContaining('Beat iron_mike 18–11', findRichText: true),
      findsWidgets,
    );
    expect(find.textContaining('+7 LP', findRichText: true), findsWidgets);
    expect(find.textContaining('New personal best'), findsWidgets);
    expect(find.text('Duel me on outrepd'), findsWidgets);
    // The story card is a scoreboard: a heading, and both lifters by name.
    expect(find.text('VICTORY'), findsWidgets);
    expect(find.text('REMATCH?'), findsNothing);
    expect(find.text('11'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a loss asks to be beaten, and shows what it cost', (
    tester,
  ) async {
    await open(tester, _loss);
    expect(
      find.textContaining('Lost to squat_queen 14–19', findRichText: true),
      findsWidgets,
    );
    expect(find.textContaining('−5 LP', findRichText: true), findsWidgets);
    expect(find.text('Think you can beat me?'), findsWidgets);
    expect(find.textContaining('New personal best'), findsNothing);
    // A loss does not claim a win on its scoreboard; it asks for another go.
    expect(find.text('REMATCH?'), findsWidgets);
    expect(find.text('VICTORY'), findsNothing);
  });

  testWidgets('in placements there is no rank to show', (tester) async {
    await open(
      tester,
      const MatchShareData(
        username: 'new_one',
        won: true,
        yourReps: 12,
        theirReps: 9,
        opponent: 'benchgod',
        seconds: 60,
      ),
    );
    expect(find.textContaining('LP', findRichText: true), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the hidden cards still paint something to capture', (
    tester,
  ) async {
    await open(tester, _win);
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find
          .ancestor(
            of: find.text('PUSH-UPS IN 60 SECONDS').first,
            matching: find.byType(RepaintBoundary),
          )
          .first,
    );
    final bytes = await tester.runAsync(() async {
      final image = await boundary.toImage();
      expect(image.width, greaterThan(200));
      final data = await image.toByteData();
      return data!.buffer.asUint8List();
    });
    // Not one flat colour: the card's text and fill are in the capture.
    expect(bytes!.toSet().length, greaterThan(2));
  });

  testWidgets('the post shape draws too', (tester) async {
    await open(tester, _win);
    await tester.tap(find.text('Post'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  for (final code in ['hi', 'de', 'ja', 'ru']) {
    testWidgets('lays out in $code', (tester) async {
      await open(tester, _loss, locale: Locale(code));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('the result screen shares the match, not the profile', (
    tester,
  ) async {
    phone(tester);
    tester.view.physicalSize = const Size(400, 900);
    await tester.pumpWidget(
      _app(
        DuelResultView(
          won: true,
          yourReps: 18,
          theirReps: 11,
          opponent: demoOpponents.first,
          outcome: demoOutcome(won: true, newBest: true),
          onRematch: () {},
          onDone: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Share'));
    await tester.pumpAndSettle();

    expect(find.text('PUSH-UPS IN 60 SECONDS'), findsWidgets);
    expect(find.text('CURRENT RANK'), findsNothing);
  });
}
