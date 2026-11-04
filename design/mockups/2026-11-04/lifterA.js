// The OUTREPD lifter, style A (comic ink): the full catalog, round two.
// viewBox 0 0 200 200. Every part is an original drawing.

const INK = '#16120F';
const CORAL = '#FF8466';
const shade = (hex, f) => {
  const n = parseInt(hex.slice(1), 16);
  const c = [n >> 16, (n >> 8) & 255, n & 255].map(v =>
    Math.max(0, Math.min(255, Math.round(f < 0 ? v * (1 + f) : v + (255 - v) * f))));
  return '#' + c.map(v => v.toString(16).padStart(2, '0')).join('');
};
// Dark print on a light garment, light print on a dark one.
const onCloth = (hex) => { const n = parseInt(hex.slice(1), 16); const l = 0.299 * (n >> 16) + 0.587 * ((n >> 8) & 255) + 0.114 * (n & 255); return l > 150 ? '#141312' : '#F5EFE4'; };
const RARITY = { Common: '#B9B2A8', Rare: '#4DA3FF', Epic: '#B26BFF', Legendary: '#F2B33D' };

// ── the catalog ──────────────────────────────────────────────────────────────
const CAT = {
  skin: [
    { n: 'Porcelain', c: '#F7DCC6' }, { n: 'Light', c: '#F2CFAE' }, { n: 'Fair', c: '#E0A985' },
    { n: 'Golden', c: '#D9A06A' }, { n: 'Olive', c: '#B08B5B' }, { n: 'Tan', c: '#C68A5C' },
    { n: 'Brown', c: '#9C6440' }, { n: 'Deep', c: '#6E4129' }, { n: 'Dark', c: '#4A2A1A' }, { n: 'Ebony', c: '#35201A' },
    { n: 'Stone', c: '#8D9099', fx: 'stone', r: 'Rare', lock: 'Clear Iron Mines' },
    { n: 'Bronze', c: '#B9733A', fx: 'metal', r: 'Rare', lock: 'Clear Bronze Dunes' },
    { n: 'Chrome', c: '#B8C2CC', fx: 'metal', r: 'Epic', lock: 'Clear Silver Peaks' },
    { n: 'Gold', c: '#E2B23C', fx: 'metal', r: 'Epic', lock: 'Clear Gold Citadel' },
    { n: 'Ice', c: '#BFE6F5', fx: 'ice', r: 'Epic', lock: 'Clear Platinum Glacier' },
    { n: 'Crystal', c: '#4FD1C5', fx: 'crystal', r: 'Legendary', lock: 'Clear Diamond Caverns' },
    { n: 'Lava', c: '#3A2A26', fx: 'lava', r: 'Legendary', lock: 'Clear Master’s Throne' },
    { n: 'Cyborg', c: '#9FB4C2', fx: 'cyborg', r: 'Legendary', lock: 'Reach Level 30' },
    { n: 'Holo', c: '#C9B8F5', fx: 'holo', r: 'Epic', lock: 'Win 50 matches' },
    { n: 'Shadow', c: '#26232E', fx: 'shadow', r: 'Legendary', lock: 'Finish a month in the top 10' },
    { n: 'Neon', c: '#1E1B33', fx: 'neon', pro: true }, { n: 'Obsidian', c: '#1A1720', fx: 'obsidian', pro: true },
    { n: 'Cosmic', c: '#3B2A7A', fx: 'cosmic', pro: true }, { n: 'Electric', c: '#2F6FD6', fx: 'electric', pro: true },
  ],
  hair: ['Bald', 'Buzz', 'Crew cut', 'Flat-top', 'Curls', 'Afro', 'Mohawk', 'Spikes', 'Slick back', 'Man bun',
    'Dreads', 'Side part', 'Long', 'Undercut', 'Waves', 'Cornrows', 'Pompadour', 'Faux hawk', 'Twists', 'Messy'].map(n => ({ n })),
  hairC: ['#141010', '#3A2416', '#6B3E1F', '#8E3B1E', '#E3C27A', '#EDEAE4', '#9A9590', '#D23A22', '#3D6FD8', '#33B36B', '#E85D9C', '#8A4FD8', '#F08A24', '#23B5B5'],
  eyes: [
    { n: 'Focused' }, { n: 'Angry' }, { n: 'Calm' }, { n: 'Wide' }, { n: 'Wink' }, { n: 'Zen' },
    { n: 'Side-eye' }, { n: 'Squint' }, { n: 'Sleepy' },
    { n: 'Fire eyes', r: 'Rare', lock: '7-day streak' }, { n: 'Star eyes', r: 'Epic', lock: '3 stars on 30 levels' },
    { n: 'Laser eyes', r: 'Legendary', lock: '30-day streak' },
    { n: 'Glow eyes', pro: true },
  ],
  brows: ['Heavy', 'Thin', 'Raised', 'Cut', 'Arched', 'Bushy', 'Double cut'].map(n => ({ n })),
  mouth: [
    { n: 'Smirk' }, { n: 'Grit' }, { n: 'Grin' }, { n: 'Roar' }, { n: 'Mouthguard' }, { n: 'Flat' },
    { n: 'Tongue out' }, { n: 'Shout' }, { n: 'Grimace' }, { n: 'Lip bite' },
    { n: 'Gold tooth', r: 'Rare', lock: 'Win 10 matches' }, { n: 'Diamond grill', r: 'Legendary', lock: 'Win 100 matches' },
  ],
  beard: ['None', 'Stubble', 'Full', 'Goatee', 'Moustache', 'Chin strap', 'Viking', 'Chops', 'Boxed', 'Anchor', 'Handlebar', 'Soul patch'].map(n => ({ n })),
  marks: ['None', 'Scar', 'Eye black', 'War paint', 'Freckles', 'Tattoo', 'Nose tape', 'Sweat', 'Cheek bandage', 'Nose ring', 'Brow piercing'].map(n => ({ n })),
  top: [
    { n: 'Shirtless' }, { n: 'Tank' }, { n: 'Stringer' }, { n: 'Tee' }, { n: 'Ringer tee' }, { n: 'Muscle tee' },
    { n: 'Polo' }, { n: 'Compression' }, { n: 'Jersey' }, { n: 'Camo tee' }, { n: 'Flannel' }, { n: 'Hoodie' },
    { n: 'Windbreaker' }, { n: 'Zip hoodie' }, { n: 'Track jacket' }, { n: 'Varsity' }, { n: 'Bomber' },
    { n: 'Denim jacket' }, { n: 'Leather jacket' }, { n: 'Puffer vest' },
    { n: 'Gold bomber', r: 'Legendary', lock: 'Reach Master' }, { n: 'Champion robe', r: 'Legendary', lock: 'Be a month’s Champion' },
    { n: 'Pro tracksuit', pro: true }, { n: 'Satin bomber', pro: true }, { n: 'Holo jersey', pro: true },
    { n: 'Tie-dye hoodie', pro: true }, { n: 'Gloss puffer', pro: true }, { n: 'Gold-trim tank', pro: true },
  ],
  topC: ['#141312', '#E9E1D2', '#D9A94A', '#C2452D', '#2F6FD6', '#2E8B57', '#7B3FC4', '#F06292', '#6B7280', '#0F766E', '#A16207', '#1E3A8A', '#991B1B', '#F5F5F4'],
  gear: [
    { n: 'None' }, { n: 'Shades' }, { n: 'Glasses' }, { n: 'Sweatband' }, { n: 'Bandana' }, { n: 'Cap back' },
    { n: 'Cap' }, { n: 'Bucket hat' }, { n: 'Beanie' }, { n: 'Durag' }, { n: 'Visor' }, { n: 'Headphones' },
    { n: 'Earbuds' }, { n: 'Earrings' }, { n: 'Silver chain' }, { n: 'Dog tags' }, { n: 'Whistle' }, { n: 'Towel' }, { n: 'Face mask' },
    { n: 'Gold chain', r: 'Rare', lock: 'Reach Gold' }, { n: 'Medal', r: 'Epic', lock: 'Finish a month on the podium' },
    { n: 'Laurel', r: 'Epic', lock: 'Reach Diamond' }, { n: 'Horns', r: 'Epic', lock: 'Win 10 in a row' },
    { n: 'Title belt', r: 'Legendary', lock: 'Be a month’s Champion' }, { n: 'Halo', r: 'Legendary', lock: 'Reach Level 50' },
    { n: 'Crown', r: 'Legendary', lock: 'Reach Master' },
    { n: 'Gold headphones', pro: true }, { n: 'Diamond studs', pro: true }, { n: 'Cyber visor', pro: true },
    { n: 'Iced chain', pro: true }, { n: 'Aura', pro: true },
  ],
  bg: ['#F2B33D', '#3FB6A8', '#E8573E', '#6C5CE7', '#2D9CDB', '#F07EA6', '#9BC53D', '#1F1D1B', '#E8DCC8', '#FF7A1A', '#14B8A6', '#A3E635', '#C084FC', '#FB7185'],
  pattern: [
    { n: 'Rays' }, { n: 'Plain' }, { n: 'Halftone' }, { n: 'Stripes' }, { n: 'Grid' }, { n: 'Checkers' },
    { n: 'Zigzag' }, { n: 'Barbells' }, { n: 'Skyline' }, { n: 'Spotlight' },
    { n: 'Flames', r: 'Epic', lock: 'Win 5 in a row' }, { n: 'Lightning', r: 'Epic', lock: '14-day streak' },
    { n: 'Gold burst', r: 'Legendary', lock: 'Be a month’s Champion' }, { n: 'Galaxy', r: 'Legendary', lock: 'All 420 Adventure stars' },
    { n: 'Aurora', pro: true }, { n: 'Neon city', pro: true }, { n: 'Holo foil', pro: true }, { n: 'Smoke', pro: true },
  ],
};
const EARNED_FROM = (list) => list.findIndex(it => it.r);
const PRO_COUNT = (list) => list.filter(it => it.pro).length;

function rng(seed) { let s = (seed * 2654435761) % 4294967296; return () => ((s = (s * 1664525 + 1013904223) % 4294967296) / 4294967296); }
function randomLifter(seed) {
  const r = rng(seed + 7); const pick = n => Math.floor(r() * n);
  const any = (list, rareChance = 0.12) => {
    const free = EARNED_FROM(list); const nFree = free < 0 ? list.length : free;
    return r() < rareChance && free >= 0 ? free + pick(list.length - PRO_COUNT(list) - free) : pick(nFree);
  };
  return {
    skin: any(CAT.skin, 0.25), hair: pick(CAT.hair.length), hairC: pick(CAT.hairC.length), eyes: any(CAT.eyes),
    brows: pick(CAT.brows.length), mouth: any(CAT.mouth), beard: pick(CAT.beard.length), marks: r() < 0.5 ? 0 : pick(CAT.marks.length),
    top: any(CAT.top, 0.08), topC: pick(CAT.topC.length), gear: any(CAT.gear, 0.25), bg: pick(CAT.bg.length), pattern: any(CAT.pattern, 0.12),
  };
}

// ── drawing helpers ──────────────────────────────────────────────────────────
let uid = 0;
function cel(id, key, d, fill, opts = {}) {
  const cid = `${id}${key}`;
  const dark = shade(fill, opts.dark ?? -0.28);
  return `<clipPath id="${cid}"><path d="${d}"/></clipPath>` +
    `<g clip-path="url(#${cid})"><path d="${d}" fill="${dark}"/><path d="${d}" fill="${fill}" transform="translate(${opts.dx ?? -9} ${opts.dy ?? -6})"/>${opts.inner || ''}</g>` +
    `<path d="${d}" fill="none" stroke="${INK}" stroke-width="${opts.w ?? 3.4}" stroke-linejoin="round"/>`;
}
const ink = (d, w = 2.6, o = 0.75, col = INK) => d ? `<path d="${d}" fill="none" stroke="${col}" stroke-width="${w}" stroke-linecap="round" stroke-linejoin="round" opacity="${o}"/>` : '';
const dot = (x, y, r, fill, w = 2.4) => `<circle cx="${x}" cy="${y}" r="${r}" fill="${fill}" stroke="${INK}" stroke-width="${w}"/>`;
const flat = (d, fill, o = 1) => `<path d="${d}" fill="${fill}" opacity="${o}"/>`;

// ── shapes ───────────────────────────────────────────────────────────────────
const P = {
  body: 'M-12 200 L-12 176 C-8 154 14 142 40 138 C56 136 70 128 79 116 L121 116 C130 128 144 136 160 138 C186 142 208 154 212 176 L212 200 Z',
  neck: 'M77 92 L75 124 C86 134 114 134 125 124 L123 92 Z',
  head: 'M65 66 C65 40 81 28 100 28 C119 28 135 40 135 66 L135 84 C135 99 127 109 115 115 L106 119 C102 120 98 120 94 119 L85 115 C73 109 65 99 65 84 Z',
  earL: 'M66 72 C56 70 55 90 66 92 Z', earR: 'M134 72 C144 70 145 90 134 92 Z',
  delts: 'M44 150 C36 162 34 182 38 200 M156 150 C164 162 166 182 162 200',
  pecs: 'M100 160 L100 200 M58 182 C76 194 94 192 100 182 M142 182 C124 194 106 192 100 182',
  traps: 'M80 118 C72 128 58 134 42 139 M120 118 C128 128 142 134 158 139 M70 140 C80 146 92 148 100 148 M130 140 C120 146 108 148 100 148',
  neckLines: 'M84 100 L95 126 M116 100 L105 126',
  jaw: 'M72 94 C76 104 80 108 86 110 M128 94 C124 104 120 108 114 110 M92 120 C96 122 104 122 108 120',
  sleeveL: 'M-12 200 L-12 176 C-8 154 14 142 40 138 L52 150 C46 168 44 184 44 200 Z',
  sleeveR: 'M212 200 L212 176 C208 154 186 142 160 138 L148 150 C154 168 156 184 156 200 Z',
};

// ── hair ─────────────────────────────────────────────────────────────────────
const BUZZ = 'M66 64 C64 40 80 30 100 30 C120 30 136 40 134 64 C128 48 116 42 100 42 C84 42 72 48 66 64 Z';
const CREW = 'M64 64 C62 38 80 26 100 26 C120 26 138 38 136 64 C130 50 118 44 100 46 C82 44 70 50 64 64 Z';
function hair(id, i, hc) {
  const H = {
    1: { f: BUZZ, faint: true },
    2: { f: CREW },
    3: { f: 'M64 66 L64 28 L136 28 L136 66 C130 54 118 48 100 48 C82 48 70 54 64 66 Z' },
    4: { f: 'M68 58 C66 32 82 18 100 18 C118 18 134 32 132 58 C124 48 114 44 100 44 C86 44 76 48 68 58 Z', curls: [[80, 30], [92, 23], [105, 22], [118, 27], [127, 37], [86, 38], [100, 33], [114, 36], [72, 42]] },
    5: { b: 'M48 76 C38 30 70 4 100 4 C130 4 162 30 152 76 C146 58 134 48 118 46 L82 46 C66 48 54 58 48 76 Z', f: 'M66 62 C68 50 80 44 100 44 C120 44 132 50 134 62 C128 54 116 50 100 50 C84 50 72 54 66 62 Z' },
    6: { f: 'M90 46 L88 8 L100 0 L112 8 L110 46 C106 44 94 44 90 46 Z', sides: 'M66 66 C64 48 70 40 78 38 L80 50 C72 54 68 58 66 66 Z M134 66 C136 48 130 40 122 38 L120 50 C128 54 132 58 134 66 Z' },
    7: { f: 'M64 64 L58 34 L74 40 L72 18 L88 30 L96 6 L106 28 L120 12 L124 34 L142 30 L136 64 C128 50 116 44 100 44 C84 44 72 50 64 64 Z' },
    8: { f: 'M64 64 C60 34 78 20 100 20 C124 20 140 34 136 64 C132 50 124 40 112 38 C104 42 92 42 84 38 C74 42 68 50 64 64 Z', lines: 'M80 30 C90 26 110 26 122 32 M76 38 C90 32 112 32 128 40' },
    9: { f: 'M64 64 C62 38 80 28 100 28 C120 28 138 38 136 64 C128 50 116 44 100 44 C84 44 72 50 64 64 Z', bun: true },
    10: { strands: true, f: 'M64 62 C62 36 80 26 100 26 C120 26 138 36 136 62 C128 50 116 44 100 44 C84 44 72 50 64 62 Z' },
    11: { f: 'M64 66 C60 34 80 22 102 22 C124 22 140 36 136 66 C134 52 128 44 118 40 C104 46 84 44 74 40 C68 46 66 54 64 66 Z', lines: 'M112 24 C114 30 116 36 118 40' },
    12: { b: 'M56 124 C48 70 60 22 100 22 C140 22 152 70 144 124 L130 124 C134 92 132 62 120 50 L80 50 C68 62 66 92 70 124 Z', f: 'M64 64 C62 36 80 24 100 24 C120 24 138 36 136 64 C130 48 118 40 100 40 C82 40 70 48 64 64 Z' },
    13: { f: 'M70 54 C66 28 88 14 110 18 C130 22 140 36 134 54 C122 40 104 38 90 44 C82 48 74 50 70 54 Z', sides: 'M66 66 C64 54 66 48 70 54 C72 58 68 62 66 66 Z M134 66 C136 54 136 50 134 54 C132 58 132 62 134 66 Z', lines: 'M86 26 C100 22 118 26 128 34' },
    14: { f: CREW, lines: 'M72 44 C78 40 84 48 90 44 C96 40 102 48 108 44 C114 40 120 48 126 44 M70 54 C76 50 82 58 88 54 C94 50 100 58 106 54 C112 50 118 58 124 54 C128 52 130 54 132 56 M78 34 C84 30 90 38 96 34 C102 30 108 38 114 34 C118 32 120 32 122 34', lineCol: '#fff', lineOp: 0.35 },
    15: { f: CREW, lines: 'M74 56 L80 32 M84 50 L88 28 M94 48 L96 27 M106 48 L104 27 M116 50 L112 28 M126 56 L120 32', lineCol: '#fff', lineOp: 0.45 },
    16: { f: 'M64 62 C60 40 70 22 90 14 C112 6 136 16 138 34 C138 46 134 56 136 62 C128 50 116 46 100 46 C84 46 72 52 64 62 Z', lines: 'M84 20 C100 14 122 16 132 30 M80 30 C96 24 116 26 128 38' },
    17: { f: 'M72 56 L80 26 L90 36 L96 8 L104 32 L112 12 L118 36 L126 28 L130 56 C120 46 82 46 72 56 Z', sides: BUZZ },
    18: { f: CREW, twists: [[78, 22], [88, 16], [100, 13], [112, 16], [122, 22], [70, 32], [130, 32]] },
    19: { f: 'M62 64 C58 44 66 26 82 22 C90 14 106 14 114 20 C130 20 142 34 138 52 L142 58 L132 56 C124 46 112 42 100 44 L96 36 L90 46 C80 46 70 52 62 64 Z' },
  }[i];
  let back = '', front = '';
  if (H) {
    if (H.b) back = cel(id, 'hb', H.b, hc);
    if (H.strands) for (const x of [62, 70, 130, 138]) {
      const x2 = x < 100 ? x - 4 : x + 4;
      back += `<path d="M${x} 50 L${x2} 122" stroke="${INK}" stroke-width="11" stroke-linecap="round"/><path d="M${x} 50 L${x2} 122" stroke="${hc}" stroke-width="6.5" stroke-linecap="round"/>`;
    }
    if (H.sides) front += flat(H.sides, hc, 0.5);
    front += H.faint ? flat(H.f, hc, 0.6) : cel(id, 'hf', H.f, hc);
    if (H.curls) for (const [x, y] of H.curls) front += dot(x, y, 6.5, hc);
    if (H.twists) for (const [x, y] of H.twists) front += `<rect x="${x - 4}" y="${y - 8}" width="8" height="18" rx="4" fill="${hc}" stroke="${INK}" stroke-width="2.2"/>`;
    if (H.lines) front += ink(H.lines, 2, H.lineOp ?? 0.5, H.lineCol ?? INK);
    if (H.bun) front += dot(100, 20, 11, hc, 3);
  }
  if (i === 0) front += ink('M84 40 C92 34 106 34 112 38', 4.5, 0.55, '#fff');
  return { back, front };
}

function beard(id, i, hc) {
  return ({
    1: flat('M68 88 C70 104 82 116 100 118 C118 116 130 104 132 88 C128 100 118 108 100 108 C82 108 72 100 68 88 Z', hc, 0.45),
    2: cel(id, 'bd', 'M66 80 C66 108 80 126 100 128 C120 126 134 108 134 80 C130 96 122 104 112 104 C106 100 94 100 88 104 C78 104 70 96 66 80 Z', hc),
    3: cel(id, 'bd', 'M91 114 C95 112 105 112 109 114 L107 126 C104 129 96 129 93 126 Z', hc, { w: 2.6 }),
    4: cel(id, 'bd', 'M82 101 C90 95 110 95 118 101 C110 99 106 101 100 100 C94 101 90 99 82 101 Z', hc, { w: 2.4 }),
    5: cel(id, 'bd', 'M66 80 C66 108 80 124 100 126 C120 124 134 108 134 80 L130 82 C130 104 118 118 100 120 C82 118 70 104 70 82 Z', hc, { w: 2.4 }),
    6: cel(id, 'bd', 'M66 82 C66 116 82 150 100 158 C118 150 134 116 134 82 C130 98 122 106 112 106 C106 102 94 102 88 106 C78 106 70 98 66 82 Z', hc) + ink('M92 130 L96 150 M108 130 L104 150', 2, 0.5),
    7: cel(id, 'bd', 'M66 74 C66 98 72 110 84 114 L86 100 C78 96 72 88 72 74 Z', hc, { w: 2.4 }) + cel(id, 'bd2', 'M134 74 C134 98 128 110 116 114 L114 100 C122 96 128 88 128 74 Z', hc, { w: 2.4 }),
    8: cel(id, 'bd', 'M70 92 C70 108 80 122 100 124 C120 122 130 108 130 92 C126 102 118 106 112 104 C106 100 94 100 88 104 C82 106 74 102 70 92 Z', hc, { w: 2.6 }),
    9: cel(id, 'bd', 'M82 101 C90 95 110 95 118 101 C110 99 106 101 100 100 C94 101 90 99 82 101 Z', hc, { w: 2.2 }) + cel(id, 'bd2', 'M88 116 C94 114 106 114 112 116 L104 130 L100 134 L96 130 Z', hc, { w: 2.4 }),
    10: cel(id, 'bd', 'M78 108 C74 104 76 96 84 98 C92 96 108 96 116 98 C124 96 126 104 122 108 C118 102 108 100 100 101 C92 100 82 102 78 108 Z', hc, { w: 2.4 }),
    11: cel(id, 'bd', 'M96 113 L104 113 L102 120 L98 120 Z', hc, { w: 2 }),
  })[i] || '';
}

function eyes(id, i, skin) {
  const white = `<path d="M77 82 C80 77 93 77 96 82 C92 86 81 86 77 82 Z M123 82 C120 77 107 77 104 82 C108 86 119 86 123 82 Z" fill="#fff" stroke="${INK}" stroke-width="2.2"/>`;
  const glowCol = skin.fx === 'cyborg' ? '#FF3B3B' : skin.fx === 'lava' ? '#FF8A3D' : skin.fx === 'crystal' ? '#E8FFFC' : skin.fx === 'shadow' ? '#B26BFF' : null;
  const pupils = (r = 3.4, dx = 0, col = glowCol || '#1a1410') => `<circle cx="${88 + dx}" cy="82" r="${r}" fill="${col}"/><circle cx="${112 + dx}" cy="82" r="${r}" fill="${col}"/>`;
  const lids = (y = 79) => ink(`M76 ${y} L96 ${y + 1} M124 ${y} L104 ${y + 1}`, 2.6, 1);
  const star = (x) => `<path d="M${x} 76 L${x + 2} 80 L${x + 6} 80.5 L${x + 3} 83.5 L${x + 4} 88 L${x} 85.5 L${x - 4} 88 L${x - 3} 83.5 L${x - 6} 80.5 L${x - 2} 80 Z" fill="#F2C14E" stroke="${INK}" stroke-width="1.2"/>`;
  switch (i) {
    case 1: return white + pupils(2.6) + ink('M76 77 L96 82 M124 77 L104 82', 3, 1);
    case 2: return white + pupils(3.4) + `<path d="M76 81 C82 78 92 78 96 81 L96 79 C90 76 82 76 76 79 Z M124 81 C118 78 108 78 104 81 L104 79 C110 76 118 76 124 79 Z" fill="${skin.c}"/>` + ink('M76 81 L96 81 M124 81 L104 81', 2.4, 1);
    case 3: return `<path d="M76 82 C80 75 93 75 97 82 C92 88 81 88 76 82 Z M124 82 C120 75 107 75 103 82 C108 88 119 88 124 82 Z" fill="#fff" stroke="${INK}" stroke-width="2.2"/>` + pupils(2.4);
    case 4: return ink('M77 82 C82 78 92 78 96 82', 2.8, 1) + `<path d="M123 82 C120 77 107 77 104 82 C108 86 119 86 123 82 Z" fill="#fff" stroke="${INK}" stroke-width="2.2"/><circle cx="112" cy="82" r="3.4" fill="#1a1410"/>` + ink('M124 79 L104 80', 2.6, 1);
    case 5: return ink('M77 81 C82 85 92 85 96 81 M123 81 C118 85 108 85 104 81', 2.8, 1);
    case 6: return white + pupils(3.2, 4) + lids();
    case 7: return `<path d="M77 82 C82 80 91 80 96 82 C91 84 82 84 77 82 Z M123 82 C118 80 109 80 104 82 C109 84 118 84 123 82 Z" fill="#1a1410" stroke="${INK}" stroke-width="2.2"/>` + ink('M75 79 L97 81 M125 79 L103 81', 2.8, 1);
    case 8: return white + pupils(3) + `<path d="M76 82 C82 78 92 78 97 82 L97 77 L76 77 Z M124 82 C118 78 108 78 103 82 L103 77 L124 77 Z" fill="${shade(skin.c, -0.08)}" stroke="${INK}" stroke-width="2.2"/>`;
    case 9: return white + `<circle cx="88" cy="82" r="3.8" fill="#FF8A1E"/><circle cx="112" cy="82" r="3.8" fill="#FF8A1E"/>` +
      `<path d="M80 76 C82 66 86 70 88 62 C90 70 94 66 96 76 Z M104 76 C106 66 110 70 112 62 C114 70 118 66 120 76 Z" fill="#FF8A1E" stroke="${INK}" stroke-width="2"/>` + lids();
    case 10: return white + star(88) + star(112) + lids();
    case 11: return white + `<path d="M88 82 L-10 96 L-10 104 Z M112 82 L210 96 L210 104 Z" fill="#FF2E2E" opacity=".85"/><circle cx="88" cy="82" r="4" fill="#FF2E2E" stroke="#fff" stroke-width="1.5"/><circle cx="112" cy="82" r="4" fill="#FF2E2E" stroke="#fff" stroke-width="1.5"/>` + lids();
    case 12: return white + `<circle cx="88" cy="82" r="6" fill="#B26BFF" opacity=".35"/><circle cx="112" cy="82" r="6" fill="#B26BFF" opacity=".35"/><circle cx="88" cy="82" r="3.4" fill="#D9A8FF"/><circle cx="112" cy="82" r="3.4" fill="#D9A8FF"/><circle cx="89" cy="81" r="1.2" fill="#fff"/><circle cx="113" cy="81" r="1.2" fill="#fff"/>` + lids();
    default: return white + pupils() + lids();
  }
}

function brows(i, hc) {
  const col = shade(hc, -0.1);
  const B = [
    'M74 66 L96 72 L96 78 L75 73 Z M126 66 L104 72 L104 78 L125 73 Z',
    'M76 70 L96 73 L96 75 L76 72 Z M124 70 L104 73 L104 75 L124 72 Z',
    'M74 62 C82 58 90 60 96 66 L96 71 C90 66 82 64 75 67 Z M126 66 L104 72 L104 78 L125 73 Z',
    'M74 66 L83 68.5 L82 74 L75 73 Z M86 69.5 L96 72 L96 78 L86 75.5 Z M126 66 L104 72 L104 78 L125 73 Z',
    'M74 70 C80 62 90 62 96 68 L96 72 C90 67 81 67 75 73 Z M126 70 C120 62 110 62 104 68 L104 72 C110 67 119 67 125 73 Z',
    'M72 68 C78 60 92 62 98 70 L97 79 C90 72 80 72 73 75 Z M128 68 C122 60 108 62 102 70 L103 79 C110 72 120 72 127 75 Z',
    'M74 66 L80 67.6 L79 73.4 L75 73 Z M83 68.4 L88 69.8 L87.5 75 L82 74 Z M91 70.6 L96 72 L96 78 L90.5 76 Z M126 66 L104 72 L104 78 L125 73 Z',
  ][i];
  return `<path d="${B}" fill="${col}" stroke="${INK}" stroke-width="2.2" stroke-linejoin="round"/>`;
}

function mouth(i) {
  const teeth = (cap) => `<path d="M86 104 L114 104 L112 111 L88 111 Z" fill="#fff" stroke="${INK}" stroke-width="2.4" stroke-linejoin="round"/>` +
    (cap === 'gold' ? `<rect x="100" y="104" width="7" height="7" fill="#F2C14E"/>` : '') +
    (cap === 'grill' ? `<path d="M87 104 L113 104 L111.5 111 L88.5 111 Z" fill="#DDE6F0"/>` + [90, 96, 102, 108].map(x => `<path d="M${x} 105 L${x + 2} 107.5 L${x} 110 L${x - 2} 107.5 Z" fill="#7FE3FF"/>`).join('') : '') +
    ink('M93 104 L93 111 M100 104 L100 111 M107 104 L107 111', 1.4, 1);
  switch (i) {
    case 1: return teeth();
    case 2: return `<path d="M86 102 C92 112 108 112 114 102 Z" fill="#fff" stroke="${INK}" stroke-width="2.6" stroke-linejoin="round"/>` + ink('M88 105 L112 105', 1.4, 1);
    case 3: return `<path d="M86 100 L114 100 L110 116 C104 120 96 120 90 116 Z" fill="#3a1410" stroke="${INK}" stroke-width="2.6" stroke-linejoin="round"/><path d="M88 100 L112 100 L111 104 L89 104 Z" fill="#fff"/><path d="M93 116 C96 112 104 112 107 116" fill="#C2452D"/>`;
    case 4: return `<path d="M85 103 L115 103 L113 112 L87 112 Z" fill="#2F6FD6" stroke="${INK}" stroke-width="2.4" stroke-linejoin="round"/>` + ink('M88 107 L112 107', 1.6, 0.6, '#fff');
    case 5: return ink('M90 107 L111 107', 3, 1);
    case 6: return ink('M88 106 C96 109 106 109 112 105', 2.8, 1) + `<path d="M96 107 C96 117 106 117 106 107 Z" fill="#E86A7A" stroke="${INK}" stroke-width="2.2"/>`;
    case 7: return `<ellipse cx="100" cy="108" rx="8" ry="7" fill="#3a1410" stroke="${INK}" stroke-width="2.6"/><path d="M94 104 L106 104 L105 106 L95 106 Z" fill="#fff"/>`;
    case 8: return `<path d="M84 104 C90 101 110 101 116 104 L114 111 C108 113 92 113 86 111 Z" fill="#fff" stroke="${INK}" stroke-width="2.4" stroke-linejoin="round"/>` + ink('M86 107.5 L114 107.5', 1.4, 1);
    case 9: return ink('M88 104 C96 107 106 107 112 104', 2.6, 1) + `<path d="M93 105 L107 105 L106 109 L94 109 Z" fill="#fff" stroke="${INK}" stroke-width="1.6"/>`;
    case 10: return teeth('gold');
    case 11: return teeth('grill');
    default: return ink('M88 106 C96 110 106 109 113 103', 2.8, 1);
  }
}

function marks(i) {
  switch (i) {
    case 1: return ink('M118 90 L128 104', 2.6, 0.9, '#f4e7d8') + ink('M118 90 L128 104', 0.8, 0.9);
    case 2: return flat('M76 88 L94 88 L93 93 L77 93 Z M106 88 L124 88 L123 93 L107 93 Z', '#141210', 0.95);
    case 3: return flat('M72 90 L90 92 L72 95 Z M72 97 L88 98 L72 101 Z M128 90 L110 92 L128 95 Z M128 97 L112 98 L128 101 Z', '#C2452D', 0.95);
    case 4: return [[80, 92], [84, 95], [77, 96], [120, 92], [116, 95], [123, 96], [96, 92], [104, 92]].map(([x, y]) => `<circle cx="${x}" cy="${y}" r="1.3" fill="#7a3b1e" opacity=".75"/>`).join('');
    case 5: return ink('M126 70 C130 74 128 80 132 84 M128 76 L134 74', 2, 0.85);
    case 6: return `<path d="M90 90 L110 90 L109 95 L91 95 Z" fill="#F4EDE0" stroke="${INK}" stroke-width="2"/>` + ink('M95 90 L95 95 M100 90 L100 95 M105 90 L105 95', 1, 0.5);
    case 7: return [[70, 56], [132, 62], [128, 98]].map(([x, y]) => `<path d="M${x} ${y} C${x - 4} ${y + 6} ${x - 3} ${y + 10} ${x} ${y + 10} C${x + 3} ${y + 10} ${x + 4} ${y + 6} ${x} ${y} Z" fill="#9FD8F5" stroke="${INK}" stroke-width="1.6"/>`).join('');
    case 8: return `<rect x="114" y="92" width="16" height="9" rx="2" transform="rotate(-18 122 96)" fill="#F4EDE0" stroke="${INK}" stroke-width="2"/>` + ink('M116 95 L128 92 M117 99 L129 96', 1, 0.4);
    case 9: return `<circle cx="104" cy="99" r="3" fill="none" stroke="#C9CED6" stroke-width="1.8"/>`;
    case 10: return dot(122, 68, 1.8, '#C9CED6', 1) + dot(124, 74, 1.8, '#C9CED6', 1);
    default: return '';
  }
}

function skinFx(id, sk) {
  switch (sk.fx) {
    case 'stone': return ink('M84 46 L92 58 L88 66 M118 92 L110 100 L114 108 M74 90 L80 96 M150 160 L160 172 L156 184 M40 160 L48 170', 2, 0.7);
    case 'metal': return ink('M80 40 C86 34 96 32 104 34', 5, 0.7, '#fff') + ink('M30 152 C40 146 52 144 60 146', 5, 0.55, '#fff');
    case 'ice': return ink('M80 40 C86 34 96 32 104 34', 5, 0.8, '#fff') + ink('M72 56 L80 60 L76 66 M124 100 L130 104 M40 160 L48 156 L46 166', 2, 0.6, '#5aa9c8');
    case 'crystal': return ink('M100 28 L88 66 L100 119 L112 66 Z M65 66 L88 66 M135 66 L112 66', 1.6, 0.45, '#0b5e57') + ink('M82 40 L94 34', 5, 0.7, '#fff');
    case 'lava': return ink('M84 46 L92 58 L88 66 M118 92 L110 100 L114 108 M74 90 L80 96 M150 160 L160 172 L156 184 M40 160 L48 170 M100 140 L96 156', 3, 1, '#FF7A1A') + ink('M84 46 L92 58 L88 66 M150 160 L160 172', 1.2, 1, '#FFE08A');
    case 'cyborg': return ink('M100 28 L100 60 M70 66 L86 66 L92 72 M135 70 L120 70', 2.2, 0.9, '#5c6f7d') + dot(126, 60, 3, '#FF3B3B', 1.4) + ink('M40 156 L60 156 L64 162', 2, 0.8, '#5c6f7d');
    case 'holo': return ['#FF7AB6', '#7AD7FF', '#B6FF7A', '#FFE07A'].map((c, k) => ink(`M${66 + k * 4} ${40 + k * 14} L${134} ${30 + k * 14}`, 6, 0.35, c)).join('') + ink('M82 40 L94 34', 4, 0.7, '#fff');
    case 'neon': return ink('M66 66 C66 40 82 28 100 28 C118 28 134 40 134 66 L134 84 C134 99 126 109 114 115 L100 120 L86 115 C74 109 66 99 66 84 Z', 2.6, 1, '#4DF2FF') + ink('M20 150 C40 140 60 136 78 120 M180 150 C160 140 140 136 122 120 M100 150 L100 200', 2.4, 0.9, '#FF4FD8');
    case 'obsidian': return ink('M78 40 C88 32 100 30 108 32', 6, 0.55, '#B26BFF') + ink('M24 156 C40 146 56 144 66 146', 6, 0.4, '#B26BFF') + ink('M118 70 L124 90', 3, 0.35, '#fff');
    case 'cosmic': { const r = rng(9); let st = ''; for (let k = 0; k < 26; k++) st += `<circle cx="${70 + r() * 60}" cy="${36 + r() * 76}" r="${r() * 1.3 + 0.4}" fill="#fff" opacity="${0.5 + r() * 0.5}"/>`; for (let k = 0; k < 30; k++) st += `<circle cx="${r() * 200}" cy="${140 + r() * 60}" r="${r() * 1.3 + 0.4}" fill="#fff" opacity="${0.5 + r() * 0.5}"/>`; return st + ink('M74 50 C90 44 110 46 126 56', 8, 0.25, '#F06292'); }
    case 'electric': return ink('M84 40 L90 52 L84 60 L92 72 M118 88 L112 98 L118 104 L112 114 M40 156 L50 164 L44 172 L54 182 M160 150 L152 160 L160 168', 2.2, 1, '#E8F6FF') + ink('M84 40 L90 52 L84 60 L92 72 M40 156 L50 164 L44 172 L54 182', 5, 0.25, '#9FE3FF');
    case 'shadow': return ink('M66 66 C66 40 82 28 100 28 C118 28 134 40 134 66', 2.4, 0.9, '#B26BFF') + ink('M20 150 C40 140 60 136 78 120 M180 150 C160 140 140 136 122 120', 2.4, 0.8, '#B26BFF');
    default: return '';
  }
}

function background(id, i, pat) {
  const bg = CAT.bg[i];
  let s = `<rect x="-20" y="-20" width="240" height="240" fill="${bg}"/>`;
  const light = shade(bg, 0.35), dark = shade(bg, -0.18);
  switch (pat) {
    case 0: s += `<g opacity=".18" fill="#fff">${[0, 1, 2, 3, 4, 5, 6, 7].map(k => `<path d="M100 120 L${100 + 260 * Math.cos(k * 0.785)} ${120 + 260 * Math.sin(k * 0.785)} L${100 + 260 * Math.cos(k * 0.785 + 0.3)} ${120 + 260 * Math.sin(k * 0.785 + 0.3)} Z"/>`).join('')}</g>`; break;
    case 2: { let d = ''; for (let y = 6; y < 200; y += 12) for (let x = (y / 12) % 2 ? 12 : 6; x < 200; x += 12) d += `<circle cx="${x}" cy="${y}" r="${1.2 + (200 - y) / 90}"/>`; s += `<g fill="${light}" opacity=".55">${d}</g>`; break; }
    case 3: s += `<g stroke="${light}" stroke-width="10" opacity=".4">${[-200, -160, -120, -80, -40, 0, 40, 80, 120, 160].map(x => `<path d="M${x} 200 L${x + 200} 0"/>`).join('')}</g>`; break;
    case 4: s += `<g stroke="${light}" stroke-width="1.2" opacity=".45">${[20, 40, 60, 80, 100, 120, 140, 160, 180].map(v => `<path d="M${v} -10 L${v} 210 M-10 ${v} L210 ${v}"/>`).join('')}</g>`; break;
    case 5: { let d = ''; for (let y = -20; y < 210; y += 25) for (let x = -20; x < 210; x += 25) if (((x + y) / 25) % 2 === 0) d += `<rect x="${x}" y="${y}" width="25" height="25"/>`; s += `<g fill="${dark}" opacity=".5">${d}</g>`; break; }
    case 6: s += `<g stroke="${light}" stroke-width="6" fill="none" opacity=".45">${[10, 50, 90, 130, 170].map(y => `<path d="M-10 ${y} ${Array.from({ length: 12 }, (_, k) => `L${k * 20} ${y + (k % 2 ? 12 : 0)}`).join(' ')}"/>`).join('')}</g>`; break;
    case 7: s += `<g fill="${dark}" opacity=".55">${[[30, 30], [150, 40], [40, 120], [170, 110], [100, 10]].map(([x, y]) => `<g transform="translate(${x} ${y}) rotate(-20)"><rect x="-22" y="-2" width="44" height="4" rx="2"/><rect x="-26" y="-9" width="6" height="18" rx="2"/><rect x="20" y="-9" width="6" height="18" rx="2"/></g>`).join('')}</g>`; break;
    case 8: s += `<g fill="${dark}">${[[0, 120, 26], [26, 100, 20], [46, 130, 24], [70, 90, 22], [92, 112, 18], [110, 80, 26], [136, 118, 22], [158, 96, 20], [178, 126, 26]].map(([x, y, w]) => `<rect x="${x}" y="${y}" width="${w}" height="${200 - y}"/>`).join('')}</g>` +
      `<g fill="${light}" opacity=".7">${[[30, 106], [76, 98], [116, 90], [116, 102], [162, 104], [52, 138]].map(([x, y]) => `<rect x="${x}" y="${y}" width="4" height="5"/>`).join('')}</g>`; break;
    case 9: s += `<path d="M70 -20 L130 -20 L190 210 L10 210 Z" fill="#fff" opacity=".18"/><ellipse cx="100" cy="196" rx="90" ry="14" fill="#fff" opacity=".18"/>`; break;
    case 10: s = `<rect x="-20" y="-20" width="240" height="240" fill="#2A0E08"/><g stroke="${INK}" stroke-width="2.5">` +
      [[20, '#FF7A1A'], [60, '#FFB13D'], [100, '#FF7A1A'], [140, '#FFB13D'], [180, '#FF7A1A']].map(([x, c]) =>
        `<path d="M${x - 26} 210 C${x - 30} 160 ${x - 6} 150 ${x - 10} 110 C${x + 10} 130 ${x + 20} 100 ${x + 12} 70 C${x + 36} 110 ${x + 34} 160 ${x + 26} 210 Z" fill="${c}"/>`).join('') + `</g>`; break;
    case 11: s = `<rect x="-20" y="-20" width="240" height="240" fill="#1B1640"/>` + [[30, 0], [150, 10], [90, 40]].map(([x, y]) =>
      `<path d="M${x} ${y} L${x - 14} ${y + 40} L${x + 2} ${y + 40} L${x - 10} ${y + 80} L${x + 22} ${y + 30} L${x + 6} ${y + 30} L${x + 16} ${y}" fill="#FFE04A" stroke="${INK}" stroke-width="2.4" stroke-linejoin="round"/>`).join(''); break;
    case 12: s = `<rect x="-20" y="-20" width="240" height="240" fill="#7A4A00"/><g fill="#F2C14E">${Array.from({ length: 16 }, (_, k) => `<path d="M100 110 L${100 + 280 * Math.cos(k * 0.3927)} ${110 + 280 * Math.sin(k * 0.3927)} L${100 + 280 * Math.cos(k * 0.3927 + 0.18)} ${110 + 280 * Math.sin(k * 0.3927 + 0.18)} Z"/>`).join('')}</g><circle cx="100" cy="110" r="70" fill="#FFE08A" opacity=".35"/>`; break;
    case 14: s = `<rect x="-20" y="-20" width="240" height="240" fill="#071526"/><path d="M-20 40 C40 10 90 70 140 30 C170 6 200 20 220 10 L220 80 C180 90 150 60 110 90 C70 120 30 70 -20 100 Z" fill="#2EE6A8" opacity=".55"/><path d="M-20 70 C50 40 100 110 160 60 C190 36 210 50 220 40 L220 110 C170 130 130 90 90 120 C50 150 20 110 -20 130 Z" fill="#8B5CF6" opacity=".45"/>` + Array.from({ length: 30 }, (_, k) => `<circle cx="${(k * 53) % 200}" cy="${(k * 37) % 120}" r="${k % 3 ? 0.8 : 1.4}" fill="#fff" opacity=".8"/>`).join(''); break;
    case 15: s = `<defs><linearGradient id="${id}nc" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="#2A0B4A"/><stop offset="1" stop-color="#FF4FD8"/></linearGradient></defs><rect x="-20" y="-20" width="240" height="240" fill="url(#${id}nc)"/><circle cx="150" cy="60" r="26" fill="#FFB13D" opacity=".85"/>` + `<g fill="#120826">${[[0, 110, 24], [24, 90, 22], [46, 120, 20], [66, 80, 26], [92, 104, 18], [110, 70, 28], [138, 112, 22], [160, 92, 20], [180, 118, 30]].map(([x, y, w]) => `<rect x="${x}" y="${y}" width="${w}" height="${220 - y}"/>`).join('')}</g>` + `<g fill="#4DF2FF">${[[30, 100], [74, 92], [118, 80], [118, 96], [166, 102], [52, 132], [96, 116], [186, 130]].map(([x, y]) => `<rect x="${x}" y="${y}" width="4" height="5"/>`).join('')}</g>`; break;
    case 16: s = `<defs><linearGradient id="${id}hf" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#7AD7FF"/><stop offset=".25" stop-color="#C9A8FF"/><stop offset=".5" stop-color="#FF9FD6"/><stop offset=".75" stop-color="#FFE59F"/><stop offset="1" stop-color="#9FFFD8"/></linearGradient></defs><rect x="-20" y="-20" width="240" height="240" fill="url(#${id}hf)"/>` + `<g stroke="#fff" stroke-width="14" opacity=".22">${[-120, -60, 0, 60, 120, 180].map(x => `<path d="M${x} 220 L${x + 220} 0"/>`).join('')}</g>`; break;
    case 17: s = `<rect x="-20" y="-20" width="240" height="240" fill="#151517"/>` + [[40, 170, 70], [160, 160, 80], [100, 40, 60], [20, 60, 50], [180, 40, 50]].map(([x, y, r]) => `<circle cx="${x}" cy="${y}" r="${r}" fill="#8C8C99" opacity=".18"/><circle cx="${x + 12}" cy="${y - 10}" r="${r * 0.6}" fill="#B9B9C6" opacity=".12"/>`).join(''); break;
    case 13: { const r = rng(5); let st = ''; for (let k = 0; k < 60; k++) st += `<circle cx="${r() * 200}" cy="${r() * 200}" r="${r() * 1.6 + 0.4}" fill="#fff" opacity="${0.5 + r() * 0.5}"/>`;
      s = `<defs><radialGradient id="${id}gx" cx="30%" cy="30%" r="80%"><stop offset="0" stop-color="#7B3FC4"/><stop offset=".55" stop-color="#2A1B5C"/><stop offset="1" stop-color="#0B0920"/></radialGradient></defs><rect x="-20" y="-20" width="240" height="240" fill="url(#${id}gx)"/><ellipse cx="60" cy="60" rx="70" ry="22" transform="rotate(-25 60 60)" fill="#F06292" opacity=".25"/>${st}`; break; }
  }
  return s;
}

// ── clothes ──────────────────────────────────────────────────────────────────
function topWear(id, i, tc, sk) {
  let s = '';
  const body = (fill, opt) => cel(id, 'body', P.body, fill, opt);
  const sleeves = (fill) => cel(id, 'slL', P.sleeveL, fill) + cel(id, 'slR', P.sleeveR, fill);
  const crew = (fill) => cel(id, 'col', 'M78 118 C86 132 114 132 122 118 L124 124 C114 138 86 138 76 124 Z', fill, { w: 2.4 });
  const hood = (fill) => cel(id, 'hood', 'M56 134 C60 108 80 98 100 98 C120 98 140 108 144 134 C126 126 112 124 100 124 C88 124 74 126 56 134 Z', fill);
  const muscles = () => ink(P.delts, 2.6) + ink(P.traps, 2.6);
  switch (i) {
    case 0: s += body(sk.c) + muscles() + ink(P.pecs, 2.6); break;
    case 1: s += body(tc) + cel(id, 'shL', 'M-12 200 L-12 176 C-8 154 14 142 40 138 C56 136 70 128 79 116 L82 122 C76 140 66 160 62 200 Z', sk.c) + cel(id, 'shR', 'M212 200 L212 176 C208 154 186 142 160 138 C144 136 130 128 121 116 L118 122 C124 140 134 160 138 200 Z', sk.c) + muscles(); break;
    case 2: s += body(tc) + cel(id, 'shL', 'M-12 200 L-12 176 C-8 154 14 142 40 138 C56 136 70 128 79 116 L86 122 C86 150 82 176 80 200 Z', sk.c) + cel(id, 'shR', 'M212 200 L212 176 C208 154 186 142 160 138 C144 136 130 128 121 116 L114 122 C114 150 118 176 120 200 Z', sk.c) + muscles(); break;
    case 3: s += body(tc) + ink('M30 142 C26 160 26 182 30 200 M170 142 C174 160 174 182 170 200', 3, 0.8) + crew(shade(tc, -0.15)); break;
    case 4: { // ringer: a contrasting collar and sleeve bands
      const trim = onCloth(tc) === '#141312' ? '#141312' : '#F5EFE4';
      s += body(tc) + ink('M30 142 C26 160 26 182 30 200 M170 142 C174 160 174 182 170 200', 9, 1) + ink('M30 142 C26 160 26 182 30 200 M170 142 C174 160 174 182 170 200', 5.5, 1, trim) + crew(trim); break;
    }
    case 5: s += body(tc) + cel(id, 'arL', 'M-12 200 L-12 176 C-8 154 14 142 40 138 L46 146 C38 164 36 184 38 200 Z', sk.c) + cel(id, 'arR', 'M212 200 L212 176 C208 154 186 142 160 138 L154 146 C162 164 164 184 162 200 Z', sk.c) + crew(shade(tc, -0.15)); break;
    case 6: s += body(tc) + cel(id, 'pl', 'M76 116 L100 132 L124 116 L130 124 L104 142 L96 142 L70 124 Z', shade(tc, 0.15), { w: 2.4 }) + ink('M100 142 L100 168', 2, 0.8) + dot(100, 150, 2, '#fff', 1.2) + dot(100, 160, 2, '#fff', 1.2); break;
    case 7: s += body(tc) + ink('M100 130 L100 200 M60 150 C70 170 74 186 72 200 M140 150 C130 170 126 186 128 200', 2.2, 0.55) + cel(id, 'col', 'M76 112 L124 112 L126 126 C114 134 86 134 74 126 Z', shade(tc, -0.1), { w: 2.4 }); break;
    case 8: s += body(tc) + cel(id, 'v', 'M80 118 L100 146 L120 118 L114 118 L100 136 L86 118 Z', shade(tc, 0.35), { w: 2.2 }) + `<text x="100" y="186" text-anchor="middle" font-family="Arial Black, Arial" font-weight="900" font-size="30" fill="${shade(tc, 0.5)}" stroke="${INK}" stroke-width="2">23</text>`; break;
    case 9: s += body('#6B7A3A', { inner: [[20, 150, 18], [70, 170, 22], [140, 150, 16], [170, 182, 20], [110, 190, 14], [40, 188, 16]].map(([x, y, r]) => `<ellipse cx="${x}" cy="${y}" rx="${r}" ry="${r * 0.6}" fill="${['#3F4A22', '#8C7A4A', '#2C3318'][x % 3]}"/>`).join('') }) + crew('#4E5A2A'); break;
    case 10: s += body(tc, { inner: [20, 50, 80, 120, 150, 180].map(x => `<path d="M${x} 120 L${x} 200" stroke="${shade(tc, -0.35)}" stroke-width="7" opacity=".6"/>`).join('') + [150, 172, 194].map(y => `<path d="M-10 ${y} L210 ${y}" stroke="${shade(tc, -0.35)}" stroke-width="6" opacity=".55"/>`).join('') + [35, 135].map(x => `<path d="M${x} 120 L${x} 200" stroke="#fff" stroke-width="1.5" opacity=".35"/>`).join('') }) +
      cel(id, 'cl', 'M78 116 L100 136 L90 146 L70 124 Z', shade(tc, 0.1), { w: 2.2 }) + cel(id, 'cr', 'M122 116 L100 136 L110 146 L130 124 Z', shade(tc, 0.1), { w: 2.2 }) + ink('M100 136 L100 200', 2.2, 0.8); break;
    case 11: s += body(tc) + hood(shade(tc, -0.2)) + ink('M90 136 L88 170 M110 136 L112 170', 2.4, 0.9) + ink('M60 186 L140 186', 3, 0.5); break;
    case 12: // windbreaker: two colours split on a slant, a zip and a stand-up collar
      s += body(tc) + cel(id, 'blk', 'M-12 168 L212 138 L212 200 L-12 200 Z', shade(tc, 0.45)) + ink('M-12 176 L212 146', 5, 1, CORAL) +
        cel(id, 'col', 'M74 112 L126 112 L128 128 C114 136 86 136 72 128 Z', shade(tc, -0.15), { w: 2.4 }) + ink('M100 132 L100 200', 3, 0.95) + ink('M100 132 L100 200', 1.2, 0.8, '#C9CED6'); break;
    case 13: s += body(tc) + hood(shade(tc, -0.2)) + ink('M100 128 L100 200', 3.2, 0.95) + ink('M100 128 L100 200', 1.2, 0.8, '#C9CED6') + ink('M88 136 L86 160 M112 136 L114 160', 2, 0.8); break;
    case 14: s += body(tc) + ink('M100 124 L100 200', 3, 0.9) + cel(id, 'col', 'M74 112 L92 112 L100 130 L108 112 L126 112 L128 128 L100 140 L72 128 Z', shade(tc, -0.15), { w: 2.4 }) + ink('M20 160 L20 200 M28 156 L28 200 M180 160 L180 200 M172 156 L172 200', 3, 0.85, '#fff'); break;
    case 15: s += body(tc) + sleeves('#E9E1D2') + cel(id, 'rib', 'M74 114 C86 128 114 128 126 114 L128 124 C114 138 86 138 72 124 Z', '#E9E1D2', { w: 2.4, inner: '<path d="M72 120 L128 120" stroke="' + tc + '" stroke-width="3"/>' }) +
      `<path d="M66 154 L70 164 L81 165 L72 172 L75 183 L66 177 L57 183 L60 172 L51 165 L62 164 Z" fill="#E9E1D2" stroke="${INK}" stroke-width="2" stroke-linejoin="round"/>` + ink('M100 136 L100 200', 2, 0.6) + [150, 164, 178, 192].map(y => dot(104, y, 1.8, '#E9E1D2', 1)).join(''); break;
    case 16: s += body(tc) + cel(id, 'rib', 'M74 114 C86 128 114 128 126 114 L128 124 C114 138 86 138 72 124 Z', CORAL, { w: 2.4 }) + ink('M100 136 L100 200', 2.6, 0.9) + ink('M100 136 L100 200', 1, 0.9, '#C9CED6') +
      ink('M-10 196 L210 196', 5, 1, CORAL); break;
    case 17: s += body('#3B6EA8') + ink('M100 128 L100 200', 2.4, 0.9) + cel(id, 'cl', 'M76 114 L96 136 L86 148 L66 124 Z', '#2F5C8E', { w: 2.2 }) + cel(id, 'cr', 'M124 114 L104 136 L114 148 L134 124 Z', '#2F5C8E', { w: 2.2 }) +
      cel(id, 'pk1', 'M58 158 L84 158 L84 176 L58 176 Z', '#2F5C8E', { w: 2 }) + cel(id, 'pk2', 'M116 158 L142 158 L142 176 L116 176 Z', '#2F5C8E', { w: 2 }) + ink('M58 158 L84 158 M116 158 L142 158 M40 150 L40 200 M160 150 L160 200', 1.4, 0.6, '#E3C27A'); break;
    case 18: s += body('#1A1817', { dark: 0.12 }) + cel(id, 'lpL', 'M76 114 L100 150 L84 170 L56 136 Z', '#2A2725', { w: 2.4, dark: 0.12 }) + cel(id, 'lpR', 'M124 114 L100 150 L116 170 L144 136 Z', '#2A2725', { w: 2.4, dark: 0.12 }) +
      ink('M108 150 L114 200', 2.6, 0.9, '#C9CED6') + ink('M30 150 C40 146 50 146 56 150', 4, 0.45, '#fff') + dot(66, 170, 2.2, '#C9CED6', 1) + dot(134, 170, 2.2, '#C9CED6', 1); break;
    case 19: s += body(shade(tc, -0.4)) + crew(shade(tc, -0.5)) + cel(id, 'vest', 'M8 200 L14 160 C24 150 40 146 56 144 L74 124 L100 136 L126 124 L144 144 C160 146 176 150 186 160 L192 200 Z', tc, { inner: [150, 166, 182].map(y => `<path d="M0 ${y} L200 ${y}" stroke="${shade(tc, -0.35)}" stroke-width="3"/>`).join('') }) + ink('M100 136 L100 200', 2.6, 0.9); break;
    case 20: s += body('#E2B23C') + cel(id, 'rib', 'M74 114 C86 128 114 128 126 114 L128 124 C114 138 86 138 72 124 Z', '#141312', { w: 2.4 }) + ink('M100 136 L100 200', 2.6, 0.9) +
      ink('M30 152 C40 146 52 144 60 146', 5, 0.7, '#fff') + ink('M-10 196 L210 196', 5, 1, '#141312'); break;
    case 22: s += body('#141312', { dark: 0.15 }) + ink('M24 146 L18 200 M34 142 L28 200 M176 146 L182 200 M166 142 L172 200', 3.4, 1, '#F2C14E') + cel(id, 'col', 'M74 112 L126 112 L128 128 C114 136 86 136 72 128 Z', '#1F1D1B', { w: 2.4, dark: 0.15 }) + ink('M100 132 L100 200', 3, 1, '#F2C14E'); break;
    case 23: s += body('#5B2A9E', { inner: '<path d="M-10 156 C30 140 60 140 90 160" stroke="#fff" stroke-width="9" opacity=".22" fill="none"/><path d="M120 150 C150 140 180 146 210 160" stroke="#fff" stroke-width="6" opacity=".14" fill="none"/>' }) + cel(id, 'rib', 'M74 114 C86 128 114 128 126 114 L128 124 C114 138 86 138 72 124 Z', '#F2C14E', { w: 2.4 }) + ink('M100 136 L100 200', 2.6, 0.9) + ink('M-10 196 L210 196', 5, 1, '#F2C14E'); break;
    case 24: s += `<defs><linearGradient id="${id}hj" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#7AD7FF"/><stop offset=".35" stop-color="#C9A8FF"/><stop offset=".7" stop-color="#FF9FD6"/><stop offset="1" stop-color="#B6FF9F"/></linearGradient></defs>` + `<path d="${P.body}" fill="url(#${id}hj)"/>` + `<g fill="#fff" opacity=".35">${[150, 162, 174, 186, 198].map(y => [10, 30, 50, 70, 90, 110, 130, 150, 170, 190].map(x => `<circle cx="${x + (y % 24 ? 10 : 0)}" cy="${y}" r="2"/>`).join('')).join('')}</g>` + `<path d="${P.body}" fill="none" stroke="${INK}" stroke-width="3.4"/>` + cel(id, 'v', 'M80 118 L100 146 L120 118 L114 118 L100 136 L86 118 Z', '#141312', { w: 2.2 }); break;
    case 25: s += `<defs><radialGradient id="${id}td" cx="50%" cy="80%" r="70%"><stop offset="0" stop-color="#FFE04A"/><stop offset=".3" stop-color="#FF6FB0"/><stop offset=".55" stop-color="#7B5CFF"/><stop offset=".8" stop-color="#3FD3FF"/><stop offset="1" stop-color="#FF6FB0"/></radialGradient></defs><path d="${P.body}" fill="url(#${id}td)"/><path d="${P.body}" fill="none" stroke="${INK}" stroke-width="3.4"/>` + cel(id, 'hood', 'M56 134 C60 108 80 98 100 98 C120 98 140 108 144 134 C126 126 112 124 100 124 C88 124 74 126 56 134 Z', '#5B3FCF') + ink('M90 136 L88 170 M110 136 L112 170', 2.4, 0.9); break;
    case 26: s += body('#121214', { dark: 0.1, inner: [150, 168, 186].map(y => `<path d="M-10 ${y} C60 ${y - 8} 140 ${y - 8} 210 ${y}" stroke="#000" stroke-width="3" fill="none"/><path d="M10 ${y - 9} C70 ${y - 16} 130 ${y - 16} 190 ${y - 9}" stroke="#fff" stroke-width="4" opacity=".2" fill="none"/>`).join('') }) + cel(id, 'col', 'M70 110 L130 110 L134 130 C116 140 84 140 66 130 Z', '#1E1E22', { w: 2.6, dark: 0.1 }) + ink('M100 136 L100 200', 2.6, 0.9, '#C9CED6'); break;
    case 27: s += body('#141312', { dark: 0.15 }) + cel(id, 'shL', 'M-12 200 L-12 176 C-8 154 14 142 40 138 C56 136 70 128 79 116 L82 122 C76 140 66 160 62 200 Z', sk.c) + cel(id, 'shR', 'M212 200 L212 176 C208 154 186 142 160 138 C144 136 130 128 121 116 L118 122 C124 140 134 160 138 200 Z', sk.c) + ink('M82 122 C76 140 66 160 62 200 M118 122 C124 140 134 160 138 200 M82 122 C90 132 110 132 118 122', 4, 1, '#F2C14E') + ink(P.delts, 2.6) + ink(P.traps, 2.6); break;
    case 21: s += body('#B0182A', { inner: '<path d="M-10 150 C40 130 70 140 80 130" stroke="#fff" stroke-width="5" opacity=".25" fill="none"/>' }) +
      cel(id, 'lpL', 'M74 114 L100 160 L90 200 L70 200 L56 134 Z', '#F2C14E', { w: 2.6 }) + cel(id, 'lpR', 'M126 114 L100 160 L110 200 L130 200 L144 134 Z', '#F2C14E', { w: 2.6 }) +
      `<text x="152" y="186" text-anchor="middle" font-family="Arial Black, Arial" font-weight="900" font-size="16" fill="#F2C14E" stroke="${INK}" stroke-width="1.6" paint-order="stroke">CHAMP</text>`; break;
  }
  return s;
}

// ── gear ─────────────────────────────────────────────────────────────────────
function gear(id, i) {
  switch (i) {
    case 1: return cel(id, 'sh', 'M70 74 L130 74 L128 88 C124 96 108 96 104 88 L100 82 L96 88 C92 96 76 96 72 88 Z', '#121212', { dark: 0.15, inner: '<path d="M76 77 L92 77 L80 90 Z M108 77 L124 77 L112 90 Z" fill="#fff" opacity=".35"/>' });
    case 2: return `<rect x="75" y="74" width="22" height="16" rx="6" fill="#fff" fill-opacity=".18" stroke="${INK}" stroke-width="2.6"/><rect x="103" y="74" width="22" height="16" rx="6" fill="#fff" fill-opacity=".18" stroke="${INK}" stroke-width="2.6"/>` + ink('M97 80 L103 80 M75 80 L66 78 M125 80 L134 78', 2.6, 1);
    case 3: return cel(id, 'sb', 'M64 54 C80 46 120 46 136 54 L136 64 C120 56 80 56 64 64 Z', '#C2452D') + ink('M70 58 L130 58', 1.4, 0.6, '#fff');
    case 4: return cel(id, 'bn', 'M62 60 C62 34 80 24 100 24 C120 24 138 34 138 60 C120 50 80 50 62 60 Z', '#2F6FD6') + cel(id, 'kn', 'M136 56 L156 48 L152 62 L160 72 L140 64 Z', '#2F6FD6', { w: 2.4 }) + [[80, 40], [100, 34], [120, 40], [90, 48], [110, 48]].map(([x, y]) => `<circle cx="${x}" cy="${y}" r="1.8" fill="#fff" opacity=".8"/>`).join('');
    case 5: return cel(id, 'cp', 'M62 62 C60 32 80 22 100 22 C120 22 140 32 138 62 C124 52 76 52 62 62 Z', '#141312', { dark: 0.2 }) + cel(id, 'cb', 'M90 24 C94 18 106 18 110 24 L108 32 L92 32 Z', '#2F6FD6', { w: 2.2 });
    case 6: return cel(id, 'cp', 'M62 60 C60 30 80 20 100 20 C120 20 140 30 138 60 C124 50 76 50 62 60 Z', '#C2452D') + cel(id, 'brim', 'M58 60 C76 52 124 52 142 60 C150 64 150 70 140 70 C120 64 80 64 60 70 C50 70 50 64 58 60 Z', '#9A2E1C', { w: 2.6 }) + ink('M100 20 L100 50', 1.6, 0.5);
    case 7: return cel(id, 'bk', 'M66 56 C66 32 82 22 100 22 C118 22 134 32 134 56 Z', '#C8B98A') + cel(id, 'bkb', 'M52 64 C56 52 144 52 148 64 C150 70 138 72 100 70 C62 72 50 70 52 64 Z', '#B1A274', { w: 2.6 });
    case 8: return cel(id, 'be', 'M60 64 C58 30 80 16 100 16 C120 16 142 30 140 64 L140 56 C120 50 80 50 60 56 Z', '#7B3FC4') + cel(id, 'cuff', 'M58 54 C80 46 120 46 142 54 L142 66 C120 58 80 58 58 66 Z', shade('#7B3FC4', -0.15)) + dot(100, 14, 8, '#F2B33D');
    case 9: return cel(id, 'dr', 'M62 62 C60 30 80 20 100 20 C120 20 140 30 138 62 C124 54 76 54 62 62 Z', '#141312', { dark: 0.2, inner: '<path d="M70 40 C90 30 112 30 132 40" stroke="#fff" stroke-width="3" opacity=".25" fill="none"/>' }) + cel(id, 'tail', 'M132 52 C150 56 156 80 150 100 L142 98 C146 80 142 64 130 60 Z', '#141312', { dark: 0.2, w: 2.4 });
    case 10: return cel(id, 'vi', 'M58 60 C76 52 124 52 142 60 C150 64 150 70 140 70 C120 64 80 64 60 70 C50 70 50 64 58 60 Z', '#2F6FD6', { w: 2.6 }) + cel(id, 'vb', 'M64 56 C80 48 120 48 136 56 L136 62 C120 56 80 56 64 62 Z', '#E9E1D2', { w: 2.2 });
    case 11: return cel(id, 'hp', 'M66 128 C64 146 136 146 134 128 C130 140 70 140 66 128 Z', '#202020', { dark: 0.2 }) + cel(id, 'cL', 'M54 120 C46 120 44 138 54 140 C62 140 66 122 54 120 Z', '#2b2b2b', { dark: 0.2 }) + cel(id, 'cR', 'M146 120 C154 120 156 138 146 140 C138 140 134 122 146 120 Z', '#2b2b2b', { dark: 0.2 });
    case 12: return dot(62, 84, 4, '#F5F5F4', 1.6) + dot(138, 84, 4, '#F5F5F4', 1.6) + ink('M62 88 L62 96 M138 88 L138 96', 2.6, 1, '#F5F5F4');
    case 13: return dot(62, 96, 3.2, '#F2C14E', 1.6) + dot(138, 96, 3.2, '#F2C14E', 1.6);
    case 14: return `<path d="M68 132 C74 164 126 164 132 132" fill="none" stroke="${INK}" stroke-width="7" stroke-linecap="round"/><path d="M68 132 C74 164 126 164 132 132" fill="none" stroke="#D7DDE4" stroke-width="4" stroke-dasharray="3 2" stroke-linecap="round"/>`;
    case 15: return ink('M72 130 C80 156 120 156 128 130', 2, 1) + `<rect x="92" y="150" width="14" height="20" rx="3" fill="#C9CED6" stroke="${INK}" stroke-width="2" transform="rotate(-8 99 160)"/><rect x="100" y="152" width="14" height="20" rx="3" fill="#B8C2CC" stroke="${INK}" stroke-width="2" transform="rotate(10 107 162)"/>`;
    case 16: return ink('M76 130 C84 152 116 152 124 130', 2.4, 1, '#C2452D') + `<path d="M92 156 L108 156 L110 166 L94 168 Z" fill="#C9CED6" stroke="${INK}" stroke-width="2"/>` + dot(96, 160, 2, INK, 1);
    case 17: return cel(id, 'tw', 'M128 118 C150 120 176 132 190 150 L178 200 L152 200 C152 170 140 146 122 132 Z', '#F4EDE0', { dark: -0.12 }) + ink('M160 150 L150 200 M172 154 L164 200', 1.6, 0.4);
    case 18: return cel(id, 'mk', 'M68 86 C78 90 122 90 132 86 C134 108 120 122 100 124 C80 122 66 108 68 86 Z', '#151413', { dark: 0.15 }) + ink('M76 96 L124 96', 1.4, 0.25, '#fff');
    case 19: return `<path d="M64 132 C70 168 130 168 136 132" fill="none" stroke="${INK}" stroke-width="9" stroke-linecap="round"/><path d="M64 132 C70 168 130 168 136 132" fill="none" stroke="#F2C14E" stroke-width="5.5" stroke-dasharray="5 3" stroke-linecap="round"/>` + dot(100, 162, 8, '#F2C14E', 2.6);
    case 20: return ink('M84 126 L100 150 L116 126', 6, 1, '#2F6FD6') + ink('M84 126 L100 150 L116 126', 2, 1) + dot(100, 160, 11, '#C9CED6', 2.8) + `<text x="100" y="165" text-anchor="middle" font-family="Arial Black, Arial" font-size="12" font-weight="900" fill="${INK}">2</text>`;
    case 21: return [...Array(6)].map((_, k) => {
      const a = 3.6 - k * 0.22, x = 100 + 46 * Math.cos(a), y = 70 - 40 * Math.sin(a); const x2 = 100 - 46 * Math.cos(a);
      return `<ellipse cx="${x}" cy="${y}" rx="8" ry="4" transform="rotate(${-k * 14 + 30} ${x} ${y})" fill="#2E8B57" stroke="${INK}" stroke-width="2"/><ellipse cx="${x2}" cy="${y}" rx="8" ry="4" transform="rotate(${k * 14 - 30} ${x2} ${y})" fill="#2E8B57" stroke="${INK}" stroke-width="2"/>`;
    }).join('');
    case 22: return cel(id, 'hnL', 'M70 44 C60 30 58 14 66 4 C68 16 74 28 82 34 Z', '#C2452D', { w: 2.6 }) + cel(id, 'hnR', 'M130 44 C140 30 142 14 134 4 C132 16 126 28 118 34 Z', '#C2452D', { w: 2.6 });
    case 23: return cel(id, 'blt', 'M10 158 C60 140 140 140 190 158 L186 182 C140 166 60 166 14 182 Z', '#141312', { dark: 0.15 }) + cel(id, 'plate', 'M76 150 L124 150 L128 176 L72 176 Z', '#F2C14E') + dot(100, 163, 7, '#C2452D', 2);
    case 24: return `<ellipse cx="100" cy="12" rx="30" ry="8" fill="none" stroke="${INK}" stroke-width="7"/><ellipse cx="100" cy="12" rx="30" ry="8" fill="none" stroke="#FFE08A" stroke-width="4"/><ellipse cx="100" cy="12" rx="38" ry="14" fill="#FFE08A" opacity=".22"/>`;
    case 26: return cel(id, 'hp', 'M66 128 C64 146 136 146 134 128 C130 140 70 140 66 128 Z', '#F2C14E') + cel(id, 'cL', 'M54 120 C46 120 44 138 54 140 C62 140 66 122 54 120 Z', '#E2B23C') + cel(id, 'cR', 'M146 120 C154 120 156 138 146 140 C138 140 134 122 146 120 Z', '#E2B23C');
    case 27: return [62, 138].map(x => `<path d="M${x} 90 L${x + 4} 95 L${x} 100 L${x - 4} 95 Z" fill="#E8FDFF" stroke="${INK}" stroke-width="1.4"/><path d="M${x - 1} 92 L${x + 1} 92" stroke="#fff" stroke-width="1"/>`).join('');
    case 28: return `<path d="M62 74 C80 70 120 70 138 74 L136 90 C118 86 82 86 64 90 Z" fill="#4DF2FF" fill-opacity=".55" stroke="${INK}" stroke-width="2.8"/>` + ink('M68 80 L132 80', 2, 0.8, '#fff');
    case 29: return `<path d="M64 132 C70 168 130 168 136 132" fill="none" stroke="${INK}" stroke-width="10" stroke-linecap="round"/><path d="M64 132 C70 168 130 168 136 132" fill="none" stroke="#E8FDFF" stroke-width="6.5" stroke-dasharray="4 2" stroke-linecap="round"/>` + `<path d="M100 152 L110 162 L100 176 L90 162 Z" fill="#E8FDFF" stroke="${INK}" stroke-width="2.4"/><path d="M94 162 L106 162" stroke="#9FE3FF" stroke-width="1.4"/>`;
    case 30: return `<path d="M60 70 C60 30 80 16 100 16 C120 16 140 30 140 70 C140 100 126 124 100 128 C74 124 60 100 60 70 Z" fill="none" stroke="#B26BFF" stroke-width="10" opacity=".22"/><path d="M56 70 C56 26 78 10 100 10 C122 10 144 26 144 70" fill="none" stroke="#FF4FD8" stroke-width="4" opacity=".35"/>` + [[56, 30], [146, 40], [62, 108], [140, 104], [100, 6]].map(([x, y]) => `<path d="M${x} ${y - 5} L${x + 1.5} ${y - 1.5} L${x + 5} ${y} L${x + 1.5} ${y + 1.5} L${x} ${y + 5} L${x - 1.5} ${y + 1.5} L${x - 5} ${y} L${x - 1.5} ${y - 1.5} Z" fill="#fff"/>`).join('');
    case 25: return cel(id, 'crown', 'M66 40 L72 8 L86 26 L100 2 L114 26 L128 8 L134 40 Z', '#F2C14E') + dot(100, 30, 4, '#C2452D', 1.8) + dot(80, 34, 3, '#2F6FD6', 1.6) + dot(120, 34, 3, '#2E8B57', 1.6);
    default: return '';
  }
}

// ── the lifter ───────────────────────────────────────────────────────────────
function lifterSvg(c, view) {
  const id = 'A' + (++uid);
  const sk = CAT.skin[c.skin];
  const hc = sk.fx === 'cyborg' ? '#5c6f7d' : CAT.hairC[c.hairC];
  const tc = CAT.topC[c.topC];
  const h = hair(id, c.hair, hc);
  const masked = c.gear === 18;
  const hatted = [5, 6, 7, 8, 9, 10].includes(c.gear);
  // 'nobg': the lifter alone, for a head that breaks out of its circle.
  // 'bgonly': the background alone, for a profile's cover.
  if (view === 'bgonly') return `<svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">${background(id, c.bg, c.pattern ?? 0)}</svg>`;
  let s = view === 'nobg' ? '' : background(id, c.bg, c.pattern ?? 0);
  s += topWear(id, c.top, tc, sk);
  s += cel(id, 'neck', P.neck, shade(sk.c, -0.06)) + ink(P.neckLines, 2.6);
  s += h.back;
  s += cel(id, 'earL', P.earL, sk.c) + cel(id, 'earR', P.earR, sk.c);
  s += cel(id, 'head', P.head, sk.c) + skinFx(id, sk) + ink(P.jaw, 2.4, 0.6);
  s += marks(c.marks);
  s += brows(c.brows, hc) + eyes(id, c.eyes, sk);
  s += ink('M100 82 L95 98 C98 101 103 101 106 98', 2.4, 1);
  if (!masked) s += mouth(c.mouth) + beard(id, c.beard, hc);
  if (!hatted || c.hair === 12 || c.hair === 10) s += h.front;
  s += gear(id, c.gear);
  const vb = view === 'head' ? '30 -6 140 140' : '0 0 200 200';
  return `<svg viewBox="${vb}" xmlns="http://www.w3.org/2000/svg">${s}</svg>`;
}

function rarityOf(c) {
  const order = ['Common', 'Rare', 'Epic', 'Legendary'];
  let best = 0;
  const bump = (it) => { if (it && it.r) best = Math.max(best, order.indexOf(it.r)); };
  bump(CAT.skin[c.skin]); bump(CAT.eyes[c.eyes]); bump(CAT.mouth[c.mouth]); bump(CAT.gear[c.gear]); bump(CAT.top[c.top]); bump(CAT.pattern[c.pattern ?? 0]);
  return order[best];
}
