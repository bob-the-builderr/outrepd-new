/// Screenshots of the end of a duel: the win, the loss, the promotion, and a
/// live rematch the other side asked for. See shots.dart for how these are
/// run and published.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/data.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/level.dart';
import 'package:outrepd/screens/post_match.dart';
import 'package:outrepd/theme.dart';
import 'package:outrepd/xp.dart';

Future<void> _font(String family, String path) async {
  final file = File(path);
  if (!file.existsSync()) return;
  final bytes = file.readAsBytesSync();
  final loader = FontLoader(family)
    ..addFont(Future.value(ByteData.view(bytes.buffer)));
  await loader.load();
}

const _karim = LiveOpponent(
  id: 'karim-id',
  username: 'karimfit',
  tierIdx: 3,
  divIdx: 2,
);

class _Live extends NoBackend {
  _Live({this.asked = false});

  final bool asked;

  @override
  bool get available => true;

  @override
  Future<List<LiveInvite>> liveInvites() async => [
    if (asked)
      const LiveInvite(
        matchId: 'theirs',
        from: _karim,
        expiresIn: Duration(seconds: 24),
        ranked: true,
      ),
  ];
}

Widget _app(Widget home) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: buildTheme(Brightness.dark),
  locale: const Locale('en'),
  localizationsDelegates: const [
    L.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: L.supportedLocales,
  home: Scaffold(body: home),
);

DuelResultView _result({required bool won, bool live = true}) => DuelResultView(
  won: won,
  yourReps: won ? 18 : 14,
  theirReps: won ? 11 : 19,
  opponent: const Opponent('karimfit', 3, 2),
  outcome: demoOutcome(won: won),
  onRematch: () {},
  onDone: () {},
  live: live
      ? const LiveMatch(id: 'played', ranked: true, opponent: _karim)
      : null,
  onLiveRematch: live ? (_) {} : null,
  monthBefore: 14,
  monthAfter: won ? 11 : 16,
  xp: XpGain(
    before: 4200,
    after: 4200 + (won ? 18 : 14) + kXpPerMatch,
    reps: won ? 18 : 14,
  ),
);

void main() {
  setUpAll(() async {
    final fonts = Platform.environment['SHOT_FONTS'] ?? 'tool/screenshots/fonts';
    await _font('Roboto', '$fonts/NotoSans.ttf');
    await _font('FlutterTest', '$fonts/NotoSans.ttf');
    final root = Platform.environment['FLUTTER_ROOT'];
    if (root != null) {
      await _font(
        'MaterialIcons',
        '$root/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
      );
    }
  });

  // A test in all but folder: it lives in tool/ so `flutter test` skips it.
  // ignore: invalid_use_of_visible_for_testing_member
  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(() => backend = const NoBackend());

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(412 * 2, 915 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
  }

  testWidgets('win', (tester) async {
    phone(tester);
    backend = _Live();
    await tester.pumpWidget(_app(_result(won: true)));
    await tester.pump(const Duration(seconds: 2));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/result_win.png'),
    );
  });

  testWidgets('loss', (tester) async {
    phone(tester);
    backend = _Live();
    await tester.pumpWidget(_app(_result(won: false)));
    await tester.pump(const Duration(seconds: 2));
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/result_loss.png'),
    );
  });

  testWidgets('rematch asked', (tester) async {
    phone(tester);
    backend = _Live(asked: true);
    await tester.pumpWidget(_app(_result(won: true)));
    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/result_rematch_asked.png'),
    );
  });

  testWidgets('promotion', (tester) async {
    phone(tester);
    await tester.pumpWidget(
      _app(
        PromotionView(
          tierIdx: 3,
          divIdx: 3,
          fromTierIdx: 3,
          fromDivIdx: 2,
          highest: true,
          onContinue: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/result_promotion.png'),
    );
  });

  testWidgets('level up', (tester) async {
    phone(tester);
    await tester.pumpWidget(_app(LevelUpView(level: 13, onContinue: () {})));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/result_level_up.png'),
    );
  });

  testWidgets('level card', (tester) async {
    phone(tester);
    await tester.pumpWidget(
      _app(
        const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                XpCard(xp: 4240),
                SizedBox(height: 12),
                XpGainCard(gain: XpGain(before: 4240, after: 4283, reps: 23)),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/level_cards.png'),
    );
  });
}
