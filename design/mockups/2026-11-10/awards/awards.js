// Awards, rebuilt (the user, 2026-11-09: "our awards are weak, as designs
// and as achievements"). Medals in five tiers per family, two ways to lay
// them out, a badge's own page, and the new list. 412 x 915 phones.
const TIER = [
  { n: 'Bronze', a: '#E9A57A', b: '#9A5A35', c: '#5C311A' },
  { n: 'Silver', a: '#F2F0EC', b: '#A9A49B', c: '#5E5A53' },
  { n: 'Gold', a: '#FBE59A', b: '#D9A94A', c: '#7A5714' },
  { n: 'Platinum', a: '#D9FBFF', b: '#7FC9D6', c: '#2E6672' },
  { n: 'Diamond', a: '#E7D4FF', b: '#9B7BEA', c: '#43307E' },
];
// Glyphs drawn on a 48 x 48 box, stroked in the medal's dark colour.
const G = {
  fist: '<path d="M14 22v-6a3 3 0 0 1 6 0v4m0-5a3 3 0 0 1 6 0v5m0-4a3 3 0 0 1 6 0v6m0-3a3 3 0 0 1 6 0v9c0 8-5 12-12 12h-2c-6 0-10-4-10-10v-4l4-4"/>',
  flame: '<path d="M24 6c2 7 10 11 10 21a10 10 0 0 1-20 0c0-5 2-8 5-10 0 4 2 6 4 7-1-7 0-13 1-18z"/>',
  crown: '<path d="M8 34h32M9 30l-1-16 9 8 7-12 7 12 9-8-1 16z"/>',
  bolt: '<path d="M27 5 11 27h12l-3 16 17-23H25z"/>',
  chart: '<path d="M8 38h32M12 32l8-9 7 5 11-14M32 14h6v6"/>',
  sword: '<path d="M10 38l8-8m-4 12-8-8M18 30 38 10l1-5-5 1-20 20"/>',
  shield: '<path d="M24 6l14 5v11c0 9-6 16-14 20-8-4-14-11-14-20V11z"/><path d="M17 23l5 5 9-10"/>',
  link: '<path d="M21 27a7 7 0 0 0 10 0l6-6a7 7 0 0 0-10-10l-2 2"/><path d="M27 21a7 7 0 0 0-10 0l-6 6a7 7 0 0 0 10 10l2-2"/>',
  ghost: '<path d="M12 40V22a12 12 0 0 1 24 0v18l-4-3-4 3-4-3-4 3-4-3z"/><circle cx="19" cy="22" r="1.5"/><circle cx="29" cy="22" r="1.5"/>',
  castle: '<path d="M8 40V18h6v5h5v-5h10v5h5v-5h6v22zM20 40v-8a4 4 0 0 1 8 0v8"/>',
  sun: '<circle cx="24" cy="26" r="7"/><path d="M24 9v5M11 26H6m36 0h-5M14 16l-3-3m26 3 3-3M8 38h32"/>',
  moon: '<path d="M32 30A13 13 0 0 1 18 12a13 13 0 1 0 14 18z"/><path d="M34 9v6m-3-3h6"/>',
  people: '<circle cx="18" cy="17" r="5"/><circle cx="31" cy="19" r="4"/><path d="M8 38c0-6 4-10 10-10s10 4 10 10M28 38c0-5 2-8 6-8s6 3 6 8"/>',
  target: '<circle cx="24" cy="24" r="15"/><circle cx="24" cy="24" r="8"/><circle cx="24" cy="24" r="1.5"/>',
  one: '<path d="M20 14l6-4v28m-8 0h16"/>',
  clock: '<circle cx="24" cy="25" r="14"/><path d="M24 17v8l5 4M20 7h8"/>',
};
let uid = 0;
// A medal: a twelve-notched rim in the tier's metal, a dark face, the glyph.
const medal = (tier, glyph, d = 92, locked = false) => {
  const t = TIER[tier], id = 'm' + uid++;
  const rim = [];
  for (let i = 0; i < 24; i++) {
    const r = i % 2 ? 44 : 47, a = (i / 24) * Math.PI * 2 - Math.PI / 2;
    rim.push(`${50 + Math.cos(a) * r},${50 + Math.sin(a) * r}`);
  }
  return `<svg width="${d}" height="${d}" viewBox="0 0 100 100" style="flex:none;${locked ? 'filter:grayscale(1) brightness(.45)' : `filter:drop-shadow(0 6px 14px rgba(0,0,0,.5)) drop-shadow(0 0 ${d / 8}px ${t.b}55)`}">
    <defs><linearGradient id="${id}" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${t.a}"/><stop offset=".55" stop-color="${t.b}"/><stop offset="1" stop-color="${t.c}"/></linearGradient>
    <radialGradient id="${id}f" cx=".5" cy=".35" r=".7"><stop offset="0" stop-color="#2b2620"/><stop offset="1" stop-color="#121110"/></radialGradient></defs>
    <polygon points="${rim.join(' ')}" fill="url(#${id})"/>
    <circle cx="50" cy="50" r="34" fill="url(#${id}f)" stroke="${t.a}" stroke-opacity=".85" stroke-width="2"/>
    <path d="M22 32 A34 34 0 0 1 78 32" fill="none" stroke="#fff" stroke-opacity=".12" stroke-width="5"/>
    <g transform="translate(26 26)" fill="none" stroke="${locked ? '#6d675f' : t.a}" stroke-width="3.2" stroke-linecap="round" stroke-linejoin="round">${G[glyph]}</g>
  </svg>`;
};
const ring = (d, frac, colour) => {
  const r = d / 2 - 3, L = 2 * Math.PI * r;
  return `<svg width="${d}" height="${d}" class="abs" style="left:0;top:0;transform:rotate(-90deg)"><circle cx="${d / 2}" cy="${d / 2}" r="${r}" fill="none" stroke="#2a2724" stroke-width="4"/><circle cx="${d / 2}" cy="${d / 2}" r="${r}" fill="none" stroke="${colour}" stroke-width="4" stroke-linecap="round" stroke-dasharray="${L * frac} ${L}"/></svg>`;
};
const pips = (got) => `<span style="display:inline-flex;gap:3px">${TIER.map((t, i) => `<i style="width:8px;height:8px;border-radius:50%;background:${i < got ? t.b : '#34302b'}"></i>`).join('')}</span>`;

// The families: [name, glyph, tiers reached (0–5), what the next asks, how far, isNew]
const FAM = [
  ['Grinder', 'fist', 3, '5,000 push-ups', 0.48, 0],
  ['Iron Will', 'flame', 2, 'A 30-day streak', 0.3, 0],
  ['Champion', 'crown', 2, '50 wins', 0.62, 0],
  ['On Fire', 'bolt', 1, '5 wins in a row', 0.6, 0],
  ['Personal Best', 'chart', 2, '40 in a minute', 0.68, 1],
  ['Giant Slayer', 'sword', 1, '5 wins over a higher tier', 0.2, 0],
  ['Clean Form', 'shield', 3, '100 clean sets', 0.5, 0],
  ['Challenger', 'link', 1, '5 people take your link', 0.4, 1],
  ['Past Self', 'ghost', 0, 'Beat last week’s you', 0, 1],
  ['Adventurer', 'castle', 1, 'Clear 2 worlds', 0.55, 1],
  ['Daily Goal', 'target', 2, 'Hit it 100 days', 0.41, 1],
  ['Early Bird', 'sun', 0, '10 sessions before 7', 0.3, 0],
  ['Night Owl', 'moon', 1, '50 sessions after 10', 0.24, 0],
  ['Crew', 'people', 2, '25 friends', 0.36, 0],
];
const SPECIAL = [
  ['Photo Finish', 'one', 'Win by exactly one rep', 2, 1, 1],
  ['Buzzer Beater', 'clock', 'Take the lead in the last 5 seconds', 3, 0, 1],
  ['Month Champion', 'crown', 'Finish first in your country for a month', 4, 0, 0],
];

const header = (sub) => `${at(20, 18, 0, `<div style="font:800 30px 'Noto Sans';white-space:nowrap">Awards</div>`)}
  ${at(20, 64, 372, `<div style="display:flex;align-items:center;gap:12px"><div style="flex:1;height:8px;border-radius:4px;background:#2a2724;overflow:hidden"><div style="width:43%;height:100%;background:linear-gradient(90deg,#9A5A35,#D9A94A)"></div></div><span style="font:700 14px 'Noto Sans';white-space:nowrap">${sub}</span></div>`)}`;

// ── A: a trophy cabinet ──────────────────────────────────────────────────────
const tileA = ([name, g, got, next, frac, isNew]) => {
  const tier = Math.max(0, got - 1), locked = got === 0;
  return `<div style="background:var(--card);border-radius:18px;padding:12px 6px 10px;text-align:center;position:relative">
    ${isNew ? `<span style="position:absolute;right:7px;top:7px;font:800 9px 'Noto Sans';padding:2px 5px;border-radius:5px;background:#3a1f17;color:var(--rival)">NEW</span>` : ''}
    <div style="position:relative;width:76px;height:76px;margin:0 auto">${ring(76, locked ? 0 : frac, TIER[Math.min(4, got)].b)}<div class="abs" style="left:8px;top:8px">${medal(tier, g, 60, locked)}</div></div>
    <div style="font:700 13px 'Noto Sans';margin-top:6px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${name}</div>
    <div style="margin-top:4px">${pips(got)}</div></div>`;
};
const optA = () => `${header('48 of 76')}
  ${at(16, 96, 380, `<div class="cap" style="padding:0 4px;margin-bottom:8px"><span>Showcase &middot; on your profile</span><span style="color:var(--cream)">Edit</span></div>
    <div style="background:linear-gradient(135deg,#2a2214,#1c1b19 60%);box-shadow:inset 0 0 0 1.5px #D9A94A;border-radius:20px;padding:14px 10px;display:flex;justify-content:space-around">
      ${[[2, 'fist', 'Grinder III'], [3, 'shield', 'Clean Form IV'], [2, 'crown', 'Champion III']].map(([t, g, n]) => `<div style="text-align:center">${medal(t, g, 84)}<div style="font:700 12.5px 'Noto Sans';margin-top:4px">${n}</div></div>`).join('')}</div>`)}
  ${at(16, 272, 380, `<div class="cap" style="padding:0 4px;margin-bottom:8px"><span>All awards</span><span style="color:var(--text)">14 families &middot; 3 special</span></div>
    <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:8px">${FAM.slice(0, 12).map(tileA).join('')}</div>`)}`;

// ── B: families, every tier in a row ────────────────────────────────────────
const rowB = ([name, g, got, next, frac, isNew]) => `<div style="background:var(--card);border-radius:18px;padding:12px 14px">
  <div style="display:flex;align-items:baseline;gap:8px"><b style="font:800 15px 'Noto Sans'">${name}</b>${isNew ? `<span style="font:800 9px 'Noto Sans';padding:2px 5px;border-radius:5px;background:#3a1f17;color:var(--rival)">NEW</span>` : ''}<span class="mini" style="margin-left:auto;font-size:12.5px">Next: ${next}</span></div>
  <div style="display:flex;justify-content:space-between;align-items:center;margin-top:8px">${TIER.map((t, i) => i < got ? medal(i, g, 52) : i === got ? `<div style="position:relative;width:56px;height:56px">${ring(56, frac, t.b)}<div class="abs" style="left:6px;top:6px">${medal(i, g, 44, true)}</div></div>` : medal(i, g, 46, true)).join('')}</div></div>`;
const optB = () => `${header('48 of 76')}
  ${at(16, 94, 380, `<div class="cap" style="padding:0 4px;margin-bottom:8px"><span>Latest</span><span class="mini">Nov 9</span></div>
    <div style="display:flex;align-items:center;gap:12px;background:linear-gradient(135deg,#2a2214,#1c1b19 60%);box-shadow:inset 0 0 0 1.5px #D9A94A;border-radius:18px;padding:12px 14px">${medal(2, 'fist', 64)}
      <div style="flex:1"><div style="font:800 11px 'Noto Sans';letter-spacing:2px;color:#D9A94A">GOLD &middot; JUST EARNED</div><div style="font:800 18px 'Noto Sans'">Grinder III</div><div class="mini">1,000 push-ups &middot; held by 18% of lifters</div></div></div>`)}
  ${at(16, 214, 380, `<div style="display:grid;gap:8px">${FAM.slice(0, 6).map(rowB).join('')}</div>`)}`;

// ── a badge's own page ──────────────────────────────────────────────────────
const detail = () => `<img src="now_awards.png" width="412" style="display:block;filter:brightness(.35)">
  <div class="sheet" style="height:640px;text-align:center;background:#1c1a18">
    <div style="width:40px;height:4px;border-radius:2px;background:#5a554e;margin:0 auto 14px"></div>
    <div class="abs" style="left:0;right:0;top:20px;height:260px;background:radial-gradient(closest-side,rgba(217,169,74,.3),transparent)"></div>
    <div style="position:relative;display:flex;justify-content:center">${medal(2, 'flame', 170)}</div>
    <div style="font:800 12px 'Noto Sans';letter-spacing:3px;color:#D9A94A;margin-top:10px">GOLD &middot; IRON WILL III</div>
    <div style="font:900 26px 'Noto Sans';margin-top:2px">30 days in a row</div>
    <div class="mini" style="font-size:14.5px;margin-top:4px">Earned Nov 2 &middot; held by 4% of lifters</div>
    <div style="display:flex;justify-content:center;gap:10px;margin:16px 0 14px">${TIER.map((t, i) => medal(i, 'flame', 50, i > 2)).join('')}</div>
    <div class="box" style="text-align:left;padding:12px 16px;margin:0 2px"><div style="display:flex;justify-content:space-between;font:600 14.5px 'Noto Sans'"><span>Next: Platinum &middot; 100 days</span><span class="mini">day 41</span></div>
      <div style="height:8px;border-radius:4px;background:#2a2724;margin-top:10px;overflow:hidden"><div style="width:41%;height:100%;background:#7FC9D6"></div></div></div>
    <div style="display:flex;gap:10px;margin-top:16px"><div class="btn pri" style="flex:1;height:52px">Wear the title</div><div class="btn sec2" style="flex:1;height:52px">Share</div></div>
  </div>`;

// The unlock: the medal flips in over the result, the way LEVEL UP does.
const unlock = () => `<div class="abs" style="inset:0;background:radial-gradient(70% 45% at 50% 36%,rgba(127,201,214,.28),transparent 70%)"></div>
  ${center(120, `<div style="font:800 15px 'Noto Sans';letter-spacing:6px;color:#7FC9D6">NEW AWARD</div>`)}
  ${center(160, `<div style="display:flex;justify-content:center;transform:perspective(600px) rotateY(-18deg)">${medal(3, 'shield', 230)}</div>`)}
  ${center(410, `<div style="font:800 12px 'Noto Sans';letter-spacing:3px;color:#7FC9D6">PLATINUM</div><div style="font:900 32px 'Noto Sans'">Clean Form IV</div>`)}
  ${center(482, `<div class="mini" style="font-size:15px">A hundred sets with every rep counted.</div>`)}
  ${center(522, `<div style="display:inline-flex;gap:6px;align-items:center;padding:6px 12px;border-radius:999px;background:#1c2a2d;color:#9fe0ea;font:700 13px 'Noto Sans'">Held by 2% of lifters</div>`)}
  ${at(18, 778, 376, `<div class="btn pri" style="height:56px;border-radius:28px">Share it</div>`)}${at(18, 841, 376, `<div class="btn sec2" style="height:56px;border-radius:28px">Continue</div>`)}`;

// The list, as a page of its own.
const list = () => `<div class="abs" style="inset:0;overflow:hidden;padding:18px 16px">
  <div style="font:800 22px 'Noto Sans';margin-bottom:4px">14 families, 5 tiers each</div>
  <div class="mini" style="margin-bottom:10px">Bronze &rarr; Silver &rarr; Gold &rarr; Platinum &rarr; Diamond. Every tier is a title you can wear.</div>
  ${FAM.map(([n, g, , , , isNew]) => `<div style="display:flex;align-items:center;gap:10px;padding:5px 0;border-bottom:1px solid #26231f">${medal(2, g, 34)}<b style="font:700 13.5px 'Noto Sans';width:104px">${n}${isNew ? ' <span style="color:var(--rival);font-size:9px">NEW</span>' : ''}</b><span class="mini" style="font-size:12px">${{
    Grinder: '100 &middot; 1K &middot; 5K &middot; 10K &middot; 50K push-ups', 'Iron Will': '7 &middot; 14 &middot; 30 &middot; 100 &middot; 365-day streak', Champion: '1 &middot; 10 &middot; 50 &middot; 200 &middot; 500 wins', 'On Fire': '3 &middot; 5 &middot; 10 &middot; 15 &middot; 20 in a row', 'Personal Best': '20 &middot; 30 &middot; 40 &middot; 50 &middot; 60 in a minute', 'Giant Slayer': '1 &middot; 5 &middot; 10 &middot; 25 &middot; 50 wins over a higher tier', 'Clean Form': '1 &middot; 10 &middot; 50 &middot; 100 &middot; 250 clean sets', Challenger: '1 &middot; 5 &middot; 20 &middot; 50 &middot; 100 people take your link', 'Past Self': '1 &middot; 3 &middot; 6 &middot; 12 &middot; 26 weeks beating you', Adventurer: '1 &middot; 2 &middot; 4 &middot; 6 &middot; 7 worlds cleared', 'Daily Goal': '7 &middot; 30 &middot; 100 &middot; 200 &middot; 365 days hit', 'Early Bird': '10 &middot; 25 &middot; 50 &middot; 100 &middot; 250 before 7', 'Night Owl': '10 &middot; 25 &middot; 50 &middot; 100 &middot; 250 after 10', Crew: '1 &middot; 5 &middot; 10 &middot; 25 &middot; 50 friends' }[n]}</span></div>`).join('')}
  <div style="font:800 16px 'Noto Sans';margin:12px 0 6px">Special, one of each</div>
  ${SPECIAL.map(([n, g, h, t, , isNew]) => `<div style="display:flex;align-items:center;gap:10px;padding:5px 0">${medal(t, g, 34)}<b style="font:700 13.5px 'Noto Sans';width:120px">${n}${isNew ? ' <span style="color:var(--rival);font-size:9px">NEW</span>' : ''}</b><span class="mini" style="font-size:12px">${h}</span></div>`).join('')}
</div>`;

const AW = {
  a: { t: 'A &middot; خزنة الجوايز (مقترح)', s: 'فوق: 3 ميداليات تختارهم يظهروا في بروفايلك (Showcase). تحت: كل الإنجازات شبكة ميداليات، حوالين كل واحدة دايرة بتوريك قربت من الدرجة الجاية قد إيه، والنقط تحتها بتقولك وصلت لأنهي درجة من الـ 5.',
    p: [['دلوقتي', 'شاشة الجوايز المبنية', `<img src="now_awards.png" width="412" style="display:block">`], ['الجديد', 'Showcase + شبكة ميداليات', optA()], ['ميدالية لوحدها', 'لما تدوس على أي واحدة', detail()]] },
  b: { t: 'B &middot; عائلات بدرجاتها', s: 'كل إنجاز سطر فيه الـ 5 ميداليات جنب بعض من البرونز للدايموند: اللي خدتها ملونة، والجاية حواليها الدايرة، والباقي مطفي. وفوق آخر ميدالية خدتها.',
    p: [['دلوقتي', 'شاشة الجوايز المبنية', `<img src="now_awards.png" width="412" style="display:block">`], ['الجديد', 'كل عائلة بدرجاتها الخمسة', optB()], ['ميدالية لوحدها', 'لما تدوس على أي واحدة', detail()]] },
  flow: { t: 'الإنجازات نفسها (نفس الحاجة في الشكلين)', s: '14 عائلة، كل واحدة 5 درجات (برونز، سيلفر، جولد، بلاتينم، دايموند)، و3 مميزين. الجديد عليه NEW: التحدي باللينك، واسبق نفسك، والمغامرة، وهدف اليوم، وأحسن دقيقة، وفوز بعدّة واحدة، وتقلب الماتش في آخر 5 ثواني. وأي ميدالية جديدة ليها شاشة احتفال زي LEVEL UP. وكل اللي اتكسب قبل كده بيفضل مكسوب.',
    p: [['القايمة', 'كل الإنجازات ودرجاتها', list()], ['ميدالية جديدة', 'شاشة الاحتفال بعد الماتش', unlock()]] },
};
function drawAw(k) {
  const o = AW[k];
  const col = (t, s, inner) => `<div><div class="lab">${t}<small>${s}</small></div><div class="phone">${inner}</div></div>`;
  document.body.innerHTML = `<div class="sec">${o.t}<small>${o.s}</small></div><div class="row">${o.p.map(([a, b, c]) => col(a, b, c)).join('')}</div>`;
}
