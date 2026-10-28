/// What the adventure's worlds, monsters and weapons are called, in the
/// lifter's language.
library;

import '../l10n/app_localizations.dart';
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

/// What a level's monster is called: its world's creature (golem.dart), and
/// how far it has grown — the regular fight, the Warden, the King.
String monsterName(L l, AdventureLevel level) {
  final (regular, warden, king) = switch (level.world) {
    0 => (l.monsterRockGolem, l.monsterOreBrute, l.monsterIronColossus),
    1 => (l.monsterScarab, l.monsterScarabGuard, l.monsterScarabPharaoh),
    2 => (l.monsterYeti, l.monsterFrostYeti, l.monsterYetiChieftain),
    3 => (l.monsterGoldSoldier, l.monsterGoldKnight, l.monsterGoldKing),
    4 => (l.monsterWisp, l.monsterWraith, l.monsterFrostLich),
    5 => (l.monsterCrystalDrake, l.monsterCrystalDragon, l.monsterDiamondWyrm),
    _ => (l.monsterShadowGuard, l.monsterShadowKnight, l.monsterTheMaster),
  };
  return switch (level.kind) {
    FightKind.regular => regular,
    FightKind.elite => warden,
    FightKind.boss => king,
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
