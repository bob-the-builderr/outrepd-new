/// Which lifter parts this account may wear: everything free, the earned
/// parts it has earned, and the Pro parts while it is Pro.
///
/// Earned parts are won in the app and never bought (the user's rule,
/// 2026-11-01), so every check here reads something the account already
/// keeps: its Adventure stars, its record, its level, its training streak
/// and its month awards.
library;

import '../adventure/adventure.dart';
import '../adventure/names.dart';
import '../backend/backend.dart';
import '../data.dart';
import '../l10n/app_localizations.dart';
import '../rewards.dart';
import '../subscription.dart';
import '../widgets.dart';
import '../xp.dart';
import 'catalog.dart';

/// What the account has done, read once when the maker opens.
class UnlockState {
  const UnlockState({
    this.worldsCleared = const {},
    this.peakTier = 0,
    this.level = 1,
    this.wins = 0,
    this.bestWinStreak = 0,
    this.bestDayStreak = 0,
    this.threeStarLevels = 0,
    this.allStars = false,
    this.awards = const {},
    this.pro = false,
  });

  /// Adventure worlds (1–7) with every level won.
  final Set<int> worldsCleared;
  final int peakTier;
  final int level;
  final int wins;
  final int bestWinStreak;
  final int bestDayStreak;
  final int threeStarLevels;
  final bool allStars;

  /// The month awards this account has finished with.
  final Set<SeasonAwardKind> awards;
  final bool pro;

  /// Read from what this phone already holds, and the month awards from the
  /// server when there is one. An award that cannot be read leaves its parts
  /// locked, never the maker closed.
  static Future<UnlockState> read() async {
    final adventure = Adventure.instance;
    final me = backend.me;
    var awards = const <SeasonAwardKind>{};
    if (backend.available) {
      try {
        awards = {for (final a in await backend.mySeasonAwards()) a.kind};
      } on Object {
        awards = const {};
      }
    }
    return UnlockState(
      worldsCleared: {
        for (var w = 1; w <= kWorlds; w++)
          if (_worldCleared(adventure, w)) w,
      },
      peakTier: me?.peakTierIdx ?? demoProfile.tierIdx,
      level: levelOf(demoProfile.xp),
      wins: me?.wins ?? demoProfile.wins,
      bestWinStreak: me?.bestStreak ?? demoProfile.bestStreak,
      bestDayStreak: rewards.bestStreak > rewards.streak ? rewards.bestStreak : rewards.streak,
      threeStarLevels: [
        for (var n = 1; n <= kAdventureLevels; n++)
          if (adventure.starsAt(n) >= 3) n,
      ].length,
      allStars: adventure.totalStars >= kAdventureLevels * 3,
      awards: awards,
      pro: Subscription.instance.active,
    );
  }

  static bool _worldCleared(Adventure adventure, int world) {
    for (var i = 1; i <= kLevelsPerWorld; i++) {
      if (!adventure.cleared((world - 1) * kLevelsPerWorld + i)) return false;
    }
    return true;
  }

  /// Whether [part] may be worn now.
  bool owns(LifterPart part) {
    if (part.pro) return pro;
    final unlock = part.unlock;
    if (unlock == null) return true;
    final n = unlock.n;
    return switch (unlock.kind) {
      UnlockKind.world => worldsCleared.contains(n),
      UnlockKind.tier => peakTier >= n,
      UnlockKind.level => level >= n,
      UnlockKind.wins => wins >= n,
      UnlockKind.winStreak => bestWinStreak >= n,
      UnlockKind.dayStreak => bestDayStreak >= n,
      UnlockKind.monthTop10 => awards.any((a) => a != SeasonAwardKind.regular),
      UnlockKind.monthPodium =>
        awards.contains(SeasonAwardKind.podium) || awards.contains(SeasonAwardKind.champion),
      UnlockKind.monthChampion => awards.contains(SeasonAwardKind.champion),
      UnlockKind.starredLevels => threeStarLevels >= n,
      UnlockKind.allStars => allStars,
    };
  }

  /// [lifter] with every part it may not wear swapped for what it wore
  /// before ([fallback]), or the first free one: what is saved.
  Lifter keepOwned(Lifter lifter, Lifter fallback) {
    int pick(List<LifterPart> list, int i, int was) =>
        owns(list[i]) ? i : (owns(list[was]) ? was : 0);
    return lifter.copyWith(
      skin: pick(kSkins, lifter.skin, fallback.skin),
      eyes: pick(kEyes, lifter.eyes, fallback.eyes),
      mouth: pick(kMouths, lifter.mouth, fallback.mouth),
      top: pick(kTops, lifter.top, fallback.top),
      gear: pick(kGear, lifter.gear, fallback.gear),
      pattern: pick(kPatterns, lifter.pattern, fallback.pattern),
    );
  }
}

/// What a locked part asks for, said the way the maker shows it under the
/// lifter: "Clear Iron Mines", "Reach Gold", "Win 50 matches".
String unlockText(L l, Unlock unlock) {
  final n = unlock.n;
  return switch (unlock.kind) {
    UnlockKind.world => l.lifterNeedsWorld(worldName(l, n - 1)),
    UnlockKind.tier => l.lifterNeedsTier(tierName(l, n)),
    UnlockKind.level => l.lifterNeedsLevel('$n'),
    UnlockKind.wins => l.lifterNeedsWins('$n'),
    UnlockKind.winStreak => l.lifterNeedsWinStreak('$n'),
    UnlockKind.dayStreak => l.lifterNeedsDayStreak('$n'),
    UnlockKind.monthTop10 => l.lifterNeedsMonthTop10,
    UnlockKind.monthPodium => l.lifterNeedsMonthPodium,
    UnlockKind.monthChampion => l.lifterNeedsMonthChampion,
    UnlockKind.starredLevels => l.lifterNeedsStars('$n'),
    UnlockKind.allStars => l.lifterNeedsAllStars,
  };
}
