/// Everything a lifter can be made of: the parts, their colours, how rare
/// each one is and what earns the ones that are earned (the user's catalog,
/// approved 2026-11-01). The drawing is in `lifter_art.dart`.
///
/// A part is saved on the account by its [LifterPart.id], never by its place
/// in a list, so adding parts later never changes anybody's lifter.
library;

enum Rarity { common, rare, epic, legendary }

/// What a locked part asks for. Checked in `unlocks.dart`.
enum UnlockKind {
  /// Every level of Adventure world [Unlock.n] (1–7) won.
  world,

  /// Rank tier [Unlock.n] reached at least once (3 = Gold … 6 = Master).
  tier,

  /// Level [Unlock.n] reached.
  level,

  /// [Unlock.n] matches won.
  wins,

  /// [Unlock.n] matches won in a row.
  winStreak,

  /// A training streak of [Unlock.n] days.
  dayStreak,

  /// A month finished in the top ten.
  monthTop10,

  /// A month finished on the podium.
  monthPodium,

  /// A month finished first.
  monthChampion,

  /// Three stars on [Unlock.n] Adventure levels.
  starredLevels,

  /// Every star in the Adventure.
  allStars,
}

class Unlock {
  const Unlock(this.kind, [this.n = 0]);
  final UnlockKind kind;
  final int n;
}

class LifterPart {
  const LifterPart(
    this.id, {
    this.color,
    this.fx,
    this.rarity = Rarity.common,
    this.unlock,
    this.pro = false,
  });

  /// Saved on the account; never renamed.
  final String id;

  /// A skin's colour, as `#RRGGBB`.
  final String? color;

  /// A skin's extra drawing (cracks, shine, circuits …).
  final String? fx;

  final Rarity rarity;

  /// Null for a part anybody can wear.
  final Unlock? unlock;

  /// OUTREPD Pro only.
  final bool pro;

  bool get earned => unlock != null;
}

const kSkins = <LifterPart>[
  LifterPart('porcelain', color: '#F7DCC6'),
  LifterPart('light', color: '#F2CFAE'),
  LifterPart('fair', color: '#E0A985'),
  LifterPart('golden', color: '#D9A06A'),
  LifterPart('olive', color: '#B08B5B'),
  LifterPart('tan', color: '#C68A5C'),
  LifterPart('brown', color: '#9C6440'),
  LifterPart('deep', color: '#6E4129'),
  LifterPart('dark', color: '#4A2A1A'),
  LifterPart('ebony', color: '#35201A'),
  LifterPart('stone', color: '#8D9099', fx: 'stone', rarity: Rarity.rare, unlock: Unlock(UnlockKind.world, 1)),
  LifterPart('bronze', color: '#B9733A', fx: 'metal', rarity: Rarity.rare, unlock: Unlock(UnlockKind.world, 2)),
  LifterPart('chrome', color: '#B8C2CC', fx: 'metal', rarity: Rarity.epic, unlock: Unlock(UnlockKind.world, 3)),
  LifterPart('gold', color: '#E2B23C', fx: 'metal', rarity: Rarity.epic, unlock: Unlock(UnlockKind.world, 4)),
  LifterPart('ice', color: '#BFE6F5', fx: 'ice', rarity: Rarity.epic, unlock: Unlock(UnlockKind.world, 5)),
  LifterPart('crystal', color: '#4FD1C5', fx: 'crystal', rarity: Rarity.legendary, unlock: Unlock(UnlockKind.world, 6)),
  LifterPart('lava', color: '#3A2A26', fx: 'lava', rarity: Rarity.legendary, unlock: Unlock(UnlockKind.world, 7)),
  LifterPart('cyborg', color: '#9FB4C2', fx: 'cyborg', rarity: Rarity.legendary, unlock: Unlock(UnlockKind.level, 30)),
  LifterPart('holo', color: '#C9B8F5', fx: 'holo', rarity: Rarity.epic, unlock: Unlock(UnlockKind.wins, 50)),
  LifterPart('shadow', color: '#26232E', fx: 'shadow', rarity: Rarity.legendary, unlock: Unlock(UnlockKind.monthTop10)),
  LifterPart('neon', color: '#1E1B33', fx: 'neon', pro: true),
  LifterPart('obsidian', color: '#1A1720', fx: 'obsidian', pro: true),
  LifterPart('cosmic', color: '#3B2A7A', fx: 'cosmic', pro: true),
  LifterPart('electric', color: '#2F6FD6', fx: 'electric', pro: true),
  // Creatures (the user's picks, 2026-11-04): each brings its own face —
  // pro_art.dart's proSkinFaces — and wears everything else over it.
  LifterPart('robot', color: '#9AA7B5', fx: 'robot', pro: true),
  LifterPart('zombie', color: '#93B07E', fx: 'zombie', pro: true),
  LifterPart('alien', color: '#A8E6A1', fx: 'alien', pro: true),
  LifterPart('skeleton', color: '#EDE6D6', fx: 'skeleton', pro: true),
  LifterPart('werewolf', color: '#8A7766', fx: 'werewolf', pro: true),
  LifterPart('reptile', color: '#5DA05A', fx: 'reptile', pro: true),
];

const kHair = <LifterPart>[
  LifterPart('bald'), LifterPart('buzz'), LifterPart('crew'), LifterPart('flat_top'),
  LifterPart('curls'), LifterPart('afro'), LifterPart('mohawk'), LifterPart('spikes'),
  LifterPart('slick_back'), LifterPart('man_bun'), LifterPart('dreads'), LifterPart('side_part'),
  LifterPart('long'), LifterPart('undercut'), LifterPart('waves'), LifterPart('cornrows'),
  LifterPart('pompadour'), LifterPart('faux_hawk'), LifterPart('twists'), LifterPart('messy'),
  // Pro (the user's picks, 2026-11-04; drawn in pro_art.dart).
  LifterPart('inferno', pro: true), LifterPart('galaxy_afro', pro: true),
  LifterPart('bolt_fade', pro: true), LifterPart('neon_dreads', pro: true),
];

const kHairColors = <String>[
  '#141010', '#3A2416', '#6B3E1F', '#8E3B1E', '#E3C27A', '#EDEAE4', '#9A9590',
  '#D23A22', '#3D6FD8', '#33B36B', '#E85D9C', '#8A4FD8', '#F08A24', '#23B5B5',
  // Pro: chrome, gold leaf, neon fade, sunset fade — see [kProHairColors].
  '#9DA9B6', '#D3961B', '#A65CFE', '#C2368B',
];

/// The Pro hair colours (the user's picks, 2026-11-04): a gradient each, by
/// its entry in [kHairColors]. That entry is the gradient's middle, and what
/// the hair's shading is worked out from; the drawing puts the gradient
/// where the colour itself would be (lifter_art.dart).
const kProHairColors = <String, ({List<String> stops, double x2, double y2})>{
  '#9DA9B6': (stops: ['#2E3842', '#FFFFFF', '#6E7A86', '#F4F8FB', '#3E4A56'], x2: 1, y2: 1),
  '#D3961B': (stops: ['#7A4E06', '#FFEFA8', '#D3961A', '#FFF8D6', '#9C6408'], x2: 1, y2: 1),
  '#A65CFE': (stops: ['#FF4FD8', '#A65CFF', '#4FD8FF'], x2: 1, y2: 0.5),
  '#C2368B': (stops: ['#3B1C6E', '#C2368A', '#FF7A3D', '#FFD36B'], x2: 0, y2: 1),
};

/// What the maker tries on and asks Pro for, when a Pro hair colour is picked.
const kProHairColourPart = LifterPart('pro_hair_colour', pro: true);

/// Whether [i] in [kHairColors] is a Pro one.
bool isProHairColour(int i) => kProHairColors.containsKey(kHairColors[i]);

const kEyes = <LifterPart>[
  LifterPart('focused'), LifterPart('angry'), LifterPart('calm'), LifterPart('wide'),
  LifterPart('wink'), LifterPart('zen'), LifterPart('side_eye'), LifterPart('squint'),
  LifterPart('sleepy'),
  LifterPart('fire', rarity: Rarity.rare, unlock: Unlock(UnlockKind.dayStreak, 7)),
  LifterPart('stars', rarity: Rarity.epic, unlock: Unlock(UnlockKind.starredLevels, 30)),
  LifterPart('laser', rarity: Rarity.legendary, unlock: Unlock(UnlockKind.dayStreak, 30)),
  LifterPart('glow', pro: true),
  LifterPart('hypno', pro: true), LifterPart('diamond_eyes', pro: true),
  LifterPart('snake_eyes', pro: true), LifterPart('electric', pro: true),
  LifterPart('gold_eyes', pro: true),
];

/// The eyes drawn shut: the blink of a lifter that moves.
const kEyesShut = 5;

const kBrows = <LifterPart>[
  LifterPart('heavy'), LifterPart('thin'), LifterPart('raised'), LifterPart('cut'),
  LifterPart('arched'), LifterPart('bushy'), LifterPart('double_cut'),
];

const kMouths = <LifterPart>[
  LifterPart('smirk'), LifterPart('grit'), LifterPart('grin'), LifterPart('roar'),
  LifterPart('mouthguard'), LifterPart('flat'), LifterPart('tongue'), LifterPart('shout'),
  LifterPart('grimace'), LifterPart('lip_bite'),
  LifterPart('gold_tooth', rarity: Rarity.rare, unlock: Unlock(UnlockKind.wins, 10)),
  LifterPart('diamond_grill', rarity: Rarity.legendary, unlock: Unlock(UnlockKind.wins, 100)),
  LifterPart('bubble_gum', pro: true), LifterPart('fangs', pro: true),
  LifterPart('fire_breath', pro: true), LifterPart('shark_grin', pro: true),
];

const kBeards = <LifterPart>[
  LifterPart('none'), LifterPart('stubble'), LifterPart('full'), LifterPart('goatee'),
  LifterPart('moustache'), LifterPart('chin_strap'), LifterPart('viking'), LifterPart('chops'),
  LifterPart('boxed'), LifterPart('anchor'), LifterPart('handlebar'), LifterPart('soul_patch'),
  LifterPart('flame_beard', pro: true), LifterPart('gold_braids', pro: true),
  LifterPart('frost_beard', pro: true), LifterPart('galaxy_beard', pro: true),
];

const kMarks = <LifterPart>[
  LifterPart('none'), LifterPart('scar'), LifterPart('eye_black'), LifterPart('war_paint'),
  LifterPart('freckles'), LifterPart('tattoo'), LifterPart('nose_tape'), LifterPart('sweat'),
  LifterPart('cheek_bandage'), LifterPart('nose_ring'), LifterPart('brow_piercing'),
  LifterPart('lightning_bolt', pro: true), LifterPart('face_gems', pro: true),
  LifterPart('gold_flakes', pro: true),
];

const kTops = <LifterPart>[
  LifterPart('shirtless'), LifterPart('tank'), LifterPart('stringer'), LifterPart('tee'),
  LifterPart('ringer'), LifterPart('muscle_tee'), LifterPart('polo'), LifterPart('compression'),
  LifterPart('jersey'), LifterPart('camo'), LifterPart('flannel'), LifterPart('hoodie'),
  LifterPart('windbreaker'), LifterPart('zip_hoodie'), LifterPart('track_jacket'), LifterPart('varsity'),
  LifterPart('bomber'), LifterPart('denim'), LifterPart('leather'), LifterPart('puffer_vest'),
  LifterPart('gold_bomber', rarity: Rarity.legendary, unlock: Unlock(UnlockKind.tier, 6)),
  LifterPart('champion_robe', rarity: Rarity.legendary, unlock: Unlock(UnlockKind.monthChampion)),
  LifterPart('pro_tracksuit', pro: true), LifterPart('satin_bomber', pro: true),
  LifterPart('holo_jersey', pro: true), LifterPart('tie_dye_hoodie', pro: true),
  LifterPart('gloss_puffer', pro: true), LifterPart('gold_trim_tank', pro: true),
  LifterPart('hero_cape', pro: true), LifterPart('chrome_armor', pro: true),
  LifterPart('galaxy_hoodie', pro: true), LifterPart('flame_jersey', pro: true),
];

const kTopColors = <String>[
  '#141312', '#E9E1D2', '#D9A94A', '#C2452D', '#2F6FD6', '#2E8B57', '#7B3FC4',
  '#F06292', '#6B7280', '#0F766E', '#A16207', '#1E3A8A', '#991B1B', '#F5F5F4',
];

/// Tops drawn in a colour of their own, which the top colour does not change.
const kFixedColorTops = {'camo', 'denim', 'leather', 'gold_bomber', 'champion_robe', 'pro_tracksuit', 'satin_bomber', 'holo_jersey', 'tie_dye_hoodie', 'gloss_puffer', 'gold_trim_tank'};

const kGear = <LifterPart>[
  LifterPart('none'), LifterPart('shades'), LifterPart('glasses'), LifterPart('sweatband'),
  LifterPart('bandana'), LifterPart('cap_back'), LifterPart('cap'), LifterPart('bucket_hat'),
  LifterPart('beanie'), LifterPart('durag'), LifterPart('visor'), LifterPart('headphones'),
  LifterPart('earbuds'), LifterPart('earrings'), LifterPart('silver_chain'), LifterPart('dog_tags'),
  LifterPart('whistle'), LifterPart('towel'), LifterPart('face_mask'),
  LifterPart('gold_chain', rarity: Rarity.rare, unlock: Unlock(UnlockKind.tier, 3)),
  LifterPart('medal', rarity: Rarity.epic, unlock: Unlock(UnlockKind.monthPodium)),
  LifterPart('laurel', rarity: Rarity.epic, unlock: Unlock(UnlockKind.tier, 5)),
  LifterPart('horns', rarity: Rarity.epic, unlock: Unlock(UnlockKind.winStreak, 10)),
  LifterPart('title_belt', rarity: Rarity.legendary, unlock: Unlock(UnlockKind.monthChampion)),
  LifterPart('halo', rarity: Rarity.legendary, unlock: Unlock(UnlockKind.level, 50)),
  LifterPart('crown', rarity: Rarity.legendary, unlock: Unlock(UnlockKind.tier, 6)),
  LifterPart('gold_headphones', pro: true), LifterPart('diamond_studs', pro: true),
  LifterPart('cyber_visor', pro: true), LifterPart('iced_chain', pro: true), LifterPart('aura', pro: true),
  LifterPart('shutter_shades', pro: true), LifterPart('flame_headband', pro: true),
  LifterPart('pet_dragon', pro: true), LifterPart('neon_wings', pro: true), LifterPart('bat_wings', pro: true),
];

/// Gear worn on the head, under which most hair is not drawn.
/// Ready-made characters (the user's picks, 2026-11-04): the whole lifter, worn
/// as it is — nothing goes on it, and choosing anything else takes it off.
/// The background stays the lifter's own. The first is none.
const kCharacters = <LifterPart>[
  LifterPart('none'),
  LifterPart('samurai', pro: true), LifterPart('viking', pro: true),
  LifterPart('ninja', pro: true), LifterPart('astronaut', pro: true),
  LifterPart('masked_wrestler', pro: true), LifterPart('pharaoh', pro: true),
];

const kHats = {'cap_back', 'cap', 'bucket_hat', 'beanie', 'durag', 'visor'};

const kBackgroundColors = <String>[
  '#F2B33D', '#3FB6A8', '#E8573E', '#6C5CE7', '#2D9CDB', '#F07EA6', '#9BC53D',
  '#1F1D1B', '#E8DCC8', '#FF7A1A', '#14B8A6', '#A3E635', '#C084FC', '#FB7185',
];

const kPatterns = <LifterPart>[
  LifterPart('rays'), LifterPart('plain'), LifterPart('halftone'), LifterPart('stripes'),
  LifterPart('grid'), LifterPart('checkers'), LifterPart('zigzag'), LifterPart('barbells'),
  LifterPart('skyline'), LifterPart('spotlight'),
  LifterPart('flames', rarity: Rarity.epic, unlock: Unlock(UnlockKind.winStreak, 5)),
  LifterPart('lightning', rarity: Rarity.epic, unlock: Unlock(UnlockKind.dayStreak, 14)),
  LifterPart('gold_burst', rarity: Rarity.legendary, unlock: Unlock(UnlockKind.monthChampion)),
  LifterPart('galaxy', rarity: Rarity.legendary, unlock: Unlock(UnlockKind.allStars)),
  LifterPart('aurora', pro: true), LifterPart('neon_city', pro: true),
  LifterPart('holo_foil', pro: true), LifterPart('smoke', pro: true),
  LifterPart('synthwave', pro: true), LifterPart('sakura', pro: true),
  LifterPart('deep_sea', pro: true), LifterPart('confetti', pro: true),
];

/// One lifter: an index into each list above.
class Lifter {
  const Lifter({
    this.skin = 5,
    this.hair = 4,
    this.hairColor = 0,
    this.eyes = 0,
    this.brows = 0,
    this.mouth = 0,
    this.beard = 2,
    this.marks = 0,
    this.top = 0,
    this.topColor = 0,
    this.gear = 0,
    this.background = 0,
    this.pattern = 0,
    this.character = 0,
  });

  final int skin, hair, hairColor, eyes, brows, mouth, beard, marks, top, topColor, gear, background, pattern;

  /// A ready-made character in [kCharacters] worn over everything, or 0.
  final int character;

  LifterPart get skinPart => kSkins[skin];
  bool get wearsHat => kHats.contains(kGear[gear].id);

  Lifter copyWith({
    int? skin,
    int? hair,
    int? hairColor,
    int? eyes,
    int? brows,
    int? mouth,
    int? beard,
    int? marks,
    int? top,
    int? topColor,
    int? gear,
    int? background,
    int? pattern,
    int? character,
  }) => Lifter(
    skin: skin ?? this.skin,
    hair: hair ?? this.hair,
    hairColor: hairColor ?? this.hairColor,
    eyes: eyes ?? this.eyes,
    brows: brows ?? this.brows,
    mouth: mouth ?? this.mouth,
    beard: beard ?? this.beard,
    marks: marks ?? this.marks,
    top: top ?? this.top,
    topColor: topColor ?? this.topColor,
    gear: gear ?? this.gear,
    background: background ?? this.background,
    pattern: pattern ?? this.pattern,
    character: character ?? this.character,
  );

  /// The parts this lifter wears, each with the list it came from.
  Iterable<LifterPart> get parts => [
    kSkins[skin], kHair[hair], kEyes[eyes], kMouths[mouth], kBeards[beard], kMarks[marks],
    kTops[top], kGear[gear], kPatterns[pattern], kCharacters[character],
  ];

  /// The rarest thing it wears.
  Rarity get rarity => parts.map((p) => p.rarity).reduce((a, b) => a.index >= b.index ? a : b);

  Map<String, Object> toJson() => {
    'v': 1,
    'skin': kSkins[skin].id,
    'hair': kHair[hair].id,
    'hairColor': kHairColors[hairColor],
    'eyes': kEyes[eyes].id,
    'brows': kBrows[brows].id,
    'mouth': kMouths[mouth].id,
    'beard': kBeards[beard].id,
    'marks': kMarks[marks].id,
    'top': kTops[top].id,
    'topColor': kTopColors[topColor],
    'gear': kGear[gear].id,
    'background': kBackgroundColors[background],
    'pattern': kPatterns[pattern].id,
    if (character != 0) 'character': kCharacters[character].id,
  };

  /// Unknown or missing parts fall back to the first of their kind: a
  /// lifter saved by a newer build, read by this one, still draws.
  factory Lifter.fromJson(Map<String, dynamic> json) {
    int part(List<LifterPart> list, String key) {
      final id = json[key];
      final i = list.indexWhere((p) => p.id == id);
      return i < 0 ? 0 : i;
    }

    int color(List<String> list, String key) {
      final hex = json[key];
      final i = list.indexOf(hex is String ? hex : '');
      return i < 0 ? 0 : i;
    }

    return Lifter(
      skin: part(kSkins, 'skin'),
      hair: part(kHair, 'hair'),
      hairColor: color(kHairColors, 'hairColor'),
      eyes: part(kEyes, 'eyes'),
      brows: part(kBrows, 'brows'),
      mouth: part(kMouths, 'mouth'),
      beard: part(kBeards, 'beard'),
      marks: part(kMarks, 'marks'),
      top: part(kTops, 'top'),
      topColor: color(kTopColors, 'topColor'),
      gear: part(kGear, 'gear'),
      background: color(kBackgroundColors, 'background'),
      pattern: part(kPatterns, 'pattern'),
      character: part(kCharacters, 'character'),
    );
  }

  /// A lifter made of free parts only, the same for the same seed: what an
  /// account that has not made one yet wears.
  factory Lifter.random(int seed) {
    final r = LifterRandom(seed);
    int free(List<LifterPart> list) => r.pick(list.where((p) => !p.earned && !p.pro).length);
    return Lifter(
      skin: free(kSkins),
      hair: free(kHair),
      // The free colours only, so the same seeds give the same lifters.
      hairColor: r.pick(kHairColors.length - kProHairColors.length),
      eyes: free(kEyes),
      brows: r.pick(kBrows.length),
      mouth: free(kMouths),
      beard: free(kBeards),
      marks: r.next() < 0.5 ? 0 : free(kMarks),
      top: free(kTops),
      topColor: r.pick(kTopColors.length),
      gear: free(kGear),
      background: r.pick(kBackgroundColors.length),
      pattern: free(kPatterns),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Lifter && other.toJson().toString() == toJson().toString();

  @override
  int get hashCode => toJson().toString().hashCode;
}

/// A small seeded generator, so a seed always gives the same lifter.
class LifterRandom {
  // The seed is kept small first, so the product stays exact on the web too.
  LifterRandom(int seed) : _s = (seed.abs() % 1000003 * 2654435761) % 4294967296;
  int _s;

  double next() {
    _s = (_s * 1664525 + 1013904223) % 4294967296;
    return _s / 4294967296;
  }

  int pick(int n) => (next() * n).floor().clamp(0, n - 1);
}
