/// Adventure: seven worlds of twenty fights, one world per tier from Iron to
/// Master, and a monster in every one of them.
///
/// The camera counts push-ups exactly as it does in a match. This file only
/// turns the count into damage, decides how much each monster can take, and
/// remembers how far the lifter has got. Nothing here touches the rank: an
/// adventure is practice with something to hit.
library;

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kWorlds = 7;
const kLevelsPerWorld = 20;
const kAdventureLevels = kWorlds * kLevelsPerWorld;
const kMaxStars = kAdventureLevels * 3;

/// Every fight is a minute, the same window a duel is: what changes from one
/// level to the next is how much the monster can take in it.
const kFightLength = Duration(seconds: 60);

enum FightKind {
  regular,

  /// Every fifth level: a bigger step up than the levels around it.
  elite,

  /// The twentieth level of each world: the biggest step of all, and the
  /// door to the next world.
  boss,
}

/// What the lifter hits with. Unlocked by stars, never bought: the best one
/// unlocked is the one in hand, so there is nothing to equip by mistake.
class Weapon {
  const Weapon(this.index, this.damage, this.stars);

  /// Its place in [kWeapons]; names, colours and drawings key off it.
  final int index;

  /// Taken off the monster's HP by every push-up.
  final int damage;

  /// Stars needed to unlock it.
  final int stars;
}

/// One per tier and a last one past Master.
const kWeapons = <Weapon>[
  Weapon(0, 10, 0),
  Weapon(1, 13, 12),
  Weapon(2, 17, 30),
  Weapon(3, 22, 60),
  Weapon(4, 28, 100),
  Weapon(5, 36, 150),
  Weapon(6, 46, 220),
  Weapon(7, 60, 300),
];

/// The best weapon [stars] unlock.
Weapon weaponFor(int stars) => kWeapons.lastWhere((w) => stars >= w.stars);

class AdventureLevel {
  const AdventureLevel._(this.number, this.hp);

  /// 1 to [kAdventureLevels].
  final int number;

  /// What the monster can take. Rises with every level, without exception:
  /// each fight asks for more than the one before it.
  final int hp;

  /// 0 to 6, and the tier the world is drawn in.
  int get world => (number - 1) ~/ kLevelsPerWorld;

  /// 1 to 20 within its world.
  int get inWorld => (number - 1) % kLevelsPerWorld + 1;

  FightKind get kind => number % kLevelsPerWorld == 0
      ? FightKind.boss
      : number % 5 == 0
      ? FightKind.elite
      : FightKind.regular;

  Duration get time => kFightLength;

  /// Push-ups it takes with [weapon].
  int repsWith(Weapon weapon) => (hp / weapon.damage).ceil();

  bool get isLast => number == kAdventureLevels;

  static AdventureLevel of(int number) =>
      _levels[(number - 1).clamp(0, kAdventureLevels - 1)];

  static List<AdventureLevel> get all => _levels;
}

/// How many push-ups level [n] asks for in its minute, with the weapon a
/// lifter earning two stars a level would be holding by then: five at the
/// first level and sixty at the last, climbing faster as it goes, with a step
/// into every fifth fight and a bigger one into each boss. The steps are
/// counted in, never subtracted out again, so the level after a boss is
/// still harder than the boss.
@visibleForTesting
double parReps(int n) {
  double steps(int n) => (n - 1) + 1.5 * (n ~/ 5) + 4.0 * (n ~/ kLevelsPerWorld);
  final share = steps(n) / steps(kAdventureLevels);
  return 5 + 55 * math.pow(share, 1.2);
}

final List<AdventureLevel> _levels = () {
  final out = <AdventureLevel>[];
  var last = 0;
  for (var n = 1; n <= kAdventureLevels; n++) {
    // Damage rises in jumps as weapons unlock, and HP rises with it, so the
    // push-ups asked for stay on the curve above for a lifter on two stars a
    // level. More stars than that make it easier; fewer, harder.
    var hp = (parReps(n) * weaponFor(2 * (n - 1)).damage).round();
    if (hp <= last) hp = last + 1;
    out.add(AdventureLevel._(n, hp));
    last = hp;
  }
  return out;
}();

/// Share of the minute that has to be left for two stars, and for three.
const kTwoStarShare = 0.2;
const kThreeStarShare = 0.4;

/// Stars for a fight won with [left] of [time] still on the clock: one for
/// winning it, two with a fifth of the minute to spare, three with two fifths.
int starsFor(Duration left, Duration time) {
  final share = left.inMilliseconds / time.inMilliseconds;
  return share >= kThreeStarShare
      ? 3
      : share >= kTwoStarShare
      ? 2
      : 1;
}

/// How much of [time] has to be left for [stars].
Duration leftFor(int stars, Duration time) => switch (stars) {
  3 => time * kThreeStarShare,
  2 => time * kTwoStarShare,
  _ => Duration.zero,
};

/// How far this phone has got: the best stars on every level won.
///
/// Kept on the phone, like the streak. An adventure moves nothing anybody
/// else can see, so there is nothing for a server to referee.
class Adventure extends ChangeNotifier {
  Adventure._();

  static final instance = Adventure._();

  static const _key = 'adventureStars';

  List<int> _stars = [];

  int starsAt(int level) =>
      level >= 1 && level <= _stars.length ? _stars[level - 1] : 0;

  bool cleared(int level) => starsAt(level) > 0;

  int get totalStars => _stars.fold(0, (sum, s) => sum + s);

  int get clearedCount => _stars.where((s) => s > 0).length;

  /// The first level not yet won: the one the map opens on and the Match tab
  /// offers. The last one again once every level is won.
  int get current {
    for (var n = 1; n <= kAdventureLevels; n++) {
      if (!cleared(n)) return n;
    }
    return kAdventureLevels;
  }

  /// Won levels can be fought again for more stars; the next one is open;
  /// everything past it waits.
  bool playable(int level) => level >= 1 && level <= current;

  Weapon get weapon => weaponFor(totalStars);

  Weapon? get nextWeapon =>
      weapon.index + 1 < kWeapons.length ? kWeapons[weapon.index + 1] : null;

  Future<void> load() async {
    final store = await SharedPreferences.getInstance();
    _stars = _parse(store.getString(_key));
    notifyListeners();
  }

  static List<int> _parse(String? raw) => [
    for (final part in (raw ?? '').split(','))
      if (int.tryParse(part.trim()) case final s?) s.clamp(0, 3),
  ];

  /// Writes down a fight won with [stars]. Keeps the best of the old and the
  /// new, and hands back the weapon this unlocked, if it unlocked one.
  Future<Weapon?> record(int level, int stars) async {
    if (level < 1 || level > kAdventureLevels || stars < 1) return null;
    final before = weapon;
    while (_stars.length < level) {
      _stars.add(0);
    }
    if (stars <= _stars[level - 1]) return null;
    _stars[level - 1] = stars;
    notifyListeners();
    try {
      final store = await SharedPreferences.getInstance();
      await store.setString(_key, _stars.join(','));
    } on Object catch (error) {
      // The fight still happened on screen; a phone that cannot write it down
      // loses the stars at the next launch, not the session.
      debugPrint('Could not save the adventure: $error');
    }
    final after = weapon;
    return after.index > before.index ? after : null;
  }

  /// Puts the map in a known state for a test or a screenshot.
  @visibleForTesting
  void debugSet(List<int> stars) {
    _stars = List.of(stars);
    notifyListeners();
  }
}
