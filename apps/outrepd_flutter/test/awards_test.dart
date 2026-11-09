/// Awards (lib/awards/families.dart, lib/rewards.dart): families of five
/// tiers judged on the numbers, the titles of before kept as tiers, the
/// specials, and the showcase.
library;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:outrepd/awards/award_text.dart';
import 'package:outrepd/awards/families.dart';
import 'package:outrepd/awards/medal.dart';
import 'package:outrepd/l10n/app_localizations.dart';
import 'package:outrepd/rewards.dart';
import 'package:outrepd/theme.dart';

void main() {
  setUp(() async {
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues({});
    await rewards.forget();
  });

  test('fourteen families of five, and three specials', () {
    expect(kAwardFamilies.length, 14);
    expect(kAwardCount, 73);
    expect(kTitles.length, kAwardCount);
    expect(kTitles.map((t) => t.id).toSet().length, kTitles.length, reason: 'ids are unique');
    for (final f in kAwardFamilies) {
      expect(f.tiers.length, 5);
      for (var t = 1; t < 5; t++) {
        expect(f.tiers[t], greaterThan(f.tiers[t - 1]), reason: '${f.id} climbs');
      }
    }
  });

  test('the numbers reach each tier', () async {
    final unlocked = await rewards.syncWithProfile(matches: 0, wins: 12, reps: 5200, bestSet: 31);
    expect(rewards.has('grinder_3'), isTrue);
    expect(rewards.has('grinder_4'), isFalse);
    expect(rewards.has('champion_2'), isTrue);
    expect(rewards.has('personal_best_2'), isTrue);
    expect(unlocked.map((t) => t.id), contains('grinder_1'));
  });

  test('the titles of before are their family\'s tiers, and stay', () async {
    rewards.earned.addAll(['the_machine', 'unbroken', 'century']);
    final unlocked = await rewards.syncWithProfile(matches: 0, wins: 0, reps: 0);
    expect(rewards.has('grinder_1'), isTrue);
    expect(rewards.has('grinder_2'), isTrue);
    expect(rewards.has('iron_will_3'), isTrue);
    expect(rewards.has('century'), isTrue, reason: 'still earned, still wearable');
    expect(titleById('century'), isNotNull);
    expect(unlocked, isEmpty, reason: 'given quietly, not celebrated again');
  });

  test('the tallies a match feeds', () async {
    await rewards.countGiantWin();
    await rewards.countPastBeat();
    await rewards.countGoalDay(100);
    await rewards.countGoalDay(100);
    await rewards.noteChallengeTakers(6);
    await rewards.noteChallengeTakers(2);
    expect(rewards.goalDays, 1, reason: 'a day counts once');
    expect(rewards.challengeTakers, 6, reason: 'kept at its largest');
    await rewards.syncWithProfile(matches: 0, wins: 0, reps: 0);
    expect(rewards.has('giant_slayer_1'), isTrue);
    expect(rewards.has('past_self_1'), isTrue);
    expect(rewards.has('challenger_2'), isTrue);
  });

  test('a showcase holds three earned awards', () async {
    rewards.earned.addAll(['grinder_1', 'champion_1', 'crew_1', 'photo_finish']);
    await rewards.setShowcase(['grinder_1', 'iron_will_5', 'champion_1', 'crew_1', 'photo_finish']);
    expect(rewards.showcase, ['grinder_1', 'champion_1', 'crew_1']);
    expect(rewards.toServer()['showcase'], ['grinder_1', 'champion_1', 'crew_1']);
  });

  test('Buzzer Beater: behind or level five seconds from the end, then ahead', () {
    // Level at 55 s (two each), then two more of mine.
    expect(tookLeadLate([10000, 50000, 56000, 58000], [20000, 40000]), isTrue);
    // Ahead the whole way.
    expect(tookLeadLate([10000, 20000, 30000], [40000]), isFalse);
    // Behind all along and still behind.
    expect(tookLeadLate([58000], [10000, 20000]), isFalse);
  });

  testWidgets('every award has a name and a line in every language', (tester) async {
    for (final locale in L.supportedLocales) {
      final l = await L.delegate.load(locale);
      for (final t in kTitles) {
        expect(awardNameOf(l, t.id), isNotEmpty, reason: '${t.id} in $locale');
        expect(awardLineOf(l, t.id), isNotEmpty, reason: '${t.id} in $locale');
      }
    }
  });

  testWidgets('a medal draws, earned and locked', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildTheme(Brightness.dark),
        localizationsDelegates: const [L.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate],
        home: const Scaffold(
          body: Row(
            children: [
              Medal(tier: 2, glyph: AwardGlyph.fist),
              Medal(tier: 4, glyph: AwardGlyph.ghost, locked: true),
            ],
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(Medal), findsNWidgets(2));
  });
}
