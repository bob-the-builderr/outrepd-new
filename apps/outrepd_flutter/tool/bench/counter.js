// A line-for-line port of lib/reps/pushup_counter.dart (PushupTracker and
// countPushups), for a machine with no Flutter: change the Dart, change this
// the same way, and `node run.js ../../test/recordings` replays the labelled
// sets and the synthetic cases in seconds. Poses are {joint: [x, y, conf]}.
//
// The defaults are what the app does. The switches are variants that were
// weighed (2026-11-04) and are kept so they can be compared again:
//   noHandsAway  a frame with no hand seen counts as a hand away
//   stale        'any' | 'none' | seconds the last floor point stands in
//   perRep       {away, seen, bottom}: shares a rep's frames must meet
//   plantReset   a new floor point restarts the rep's tallies
//   armReset     arming restarts them
//   clearStray   a hand back on its point drops its off-point readings
//   trace        an array that receives each top crossing's tallies
const C = {
  bottom: 0.5, top: 0.75, smooth: 0.05, headMedian: 0.12, minRep: 0.35,
  widthSec: 3, widthPct: 80, lockKeep: 5, lockSeeds: 2, lockPrior: 1,
  bandLow: 0.6, bandHigh: 1.8, borderline: 0.05, nearMiss: 0.05,
  stoodSec: 0.5, stoodShare: 0.6, near: 0.35, floorPointSec: 1.5,
  unseenSec: 1, floorFreshSec: 1, replantSec: 0.8, replantSettle: 0.12,
  handsWin: 0.4, awayShare: 0.35, uprightTorso: 0.6, flatTorso: 0.5,
};

const median = (v) => {
  const s = [...v].sort((a, b) => a - b), n = s.length;
  if (!n) return NaN;
  return n % 2 ? s[(n - 1) / 2] : (s[n / 2 - 1] + s[n / 2]) / 2;
};
const percentile = (v, q) => {
  const s = [...v].sort((a, b) => a - b);
  if (s.length === 1) return s[0];
  const pos = (s.length - 1) * q / 100, lo = Math.floor(pos), hi = Math.ceil(pos);
  return s[lo] + (s[hi] - s[lo]) * (pos - lo);
};
const dist = (x, y, p) => Math.hypot(x - p[0], y - p[1]);
const conf = (pose, j, min = 0.7) => {
  const p = pose[j];
  return p && p[2] >= min ? p : null;
};
const width = (pose) => {
  const l = conf(pose, 'leftShoulder'), r = conf(pose, 'rightShoulder');
  if (!l || !r) return null;
  const w = Math.hypot(l[0] - r[0], l[1] - r[1]);
  return w < 0.02 ? null : w;
};
const mid = (pose, a, b) => {
  const pa = conf(pose, a), pb = conf(pose, b);
  if (pa && pb) return [(pa[0] + pb[0]) / 2, (pa[1] + pb[1]) / 2];
  const one = pa || pb;
  return one ? [one[0], one[1]] : null;
};
const bodyIsDown = (pose) => {
  const s = mid(pose, 'leftShoulder', 'rightShoulder'), h = mid(pose, 'leftHip', 'rightHip');
  const w = width(pose);
  if (!s || !h || w == null) return false;
  const dx = h[0] - s[0], dy = h[1] - s[1], torso = Math.hypot(dx, dy);
  if (torso < 0.01) return false;
  if (torso / w <= C.uprightTorso) return true;
  return Math.abs(dy) / torso <= C.flatTorso;
};
const isStoodUp = (pose) => {
  const s = mid(pose, 'leftShoulder', 'rightShoulder'), h = mid(pose, 'leftHip', 'rightHip');
  if (!s || !h || width(pose) == null) return null;
  if (Math.hypot(h[0] - s[0], h[1] - s[1]) < 0.01) return null;
  return !bodyIsDown(pose);
};

class Hands {
  constructor(opt) {
    this.opt = opt;
    this.points = { L: null, R: null };
    this.history = { L: [], R: [] };
    this.stray = { L: [], R: [] };
    this.lastSeen = { L: null, R: null };
    this.lastOnPoint = { L: null, R: null };
    this.away = [];
    this.now = 0;
    this.frameAway = false;
    this.frameOn = false;
    this.plants = 0;
  }
  add(t, left, right, w) {
    this.now = t;
    const near = C.near * w;
    let anyAway = false, anyOn = false;
    for (const [h, p] of [['L', left], ['R', right]]) {
      if (!p) continue;
      const o = h === 'L' ? 'R' : 'L';
      const own = this.points[h], theirs = this.points[o];
      const dOwn = own ? dist(p[0], p[1], own) : Infinity;
      const dTheirs = theirs ? dist(p[0], p[1], theirs) : Infinity;
      const seen = this.lastSeen[h];
      const unseen = seen == null || t - seen > C.unseenSec * 1000;
      if (dOwn <= near) {
        this.history[h].push([t, p[0], p[1]]);
        this.lastOnPoint[h] = t;
        anyOn = true;
        if (this.opt.clearStray) this.stray[h].length = 0;
      } else if (dTheirs <= near) {
        anyOn = true;
      } else if (!own || unseen) {
        this.plant(h, t, p[0], p[1]);
        anyOn = true;
      } else {
        anyAway = true;
        this.stray[h].push([t, p[0], p[1]]);
      }
      this.lastSeen[h] = t;
    }
    for (const h of ['L', 'R']) {
      const hist = this.history[h];
      while (hist.length && t - hist[0][0] > C.floorPointSec * 1000) hist.shift();
      if (hist.length) this.points[h] = [median(hist.map((s) => s[1])), median(hist.map((s) => s[2]))];
      const st = this.stray[h];
      while (st.length && t - st[0][0] > C.replantSec * 1000) st.shift();
      if (st.length >= 5 && t - st[0][0] >= C.replantSec * 800) {
        const mx = median(st.map((s) => s[1])), my = median(st.map((s) => s[2]));
        const spread = percentile(st.map((s) => dist(s[1], s[2], [mx, my])), 80);
        if (spread <= C.replantSettle * w) {
          this.points[h] = [mx, my];
          this.history[h] = st.slice();
          this.lastOnPoint[h] = t;
          st.length = 0;
          this.plants++;
        }
      }
    }
    this.away.push([t, anyAway || (this.opt.noHandsAway && !left && !right)]);
    while (this.away.length && t - this.away[0][0] > C.handsWin * 1000) this.away.shift();
    this.frameAway = anyAway;
    this.frameOn = anyOn;
  }
  plant(h, t, x, y) {
    this.points[h] = [x, y];
    this.history[h] = [[t, x, y]];
    this.lastOnPoint[h] = t;
    this.stray[h].length = 0;
    this.plants++;
  }
  get planted() {
    if ((!this.points.L && !this.points.R) || !this.away.length) return false;
    return this.away.filter((a) => a[1]).length / this.away.length <= C.awayShare;
  }
  get floorY() {
    const fresh = [];
    for (const h of ['L', 'R']) {
      if (this.points[h] && this.lastOnPoint[h] != null && this.now - this.lastOnPoint[h] <= C.floorFreshSec * 1000) fresh.push(this.points[h][1]);
    }
    if (fresh.length) return fresh.reduce((a, b) => a + b) / fresh.length;
    if (this.opt.stale === 'none') return null;
    let latest = null;
    for (const h of ['L', 'R']) {
      if (!this.points[h]) continue;
      if (latest == null || (this.lastOnPoint[h] ?? -1) > (this.lastOnPoint[latest] ?? -1)) latest = h;
    }
    if (latest == null) return null;
    if (typeof this.opt.stale === 'number') {
      const on = this.lastOnPoint[latest];
      if (on == null || this.now - on > this.opt.stale * 1000) return null;
    }
    return this.points[latest][1];
  }
}

class Tracker {
  constructor(opt = {}) {
    this.opt = { noHandsAway: false, stale: 2.5, perRep: { away: 1, seen: 0.1 }, clearStray: true, ...opt };
    this.hands = new Hands(this.opt);
    this.heads = []; this.widths = []; this.stances = [];
    this.tops = Array(C.lockSeeds).fill(C.lockPrior);
    this.smooth = null; this.lastAt = null; this.phase = 'idle';
    this.excursionTop = null; this.dipLow = null; this.lastRepAt = null;
    this.reps = 0; this.repTimes = []; this.repBottoms = []; this.refusedAt = []; this.nearMissAt = [];
    this.origin = 0; this.planted = false;
    this.repFrames = 0; this.repAway = 0; this.repSeen = 0; this.botFrames = 0; this.botAway = 0;
  }
  get lockout() { return median(this.tops); }
  get standing() {
    if (this.stances.length < 3) return false;
    return this.stances.filter((s) => s[1]).length >= this.stances.length * C.stoodShare;
  }
  inside(times) {
    if (!this.repTimes.length) return 0;
    const f = this.repTimes[0], l = this.repTimes[this.repTimes.length - 1];
    return times.filter((t) => t > f && t < l).length;
  }
  get confident() {
    const borderline = this.repBottoms.filter((b) => b > C.bottom - C.borderline).length;
    return this.reps > 0 && this.inside(this.refusedAt) === 0 && this.inside(this.nearMissAt) === 0 && borderline === 0;
  }
  restart(t) {
    this.reps = 0; this.repTimes = []; this.repBottoms = []; this.refusedAt = []; this.nearMissAt = [];
    this.lastRepAt = null; this.origin = t;
    if (this.phase === 'down') this.phase = 'idle';
  }
  add(t, pose) {
    const stance = isStoodUp(pose);
    if (stance != null) this.stances.push([t, stance]);
    while (this.stances.length && t - this.stances[0][0] > C.stoodSec * 1000) this.stances.shift();
    const head = conf(pose, 'nose');
    if (head) this.heads.push([t, head[1]]);
    const w = width(pose);
    if (w != null) this.widths.push([t, w]);
    while (this.heads.length && t - this.heads[0][0] > C.headMedian * 1000) this.heads.shift();
    while (this.widths.length && t - this.widths[0][0] > C.widthSec * 1000) this.widths.shift();
    if (!this.widths.length) return;
    const scale = percentile(this.widths.map((x) => x[1]), C.widthPct);
    this.hands.add(t, conf(pose, 'leftWrist'), conf(pose, 'rightWrist'), scale);
    this.planted = this.hands.planted;
    if (this.opt.plantReset && this.hands.plants !== this.seenPlants) {
      this.seenPlants = this.hands.plants;
      this.repFrames = 0; this.repAway = 0; this.repSeen = 0; this.botFrames = 0; this.botAway = 0;
    }
    this.repFrames++;
    if (this.hands.frameAway) this.repAway++;
    if (this.hands.frameOn) this.repSeen++;
    const floor = this.hands.floorY;
    if (floor == null || !this.heads.length) return;
    const raw = (floor - median(this.heads.map((x) => x[1]))) / scale;
    if (this.smooth == null || this.lastAt == null) this.smooth = raw;
    else {
      const a = 1 - Math.exp(-((t - this.lastAt) / 1000) / C.smooth);
      this.smooth += (raw - this.smooth) * a;
    }
    this.lastAt = t;
    const h = this.smooth, share = h / this.lockout;
    if (share <= C.bottom) { this.botFrames = (this.botFrames || 0) + 1; if (this.hands.frameAway) this.botAway = (this.botAway || 0) + 1; }
    this.dipLow = this.dipLow == null ? share : Math.min(this.dipLow, share);
    if (this.phase === 'idle' || this.phase === 'up') {
      this.excursionTop = this.excursionTop == null ? h : Math.max(this.excursionTop, h);
      if (share >= C.top) {
        this.repFrames = 0; this.repAway = 0; this.repSeen = 0; this.botFrames = 0; this.botAway = 0;
      }
      if (this.phase === 'up' && share >= C.top) {
        const dip = this.dipLow;
        if (dip > C.bottom && dip <= C.bottom + C.nearMiss) this.nearMissAt.push(t - this.origin);
        this.dipLow = share;
      }
      const top = this.excursionTop;
      const seenTop = share >= C.top || (share > C.bottom && top != null && top / this.lockout >= C.top);
      if (this.phase === 'idle' && seenTop && this.planted && !this.standing) {
        this.phase = 'up';
        this.dipLow = share;
        if (this.opt.armReset) { this.repFrames = 0; this.repAway = 0; this.repSeen = 0; this.botFrames = 0; this.botAway = 0; }
      }
      if (share <= C.bottom) {
        const top2 = this.excursionTop, ref = this.lockout;
        if (top2 != null && top2 >= C.bandLow * ref && top2 <= C.bandHigh * ref) {
          this.tops.push(top2);
          while (this.tops.length > C.lockKeep) this.tops.shift();
        }
        this.excursionTop = null;
        if (this.phase === 'up') this.phase = 'down';
      }
    } else if (share >= C.top) {
      const quick = this.lastRepAt == null || t - this.lastRepAt >= C.minRep * 1000;
      const stoodUp = this.standing;
      const pr = this.opt.perRep;
      const bot = pr && pr.bottom != null ? (this.botAway || 0) <= pr.bottom * (this.botFrames || 0) : true;
      const held = !pr || this.repFrames === 0 ||
        (this.repAway <= pr.away * this.repFrames && this.repSeen >= pr.seen * this.repFrames && bot);
      if (this.opt.trace) this.opt.trace.push({ t, frames: this.repFrames, away: this.repAway, seen: this.repSeen, planted: this.planted, held, botFrames: this.botFrames || 0, botAway: this.botAway || 0 });
      if (this.planted && held && quick && !stoodUp) {
        this.reps++;
        this.repTimes.push(t - this.origin);
        this.repBottoms.push(this.dipLow);
        this.lastRepAt = t;
      } else if (!this.planted || !held || stoodUp) {
        this.refusedAt.push(t - this.origin);
      }
      this.phase = this.planted && held && !stoodUp ? 'up' : 'idle';
      this.excursionTop = h;
      this.dipLow = share;
      this.repFrames = 0; this.repAway = 0; this.repSeen = 0; this.botFrames = 0; this.botAway = 0;
    }
  }
}

function count(frames, startMs, opt) {
  const tr = new Tracker(opt);
  let started = startMs == null;
  for (const f of frames) {
    if (!started && f.t >= startMs) { tr.restart(startMs); started = true; }
    tr.add(f.t, f.p);
  }
  if (!started) tr.restart(startMs);
  return { reps: tr.reps, confident: tr.confident, tracker: tr };
}

module.exports = { C, count, Tracker };
