// Another player's profile: three directions, drawn at 412 x 915.
// parts.js is lib/tier_badge.dart's painters; the framed pictures are cut from
// the built app's own screens, so what is shown is what the app can draw.
const D = 5; // Diamond, as in the store screenshot.
const t = T[D];

// iron_mike in his frame, cut from now_other.png (1320 wide).
const mike = (w) => {
  const k = w / 460;
  return `<div style="width:${w}px;height:${Math.round(310 * k)}px;background:url(now_other.png) no-repeat;background-size:${Math.round(1320 * k)}px auto;background-position:-${Math.round(430 * k)}px -${Math.round(158 * k)}px;mix-blend-mode:lighten;flex:none"></div>`;
};
// You in your frame, cut from now_me.png (824 wide).
const me = (w) => {
  const k = w / 320;
  return `<div style="width:${w}px;height:${Math.round(200 * k)}px;background:url(now_me.png) no-repeat;background-size:${Math.round(824 * k)}px auto;background-position:-${Math.round(252 * k)}px -${Math.round(85 * k)}px;mix-blend-mode:lighten;flex:none"></div>`;
};

const appBar = () => `<div class="abar">
  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#F4EDE4" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M15 5l-7 7 7 7"/></svg>
  <svg width="24" height="24" viewBox="0 0 24 24" fill="#F4EDE4"><circle cx="12" cy="5" r="2"/><circle cx="12" cy="12" r="2"/><circle cx="12" cy="19" r="2"/></svg>
</div>`;
const pin = (label) => `<div class="pin"><div class="btn">${label}</div></div>`;
const nameLine = (size = 26) => `<div style="display:flex;align-items:center;justify-content:center;gap:8px"><span style="font:800 ${size}px 'Noto Sans'">iron_mike</span><span class="lv">Lv 24</span></div>`;
const titleLine = () => `<div style="text-align:center;font:600 14px 'Noto Sans';color:#A45BC4;margin-top:1px">&#9889; Giant Slayer</div>`;

// The big rank card, as on your own profile.
const rankBig = (ch = 112) => framed(D, 412, ch, `<div style="display:flex;align-items:center;width:100%;padding:0 14px 0 8px;text-align:left">
  <div style="position:relative;width:84px;height:72px;flex:none"><div class="breath" style="position:absolute;left:0;top:-6px;width:84px;height:84px;border-radius:50%;background:radial-gradient(closest-side,${t.mid}66,transparent)"></div><div style="position:absolute;left:0;top:0">${crest(D, 84)}</div></div>
  <div style="flex:1;margin-left:10px;min-width:0">
    <div style="display:flex;justify-content:space-between;align-items:baseline"><span class="tag" style="color:${t.light};font-size:13px">DIAMOND IV</span><span style="font:600 12.5px 'Noto Sans';color:#F4EDE4">Next: Diamond III</span></div>
    <div style="font:800 32px/1.15 'Noto Sans'">3,672</div>
    <div class="bar" style="height:7px;margin-top:5px;border-radius:4px"><i style="width:72%;background:${t.mid}"></i></div>
    <div style="font:500 12px 'Noto Sans';color:var(--muted);margin-top:4px">28 to go</div>
  </div></div>`);

// The slim rank row.
const rankSlim = () => framed(D, 412, 76, `<div style="display:flex;align-items:center;width:100%;padding:0 12px 0 8px;text-align:left">
  <div style="position:relative;width:56px;height:48px;flex:none"><div style="position:absolute;left:0;top:0">${crest(D, 56)}</div></div>
  <div style="flex:1;margin-left:8px;min-width:0">
    <div class="tag" style="color:${t.light}">DIAMOND IV</div>
    <div class="rate">3,672 <span>&nbsp;&middot;&nbsp; 28 to Diamond III</span></div>
    <div class="bar"><i style="width:72%;background:${t.mid}"></i></div>
  </div></div>`);

const cell = (label, value) => `<div class="cell"><span>${label}</span><b>${value}</b></div>`;
const unit = (a, b, c, d) => `${a}<small>${b}</small> ${c}<small>${d}</small>`;
// One card, as your own profile's numbers are.
const stats6 = () => `<div class="grid">
  ${cell('Global', '#3')}${cell('United States', '#1')}${cell('Best set', '31')}
  ${cell('Total reps', '3,140')}${cell('Record', unit('41', 'W', '12', 'L'))}${cell('Streak', '22')}
</div>`;
const stats4 = () => `<div class="grid four">${cell('Best set', '31')}${cell('Win rate', '77%')}${cell('Total reps', '3,140')}${cell('Streak', '22')}</div>`;

const h2h = () => `<div class="card" style="padding:13px 16px 12px">
  <div style="font:600 14px 'Noto Sans';color:var(--muted)">Head to head</div>
  <div style="display:flex;align-items:baseline;margin-top:6px"><b style="font:800 30px/1 'Noto Sans'">1</b><span class="dim">&nbsp;You</span><span style="flex:1"></span><span class="dim">iron_mike&nbsp;</span><b style="font:800 30px/1 'Noto Sans';color:var(--rival)">3</b></div>
  <div style="display:flex;height:8px;border-radius:4px;overflow:hidden;margin-top:9px"><i style="flex:1;background:var(--cream)"></i><i style="flex:3;background:var(--rival)"></i></div>
  <div class="dim" style="margin-top:8px">Last time 14&ndash;19, 2d ago &middot; Your best 16</div>
</div>`;

// A: the same order and the same cards as your own profile.
const aFriend = () => `${appBar()}<div class="scroll" style="padding-top:48px">
  <div style="display:flex;justify-content:center">${mike(270)}</div>
  <div style="margin-top:8px">${nameLine(28)}</div>${titleLine()}
  <div style="margin-top:14px">${rankBig(118)}</div>
  <div class="pad" style="margin-top:6px">${stats6()}</div>
  <div class="pad" style="margin-top:12px">${h2h()}</div>
</div>${pin('Challenge')}`;
const aStranger = () => `${appBar()}<div class="scroll" style="padding-top:66px">
  <div style="display:flex;justify-content:center">${mike(330)}</div>
  <div style="margin-top:14px">${nameLine(30)}</div>${titleLine()}
  <div style="margin-top:26px">${rankBig(128)}</div>
  <div class="pad" style="margin-top:20px">${stats6()}</div>
</div>${pin('Add friend')}`;

// B: the match between you is the first thing on the page.
const bFriend = () => `${appBar()}
  <div class="vsbg"></div>
  <div class="scroll" style="padding-top:64px">
  <div class="vs">
    <div class="side">${me(196)}<div class="who">You</div></div>
    <div class="side">${mike(196)}<div class="who">iron_mike <span class="lv">Lv 24</span></div></div>
  </div>
  <div class="score"><b style="color:var(--cream)">1</b><i>&ndash;</i><b style="color:var(--rival)">3</b></div>
  <div style="text-align:center;margin-top:6px;font:600 15px 'Noto Sans';color:#E6DFD4">Last time 14&ndash;19, 2d ago</div>
  <div style="text-align:center;margin-top:1px;font:500 13.5px 'Noto Sans';color:var(--muted)">Your best against them: 16</div>
  <div style="margin-top:20px">${rankBig(108)}</div>
  <div class="pad" style="margin-top:6px">${stats6()}</div>
</div>${pin('Challenge')}`;
const bStranger = aStranger;

// C: a big player card in their tier's colours; on a Pro, their cover.
const hero = (h) => `<div class="hero" style="height:${h}px"></div>`;
const mikeK = (w) => `<div class="mk" style="width:${w}px;height:${Math.round(310 * w / 460)}px;background-size:100% 100%;flex:none"></div>`;
const heroTop = (w, size) => `<div style="display:flex;justify-content:center">${mikeK(w)}</div>
  <div style="margin-top:6px">${nameLine(size)}</div><div style="display:flex;justify-content:center;margin-top:5px"><span class="pill">&#9889; Giant Slayer</span></div>
  <div style="text-align:center;margin-top:10px"><div class="tag" style="color:${t.light};font-size:14px;letter-spacing:2px">DIAMOND IV</div>
  <div style="font:900 54px/1.05 'Noto Sans'">3,672</div>
  <div class="bar" style="height:7px;width:220px;margin:6px auto 0;border-radius:4px;background:#00000066"><i style="width:72%;background:${t.light}"></i></div>
  <div style="font:500 12.5px 'Noto Sans';color:#D8E9E6;margin-top:5px">28 to Diamond III &middot; Global #3 &middot; United States #1</div></div>`;
const h2hLine = () => `<div class="card" style="display:flex;align-items:center;padding:13px 16px">
  <div style="flex:1;min-width:0"><div style="font:600 14px 'Noto Sans'">You against them</div><div class="dim" style="margin-top:2px">Last time 14&ndash;19, 2d ago</div></div>
  <b style="font:800 30px/1 'Noto Sans';color:var(--cream)">1</b><span class="dim" style="margin:0 8px">&ndash;</span><b style="font:800 30px/1 'Noto Sans';color:var(--rival)">3</b>
</div>`;
const cFriend = () => `${hero(600)}${appBar()}<div class="scroll" style="padding-top:46px">
  ${heroTop(340, 32)}
  <div class="pad" style="margin-top:22px">${stats4()}</div>
  <div class="pad" style="margin-top:12px">${h2h()}</div>
</div>${pin('Challenge')}`;
const cStranger = () => `${hero(700)}${appBar()}<div class="scroll" style="padding-top:70px">
  ${heroTop(380, 34)}
  <div class="pad" style="margin-top:52px">${stats4()}</div>
</div>${pin('Add friend')}`;

const now = () => `<img src="now_other.png" width="412" style="display:block">`;
const OPTIONS = {
  a: { t: 'A &middot; زي بروفايلك', s: 'نفس ترتيب بروفايلك: كارت الرتبة الكبير، وكارت أرقام واحد، وبعدهم المواجهة، والزرار ثابت تحت.', f: aFriend, x: aStranger },
  b: { t: 'B &middot; المواجهة الأول', s: 'انت وهو وجه لوجه فوق والنتيجة بينكم. أقرب لروح اللعبة، ورتبته وأرقامه تحت.', f: bFriend, x: bStranger, xs: 'مفيش ماتش بينكم، فبيبقى زي A' },
  c: { t: 'C &middot; كارت لاعب كبير', s: 'نص الشاشة كارت بألوان رتبته: صورته كبيرة ورقمه ضخم، والـ Pro غلافه يظهر مكان اللون.', f: cFriend, x: cStranger },
};
function draw(k) {
  const o = OPTIONS[k];
  const col = (title, sub, inner) => `<div><div class="lab">${title}<small>${sub}</small></div><div class="phone">${inner}</div></div>`;
  document.body.innerHTML = `<div class="sec">${o.t}<small>${o.s}</small></div><div class="row">
    ${col('دلوقتي', 'النسخة المبنية، صديق لعبت معاه', now())}
    ${col('الشكل الجديد: صديق', 'اللي لعبت معاه وتقدر تتحداه', o.f())}
    ${col('الشكل الجديد: لاعب غريب', o.xs || 'من الرانك، من غير سجل بينكم', o.x())}
  </div>`;
  if (document.querySelector('.mk')) keyFrame();
}

// Lifts the frame off the screenshot's black: everything inside the ring is
// kept whole, outside it the dark falls away.
function keyFrame() {
  const img = new Image();
  img.onload = () => {
    const c = document.createElement('canvas');
    c.width = 460; c.height = 310;
    const g = c.getContext('2d');
    g.drawImage(img, -430, -158);
    const d = g.getImageData(0, 0, 460, 310), p = d.data;
    for (let y = 0; y < 310; y++) for (let x = 0; x < 460; x++) {
      const i = (y * 460 + x) * 4;
      if (Math.hypot(x - 231, y - 136) <= 134) continue;
      const v = Math.max(p[i], p[i + 1], p[i + 2]);
      p[i + 3] = Math.round(255 * Math.min(1, Math.max(0, (v - 34) / 56)));
    }
    g.putImageData(d, 0, 0);
    const url = c.toDataURL();
    document.querySelectorAll('.mk').forEach((e) => { e.style.backgroundImage = `url(${url})`; });
  };
  img.src = NOW_OTHER;
}
