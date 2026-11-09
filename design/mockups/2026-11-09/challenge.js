// A challenge by link: three places to send it from, and what happens once it
// is sent. Each phone is 412 x 915. Faces are cut from the built app's own
// screens: the sender is the result screen's "You" (called mokhtar here), the
// others are the Ranks tab's sample players, so each person keeps one face.
const W = 'now_result_win.png', R = 'now_ranks_top.png', H = 'now_tab_match.png';
const FACES = {
  me: [W, 224, 338, 70], karim: [W, 600, 338, 70],
  iron: [R, 213, 397, 49], squat: [R, 213, 546, 49], bench: [R, 213, 696, 49],
};
const face = (k, d) => {
  const [src, cx, cy, r] = FACES[k];
  const s = d / (2 * r);
  return `<div class="face" style="width:${d}px;height:${d}px;background-image:url(${src});background-size:${824 * s}px auto;background-position:-${(cx - r) * s}px -${(cy - r) * s}px"></div>`;
};
const at = (x, y, w, inner, more = '') => `<div class="abs" style="left:${x}px;top:${y}px;${w ? `width:${w}px;` : ''}${more}">${inner}</div>`;
const center = (y, inner, more = '') => `<div class="abs" style="left:0;right:0;top:${y}px;text-align:center;${more}">${inner}</div>`;
const scaled = (s, w, h, inner) => `<div style="width:${w * s}px;height:${h * s}px;overflow:hidden;border-radius:${8 / s}px"><div style="transform:scale(${s});transform-origin:0 0;width:${w}px;height:${h}px">${inner}</div></div>`;
const LINK = 'outrepd.com/c/k7f2';
const linkIcon = (c = '#E8846B') => `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="${c}" stroke-width="2.4" stroke-linecap="round"><path d="M10 14a4 4 0 0 0 5.7 0l3-3a4 4 0 0 0-5.7-5.7l-1 1"/><path d="M14 10a4 4 0 0 0-5.7 0l-3 3a4 4 0 0 0 5.7 5.7l1-1"/></svg>`;

// ── the cards that go out ────────────────────────────────────────────────────
// A: the match card the Share button makes today, with the challenge under it.
const matchCard = () => `<div class="card">
  <div class="brand">OUTREPD</div>
  ${at(26, 70, 90, `<div style="display:flex;flex-direction:column;align-items:center;gap:6px">${face('me', 74)}<div class="who">mokhtar</div></div>`)}
  ${at(296, 70, 90, `<div style="display:flex;flex-direction:column;align-items:center;gap:6px">${face('karim', 74)}<div class="who" style="color:var(--rival)">karimfit</div></div>`)}
  ${center(78, `<span style="font:900 64px 'Noto Sans';color:var(--text)">18</span><span style="font:900 40px 'Noto Sans';color:#5a534a;margin:0 8px;vertical-align:14px">&ndash;</span><span style="font:900 64px 'Noto Sans';color:var(--rival)">11</span>`)}
  ${at(22, 196, 368, `<div style="display:flex;gap:6px"><div style="flex:18;height:9px;border-radius:5px;background:var(--cream)"></div><div style="flex:11;height:9px;border-radius:5px;background:var(--rival)"></div></div>`)}
  ${at(62, 228, 288, `<div style="border-radius:14px;padding:12px 16px;text-align:left;background:#1b1813;box-shadow:inset 0 0 0 1.5px #c9a24a"><div style="font:800 12px 'Noto Sans';letter-spacing:1.5px;color:var(--gold)">GOLD III</div><div style="font:800 21px 'Noto Sans'">2,764 <span style="font:600 14px 'Noto Sans';color:var(--gold)">&middot; +32 rating</span></div></div>`)}
  ${center(338, `<div class="beat">CAN YOU BEAT 18?</div><div class="link hot">${LINK}</div>`)}
</div>`;
// B and C: one number and one question.
const challengeCard = (n) => `<div class="card">
  <div class="brand">OUTREPD</div>
  ${center(52, `<div style="display:flex;justify-content:center">${face('me', 124)}</div>`)}
  ${center(186, `<div class="who" style="font-size:18px">mokhtar challenges you</div>`)}
  ${center(214, `<div class="big" style="color:var(--text)">${n}</div>`)}
  ${center(338, `<div class="sub">push-ups in 60 seconds</div>`)}
  ${center(372, `<div class="beat">CAN YOU BEAT IT?</div><div class="link hot">${LINK}</div>`)}
</div>`;

// What the friend gets, in an example messenger.
const chat = (card, n) => `<div class="chat">
  <div class="chead"><span style="font-size:30px;color:#d9dee1;line-height:1">&lsaquo;</span>${face('me', 40)}<div><b>mokhtar</b><span>online</span></div></div>
  <div class="cbody">
    <div style="align-self:center;background:#1f2c34;border-radius:8px;padding:4px 10px;font:500 12.5px 'Noto Sans';color:#8fa3ad">TODAY</div>
    <div class="bub in" style="padding:4px 4px 18px">${scaled(0.68, 412, 515, card)}
      <div style="padding:6px 5px 0">I did ${n} push-ups in 60 seconds. Think you can beat me? <a>${LINK}</a></div><span class="t">9:41</span></div>
    <div class="bub out">Bet. Give me 5 minutes<span class="t">9:42</span></div>
  </div>
  <div class="cin">Message</div>
</div>`;

// ── where it is sent from ────────────────────────────────────────────────────
const resultNow = () => `<img src="${W}" width="412" style="display:block">`;
const done = (x, w) => at(x, 841, w, `<div class="btn sec2" style="height:56px;border-radius:28px">Done</div>`);

const aShare = () => `${resultNow()}<div class="abs" style="inset:0;background:rgba(0,0,0,.6)"></div>
  <div class="sheet" style="height:420px">
    <div style="width:40px;height:4px;border-radius:2px;background:#5a554e;margin:0 auto 16px"></div>
    <div style="display:flex;gap:14px;align-items:flex-start">
      ${scaled(0.4, 412, 515, matchCard())}
      <div style="flex:1;font:400 15px/1.45 'Noto Sans';color:#e8e2d8">Beat my 18 on OUTREPD<br><span style="color:var(--muted)">${LINK}</span>
        <div class="mini" style="margin-top:10px">The same Share button. The link now opens the challenge instead of the profile.</div></div>
    </div>
    <div class="apps">
      <div><i style="background:#25D366"></i>WhatsApp</div><div><i style="background:linear-gradient(45deg,#f09433,#dc2743,#bc1888)"></i>Instagram</div>
      <div><i style="background:#3d8bfd"></i>Messages</div><div><i style="background:#4a4640"></i>Copy link</div>
    </div>
  </div>`;

const bResult = () => `${resultNow()}<div class="abs" style="left:0;right:0;top:836px;height:79px;background:var(--bg)"></div>
  ${at(18, 841, 182, `<div class="btn ch" style="height:56px;border-radius:28px">${linkIcon()}Challenge</div>`)}${done(212, 182)}`;

const cHome = () => `<div class="abs" style="left:0;top:0;width:412px;height:690px;background:url(${H}) no-repeat;background-size:412px auto"></div>
  ${at(16, 690, 380, `<div class="box" style="height:78px;display:flex;align-items:center;gap:14px;padding:0 16px;box-shadow:inset 0 0 0 1.5px var(--rival)">
    <div style="width:46px;height:46px;border-radius:50%;background:#2B1E19;display:flex;align-items:center;justify-content:center;flex:none">${linkIcon()}</div>
    <div style="flex:1"><div style="font:700 18px 'Noto Sans'">Challenge a friend</div><div class="mini" style="font-size:14px">Your best: 24 in 60 seconds &middot; send it</div></div>
    <span style="font-size:28px;color:var(--muted)">&rsaquo;</span></div>`)}
  <div class="abs" style="left:0;top:780px;width:412px;height:135px;background:url(${H}) no-repeat;background-size:412px auto;background-position:0 -690px"></div>`;

// ── once it is sent ──────────────────────────────────────────────────────────
const web = () => `<div class="url"><div><svg width="14" height="14" viewBox="0 0 24 24" fill="#9B9489"><path d="M6 10V8a6 6 0 1 1 12 0v2h1v12H5V10h1zm2 0h8V8a4 4 0 1 0-8 0v2z"/></svg>${LINK}</div></div>
  ${center(116, `<div style="font:700 13px 'Noto Sans';letter-spacing:5px;color:#d9cfbf">OUTREPD</div>`)}
  ${center(150, `<div style="display:flex;justify-content:center">${face('me', 136)}</div>`)}
  ${center(300, `<div style="font:700 20px 'Noto Sans'">mokhtar challenges you</div>`)}
  ${center(330, `<div class="big" style="font-size:128px">18</div>`)}
  ${center(460, `<div style="font:500 17px 'Noto Sans';color:#cfc6b8">push-ups in 60 seconds</div>`)}
  ${center(494, `<div style="font:900 28px 'Noto Sans';color:var(--rival)">Can you beat it?</div>`)}
  ${center(548, `<div class="mini" style="font-size:15px;padding:0 40px">OUTREPD counts your push-ups with your phone&rsquo;s camera. It&rsquo;s free.</div>`)}
  ${at(24, 618, 364, `<div class="btn pri" style="height:58px;border-radius:29px">Get the app, then take it</div>`)}
  ${center(696, `<div style="font:600 16px 'Noto Sans';color:var(--cream)">Have the app? <u>Open the challenge</u></div>`)}
  ${center(760, `<div class="mini">Open 6 more days &middot; 3 people took it</div>`)}`;

const lrow = (k, name, sub, reps, extra = '', mine = false) => `<div class="lr ${mine ? 'me' : ''}">${k ? face(k, 38) : ''}<div class="n">${name}${sub ? `<small>${sub}</small>` : ''}</div>${extra}<div class="r">${reps}</div></div>`;

const inApp = () => `${at(18, 22, 0, `<span style="font-size:26px;color:var(--muted)">&#x2715;</span>`)}
  ${center(18, `<span class="pill"><i></i>CHALLENGE &middot; FRIENDLY</span>`)}
  ${center(76, `<div style="display:flex;justify-content:center">${face('me', 140)}</div>`)}
  ${center(226, `<div style="font:800 26px 'Noto Sans'">mokhtar</div><div style="font:600 15px 'Noto Sans';color:var(--gold)">Gold III &middot; Lv 12</div>`)}
  ${center(292, `<div class="mini" style="font-size:16px">challenges you to beat</div>`)}
  ${center(316, `<div class="big" style="font-size:112px">18</div>`)}
  ${center(428, `<div style="font:500 16px 'Noto Sans';color:#cfc6b8">push-ups in 60 seconds</div>`)}
  ${at(16, 474, 380, `<div class="cap"><span>On this challenge</span><span style="color:var(--text)">3 took it</span></div>
    <div class="box">${lrow('iron', 'iron_mike', '', 23, '<span class="tag beat">BEAT IT</span>')}${lrow('me', 'mokhtar', 'set it', 18)}${lrow('squat', 'squat_queen', '', 14)}</div>`)}
  ${center(686, `<div class="mini" style="padding:0 34px">Friendly: your rating stays where it is. Your push-ups count toward today&rsquo;s goal.</div>`)}
  ${at(18, 778, 376, `<div class="btn pri" style="height:56px;border-radius:28px">Take the challenge</div>`)}
  ${center(852, `<div style="font:600 16px 'Noto Sans';color:var(--muted)">Not now</div>`)}`;

const taker = () => `${center(20, `<div style="font:900 56px/1 'Noto Sans';color:var(--cream);letter-spacing:1px">YOU BEAT IT</div>`)}
  ${center(84, `<div style="font:500 17px 'Noto Sans';color:var(--muted)">3 more than mokhtar.</div>`)}
  ${at(18, 124, 376, `<div class="box" style="height:222px;display:flex;align-items:stretch;padding:12px">
    <div style="flex:1;border-radius:14px;box-shadow:inset 0 0 0 1.5px #5a554e;background:#262421;display:flex;flex-direction:column;align-items:center;padding-top:10px">${face('bench', 70)}<div style="font:500 15px 'Noto Sans';color:var(--muted);margin-top:4px">You</div><div style="font:900 58px/1.05 'Noto Sans'">21</div><div style="font:500 13px 'Noto Sans'">Winner</div></div>
    <div style="flex:1;display:flex;flex-direction:column;align-items:center;padding-top:10px">${face('me', 70)}<div style="font:500 15px 'Noto Sans';color:var(--muted);margin-top:4px">mokhtar</div><div style="font:900 58px/1.05 'Noto Sans';color:var(--rival)">18</div></div></div>`)}
  ${at(18, 368, 376, `<div class="cap"><span>On this challenge</span><span style="color:var(--text)">You&rsquo;re #2 of 4</span></div>
    <div class="box">${lrow('iron', 'iron_mike', '', 23)}${lrow('bench', 'You', '', 21, '', true)}${lrow('me', 'mokhtar', 'set it', 18)}${lrow('squat', 'squat_queen', '', 14)}</div>`)}
  ${center(626, `<div class="mini">Friendly &middot; rating unchanged &middot; +21 toward today&rsquo;s goal</div>`)}
  ${at(18, 778, 376, `<div class="btn pri" style="height:56px;border-radius:28px">Challenge mokhtar back</div>`)}
  ${at(18, 841, 182, `<div class="btn sec2" style="height:56px;border-radius:28px">Share</div>`)}${done(212, 182)}`;

const sender = () => `<div class="push"><div class="ic">O</div><div style="flex:1"><b>OUTREPD</b><span class="tm">now</span>
    <p>benchgod beat your 18 with 21. Take it back?</p></div></div>
  ${at(16, 122, 0, `<div style="display:flex;align-items:center;gap:10px;white-space:nowrap"><span style="font-size:30px;color:var(--text);line-height:1">&lsaquo;</span><span style="font:700 26px 'Noto Sans'">Your challenge</span></div>`)}
  ${at(16, 176, 380, `<div class="box" style="display:flex;align-items:center;gap:16px;padding:16px 18px">
    <div class="big" style="font-size:76px">18</div><div><div style="font:600 16px 'Noto Sans'">push-ups in 60 seconds</div><div class="mini">Open 6 more days</div></div></div>`)}
  ${at(16, 300, 380, `<div class="cap"><span>3 took it</span><span style="color:var(--rival)">2 beat you</span></div>
    <div class="box">
      <div class="lr" style="height:64px">${face('iron', 40)}<div class="n">iron_mike <span style="color:var(--rival);font-weight:800">23</span><small>beat you &middot; 1 h ago</small></div><span class="go">Take it back</span></div>
      <div class="lr" style="height:64px">${face('bench', 40)}<div class="n">benchgod <span style="color:var(--rival);font-weight:800">21</span><small>beat you &middot; now</small></div><span class="go">Take it back</span></div>
      <div class="lr" style="height:64px">${face('squat', 40)}<div class="n">squat_queen <span style="color:var(--cream);font-weight:800">14</span><small>you held &middot; 3 h ago</small></div></div>
    </div>`)}
  ${center(560, `<div class="mini" style="padding:0 34px">Take it back: race their set. Beat it and they hear about it.</div>`)}
  ${at(18, 778, 376, `<div class="btn pri" style="height:56px;border-radius:28px">Send to more friends</div>`)}
  ${center(852, `<div style="font:600 16px 'Noto Sans';color:var(--muted)">Also under Profile &rsaquo; Challenges</div>`)}`;

const OPTIONS = {
  a: { t: 'A &middot; زرار Share نفسه بقى تحدّي',
    s: 'مفيش زرار جديد. نفس كارت الماتش اللي بيتشير النهارده، بس تحته <bdi dir="ltr">&laquo;Can you beat 18?&raquo;</bdi> واللينك بيفتح التحدي بدل البروفايل.',
    p: [['دلوقتي', 'شاشة النتيجة المبنية', resultNow()], ['الجديد: Share', 'نفس الزرار، والكارت شايل التحدي', aShare()], ['عند صاحبك', 'اللي بيوصله (واتساب مثلاً)', chat(matchCard(), 18)]] },
  b: { t: 'B &middot; زرار Challenge لوحده (مقترح)',
    s: 'Share بيبقى Challenge بلون الخصم، والكارت اللي بيتبعت كارت تحدّي: رقم واحد كبير وسؤال واحد. الكلمة نفسها بتقول للاعب يعمل إيه.',
    p: [['دلوقتي', 'شاشة النتيجة المبنية', resultNow()], ['الجديد: النتيجة', 'Challenge مكان Share', bResult()], ['عند صاحبك', 'اللي بيوصله (واتساب مثلاً)', chat(challengeCard(18), 18)]] },
  c: { t: 'C &middot; التحدّي من الهوم',
    s: 'كارت تحت Find a match بيبعت أحسن سِت ليك مش آخر ماتش، فتتحدى حد في أي وقت. شاشة النتيجة زي ما هي. (ينفع يتضاف فوق A أو B بعدين.)',
    p: [['دلوقتي', 'الهوم المبني', `<img src="${H}" width="412" style="display:block">`], ['الجديد: الهوم', 'كارت التحدي تحت Find a match', cHome()], ['عند صاحبك', 'اللي بيوصله (واتساب مثلاً)', chat(challengeCard(24), 24)]] },
  flow: { t: 'بعد ما اللينك يتبعت (نفس الحاجة في الأشكال التلاتة)',
    s: 'التحدي ودّي: الريتنج ونقط الأسبوع مبيتغيروش، بس العدّات بتتحسب في هدف اليوم. اللينك مفتوح 7 أيام لأي عدد من الناس (جروب كامل)، وكل واحد ليه محاولة واحدة. الماتش نفسه هو ماتش السِت المتسجلة اللي عندنا: بتشوف عدّاد صاحبك وانت بتلعب.',
    p: [['معندوش التطبيق', 'صفحة على الموقع', web()], ['عنده التطبيق', 'اللينك بيفتح التحدي على طول', inApp()], ['بعد ما يلعب', 'النتيجة، ومين تاني أخده', taker()], ['عندك انت', 'إشعار، وصفحة تحدّيك', sender()]] },
};
function draw(k) {
  const o = OPTIONS[k];
  const col = (t, s, inner) => `<div><div class="lab">${t}<small>${s}</small></div><div class="phone">${inner}</div></div>`;
  document.body.innerHTML = `<div class="sec">${o.t}<small>${o.s}</small></div><div class="row">${o.p.map(([a, b, c]) => col(a, b, c)).join('')}</div>`;
}
