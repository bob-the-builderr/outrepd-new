// Revokes an account's Sign in with Apple when the account is deleted.
//
// App Store guideline 5.1.1(v): an app that offers Sign in with Apple and
// lets people delete their account must revoke the Apple tokens when they
// do. The app asks Apple for a fresh authorization code just before the
// delete and sends it here; this trades it for a refresh token and revokes
// that, which ends the app's access to the Apple ID.
//
// Deploying it:
//
//   Supabase dashboard > Edge Functions > Deploy a new function
//   Name it exactly `revoke-apple` and paste this file.
//
//   Then Edge Functions > Secrets, and add:
//     APPLE_TEAM_ID       the ten-character team id
//     APPLE_KEY_ID        the id of a "Sign in with Apple" key
//                         (Apple Developer > Keys), primary App ID
//                         com.outrepd.outrepd
//     APPLE_PRIVATE_KEY   the contents of that key's .p8 file
//
// The secrets are set in that screen and nowhere else. They must not be
// written into this file, the repository, or a chat window.

import { createClient } from 'jsr:@supabase/supabase-js@2';
import { importPKCS8, SignJWT } from 'npm:jose@5.9.6';

const clientId = 'com.outrepd.outrepd';

const cors = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, content-type',
};

function reply(status: number, body: Record<string, unknown>) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...cors, 'Content-Type': 'application/json' },
  });
}

/// What Apple takes in place of a password: a short-lived JWT signed with
/// the Sign in with Apple key.
async function clientSecret() {
  const team = Deno.env.get('APPLE_TEAM_ID');
  const keyId = Deno.env.get('APPLE_KEY_ID');
  const pem = Deno.env.get('APPLE_PRIVATE_KEY');
  if (!team || !keyId || !pem) throw new Error('Apple key not configured');
  const key = await importPKCS8(pem.replace(/\\n/g, '\n'), 'ES256');
  return await new SignJWT({})
    .setProtectedHeader({ alg: 'ES256', kid: keyId })
    .setIssuer(team)
    .setSubject(clientId)
    .setAudience('https://appleid.apple.com')
    .setIssuedAt()
    .setExpirationTime('5m')
    .sign(key);
}

Deno.serve(async (request) => {
  if (request.method === 'OPTIONS') return new Response('ok', { headers: cors });

  // Only a signed-in account may ask, for itself.
  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_ANON_KEY')!,
    { global: { headers: { Authorization: request.headers.get('Authorization') ?? '' } } },
  );
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return reply(401, { error: 'not signed in' });

  let code = '';
  try {
    code = String((await request.json()).code ?? '');
  } catch (_) {
    // Handled below as a missing code.
  }
  if (!code) return reply(400, { error: 'no authorization code' });

  try {
    const secret = await clientSecret();
    const form = (fields: Record<string, string>) => new URLSearchParams(fields);

    const exchanged = await fetch('https://appleid.apple.com/auth/token', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: form({
        client_id: clientId,
        client_secret: secret,
        code,
        grant_type: 'authorization_code',
      }),
    });
    const tokens = await exchanged.json();
    const token = tokens.refresh_token ?? tokens.access_token;
    if (!exchanged.ok || !token) {
      return reply(502, { error: 'Apple would not exchange the code', detail: tokens.error });
    }

    const revoked = await fetch('https://appleid.apple.com/auth/revoke', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: form({
        client_id: clientId,
        client_secret: secret,
        token,
        token_type_hint: tokens.refresh_token ? 'refresh_token' : 'access_token',
      }),
    });
    if (!revoked.ok) return reply(502, { error: 'Apple would not revoke the token' });
    return reply(200, { revoked: true });
  } catch (error) {
    return reply(500, { error: String(error) });
  }
});
