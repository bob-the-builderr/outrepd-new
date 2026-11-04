// Replays the labelled sets and the synthetic cases through counter.js,
// once per variant. Usage: node run.js <recordings dir> ['{"name": {switches}}']
// The synthetic poses are test/support/synthetic_poses.dart, ported.
const fs = require('fs'), path = require('path');
const { count } = require('./counter.js');

const JOINTS = ['nose', 'leftShoulder', 'rightShoulder', 'leftElbow', 'rightElbow', 'leftWrist', 'rightWrist', 'leftHip', 'rightHip', 'leftKnee', 'rightKnee', 'leftAnkle', 'rightAnkle'];
function load(file) {
  const j = JSON.parse(fs.readFileSync(file, 'utf8'));
  const truth = j.trueCount ?? parseInt(String(j.note ?? '').trim(), 10);
  if (!Number.isFinite(truth)) return null;
  const frames = j.frames.map((f) => {
    const p = {};
    for (const [name, v] of Object.entries(f.p)) p[JOINTS.includes(name) ? name : 'nose'] = [v[0], v[1], v[3]];
    return { t: f.t, p };
  });
  return { truth, frames, start: j.start ?? null };
}

// test/support/synthetic_poses.dart
const W = 0.30, FLOOR = 0.72, FRAME = 33;
const at = (x, y) => [x, y, 0.95];
function pushUpPose(up) {
  const height = 0.1 + 0.9 * up, nose = FLOOR - height * W, sh = nose + 0.05, hips = sh - 0.06;
  return {
    nose: at(0.5, nose), leftShoulder: at(0.35, sh), rightShoulder: at(0.65, sh),
    leftElbow: at(0.27, (sh + FLOOR) / 2), rightElbow: at(0.73, (sh + FLOOR) / 2),
    leftWrist: at(0.33, FLOOR), rightWrist: at(0.67, FLOOR),
    leftHip: at(0.44, hips), rightHip: at(0.56, hips),
    leftKnee: at(0.46, hips - 0.03), rightKnee: at(0.54, hips - 0.03),
    leftAnkle: at(0.47, hips - 0.05), rightAnkle: at(0.53, hips - 0.05),
  };
}
const standingPose = () => ({
  nose: at(0.5, 0.1), leftShoulder: at(0.42, 0.2), rightShoulder: at(0.58, 0.2),
  leftElbow: at(0.41, 0.34), rightElbow: at(0.59, 0.34), leftWrist: at(0.4, 0.48), rightWrist: at(0.6, 0.48),
  leftHip: at(0.44, 0.5), rightHip: at(0.56, 0.5), leftKnee: at(0.44, 0.7), rightKnee: at(0.56, 0.7),
  leftAnkle: at(0.44, 0.9), rightAnkle: at(0.56, 0.9),
});
const between = (a, b, t) => {
  const o = {};
  for (const k of Object.keys(a)) if (b[k]) o[k] = [a[k][0] + (b[k][0] - a[k][0]) * t, a[k][1] + (b[k][1] - a[k][1]) * t, 0.95];
  return o;
};
const gettingDown = (n = 25) => Array.from({ length: n }, (_, i) => between(standingPose(), pushUpPose(1), i / (n - 1)));
const repShape = (f, depth = 1) => 1 - depth * (1 - Math.cos(f * 2 * Math.PI)) / 2;
const pushUpSet = (reps, { per = 30, lead = 15, tail = 10 } = {}) => [
  ...Array(lead).fill(0).map(() => pushUpPose(1)),
  ...Array.from({ length: reps * per }, (_, i) => pushUpPose(repShape((i % per) / per))),
  ...Array(tail).fill(0).map(() => pushUpPose(1)),
];
const timed = (poses) => poses.map((p, i) => ({ t: i * FRAME, p }));
const moved = (pose, dy, hands = true) => {
  const o = {};
  for (const [k, v] of Object.entries(pose)) if (hands || (k !== 'leftWrist' && k !== 'rightWrist')) o[k] = [v[0], v[1] + dy, v[2]];
  return o;
};
const swing = (f) => 0.25 * (1 - repShape(f));
const swings = (hands) => timed([
  ...Array(30).fill(0).map(() => pushUpPose(1)),
  ...Array.from({ length: 240 }, (_, i) => moved(pushUpPose(1), swing((i % 30) / 30), hands)),
]);

const synthetic = [
  ['a plain set of six', timed(pushUpSet(6)), 6],
  ['begins already in position', timed(pushUpSet(6, { lead: 0 })), 6],
  ...[0, 5, 10, 15, 20, 30].map((pause) => [`down then pause ${pause}`, timed([...Array(40).fill(0).map(standingPose), ...gettingDown(), ...pushUpSet(5, { lead: pause })]), 5]),
  ['phone swung, no hands', swings(false), 0],
  ['phone swung, whole body', swings(true), 0],
  ['reps before the round', null, 4],
];

// The app, then whatever variants are passed as JSON: '{"name": {switches}}'.
const variants = {
  app: {},
  ...JSON.parse(process.argv[3] || '{}'),
};

const dir = process.argv[2];
const sets = fs.readdirSync(dir).filter((f) => f.endsWith('.json')).sort().map((f) => ({ name: f, ...load(path.join(dir, f)) })).filter((s) => s.truth != null);
for (const [name, opt] of Object.entries(variants)) {
  let exact = 0, within = 0;
  const lines = [];
  for (const s of sets) {
    const r = count(s.frames, s.start, opt);
    const e = r.reps - s.truth;
    if (e === 0) exact++;
    if (Math.abs(e) <= 1) within++;
    if (e !== 0) lines.push(`   ${e > 0 ? '+' : ''}${e} counted ${r.reps}${r.confident ? '' : ' (unsure)'} for ${s.truth}  ${s.name}`);
  }
  const syn = [];
  for (const [label, frames, want] of synthetic) {
    let got;
    if (frames) got = count(frames, null, opt).reps;
    else {
      const f = timed([...pushUpSet(3, { tail: 0 }), ...pushUpSet(4)]);
      got = count(f, f[15 + 90].t, opt).reps;
    }
    if (got !== want) syn.push(`   ${label}: ${got}, want ${want}`);
  }
  console.log(`${name}: ${exact}/${sets.length} exact, ${within}/${sets.length} within 1; synthetic ${synthetic.length - syn.length}/${synthetic.length}`);
  for (const l of [...lines, ...syn]) console.log(l);
}
