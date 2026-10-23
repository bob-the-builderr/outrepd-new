// Keyword research without a paid tool: Apple's own search suggestions
// (ordered by what people type) and the apps that rank for each term, with
// their rating counts as a rough difficulty.
//   node research.js <out.json> [store=143441] [lang=en] [seeds...]
const fs = require('fs');
const [out, store = '143441', country = 'us', ...seedArgs] = process.argv.slice(2);
const seeds = seedArgs.length ? seedArgs : [
  'push up', 'pushup', 'push ups', 'pushups', 'push up challenge', 'push up counter',
  'push up tracker', 'pushup counter', 'push up workout', 'push up battle',
  'calisthenics', 'home workout', 'fitness challenge', 'workout challenge',
  'fitness game', 'workout game', 'rep counter', 'exercise counter',
  'ai trainer', 'ai fitness', 'fitness duel', 'workout battle', '1v1',
  'strength training', 'bodyweight workout', 'chest workout', '100 push ups',
];

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

async function hints(term) {
  const url = `https://search.itunes.apple.com/WebObjects/MZSearchHints.woa/wa/hints?clientApplication=Software&term=${encodeURIComponent(term)}`;
  const res = await fetch(url, { headers: { 'X-Apple-Store-Front': `${store}-1,29` } });
  const xml = await res.text();
  return [...xml.matchAll(/<key>term<\/key>\s*<string>([^<]*)<\/string>/g)].map((m) =>
    m[1].replace(/&amp;/g, '&').replace(/&#39;/g, "'"));
}

async function ranking(term) {
  const url = `https://itunes.apple.com/search?term=${encodeURIComponent(term)}&entity=software&country=${country}&limit=10`;
  const res = await fetch(url);
  const json = await res.json();
  return (json.results || []).map((a) => ({
    name: a.trackName,
    ratings: a.userRatingCount || 0,
    genre: a.primaryGenreName,
  }));
}

(async () => {
  const data = {};
  for (const seed of seeds) {
    try {
      const h = await hints(seed);
      const r = await ranking(seed);
      const top = r.slice(0, 5).map((a) => a.ratings);
      data[seed] = {
        suggestions: h,
        top10: r,
        medianTop5Ratings: top.sort((a, b) => a - b)[Math.floor(top.length / 2)] || 0,
      };
      console.log(`${seed.padEnd(20)} hints:${String(h.length).padStart(2)}  top5 median ratings:${data[seed].medianTop5Ratings}  | ${h.slice(0, 6).join(' / ')}`);
    } catch (e) {
      console.log(`${seed}: ${e.message}`);
    }
    await sleep(700);
  }
  fs.writeFileSync(out, JSON.stringify(data, null, 1));
})();
