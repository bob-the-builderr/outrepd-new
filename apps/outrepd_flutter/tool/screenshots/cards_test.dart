/// Screenshots of the card a name opens and the cards that are shared — a
/// free player's and a Pro's (the user's picks, 2026-11-03) — to see what
/// they look like without a phone. See shots.dart for how these are run and
/// published.
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/lifter/looks.dart';
import 'package:outrepd/screens/other_profile.dart';
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

/// iron_mike, a friend at Diamond IV; Pro with the stadium cover when [pro].
class _Server extends NoBackend {
  _Server({required this.pro});

  final bool pro;

  @override
  bool get available => true;

  @override
  Future<LifterProfile?> lifterProfile(String theirId) async => LifterProfile(
    id: theirId,
    username: 'iron_mike',
    tierIdx: 5,
    divIdx: 1,
    lp: 72,
    placementsDone: 5,
    totalReps: 3140,
    bestSet: 31,
    wins: 41,
    losses: 12,
    winStreak: 22,
    globalPlace: 3,
    country: 'US',
    countryPlace: 1,
    isFriend: true,
    winsVsYou: 3,
    lossesVsYou: 1,
    xp: 40,
  );

  @override
  Future<Map<String, ProLook>> proLooks(List<String> ids) async => {
    for (final id in ids)
      id: pro
          ? ProLook(id: id, pro: true, cover: 'stadium_lights')
          : ProLook(id: id),
  };
}

Widget _app(void Function(BuildContext) open) => MaterialApp(
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
  // The covers move; a still frame settles.
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context).copyWith(disableAnimations: true),
    child: child!,
  ),
  home: Builder(
    builder: (context) => Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () => open(context),
          child: const Text('open'),
        ),
      ),
    ),
  ),
);

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(412 * 2, 915 * 2);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
}

/// A card the share sheet renders for its capture, full size: the layer the
/// size of a story (732 high) or a post (515).
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
  tearDown(() => backend = const NoBackend());

  for (final pro in [false, true]) {
    final name = pro ? 'pro' : 'free';

    testWidgets('the card a name opens, $name', (tester) async {
      _phone(tester);
      backend = _Server(pro: pro);
      await tester.pumpWidget(
        _app(
          (context) => showLifterPeek(
            context,
            id: 'iron_mike-$name',
            username: 'iron_mike',
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      // How they look arrives after the card, as it does on a phone.
      await Looks.instance.fetch(['iron_mike-$name']);
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/peek_$name.png'),
      );
    });

    testWidgets('the profile card, $name', (tester) async {
      _phone(tester);
      await tester.pumpWidget(
        _app(
          (context) => showShareCardSheet(
            context,
            data: ShareCardData(
              username: 'mokhtar',
              tierIdx: 3,
              divIdx: 2,
              lp: 64,
              wins: 62,
              losses: 18,
              bestSet: 31,
              winStreak: 5,
              globalPlace: 1284,
              country: 'EG',
              countryPlace: 12,
              xp: 2400,
              pro: pro,
              cover: pro ? 'stadium_lights' : null,
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await expectLater(
        _card(732),
        matchesGoldenFile('goldens/share_profile_story_$name.png'),
      );
      await expectLater(
        _card(515),
        matchesGoldenFile('goldens/share_profile_post_$name.png'),
      );
    });
  }

  testWidgets('the match card, full size', (tester) async {
    _phone(tester);
    await tester.pumpWidget(
      _app(
        (context) => showMatchShareSheet(
          context,
          data: const MatchShareData(
            username: 'mokhtar',
            won: true,
            yourReps: 18,
            theirReps: 11,
            opponent: 'iron_mike',
            seconds: 60,
            tierIdx: 3,
            divIdx: 2,
            lp: 64,
            lpDelta: 24,
            newBest: true,
            opponentTierIdx: 5,
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await expectLater(
      _card(732),
      matchesGoldenFile('goldens/share_match_story.png'),
    );
    await expectLater(
      _card(515),
      matchesGoldenFile('goldens/share_match_post.png'),
    );
  });
}
