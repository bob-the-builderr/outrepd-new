// Builds outrepd.com's app-ads.txt from the three sources here:
//   node build.js <ironSource publisher id>  >  app-ads.txt
// AdMob's line (live since 2026-10-29), Unity Ads' list as its dashboard
// gives it (Monetization > Settings > Organization > App-ads.txt), and
// ironSource's DIRECT line with its published resellers (docs.unity.com,
// ironSource exchange, App-Ads.txt). A line already listed is not repeated.
const fs = require('fs');
const path = require('path');
const id = process.argv[2];
if (!/^\w+$/.test(id || '')) throw new Error('usage: node build.js <ironSource publisher id>');
const read = (f) => fs.readFileSync(path.join(__dirname, f), 'utf8').split(/\r?\n/).map((l) => l.trim()).filter(Boolean);
const seen = new Set();
const out = ['# OUTREPD: who may sell the ads in this app.', 'OWNERDOMAIN=outrepd.com'];
const section = (title, lines) => {
  out.push('', `# ${title}`);
  for (const line of lines) {
    const key = line.toLowerCase().replace(/\s+/g, '');
    if (seen.has(key)) continue;
    seen.add(key);
    out.push(line);
  }
};
section('Google AdMob', ['google.com, pub-8209820844798669, DIRECT, f08c47fec0942fa0']);
section('Unity Ads, through LevelPlay', read('unity.txt'));
section('ironSource Ads, through LevelPlay', [`ironsrc.com, ${id}, DIRECT`, ...read('ironsource-resellers.txt')]);
process.stdout.write(out.join('\n') + '\n');
