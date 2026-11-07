// Ranks among friends on the Friends tab: three directions, 412 x 915.
// The pictures are cut from the built app's own screens; the people and their
// ratings are the app's sample friends (demoFriends), each rated as ratingOf.
const R = 'now_ranks_top.png', F = 'now_friends.png';
const CUT = {
  iron: [R, 130, 342, 166, 112], squat: [R, 130, 492, 166, 112], bench: [R, 130, 644, 166, 104],
  newbie: [R, 135, 1095, 156, 100], me: [R, 148, 1672, 166, 104], delt: [F, 45, 1155, 185, 112, 1.6],
};
const pic = (k, s = 0.5) => {
  const [src, x, y, w, h, b] = CUT[k];
  const w0 = 824 * s;
  return `<div style="width:${190 * s}px;display:flex;justify-content:center;flex:none"><div style="width:${w * s}px;height:${h * s}px;flex:none;background:url(${src}) no-repeat;background-size:${w0}px auto;background-position:-${x * s}px -${y * s}px;mix-blend-mode:lighten;${b ? `filter:brightness(${b}) contrast(1.4);` : ''}"></div></div>`;
};
const PEOPLE = [
  { k: 'iron', n: 'iron_mike', lv: 22, t: 'Diamond III', r: '3,788', you: 1, them: 3 },
  { k: 'squat', n: 'squat_queen', lv: 19, t: 'Platinum V', r: '3,072', you: 2, them: 2 },
  { k: 'delt', n: 'delt_destroyer', lv: 10, t: 'Gold I', r: '2,964', you: 4, them: 0 },
  { k: 'me', n: 'demo_lifter', lv: 12, t: 'Gold III', r: '2,764', mine: true },
  { k: 'bench', n: 'benchgod', lv: 15, t: 'Gold III', r: '2,751', you: 2, them: 1 },
  { k: 'newbie', n: 'newbie_gains', lv: 5, t: 'Bronze II', r: '1,821', never: true },
];
const MEDAL = ['#D9A94A', '#A8A297', '#B8784E'];
const place = (i) => i < 3
  ? `<div class="medal" style="background:${MEDAL[i]}">${i + 1}</div>`
  : `<div class="plain">${i + 1}</div>`;
const score = (p) => p.you === undefined
  ? `<span class="m">Never played you</span>`
  : `<span class="m">You</span> <b class="c">${p.you}</b> <span class="m">&ndash;</span> <b class="o">${p.them}</b> <span class="m">Them</span>`;
const row = (p, i, s = 0.5, h = 75) => `<div class="fr ${p.mine ? 'mine' : ''}" style="height:${h}px">
  ${place(i)}${pic(p.k, s)}
  <div class="who"><div class="nm"><span>${p.n}</span><i class="lv">Lv ${p.lv}</i>${p.mine ? '<i class="yu">YOU</i>' : ''}</div>
  <div class="ln">${p.mine ? `<span class="m">${p.t}</span>` : score(p)}</div></div>
  <div class="rt"><b>${p.r}</b><span>rating</span></div></div>`;
const list = (rows) => `<div class="group">${rows.join('<div class="hair"></div>')}</div>`;

const title = () => `<div class="ttl">Friends</div>
  <svg class="add" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#F4EDE4" stroke-width="2" stroke-linecap="round"><circle cx="9" cy="8" r="4"/><path d="M2 21c0-4 3-6 7-6s7 2 7 6M19 7v6M16 10h6"/></svg>`;
// The Friends tab as built, cut from a given height down, placed at y.
const built = (from, y, h) => `<div style="position:absolute;left:0;top:${y}px;width:412px;height:${h}px;background:url(${F}) no-repeat;background-size:412px auto;background-position:0 -${from}px"></div>`;
const tabBar = () => `<div class="tabs"><span class="g"></span><span class="on">Friends</span><span class="g"></span><span class="g"></span></div>`;
const strip = (on) => `<div class="strip">${['Friends', 'Ranks'].map((x) => `<span class="${x === on ? 'on' : ''}">${x}</span>`).join('')}</div>`;
const label = (a, b = '') => `<div class="sl"><span>${a}</span><span class="r">${b}</span></div>`;

// A: a section above the list, the top few and you; the rest behind See all.
const aPage = () => `${title()}${built(60, 60, 106)}
  <div style="position:absolute;left:12px;right:12px;top:172px">
    ${label('Ranks among friends', 'You&rsquo;re #4 of 6')}
    ${list(PEOPLE.slice(0, 4).map((p, i) => row(p, i, 0.44, 66)))}
    <div class="all">View all <span>&rsaquo;</span></div>
  </div>
  ${built(178, 530, 300)}${tabBar()}`;

// B: Friends and Ranks as two views, the same strip as the Ranks tab.
const bRanks = () => `${title()}${strip('Ranks')}
  <div style="position:absolute;left:12px;right:12px;top:120px">
    ${label('You&rsquo;re #4 of 6', '')}
    ${list(PEOPLE.map((p, i) => row(p, i)))}
  </div>${tabBar()}`;
const bFriends = () => `${title()}${strip('Friends')}${built(60, 116, 720)}${tabBar()}`;

// C: a strip of cards to swipe, opened on you; the list stays under it.
const card = (p, i) => `<div class="pc ${p.mine ? 'mine' : ''}">
  <div class="pl">${place(i)}</div>
  <div style="display:flex;justify-content:center;margin-top:14px">${pic(p.k, 0.5)}</div>
  <div class="pn">${p.n}</div>
  <div class="pr">${p.r}</div>
  <div class="ps">${p.mine ? '<span class="m">You</span>' : p.you === undefined ? '<span class="m">Never played</span>' : score(p)}</div>
</div>`;
const cPage = () => `${title()}${built(60, 60, 106)}
  <div style="position:absolute;left:12px;right:12px;top:172px">${label('Ranks among friends', 'You&rsquo;re #4 of 6')}</div>
  <div class="cards" style="left:-208px">${PEOPLE.map(card).join('')}</div>
  ${built(178, 376, 440)}${tabBar()}`;

const now = () => `<img src="${F}" width="412" style="display:block">${tabBar()}`;
const OPTIONS = {
  a: { t: 'A &middot; جزء فوق الليست', s: 'أول 3 وانت ظاهرين فوق أونلاين، والباقي من View all. لكن Challenge بينزل تحت.', p: [['الشكل الجديد', 'أعلى تاب الفريندس', aPage()]] },
  b: { t: 'B &middot; شريحتين: Friends و Ranks', s: 'نفس شريحة تاب الرانكات. كل صحابك مترتبين في صفحة نضيفة، وليستة الفريندس زي ما هي.', p: [['الشكل الجديد: Ranks', 'كل صحابك مترتبين وانت وسطهم', bRanks()], ['الشكل الجديد: Friends', 'الليستة زي ما هي', bFriends()]] },
  c: { t: 'C &middot; كروت تتسحب', s: 'شريط كروت صغير فوق الليست، بيفتح عند ترتيبك، وتسحبه يمين وشمال للباقي.', p: [['الشكل الجديد', 'الكروت فوق والليستة تحتها', cPage()]] },
};
function draw(k) {
  const o = OPTIONS[k];
  const col = (t, s, inner) => `<div><div class="lab">${t}<small>${s}</small></div><div class="phone">${inner}</div></div>`;
  document.body.innerHTML = `<div class="sec">${o.t}<small>${o.s}</small></div><div class="row">
    ${col('دلوقتي', 'النسخة المبنية', now())}${o.p.map(([a, b, c]) => col(a, b, c)).join('')}</div>`;
}
