// Emails whoever answers reports each time one is filed.
//
// The terms promise that reports are acted on within 24 hours, and nothing in
// the app shows the reports table to anybody, so without this a report sits
// there until someone happens to open the dashboard.
//
// Called by the send_report_alert trigger in supabase/push.sql with a
// report's id and nothing else. It claims the report itself -- sets
// alerted_at where it is still empty -- before emailing, so any number of
// calls for one report send one email, and a caller who is not the trigger
// can do nothing but have an existing report emailed about once. That is
// why this function needs no secret from its caller, and why the trigger
// lives in install.sql rather than in a statement typed into the SQL editor.
//
// Deploying it:
//
//   1. Supabase dashboard > Edge Functions > report-alert > Code (or Deploy
//      a new function named exactly `report-alert`), paste this file, deploy.
//
//   2. Edge Functions > Secrets must hold:
//        REPORTS_TO       where alerts go, e.g. you@yourdomain
//        RESEND_API_KEY   shared with email-my-data
//        EXPORT_FROM      shared with email-my-data
//      REPORT_ALERT_SECRET is no longer used and can be deleted once the
//      new install.sql has been pasted.
//
//   3. Edge Functions > report-alert > Details: "Verify JWT" off. The trigger
//      calls it without a token.
//
// Deploy this before pasting the install.sql that carries the new trigger:
// it also understands the old hand-made trigger's call, so no report goes
// unannounced in between.

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

const uuid =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

Deno.serve(async (request) => {
  const key = Deno.env.get('RESEND_API_KEY');
  const from = Deno.env.get('EXPORT_FROM');
  const to = Deno.env.get('REPORTS_TO');
  if (!key || !from || !to) {
    return reply(500, {
      error: 'RESEND_API_KEY, EXPORT_FROM and REPORTS_TO must all be set',
    });
  }

  // The trigger sends {report_id}. The hand-made trigger this replaced sent
  // the whole row as {type, table, record}; only its id is used, and the
  // report is read back from the table, never taken from the request.
  let id: unknown;
  try {
    const body = await request.json();
    id = body?.report_id ?? body?.record?.id;
  } catch {
    return reply(400, { error: 'expected a JSON body' });
  }
  if (typeof id !== 'string' || !uuid.test(id)) {
    return reply(400, { error: 'no report id' });
  }

  // The service key, which the platform provides to every function, because
  // the reports table has no read policy at all: nobody reads it through the
  // app, and this function is not the app.
  const db = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    { auth: { persistSession: false } },
  );

  // Claimed in the same step as read: of any number of calls, one gets the
  // row back, and the rest find it already alerted.
  const { data: report, error: claimError } = await db
    .from('reports')
    .update({ alerted_at: new Date().toISOString() })
    .eq('id', id)
    .is('alerted_at', null)
    .select('id, reporter, reported, reason, details, created_at')
    .maybeSingle();
  if (claimError) return reply(500, { error: claimError.message });
  if (!report) return reply(200, { skipped: 'already alerted, or no such report' });

  async function nameOf(who: unknown) {
    if (typeof who !== 'string') return '(deleted account)';
    const { data } = await db
      .from('profiles')
      .select('username')
      .eq('id', who)
      .maybeSingle();
    return data?.username ? `${data.username} (${who})` : `(unknown) ${who}`;
  }

  const reporter = await nameOf(report.reporter);
  const reported = await nameOf(report.reported);
  const reason = reasons[String(report.reason)] ?? String(report.reason);
  const details = String(report.details ?? '').trim();

  // Earlier reports against the same account, which is usually what decides
  // between a warning and a ban.
  let earlier = 0;
  if (typeof report.reported === 'string') {
    const { count } = await db
      .from('reports')
      .select('id', { count: 'exact', head: true })
      .eq('reported', report.reported)
      .neq('id', report.id);
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
        `Filed:     ${report.created_at}\n` +
        `Earlier reports against this account: ${earlier}\n\n` +
        `Details:\n${details || '(none)'}\n\n` +
        `Report id: ${report.id}\n` +
        `See it in Supabase > Table Editor > reports.\n`,
    }),
  });

  if (!sent.ok) {
    // Not sent, so not alerted: let a later call try again.
    await db.from('reports').update({ alerted_at: null }).eq('id', report.id);
    return reply(502, { error: `resend refused it: ${await sent.text()}` });
  }
  return reply(200, { sent: true });
});
