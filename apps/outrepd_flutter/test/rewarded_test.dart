/// What a rewarded video gives (the user's pick, 2026-11-09, A + B + C):
/// the match's XP again, a streak brought back once a week, a Pro part for
/// a day — each offered only while a video is there, and laid out on a
/// small phone with the text turned up.
library;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/ads.dart';
import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/lifter/catalog.dart';
import 'package:outrepd/lifter/pro_trial.dart';
import 'package:outrepd/lifter/unlocks.dart';
import 'package:outrepd/rewards.dart';
import 'package:outrepd/screens/level.dart';
import 'package:outrepd/screens/rewarded.dart';
import 'package:outrepd/theme.dart';
import 'package:outrepd/xp.dart';

class _Server extends NoBackend {
  int doubled = 0;

  @override
  bool get available => true;

  @override
  Future<int> doubleDuelXp(String duelId) async {
    doubled++;
    return 38;
  }
}

Widget _app(Widget home, {double scale = 1, Locale locale = const Locale('en')}) =>
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
      home: Scaffold(body: Center(child: home)),
    );

const _gain = XpGain(before: 4180, after: 4218, reps: 18);

/// A streak of nine whose last session was four days ago, the week's rest
/// days already spent: over, and not brought back yet.
void _endedStreak() {
  rewards
    ..streak = 9
    ..restUsedThisWeek = kRestDaysPerWeek
    ..streakSaved = null
    ..lastSession = DateTime.now().subtract(const Duration(days: 4));
}

Future<void> _laysOut(WidgetTester tester, Widget app) async {
  final errors = <FlutterErrorDetails>[];
  final old = FlutterError.onError;
  FlutterError.onError = errors.add;
  try {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
  } finally {
    FlutterError.onError = old;
  }
  expect([for (final e in errors) e.toString()], isEmpty);
}

void main() {
  late _Server server;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    server = _Server();
    backend = server;
    Ads.debugRewarded = true;
  });
  tearDown(() {
    Ads.debugRewarded = null;
    backend = const NoBackend();
  });

  group('A: the match\'s XP twice', () {
    testWidgets('with no video there is no offer, only the card', (tester) async {
      Ads.debugRewarded = false;
      await tester.pumpWidget(_app(const XpDoubleCard(gain: _gain, duelId: 'd')));
      await tester.pumpAndSettle();
      expect(find.byType(XpGainCard), findsOneWidget);
      expect(find.text('Double it'), findsNothing);
    });

    testWidgets('watched: the server pays it again, once', (tester) async {
      await tester.pumpWidget(_app(const XpDoubleCard(gain: _gain, duelId: 'd')));
      await tester.pumpAndSettle();
      expect(find.text('+38 XP'), findsOneWidget);
      expect(find.text('Double it'), findsOneWidget);
      await tester.tap(find.byKey(const Key('doubleXp')));
      await tester.pumpAndSettle();
      expect(server.doubled, 1);
      expect(find.text('+76 XP'), findsOneWidget);
      expect(find.text('×2 DOUBLED'), findsOneWidget);
      expect(find.byKey(const Key('doubleXp')), findsNothing);
    });

    testWidgets('not watched to the end: nothing changes', (tester) async {
      await tester.pumpWidget(_app(const XpDoubleCard(gain: _gain, duelId: 'd')));
      await tester.pumpAndSettle();
      Ads.debugRewarded = false;
      await tester.tap(find.byKey(const Key('doubleXp')));
      await tester.pumpAndSettle();
      expect(server.doubled, 0);
    });
  });

  group('B: the streak back', () {
    test('an ended streak can be brought back, once a week', () async {
      _endedStreak();
      expect(rewards.streakAlive, isFalse);
      expect(rewards.streakRestorable, isTrue);
      await rewards.restoreStreak();
      expect(rewards.streak, 9);
      expect(rewards.streakAlive, isTrue, reason: 'today carries it on');
      // Ended again within the week: not again.
      rewards.lastSession = DateTime.now().subtract(const Duration(days: 4));
      expect(rewards.streakRestorable, isFalse);
      // A week on, it may be.
      rewards.streakSaved = DateTime.now().subtract(const Duration(days: 8));
      expect(rewards.streakRestorable, isTrue);
    });

    test('a streak still alive, or none at all, is nothing to bring back', () {
      rewards
        ..streak = 9
        ..restUsedThisWeek = 0
        ..streakSaved = null
        ..lastSession = DateTime.now().subtract(const Duration(days: 1));
      expect(rewards.streakRestorable, isFalse);
      rewards.streak = 0;
      expect(rewards.streakRestorable, isFalse);
    });

    testWidgets('the card says how long it was, and brings it back', (tester) async {
      _endedStreak();
      await tester.pumpWidget(_app(const StreakBackCard()));
      await tester.pumpAndSettle();
      expect(find.text('Your 9-day streak ended'), findsOneWidget);
      expect(find.text('Keep my 9 days'), findsOneWidget);
      await tester.tap(find.byKey(const Key('keepStreak')));
      await tester.pumpAndSettle();
      expect(rewards.streakAlive, isTrue);
    });

    test('when it was brought back travels with the account', () {
      rewards.streakSaved = DateTime.fromMillisecondsSinceEpoch(1000);
      expect(rewards.toServer()['streakSaved'], 1000);
    });
  });

  group('C: a Pro part for a day', () {
    const inferno = LifterPart('inferno', pro: true);

    test('worn for a day, then taken off for what it replaced', () async {
      final start = DateTime(2026, 11, 9, 12);
      await withClock(Clock.fixed(start), () async {
        expect(await ProTrial.instance.start(key: 'hair', part: inferno, was: 'buzz'), isTrue);
        expect(ProTrial.instance.covers(inferno), isTrue);
        expect(const UnlockState().owns(inferno), isTrue, reason: 'for the day');
        expect(ProTrial.instance.covers(const LifterPart('galaxy_afro', pro: true)), isFalse);
      });
      final wearing = Lifter.fromJson({'hair': 'inferno'});
      await withClock(Clock.fixed(start.add(const Duration(hours: 23))), () async {
        expect(ProTrial.instance.takeOff(wearing), wearing);
      });
      await withClock(Clock.fixed(start.add(const Duration(hours: 25))), () async {
        expect(ProTrial.instance.covers(inferno), isFalse);
        expect(const UnlockState().owns(inferno), isFalse);
        expect(ProTrial.instance.takeOff(wearing).toJson()['hair'], 'buzz');
      });
    });

    testWidgets('the sheet: Get Pro, and the day while a video is there', (tester) async {
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => showProTrialSheet(
                context,
                lifter: Lifter.fromJson({'hair': 'inferno'}),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Get Pro'), findsOneWidget);
      expect(find.text('Wear it free for a day'), findsOneWidget);
      await tester.tap(find.byKey(const Key('trialWear')));
      await tester.pumpAndSettle();
      expect(find.text('Get Pro'), findsNothing);
    });

    testWidgets('no video, no free day on the sheet', (tester) async {
      Ads.debugRewarded = false;
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => showProTrialSheet(
                context,
                lifter: Lifter.fromJson({'hair': 'inferno'}),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('Get Pro'), findsOneWidget);
      expect(find.text('Wear it free for a day'), findsNothing);
    });
  });

  // On a small phone with the text turned up, and in the languages that
  // have broken rows before.
  final screens = <String, Widget Function()>{
    'xp card': () => const Padding(
      padding: EdgeInsets.all(16),
      child: XpDoubleCard(gain: _gain, duelId: 'd'),
    ),
    'streak card': () {
      _endedStreak();
      return const Padding(padding: EdgeInsets.all(16), child: StreakBackCard());
    },
  };
  void small(WidgetTester tester) {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  for (final MapEntry(key: name, value: screen) in screens.entries) {
    for (final scale in [1.0, 1.3, 1.6]) {
      testWidgets('$name lays out at ${scale}x', (tester) async {
        small(tester);
        await _laysOut(tester, _app(screen(), scale: scale));
      });
    }
    for (final code in ['hi', 'de', 'ja', 'ru', 'tr']) {
      testWidgets('$name lays out in $code', (tester) async {
        small(tester);
        await _laysOut(tester, _app(screen(), scale: 1.3, locale: Locale(code)));
      });
    }
  }
}
