/// What the adventure's worlds, monsters and weapons are called, in the
/// lifter's language.
library;

import '../l10n/app_localizations.dart';
import '../widgets.dart' show tierName;
import 'adventure.dart';

String worldName(L l, int world) => switch (world) {
  0 => l.worldIron,
  1 => l.worldBronze,
  2 => l.worldSilver,
  3 => l.worldGold,
  4 => l.worldPlatinum,
  5 => l.worldDiamond,
  _ => l.worldMaster,
};

/// "Iron Golem", "Gold Warden", "Master King": the world's metal and what
/// kind of fight it is.
String monsterName(L l, AdventureLevel level) {
  final tier = tierName(l, level.world);
  return switch (level.kind) {
    FightKind.regular => l.monsterGolem(tier),
    FightKind.elite => l.monsterWarden(tier),
    FightKind.boss => l.monsterKing(tier),
  };
}

String weaponName(L l, Weapon weapon) => switch (weapon.index) {
  0 => l.weaponGauntlets,
  1 => l.weaponKnuckles,
  2 => l.weaponFang,
  3 => l.weaponHammer,
  4 => l.weaponAxe,
  5 => l.weaponSpear,
  6 => l.weaponSword,
  _ => l.weaponCrownbreaker,
};
