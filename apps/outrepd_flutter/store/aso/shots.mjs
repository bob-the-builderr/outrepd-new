// Puts the store screenshots in store/screenshots/<display type>/ on App Store
// Connect, on a version's en-US localization — the one every other locale
// shows where it has none of its own — in file-name order, replacing what
// that set held, then waits for Apple to process each and reads them back:
// a 2xx is not verification (vibe-aso, law 5). Run on the Linux CI with the
// key the iOS build signs with, like push.mjs (the user's yes, 2026-11-04).
//
//   node store/aso/shots.mjs <path to .p8> check <version>   what en-US holds now
//   node store/aso/shots.mjs <path to .p8> push <version>    replace it, then verify

import { createHash, createPrivateKey, createSign } from 'node:crypto';
import { readdirSync, readFileSync, statSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const bundleId = 'com.outrepd.outrepd';
const [keyPath, mode = 'check', versionString] = process.argv.slice(2);
const keyId = process.env.ASC_KEY_ID;
const issuer = process.env.ASC_ISSUER_ID;
if (!keyPath || !keyId || !issuer) {
  console.log('no App Store Connect key; nothing done');
  process.exit(1);
}
if (!versionString) {
  console.log('shots needs the version, like 1.1.6');
  process.exit(1);
}

const root = join(dirname(fileURLToPath(import.meta.url)), '..', 'screenshots');
const types = readdirSync(root).filter((d) => statSync(join(root, d)).isDirectory()).sort();

function token() {
  const part = (value) => Buffer.from(JSON.stringify(value)).toString('base64url');
  const now = Math.floor(Date.now() / 1000);
  const head = part({ alg: 'ES256', kid: keyId, typ: 'JWT' });
  const body = part({ iss: issuer, iat: now, exp: now + 1100, aud: 'appstoreconnect-v1' });
  const signer = createSign('SHA256');
  signer.update(`${head}.${body}`);
  const signature = signer
    .sign({ key: createPrivateKey(readFileSync(keyPath, 'utf8')), dsaEncoding: 'ieee-p1363' })
    .toString('base64url');
  return `${head}.${body}.${signature}`;
}
let auth = token();
let authAt = Date.now();

const api = 'https://api.appstoreconnect.apple.com/v1';
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

async function call(method, path, body) {
  if (Date.now() - authAt > 15 * 60 * 1000) {
    auth = token();
    authAt = Date.now();
  }
  for (let attempt = 0; attempt < 4; attempt++) {
    const res = await fetch(path.startsWith('http') ? path : api + path, {
      method,
      headers: { Authorization: `Bearer ${auth}`, 'Content-Type': 'application/json' },
      body: body ? JSON.stringify(body) : undefined,
    });
    if (res.status === 429) {
      await sleep(5000 * (attempt + 1));
      continue;
    }
    const text = await res.text();
    const json = text ? JSON.parse(text) : {};
    if (!res.ok) {
      const why = (json.errors || []).map((e) => `${e.title}: ${e.detail}`).join(' | ');
      throw new Error(`${method} ${path} -> ${res.status} ${why}`);
    }
    return json;
  }
  throw new Error(`${method} ${path}: rate limited`);
}

async function all(path) {
  const out = [];
  let next = path;
  while (next) {
    const page = await call('GET', next);
    out.push(...page.data);
    next = page.links?.next ?? null;
  }
  return out;
}

const describe = (shot) => {
  const a = shot.attributes;
  const size = a.imageAsset ? `${a.imageAsset.width}x${a.imageAsset.height}` : '?';
  const state = a.assetDeliveryState?.state ?? '?';
  const errors = (a.assetDeliveryState?.errors ?? []).map((e) => e.description || e.code).join('; ');
  return `${a.fileName}  ${size}  ${state}${errors ? `  (${errors})` : ''}`;
};

const app = (await call('GET', `/apps?filter[bundleId]=${bundleId}`)).data[0];
if (!app) {
  console.log(`no app ${bundleId}`);
  process.exit(1);
}
const version = (await all(`/apps/${app.id}/appStoreVersions?limit=10`)).find(
  (v) => v.attributes.versionString === versionString,
);
if (!version) {
  console.log(`no version ${versionString}`);
  process.exit(1);
}
console.log(`version ${versionString}  ${version.attributes.appStoreState}`);
const en = (await all(`/appStoreVersions/${version.id}/appStoreVersionLocalizations?limit=200`)).find(
  (l) => l.attributes.locale === 'en-US',
);
if (!en) {
  console.log('no en-US localization');
  process.exit(1);
}

const setsOf = () => all(`/appStoreVersionLocalizations/${en.id}/appScreenshotSets`);
for (const set of await setsOf()) {
  const shots = await all(`/appScreenshotSets/${set.id}/appScreenshots`);
  console.log(`en-US ${set.attributes.screenshotDisplayType}: ${shots.length} now`);
  for (const s of shots) console.log(`  ${describe(s)}`);
}
if (mode !== 'push') process.exit(0);

const editable = ['PREPARE_FOR_SUBMISSION', 'DEVELOPER_REJECTED', 'REJECTED', 'METADATA_REJECTED'];
if (!editable.includes(version.attributes.appStoreState)) {
  console.log(`version ${versionString} is ${version.attributes.appStoreState}: not editable`);
  process.exit(1);
}

let failed = false;
for (const type of types) {
  const files = readdirSync(join(root, type)).filter((f) => f.endsWith('.png')).sort();
  console.log(`\n${type}: ${files.length} to upload`);
  let set = (await setsOf()).find((s) => s.attributes.screenshotDisplayType === type);
  if (!set) {
    set = (
      await call('POST', '/appScreenshotSets', {
        data: {
          type: 'appScreenshotSets',
          attributes: { screenshotDisplayType: type },
          relationships: {
            appStoreVersionLocalization: { data: { type: 'appStoreVersionLocalizations', id: en.id } },
          },
        },
      })
    ).data;
  }
  // Out with what the set held, so the order is only these.
  for (const old of await all(`/appScreenshotSets/${set.id}/appScreenshots`)) {
    await call('DELETE', `/appScreenshots/${old.id}`);
  }
  const ids = [];
  for (const file of files) {
    const bytes = readFileSync(join(root, type, file));
    const shot = (
      await call('POST', '/appScreenshots', {
        data: {
          type: 'appScreenshots',
          attributes: { fileName: file, fileSize: bytes.length },
          relationships: { appScreenshotSet: { data: { type: 'appScreenshotSets', id: set.id } } },
        },
      })
    ).data;
    for (const op of shot.attributes.uploadOperations) {
      const headers = Object.fromEntries((op.requestHeaders ?? []).map((h) => [h.name, h.value]));
      const res = await fetch(op.url, {
        method: op.method,
        headers,
        body: bytes.subarray(op.offset, op.offset + op.length),
      });
      if (!res.ok) throw new Error(`upload ${file} -> ${res.status}`);
    }
    await call('PATCH', `/appScreenshots/${shot.id}`, {
      data: {
        type: 'appScreenshots',
        id: shot.id,
        attributes: { uploaded: true, sourceFileChecksum: createHash('md5').update(bytes).digest('hex') },
      },
    });
    ids.push(shot.id);
    console.log(`  ${file}: sent`);
  }
  // In file-name order, whatever order Apple finished them in.
  await call('PATCH', `/appScreenshotSets/${set.id}/relationships/appScreenshots`, {
    data: ids.map((id) => ({ type: 'appScreenshots', id })),
  });
  // Apple processes each one; read them back until it has.
  let shots = [];
  for (let i = 0; i < 50; i++) {
    shots = await all(`/appScreenshotSets/${set.id}/appScreenshots`);
    const states = shots.map((s) => s.attributes.assetDeliveryState?.state);
    if (states.every((s) => s === 'COMPLETE' || s === 'FAILED')) break;
    await sleep(6000);
  }
  for (const s of shots) {
    console.log(`  ${describe(s)}`);
    if (s.attributes.assetDeliveryState?.state !== 'COMPLETE') failed = true;
  }
  const order = shots.map((s) => s.attributes.fileName).join(',') === files.join(',');
  console.log(`  ${shots.length} of ${files.length} on App Store Connect, ${order ? 'in order' : 'OUT OF ORDER'}`);
  if (shots.length !== files.length || !order) failed = true;
}
console.log(failed ? '\nscreenshots: NOT all verified' : '\nscreenshots: all verified');
process.exit(failed ? 1 : 0);
