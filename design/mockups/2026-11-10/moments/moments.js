// Moments: the app celebrating a new personal best, a milestone of total
// push-ups, and each month in a recap. Two ways to show the first two (A a
// screen of their own like LEVEL UP, B inside the result), and the recap.
// Uses ../../2026-11-09/challenge.css and challenge.js (face, at, center).
const RW = 'now_result_win.png', LU = 'now_result_level_up.png', HM = 'now_tab_match.png', PR = 'now_tab_profile.png';
const GOLD = '#E0B145';
const confetti = (n, h, seed = 7) => {
  let r = seed, out = '';
  const rnd = () => (r = (r * 9301 + 49297) % 233280) / 233280;
  const cols = ['#E0B145', '#E8846B', '#E8DCC8', '#4CC38A', '#F2D27A'];
  for (let i = 0; i < n; i++) {
    const x = rnd() * 412, y = rnd() * h, w = 5 + rnd() * 7, hh = 9 + rnd() * 10, a = rnd() * 180;
    out += `<i style="position:absolute;left:${x}px;top:${y}px;width:${w}px;height:${hh}px;background:${cols[i % 5]};border-radius:2px;transform:rotate(${a}deg);opacity:${0.55 + rnd() * 0.45}"></i>`;
  }
  return `<div class="abs" style="left:0;right:0;top:0;height:${h}px;overflow:hidden">${out}</div>`;
};
const glow = (y, c = 'rgba(224,177,69,.28)') => `<div class="abs" style="left:-60px;right:-60px;top:${y}px;height:420px;background:radial-gradient(closest-side,${c},transparent)"></div>`;
const btns = (a, b) => `${at(18, 778, 376, `<div class="btn pri" style="height:56px;border-radius:28px">${a}</div>`)}${at(18, 841, 376, `<div class="btn sec2" style="height:56px;border-radius:28px">${b}</div>`)}`;
const label = (t, y = 150) => center(y, `<div style="font:800 15px 'Noto Sans';letter-spacing:6px;color:${GOLD}">${t}</div>`);

// ── A: a screen of its own, the way LEVEL UP is ─────────────────────────────
const pbScreen = () => `${glow(150)}${confetti(46, 400)}
  ${label('NEW PERSONAL BEST', 128)}
  ${center(176, `<div style="display:flex;justify-content:center"><div style="width:236px;height:236px;border-radius:50%;display:grid;place-items:center;background:radial-gradient(circle at 50% 35%,#3a2d15,#1b1712 70%);box-shadow:0 0 0 6px #D9A94A,0 0 0 14px rgba(217,169,74,.25),0 0 70px rgba(224,177,69,.45)">
    <div><div class="big" style="font-size:118px;color:#F2D27A;text-shadow:0 0 30px rgba(242,210,122,.5)">27</div><div style="font:700 14px 'Noto Sans';color:#cfc6b8;margin-top:-6px">push-ups in a minute</div></div></div></div>`)}
  ${center(440, `<div style="font:800 26px 'Noto Sans'">Up from <span style="color:var(--muted);text-decoration:line-through">24</span> &nbsp;<span style="color:#4CC38A">+3</span></div>`)}
  ${center(478, `<div class="mini" style="font-size:15px">Your best since Oct 2. The camera counted every one.</div>`)}
  ${at(18, 530, 376, `<div class="box" style="padding:14px 16px;display:flex;align-items:center;gap:14px">
    <svg width="150" height="60"><polyline points="4,52 30,46 56,44 82,36 108,30 146,8" fill="none" stroke="#E8DCC8" stroke-width="3" stroke-linejoin="round"/><circle cx="146" cy="8" r="6" fill="#F2D27A"/></svg>
    <div><div style="font:700 15px 'Noto Sans'">Your best, month by month</div><div class="mini">18 &rarr; 21 &rarr; 24 &rarr; 27</div></div></div>`)}
  ${btns('Share it', 'Continue')}`;
const medal = (txt, sub) => `<div style="display:flex;justify-content:center"><div style="width:230px;height:230px;position:relative;display:grid;place-items:center">
  <svg class="abs" style="inset:0" width="230" height="230" viewBox="0 0 230 230"><defs><linearGradient id="m" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="#F7DE8E"/><stop offset=".5" stop-color="#D9A94A"/><stop offset="1" stop-color="#8F6A22"/></linearGradient></defs>
    <path d="M115 6 L139 34 L176 24 L182 61 L218 76 L200 109 L218 142 L182 157 L176 194 L139 184 L115 212 L91 184 L54 194 L48 157 L12 142 L30 109 L12 76 L48 61 L54 24 L91 34 Z" fill="url(#m)"/>
    <circle cx="115" cy="109" r="70" fill="#1b1712" stroke="#F2D27A" stroke-width="3"/></svg>
  <div style="position:relative;text-align:center;margin-top:-6px"><div class="big" style="font-size:66px;color:#F2D27A">${txt}</div><div style="font:800 12px 'Noto Sans';letter-spacing:3px;color:#cfc6b8">${sub}</div></div></div></div>`;
const milestoneScreen = () => `${glow(140)}${confetti(40, 380, 19)}
  ${label('MILESTONE', 120)}
  ${center(160, medal('1K', 'PUSH-UPS'))}
  ${center(410, `<div style="font:900 34px 'Noto Sans'">1,000 push-ups</div>`)}
  ${center(456, `<div class="mini" style="font-size:15px">In 23 days and 41 sets, since Oct 17.</div>`)}
  ${at(18, 512, 376, `<div class="box" style="padding:16px 18px"><div style="display:flex;justify-content:space-between;font:600 15px 'Noto Sans'"><span>Next: 5,000</span><span class="mini">4,000 to go</span></div>
    <div style="height:8px;border-radius:4px;background:#2a2724;margin-top:12px;overflow:hidden"><div style="width:20%;height:100%;background:${GOLD}"></div></div>
    <div style="display:flex;gap:8px;margin-top:14px">${[['100', 1], ['1K', 1], ['5K', 0], ['10K', 0], ['25K', 0]].map(([t, d]) => `<span style="flex:1;text-align:center;padding:6px 0;border-radius:10px;font:800 13px 'Noto Sans';${d ? `background:#2A2214;color:#F2D27A;box-shadow:inset 0 0 0 1.5px ${GOLD}` : 'background:#1f1d1b;color:#6d675f'}">${t}</span>`).join('')}</div></div>`)}
  ${btns('Share it', 'Continue')}`;

// ── B: inside the result, no screen of its own ──────────────────────────────
const resultB = () => `<img src="${RW}" width="412" style="display:block">
  <div class="abs" style="left:0;right:0;top:350px;height:300px;background:var(--bg)"></div>
  ${at(18, 356, 376, `<div class="box" style="padding:14px 16px;box-shadow:inset 0 0 0 1.5px ${GOLD};background:linear-gradient(120deg,#2a2214,#1c1b19 60%);position:relative;overflow:hidden">
    ${confetti(14, 90, 3).replace('class="abs"', 'class="abs" style="opacity:.6"')}
    <div style="position:relative;display:flex;align-items:center;gap:14px"><div class="big" style="font-size:54px;color:#F2D27A">27</div>
      <div style="flex:1"><div style="font:800 12px 'Noto Sans';letter-spacing:2px;color:${GOLD}">NEW PERSONAL BEST</div><div style="font:600 15px 'Noto Sans'">Up from 24 &middot; <span style="color:#4CC38A">+3</span></div></div>
      <span class="go" style="background:#F2D27A">Share</span></div></div>`)}
  ${at(18, 470, 376, `<div class="box" style="padding:12px 16px;display:flex;align-items:center;gap:12px">
    <div style="width:44px;height:44px;border-radius:50%;background:#2A2214;box-shadow:inset 0 0 0 2px ${GOLD};display:grid;place-items:center;font:900 15px 'Noto Sans';color:#F2D27A">1K</div>
    <div style="flex:1"><div style="font:700 15px 'Noto Sans'">1,000 push-ups</div><div class="mini">A milestone. Next: 5,000</div></div><span class="go">Share</span></div>`)}
  ${at(18, 548, 376, `<div class="mini" style="text-align:center">The rest of the result as it is today: the minute, rating and week, below.</div>`)}`;

// ── The month: a recap on the first of each month ───────────────────────────
const homeCard = () => `<img src="${HM}" width="412" style="display:block">
  <div class="abs" style="left:0;right:0;top:66px;height:96px;background:var(--bg)"></div>
  ${at(16, 72, 380, `<div class="box" style="height:84px;display:flex;align-items:center;gap:14px;padding:0 16px;box-shadow:inset 0 0 0 1.5px ${GOLD};background:linear-gradient(120deg,#2a2214,#1c1b19 65%)">
    <div style="width:52px;height:52px;border-radius:14px;background:#121110;display:grid;place-items:center;text-align:center;line-height:1"><div><div style="font:800 10px 'Noto Sans';color:${GOLD}">NOV</div><div style="font:900 22px 'Noto Sans'">30</div></div></div>
    <div style="flex:1"><div style="font:700 18px 'Noto Sans'">Your November is in</div><div class="mini" style="font-size:14px">1,240 push-ups &middot; best 27 &middot; 14 wins</div></div>
    <span style="font-size:28px;color:var(--muted)">&rsaquo;</span></div>`)}`;
const stat = (big, small, c = 'var(--text)') => `<div class="box" style="padding:14px 16px"><div class="big" style="font-size:40px;color:${c}">${big}</div><div class="mini" style="font-size:13.5px;margin-top:4px">${small}</div></div>`;
const recap = () => `<div class="abs" style="inset:0;background:radial-gradient(90% 50% at 50% 0%,#3a2d15,#121110 70%)"></div>${confetti(20, 200, 11)}
  
  ${center(56, `<div style="font:800 14px 'Noto Sans';letter-spacing:6px;color:${GOLD}">YOUR NOVEMBER</div>`)}
  ${center(86, `<div style="display:flex;justify-content:center">${face('me', 92)}</div>`)}
  ${center(190, `<div class="big" style="font-size:96px">1,240</div><div style="font:700 17px 'Noto Sans';color:#cfc6b8">push-ups this month</div>`)}
  ${at(16, 336, 380, `<div style="display:grid;grid-template-columns:1fr 1fr;gap:10px">
    ${stat('27', 'best minute &middot; <span style="color:#4CC38A">+3</span>', '#F2D27A')}${stat('14&ndash;6', 'wins &ndash; losses')}
    ${stat('9', 'days in a row, your longest')}${stat('#2', 'among your 6 friends', 'var(--rival)')}</div>`)}
  ${at(16, 568, 380, `<div class="box" style="padding:14px 16px"><div class="cap" style="margin:0 0 8px;padding:0"><span>Your month, day by day</span><span style="color:var(--text)">Sat 22: 160</span></div>
    <div style="display:flex;align-items:flex-end;gap:3px;height:70px">${Array.from({ length: 30 }, (_, i) => { const v = [0, 40, 60, 0, 35, 80, 120, 0, 50, 70, 90, 0, 60, 110, 30, 0, 75, 95, 40, 0, 85, 160, 70, 0, 55, 100, 65, 0, 45, 90][i]; return `<i style="flex:1;height:${Math.max(3, v / 160 * 70)}px;border-radius:2px;background:${i === 21 ? '#F2D27A' : v ? '#E8DCC8' : '#2a2724'}"></i>`; }).join('')}</div></div>`)}
  ${btns('Share my month', 'Done')}`;

const MO = {
  a: { t: 'A &middot; شاشة لوحدها، زي LEVEL UP (مقترح)',
    s: 'بعد الماتش اللي كسرت فيه رقمك، أو عدّيت فيه علامة زي 1,000 ضغطة: شاشة احتفال كاملة فيها كونفيتي، قبل شاشة النتيجة، زي ما LEVEL UP بيعمل دلوقتي. فيها زرار شير بكارت جاهز.',
    p: [['دلوقتي', 'LEVEL UP المبني (نفس الفكرة)', `<img src="${LU}" width="412" style="display:block">`], ['رقم قياسي جديد', 'لما تكسر أحسن رقم ليك', pbScreen()], ['علامة', '100 ثم 1K ثم 5K ثم 10K ثم 25K', milestoneScreen()]] },
  b: { t: 'B &middot; جوه شاشة النتيجة',
    s: 'من غير شاشة زيادة: كارت دهبي فوق النتيجة نفسها بالرقم القياسي أو العلامة، وجنبه زرار شير. أهدى، بس أقل فرحة.',
    p: [['دلوقتي', 'النتيجة المبنية', `<img src="${RW}" width="412" style="display:block">`], ['الجديد', 'الكروت الدهبي فوق النتيجة', resultB()]] },
  recap: { t: 'ملخص الشهر (نفس الحاجة في الشكلين)',
    s: 'أول يوم في كل شهر، كارت دهبي في الهوم &laquo;Your November is in&raquo;. بتدوس عليه يفتحلك ملخص شهرك: عدد الضغطات، وأحسن دقيقة، والكسب والخسارة، وأطول ستريك، وترتيبك وسط صحابك، ورسمة لكل يوم. وتشيره بكارت.',
    p: [['الهوم', 'الكارت في أول يوم في الشهر', homeCard()], ['الملخص', 'شهرك كله في شاشة', recap()]] },
};
function drawMo(k) {
  const o = MO[k];
  const col = (t, s, inner) => `<div><div class="lab">${t}<small>${s}</small></div><div class="phone">${inner}</div></div>`;
  document.body.innerHTML = `<div class="sec">${o.t}<small>${o.s}</small></div><div class="row">${o.p.map(([a, b, c]) => col(a, b, c)).join('')}</div>`;
}
