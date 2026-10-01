// Emails somebody a copy of everything the server holds about them.
//
// It exists because sending an email needs a Resend key, and a key that
// reaches a phone is a key anybody can pull out of the APK and send mail
// with. The key lives here, in the function's environment, and the app's
// whole part in this is handing over an address.
//
// Deploying it:
//
//   Supabase dashboard → Edge Functions → Deploy a new function
//   Name it exactly `email-my-data` and paste this file.
//
//   Then Edge Functions → Secrets, and add:
//     RESEND_API_KEY   the key from resend.com
//     EXPORT_FROM      the verified sender, e.g. outrepd <data@yourdomain>
//
// The secrets are set in that screen and nowhere else. They must not be
// written into this file, the repository, or a chat window.

import { createClient } from 'jsr:@supabase/supabase-js@2';

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

/// Enough to catch a typo, and no more. A stricter pattern than this rejects
/// real addresses, and the only cost of a wrong one is an email nobody reads.
function looksLikeAnAddress(value: string) {
  return /^[^@\s]+@[^@\s.]+\.[^@\s]+$/.test(value);
}

Deno.serve(async (request) => {
  if (request.method === 'OPTIONS') return new Response('ok', { headers: cors });

  const key = Deno.env.get('RESEND_API_KEY');
  const from = Deno.env.get('EXPORT_FROM');
  if (!key || !from) {
    // Said plainly rather than as a 500: this is a deployment that is not
    // finished, and the person reading the log is the one who can finish it.
    return reply(500, {
      error: 'RESEND_API_KEY and EXPORT_FROM are not set on this function',
    });
  }

  // The caller's own token, passed straight through. Everything the export
  // gathers is scoped by `auth.uid()` inside the database, so this function
  // never decides whose data it is — it cannot, and that is the point.
  const authorization = request.headers.get('Authorization');
  if (!authorization) return reply(401, { error: 'not signed in' });

  let to = '';
  try {
    const body = await request.json();
    to = String(body?.to ?? '').trim();
  } catch {
    return reply(400, { error: 'expected a JSON body' });
  }
  if (!looksLikeAnAddress(to)) return reply(400, { error: 'not an address' });

  const db = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_ANON_KEY')!,
    { global: { headers: { Authorization: authorization } } },
  );

  // Only to the address this account signed in with. It used to go wherever
  // the request said, which made this function a way for anybody with an
  // account to send mail from this project's sender to any address at all,
  // as often as they liked — and a sender that does that gets blocked.
  const token = authorization.replace(/^Bearer\s+/i, '');
  const { data: who } = await db.auth.getUser(token);
  const own = (who?.user?.email ?? '').trim().toLowerCase();
  if (!own) return reply(403, { error: 'this account has no email address' });
  if (to.toLowerCase() !== own) {
    return reply(403, { error: 'the export only goes to your own address' });
  }

  // And not endlessly: three a day (claim_data_export, account.sql).
  const { data: allowed, error: rateError } = await db.rpc('claim_data_export');
  if (rateError) return reply(400, { error: rateError.message });
  if (allowed !== true) {
    return reply(429, { error: 'already sent three today' });
  }

  const { data, error } = await db.rpc('my_data');
  if (error) return reply(400, { error: error.message });

  const stamp = new Date().toISOString().slice(0, 10);
  const file = `outrepd-${stamp}.json`;

  const sent = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${key}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      from,
      to,
      subject: 'Your OUTREPD data',
      text:
        'Attached is everything OUTREPD holds about your account.\n\n' +
        'Pose landmarks are not in it, and never were: the camera reads ' +
        'them on your phone and they are not sent anywhere. There is ' +
        'nothing of them on any server to include.\n',
      attachments: [
        {
          filename: file,
          content: btoa(
            // The export is plain ASCII once escaped, which keeps btoa from
            // choking on a username with an accent in it.
            JSON.stringify(data, null, 2).replace(
              /[-￿]/g,
              (c) => '\\u' + c.charCodeAt(0).toString(16).padStart(4, '0'),
            ),
          ),
        },
      ],
    }),
  });

  if (!sent.ok) {
    return reply(502, { error: `resend refused it: ${await sent.text()}` });
  }
  return reply(200, { sent: true });
});
