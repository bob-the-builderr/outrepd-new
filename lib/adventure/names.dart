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

/// What a level's monster is called: its world's creature in the form it has
/// reached (AdventureLevel.form, drawn in golem.dart). A Warden is the first
/// sight of the next form, and says so.
String monsterName(L l, AdventureLevel level) {
  final forms = switch (level.world) {
    0 => [
      l.monsterPebbleGolem,
      l.monsterStoneGolem,
      l.monsterOreGolem,
      l.monsterMinerGolem,
      l.monsterIronColossus,
    ],
    1 => [
      l.monsterScarabGrub,
      l.monsterScarab,
      l.monsterHornedScarab,
      l.monsterScarabWarrior,
      l.monsterScarabPharaoh,
    ],
    2 => [
      l.monsterYetiCub,
      l.monsterYeti,
      l.monsterHornedYeti,
      l.monsterFrostYeti,
      l.monsterYetiChieftain,
    ],
    3 => [
      l.monsterGoldRecruit,
      l.monsterGoldSoldier,
      l.monsterGoldGuard,
      l.monsterGoldKnight,
      l.monsterGoldKing,
    ],
    4 => [
      l.monsterWisp,
      l.monsterShade,
      l.monsterWraith,
      l.monsterIceSpecter,
      l.monsterFrostLich,
    ],
    5 => [
      l.monsterCrystalHatchling,
      l.monsterCrystalWhelp,
      l.monsterCrystalDrake,
      l.monsterCrystalDragon,
      l.monsterDiamondWyrm,
    ],
    _ => [
      l.monsterShadowSquire,
      l.monsterShadowGuard,
      l.monsterShadowKnight,
      l.monsterShadowLord,
      l.monsterTheMaster,
    ],
  };
  final name = forms[level.form - 1];
  return level.kind == FightKind.elite ? l.monsterWarden(name) : name;
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
