// Writes lib/lifter/pro_art.dart: the Pro parts the user picked
// (2026-11-04), taken from the very drawings they picked them in —
// design/mockups/2026-11-04 — so the app draws exactly what was approved.
//
//   node tool/lifter/pro_parts.js        (from apps/outrepd_flutter)
//
// Each mockup page is run in a sandbox with lifterA.js (the JS lifter the
// Dart one was ported from), its compose() swapped for one that hands back
// the parts instead of drawing a lifter. Then each part is made fit for the
// app's SVG renderer, which draws no filters: a blurred glow becomes soft
// strokes, and every id gets the part's own prefix, so parts drawn together
// never share one.
'use strict';
const fs = require('fs');
const path = require('path');
const vm = require('vm');

const root = path.resolve(__dirname, '..', '..');
const mock = path.resolve(root, '..', '..', 'design', 'mockups', '2026-11-04');
const lib = fs.readFileSync(path.join(mock, 'lifterA.js'), 'utf8');

// A page's script, run with lifterA.js; compose() then returns its overrides.
function load(page) {
  const html = fs.readFileSync(path.join(mock, page), 'utf8');
  const js = html.slice(html.lastIndexOf('<script>') + 8, html.lastIndexOf('</script>'));
  const ctx = { Math, console, document: { getElementById: () => ({ set innerHTML(_) {} }) } };
  vm.createContext(ctx);
  vm.runInContext(lib, ctx);
  vm.runInContext(js, ctx);
  vm.runInContext('compose = (c, o) => o; lifter = (c, back, front, defs) => ({ hairBack: back, hairFront: front, defs });', ctx);
  return (expr) => vm.runInContext(expr, ctx);
}

// ── fit for the app ──────────────────────────────────────────────────────────

const attrs = (s) => { const m = {}; for (const [, k, v] of s.matchAll(/([\w-]+)="([^"]*)"/g)) m[k] = v; return m; };
const tag = (name, a) => `<${name} ${Object.entries(a).map(([k, v]) => `${k}="${v}"`).join(' ')}/>`;

function soften(svg) {
  let s = svg.replace(/<filter\b[^>]*>[\s\S]*?<\/filter>/g, '');
  // A group drawn blurred: its strokes again, wider and faint.
  s = s.replace(/<g filter="url\(#[^)]+\)"(?: opacity="[^"]*")?>([\s\S]*?)<\/g>/g, (_, inner) =>
    `<g opacity=".3">${inner.replace(/stroke-width="([\d.]+)"/g, (_, w) => `stroke-width="${(+w * 2.2).toFixed(1)}"`)}</g>`);
  // One shape drawn blurred: a stroke, it is a line's glow; a fill, a halo.
  s = s.replace(/<(path|circle|ellipse|rect)\b([^>]*?)\/>/g, (whole, name, rest) => {
    if (!/filter="url\(#/.test(rest)) return whole;
    const a = attrs(rest);
    delete a.filter;
    if (a.stroke && a.stroke !== 'none') {
      const w = +(a['stroke-width'] || 2);
      return tag(name, { ...a, 'stroke-width': (w * 1.9).toFixed(1), opacity: '.28' });
    }
    const colour = a.fill || '#fff';
    delete a.fill; delete a.opacity;
    return tag(name, { ...a, fill: 'none', stroke: colour, 'stroke-width': '7', opacity: '.18', 'stroke-linejoin': 'round' }) +
      tag(name, { ...a, fill: 'none', stroke: colour, 'stroke-width': '3.6', opacity: '.32', 'stroke-linejoin': 'round' });
  });
  return s;
}

function own(prefix, svg) {
  const ids = [...new Set([...svg.matchAll(/id="([^"]+)"/g)].map((m) => m[1]))];
  let s = svg;
  for (const id of ids) {
    s = s.split(`id="${id}"`).join(`id="${prefix}${id}"`).split(`url(#${id})`).join(`url(#${prefix}${id})`).split(`href="#${id}"`).join(`href="#${prefix}${id}"`);
  }
  return s;
}

const fit = (prefix, svg) => own(prefix, soften(svg || ''));

// ── the picks ────────────────────────────────────────────────────────────────

const parts = load('pro_parts.html');
const fixes = load('pro_fixes.html');
const fixes2 = load('pro_fixes2.html');
const fixes3 = load('pro_fixes3.html');
const item = (run, section, code) => run(`(() => { const s = sections.find((s) => s.title === ${JSON.stringify(section)}); const it = s.items.find((i) => i[0] === ${JSON.stringify(code)}); return it[2](); })()`);

const hair = {};
for (const [code, id] of [['H1', 'inferno'], ['H2', 'galaxy_afro'], ['H3', 'bolt_fade'], ['H4', 'neon_dreads']]) {
  const o = item(parts, 'الشعر', code);
  const p = id.slice(0, 3) + '_';
  hair[id] = { back: fit(p, (o.defs || '') + (o.hairBack || '')), front: fit(p, (o.defs || '') + (o.hairFront || '')) };
  // The defs once, in front: the back takes its gradients from there too.
  hair[id].back = hair[id].back.replace(/<defs>[\s\S]*?<\/defs>/, '');
}

const beards = {};
for (const [code, id] of [['B1', 'flame_beard'], ['B2', 'gold_braids'], ['B3', 'frost_beard']]) {
  const o = item(parts, 'الدقن', code);
  beards[id] = fit(id.slice(0, 3) + 'b_', (o.defs || '') + o.beard);
}
{ const o = fixes2('galaxyBeard()'); beards.galaxy_beard = fit('gab_', (o.defs || '') + o.beard); }

const mouths = {};
{ const o = fixes2('bubbleGum()'); mouths.bubble_gum = fit('bgm_', (o.defs || '') + o.mouth); }
{ const o = item(parts, 'البُق', 'M2'); mouths.fangs = fit('fng_', (o.defs || '') + o.mouth); }
{ const o = item(parts, 'البُق', 'M3'); mouths.fire_breath = fit('fbr_', (o.defs || '') + o.mouth); }
{ const o = fixes2('sharkGrin()'); mouths.shark_grin = fit('shk_', (o.defs || '') + o.mouth); }

const marks = {};
for (const [code, id] of [['F2', 'lightning_bolt'], ['F3', 'face_gems'], ['F4', 'gold_flakes']]) {
  const o = item(parts, 'علامات الوش', code);
  marks[id] = fit(id.slice(0, 3) + 'm_', (o.defs || '') + o.marks);
}

const eyes = {};
for (const [expr, run, id] of [['hypno()', fixes, 'hypno'], ['diamondEyes()', fixes, 'diamond_eyes'], ['snakeEyes()', fixes2, 'snake_eyes'], ['electricEyes()', fixes, 'electric'], ['goldEyes()', fixes2, 'gold_eyes']]) {
  const o = run(expr);
  eyes[id] = fit(id.slice(0, 3) + 'e_', (o.defs || '') + o.eyes);
}

// Clothes, drawn over the whole body.
const tops = {};
{ const o = fixes('heroCape()'); tops.hero_cape = fit('hcp_', (o.defs || '') + o.top); }
for (const [code, id] of [['T2', 'chrome_armor'], ['T3', 'galaxy_hoodie'], ['T4', 'flame_jersey']]) {
  const o = item(parts, 'اللبس', code);
  tops[id] = fit(id.slice(0, 3) + 't_', (o.defs || '') + o.top);
}

// What is worn: in front, or (wings) behind the body.
const gear = {}, gearBack = {};
for (const [expr, run, id] of [['shutterShades()', fixes2, 'shutter_shades'], ['flameBand()', fixes, 'flame_headband'], ['dragon()', fixes, 'pet_dragon']]) {
  const o = run(expr);
  gear[id] = fit(id.slice(0, 3) + 'g_', (o.defs || '') + o.gear);
}
for (const [expr, run, id] of [['neonWings()', fixes2, 'neon_wings'], ['batWings()', fixes3, 'bat_wings']]) {
  const o = run(expr);
  gearBack[id] = fit(id.slice(0, 3) + 'w_', (o.defs || '') + o.under);
}

// Backgrounds: the whole square.
const patterns = {};
for (const [code, id] of [['P1', 'synthwave'], ['P2', 'sakura'], ['P3', 'deep_sea'], ['P4', 'confetti']]) {
  const o = item(parts, 'خلفية الأفاتار', code);
  patterns[id] = fit(id.slice(0, 3) + 'p_', (o.defs || '') + o.bg);
}

// The free afro, redrawn: its outline, and its coils in a colour the app fills
// in (HCL, the hair colour lightened).
const afroOutline = parts('afroShape()');
const afroCoils = parts("coils('HCL', 0.55)");

// ── the Dart ─────────────────────────────────────────────────────────────────

const lit = (s) => { if (s.includes("'''")) throw new Error('triple quote in a drawing'); return `r'''${s}'''`; };
const map = (name, doc, m, type = 'String', val = lit) =>
  `${doc}\nconst ${name} = <String, ${type}>{\n${Object.entries(m).map(([k, v]) => `  '${k}': ${val(v)},`).join('\n')}\n};\n`;

const out = `// GENERATED by tool/lifter/pro_parts.js from the drawings the user picked
// (design/mockups/2026-11-04). Do not edit: change the drawing there and run
// the tool again.
//
// Each value is SVG in the lifter's 200 × 200 space (lifter_art.dart), its ids
// its own. Glows are soft strokes: the app's SVG renderer draws no filters.
// ignore_for_file: lines_longer_than_80_chars
library;

${map('proHair', '/// Pro hair by part id: what goes behind the head, and what in front.', hair, '({String back, String front})', (v) => `(back: ${lit(v.back)}, front: ${lit(v.front)})`)}
${map('proBeards', '/// Pro beards by part id, drawn under the mouth.', beards)}
${map('proMouths', '/// Pro mouths by part id.', mouths)}
${map('proMarks', '/// Pro face marks by part id.', marks)}
${map('proEyes', '/// Pro eyes by part id, eye whites and lids included.', eyes)}
${map('proTops', '/// Pro clothes by part id, the whole body.', tops)}
${map('proGear', '/// Pro gear by part id, worn in front.', gear)}
${map('proGearBack', '/// Pro gear by part id that is worn behind the body: wings.', gearBack)}
${map('proPatterns', '/// Pro backgrounds by part id: the whole square.', patterns)}
/// The afro's outline (hair 5): a cloud of hair, ending above the ears.
const afroOutline = ${lit(afroOutline)};

/// The afro's coils; HCL is where the lightened hair colour goes.
const afroCoils = ${lit(afroCoils)};
`;
fs.writeFileSync(path.join(root, 'lib', 'lifter', 'pro_art.dart'), out);
console.log('pro_art.dart:', Object.keys(hair).length, 'hair,', Object.keys(beards).length, 'beards,', Object.keys(mouths).length, 'mouths,', Object.keys(marks).length, 'marks,', Object.keys(eyes).length, 'eyes,', Object.keys(tops).length, 'tops,', Object.keys(gear).length + Object.keys(gearBack).length, 'gear,', Object.keys(patterns).length, 'backgrounds;', out.length, 'chars');
