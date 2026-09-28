// Keeps the `subscriptions` table in step with RevenueCat.
//
// RevenueCat calls this on every purchase, renewal, cancellation, expiry,
// billing problem and transfer. Rather than trust each event's own fields —
// they differ by type, and events can arrive out of order — it asks
// RevenueCat for the account's current state and writes that. The server's
// has_pro() (subscriptions.sql) then reads it, so a modified app that skips
// the paywall still cannot play a duel once enforcement is switched on.
//
// Deploying it:
//
//   1. Supabase dashboard → Edge Functions → Deploy a new function.
//      Name it exactly `revenuecat-webhook` and paste this file.
//
//   2. Edge Functions → revenuecat-webhook → turn off "Enforce JWT
//      Verification". RevenueCat cannot send a Supabase token; the
//      authorization value below is what keeps other callers out.
//
//   3. Edge Functions → Secrets, and add:
//        REVENUECAT_SECRET_KEY     RevenueCat → Project settings → API keys →
//                                  a *secret* key (sk_...). Never the public
//                                  one the app uses, and never in the app.
//        REVENUECAT_WEBHOOK_AUTH   any long random string
//
//   4. RevenueCat → Project → Integrations → Webhooks → Add:
//        URL:                   https://<project ref>.supabase.co/functions/v1/revenuecat-webhook
//        Authorization header:  the same value as REVENUECAT_WEBHOOK_AUTH
//      Then "Send test event" and check a 200 comes back.
//
//   5. After a real test purchase shows up as a row in `subscriptions`
//      (Table Editor), switch enforcement on: in subscriptions.sql change
//      paywall_enforced() to `select true`, and run that function's
//      `create or replace` in the SQL Editor.
//
// The secrets live in those two dashboards and nowhere else — not in this
// file, the repository, or a chat window.

import { createClient } from 'jsr:@supabase/supabase-js@2';

const ENTITLEMENT = 'pro';

function reply(status: number, body: Record<string, unknown>) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}

/// The app logs RevenueCat in with the Supabase user id, a UUID. Anything
/// else — RevenueCat's own anonymous ids — belongs to no account here.
const uuid =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/// Every account an event concerns: a transfer moves a subscription from one
/// to another, and both have to be rewritten.
function accountsIn(event: Record<string, unknown>): string[] {
  const ids = new Set<string>();
  const add = (value: unknown) => {
    if (typeof value === 'string' && uuid.test(value)) ids.add(value);
    if (Array.isArray(value)) value.forEach(add);
  };
  add(event.app_user_id);
  add(event.original_app_user_id);
  add(event.aliases);
  add(event.transferred_from);
  add(event.transferred_to);
  return [...ids];
}

type Row = {
  user_id: string;
  active: boolean;
  expires_at: string | null;
  product_id: string | null;
  store: string | null;
  updated_at: string;
};

/// What RevenueCat says about [id] right now.
async function currentState(id: string, secretKey: string): Promise<Row> {
  const response = await fetch(
    `https://api.revenuecat.com/v1/subscribers/${encodeURIComponent(id)}`,
    { headers: { Authorization: `Bearer ${secretKey}` } },
  );
  if (!response.ok) {
    throw new Error(`RevenueCat answered ${response.status} for ${id}`);
  }
  const subscriber = (await response.json()).subscriber ?? {};
  const entitlement = subscriber.entitlements?.[ENTITLEMENT];
  const product: string | null = entitlement?.product_identifier ?? null;
  // A billing grace period keeps access while the store retries the card.
  const expires: string | null =
    entitlement?.grace_period_expires_date ?? entitlement?.expires_date ?? null;
  const active = entitlement != null &&
    (expires == null || Date.parse(expires) > Date.now());
  return {
    user_id: id,
    active,
    expires_at: entitlement ? expires : null,
    product_id: product,
    store: product ? subscriber.subscriptions?.[product]?.store ?? null : null,
    updated_at: new Date().toISOString(),
  };
}

Deno.serve(async (request) => {
  const secretKey = Deno.env.get('REVENUECAT_SECRET_KEY');
  const auth = Deno.env.get('REVENUECAT_WEBHOOK_AUTH');
  const url = Deno.env.get('SUPABASE_URL');
  const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
  if (!secretKey || !auth || !url || !serviceKey) {
    return reply(500, { error: 'not configured' });
  }

  // RevenueCat sends the configured value as-is; accept it with or without
  // a "Bearer " prefix.
  const given = (request.headers.get('Authorization') ?? '')
    .replace(/^Bearer\s+/i, '');
  if (given !== auth) return reply(401, { error: 'unauthorized' });

  let event: Record<string, unknown>;
  try {
    event = (await request.json()).event ?? {};
  } catch {
    return reply(400, { error: 'not json' });
  }

  const db = createClient(url, serviceKey, {
    auth: { persistSession: false },
  });

  const written: string[] = [];
  const skipped: string[] = [];
  for (const id of accountsIn(event)) {
    try {
      const row = await currentState(id, secretKey);
      const { error } = await db.from('subscriptions').upsert(row);
      // An id that is no account here (deleted, or never one) fails the
      // foreign key. Nothing to keep for it.
      if (error) {
        skipped.push(id);
        console.log(`not written for ${id}: ${error.message}`);
      } else {
        written.push(id);
      }
    } catch (error) {
      // Answering 500 makes RevenueCat retry later, which is what a
      // RevenueCat or network hiccup deserves.
      console.error(error);
      return reply(500, { error: String(error) });
    }
  }

  return reply(200, { type: event.type ?? null, written, skipped });
});
