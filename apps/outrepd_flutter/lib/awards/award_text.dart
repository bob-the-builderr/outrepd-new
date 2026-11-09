/// The awards in the reader's language: each family's and special's name,
/// and what each tier asks.
library;

import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import 'families.dart';

String familyName(L l, AwardFamily f) => switch (f.id) {
  'grinder' => l.awGrinder,
  'iron_will' => l.awIronWill,
  'champion' => l.awChampion,
  'on_fire' => l.awOnFire,
  'personal_best' => l.awPersonalBest,
  'giant_slayer' => l.awGiantSlayer,
  'clean_form' => l.awCleanForm,
  'challenger' => l.awChallenger,
  'past_self' => l.awPastSelf,
  'adventurer' => l.awAdventurer,
  'daily_goal' => l.awDailyGoal,
  'early_bird' => l.awEarlyBird,
  'night_owl' => l.awNightOwl,
  'crew' => l.awCrew,
  _ => f.name,
};

String specialName(L l, AwardSpecial s) => switch (s.id) {
  kPhotoFinish => l.awPhotoFinish,
  kBuzzerBeater => l.awBuzzerBeater,
  kMonthChampion => l.awMonthChampion,
  _ => s.name,
};

String specialLine(L l, AwardSpecial s) => switch (s.id) {
  kPhotoFinish => l.awDoPhotoFinish,
  kBuzzerBeater => l.awDoBuzzer,
  kMonthChampion => l.awDoMonthChampion,
  _ => s.name,
};

/// What a family counts, with [n]: "Push-ups: 5,000".
String familyLine(L l, AwardFamily f, int n) {
  final v = NumberFormat.decimalPattern(l.localeName).format(n);
  return switch (f.kind) {
    AwardKind.reps => l.awDoReps(v),
    AwardKind.streak => l.awDoStreak(v),
    AwardKind.wins => l.awDoWins(v),
    AwardKind.winRun => l.awDoWinRun(v),
    AwardKind.best => l.awDoBest(v),
    AwardKind.giant => l.awDoGiant(v),
    AwardKind.clean => l.awDoClean(v),
    AwardKind.challengers => l.awDoChallengers(v),
    AwardKind.pastSelf => l.awDoPastSelf(v),
    AwardKind.worlds => l.awDoWorlds(v),
    AwardKind.goalDays => l.awDoGoal(v),
    AwardKind.early => l.awDoEarly(v),
    AwardKind.late => l.awDoLate(v),
    AwardKind.friends => l.awDoFriends(v),
  };
}

/// The tier's metal: Bronze to Diamond, the words the ranks use.
String tierWord(L l, int tier) => switch (tier) {
  0 => l.tierBronze,
  1 => l.tierSilver,
  2 => l.tierGold,
  3 => l.tierPlatinum,
  _ => l.tierDiamond,
};

const _numerals = ['I', 'II', 'III', 'IV', 'V'];

/// An award's title in the reader's language, or null for an id that is not
/// one of the awards.
String? awardNameOf(L l, String id) {
  if (familyTierOf(id) case final held?) {
    return '${familyName(l, held.family)} ${_numerals[held.tier]}';
  }
  if (specialOf(id) case final s?) return specialName(l, s);
  return null;
}

/// What an award asks, or null for an id that is not one of the awards.
String? awardLineOf(L l, String id) {
  if (familyTierOf(id) case final held?) {
    return familyLine(l, held.family, held.family.tiers[held.tier]);
  }
  if (specialOf(id) case final s?) return specialLine(l, s);
  return null;
}
