// Rewarded ads: a short video the player chooses to watch, for something that
// never touches the ranked ladder. Three places, each beside the built screen.
// Uses challenge.css. Phones are 412 x 915.
const RW = 'now_result_win.png', TM = 'now_tab_match.png', TP = 'now_tab_profile.png', PP = 'now_pro_parts_1.png';
const slice = (src, from, y, h, w0 = 412) => `<div class="abs" style="left:0;top:${y}px;width:412px;height:${h}px;background:url(${src}) no-repeat;background-size:${w0}px auto;background-position:0 -${from}px"></div>`;
const play = (c) => `<svg width="16" height="16" viewBox="0 0 24 24" fill="${c}"><path d="M7 4.5v15l13-7.5z"/></svg>`;
const goldBtn = (t, h = 48) => `<div class="btn" style="height:${h}px;border-radius:${h / 2}px;background:#2A2214;color:#F2D27A;box-shadow:inset 0 0 0 1.5px #D9A94A;font-weight:700">${play('#F2D27A')}${t}</div>`;
const tag = (t, bg, c) => `<span style="font:800 11px 'Noto Sans';padding:3px 8px;border-radius:7px;background:${bg};color:${c};vertical-align:4px">${t}</span>`;

// ── A: double the XP of the match just played ───────────────────────────────
const xpCard = (after) => `<div class="box" style="padding:16px 18px">
  <div style="display:flex;justify-content:space-between;align-items:baseline"><span style="font:500 17px 'Noto Sans'">Level 12</span><span class="mini" style="font-size:15px">${after ? '598' : '560'} / 650 XP</span></div>
  <div style="height:8px;border-radius:4px;background:#2a2724;margin:12px 0 14px;position:relative;overflow:hidden">
    <div style="position:absolute;left:0;top:0;bottom:0;width:${after ? 92 : 86}%;background:#D9A94A;border-radius:4px"></div></div>
  ${after
    ? `<div style="display:flex;align-items:center;gap:10px"><span style="font:900 30px 'Noto Sans';color:#E8B94A">+76 XP</span>${tag('&times;2 DOUBLED', '#2A2214', '#F2D27A')}</div>
       <div class="mini" style="margin-top:4px">52 XP to Level 13</div>`
    : `<div style="display:flex;align-items:center;gap:12px"><span style="font:900 30px 'Noto Sans';color:#E8B94A;flex:none">+38 XP</span><div style="flex:1">${goldBtn('Double it')}</div></div>
       <div class="mini" style="margin-top:8px">A short video, and no ad after this match.</div>`}
</div>`;
const aNew = (after) => `${slice(RW, 0, 0, 612)}${at(18, 618, 376, xpCard(after))}${slice(RW, 770, 770, 145)}
  ${after ? at(18, 841, 182, '') : ''}`;

// ── B: bring back a streak the rest days could not cover ─────────────────────
const flame = `<svg width="26" height="26" viewBox="0 0 24 24" fill="#E8846B"><path d="M12 2c1 3.5 5 5.8 5 11a5 5 0 0 1-10 0c0-2.4 1.2-3.9 2.3-5 .2 1.6.9 2.8 2 3.4C11 8.6 11.3 5 12 2z"/></svg>`;
const bNew = () => `${slice(TM, 0, 0, 66)}
  ${at(16, 74, 380, `<div class="box" style="padding:16px;box-shadow:inset 0 0 0 1.5px var(--rival)">
    <div style="display:flex;gap:12px;align-items:center">
      <div style="width:46px;height:46px;border-radius:50%;background:#2B1E19;display:flex;align-items:center;justify-content:center;flex:none">${flame}</div>
      <div><div style="font:700 18px 'Noto Sans'">Your 9-day streak ended</div>
      <div class="mini" style="font-size:14px">Bring it back with a short video. Once a week.</div></div></div>
    <div style="margin-top:14px">${goldBtn('Keep my 9 days', 50)}</div>
  </div>`)}
  ${slice(TM, 196, 252, 663)}`;

// ── C: wear one Pro part for a day ───────────────────────────────────────────
const part = (d) => { const s = d / 192; return `<div style="width:${d}px;height:${d}px;border-radius:18px;flex:none;background:url(${PP}) no-repeat;background-size:${824 * s}px auto;background-position:-${12 * s}px -${12 * s}px"></div>`; };
const cNew = () => `<img src="${TP}" width="412" style="display:block"><div class="abs" style="inset:0;background:rgba(0,0,0,.62)"></div>
  <div class="sheet" style="height:520px;text-align:center">
    <div style="width:40px;height:4px;border-radius:2px;background:#5a554e;margin:0 auto 18px"></div>
    <div style="display:flex;justify-content:center">${part(150)}</div>
    <div style="margin-top:14px;font:800 23px 'Noto Sans'">Flame hair ${tag('PRO', '#E8DCC8', '#121110')}</div>
    <div class="mini" style="font-size:15px;margin:8px 18px 0">Pro parts come with Pro. Try this one free for a day: everyone sees it on you until tomorrow.</div>
    <div style="margin-top:20px" class="btn pri">Get Pro</div>
    <div style="margin-top:12px">${goldBtn('Wear it free for a day', 52)}</div>
  </div>`;

const RULES = 'لـ Pro: المكافأة من غير فيديو. اللي يتفرج على فيديو المكافأة مبيشوفش إعلان بين الشاشات بعد الماتش ده. المكافأة عمرها ما تلمس الرانك ولا نقط الأسبوع.';
const RW_OPTIONS = {
  a: { t: 'A &middot; ضاعف الـ XP بعد الماتش (مقترح)',
    s: 'زرار في كارت الـ XP في شاشة النتيجة. ده أكتر مكان بيتشاف (بعد كل ماتش)، فهو اللي هيجيب أكتر فلوس. ' + RULES,
    p: [['دلوقتي', 'شاشة النتيجة المبنية', `<img src="${RW}" width="412" style="display:block">`], ['الجديد', 'زرار Double it في كارت الـ XP', aNew(false)], ['بعد الفيديو', 'الـ XP اتضاعف', aNew(true)]] },
  b: { t: 'B &middot; رجّع الستريك',
    s: 'لما أيام الراحة المسموحة تخلص والستريك يقع، كارت في الهوم يرجّعه بفيديو، مرة في الأسبوع. بيخلي الناس ترجع، بس بيتشاف قليل. ' + RULES,
    p: [['دلوقتي', 'الهوم المبني: الستريك بيقع وخلاص', `<img src="${TM}" width="412" style="display:block">`], ['الجديد', 'كارت يرجّع الستريك', bNew()]] },
  c: { t: 'C &middot; جرّب قطعة Pro يوم',
    s: 'لما تدوس على قطعة Pro مقفولة: يا تشترك Pro، يا تلبسها يوم ببلاش بفيديو، والكل يشوفها عليك. بيبيع Pro كمان، بس بيتشاف أقل من A.',
    p: [['دلوقتي', 'البروفايل المبني', `<img src="${TP}" width="412" style="display:block">`], ['الجديد', 'قطعة Pro مقفولة: جرّبها يوم', cNew()]] },
};
function drawRw(k) {
  const o = RW_OPTIONS[k];
  const col = (t, s, inner) => `<div><div class="lab">${t}<small>${s}</small></div><div class="phone">${inner}</div></div>`;
  document.body.innerHTML = `<div class="sec">${o.t}<small>${o.s}</small></div><div class="row">${o.p.map(([a, b, c]) => col(a, b, c)).join("")}</div>`;
}
