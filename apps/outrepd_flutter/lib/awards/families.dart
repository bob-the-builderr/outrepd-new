/// Awards, rebuilt (the user's picks, 2026-11-09): fourteen families of five
/// tiers each — Bronze, Silver, Gold, Platinum, Diamond — and three specials.
/// Every tier is a title to wear. The titles of before stay earned: each one
/// that has a family here counts as that family's tier (kLegacyToFamily), and
/// the rest can still be worn.
library;

/// What a family counts.
enum AwardKind {
  reps,
  streak,
  wins,
  winRun,
  best,
  giant,
  clean,
  challengers,
  pastSelf,
  worlds,
  goalDays,
  early,
  late,
  friends,
}

/// The medal's drawing (lib/awards/medal.dart).
enum AwardGlyph {
  fist,
  flame,
  crown,
  bolt,
  chart,
  sword,
  shield,
  link,
  ghost,
  castle,
  target,
  sun,
  moon,
  people,
  one,
  clock,
}

class AwardFamily {
  const AwardFamily(this.id, this.name, this.glyph, this.kind, this.tiers, {this.isNew = false});

  final String id;

  /// What the title says, with the tier's numeral after it. Like the titles
  /// before it, a name and not a sentence: it is the same in every language.
  final String name;
  final AwardGlyph glyph;
  final AwardKind kind;

  /// What each tier asks, Bronze first.
  final List<int> tiers;

  /// Came with this rebuild: the Awards screen says so.
  final bool isNew;

  /// The id of tier [tier] (0–4).
  String idOf(int tier) => '${id}_${tier + 1}';
}

const kAwardFamilies = <AwardFamily>[
  AwardFamily('grinder', 'Grinder', AwardGlyph.fist, AwardKind.reps, [100, 1000, 5000, 10000, 50000]),
  AwardFamily('iron_will', 'Iron Will', AwardGlyph.flame, AwardKind.streak, [7, 14, 30, 100, 365]),
  AwardFamily('champion', 'Champion', AwardGlyph.crown, AwardKind.wins, [1, 10, 50, 200, 500]),
  AwardFamily('on_fire', 'On Fire', AwardGlyph.bolt, AwardKind.winRun, [3, 5, 10, 15, 20]),
  AwardFamily('personal_best', 'Personal Best', AwardGlyph.chart, AwardKind.best, [20, 30, 40, 50, 60], isNew: true),
  AwardFamily('giant_slayer', 'Giant Slayer', AwardGlyph.sword, AwardKind.giant, [1, 5, 10, 25, 50]),
  AwardFamily('clean_form', 'Clean Form', AwardGlyph.shield, AwardKind.clean, [1, 10, 50, 100, 250]),
  AwardFamily('challenger', 'Challenger', AwardGlyph.link, AwardKind.challengers, [1, 5, 20, 50, 100], isNew: true),
  AwardFamily('past_self', 'Past Self', AwardGlyph.ghost, AwardKind.pastSelf, [1, 3, 6, 12, 26], isNew: true),
  AwardFamily('adventurer', 'Adventurer', AwardGlyph.castle, AwardKind.worlds, [1, 2, 4, 6, 7], isNew: true),
  AwardFamily('daily_goal', 'Daily Goal', AwardGlyph.target, AwardKind.goalDays, [7, 30, 100, 200, 365], isNew: true),
  AwardFamily('early_bird', 'Early Bird', AwardGlyph.sun, AwardKind.early, [10, 25, 50, 100, 250]),
  AwardFamily('night_owl', 'Night Owl', AwardGlyph.moon, AwardKind.late, [10, 25, 50, 100, 250]),
  AwardFamily('crew', 'Crew', AwardGlyph.people, AwardKind.friends, [1, 5, 10, 25, 50]),
];

/// One of a kind: judged by the match that did it.
class AwardSpecial {
  const AwardSpecial(this.id, this.name, this.glyph, this.tier, {this.isNew = false});

  final String id;
  final String name;
  final AwardGlyph glyph;

  /// The metal it is struck in.
  final int tier;
  final bool isNew;
}

const kPhotoFinish = 'photo_finish';
const kBuzzerBeater = 'buzzer_beater';
const kMonthChampion = 'month_champion';

const kAwardSpecials = <AwardSpecial>[
  AwardSpecial(kPhotoFinish, 'Photo Finish', AwardGlyph.one, 2, isNew: true),
  AwardSpecial(kBuzzerBeater, 'Buzzer Beater', AwardGlyph.clock, 3, isNew: true),
  AwardSpecial(kMonthChampion, 'Month Champion', AwardGlyph.crown, 4),
];

/// How many there are to earn.
final int kAwardCount = kAwardFamilies.length * 5 + kAwardSpecials.length;

const _numerals = ['I', 'II', 'III', 'IV', 'V'];

/// "Grinder III".
String awardTitle(AwardFamily family, int tier) => '${family.name} ${_numerals[tier]}';

/// The title of before that each family tier stands for: whoever held it holds
/// the tier. Titles with no family here (matches played, tiers reached, the
/// perfect weeks…) stay earned and wearable as they were.
const kLegacyToFamily = <String, String>{
  'first_win': 'champion_1',
  'on_a_roll': 'on_fire_1',
  'five_straight': 'on_fire_2',
  'unstoppable': 'on_fire_3',
  'untouchable': 'on_fire_5',
  'giant_slayer': 'giant_slayer_1',
  'hundred_reps': 'grinder_1',
  'five_hundred': 'grinder_1',
  'the_machine': 'grinder_2',
  'five_thousand': 'grinder_3',
  'ten_thousand': 'grinder_4',
  'fifty_thousand': 'grinder_5',
  'no_days_off': 'iron_will_1',
  'fortnight': 'iron_will_2',
  'unbroken': 'iron_will_3',
  'sixty_days': 'iron_will_3',
  'hundred_days': 'iron_will_4',
  'year_round': 'iron_will_5',
  'clean_hands': 'clean_form_1',
  'spotless': 'clean_form_2',
  'textbook': 'clean_form_3',
  'early_bird': 'early_bird_1',
  'sunrise_club': 'early_bird_3',
  'night_owl': 'night_owl_1',
  'graveyard': 'night_owl_3',
  'not_alone': 'crew_1',
  'well_connected': 'crew_3',
  'the_gym_knows': 'crew_5',
};

/// The family and tier an id names, or null for one that is not a tier.
({AwardFamily family, int tier})? familyTierOf(String id) {
  for (final f in kAwardFamilies) {
    for (var t = 0; t < 5; t++) {
      if (f.idOf(t) == id) return (family: f, tier: t);
    }
  }
  return null;
}

AwardSpecial? specialOf(String id) {
  for (final s in kAwardSpecials) {
    if (s.id == id) return s;
  }
  return null;
}

/// The highest tier of [family] in [earned], -1 for none.
int tierHeld(AwardFamily family, Set<String> earned) {
  for (var t = 4; t >= 0; t--) {
    if (earned.contains(family.idOf(t))) return t;
  }
  return -1;
}

/// What the numbers say about each family: the ids of every tier reached.
Iterable<String> tiersReached(AwardFamily family, int value) sync* {
  for (var t = 0; t < 5; t++) {
    if (value >= family.tiers[t]) yield family.idOf(t);
  }
}

/// [mine] took the lead over [theirs] in the last [window] of a [length]
/// round and won it: level or behind at its start, ahead at the end. Rep
/// times are milliseconds from the start of the round.
bool tookLeadLate(
  List<int> mine,
  List<int> theirs, {
  int length = 60000,
  int window = 5000,
}) {
  if (mine.isEmpty || theirs.isEmpty) return false;
  final at = length - window;
  final mineThen = mine.where((t) => t <= at).length;
  final theirsThen = theirs.where((t) => t <= at).length;
  return mineThen <= theirsThen && mine.length > theirs.length;
}
