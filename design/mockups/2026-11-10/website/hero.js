// Three bolder heroes for outrepd.com, each at desktop (1280 x 820) and
// phone (412 x 880) size. The art is the app's own: the VS screen's two
// lifters, the result screen's faces, the live match.
const nav = (mob) => mob
  ? `<div class="nav" style="padding:0 18px;height:58px"><span class="brand">OUTREPD</span><span class="dl" style="padding:8px 14px;font-size:13px">Download</span></div>`
  : `<div class="nav"><span class="brand">OUTREPD</span><span class="links"><span>How it works</span><span>The app</span><span>Adventure</span><span>Ranks</span><span>FAQ</span></span><span class="dl">Download</span></div>`;
const badges = (s = 1) => `<div class="badges" style="transform:scale(${s});transform-origin:left top">
  <div class="badge"><svg width="20" height="24" viewBox="0 0 24 24" fill="#fff"><path d="M16.4 12.6c0-2.5 2-3.7 2.1-3.8-1.2-1.7-3-1.9-3.6-2-1.5-.2-3 .9-3.8.9-.8 0-2-.9-3.3-.9-1.7 0-3.3 1-4.2 2.5-1.8 3.1-.5 7.7 1.3 10.2.9 1.2 1.9 2.6 3.2 2.6 1.3-.1 1.8-.8 3.3-.8 1.6 0 2 .8 3.3.8 1.4 0 2.3-1.3 3.1-2.5 1-1.4 1.4-2.8 1.4-2.9-.1 0-2.8-1-2.8-4.1zM14 5.2c.7-.8 1.2-2 1-3.2-1 0-2.2.7-3 1.5-.6.7-1.2 1.9-1 3.1 1.1.1 2.3-.6 3-1.4z"/></svg><span>Download on the<b>App Store</b></span></div>
  <div class="badge"><svg width="20" height="22" viewBox="0 0 24 24"><path fill="#34A853" d="M3 2l11 10L3 22c-.6-.3-1-1-1-1.8V3.8C2 3 2.4 2.3 3 2z"/><path fill="#FBBC04" d="M17.7 15.4 14 12l3.7-3.4 3.9 2.2c1.1.6 1.1 1.8 0 2.4z"/><path fill="#EA4335" d="M14 12 3 22c.4.2 1 .2 1.5-.1l13.2-6.5z"/><path fill="#4285F4" d="M14 12 17.7 8.6 4.5 2.1C4 1.8 3.4 1.8 3 2z"/></svg><span>GET IT ON<b>Google Play</b></span></div></div>`;
const face = (cx, cy, r, d, src = 'result.png') => {
  const s = d / (2 * r);
  return `<div style="width:${d}px;height:${d}px;border-radius:50%;flex:none;background:url(${src}) no-repeat;background-size:${824 * s}px auto;background-position:-${(cx - r) * s}px -${(cy - r) * s}px"></div>`;
};
const me = (d) => face(224, 338, 70, d), them = (d) => face(600, 338, 70, d);
const headline = (size, mob) => `<p class="display" style="font-size:${size}px">Outrep<br>anyone.<br><span style="color:var(--rival)">Live.</span></p>`;

// ── A: the VS poster ─────────────────────────────────────────────────────────
// The app's VS screen as the whole first screen: the rival dropping in on one
// side, you on the other, VS slammed between, the live count above.
const aDesk = () => `
  <div class="abs" style="inset:0;clip-path:polygon(0 0,60% 0,44% 100%,0 100%);background:#e8dcc8">
    <div class="abs" style="left:-60px;top:-150px;width:900px;height:2000px;background:url(vs.png) no-repeat;background-size:900px auto"></div>
    <div class="abs" style="inset:0;background:linear-gradient(0deg,#121110 0%,rgba(18,17,16,.96) 36%,rgba(18,17,16,0) 58%)"></div></div>
  <div class="abs" style="inset:0;clip-path:polygon(60% 0,100% 0,100% 100%,44% 100%);background:#ff7a1a">
    <div class="abs" style="left:520px;top:-1200px;width:1000px;height:2300px;background:url(vs.png) no-repeat;background-size:1000px auto"></div>
    <div class="abs" style="inset:0;background:linear-gradient(0deg,#121110 0%,rgba(18,17,16,.96) 36%,rgba(18,17,16,0) 58%)"></div></div>
  <div class="abs" style="left:0;right:0;top:0;bottom:0;background:linear-gradient(180deg,rgba(18,17,16,.75),rgba(18,17,16,0) 22%)"></div>
  <svg class="abs" style="left:0;top:0" width="1280" height="820"><line x1="768" y1="0" x2="563" y2="820" stroke="#121110" stroke-width="26"/></svg>
  <div class="abs display" style="left:540px;top:170px;font-size:170px;color:var(--cream);transform:rotate(-8deg);text-shadow:0 12px 40px rgba(0,0,0,.6);-webkit-text-stroke:6px #121110;paint-order:stroke fill">VS</div>
  ${nav(false)}
  <div class="abs" style="left:0;right:0;top:86px;display:flex;justify-content:center"><div class="card" style="display:flex;align-items:center;gap:22px;padding:10px 22px;border-radius:999px">
    <span class="display" style="font-size:44px;color:var(--rival)">11</span><span class="pill" style="border:0;background:#2a2622"><i></i>0:42</span><span class="display" style="font-size:44px;color:var(--cream)">18</span></div></div>
  <div class="abs" style="left:0;right:0;bottom:48px;text-align:center">
    <div class="kicker">Live 1v1 push-up challenge app</div>
    <p class="display" style="font-size:78px;margin:14px 0 16px">Outrep anyone. <span style="color:var(--rival)">Live.</span></p>
    <p class="lead" style="margin:0 auto 22px;max-width:620px">Phone on the floor, a real rival on the other side, sixty seconds on the clock. Your camera counts every full rep.</p>
    <div style="display:flex;justify-content:center">${badges()}</div>
  </div>
  <div class="abs" style="display:none">
    <div style="font:800 26px var(--display);font-stretch:125%;text-transform:uppercase">karim.reps <span style="color:var(--muted)">vs</span> you</div>
    <div style="color:var(--gold);font:700 14px var(--body);margin-top:4px">Silver III · Lv 5 &nbsp;&middot;&nbsp; Gold III · Lv 12</div></div>`;
const aMob = () => `
  <div class="abs" style="left:0;top:6px;width:412px;height:915px;background:url(vs.png) no-repeat;background-size:412px auto"></div>
  <div class="abs" style="left:0;right:0;top:420px;bottom:0;background:linear-gradient(180deg,rgba(18,17,16,0),rgba(18,17,16,.92) 34%,#121110 60%)"></div>
  <div class="abs" style="left:0;right:0;top:0;height:60px;background:#121110"></div>${nav(true)}
  <div class="abs" style="left:20px;right:20px;top:530px">
    <div class="kicker">Live 1v1 push-up challenge app</div>
    <div style="margin:10px 0 12px">${headline(58, true)}</div>
    <p class="lead" style="font-size:15px;margin-bottom:16px">A real rival, sixty seconds, every full rep counted by your phone's camera.</p>
    ${badges(0.9)}</div>`;

// ── B: the count ─────────────────────────────────────────────────────────────
// The scoreboard as the hero: two counts racing, the clock running down — on
// the real page the numbers tick up as you watch.
const board = (scale = 1) => `<div class="card" style="width:${560 * scale}px;padding:${26 * scale}px;border-radius:${26 * scale}px;background:radial-gradient(120% 80% at 50% 0%,#2b2520,#1c1a18 60%)">
  <div style="display:flex;justify-content:space-between;align-items:center"><span class="pill"><i></i>Live · ranked</span>
    <svg width="${70 * scale}" height="${70 * scale}" viewBox="0 0 70 70"><circle cx="35" cy="35" r="30" fill="none" stroke="#2c2926" stroke-width="6"/><circle cx="35" cy="35" r="30" fill="none" stroke="#e8dcc8" stroke-width="6" stroke-linecap="round" stroke-dasharray="132 189" transform="rotate(-90 35 35)"/><text x="35" y="41" text-anchor="middle" fill="#F5EFE4" style="font:900 18px Archivo">0:42</text></svg></div>
  <div style="display:flex;margin-top:${10 * scale}px">
    <div style="flex:1;text-align:center">${'<div style="display:flex;justify-content:center">' + me(86 * scale) + '</div>'}<div style="font:700 ${15 * scale}px var(--body);color:var(--soft);margin-top:6px">You</div>
      <div class="display" style="font-size:${150 * scale}px;color:var(--cream);line-height:.95">18</div></div>
    <div style="flex:1;text-align:center">${'<div style="display:flex;justify-content:center">' + them(86 * scale) + '</div>'}<div style="font:700 ${15 * scale}px var(--body);color:var(--soft);margin-top:6px">karimfit</div>
      <div class="display" style="font-size:${150 * scale}px;color:var(--rival);line-height:.95">11</div></div></div>
  <div style="display:flex;gap:10px;margin-top:${16 * scale}px"><div style="flex:18;height:${12 * scale}px;border-radius:6px;background:var(--cream)"></div><div style="flex:11;height:${12 * scale}px;border-radius:6px;background:var(--rival)"></div></div>
  <div style="display:flex;justify-content:space-between;margin-top:${12 * scale}px;font:600 ${13 * scale}px var(--body);color:var(--muted)"><span>+7 ahead</span><span>Counted on each phone</span></div></div>`;
const bDesk = () => `
  <div class="abs" style="right:-80px;top:0;width:760px;height:820px;background:url(lifter.webp) center/cover no-repeat;opacity:.28;filter:grayscale(.3)"></div>
  <div class="abs" style="inset:0;background:radial-gradient(60% 70% at 78% 50%,rgba(224,177,69,.10),rgba(18,17,16,0) 70%),linear-gradient(90deg,#121110 35%,rgba(18,17,16,.4))"></div>
  ${nav(false)}
  <div class="abs" style="left:64px;top:170px;width:560px">
    <div class="kicker">Live 1v1 push-up challenge app</div>
    <div style="margin:16px 0 20px">${headline(104)}</div>
    <p class="lead" style="max-width:470px;margin-bottom:24px">Phone on the floor, a real rival on the other side, sixty seconds on the clock. The higher count takes the rating.</p>
    ${badges()}</div>
  <div class="abs" style="left:660px;top:150px">${board()}</div>`;
const bMob = () => `
  <div class="abs" style="inset:0;background:radial-gradient(90% 50% at 50% 70%,rgba(224,177,69,.12),rgba(18,17,16,0) 70%)"></div>
  ${nav(true)}
  <div class="abs" style="left:20px;right:20px;top:84px">
    <div class="kicker">Live 1v1 push-up challenge app</div>
    <div style="margin:10px 0 12px">${headline(56, true)}</div></div>
  <div class="abs" style="left:20px;top:330px">${board(0.664)}</div>
  <div class="abs" style="left:20px;right:20px;top:660px"><p class="lead" style="font-size:15px;margin-bottom:16px">A real rival, sixty seconds, every full rep counted by your phone's camera.</p>${badges(0.9)}</div>`;

// ── C: the phone and everything around it ───────────────────────────────────
// The live match on a phone turned towards you, the rest of the app floating
// around it: the rating it pays, a challenge link, the plan, the level.
const phone = (w) => `<div style="width:${w}px;height:${w * 2.17}px;border-radius:${w * 0.16}px;background:#0a0a0a;padding:${w * 0.035}px;box-shadow:0 0 0 2px #3a3631,0 40px 80px rgba(0,0,0,.6),0 0 120px rgba(232,132,107,.18)">
  <div style="width:100%;height:100%;border-radius:${w * 0.13}px;background:url(live.png) center/cover no-repeat"></div></div>`;
const chipRating = `<div class="card" style="display:flex;align-items:center;gap:12px;padding:12px 16px"><div style="width:40px;height:40px;border-radius:12px;background:#2a2214;display:grid;place-items:center;color:var(--gold);font:900 18px Archivo">▲</div><div><div class="display" style="font-size:24px;line-height:1">+32</div><div style="font:600 12px var(--body);color:var(--muted)">rating · Gold III</div></div></div>`;
const chipChallenge = `<div class="card" style="padding:14px 18px;width:230px"><div style="font:800 11px var(--body);letter-spacing:.16em;color:var(--rival)">CHALLENGE LINK</div><div class="display" style="font-size:30px;margin-top:6px">Can you beat 18?</div><div style="margin-top:10px;display:inline-block;background:var(--rival);color:#1a0f0b;font:800 12px var(--body);padding:5px 12px;border-radius:999px">outrepd.com/c/k7f2</div></div>`;
const chipPlan = `<div class="card" style="padding:14px 16px;width:220px"><div style="display:flex;justify-content:space-between;font:800 13px var(--body)"><span>Road to 36</span><span style="color:var(--green)">On track</span></div>
  <svg width="188" height="70" style="margin-top:8px"><line x1="8" y1="60" x2="180" y2="10" stroke="#3a3631" stroke-width="2" stroke-dasharray="4 5"/><polyline points="8,60 37,52 66,40" fill="none" stroke="#E8DCC8" stroke-width="3"/><circle cx="66" cy="40" r="5" fill="#E8DCC8"/><circle cx="180" cy="10" r="5" fill="none" stroke="#E0B145" stroke-width="2.5"/></svg>
  <div style="font:600 12px var(--body);color:var(--muted)">Beat last week's you</div></div>`;
const chipLevel = `<div class="card" style="display:flex;align-items:center;gap:10px;padding:10px 14px">${me(36)}<div><div style="font:800 14px var(--body)">Level 12</div><div style="font:600 12px var(--body);color:var(--gold)">+38 XP</div></div></div>`;
const cDesk = () => `
  <div class="abs" style="inset:0;background:radial-gradient(50% 60% at 72% 52%,rgba(232,132,107,.16),rgba(18,17,16,0) 70%)"></div>
  ${nav(false)}
  <div class="abs" style="left:64px;top:190px;width:540px">
    <div class="kicker">Live 1v1 push-up challenge app</div>
    <div style="margin:16px 0 20px">${headline(100)}</div>
    <p class="lead" style="max-width:450px;margin-bottom:24px">Race real people live, dare friends with a link, and beat last week's you. Your camera counts every full rep.</p>
    ${badges()}</div>
  <div class="abs" style="left:780px;top:96px;transform:perspective(1600px) rotateY(-18deg) rotateX(6deg) rotate(2deg)">${phone(300)}</div>
  <div class="abs" style="left:640px;top:160px;transform:rotate(-4deg)">${chipRating}</div>
  <div class="abs" style="left:600px;top:520px;transform:rotate(-3deg)">${chipChallenge}</div>
  <div class="abs" style="left:1040px;top:250px;transform:rotate(4deg)">${chipPlan}</div>
  <div class="abs" style="left:1030px;top:620px;transform:rotate(3deg)">${chipLevel}</div>`;
const cMob = () => `
  <div class="abs" style="inset:0;background:radial-gradient(80% 40% at 50% 72%,rgba(232,132,107,.18),rgba(18,17,16,0) 70%)"></div>
  ${nav(true)}
  <div class="abs" style="left:20px;right:20px;top:80px">
    <div class="kicker">Live 1v1 push-up challenge app</div>
    <div style="margin:10px 0 0">${headline(52, true)}</div></div>
  <div class="abs" style="left:116px;top:330px;transform:perspective(1200px) rotateY(-16deg) rotateX(6deg) rotate(2deg)">${phone(190)}</div>
  <div class="abs" style="left:12px;top:380px;transform:rotate(-4deg) scale(.85);transform-origin:left top">${chipRating}</div>
  <div class="abs" style="left:236px;top:640px;transform:rotate(4deg) scale(.7);transform-origin:left top">${chipPlan}</div>
  <div class="abs" style="left:20px;right:20px;top:790px">${badges(0.9)}</div>`;

const OPTIONS = {
  a: { t: 'A &middot; بوستر الـ VS', s: 'أول شاشة في الموقع هي شاشة الـ VS بتاعة التطبيق: الخصم في ناحية وانت في الناحية التانية، VS في النص، والعدّ اللايف فوق. شكلها زي بوستر ماتش ملاكمة.',
    n: 'في الصفحة الحقيقية: النصّين بيدخلوا من الجنبين وكلمة VS بتنزل بخبطة، زي ما بيحصل في التطبيق.', d: aDesk(), m: aMob() },
  b: { t: 'B &middot; العدّاد', s: 'لوحة الماتش هي البطل: رقمين كبار بيتسابقوا، والساعة بتعدّ. أبسط وأوضح، وبتقول الفكرة من أول نظرة.',
    n: 'في الصفحة الحقيقية: الرقمين بيعدّوا قدامك من 0، والساعة بتنزل، والبارين بيكبروا.', d: bDesk(), m: bMob() },
  c: { t: 'C &middot; الموبايل وحواليه التطبيق (مقترح)', s: 'الماتش اللايف على موبايل مايل ناحيتك، وحواليه أهم حاجات التطبيق: الريتنج، ولينك التحدي، والخطة، واللفل. بيوري التطبيق كله في شاشة واحدة.',
    n: 'في الصفحة الحقيقية: الكروت بتتحرك بالراحة حوالين الموبايل، والموبايل بيلف شوية مع حركة الماوس.', d: cDesk(), m: cMob() },
};
function draw(k) {
  const o = OPTIONS[k];
  document.body.innerHTML = `<div class="sec">${o.t}<small>${o.s}</small></div>
  <div class="row"><div><div class="lab">كمبيوتر</div><div class="desk">${o.d}</div><div class="note">${o.n}</div></div>
  <div><div class="lab">موبايل</div><div class="mob">${o.m}</div></div></div>`;
}
