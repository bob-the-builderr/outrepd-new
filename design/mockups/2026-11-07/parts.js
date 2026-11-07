// Every colour, feather and ornament below is lib/tier_badge.dart's own.
const fan5 = [[37,-22,50],[45,-12,49],[53,-2,46],[61,8,42],[69,18,36]];
const T = [
 {n:'Iron', base:'#5E5E5B', mid:'#82827D', light:'#9A9A94', wing:'#5E5E5B', glow:0},
 {n:'Bronze', base:'#A8663A', mid:'#C9834E', light:'#E3A272', wing:'#7E4A28', glow:.3, feathers:[[98,54,132,50,118,64]]},
 {n:'Silver', base:'#8894A0', mid:'#AEBAC2', light:'#D8E2E8', wing:'#68747C', glow:.35, feathers:[[98,40,130,32,120,48],[98,54,132,50,118,64]]},
 {n:'Gold', base:'#B8912F', mid:'#E0B145', light:'#F7D87F', wing:'#8A6518', glow:.5, fan:[[43,-15,47],[51,-4,45],[59,7,40]]},
 {n:'Platinum', base:'#8794A0', mid:'#BCC8D0', light:'#EDF4F8', wing:'#6F7C88', glow:.55, fan:[[40,-19,49],[48,-9,47],[56,1,44],[64,11,39]], gem:'#DCE8EF'},
 {n:'Diamond', base:'#2F8F88', mid:'#5FC9C0', light:'#A8EDE7', wing:'#25716C', glow:.65, fan:fan5, chevron:'#CFF7F3', gem:'#A8EDE7', laurel:'#5FC9C0'},
 {n:'Master', base:'#CFC3B0', mid:'#F0E9DC', light:'#FFFFFF', wing:'#E8846B', glow:.75, fan:fan5, chevron:'#E8846B', laurel:'#E8846B', crown:true, dy:2},
];
let uid = 0;
const pts = (a) => a.map(([x,y]) => `${x.toFixed(1)},${y.toFixed(1)}`).join(' ');
function blade(y, deg, L) {
  const a = deg * Math.PI / 180, c = Math.cos(a), s = Math.sin(a);
  return [[98, y-8], [94+L*c, y+L*s], [94+L*.7*c - s*9, y+L*.7*s + c*9], [98, y+8]];
}
function wingShapes(t) {
  if (t.fan) return t.fan.map(([y,d,L]) => blade(y + (t.dy||0), d, L));
  return (t.feathers||[]).map(([,y1,x2,y2,x3,y3]) => [[98,y1-1],[x2,y2],[x3,y3],[98,y3+1]]);
}
function leaves(t, dy) {
  const master = !!t.crown, out = [];
  for (const side of [-1, 1]) for (let k = 0; k < 5; k++) {
    const u = (master ? .1 : .12) + k*.17;
    const at = [70 + side*((master?25:24)*u + 2), 104.5 + dy*2 - (master?9.5:9)*u*u - 4*u];
    const deg = (side > 0 ? -25 : 205) + (k % 2 ? 1 : -1)*38*side - side*k*9;
    const a = deg*Math.PI/180, c = Math.cos(a), s = Math.sin(a);
    const len = (master?15:13) - k*.8, w = master ? 4.8 : 4.2;
    const p = (x, y) => [at[0] + x*c - y*s, at[1] + x*s + y*c];
    const up = p(len/2, -w), lo = p(len/2, w), pt = p(len, 0);
    out.push(`M${at[0].toFixed(1)} ${at[1].toFixed(1)} Q${up[0].toFixed(1)} ${up[1].toFixed(1)} ${pt[0].toFixed(1)} ${pt[1].toFixed(1)} Q${lo[0].toFixed(1)} ${lo[1].toFixed(1)} ${at[0].toFixed(1)} ${at[1].toFixed(1)}Z`);
  }
  return out;
}
// The tier's badge, as the app draws it.
function crest(ti, size) {
  const t = T[ti], dy = t.dy||0, id = 'c' + (uid++);
  const ws = wingShapes(t);
  const wing = (shape, mirror) => `<polygon points="${pts(mirror ? shape.map(([x,y]) => [140-x,y]) : shape)}" fill="url(#${id}${mirror?'l':'r'})"/>`;
  const by = 22 + dy;
  return `<svg width="${size}" height="${size*120/140}" viewBox="0 0 140 120" style="overflow:visible">
   <defs><linearGradient id="${id}r" x1="98" x2="138" y1="0" y2="0" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="${t.wing}"/><stop offset="1" stop-color="${t.light}"/></linearGradient>
   <linearGradient id="${id}l" x1="42" x2="2" y1="0" y2="0" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="${t.wing}"/><stop offset="1" stop-color="${t.light}"/></linearGradient>
   <filter id="${id}g" x="-30%" y="-30%" width="160%" height="160%"><feDropShadow dx="0" dy="0" stdDeviation="4" flood-color="${t.mid}" flood-opacity="${t.glow}"/></filter></defs>
   <g filter="url(#${id}g)">
   ${ws.map(s => wing(s,false) + wing(s,true)).join('')}
   ${t.laurel ? `<path d="M${46-dy} ${96+dy} Q70 ${113+dy*2} ${94+dy} ${96+dy}" stroke="${t.laurel}" stroke-width="1.6" fill="none"/>${leaves(t,dy).map(d=>`<path d="${d}" fill="${t.laurel}"/>`).join('')}` : ''}
   <path d="M70 ${22+dy} L98 ${34+dy} L98 ${62+dy} C98 ${86+dy} 70 ${102+dy} 70 ${102+dy} C70 ${102+dy} 42 ${86+dy} 42 ${62+dy} L42 ${34+dy}Z" fill="${t.base}" stroke="#00000070" stroke-width="2"/>
   <path d="M70 ${22+dy} L98 ${34+dy} L70 ${48+dy}Z" fill="${t.mid}"/>
   <path d="M42 ${34+dy} L70 ${22+dy} L70 ${48+dy}Z" fill="${t.light}"/>
   <path d="M56 ${74+dy} L70 ${64+dy} L84 ${74+dy} L84 ${80+dy} L70 ${70+dy} L56 ${80+dy}Z" fill="${t.chevron||t.light}"/>
   ${t.gem ? `<path d="M70 5 L76.5 14.5 L70 24 L63.5 14.5Z" fill="${t.gem}" stroke="#00000055"/><path d="M70 5 L70 14.5 L63.5 14.5Z" fill="#fff" opacity=".6"/>` : ''}
   ${t.crown ? `<path d="M52 ${by-1} L52 ${by-5} L57 ${by-19} L63 ${by-6} L70 ${by-23} L77 ${by-6} L83 ${by-19} L88 ${by-5} L88 ${by-1} Q70 ${by+2} 52 ${by-1}Z" fill="${t.wing}"/>` : ''}
   </g></svg>`;
}

// The rank card, wearing its tier: the metal round its edge, the badge's
// own feathers growing out of its sides, and from Platinum up the gem, from
// Diamond the laurel, on Master the crown. `shape` A is the card as it is;
// B gives it the shield's outline — a low peak on top, a point below.
function card(ti, shape, cw, data) {
  const t = T[ti], id = 'k' + (uid++), dy = t.dy||0;
  const ins = 32, ch = 80, y0 = 14, x0 = ins, x1 = cw - ins, w = x1 - x0, cx = cw/2, r = 16;
  const H = y0 + ch + (shape === 'A' ? 24 : 32);
  const yb = y0 + ch;
  let path;
  if (shape === 'A') {
    path = `M${x0} ${y0+r} Q${x0} ${y0} ${x0+r} ${y0} L${x1-r} ${y0} Q${x1} ${y0} ${x1} ${y0+r} L${x1} ${yb-r} Q${x1} ${yb} ${x1-r} ${yb} L${x0+r} ${yb} Q${x0} ${yb} ${x0} ${yb-r}Z`;
  } else {
    const top = y0 + 7, bot = yb - 8;
    path = `M${x0} ${top+r} Q${x0} ${top} ${x0+r} ${top-1} L${cx-12} ${y0+1.2} Q${cx} ${y0-1.5} ${cx+12} ${y0+1.2} L${x1-r} ${top-1} Q${x1} ${top} ${x1} ${top+r} L${x1} ${bot-r} Q${x1} ${bot} ${x1-r} ${bot+1.6} L${cx+14} ${bot+13} Q${cx} ${bot+17} ${cx-14} ${bot+13} L${x0+r} ${bot+1.6} Q${x0} ${bot} ${x0} ${bot-r}Z`;
  }
  const sw = [1, 1.2, 1.4, 1.7, 1.9, 2.1, 2.4][ti];
  // Feathers rooted on the card's straight sides, the badge's shapes scaled.
  const s = .8, rootY = shape === 'A' ? y0 + ch/2 : y0 + ch*.44;
  const toR = ([x,y]) => [x1 - 1 + (x-98)*s, rootY + (y-52-dy)*s];
  const toL = ([x,y]) => [x0 + 1 - (x-98)*s, rootY + (y-52-dy)*s];
  const ws = wingShapes(t);
  // Laurel hung from the bottom edge's middle, the crown and gem on the top's.
  const lt = `translate(${cx-70*1.25} ${(shape==='A'?yb+9:yb+17)-101*1.25}) scale(1.25)`;
  const gemY = shape === 'A' ? y0 : y0 - 1;
  const by = gemY + 3;
  const frame = `<svg class="frame" width="${cw}" height="${H}">
   <defs>
    <linearGradient id="${id}b" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${t.light}"/><stop offset=".45" stop-color="${t.mid}"/><stop offset="1" stop-color="${t.base}"/></linearGradient>
    <linearGradient id="${id}f" x1="0" x2="1"><stop offset="0" stop-color="${t.mid}" stop-opacity="${.07 + ti*.012}"/><stop offset=".6" stop-color="${t.mid}" stop-opacity="0"/></linearGradient>
    <linearGradient id="${id}wr" x1="${x1}" x2="${x1+30}" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="${t.wing}"/><stop offset="1" stop-color="${t.light}"/></linearGradient>
    <linearGradient id="${id}wl" x1="${x0}" x2="${x0-30}" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="${t.wing}"/><stop offset="1" stop-color="${t.light}"/></linearGradient>
    <filter id="${id}g" x="-20%" y="-60%" width="140%" height="220%"><feDropShadow dx="0" dy="0" stdDeviation="${4 + ti}" flood-color="${t.mid}" flood-opacity="${t.glow*.6}"/></filter>
   </defs>
   <g class="${ti >= 3 ? 'glowing' : ''}" filter="url(#${id}g)">
    ${ws.map(sh => `<polygon points="${pts(sh.map(toR))}" fill="url(#${id}wr)"/><polygon points="${pts(sh.map(toL))}" fill="url(#${id}wl)"/>`).join('')}
    <path d="${path}" fill="#1A1918"/>
   </g>
   <path d="${path}" fill="url(#${id}f)"/>
   <path d="${path}" fill="none" stroke="url(#${id}b)" stroke-width="${sw}"/>
   ${ti >= 2 ? `<path d="${path}" fill="none" stroke="${t.light}" stroke-opacity="${ti>=4?.28:.16}" stroke-width=".8" transform="translate(${cx} ${H/2}) scale(${(w-8)/w} ${(ch-8)/ch}) translate(${-cx} ${-H/2})"/>` : ''}
   ${t.laurel ? `<g transform="${lt}"><path d="M46 96 Q70 113 94 96" stroke="${t.laurel}" stroke-width="1.4" fill="none"/>${leaves(t,0).map(d=>`<path d="${d}" fill="${t.laurel}"/>`).join('')}</g>` : ''}
   ${t.gem && !t.crown ? `<g transform="translate(${cx} ${gemY})"><path d="M0 -9 L6.5 0 L0 9 L-6.5 0Z" fill="${t.gem}" stroke="#00000066"/><path d="M0 -9 L0 0 L-6.5 0Z" fill="#fff" opacity=".6"/></g>` : ''}
   ${t.crown ? `<g transform="translate(${cx-70*.9} ${by - 22*.9}) scale(.9)"><path d="M52 21 L52 17 L57 3 L63 16 L70 -1 L77 16 L83 3 L88 17 L88 21 Q70 24 52 21Z" fill="${t.wing}" stroke="#00000055"/></g>` : ''}
  </svg>`;
  const topPad = shape === 'A' ? y0 : y0 + 7;
  const inner = `<div class="in" style="left:${x0+6}px;right:${ins+12}px;top:${topPad}px;height:${shape==='A'?ch:ch-15}px">
    <div style="position:relative;width:60px;height:52px;flex:none">
      <div class="breath" style="position:absolute;left:-2px;top:-6px;width:64px;height:64px;border-radius:50%;background:radial-gradient(closest-side,${t.mid}66,transparent)"></div>
      <div style="position:absolute;left:0;top:0">${crest(ti, 60)}</div></div>
    <div style="flex:1;margin-left:6px;min-width:0">
      <div class="tag" style="color:${t.light}">${t.n.toUpperCase()} III</div>
      <div class="rate">${(1000 + 500*ti + 264).toLocaleString('en')} <span>&nbsp;·&nbsp; 36 to ${t.n} II</span></div>
      <div class="bar"><i style="width:64%;background:${ti===6?t.wing:t.mid}"></i></div></div>
    <div style="color:var(--muted);font-size:20px;margin-left:8px">›</div></div>`;
  return `<div class="rc" style="width:${cw}px;height:${H}px">${frame}${inner}</div>`;
}

function framed(ti, cw, ch, inner) {
  const t = T[ti], id = 'f' + (uid++);
  const side = 30, top = 14, bottom = 20, x0 = side, x1 = cw - side, y0 = top, yb = top + ch, cx = cw/2, r = 16, H = top + ch + bottom;
  const path = `M${x0} ${y0+r} Q${x0} ${y0} ${x0+r} ${y0} L${x1-r} ${y0} Q${x1} ${y0} ${x1} ${y0+r} L${x1} ${yb-r} Q${x1} ${yb} ${x1-r} ${yb} L${x0+r} ${yb} Q${x0} ${yb} ${x0} ${yb-r}Z`;
  const s = .8, rootY = y0 + ch/2;
  const toR = ([x,y]) => [x1 - 1 + (x-98)*s, rootY + (y-53)*s];
  const toL = ([x,y]) => [x0 + 1 - (x-98)*s, rootY + (y-53)*s];
  const lt = `translate(${cx-70*1.2} ${yb+14-101*1.2}) scale(1.2)`;
  const sw = [1,1.2,1.4,1.7,1.9,2.1,2.4][ti];
  return `<div class="rc" style="width:${cw}px;height:${H}px"><svg class="frame" width="${cw}" height="${H}">
   <defs><linearGradient id="${id}b" x1="0" y1="0" x2="1" y2="1"><stop offset="0" stop-color="${t.light}"/><stop offset=".45" stop-color="${t.mid}"/><stop offset="1" stop-color="${t.base}"/></linearGradient>
   <linearGradient id="${id}f" x1="0" x2="1"><stop offset="0" stop-color="${t.mid}" stop-opacity="${.07+ti*.012}"/><stop offset=".6" stop-color="${t.mid}" stop-opacity="0"/></linearGradient>
   <linearGradient id="${id}wr" x1="${x1}" x2="${x1+34}" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="${t.wing}"/><stop offset="1" stop-color="${t.light}"/></linearGradient>
   <linearGradient id="${id}wl" x1="${x0}" x2="${x0-34}" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="${t.wing}"/><stop offset="1" stop-color="${t.light}"/></linearGradient>
   <filter id="${id}g" x="-20%" y="-60%" width="140%" height="220%"><feDropShadow dx="0" dy="0" stdDeviation="${5+ti}" flood-color="${t.mid}" flood-opacity="${[0,.22,.28,.42,.5,.6,.7][ti]}"/></filter></defs>
   <g class="${ti>=3?'glowing':''}" filter="url(#${id}g)">${wingShapes(t).map(sh=>`<polygon points="${pts(sh.map(toR))}" fill="url(#${id}wr)"/><polygon points="${pts(sh.map(toL))}" fill="url(#${id}wl)"/>`).join('')}<path d="${path}" fill="#1A1918"/></g>
   <path d="${path}" fill="url(#${id}f)"/><path d="${path}" fill="none" stroke="url(#${id}b)" stroke-width="${sw}"/>
   ${ti>=2?`<rect x="${x0+4}" y="${y0+4}" width="${x1-x0-8}" height="${ch-8}" rx="${r-4}" fill="none" stroke="${t.light}" stroke-opacity="${ti>=4?.28:.16}" stroke-width=".8"/>`:''}
   ${t.laurel?`<g transform="${lt}"><path d="M46 96 Q70 113 94 96" stroke="${t.laurel}" stroke-width="1.4" fill="none"/>${leaves(t,0).map(d=>`<path d="${d}" fill="${t.laurel}"/>`).join('')}</g>`:''}
   ${t.gem&&!t.crown?`<g transform="translate(${cx} ${y0})"><path d="M0 -9 L7 0 L0 9 L-7 0Z" fill="${t.gem}" stroke="#121110"/><path d="M0 -9 L0 0 L-7 0Z" fill="#fff" opacity=".85"/></g>`:''}
  </svg><div class="in" style="left:${x0}px;right:${side}px;top:${y0}px;height:${ch}px">${inner}</div></div>`;
}
