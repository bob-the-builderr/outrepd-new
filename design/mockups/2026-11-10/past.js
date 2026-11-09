// Beat your past self: a six-week plan from your best set, with a race each
// week against your own best of the week before. Uses ../2026-11-09's
// challenge.css and challenge.js helpers (face, at, center). 412 x 915 phones.
const HOME = 'now_challenge_home.png', VS = 'now_vs_challenge.png';
const cut = (src, from, y, h) => `<div class="abs" style="left:0;top:${y}px;width:412px;height:${h}px;background:url(${src}) no-repeat;background-size:412px auto;background-position:0 -${from}px"></div>`;
const ghost = (d) => `<div style="filter:grayscale(1) brightness(.85);opacity:.8;border-radius:50%;box-shadow:0 0 0 2px #6d675f">${face('me', d)}</div>`;
const ring = (d, frac, label, c = '#E8DCC8') => {
  const r = d / 2 - 5, L = 2 * Math.PI * r;
  return `<svg width="${d}" height="${d}" style="flex:none"><circle cx="${d / 2}" cy="${d / 2}" r="${r}" fill="none" stroke="#2a2724" stroke-width="7"/>
    <circle cx="${d / 2}" cy="${d / 2}" r="${r}" fill="none" stroke="${c}" stroke-width="7" stroke-linecap="round" stroke-dasharray="${L * frac} ${L}" transform="rotate(-90 ${d / 2} ${d / 2})"/>
    <text x="50%" y="54%" text-anchor="middle" dominant-baseline="middle" fill="#F4EDE4" style="font:800 ${d / 4}px 'Noto Sans'">${label}</text></svg>`;
};
const chev = `<span style="font-size:28px;color:var(--muted)">&rsaquo;</span>`;

// The road from the starting best to the goal, week by week.
const road = (w, h, pts, goal = 36, start = 24) => {
  const X = (i) => 22 + i * (w - 44) / 6, Y = (v) => h - 30 - (v - 20) * (h - 56) / 18;
  const done = pts.map((v, i) => `${X(i)},${Y(v)}`).join(' ');
  const last = pts.length - 1;
  return `<svg width="${w}" height="${h}">
    <line x1="${X(0)}" y1="${Y(start)}" x2="${X(6)}" y2="${Y(goal)}" stroke="#5a554e" stroke-width="2" stroke-dasharray="5 6"/>
    <polyline points="${done}" fill="none" stroke="#E8DCC8" stroke-width="3.5" stroke-linejoin="round"/>
    ${pts.map((v, i) => `<circle cx="${X(i)}" cy="${Y(v)}" r="${i === last ? 7 : 5}" fill="${i === last ? '#E8DCC8' : '#121110'}" stroke="#E8DCC8" stroke-width="2.5"/>
      <text x="${X(i)}" y="${Y(v) - 13}" text-anchor="middle" fill="#F4EDE4" style="font:700 14px 'Noto Sans'">${v}</text>`).join('')}
    <circle cx="${X(6)}" cy="${Y(goal)}" r="6" fill="none" stroke="#D9A94A" stroke-width="2.5"/>
    <text x="${X(6)}" y="${Y(goal) - 13}" text-anchor="middle" fill="#E8B94A" style="font:800 14px 'Noto Sans'">${goal}</text>
    ${['Start', 'W1', 'W2', 'W3', 'W4', 'W5', 'W6'].map((t, i) => `<text x="${X(i)}" y="${h - 6}" text-anchor="middle" fill="#9B9489" style="font:500 12px 'Noto Sans'">${t}</text>`).join('')}
  </svg>`;
};

// ── where it starts from ─────────────────────────────────────────────────────
const homeNow = () => `<img src="${HOME}" width="412" style="display:block">`;
// A: today's goal becomes today's plan; nothing is added.
const homeA = () => `${homeNow()}<div class="abs" style="left:0;right:0;top:686px;height:100px;background:var(--bg)"></div>
  ${at(16, 690, 380, `<div class="box" style="height:92px;display:flex;align-items:center;gap:16px;padding:0 16px">${ring(62, 1 / 3, '1/3')}
    <div style="flex:1"><div style="font:700 18px 'Noto Sans'">Today&rsquo;s plan</div>
    <div class="mini" style="font-size:14.5px">Week 2 &middot; 3 sets of 12 &middot; 1 done</div>
    <div style="font:600 13.5px 'Noto Sans';color:var(--gold)">Sunday: race last week&rsquo;s you</div></div>${chev}</div>`)}`;
// B: a card of its own for the race; today's goal stays as it is.
const homeB = () => `${cut(HOME, 0, 0, 686)}
  ${at(16, 690, 380, `<div class="box" style="height:80px;display:flex;align-items:center;gap:14px;padding:0 16px;box-shadow:inset 0 0 0 1.5px #D9A94A">${ghost(48)}
    <div style="flex:1"><div style="font:700 18px 'Noto Sans'">Beat last week&rsquo;s you</div>
    <div class="mini" style="font-size:14px">26 to beat &middot; Sunday &middot; week 2 of 6</div></div>${chev}</div>`)}
  ${cut(HOME, 686, 782, 133)}`;

// ── the plan ─────────────────────────────────────────────────────────────────
const chip = (big, small, on) => `<div style="flex:1;height:86px;border-radius:16px;background:${on ? '#262421' : 'var(--card)'};box-shadow:inset 0 0 0 ${on ? 2 : 1}px ${on ? 'var(--cream)' : 'var(--line)'};display:flex;flex-direction:column;align-items:center;justify-content:center">
  <div style="font:900 30px/1.1 'Noto Sans'">${big}</div><div class="mini" style="font-size:12.5px;${on ? 'color:var(--cream)' : ''}">${small}</div></div>`;
const setup = () => `${at(18, 22, 0, `<span style="font-size:26px;color:var(--muted)">&#x2715;</span>`)}
  ${at(22, 70, 368, `<div style="font:800 32px 'Noto Sans'">Get stronger</div><div class="mini" style="font-size:15.5px;margin-top:4px">A six-week plan from your best set.</div>`)}
  ${at(16, 162, 380, `<div class="box" style="display:flex;align-items:center;gap:16px;padding:14px 18px"><div class="big" style="font-size:64px">24</div>
    <div><div style="font:600 16px 'Noto Sans'">Your best</div><div class="mini">in 60 seconds &middot; Nov 8</div></div></div>`)}
  ${at(16, 276, 380, `<div class="cap"><span>Your goal in 6 weeks</span></div><div style="display:flex;gap:10px">${chip(30, 'Steady', false)}${chip(36, 'Recommended', true)}${chip(42, 'Hard', false)}</div>`)}
  ${at(16, 414, 380, `<div class="cap"><span>Days a week</span></div><div style="display:flex;gap:10px">${chip(3, 'days', true)}${chip(4, 'days', false)}${chip(5, 'days', false)}</div>`)}
  ${at(16, 556, 380, `<div class="box" style="padding:14px 18px"><div class="mini" style="font-size:14.5px;color:#d8d1c6">Each training day: a few short sets the camera counts.</div>
    <div class="mini" style="font-size:14.5px;color:#d8d1c6;margin-top:6px">Each Sunday: race last week&rsquo;s you, at the pace you really did it.</div></div>`)}
  ${at(18, 778, 376, `<div class="btn pri" style="height:56px;border-radius:28px">Start the plan</div>`)}`;

const day = (d, mark, today) => `<div style="flex:1;text-align:center"><div style="font:600 13px 'Noto Sans';color:${today ? 'var(--text)' : 'var(--muted)'}">${d}</div>
  <div style="height:36px;display:flex;align-items:center;justify-content:center;margin-top:4px">${mark}</div></div>`;
const dot = (fill, line = '#4a4640') => `<div style="width:26px;height:26px;border-radius:50%;background:${fill};box-shadow:inset 0 0 0 2px ${line}"></div>`;
const flag = `<svg width="24" height="24" viewBox="0 0 24 24" fill="#D9A94A"><path d="M5 3h2v18H5zM8 4h11l-2.5 4L19 12H8z"/></svg>`;
const plan = () => `${at(16, 20, 0, `<div style="display:flex;align-items:center;gap:10px;white-space:nowrap"><span style="font-size:30px;line-height:1">&lsaquo;</span><span style="font:700 26px 'Noto Sans'">Your plan</span></div>`)}
  ${at(22, 74, 368, `<div style="font:900 34px 'Noto Sans'">Road to 36</div><div class="mini" style="font-size:15px">Week 2 of 6 &middot; you started at 24</div>`)}
  ${at(16, 150, 380, `<div class="box" style="padding:10px 0 4px">${road(380, 196, [24, 26])}</div>`)}
  ${at(16, 370, 380, `<div class="cap"><span>This week</span><span style="color:var(--text)">1 of 3 days</span></div>
    <div class="box" style="padding:12px 10px 14px"><div style="display:flex">
      ${day('M', dot('var(--cream)', 'var(--cream)'))}${day('T', '<span class="mini">rest</span>')}${day('W', ring(36, 1 / 3, ''), true)}${day('T', '<span class="mini">rest</span>')}${day('F', dot('none'))}${day('S', '<span class="mini">rest</span>')}${day('S', flag)}</div>
      <div style="border-top:1px solid var(--line);margin:10px 6px 0;padding-top:12px;display:flex;align-items:center;justify-content:space-between">
        <span style="font:600 16px 'Noto Sans'">Today: 3 sets of 12</span>
        <span style="display:flex;gap:6px">${[1, 0, 0].map((x) => `<i style="width:26px;height:10px;border-radius:5px;background:${x ? 'var(--cream)' : '#34302b'}"></i>`).join('')}</span></div></div>`)}
  ${at(16, 588, 380, `<div class="box" style="display:flex;align-items:center;gap:14px;padding:14px 16px;box-shadow:inset 0 0 0 1.5px #D9A94A">${ghost(52)}
    <div style="flex:1"><div style="font:700 17px 'Noto Sans'">Race last week&rsquo;s you</div><div class="mini" style="font-size:14px">26 to beat &middot; opens Sunday</div></div>${flag}</div>`)}
  ${at(18, 778, 376, `<div class="btn pri" style="height:56px;border-radius:28px">Start set 2 of 3</div>`)}
  ${center(852, `<div style="font:600 16px 'Noto Sans';color:var(--muted)">Change the plan</div>`)}`;

// The race: the built challenge intro, with last week's you on top.
const vsYou = () => `<img src="${VS}" width="412" style="display:block">
  <div class="abs" style="left:0;top:52px;width:412px;height:394px;clip-path:polygon(0 0,412px 0,412px 333px,0 393px);overflow:hidden;background:#2a2826">
    <div class="abs" style="left:0;top:-476px;width:412px;height:915px;background:url(${VS}) no-repeat;background-size:412px auto;filter:grayscale(1) brightness(.7) contrast(1.1)"></div>
    <div class="abs" style="left:0;right:0;top:150px;bottom:0;background:linear-gradient(180deg,rgba(38,36,34,0),#262422 45%)"></div><div class="abs" style="inset:0;background:linear-gradient(180deg,rgba(18,17,16,0) 45%,rgba(18,17,16,.8) 92%)"></div></div>
  ${at(20, 340, 0, `<div style="border-left:4px solid #8a8378;padding-left:12px;white-space:nowrap"><div style="font:800 32px 'Noto Sans'">Last week&rsquo;s you</div><div style="font:600 16px 'Noto Sans';color:#b8b0a4">26 &middot; Sunday, Nov 8</div></div>`)}
  <div class="abs" style="left:0;right:0;top:0;height:52px;background:var(--bg)"></div>
  ${center(10, `<span class="pill"><i style="background:#D9A94A"></i>YOU VS YOU &middot; WEEK 2</span>`)}`;

const result = () => `${center(20, `<div style="font:900 44px/1.02 'Noto Sans';color:var(--cream)">YOU BEAT<br>LAST WEEK&rsquo;S YOU</div>`)}
  ${center(118, `<div style="font:500 17px 'Noto Sans';color:var(--muted)">3 more than a week ago.</div>`)}
  ${at(18, 156, 376, `<div class="box" style="height:210px;display:flex;align-items:stretch;padding:12px">
    <div style="flex:1;border-radius:14px;box-shadow:inset 0 0 0 1.5px #5a554e;background:#262421;display:flex;flex-direction:column;align-items:center;padding-top:10px">${face('me', 70)}<div style="font:500 15px 'Noto Sans';color:var(--muted);margin-top:4px">You now</div><div style="font:900 56px/1.05 'Noto Sans'">29</div><div style="font:500 13px 'Noto Sans'">Winner</div></div>
    <div style="flex:1;display:flex;flex-direction:column;align-items:center;padding-top:10px">${ghost(70)}<div style="font:500 15px 'Noto Sans';color:var(--muted);margin-top:4px">Last week</div><div style="font:900 56px/1.05 'Noto Sans';color:#8a8378">26</div></div></div>`)}
  ${at(18, 386, 376, `<div class="box" style="padding:14px 0 6px"><div style="display:flex;justify-content:space-between;padding:0 18px"><span style="font:700 17px 'Noto Sans'">Road to 36</span><span style="font:600 14px 'Noto Sans';color:#8fd19e">On track</span></div>
    ${road(376, 190, [24, 26, 29])}</div>`)}
  ${center(618, `<div class="mini">7 to go in 4 weeks &middot; next race Sunday, Nov 22</div>`)}
  ${at(18, 778, 376, `<div class="btn pri" style="height:56px;border-radius:28px">Share my progress</div>`)}
  ${at(18, 841, 376, `<div class="btn sec2" style="height:56px;border-radius:28px">Done</div>`)}`;

const PS_OPTIONS = {
  a: { t: 'A &middot; هدف اليوم بيبقى خطة اليوم (مقترح)',
    s: 'مفيش كارت جديد في الهوم. لما تبدأ خطة، كارت Today&rsquo;s goal بيبقى Today&rsquo;s plan: كام سِت النهارده، وفاضل كام، وإمتى السباق. اللي مش في خطة بيفضل يشوف هدف اليوم زي ما هو.',
    p: [['دلوقتي', 'الهوم المبني (فيه كارت التحدي)', homeNow()], ['الجديد', 'Today&rsquo;s plan مكان Today&rsquo;s goal', homeA()]] },
  b: { t: 'B &middot; كارت لوحده للسباق',
    s: 'هدف اليوم زي ما هو، وكارت جديد بلون دهبي &laquo;Beat last week&rsquo;s you&raquo; فوقه. أوضح، بس الهوم بيطول والمغامرة بتنزل لتحت.',
    p: [['دلوقتي', 'الهوم المبني (فيه كارت التحدي)', homeNow()], ['الجديد', 'كارت السباق فوق هدف اليوم', homeB()]] },
  flow: { t: 'الخطة نفسها (نفس الحاجة في الشكلين)',
    s: 'بتبدأ من أحسن سِت ليك وتختار الهدف وكام يوم في الأسبوع. كل يوم تمرين: سِتات قصيرة الكاميرا بتعدّها، وبتتحسب في هدف اليوم والستريك. كل أحد: سباق ضد أحسن سِت ليك من الأسبوع اللي فات، بالسرعة اللي عملتها بيها فعلاً. ودّي: مبيلمسش الريتنج.',
    p: [['البداية', 'تختار الهدف والأيام', setup()], ['صفحة الخطة', 'الطريق للهدف وتمرين النهارده', plan()], ['السباق', 'انت ضد نفسك من أسبوع', vsYou()], ['بعد السباق', 'كسبت نفسك، والخط طالع', result()]] },
};
function drawPs(k) {
  const o = PS_OPTIONS[k];
  const col = (t, s, inner) => `<div><div class="lab">${t}<small>${s}</small></div><div class="phone">${inner}</div></div>`;
  document.body.innerHTML = `<div class="sec">${o.t}<small>${o.s}</small></div><div class="row">${o.p.map(([a, b, c]) => col(a, b, c)).join('')}</div>`;
}
