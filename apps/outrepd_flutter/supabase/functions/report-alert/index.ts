// Emails whoever answers reports each time one is filed.
//
// The terms promise that reports are acted on within 24 hours, and nothing in
// the app shows the reports table to anybody, so without this a report sits
// there until someone happens to open the dashboard.
//
// Deploying it:
//
//   1. Supabase dashboard → Edge Functions → Deploy a new function.
//      Name it exactly `report-alert` and paste this file.
//
//   2. Edge Functions → Secrets, and add:
//        REPORTS_TO            where alerts go, e.g. you@yourdomain
//        REPORT_ALERT_SECRET   any long random string
//      RESEND_API_KEY and EXPORT_FROM are shared with `email-my-data`, so if
//      that function already works they are set.
//
//   3. Database → Webhooks → Create a new hook:
//        Table            reports
//        Events           Insert
//        Type             Supabase Edge Functions → report-alert, method POST
//        HTTP Headers     Add auth header with service key, and add
//                         x-alert-secret = the same REPORT_ALERT_SECRET
//
// The secrets are set in those screens and nowhere else. They must not be
// written into this file, the repository, or a chat window.

import { createClient } from 'jsr:@supabase/supabase-js@2';

function reply(status: number, body: Record<string, unknown>) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}

/// The words a reason code stands for, as the report screen shows them.
const reasons: Record<string, string> = {
  cheating: 'Cheating or fake reps',
  harassment: 'Harassment or abuse',
  content: 'Inappropriate content',
  impersonation: 'Impersonation',
  other: 'Something else',
};

Deno.serve(async (request) => {
  const key = Deno.env.get('RESEND_API_KEY');
  const from = Deno.env.get('EXPORT_FROM');
  const to = Deno.env.get('REPORTS_TO');
  const secret = Deno.env.get('REPORT_ALERT_SECRET');
  if (!key || !from || !to || !secret) {
    return reply(500, {
      error:
        'RESEND_API_KEY, EXPORT_FROM, REPORTS_TO and REPORT_ALERT_SECRET ' +
        'must all be set on this function',
    });
  }

  // Only the database webhook knows this. Without the check anybody holding
  // the app's public key could call the function and fill the inbox.
  if (request.headers.get('x-alert-secret') !== secret) {
    return reply(401, { error: 'not the webhook' });
  }

  let record: Record<string, unknown> | undefined;
  try {
    const body = await request.json();
    if (body?.type !== 'INSERT' || body?.table !== 'reports') {
      return reply(200, { skipped: true });
    }
    record = body.record;
  } catch {
    return reply(400, { error: 'expected the webhook JSON body' });
  }
  if (!record) return reply(400, { error: 'no record' });

  // The service key, which the platform provides to every function, because
  // the reports table has no read policy at all: nobody reads it through the
  // app, and this function is not the app.
  const db = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  );

  async function nameOf(id: unknown) {
    if (typeof id !== 'string') return '(deleted account)';
    const { data } = await db
      .from('profiles')
      .select('username')
      .eq('id', id)
      .maybeSingle();
    return data?.username ? `${data.username} (${id})` : `(unknown) ${id}`;
  }

  const reporter = await nameOf(record.reporter);
  const reported = await nameOf(record.reported);
  const reason = reasons[String(record.reason)] ?? String(record.reason);
  const details = String(record.details ?? '').trim();

  // Earlier reports against the same account, which is usually what decides
  // between a warning and a ban.
  let earlier = 0;
  if (typeof record.reported === 'string') {
    const { count } = await db
      .from('reports')
      .select('id', { count: 'exact', head: true })
      .eq('reported', record.reported)
      .neq('id', record.id);
    earlier = count ?? 0;
  }

  const sent = await fetch('https://api.resend.com/emails', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${key}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      from,
      to,
      subject: `OUTREPD report: ${reason}`,
      text:
        `A player was reported. The terms promise action within 24 hours.\n\n` +
        `Reason:    ${reason}\n` +
        `Reported:  ${reported}\n` +
        `By:        ${reporter}\n` +
        `Filed:     ${record.created_at}\n` +
        `Earlier reports against this account: ${earlier}\n\n` +
        `Details:\n${details || '(none)'}\n\n` +
        `Report id: ${record.id}\n` +
        `See it in Supabase → Table Editor → reports.\n`,
    }),
  });

  if (!sent.ok) {
    return reply(502, { error: `resend refused it: ${await sent.text()}` });
  }
  return reply(200, { sent: true });
});
