/// After a live match: once the other lifter leaves their result screen, the
/// rematch button greys out and says so, and this phone says when it leaves.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/screens/live_rematch.dart';
import 'package:outrepd/theme.dart';

class _Server extends NoBackend {
  _Server({required this.theyLeft});

  final bool theyLeft;
  final saidLeaving = <bool>[];

  @override
  Future<RematchPresence> liveResultPresence(
    String afterMatchId, {
    bool leaving = false,
  }) async {
    saidLeaving.add(leaving);
    return theyLeft ? RematchPresence.left : RematchPresence.here;
  }
}

const _match = LiveMatch(
  id: 'played',
  ranked: true,
  opponent: LiveOpponent(
    id: 'karim-id',
    username: 'karimfit',
    tierIdx: 3,
    divIdx: 2,
  ),
);

Widget _app() => MaterialApp(
  theme: buildTheme(Brightness.dark),
  locale: const Locale('en'),
  localizationsDelegates: const [
    L.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: L.supportedLocales,
  home: Scaffold(
    body: LiveRematchButton(after: _match, onStart: (_) {}),
  ),
);

void main() {
  tearDown(() => backend = const NoBackend());

  testWidgets('the other one left: greyed out, and it says so', (tester) async {
    backend = _Server(theyLeft: true);
    await tester.pumpWidget(_app());
    await tester.pump();
    await tester.pump();

    expect(find.text('karimfit left · no rematch this time'), findsOneWidget);
    final button = tester.widget<InkWell>(find.byKey(const Key('liveRematch')));
    expect(button.onTap, isNull);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('still there: the button works, and leaving is said',
      (tester) async {
    final server = _Server(theyLeft: false);
    backend = server;
    await tester.pumpWidget(_app());
    await tester.pump();
    await tester.pump();

    expect(find.byKey(const Key('rematchTheyLeft')), findsNothing);
    final button = tester.widget<InkWell>(find.byKey(const Key('liveRematch')));
    expect(button.onTap, isNotNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(server.saidLeaving.last, isTrue);
  });
}
