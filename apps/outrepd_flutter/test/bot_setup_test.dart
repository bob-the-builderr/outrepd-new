/// The demo opponent: the number and the timeline are one value, and the
/// timeline is always playable.
///
/// The camera walks the landing times and stops at the first one past the
/// clock (see TrainerScreen._opponentReps). That makes two things load-bearing
/// that a screen full of dots could quietly break: the list has to be
/// ascending or the bar undercounts, and the count has to be exactly how many
/// times there are, or the result screen reports a number the bar never
/// reached. These pin both, plus the store round-trip, because a demo that
/// reopens as somebody else's name is not a demo anybody can shoot twice.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/bot.dart';
import 'package:outrepd/screens/bot_setup.dart';
import 'package:outrepd/theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('the spread', () {
    test('gives exactly the count asked for', () {
      for (final count in [1, 5, 18, 100]) {
        expect(spreadRepTimes(count: count).length, count);
      }
    });

    test('is ascending, so the bar that walks it counts them all', () {
      final times = spreadRepTimes(count: 23);
      for (var i = 1; i < times.length; i++) {
        expect(times[i], greaterThanOrEqualTo(times[i - 1]));
      }
    });

    test('stays inside the round', () {
      for (final t in spreadRepTimes(count: 40)) {
        expect(t, greaterThanOrEqualTo(0));
        expect(t, lessThanOrEqualTo(kBotRoundMs));
      }
    });

    test('asks for none, gets none', () {
      expect(spreadRepTimes(count: 0), isEmpty);
    });

    test('asks for a million, gets the ceiling', () {
      expect(spreadRepTimes(count: 999999).length, kBotMaxReps);
    });
  });

  group('the opponent', () {
    test('sorts and clamps whatever it is handed', () {
      final bot = BotOpponent(
        name: 'x',
        repTimesMs: const [90000, -5, 30000, 1000],
      );
      expect(bot.repTimesMs, [0, 1000, 30000, kBotRoundMs]);
    });

    test('the count is exactly how many landings there are', () {
      final bot = BotOpponent(name: 'x', repTimesMs: spreadRepTimes(count: 12));
      expect(bot.reps, 12);
      expect(bot.repTimesSorted.length, 12);
    });

    test('the handout of times cannot be mutated in place', () {
      final bot = BotOpponent(name: 'x', repTimesMs: const [1000, 2000]);
      expect(() => bot.repTimesSorted.add(3000), throwsUnsupportedError);
    });

    test('survives a save and open unchanged', () {
      final bot = BotOpponent(
        name: 'reels',
        photoPath: 'C:/tmp/reels.jpg',
        repTimesMs: const [2000, 5000, 56000],
      );
      final back = BotOpponent.fromJson(bot.toJson());
      expect(back.name, 'reels');
      expect(back.photoPath, 'C:/tmp/reels.jpg');
      expect(back.repTimesMs, [2000, 5000, 56000]);
    });

    test('a nameless stored opponent opens as the default one', () {
      expect(BotOpponent.fromJson({'times': [1000]}).name, 'iron_mike');
    });

    test('an opponent with no landings opens with a playable minute', () {
      final back = BotOpponent.fromJson({'name': 'x', 'times': <int>[]});
      expect(back.reps, greaterThan(0));
    });

    test('the default opens ready to race', () {
      final bot = defaultBot();
      expect(bot.name, isNotEmpty);
      expect(bot.reps, greaterThan(0));
    });

    test('save then load gives the same opponent back', () async {
      await saveBot(
        BotOpponent(name: 'shot_two', repTimesMs: const [3000, 9000]),
      );
      final back = await loadBot();
      expect(back.name, 'shot_two');
      expect(back.repTimesMs, [3000, 9000]);
    });
  });

  group('the setup screen', () {
    testWidgets('opens on the last saved opponent', (tester) async {
      SharedPreferences.setMockInitialValues({
        'botOpponent': '{"name":"rival","times":[1000,2000,3000]}',
      });
      await _open(tester);

      expect(
        (tester.widget<TextField>(find.byKey(const Key('botName')))
                .controller)
            ?.text,
        'rival',
      );
      expect(_reps(tester), '3');
    });

    testWidgets('the count steps up and down', (tester) async {
      await _open(tester);
      expect(_reps(tester), '18');

      await tester.tap(find.byKey(const Key('botRepsUp')));
      await tester.pump();
      expect(_reps(tester), '19');

      await tester.tap(find.byKey(const Key('botRepsDown')));
      await tester.pump();
      expect(_reps(tester), '18');
    });

    testWidgets('the count cannot go below one', (tester) async {
      await _open(tester);
      for (var i = 0; i < 25; i++) {
        await tester.tap(find.byKey(const Key('botRepsDown')));
        await tester.pump();
      }
      expect(_reps(tester), '1');
    });

    testWidgets('no name, no match to start', (tester) async {
      await _open(tester);
      expect(_startEnabled(tester), isTrue);

      await tester.enterText(find.byKey(const Key('botName')), '   ');
      await tester.pump();
      expect(_startEnabled(tester), isFalse);
    });
  });
}

String _reps(WidgetTester tester) =>
    tester.widget<Text>(find.byKey(const Key('botReps'))).data!;

bool _startEnabled(WidgetTester tester) =>
    tester.widget<FilledButton>(find.byKey(const Key('botStart'))).onPressed !=
    null;

Future<void> _open(WidgetTester tester) async {
  tester.view.physicalSize = const Size(400, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: buildTheme(Brightness.dark),
      home: const BotSetupScreen(),
    ),
  );
  await tester.pumpAndSettle();
}
