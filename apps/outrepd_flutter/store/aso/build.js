// Writes the App Store listing for every locale into the fastlane layout
// (fastlane/metadata/<locale>/<field>.txt) and checks it the way vibe-aso's
// phase 2 asks: Apple's character limits, the URLs byte-identical, the
// brand present in every name, no pricing words.
//   node store/aso/build.js
const fs = require('fs');
const path = require('path');

const locales = {
  ...require('./en.js'),
  ...(fs.existsSync(path.join(__dirname, 'app_langs.js')) ? require('./app_langs.js') : {}),
  ...(fs.existsSync(path.join(__dirname, 'more_langs.js')) ? require('./more_langs.js') : {}),
};

// What's New for the version being prepared, per locale (notes.js).
const notes = fs.existsSync(path.join(__dirname, 'notes.js')) ? require('./notes.js') : {};

const out = path.join(__dirname, '..', '..', 'fastlane', 'metadata');
const limits = {
  name: 30,
  subtitle: 30,
  keywords: 100,
  promotional_text: 170,
  description: 4000,
  release_notes: 4000,
};
const atoms = ['https://www.outrepd.com/terms', 'https://www.outrepd.com/privacy'];
// Apple bounces pricing language in a paywalled app's listing (3.1.2/5.6).
const pricing = /\bfree\b|gratis|kostenlos|gratuit|\$|€|£|¥|₹/i;

let problems = 0;
const say = (locale, what) => {
  problems++;
  console.log(`  ${locale}: ${what}`);
};

for (const [locale, raw] of Object.entries(locales)) {
  // Composed form (NFC): what Apple counts, and what a store field holds.
  const f = Object.fromEntries(Object.entries(raw).map(([k, v]) => [k, v.normalize('NFC')]));
  const fields = {
    name: f.name,
    subtitle: f.subtitle,
    keywords: f.keywords,
    promotional_text: f.promo,
    description: f.description,
    privacy_url: 'https://www.outrepd.com/privacy',
    release_notes: (notes[locale] ?? '').normalize('NFC'),
  };
  for (const [field, limit] of Object.entries(limits)) {
    const value = fields[field] ?? '';
    // Apple counts characters, not bytes: code points, as in [...value].
    const length = [...value].length;
    if (!value) say(locale, `${field} is empty`);
    if (length > limit) say(locale, `${field} is ${length} (limit ${limit})`);
  }
  if (!fields.name.includes('OUTREPD')) say(locale, 'the name lost the brand');
  if (/\s/.test(fields.keywords) && !/^[^\s]*$/.test(fields.keywords.replace(/ /g, ''))) {
    say(locale, 'keywords have spaces');
  }
  if (fields.keywords.includes(' ,') || fields.keywords.includes(', ')) say(locale, 'space beside a comma in keywords');
  for (const atom of atoms) {
    if (!fields.description.includes(atom)) say(locale, `description lost ${atom}`);
  }
  for (const field of ['promotional_text', 'description', 'subtitle', 'release_notes']) {
    const m = fields[field].match(pricing);
    if (m) say(locale, `pricing word "${m[0]}" in ${field}`);
  }
  const dir = path.join(out, locale);
  fs.mkdirSync(dir, { recursive: true });
  for (const [field, value] of Object.entries(fields)) {
    fs.writeFileSync(path.join(dir, `${field}.txt`), `${value}\n`);
  }
  const n = (s) => [...s].length;
  console.log(
    `${locale.padEnd(8)} name ${String(n(f.name)).padStart(2)}  subtitle ${String(n(f.subtitle)).padStart(2)}  ` +
      `keywords ${String(n(f.keywords)).padStart(3)}  promo ${String(n(f.promo)).padStart(3)}  description ${n(f.description)}`,
  );
}
console.log(`${Object.keys(locales).length} locales, ${problems} problems`);
process.exitCode = problems ? 1 : 0;
