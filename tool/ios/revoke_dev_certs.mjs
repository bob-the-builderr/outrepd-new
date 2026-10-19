// Revokes the account's Apple Development certificates before a CI build.
//
// Every iOS build runs on a fresh Mac, so Xcode's automatic signing makes a
// new development certificate each time — and the private key behind it is
// gone when the machine is. Apple caps how many an account may hold, and once
// the cap is reached the archive fails with "Your account has reached the
// maximum number of certificates". Nobody signs development builds on a
// machine of their own here, so every development certificate on the account
// is one a past build left behind and can never use again.
//
// Distribution certificates — what App Store and TestFlight builds are signed
// with — are not touched.
//
//   node tool/ios/revoke_dev_certs.mjs <path to the .p8 key>
//
// Reads ASC_KEY_ID and ASC_ISSUER_ID from the environment. Never fails the
// build: if this cannot clear anything, the archive says why on its own.

import { createPrivateKey, createSign } from 'node:crypto';
import { readFileSync } from 'node:fs';

const keyId = process.env.ASC_KEY_ID;
const issuer = process.env.ASC_ISSUER_ID;
const keyPath = process.argv[2];
if (!keyId || !issuer || !keyPath) {
  console.log('no App Store Connect key; nothing cleared');
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
const headers = { Authorization: `Bearer ${head}.${body}.${signature}` };

const api = 'https://api.appstoreconnect.apple.com/v1/certificates';
const listed = await fetch(
  `${api}?filter[certificateType]=DEVELOPMENT,IOS_DEVELOPMENT&limit=200`,
  { headers },
);
if (!listed.ok) {
  console.log(`could not list certificates: ${listed.status} ${await listed.text()}`);
  process.exit(0);
}

const { data } = await listed.json();
console.log(`${data.length} development certificate(s) on the account`);
for (const cert of data) {
  const gone = await fetch(`${api}/${cert.id}`, { method: 'DELETE', headers });
  const name = cert.attributes?.name ?? cert.id;
  console.log(gone.ok ? `revoked ${name}` : `could not revoke ${name}: ${gone.status}`);
}
