// Turns on Sign in with Apple for the app's App ID, when it is not on yet.
//
// Runner.entitlements asks for it; a provisioning profile only carries an
// entitlement its App ID has, so without this the archive is signed without
// it and the Apple button fails on the phone. Once on, it stays on: this
// only reads, every build after the first.
//
//   node tool/ios/enable_apple_sign_in.mjs <path to the .p8 key>
//
// Reads ASC_KEY_ID and ASC_ISSUER_ID from the environment. Never fails the
// build: Xcode's automatic signing may still manage it, and the archive says
// plainly if it cannot.

import { createPrivateKey, createSign } from 'node:crypto';
import { readFileSync } from 'node:fs';

const bundleId = 'com.outrepd.outrepd';
const keyId = process.env.ASC_KEY_ID;
const issuer = process.env.ASC_ISSUER_ID;
const keyPath = process.argv[2];
if (!keyId || !issuer || !keyPath) {
  console.log('no App Store Connect key; nothing changed');
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
  const app = found.ok
    ? (await found.json()).data.find((id) => id.attributes?.identifier === bundleId)
    : null;
  if (!app) {
    console.log(`could not find the App ID ${bundleId}: ${found.status}`);
    process.exit(0);
  }

  const caps = await fetch(`${api}/bundleIds/${app.id}/bundleIdCapabilities`, { headers });
  const have = caps.ok ? (await caps.json()).data : [];
  if (have.some((c) => c.attributes?.capabilityType === 'APPLE_ID_AUTH')) {
    console.log('Sign in with Apple is on');
    process.exit(0);
  }

  const made = await fetch(`${api}/bundleIdCapabilities`, {
    method: 'POST',
    headers,
    body: JSON.stringify({
      data: {
        type: 'bundleIdCapabilities',
        attributes: {
          capabilityType: 'APPLE_ID_AUTH',
          settings: [
            { key: 'APPLE_ID_AUTH_APP_CONSENT', options: [{ key: 'PRIMARY_APP_CONSENT' }] },
          ],
        },
        relationships: { bundleId: { data: { type: 'bundleIds', id: app.id } } },
      },
    }),
  });
  console.log(
    made.ok
      ? 'turned Sign in with Apple on'
      : `could not turn Sign in with Apple on: ${made.status} ${await made.text()}`,
  );
} catch (error) {
  console.log(`could not ask App Store Connect: ${error}`);
}
