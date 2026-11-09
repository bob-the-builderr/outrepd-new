// Three new milestone celebrations beside the built one (the user,
// 2026-11-09: "can we change the design of the milestone celebration?").
// Uses ../../2026-11-09/challenge.css and challenge.js (face, at, center).
const GOLD = '#E0B145', GL = '#F2D27A';
const btn2 = (a, b) => `${at(18, 778, 376, `<div class="btn pri" style="height:56px;border-radius:28px">${a}</div>`)}${at(18, 841, 376, `<div class="btn sec2" style="height:56px;border-radius:28px">${b}</div>`)}`;
const rays = (cx, cy, n = 18, c = 'rgba(224,177,69,.16)') => {
  let p = '';
  for (let i = 0; i < n; i++) {
    const a = (i / n) * Math.PI * 2, b = a + Math.PI / n / 1.4;
    p += `<path d="M${cx} ${cy} L${cx + Math.cos(a) * 700} ${cy + Math.sin(a) * 700} L${cx + Math.cos(b) * 700} ${cy + Math.sin(b) * 700} Z" fill="${c}"/>`;
  }
  return `<svg class="abs" style="left:0;top:0" width="412" height="915">${p}</svg>`;
};
const sparks = (seed, n, h) => {
  let r = seed, o = '';
  const rnd = () => (r = (r * 9301 + 49297) % 233280) / 233280;
  for (let i = 0; i < n; i++) {
    const x = rnd() * 412, y = rnd() * h, s = 2 + rnd() * 4;
    o += `<i style="position:absolute;left:${x}px;top:${y}px;width:${s}px;height:${s}px;border-radius:50%;background:${i % 3 ? GL : '#fff'};box-shadow:0 0 ${s * 3}px ${GL};opacity:${0.5 + rnd() * 0.5}"></i>`;
  }
  return `<div class="abs" style="inset:0">${o}</div>`;
};

// A: the count rolls up to the mark like a scoreboard, and lands with a stamp.
const digit = (d, big = true) => `<span style="display:inline-grid;place-items:center;width:${big ? 64 : 40}px;height:${big ? 96 : 60}px;margin:0 3px;border-radius:12px;background:linear-gradient(180deg,#2a2622 0 49%,#1c1a18 51%);box-shadow:inset 0 0 0 1px #3a3631,0 10px 24px rgba(0,0,0,.5);font:900 ${big ? 70 : 42}px/1 'Noto Sans';color:${GL};position:relative">${d}<i style="position:absolute;left:0;right:0;top:50%;height:2px;background:#121110"></i></span>`;
const optA = () => `${rays(206, 300)}${sparks(5, 26, 520)}
  ${center(118, `<div style="font:800 14px 'Noto Sans';letter-spacing:6px;color:${GOLD}">YOU JUST HIT</div>`)}
  ${center(170, `<div style="display:flex;justify-content:center;align-items:center">${digit('1')}<span style="font:900 60px 'Noto Sans';color:${GL};margin:0 2px">,</span>${digit('0')}${digit('0')}${digit('0')}</div>`)}
  ${center(286, `<div style="font:800 22px 'Noto Sans';letter-spacing:4px">PUSH-UPS</div>`)}
  ${center(340, `<div style="display:inline-block;transform:rotate(-8deg);padding:10px 22px;border:4px solid ${GOLD};border-radius:14px;font:900 30px 'Noto Sans';letter-spacing:3px;color:${GOLD};box-shadow:0 0 30px rgba(224,177,69,.35)">1K CLUB</div>`)}
  ${at(18, 470, 376, `<div class="box" style="padding:16px 18px">
    <div style="display:flex;justify-content:space-between;font:600 15px 'Noto Sans'"><span>Next stop: 5,000</span><span class="mini">3,988 to go</span></div>
    <div style="height:8px;border-radius:4px;background:#2a2724;margin-top:12px;overflow:hidden"><div style="width:20%;height:100%;background:${GOLD}"></div></div>
    <div class="mini" style="margin-top:10px">Every one counted on camera.</div></div>`)}
  ${btn2('Share it', 'Continue')}`;

// B: an award plaque with the lifter's name and the day, like a real trophy.
const optB = () => `<div class="abs" style="inset:0;background:radial-gradient(60% 45% at 50% 34%,rgba(224,177,69,.28),transparent 70%)"></div>${sparks(9, 18, 460)}
  ${center(96, `<div style="font:800 14px 'Noto Sans';letter-spacing:6px;color:${GOLD}">MILESTONE</div>`)}
  ${at(56, 136, 300, `<div style="height:330px;border-radius:22px;padding:7px;background:linear-gradient(135deg,#F7DE8E,#C9952F 45%,#8F6A22);box-shadow:0 30px 60px rgba(0,0,0,.6),0 0 60px rgba(224,177,69,.25)">
    <div style="height:100%;border-radius:16px;background:linear-gradient(180deg,#221d16,#15120e);box-shadow:inset 0 0 0 1.5px rgba(242,210,122,.5);display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center;padding:18px">
      <div style="font:800 11px 'Noto Sans';letter-spacing:4px;color:#b8a170">OUTREPD AWARD</div>
      <div style="margin:14px 0 10px">${face('me', 74)}</div>
      <div style="font:900 64px/1 'Noto Sans';color:${GL};text-shadow:0 0 24px rgba(242,210,122,.4)">1,000</div>
      <div style="font:800 15px 'Noto Sans';letter-spacing:3px;margin-top:4px">PUSH-UPS</div>
      <div style="width:120px;height:1px;background:rgba(242,210,122,.4);margin:12px 0"></div>
      <div style="font:700 15px 'Noto Sans'">mokhtar</div><div class="mini" style="font-size:12.5px">November 9, 2026</div>
    </div></div>`)}
  ${at(150, 470, 112, `<div style="height:20px;border-radius:0 0 10px 10px;background:linear-gradient(180deg,#8F6A22,#5c4416)"></div><div style="height:12px;margin:0 -24px;border-radius:6px;background:linear-gradient(180deg,#3a3026,#221d16)"></div>`)}
  ${center(530, `<div style="font:600 16px 'Noto Sans'">Next: <b style="color:${GL}">5,000</b> &middot; <span class="mini" style="font-size:15px">3,988 to go</span></div>`)}
  ${btn2('Share my award', 'Continue')}`;

// C: the lifter, big as on the VS screen, lifting the number over their head.
const optC = () => `<div class="abs" style="left:0;right:0;top:0;height:430px;background:#ff7a1a"></div>
  <div class="abs" style="left:0;right:0;top:0;height:430px;overflow:hidden"><div class="abs" style="left:-40px;top:-470px;width:492px;height:1093px;background:url(vs.png) no-repeat;background-size:492px auto"></div></div>
  <div class="abs" style="left:0;right:0;top:0;height:120px;background:#121110"></div>
  <div class="abs" style="left:0;right:0;top:120px;height:312px;background:linear-gradient(180deg,#121110 0%,rgba(18,17,16,0) 22%,rgba(18,17,16,0) 70%,#121110 92%)"></div>
  <div class="abs" style="left:0;right:0;top:420px;bottom:0;background:#121110"></div>
  <div class="abs" style="left:0;right:0;top:0;height:420px;overflow:hidden">${rays(206, 120, 14, 'rgba(255,255,255,.07)')}</div>${sparks(13, 22, 300)}
  ${center(46, `<div style="font:800 14px 'Noto Sans';letter-spacing:6px;color:${GL}">YOU JUST HIT</div>`)}
  ${center(72, `<div style="font:900 104px/1 'Noto Sans';color:#fff;text-shadow:0 6px 0 #121110,0 0 40px rgba(242,210,122,.6);-webkit-text-stroke:3px #121110;paint-order:stroke fill">1,000</div>`)}
  ${center(182, `<div style="display:inline-block;padding:6px 16px;border-radius:999px;background:#121110;font:800 14px 'Noto Sans';letter-spacing:3px">PUSH-UPS</div>`)}
  ${center(450, `<div style="font:900 30px 'Noto Sans'">The 1K club is yours.</div><div class="mini" style="font-size:15px;margin-top:6px">Every one counted on camera.</div>`)}
  ${at(18, 540, 376, `<div class="box" style="padding:16px 18px"><div style="display:flex;justify-content:space-between;font:600 15px 'Noto Sans'"><span>Next: 5,000</span><span class="mini">3,988 to go</span></div>
    <div style="height:8px;border-radius:4px;background:#2a2724;margin-top:12px;overflow:hidden"><div style="width:20%;height:100%;background:${GOLD}"></div></div></div>`)}
  ${btn2('Share it', 'Continue')}`;

const OPTS = [
  ['دلوقتي', 'الشكل المبني', `<img src="built_milestone.png" width="412" style="display:block">`],
  ['A &middot; عدّاد بيلف', 'الرقم بيعدّ لحد 1,000 زي لوحة النتيجة، وبعدين ختم "1K CLUB"', optA()],
  ['B &middot; درع جايزة', 'درع دهبي محفور عليه اسمك والتاريخ، زي الجوايز الحقيقية', optB()],
  ['C &middot; شخصيتك بطل', 'الشخصية بتاعتك كبيرة زي شاشة الـ VS، والرقم فوقها', optC()],
];
function drawMs() {
  const col = ([t, s, inner]) => `<div><div class="lab">${t}<small>${s}</small></div><div class="phone">${inner}</div></div>`;
  document.body.innerHTML = `<div class="sec">احتفال الوصول لعدد العدّات: 3 أشكال جديدة<small>كلهم بيظهروا في نفس المكان (بعد الماتش، قبل النتيجة)، وفيهم زرار شير. في الحقيقة كل حاجة بتتحرك: الأرقام بتلف، والختم بينزل، والنجوم بتلمع.</small></div><div class="row">${OPTS.map(col).join('')}</div>`;
}
