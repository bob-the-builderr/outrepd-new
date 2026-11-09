/// Screenshots of a challenge by link (the user's pick, 2026-11-09, B + C),
/// to set beside the mockups in design/mockups/2026-11-09: the home card,
/// the card that is sent, what the link opens, the result of a try, and
/// "Your challenge". See shots.dart for how these are run and published.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/challenge.dart';
import 'package:outrepd/screens/match.dart';
import 'package:outrepd/screens/share_card.dart';
import 'package:outrepd/theme.dart';

Future<void> _font(String family, String path) async {
  final file = File(path);
  if (!file.existsSync()) return;
  final bytes = file.readAsBytesSync();
  final loader = FontLoader(family)
    ..addFont(Future.value(ByteData.view(bytes.buffer)));
  await loader.load();
}

final _at = DateTime.now().subtract(const Duration(hours: 3));
const _code = 'k7f2mq';
const _owner = ChallengeOwner(
  id: 'mokhtar',
  username: 'mokhtar',
  tierIdx: 3,
  divIdx: 2,
  xp: 2400,
);

ChallengeEntry _entry(
  String id,
  String name,
  int reps, {
  bool owner = false,
  bool beat = false,
}) => ChallengeEntry(
  takeId: owner ? null : 'take-$id',
  id: id,
  username: name,
  reps: reps,
  at: _at,
  owner: owner,
  beat: beat,
  canBack: !owner,
);

/// The challenge as a link opens it, before this account's try.
ChallengeView get _open => ChallengeView(
  code: _code,
  reps: 18,
  owner: _owner,
  expiresAt: DateTime(2026, 11, 16),
  board: [
    _entry('iron', 'iron_mike', 23, beat: true),
    _entry('mokhtar', 'mokhtar', 18, owner: true),
    _entry('squat', 'squat_queen', 14),
  ],
);

/// After this account's 21.
ChallengeView get _after => ChallengeView(
  code: _code,
  reps: 18,
  owner: _owner,
  expiresAt: DateTime(2026, 11, 16),
  taken: 21,
  takeId: 'take-me',
  board: [
    _entry('iron', 'iron_mike', 23, beat: true),
    _entry('me', 'demo_lifter', 21, beat: true),
    _entry('mokhtar', 'mokhtar', 18, owner: true),
    _entry('squat', 'squat_queen', 14),
  ],
);

/// This account's own, three tries on it.
ChallengeView get _mine => ChallengeView(
  code: _code,
  reps: 18,
  owner: const ChallengeOwner(id: 'me', username: 'demo_lifter'),
  expiresAt: DateTime(2026, 11, 16),
  mine: true,
  board: [
    _entry('iron', 'iron_mike', 23, beat: true),
    _entry('bench', 'benchgod', 21, beat: true),
    _entry('me', 'demo_lifter', 18, owner: true),
    _entry('squat', 'squat_queen', 14),
  ],
);

class _Server extends NoBackend {
  @override
  bool get available => true;

  @override
  RemoteProfile? get me => const RemoteProfile(
    id: 'me',
    username: 'demo_lifter',
    tierIdx: 3,
    divIdx: 2,
    lp: 64,
    friendCode: 'ABC123',
  );

  @override
  Future<ChallengeLink?> makeChallenge({String? setId}) async =>
      const ChallengeLink(code: _code, reps: 18);

  @override
  Future<ChallengeLink?> challengeBest() async =>
      const ChallengeLink(code: _code, reps: 24);

  @override
  Future<ChallengeView?> openChallenge(String code) async => _open;
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
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(disableAnimations: true),
    child: child!,
  ),
  home: home,
);

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(412 * 2, 915 * 2);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
}

/// A card the share sheet renders for its capture, full size.
Finder _card(double height) => find
    .byElementPredicate((element) {
      if (element.widget is! RepaintBoundary) return false;
      final box = element.renderObject;
      return box is RenderBox &&
          box.hasSize &&
          box.size == Size(412, height);
    })
    .first;

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

  setUp(() {
    // A test in all but folder: it lives in tool/ so `flutter test` skips it.
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
    backend = _Server();
  });
  tearDown(() => backend = const NoBackend());

  Future<void> shoot(WidgetTester tester, Widget screen, String name) async {
    _phone(tester);
    await tester.pumpWidget(_app(screen));
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/$name.png'),
    );
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  }

  testWidgets('the home card, C', (tester) async {
    await shoot(tester, const MatchScreen(), 'challenge_home');
  });

  testWidgets('what a link opens', (tester) async {
    await shoot(
      tester,
      ChallengeScreen(code: _code, preview: _open),
      'challenge_open',
    );
  });

  testWidgets('after a try', (tester) async {
    await shoot(
      tester,
      Scaffold(
        body: ChallengeResultView(view: _after, reps: 21, onDone: () {}),
      ),
      'challenge_result',
    );
  });

  testWidgets('your challenge', (tester) async {
    await shoot(
      tester,
      ChallengeScreen(code: _code, preview: _mine),
      'challenge_yours',
    );
  });

  testWidgets('the card that is sent, B', (tester) async {
    _phone(tester);
    await tester.pumpWidget(
      _app(
        Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => showChallengeShareSheet(
                  context,
                  data: const ChallengeShareData(
                    username: 'mokhtar',
                    code: _code,
                    reps: 18,
                    seconds: 60,
                    tierIdx: 3,
                  ),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/challenge_sheet.png'),
    );
    await expectLater(
      _card(515),
      matchesGoldenFile('goldens/challenge_card_post.png'),
    );
    await expectLater(
      _card(732),
      matchesGoldenFile('goldens/challenge_card_story.png'),
    );
  });
}
