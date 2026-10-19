// Makes sure Apple knows the promo copy before it is signed and uploaded:
// registers its bundle id when it is not registered yet, then says whether
// App Store Connect has an app for it — the one step the API cannot take,
// and without which an upload has nowhere to go.
//
//   node tool/ios/promo_app_id.mjs <path to the .p8 key>
//
// Reads ASC_KEY_ID and ASC_ISSUER_ID from the environment; writes
// app_record=yes|no to $GITHUB_OUTPUT. Never fails the build by itself.

import { createPrivateKey, createSign } from 'node:crypto';
import { appendFileSync, readFileSync } from 'node:fs';

const bundleId = 'com.outrepd.promo';
const keyId = process.env.ASC_KEY_ID;
const issuer = process.env.ASC_ISSUER_ID;
const keyPath = process.argv[2];

const say = (line) => {
  console.log(line);
  if (process.env.GITHUB_OUTPUT) appendFileSync(process.env.GITHUB_OUTPUT, `${line}\n`);
};

if (!keyId || !issuer || !keyPath) {
  console.log('no App Store Connect key');
  say('app_record=no');
  process.exit(0);
}

const part = (value) => Buffer.from(JSON.stringify(value)).toString('base64url');
const now = Math.floor(Date.now() / 1000);
const head = part({ alg: 'ES256', kid: keyId, typ: 'JWT' });
const body = part({ iss: issuer, iat: now, exp: now + 600, aud: 'appstoreconnect-v1' });
const signer = createSign('SHA256');
signer.update(`${head}.${body}`);
const signature = signer
  .sign({ key: createPrivateKey(readFileSync(keyPath, 'utf8')), dsaEncoding: 'ieee-p1363' })
  .toString('base64url');
const headers = {
  Authorization: `Bearer ${head}.${body}.${signature}`,
  'Content-Type': 'application/json',
};
const api = 'https://api.appstoreconnect.apple.com/v1';

try {
  const found = await fetch(`${api}/bundleIds?filter[identifier]=${bundleId}`, { headers });
  const ids = found.ok ? (await found.json()).data : [];
  // The filter matches prefixes too: com.outrepd.promo is not com.outrepd.promox.
  if (ids.some((id) => id.attributes?.identifier === bundleId)) {
    console.log(`${bundleId} is registered`);
  } else {
    const made = await fetch(`${api}/bundleIds`, {
      method: 'POST',
      headers,
      body: JSON.stringify({
        data: {
          type: 'bundleIds',
          attributes: { identifier: bundleId, name: 'OUTREPD Promo', platform: 'IOS' },
        },
      }),
    });
    console.log(
      made.ok
        ? `registered ${bundleId}`
        : `could not register ${bundleId}: ${made.status} ${await made.text()}`,
    );
  }

  const apps = await fetch(`${api}/apps?filter[bundleId]=${bundleId}`, { headers });
  const record = apps.ok
    ? (await apps.json()).data.find((app) => app.attributes?.bundleId === bundleId)
    : null;
  if (record) {
    console.log(`App Store Connect app: ${record.attributes.name}`);
    say('app_record=yes');
  } else {
    console.log(`no App Store Connect app for ${bundleId} yet`);
    say('app_record=no');
  }
} catch (error) {
  console.log(`could not ask App Store Connect: ${error}`);
  // Try the upload anyway: it says plainly why if it cannot go.
  say('app_record=yes');
}
