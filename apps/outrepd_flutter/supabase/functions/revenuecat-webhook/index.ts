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
//      (Table Editor), fill in everybody who subscribed before the webhook:
//      POST to the same URL with the same Authorization value and the body
//      {"backfill": true}. It answers with how many accounts it read and
//      how many are active.
//
//   6. Only then, and only with an app version out that calls this function
//      after a purchase (see below), switch enforcement on: in
//      subscriptions.sql change paywall_enforced() to `select true`, and run
//      that function's `create or replace` in the SQL Editor.
//
// Three callers, told apart by the Authorization header:
//   - RevenueCat, with REVENUECAT_WEBHOOK_AUTH: syncs the accounts the event
//     names.
//   - The same secret with {"backfill": true}: syncs every account.
//   - The app, with the lifter's own Supabase token, straight after a
//     purchase or a restore: syncs that one account at once, because the
//     webhook can be seconds behind the store and the first duel should not
//     be turned down in between.
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

/// Writes RevenueCat's current answer for each of [ids]. Throws on a
/// RevenueCat or network failure; an id that is no account here is skipped.
async function sync(
  db: ReturnType<typeof createClient>,
  ids: string[],
  secretKey: string,
) {
  const written: string[] = [];
  const skipped: string[] = [];
  for (const id of ids) {
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
  }
  return { written, skipped };
}

/// Equal, without stopping at the first difference: how long a comparison
/// takes says nothing about how much of the secret a guess got right.
function sameSecret(a: string, b: string) {
  const x = new TextEncoder().encode(a);
  const y = new TextEncoder().encode(b);
  let diff = x.length ^ y.length;
  for (let i = 0; i < Math.max(x.length, y.length); i++) {
    diff |= (x[i] ?? 0) ^ (y[i] ?? 0);
  }
  return diff === 0;
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

  const db = createClient(url, serviceKey, {
    auth: { persistSession: false },
  });

  let body: Record<string, unknown> = {};
  try {
    body = await request.json();
  } catch {
    // The app's own call has no body; RevenueCat's always has one.
  }

  // ── the app, right after a purchase or a restore ──────────────────────────
  //
  // Called with the lifter's own Supabase token. The store has just said
  // yes and the app has opened, but RevenueCat's webhook can be seconds
  // behind — long enough for the server to turn down the first duel. This
  // writes the caller's row now. Only ever the caller's: the account comes
  // from the token, not from anything the phone says.
  if (!sameSecret(given, auth)) {
    const { data, error } = await db.auth.getUser(given);
    const id = data?.user?.id;
    if (error || !id) return reply(401, { error: 'unauthorized' });
    // At most once every ten seconds per account: each call is a request to
    // RevenueCat, and a loop on a modified phone should not spend them.
    const { data: last } = await db
      .from('subscriptions')
      .select('updated_at, active')
      .eq('user_id', id)
      .maybeSingle();
    if (last && Date.now() - Date.parse(last.updated_at) < 10_000) {
      return reply(200, { active: last.active, synced: false });
    }
    try {
      await sync(db, [id], secretKey);
    } catch (e) {
      console.error(e);
      return reply(502, { error: 'store unreachable' });
    }
    const { data: now } = await db
      .from('subscriptions')
      .select('active')
      .eq('user_id', id)
      .maybeSingle();
    return reply(200, { active: now?.active ?? false, synced: true });
  }

  // ── once, before enforcement: everybody who subscribed before this ─────────
  //
  // With the webhook's own secret and {"backfill": true}: every account gets
  // its row from RevenueCat, so nobody who paid before the webhook existed is
  // locked out when enforcement is switched on.
  if (body.backfill === true) {
    const ids: string[] = [];
    for (let page = 0; ; page++) {
      const { data, error } = await db
        .from('profiles')
        .select('id')
        .range(page * 1000, page * 1000 + 999);
      if (error) return reply(500, { error: error.message });
      ids.push(...(data ?? []).map((r: { id: string }) => r.id));
      if (!data || data.length < 1000) break;
    }
    try {
      const { written, skipped } = await sync(db, ids, secretKey);
      const { count } = await db
        .from('subscriptions')
        .select('user_id', { count: 'exact', head: true })
        .eq('active', true);
      return reply(200, {
        accounts: ids.length,
        written: written.length,
        skipped: skipped.length,
        active: count ?? null,
      });
    } catch (e) {
      console.error(e);
      return reply(500, { error: String(e) });
    }
  }

  // ── RevenueCat's webhook ──────────────────────────────────────────────────
  const event = (body.event ?? {}) as Record<string, unknown>;
  try {
    const { written, skipped } = await sync(db, accountsIn(event), secretKey);
    return reply(200, { type: event.type ?? null, written, skipped });
  } catch (error) {
    // Answering 500 makes RevenueCat retry later, which is what a
    // RevenueCat or network hiccup deserves.
    console.error(error);
    return reply(500, { error: String(error) });
  }
});
