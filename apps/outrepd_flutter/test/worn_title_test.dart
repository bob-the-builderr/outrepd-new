/// The title a lifter wears, as other people see it: sent to the server when
/// it changes, and drawn under their name on the profile you open.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/backend/backend.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/rewards.dart';
import 'package:outrepd/screens/other_profile.dart';
import 'package:outrepd/theme.dart';

class _TitleBackend extends NoBackend {
  _TitleBackend([this.profile]);

  final LifterProfile? profile;
  final sent = <String?>[];

  @override
  bool get available => true;

  @override
  Future<void> setTitle(String? id) async => sent.add(id);

  @override
  Future<LifterProfile?> lifterProfile(String theirId) async => profile;
}

/// Records calls like [_TitleBackend] but reports no server, the way a
/// phone does before sign-in.
class _OfflineTitleBackend extends _TitleBackend {
  @override
  bool get available => false;
}

LifterProfile _wearing(String? title) => LifterProfile(
  id: 'ayaan99-id',
  username: 'ayaan99',
  tierIdx: 3,
  divIdx: 2,
  lp: 40,
  placementsDone: 5,
  totalReps: 500,
  bestSet: 20,
  wins: 10,
  losses: 5,
  winStreak: 2,
  isFriend: false,
  winsVsYou: 0,
  lossesVsYou: 0,
  title: title,
);

Widget _app(Widget home) => MaterialApp(
  theme: buildTheme(Brightness.dark),
  locale: const Locale('en'),
  localizationsDelegates: const [
    L.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: L.supportedLocales,
  home: home,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(() => backend = const NoBackend());

  group('sending it', () {
    test('wearing a title tells the server, once per change', () async {
      final fake = _TitleBackend();
      backend = fake;
      final rewards = Rewards();
      await rewards.load();
      await pumpEventQueue();
      fake.sent.clear();

      await rewards.wear('first_blood');
      await pumpEventQueue();
      expect(fake.sent, ['first_blood']);

      // Saving for another reason does not send it again.
      await rewards.award('comeback');
      await pumpEventQueue();
      expect(fake.sent, ['first_blood']);

      await rewards.wear(null);
      await pumpEventQueue();
      expect(fake.sent, ['first_blood', null]);
    });

    test('nothing is sent without a server', () async {
      final fake = _OfflineTitleBackend();
      backend = fake;
      final rewards = Rewards();
      await rewards.load();
      await rewards.wear('first_blood');
      await pumpEventQueue();
      expect(fake.sent, isEmpty);
    });
  });

  group('showing it', () {
    testWidgets('their title sits under their name', (tester) async {
      backend = _TitleBackend(_wearing('giant_slayer'));
      await tester.pumpWidget(
        _app(const OtherProfileScreen(id: 'ayaan99-id', username: 'ayaan99')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Giant Slayer'), findsOneWidget);
    });

    testWidgets('a title this build does not know shows nothing', (
      tester,
    ) async {
      backend = _TitleBackend(_wearing('from_a_newer_version'));
      await tester.pumpWidget(
        _app(const OtherProfileScreen(id: 'ayaan99-id', username: 'ayaan99')),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('ayaan99'), findsOneWidget);
    });
  });
}
