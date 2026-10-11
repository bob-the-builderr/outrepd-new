/// The live rematch on the result screen: asking, being asked, and the
/// match starting once both have.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/live_rematch.dart';
import 'package:outrepd/theme.dart';

const _karim = LiveOpponent(id: 'karim-id', username: 'karimfit', tierIdx: 3, divIdx: 2);
const _played = LiveMatch(id: 'match-1', ranked: true, opponent: _karim);

class _Server extends NoBackend {
  /// What asking answers with.
  LiveRematch answer = const LiveRematch(
    matchId: 'rematch-1',
    status: LiveStatus.invited,
    ranked: true,
  );

  /// Where our own rematch stands when polled.
  LiveStatus state = LiveStatus.invited;

  List<LiveInvite> invites = const [];
  int asks = 0;
  final cancelled = <String>[];

  @override
  bool get available => true;

  @override
  Future<LiveRematch> rematchLive(String afterMatchId) async {
    asks++;
    return answer;
  }

  @override
  Future<List<LiveInvite>> liveInvites() async => invites;

  @override
  Future<LiveState> liveState(String matchId) async => LiveState(
    status: state,
    ranked: true,
    opponent: _karim,
    theyAreReady: false,
    theirReps: 0,
  );

  @override
  Future<void> cancelLiveInvite(String matchId) async => cancelled.add(matchId);
}

Widget _app(Widget child) => MaterialApp(
  theme: buildTheme(Brightness.dark),
  locale: const Locale('en'),
  localizationsDelegates: const [
    L.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: L.supportedLocales,
  home: Scaffold(body: Center(child: child)),
);

void main() {
  late _Server server;
  setUp(() => backend = server = _Server());
  tearDown(() => backend = const NoBackend());

  testWidgets('asking waits on them, and can be taken back', (tester) async {
    LiveMatch? started;
    await tester.pumpWidget(
      _app(LiveRematchButton(after: _played, onStart: (m) => started = m)),
    );
    await tester.tap(find.text('Rematch live'));
    await tester.pump();

    expect(server.asks, 1);
    expect(find.textContaining('Waiting for karimfit'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pump();
    expect(server.cancelled, ['rematch-1']);
    expect(find.text('Rematch live'), findsOneWidget);
    expect(started, isNull);
  });

  testWidgets('starts once they say yes', (tester) async {
    LiveMatch? started;
    await tester.pumpWidget(
      _app(LiveRematchButton(after: _played, onStart: (m) => started = m)),
    );
    await tester.tap(find.text('Rematch live'));
    await tester.pump();

    server.state = LiveStatus.ready;
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(started?.id, 'rematch-1');
    expect(started?.ranked, isTrue);
    expect(started?.opponent.id, 'karim-id');
  });

  testWidgets('when they asked first, the button is the answer', (
    tester,
  ) async {
    LiveMatch? started;
    server.invites = const [
      LiveInvite(
        matchId: 'theirs-1',
        from: _karim,
        expiresIn: Duration(seconds: 25),
        ranked: true,
      ),
    ];
    server.answer = const LiveRematch(
      matchId: 'theirs-1',
      status: LiveStatus.ready,
      ranked: true,
    );
    await tester.pumpWidget(
      _app(LiveRematchButton(after: _played, onStart: (m) => started = m)),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('karimfit wants a rematch · Accept'), findsOneWidget);
    await tester.tap(find.byKey(const Key('liveRematch')));
    await tester.pump();
    expect(started?.id, 'theirs-1');
  });

  testWidgets('an invite from somebody else is not their rematch', (
    tester,
  ) async {
    server.invites = const [
      LiveInvite(
        matchId: 'other-1',
        from: LiveOpponent(id: 'sara-id', username: 'sara', tierIdx: 1, divIdx: 1),
        expiresIn: Duration(seconds: 50),
      ),
    ];
    await tester.pumpWidget(
      _app(LiveRematchButton(after: _played, onStart: (_) {})),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();
    expect(find.text('Rematch live'), findsOneWidget);
  });

  testWidgets('says so when the next one cannot be ranked', (tester) async {
    server.answer = const LiveRematch(
      matchId: 'rematch-1',
      status: LiveStatus.invited,
      ranked: false,
    );
    await tester.pumpWidget(
      _app(LiveRematchButton(after: _played, onStart: (_) {})),
    );
    expect(
      find.text('Friendly · 2 ranked a day with the same lifter'),
      findsNothing,
    );
    await tester.tap(find.text('Rematch live'));
    await tester.pump();
    expect(
      find.text('Friendly · 2 ranked a day with the same lifter'),
      findsOneWidget,
    );
  });

  testWidgets('a lapsed ask says so, and can be asked again', (tester) async {
    await tester.pumpWidget(
      _app(LiveRematchButton(after: _played, onStart: (_) {})),
    );
    await tester.tap(find.text('Rematch live'));
    await tester.pump();
    server.state = LiveStatus.expired;
    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    expect(find.text('No rematch this time'), findsOneWidget);
    await tester.tap(find.text('Rematch live'));
    await tester.pump();
    expect(server.asks, 2);
  });
}
