// The 1.1.7 store screenshots, style A, every screen placed the same way
// (composeB.html). node makeC.js [size folder]   ONLY=02-challenge,... OUT=dir
// The screens go in ci/ beside this file, taken from the ci-results branch
// (latest/screens/<name>.png). render.sh uses Edge headless.
const { execFileSync } = require('child_process');
const fs = require('fs');
const path = require('path');
const read = require('./png.js');
const here = __dirname;
const out = process.env.OUT || 'C:/Users/MA/Desktop/mokhtar/OUTREPD 1.1.7 store screenshots';

// [file, CI screen, headline, line, chip, chip row, how the top is drawn]
// top: 'bar' = drawn without a status bar, add one; 'bleed' = the screen's
// own art runs under the status bar; a number = rows of status inset to drop.
const shots = [
  ['01-live-match', 'store_live_match_1320x2868', 'Outrep<br>your <em>rival</em>', 'Live 1v1 push-up battles. The camera counts every rep.', '10 vs 7', 1731, 'bleed'],
  ['02-challenge', 'challenge_open', 'Dare anyone<br>with a <em>link</em>', 'Send your minute. They race it, one try each.', '18 to beat', 253, 'bar'],
  ['03-past-self', 'plan_page', 'Beat last<br><em>week’s you</em>', 'A six-week plan and a race every Sunday.', 'Week 2 of 6', 336, 'bar'],
  ['04-awards', 'awards_cabinet', 'Medals in<br><em>five metals</em>', '14 families, Bronze to Diamond. Pin your best three.', '19 / 73', 171, 'bar'],
  ['05-adventure-fight', 'store_1320x2868_adventure_fight', 'Push-ups are<br>your <em>weapon</em>', 'Every rep hits the monster.', '−10 HP', 608, 40],
  ['06-ranks', 'store_1320x2868_02-ranks', 'Climb<br>the <em>ranks</em>', 'Boards for the world, your country and your friends.', '+5 a win', 527, 'bar'],
  ['07-won', 'store_1320x2868_07-won', 'Win and<br><em>rank up</em>', 'A win adds 25 rating plus the gap in reps.', '+32', 527, 'bar'],
  ['08-milestone', 'moment_milestone', 'Every rep<br><em>adds up</em>', 'Personal bests, milestones and your month in review.', '', 0, 'bleed'],
  ['09-adventure-map', 'store_1320x2868_adventure_map', '140 levels.<br><em>7 worlds.</em>', 'A monster on every level.', '', 0, 40],
  ['10-recap', 'recap', 'Your month<br><em>in review</em>', 'Push-ups, wins and your best minute, every month.', '', 0, 'bar'],
];
const sizes = [
  { dir: 'app-store-1320x2868', w: 1320, h: 2868, count: 10 },
  { dir: 'app-store-1206x2622', w: 1206, h: 2622, count: 10 },
  { dir: 'app-store-1284x2778', w: 1284, h: 2778, count: 10 },
  { dir: 'google-play-1080x1920', w: 1080, h: 1920, count: 8 },
];

// The status strip is painted with the screen's own top row, smoothed so a
// stray piece of confetti does not become a stripe.
function barOf(file) {
  const im = read(path.join(here, 'ci', file + '.png'));
  const hex = (c) => '#' + c.map((x) => Math.round(x).toString(16).padStart(2, '0')).join('');
  const stops = [];
  for (let i = 0; i <= 32; i++) {
    const cx = Math.round((i / 32) * (im.w - 1)), ch = [[], [], []];
    for (let x = Math.max(0, cx - 90); x <= Math.min(im.w - 1, cx + 90); x++)
      for (let y = 0; y < 8; y++) im.px(x, y).forEach((c, j) => ch[j].push(c));
    stops.push(hex(ch.map((a) => a.sort((p, r) => p - r)[a.length >> 1])));
  }
  return new Set(stops).size === 1 ? stops[0] : 'linear-gradient(to right,' + stops.map((c, i) => c + ' ' + (i * 100 / 32).toFixed(2) + '%').join(',') + ')';
}

for (const z of sizes.filter((z) => !process.argv[2] || z.dir === process.argv[2])) {
  fs.mkdirSync(path.join(out, z.dir), { recursive: true });
  for (const [name, src, h1, p, chip, crow, top] of shots.slice(0, z.count).filter(([n]) => !process.env.ONLY || process.env.ONLY.split(',').includes(n))) {
    const q = new URLSearchParams({
      w: z.w, h: z.h, img: 'ci/' + src + '.png', h1, p, chip, crow,
      pad: top === 'bar' ? '1' : '0', drop: typeof top === 'number' ? top : 0,
      ...(top === 'bar' ? { barbg: barOf(src) } : {}), ...(src === 'recap' ? { soft: '1' } : {}),
    }).toString();
    const dest = path.join(out, z.dir, name + '.png').split('\\').join('/');
    const r = execFileSync('bash', [path.join(here, 'render.sh').split(path.sep).join('/'), 'composeB.html', q, dest, String(z.w), String(z.h)]).toString().trim();
    console.log(z.dir, name, r);
  }
}
