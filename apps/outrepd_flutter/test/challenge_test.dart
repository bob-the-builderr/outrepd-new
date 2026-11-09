/// A challenge by link (the user's pick, 2026-11-09, B + C): the link, what
/// it opens, the result of a try, and the card it is sent with — on a small
/// phone with large text, and in the languages that have broken rows before.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/deep_links.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/challenge.dart';
import 'package:outrepd/screens/share_card.dart';
import 'package:outrepd/theme.dart';

const _code = 'k7f2mq';
const _owner = ChallengeOwner(
  id: 'mokhtar',
  username: 'mokhtar',
  tierIdx: 3,
  divIdx: 2,
);
final _at = DateTime.now().subtract(const Duration(hours: 3));

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

ChallengeView _open({int? taken, bool open = true}) => ChallengeView(
  code: _code,
  reps: 18,
  owner: _owner,
  expiresAt: DateTime.now().add(const Duration(days: 6)),
  open: open,
  taken: taken,
  board: [
    _entry('iron', 'iron_mike', 23, beat: true),
    _entry('mokhtar', 'mokhtar', 18, owner: true),
    _entry('squat', 'squat_queen', 14),
  ],
);

ChallengeView _after(int reps) => ChallengeView(
  code: _code,
  reps: 18,
  owner: _owner,
  expiresAt: DateTime.now().add(const Duration(days: 6)),
  taken: reps,
  takeId: 'take-me',
  board: [
    _entry('iron', 'iron_mike', 23, beat: true),
    _entry('me', 'demo_lifter', reps, beat: reps > 18),
    _entry('mokhtar', 'mokhtar', 18, owner: true),
    _entry('squat', 'squat_queen', 14),
  ]..sort((a, b) => b.reps.compareTo(a.reps)),
);

final _mine = ChallengeView(
  code: _code,
  reps: 18,
  owner: const ChallengeOwner(id: 'me', username: 'demo_lifter'),
  expiresAt: DateTime.now().add(const Duration(days: 6)),
  mine: true,
  board: [
    _entry('iron', 'iron_mike', 23, beat: true),
    _entry('bench', 'benchgod', 21, beat: true),
    _entry('me', 'demo_lifter', 18, owner: true),
    _entry('squat', 'squat_queen', 14),
  ],
);

class _Server extends NoBackend {
  _Server({this.link = const ChallengeLink(code: _code, reps: 18)});

  final ChallengeLink? link;

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
  Future<ChallengeLink?> makeChallenge({String? setId}) async => link;

  @override
  Future<ChallengeLink?> challengeBest() async =>
      link == null ? null : ChallengeLink(code: link!.code, reps: 24);

  @override
  Future<ChallengeView?> openChallenge(String code) async =>
      code == _code ? _open() : null;

  @override
  Future<ChallengeLink?> backChallenge(String takeId) async => link;
}

Widget _app(
  Widget home, {
  double scale = 1,
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

void _small(WidgetTester tester) {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void _tall(WidgetTester tester) {
  tester.view.physicalSize = const Size(412, 915);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  setUp(() => backend = _Server());
  tearDown(() => backend = const NoBackend());

  group('links', () {
    test('a challenge link names its code, with or without www', () {
      expect(challengeCodeFromLink(Uri.parse('https://www.outrepd.com/c/k7f2mq')), _code);
      expect(challengeCodeFromLink(Uri.parse('https://outrepd.com/c/K7F2MQ/')), _code);
    });

    test('anything else names none', () {
      for (final link in [
        'https://www.outrepd.com/c/',
        'https://www.outrepd.com/c/k7f2m',
        'https://www.outrepd.com/c/k7f2mqq',
        // No 0, 1, i, l or o in a code: easy to misread.
        'https://www.outrepd.com/c/k7f2m1',
        'https://www.outrepd.com/c/k7f2mo',
        'https://www.outrepd.com/u/k7f2mq',
        'https://example.com/c/k7f2mq',
      ]) {
        expect(challengeCodeFromLink(Uri.parse(link)), isNull, reason: link);
      }
      // And a challenge link names no lifter.
      expect(lifterNameFromLink(Uri.parse('https://www.outrepd.com/c/k7f2mq')), isNull);
    });

    test('the link a card carries is the link the app opens', () {
      expect(challengePath(_code), 'outrepd.com/c/k7f2mq');
      expect(challengeCodeFromLink(Uri.parse(shareLink(challengePath(_code)))), _code);
    });
  });

  test('a challenge reads the server\'s shape', () {
    final view = ChallengeView.fromJson({
      'code': _code,
      'reps': 18,
      'rep_times': [2900, 5800],
      'expires_at': '2026-11-16T09:00:00Z',
      'open': true,
      'mine': false,
      'taken': null,
      'owner': {'id': 'mokhtar', 'username': 'mokhtar', 'tier_idx': 3, 'div_idx': 2, 'xp': 10},
      'board': [
        {'take_id': null, 'id': 'mokhtar', 'username': 'mokhtar', 'reps': 18,
         'at': '2026-11-09T09:00:00Z', 'owner': true, 'beat': false, 'can_back': false},
        {'take_id': 't', 'id': 'b', 'username': 'bob', 'reps': 20,
         'at': '2026-11-09T10:00:00Z', 'owner': false, 'beat': true, 'can_back': true},
      ],
    })!;
    expect(view.repTimes, [2900, 5800]);
    expect(view.owner.tierIdx, 3);
    expect(view.taken, isNull);
    expect(view.board.last.beat, isTrue);
    expect(view.placeOf('b'), 2);
    expect(view.placeOf('mokhtar'), isNull, reason: 'the owner set it');
    expect(ChallengeView.fromJson(null), isNull);
    expect(ChallengeLink.fromJson({'code': _code, 'reps': 18})!.reps, 18);
  });

  testWidgets('the link opens the challenge to take', (tester) async {
    _tall(tester);
    await tester.pumpWidget(_app(ChallengeScreen(code: _code, preview: _open())));
    await tester.pumpAndSettle();
    expect(find.text('CHALLENGE · FRIENDLY'), findsOneWidget);
    expect(find.text('mokhtar'), findsWidgets);
    expect(find.text('18'), findsWidgets);
    expect(find.text('BEAT IT'), findsOneWidget);
    expect(find.text('set it'), findsOneWidget);
    expect(find.text('3 took it'), findsNothing, reason: 'two took it');
    expect(find.text('2 took it'), findsOneWidget);
    final take = tester.widget<FilledButton>(find.byKey(const Key('takeChallenge')));
    expect(take.onPressed, isNotNull);
  });

  testWidgets('one try each: taken, it cannot be taken again', (tester) async {
    _tall(tester);
    await tester.pumpWidget(
      _app(ChallengeScreen(code: _code, preview: _open(taken: 21))),
    );
    await tester.pumpAndSettle();
    expect(find.text('You took it: 21.'), findsOneWidget);
    final take = tester.widget<FilledButton>(find.byKey(const Key('takeChallenge')));
    expect(take.onPressed, isNull);
  });

  testWidgets('a closed challenge says so', (tester) async {
    _tall(tester);
    await tester.pumpWidget(
      _app(ChallengeScreen(code: _code, preview: _open(open: false))),
    );
    await tester.pumpAndSettle();
    expect(find.text('This challenge has closed.'), findsOneWidget);
    final take = tester.widget<FilledButton>(find.byKey(const Key('takeChallenge')));
    expect(take.onPressed, isNull);
  });

  testWidgets('a code that leads nowhere says so', (tester) async {
    _tall(tester);
    await tester.pumpWidget(_app(const ChallengeScreen(code: 'zzzzzz')));
    await tester.pumpAndSettle();
    expect(find.text('Challenge is gone'), findsOneWidget);
  });

  testWidgets('a link is opened from the server', (tester) async {
    _tall(tester);
    await tester.pumpWidget(_app(const ChallengeScreen(code: _code)));
    await tester.pumpAndSettle();
    expect(find.text('iron_mike'), findsOneWidget);
  });

  testWidgets('your own: who took it, and each one that beat it to take back',
      (tester) async {
    _tall(tester);
    await tester.pumpWidget(_app(ChallengeScreen(code: _code, preview: _mine)));
    await tester.pumpAndSettle();
    expect(find.text('Your challenge'), findsOneWidget);
    expect(find.text('3 took it'), findsOneWidget);
    expect(find.text('2 beat you'), findsOneWidget);
    expect(find.text('Take it back'), findsNWidgets(2));
    expect(find.text('Send to more friends'), findsOneWidget);
  });

  testWidgets('beaten: by how much, where it put you, and sent back',
      (tester) async {
    _tall(tester);
    await tester.pumpWidget(
      _app(Scaffold(body: ChallengeResultView(view: _after(21), reps: 21, onDone: () {}))),
    );
    await tester.pumpAndSettle();
    expect(find.text('YOU BEAT IT'), findsOneWidget);
    expect(find.text('3 more than mokhtar.'), findsOneWidget);
    expect(find.text("You're #2 of 4"), findsOneWidget);
    await tester.tap(find.byKey(const Key('challengeBack')));
    await tester.pumpAndSettle();
    expect(find.text('Sent back'), findsOneWidget);
  });

  testWidgets('short: by how much, and level is not a win', (tester) async {
    _tall(tester);
    await tester.pumpWidget(
      _app(Scaffold(body: ChallengeResultView(view: _after(15), reps: 15, onDone: () {}))),
    );
    await tester.pumpAndSettle();
    expect(find.text('NOT THIS TIME'), findsOneWidget);
    expect(find.text('3 short of mokhtar.'), findsOneWidget);

    await tester.pumpWidget(
      _app(Scaffold(body: ChallengeResultView(view: _after(18), reps: 18, onDone: () {}))),
    );
    await tester.pumpAndSettle();
    expect(find.text('NOT THIS TIME'), findsOneWidget);
    expect(find.textContaining('Level with mokhtar'), findsOneWidget);
  });

  testWidgets('the Challenge button sends the challenge card', (tester) async {
    _tall(tester);
    await tester.pumpWidget(_app(const Scaffold(body: Center(child: ChallengeButton()))));
    await tester.tap(find.byKey(const Key('challenge')));
    await tester.pumpAndSettle();
    expect(find.text('CAN YOU BEAT IT?'), findsWidgets);
    expect(find.text('outrepd.com/c/k7f2mq'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('with no whole minute to send, it says so', (tester) async {
    _tall(tester);
    backend = _Server(link: null);
    await tester.pumpWidget(_app(const Scaffold(body: Center(child: ChallengeButton()))));
    await tester.tap(find.byKey(const Key('challenge')));
    await tester.pumpAndSettle();
    expect(find.text('Lift a whole minute first, then send it.'), findsOneWidget);
  });

  testWidgets('the home card sends the best minute', (tester) async {
    _tall(tester);
    await tester.pumpWidget(_app(const Scaffold(body: Center(child: ChallengeHomeCard()))));
    expect(find.text('Challenge a friend'), findsOneWidget);
    await tester.tap(find.byKey(const Key('challengeHome')));
    await tester.pumpAndSettle();
    expect(find.text('24'), findsWidgets);
    expect(find.text('CAN YOU BEAT IT?'), findsWidgets);
  });

  // Every screen, on a small phone with the text turned up.
  final screens = <String, Widget Function()>{
    'open': () => ChallengeScreen(code: _code, preview: _open()),
    'yours': () => ChallengeScreen(code: _code, preview: _mine),
    'result': () => Scaffold(
      body: ChallengeResultView(view: _after(21), reps: 21, onDone: () {}),
    ),
    'home card': () => const Scaffold(
      body: Padding(padding: EdgeInsets.all(16), child: ChallengeHomeCard()),
    ),
  };
  for (final MapEntry(key: name, value: screen) in screens.entries) {
    for (final scale in [1.0, 1.3, 1.6]) {
      testWidgets('$name lays out at ${scale}x', (tester) async {
        _small(tester);
        await tester.pumpWidget(_app(screen(), scale: scale));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
    for (final code in ['hi', 'de', 'ja', 'ru', 'tr']) {
      testWidgets('$name lays out in $code', (tester) async {
        _small(tester);
        await tester.pumpWidget(_app(screen(), scale: 1.3, locale: Locale(code)));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }

  for (final code in ['en', 'hi', 'de', 'ja', 'ru']) {
    testWidgets('the challenge card draws in $code', (tester) async {
      _tall(tester);
      await tester.pumpWidget(
        _app(const Scaffold(body: Center(child: ChallengeButton())), locale: Locale(code)),
      );
      await tester.tap(find.byKey(const Key('challenge')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
