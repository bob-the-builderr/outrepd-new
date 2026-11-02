// Run from apps/outrepd_flutter: writes supabase/ladder_vectors.json exactly
// as test/ladder_vectors_test.dart does (no Flutter on this machine).
const fs = require('fs');
const kTopTier = 6, kTopDivision = 4, kDivs = 5, kLadderLevels = 35;
const lpFor = (won, y, t) => { const gap = Math.abs(y - t); return won ? 25 + gap : -(20 + gap); };
function applyLp(from, delta, floor) {
  let tier = from[0], div = from[1], lp = from[2] + delta;
  while (lp >= 100) {
    if (tier >= kTopTier && div >= kTopDivision) break;
    lp -= 100;
    if (div < kTopDivision) div++; else { tier++; div = 0; }
  }
  while (lp < 0) {
    if (div === 0 && tier <= floor) { lp = 0; break; }
    lp += 100;
    if (div > 0) div--; else { tier--; div = kTopDivision; }
  }
  return [tier, div, lp];
}
const ladderLevel = (t, d) => Math.min(Math.max(t, 0), kTopTier) * kDivs + Math.min(Math.max(d, 0), kTopDivision) + 1;

const pay = [];
for (const won of [true, false])
  for (let y = 0; y <= 40; y += 2)
    for (let t = 0; t <= 40; t += 4)
      pay.push({ won, your_reps: y, their_reps: t, total: lpFor(won, y, t) });
const weighed = [];
for (const won of [true, false])
  for (let y = 0; y <= 40; y += 8)
    for (let t = 0; t <= 40; t += 8)
      for (const yl of [1, 12, 30])
        for (const apart of [-8, -5, -2, -1, 0, 1, 3, 5, 9])
          if (yl + apart >= 1 && yl + apart <= kLadderLevels)
            weighed.push({ won, your_reps: y, their_reps: t, your_level: yl, their_level: yl + apart, total: lpFor(won, y, t) });
const applied = [];
for (const from of [[0, 0, 0], [3, 2, 40], [3, 4, 95], [kTopTier, 4, 99], [2, 0, 5], [5, 3, 50]])
  for (const delta of [-200, -60, -18, -1, 0, 1, 23, 99, 140, 250])
    for (const floor of [0, 3, kTopTier]) {
      const a = applyLp(from, delta, floor);
      applied.push({ from_tier: from[0], from_div: from[1], from_lp: from[2], delta, floor_tier: floor, tier_idx: a[0], div_idx: a[1], lp: a[2] });
    }
const levels = [];
for (let t = 0; t <= kTopTier; t++) for (let d = 0; d <= kTopDivision; d++) levels.push({ tier_idx: t, div_idx: d, level: ladderLevel(t, d) });
const placements = [];
for (let w = 0; w <= 5; w++) placements.push({ wins: w, tier_idx: 0, div_idx: 0, lp: 0 });
const out = { generated_by: 'flutter test test/ladder_vectors_test.dart', lp_for: pay, lp_for_levels: weighed, apply_lp: applied, ladder_level: levels, placement_rank: placements };
fs.writeFileSync('supabase/ladder_vectors.json', JSON.stringify(out, null, 2) + '\n');
console.log('vectors', pay.length, weighed.length, applied.length);
