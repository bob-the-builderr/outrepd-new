-- The server's switches. Not part of install.sql: each statement here is run
-- on its own, in the Supabase SQL editor, when it is time. A value set here
-- survives every later paste of install.sql.

-- ───────────────────────── requiring Pro for a duel ──────────────────────────
--
-- Turn on only when both are true:
--   1. RevenueCat's webhook has been writing the `subscriptions` table
--      (Table Editor shows rows with active = true for subscribers), and
--   2. an app version that has the server sync right after a purchase is out
--      on both stores — otherwise the first duel straight after buying can be
--      turned down for the few seconds the webhook takes.
--
-- Before turning it on, fill in anybody who subscribed since the last
-- backfill: POST {"backfill": true} to the revenuecat-webhook function with
-- its secret (see the top of functions/revenuecat-webhook/index.ts).

-- On:
update server_switches set enabled = true, changed_at = now()
 where name = 'paywall_enforced';

-- Off again, if anything goes wrong — paying lifters are never locked out
-- by a switch that is off:
-- update server_switches set enabled = false, changed_at = now()
--  where name = 'paywall_enforced';

-- Where it stands:
-- select name, enabled, changed_at from server_switches;
