// Puts the listing in fastlane/metadata on App Store Connect, every locale,
// and reads each field back: a 2xx is not verification (vibe-aso, law 5).
// fastlane is Mac-only; this is the same job through Apple's API, run on the
// Linux CI with the key the iOS build signs with.
//
//   node store/aso/push.mjs <path to .p8> check            what is live, what would change
//   node store/aso/push.mjs <path to .p8> push <version>   write it to that version, then verify
//   node store/aso/push.mjs <path to .p8> create <version> make that version first if it is
//                                                          missing (the user's yes, 2026-11-04), then push
//
// Writes to the version only while App Store Connect lets it be edited
// (Prepare for Submission). Name and subtitle go on the app info that
// version will carry. release_notes.txt, where a locale has one, becomes its
// "What's New".

import { createPrivateKey, createSign } from 'node:crypto';
import { existsSync, readdirSync, readFileSync } from 'node:fs';
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
if ((mode === 'push' || mode === 'create') && !versionString) {
  console.log('push needs the version to write to, like 1.1.3');
  process.exit(1);
}

const metadata = join(dirname(fileURLToPath(import.meta.url)), '..', '..', 'fastlane', 'metadata');
const read = (locale, field) => {
  const file = join(metadata, locale, `${field}.txt`);
  return existsSync(file) ? readFileSync(file, 'utf8').replace(/\n$/, '') : null;
};
const locales = readdirSync(metadata).sort();

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

const app = (await call('GET', `/apps?filter[bundleId]=${bundleId}`)).data[0];
if (!app) {
  console.log(`no app ${bundleId}`);
  process.exit(1);
}
console.log(`app ${app.attributes.name} (${app.id})`);

let versions = await all(`/apps/${app.id}/appStoreVersions?limit=10`);

// A new version, only when asked: App Store Connect then opens a new app
// info for its name and subtitle, read below with the rest.
if (mode === 'create' && !versions.some((v) => v.attributes.versionString === versionString)) {
  await call('POST', '/appStoreVersions', {
    data: {
      type: 'appStoreVersions',
      attributes: { platform: 'IOS', versionString },
      relationships: { app: { data: { type: 'apps', id: app.id } } },
    },
  });
  console.log(`made version ${versionString}`);
  versions = await all(`/apps/${app.id}/appStoreVersions?limit=10`);
}
for (const v of versions.slice(0, 4)) {
  console.log(`version ${v.attributes.versionString}  ${v.attributes.appStoreState}`);
}
const infos = await all(`/apps/${app.id}/appInfos`);
for (const i of infos) console.log(`app info ${i.id}  ${i.attributes.appStoreState ?? i.attributes.state}`);

// The app info a new version edits: the one not yet live.
const liveStates = ['READY_FOR_SALE', 'READY_FOR_DISTRIBUTION', 'REPLACED_WITH_NEW_INFO'];
const editableInfo =
  infos.find((i) => !liveStates.includes(i.attributes.appStoreState ?? i.attributes.state)) ?? null;

const want = (locale) => ({
  version: {
    description: read(locale, 'description'),
    keywords: read(locale, 'keywords'),
    promotionalText: read(locale, 'promotional_text'),
    ...(read(locale, 'release_notes') ? { whatsNew: read(locale, 'release_notes') } : {}),
  },
  info: {
    name: read(locale, 'name'),
    subtitle: read(locale, 'subtitle'),
    privacyPolicyUrl: read(locale, 'privacy_url'),
  },
});

if (mode === 'check') {
  const live = versions.find((v) => liveStates.includes(v.attributes.appStoreState)) ?? versions[0];
  const have = Object.fromEntries(
    (await all(`/appStoreVersions/${live.id}/appStoreVersionLocalizations?limit=200`)).map((l) => [
      l.attributes.locale,
      l.attributes,
    ]),
  );
  console.log(`\nlive ${live.attributes.versionString}: ${Object.keys(have).length} locales live, ${locales.length} written here`);
  for (const locale of locales) {
    const w = want(locale);
    const h = have[locale];
    if (!h) {
      console.log(`  ${locale}: new`);
      continue;
    }
    const changed = ['keywords', 'promotionalText', 'description'].filter((k) => (h[k] ?? '') !== w.version[k]);
    console.log(`  ${locale}: ${changed.length ? `changes ${changed.join(', ')}` : 'same'}`);
  }
  process.exit(0);
}

const version = versions.find((v) => v.attributes.versionString === versionString);
if (!version) {
  console.log(`no version ${versionString} yet: make it in App Store Connect first`);
  process.exit(1);
}
const editable = ['PREPARE_FOR_SUBMISSION', 'DEVELOPER_REJECTED', 'REJECTED', 'METADATA_REJECTED'];
if (!editable.includes(version.attributes.appStoreState)) {
  console.log(`version ${versionString} is ${version.attributes.appStoreState}: not editable`);
  process.exit(1);
}
if (!editableInfo) {
  console.log('no app info open for editing: name and subtitle cannot change right now');
  process.exit(1);
}

const versionLocs = Object.fromEntries(
  (await all(`/appStoreVersions/${version.id}/appStoreVersionLocalizations?limit=200`)).map((l) => [l.attributes.locale, l]),
);
const infoLocs = Object.fromEntries(
  (await all(`/appInfos/${editableInfo.id}/appInfoLocalizations?limit=200`)).map((l) => [l.attributes.locale, l]),
);

// Every locale needs a support URL, and a locale Apple opened for us has
// none: the English one's, everywhere it is missing.
const supportUrl =
  versionLocs['en-US']?.attributes?.supportUrl ??
  (await all(`/appStoreVersions/${version.id}/appStoreVersionLocalizations?filter[locale]=en-US`))[0]
    ?.attributes?.supportUrl ??
  null;
console.log(`support url ${supportUrl ?? 'none in en-US'}`);

let failed = 0;
for (const locale of locales) {
  const w = want(locale);
  if (supportUrl) w.version.supportUrl = supportUrl;
  try {
    // Name first: a locale needs its app info localization before Apple
    // accepts the version's.
    if (infoLocs[locale]) {
      await call('PATCH', `/appInfoLocalizations/${infoLocs[locale].id}`, {
        data: { type: 'appInfoLocalizations', id: infoLocs[locale].id, attributes: w.info },
      });
    } else {
      const made = await call('POST', '/appInfoLocalizations', {
        data: {
          type: 'appInfoLocalizations',
          attributes: { locale, ...w.info },
          relationships: { appInfo: { data: { type: 'appInfos', id: editableInfo.id } } },
        },
      });
      infoLocs[locale] = made.data;
    }
    // Adding a locale's app info makes Apple open the version's localization
    // for it too, empty: find that one rather than make a second.
    if (!versionLocs[locale]) {
      const found = await all(
        `/appStoreVersions/${version.id}/appStoreVersionLocalizations?filter[locale]=${locale}`,
      );
      if (found.length) versionLocs[locale] = found[0];
    }
    if (versionLocs[locale]) {
      await call('PATCH', `/appStoreVersionLocalizations/${versionLocs[locale].id}`, {
        data: { type: 'appStoreVersionLocalizations', id: versionLocs[locale].id, attributes: w.version },
      });
    } else {
      const made = await call('POST', '/appStoreVersionLocalizations', {
        data: {
          type: 'appStoreVersionLocalizations',
          attributes: { locale, ...w.version },
          relationships: { appStoreVersion: { data: { type: 'appStoreVersions', id: version.id } } },
        },
      });
      versionLocs[locale] = made.data;
    }

    // Read back, field by field.
    const gotInfo = (await call('GET', `/appInfoLocalizations/${infoLocs[locale].id}`)).data.attributes;
    const gotVersion = (await call('GET', `/appStoreVersionLocalizations/${versionLocs[locale].id}`)).data.attributes;
    const wrong = [
      ...Object.entries(w.info).filter(([k, v]) => (gotInfo[k] ?? '') !== v).map(([k]) => k),
      ...Object.entries(w.version).filter(([k, v]) => (gotVersion[k] ?? '') !== v).map(([k]) => k),
    ];
    if (wrong.length) {
      failed++;
      console.log(`  ${locale}: written, but reads back different: ${wrong.join(', ')}`);
    } else {
      console.log(`  ${locale}: verified`);
    }
  } catch (e) {
    failed++;
    console.log(`  ${locale}: ${e.message}`);
  }
  await sleep(300);
}
console.log(`${locales.length - failed} of ${locales.length} locales verified`);
process.exit(failed ? 1 : 0);
