// Per-market keyword research: in each locale's own storefront, Apple's
// suggestions for the local words for push-ups, a push-up counter and a
// push-up challenge, and how many ratings the top apps for the first term
// carry (a rough difficulty). Appends to markets.json.
//   node markets.js <locale> [<locale> ...]
const fs = require('fs');

const S = {
  US: 143441, GB: 143444, CA: 143455, AU: 143460, DE: 143443, FR: 143442,
  ES: 143454, MX: 143468, BR: 143503, PT: 143453, IT: 143450, NL: 143452,
  SE: 143456, NO: 143457, DK: 143458, FI: 143447, PL: 143478, CZ: 143489,
  SK: 143496, HU: 143482, RO: 143487, HR: 143494, SI: 143499, GR: 143448,
  TR: 143480, RU: 143469, UA: 143492, JP: 143462, KR: 143466, CN: 143465,
  TW: 143470, TH: 143475, VN: 143471, ID: 143476, MY: 143473, IN: 143467,
  SA: 143479, IL: 143491, PK: 143477, BD: 143490,
};

const en = ['push up', 'push up counter', 'push up challenge'];
const T = {
  'en-US': ['US', en], 'en-GB': ['GB', ['press up', ...en]], 'en-AU': ['AU', en], 'en-CA': ['CA', en],
  'de-DE': ['DE', ['liegestütze', 'liegestütze zähler', 'liegestütze challenge']],
  'fr-FR': ['FR', ['pompes', 'compteur pompes', 'défi pompes']],
  'fr-CA': ['CA', ['pompes', 'push up', 'défi pompes']],
  'es-ES': ['ES', ['flexiones', 'contador flexiones', 'reto flexiones']],
  'es-MX': ['MX', ['lagartijas', 'flexiones', 'contador de lagartijas']],
  'ca': ['ES', ['flexions', 'flexiones', 'push up']],
  'pt-BR': ['BR', ['flexão', 'flexões', 'contador de flexões']],
  'pt-PT': ['PT', ['flexões', 'contador flexões', 'push up']],
  'it': ['IT', ['flessioni', 'contatore flessioni', 'sfida flessioni']],
  'nl-NL': ['NL', ['opdrukken', 'push ups', 'push up teller']],
  'sv': ['SE', ['armhävningar', 'push ups', 'armhävning']],
  'no': ['NO', ['armhevinger', 'push ups', 'armheving']],
  'da': ['DK', ['armbøjninger', 'push ups', 'armbøjning']],
  'fi': ['FI', ['punnerrukset', 'punnerrus', 'push up']],
  'pl': ['PL', ['pompki', 'licznik pompek', 'wyzwanie pompki']],
  'cs': ['CZ', ['kliky', 'počítadlo kliků', 'push up']],
  'sk': ['SK', ['kľuky', 'kliky', 'push up']],
  'hu': ['HU', ['fekvőtámasz', 'fekvőtámasz számláló', 'push up']],
  'ro': ['RO', ['flotări', 'flotari', 'push up']],
  'hr': ['HR', ['sklekovi', 'sklek', 'push up']],
  'sl-SI': ['SI', ['sklece', 'push up', 'sklec']],
  'el': ['GR', ['κάμψεις', 'push ups', 'push up']],
  'tr': ['TR', ['şınav', 'şınav sayacı', 'şınav challenge']],
  'ru': ['RU', ['отжимания', 'счетчик отжиманий', 'отжимания челлендж']],
  'uk': ['UA', ['віджимання', 'лічильник віджимань', 'push up']],
  'ja': ['JP', ['腕立て伏せ', '腕立て カウンター', 'プッシュアップ']],
  'ko': ['KR', ['팔굽혀펴기', '푸시업', '푸쉬업']],
  'zh-Hans': ['CN', ['俯卧撑', '俯卧撑计数', '俯卧撑挑战']],
  'zh-Hant': ['TW', ['伏地挺身', '伏地挺身計數', '伏地挺身挑戰']],
  'th': ['TH', ['วิดพื้น', 'push up', 'นับวิดพื้น']],
  'vi': ['VN', ['hít đất', 'chống đẩy', 'push up']],
  'id': ['ID', ['push up', 'push up counter', 'tantangan push up']],
  'ms': ['MY', ['tekan tubi', 'push up', 'push up counter']],
  'hi': ['IN', ['push up', 'पुश अप', 'push up counter']],
  'gu-IN': ['IN', en], 'kn-IN': ['IN', en], 'ml-IN': ['IN', en], 'mr-IN': ['IN', en],
  'or-IN': ['IN', en], 'pa-IN': ['IN', en], 'ta-IN': ['IN', en], 'te-IN': ['IN', en],
  'bn-BD': ['BD', ['push up', 'পুশ আপ', 'push up counter']],
  'ur-PK': ['PK', ['push up', 'پش اپ', 'push up counter']],
  'ar-SA': ['SA', ['تمارين الضغط', 'ضغط', 'push up']],
  'he': ['IL', ['שכיבות סמיכה', 'push up', 'push ups']],
};

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
const country = (code) => code.toLowerCase();

async function hints(store, term) {
  const url = `https://search.itunes.apple.com/WebObjects/MZSearchHints.woa/wa/hints?clientApplication=Software&term=${encodeURIComponent(term)}`;
  const xml = await (await fetch(url, { headers: { 'X-Apple-Store-Front': `${store}-1,29` } })).text();
  return [...xml.matchAll(/<key>term<\/key>\s*<string>([^<]*)<\/string>/g)].map((m) => m[1].replace(/&amp;/g, '&'));
}

async function top(cc, term) {
  const url = `https://itunes.apple.com/search?term=${encodeURIComponent(term)}&entity=software&country=${cc}&limit=10`;
  const json = await (await fetch(url)).json();
  return (json.results || []).slice(0, 5).map((a) => `${a.trackName} [${a.userRatingCount || 0}]`);
}

(async () => {
  const file = 'markets.json';
  const all = fs.existsSync(file) ? JSON.parse(fs.readFileSync(file, 'utf8')) : {};
  for (const locale of process.argv.slice(2)) {
    const [cc, seeds] = T[locale];
    const out = { store: cc, seeds: {} };
    for (const seed of seeds) {
      try {
        out.seeds[seed] = { hints: await hints(S[cc], seed) };
      } catch (e) {
        out.seeds[seed] = { error: e.message };
      }
      await sleep(400);
    }
    try {
      out.top = await top(country(cc), seeds[0]);
    } catch (e) {
      out.top = [e.message];
    }
    all[locale] = out;
    const counts = seeds.map((s) => `${s}:${(out.seeds[s].hints || []).length}`).join('  ');
    console.log(`${locale.padEnd(8)} ${cc}  ${counts}`);
    await sleep(400);
  }
  fs.writeFileSync(file, JSON.stringify(all, null, 1));
})();
