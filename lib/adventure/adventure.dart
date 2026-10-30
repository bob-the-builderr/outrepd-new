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

/// The first world's fights are a minute, the same window a duel is. Each
/// world after it adds [kFightLengthPerWorld], to a minute and a half in the
/// last: the user found the climb too slow (2026-10-28), and a minute caps
/// what any level can ask at about sixty push-ups.
const kFightLength = Duration(seconds: 60);
const kFightLengthPerWorld = Duration(seconds: 5);

/// How much more a monster takes from its world's own weapon than the curve
/// ([parReps]) says: about what the next weapon takes off, so the curve is
/// the fight for whoever has that one, and harder without it.
const kOwnWeaponMargin = 1.2;

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
///
/// Each world's monsters are made of that world's metal and only take hits
/// from a weapon of it or better (see [AdventureLevel.weaponNeeded]). That is
/// what a weapon is for: the next world stays shut until its stars are won.
/// Past that a better weapon helps, but only a little — each hits about a
/// fifth harder than the one before it.
class Weapon {
  const Weapon(this.index, this.damage, this.stars);

  /// Its place in [kWeapons]; names, colours and drawings key off it.
  final int index;

  /// Taken off the monster's HP by every push-up.
  final int damage;

  /// Stars needed to unlock it.
  final int stars;
}

/// One per world, and a last one past Master for whoever three-stars enough.
/// Each world's weapon asks for a star and a half a level over the worlds
/// before it: a world won on one star a fight leaves the next one shut, and
/// earlier levels have to be fought again, faster, to open it.
const kWeapons = <Weapon>[
  Weapon(0, 10, 0),
  Weapon(1, 12, 30),
  Weapon(2, 15, 60),
  Weapon(3, 18, 90),
  Weapon(4, 22, 120),
  Weapon(5, 27, 150),
  Weapon(6, 33, 180),
  Weapon(7, 40, 300),
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

  /// Which of its world's five forms the monster is in, 1 to 5: a new one
  /// every five levels, the Warden at 5, 10 and 15 the first sight of the
  /// next, and the King at 20 the last (lib/adventure/golem.dart).
  int get form => kind == FightKind.boss
      ? 5
      : (inWorld - 1) ~/ 5 + 1 + (kind == FightKind.elite ? 1 : 0);

  Duration get time => kFightLength + kFightLengthPerWorld * world;

  /// The weakest weapon that hurts this world's monsters: its own metal.
  Weapon get weaponNeeded => kWeapons[world];

  /// Whether [weapon] can hurt it at all.
  bool canBeHurtBy(Weapon weapon) => weapon.index >= weaponNeeded.index;

  /// What each push-up takes off it with [weapon]: nothing below its metal.
  int damageFrom(Weapon weapon) => canBeHurtBy(weapon) ? weapon.damage : 0;

  /// Push-ups it takes with [weapon], or null when [weapon] cannot hurt it.
  int? repsWith(Weapon weapon) =>
      canBeHurtBy(weapon) ? (hp / weapon.damage).ceil() : null;

  bool get isLast => number == kAdventureLevels;

  static AdventureLevel of(int number) =>
      _levels[(number - 1).clamp(0, kAdventureLevels - 1)];

  static List<AdventureLevel> get all => _levels;
}

/// How many push-ups level [n] asks for in its fight from a lifter holding the
/// next weapon: five at the first level and ninety at the last, in even steps —
/// about seventeen by the first boss, forty by the third, sixty-six by the
/// fifth — with a step into every fifth fight and a bigger one into each
/// boss. The steps are counted in, never subtracted out again, so the level
/// after a boss is still harder than the boss. (Until 2026-10-28 it was
/// sixty at the end on a curve that started slowly; the user found it slow.)
@visibleForTesting
double parReps(int n) {
  double steps(int n) => (n - 1) + 1.5 * (n ~/ 5) + 4.0 * (n ~/ kLevelsPerWorld);
  final share = steps(n) / steps(kAdventureLevels);
  return 5 + 85 * share;
}

final List<AdventureLevel> _levels = () {
  final out = <AdventureLevel>[];
  var last = 0;
  for (var n = 1; n <= kAdventureLevels; n++) {
    // Sized so that the curve above is what a lifter holding the next weapon
    // does — the one most have by then — and the world's own weapon, the
    // weakest that can hurt it, asks [kOwnWeaponMargin] times that (the
    // user, 2026-10-28: make up for what the weapons take off).
    final world = (n - 1) ~/ kLevelsPerWorld;
    var hp = (parReps(n) * kOwnWeaponMargin * kWeapons[world].damage).round();
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

/// How far this account has got: the best stars on every level won.
///
/// Kept on the phone so a fight with no signal still counts, and on the
/// account so a new phone, or a reinstall, picks up where the last one left
/// off. The two are merged level by level, the best of each, so neither side
/// ever takes stars off the other.
class Adventure extends ChangeNotifier {
  Adventure._();

  static final instance = Adventure._();

  static const _key = 'adventureStars';

  /// Whose stars these are: the account they were last merged with. Stars on
  /// this phone from a different account are that account's, not this one's.
  static const _ownerKey = 'adventureOwner';

  List<int> _stars = [];
  String? _owner;

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

  /// Open, and the weapon in hand can hurt what is in it.
  bool canFight(int level) =>
      playable(level) && AdventureLevel.of(level).canBeHurtBy(weapon);

  Weapon get weapon => staged ?? weaponFor(totalStars);

  /// Promo: the weapon picked on the setup screen, in place of the one the
  /// stars would give.
  Weapon? staged;

  Weapon? get nextWeapon =>
      weapon.index + 1 < kWeapons.length ? kWeapons[weapon.index + 1] : null;

  Future<void> load() async {
    final store = await SharedPreferences.getInstance();
    _stars = _parse(store.getString(_key));
    _owner = store.getString(_ownerKey);
    notifyListeners();
  }

  static List<int> _parse(String? raw) => [
    for (final part in (raw ?? '').split(','))
      if (int.tryParse(part.trim()) case final s?) s.clamp(0, 3),
  ];

  /// The best of [a] and [b] on every level.
  @visibleForTesting
  static List<int> merge(List<int> a, List<int> b) => [
    for (var i = 0; i < math.max(a.length, b.length); i++)
      math.max(i < a.length ? a[i] : 0, i < b.length ? b[i] : 0).clamp(0, 3),
  ];

  Future<void> _save() async {
    try {
      final store = await SharedPreferences.getInstance();
      await store.setString(_key, _stars.join(','));
      if (_owner case final owner?) {
        await store.setString(_ownerKey, owner);
      } else {
        await store.remove(_ownerKey);
      }
    } on Object catch (error) {
      // The fight still happened on screen; a phone that cannot write it down
      // loses the stars at the next launch, not the session.
      debugPrint('Could not save the adventure: $error');
    }
  }

  /// Writes down a fight won with [stars]. Keeps the best of the old and the
  /// new, and hands back the weapon this unlocked, if it unlocked one. The
  /// promo has no account to tell.
  Future<Weapon?> record(int level, int stars) async {
    if (level < 1 || level > kAdventureLevels || stars < 1) return null;
    final before = weapon;
    while (_stars.length < level) {
      _stars.add(0);
    }
    if (stars <= _stars[level - 1]) return null;
    _stars[level - 1] = stars;
    notifyListeners();
    await _save();
    final after = weapon;
    return after.index > before.index ? after : null;
  }

  /// Puts the map in a known state for a test or a screenshot.
  @visibleForTesting
  void debugSet(List<int> stars, {String? owner}) {
    _stars = List.of(stars);
    _owner = owner;
    notifyListeners();
  }
}
