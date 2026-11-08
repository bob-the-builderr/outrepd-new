// Sends a notice to the phones of the account it is for, through Firebase
// Cloud Messaging, in the language each phone's app is in.
//
// Called by the send_push trigger in supabase/push.sql with a notice's id
// and nothing else. It looks the notice up itself and marks it pushed in the
// same step, so any number of calls for one notice send it once — which is
// why this function needs no secret from its caller.
//
// Deploying it:
//
//   1. Firebase console → Project settings → Service accounts → Generate new
//      private key. That downloads a JSON file.
//
//   2. Supabase dashboard → Edge Functions → Secrets → add
//        FCM_SERVICE_ACCOUNT   the whole of that JSON file, pasted as is
//
//   3. Edge Functions → Deploy a new function → Via editor. Name it exactly
//      `push` and paste this file — with the import of './messages.ts'
//      below replaced by the contents of messages.ts, minus its `export`,
//      so the editor gets one file. That is how it was first deployed.
//      With the Supabase CLI instead, the two files deploy as they are:
//        supabase functions deploy push --no-verify-jwt
//      Deploy again whenever messages.ts is regenerated, or pushes keep the
//      old wording.
//
//   4. Edge Functions → push → Details → turn off "Enforce JWT verification".
//      The trigger calls it without one, and the notice lookup above is what
//      keeps a caller from doing anything but sending a notice that exists,
//      once.
//
// The service account key is set in that one screen and nowhere else. It
// must not be written into this file, the repository, or a chat window.

import { createClient } from 'jsr:@supabase/supabase-js@2';

import { messages } from './messages.ts';

type ServiceAccount = {
  project_id: string;
  client_email: string;
  private_key: string;
};

type Notice = {
  id: string;
  profile_id: string;
  kind:
    | 'raced'
    | 'friend_request'
    | 'friend_accepted'
    | 'challenged'
    | 'live_invite'
    | 'passed';
  actor_name: string;
  you_won: boolean | null;
  your_reps: number | null;
  their_reps: number | null;
};

function reply(status: number, body: Record<string, unknown>) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}

/// The title and body for [notice], in [language] or English.
function words(notice: Notice, language: string) {
  const l = messages[language] ?? messages['en'];
  const fill = (text: string) =>
    text
      .replaceAll('{name}', notice.actor_name || '?')
      .replaceAll('{yours}', String(notice.your_reps ?? 0))
      .replaceAll('{theirs}', String(notice.their_reps ?? 0));
  switch (notice.kind) {
    case 'raced':
      return {
        title: l.nRacedTitle,
        body: fill(notice.you_won ? l.nRacedHeld : l.nRacedBeaten),
      };
    case 'friend_request':
      return { title: l.nFriendTitle, body: fill(l.nFriendBody) };
    case 'friend_accepted':
      return { title: l.nFriendOkTitle, body: fill(l.nFriendOkBody) };
    case 'challenged':
      return { title: l.nChallengedTitle, body: fill(l.nChallengedBody) };
    case 'live_invite':
      return { title: l.nLiveTitle, body: fill(l.nLiveBody) };
    case 'passed':
      return { title: l.nPassedTitle, body: fill(l.nPassedBody) };
  }
}

function base64url(bytes: Uint8Array | string) {
  const raw = typeof bytes === 'string'
    ? btoa(unescape(encodeURIComponent(bytes)))
    : btoa(String.fromCharCode(...bytes));
  return raw.replaceAll('+', '-').replaceAll('/', '_').replaceAll('=', '');
}

/// A Google access token for sending, from the service account's key: a
/// signed JWT exchanged at Google's token endpoint.
async function accessToken(account: ServiceAccount) {
  const now = Math.floor(Date.now() / 1000);
  const header = base64url(JSON.stringify({ alg: 'RS256', typ: 'JWT' }));
  const claims = base64url(
    JSON.stringify({
      iss: account.client_email,
      scope: 'https://www.googleapis.com/auth/firebase.messaging',
      aud: 'https://oauth2.googleapis.com/token',
      iat: now,
      exp: now + 3600,
    }),
  );
  const pem = account.private_key
    .replace(/-----[^-]+-----/g, '')
    .replace(/\s+/g, '');
  const der = Uint8Array.from(atob(pem), (c) => c.charCodeAt(0));
  const key = await crypto.subtle.importKey(
    'pkcs8',
    der,
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
    false,
    ['sign'],
  );
  const signature = new Uint8Array(
    await crypto.subtle.sign(
      'RSASSA-PKCS1-v1_5',
      key,
      new TextEncoder().encode(`${header}.${claims}`),
    ),
  );
  const response = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion: `${header}.${claims}.${base64url(signature)}`,
    }),
  });
  if (!response.ok) {
    throw new Error(`token exchange failed: ${response.status}`);
  }
  return (await response.json()).access_token as string;
}

Deno.serve(async (request) => {
  const raw = Deno.env.get('FCM_SERVICE_ACCOUNT');
  if (!raw) return reply(500, { error: 'FCM_SERVICE_ACCOUNT is not set' });

  let id: unknown;
  try {
    id = (await request.json()).id;
  } catch {
    return reply(400, { error: 'expected {"id": ...}' });
  }
  if (typeof id !== 'string' || !/^[0-9a-f-]{36}$/i.test(id)) {
    return reply(400, { error: 'expected a notice id' });
  }

  const db = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  );

  // Claim it. Only the call that flips pushed_at from empty gets the row
  // back, so a notice is pushed once however many times this is called.
  const { data: notice, error } = await db
    .from('notifications')
    .update({ pushed_at: new Date().toISOString() })
    .eq('id', id)
    .is('pushed_at', null)
    .select('id, profile_id, kind, actor_name, you_won, your_reps, their_reps')
    .maybeSingle<Notice>();
  if (error) return reply(500, { error: error.message });
  if (!notice) return reply(200, { sent: 0, reason: 'already pushed or gone' });

  const { data: phones } = await db
    .from('push_tokens')
    .select('token, language')
    .eq('profile_id', notice.profile_id);
  if (!phones || phones.length === 0) return reply(200, { sent: 0 });

  const account = JSON.parse(raw) as ServiceAccount;
  const token = await accessToken(account);
  const endpoint =
    `https://fcm.googleapis.com/v1/projects/${account.project_id}/messages:send`;

  let sent = 0;
  for (const phone of phones) {
    const { title, body } = words(notice, phone.language);
    const response = await fetch(endpoint, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({
        message: {
          token: phone.token,
          notification: { title, body },
          data: { notice: notice.id, kind: notice.kind },
          android: {
            priority: 'high',
            notification: { channel_id: 'matches' },
          },
          apns: { payload: { aps: { sound: 'default' } } },
        },
      }),
    });
    if (response.ok) {
      sent++;
      continue;
    }
    // The app was uninstalled, or the token went stale: nothing will arrive
    // there again, and dropping it keeps the next push from trying. Only on
    // those answers — a 400 for anything else is a fault in this message,
    // and must not cost somebody their pushes.
    const failure = await response.text();
    if (
      response.status === 404 ||
      failure.includes('UNREGISTERED') ||
      failure.includes('registration token')
    ) {
      await db.from('push_tokens').delete().eq('token', phone.token);
    } else {
      console.error(`push to one phone failed: ${response.status} ${failure}`);
    }
  }
  return reply(200, { sent });
});
