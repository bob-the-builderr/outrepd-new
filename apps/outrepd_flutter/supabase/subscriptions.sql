-- The subscription, as the server knows it.
--
-- The app keeps a paywall in front of everything, but the app is a phone in
-- somebody else's hands: a modified client can skip any screen. So the calls
-- that make a duel happen — writing a set, finding an opponent, settling —
-- also ask the server, and the server's answer comes from here.
--
-- Who has paid is written by one thing only: the `revenuecat-webhook` edge
-- function, with the service key, whenever RevenueCat reports a purchase, a
-- renewal, a cancellation or an expiry. No client can insert or update a row.
--
-- Enforcement starts switched OFF (`paywall_enforced()` below returns false),
-- because until the webhook is live no row here is ever written, and turning
-- it on then would lock out every paying lifter too. The steps to turn it on
-- are at the top of functions/revenuecat-webhook/index.ts.
--
-- This file comes first in install.sql: the sets policy in schema.sql and the
-- functions in duel.sql call has_pro().

create table if not exists subscriptions (
  user_id uuid primary key references auth.users (id) on delete cascade,
  -- Whether the Pro entitlement is active, as RevenueCat last reported it.
  active boolean not null default false,
  -- When it lapses unless renewed. Null for a lifetime grant.
  expires_at timestamptz,
  product_id text,
  store text,
  updated_at timestamptz not null default now()
);

alter table subscriptions enable row level security;

-- A lifter may read their own row (the app does not today, but a support
-- question is answered faster when it can). Nobody may write one.
drop policy if exists "a lifter reads their own subscription" on subscriptions;
create policy "a lifter reads their own subscription"
  on subscriptions for select
  to authenticated
  using (user_id = auth.uid());

-- The switch. Replace `false` with `true` once the webhook has been receiving
-- events — see functions/revenuecat-webhook/index.ts.
create or replace function paywall_enforced()
returns boolean
language sql
-- Stable, not immutable: an immutable function can be folded into a cached
-- plan, and then flipping the switch would not reach sessions already open.
stable
set search_path = public
as $$
  select false
$$;

-- Whether [uid] may play: always, while enforcement is off; otherwise only
-- with an active, unexpired subscription. A short grace past the expiry
-- covers a renewal that the store has taken but the webhook has not yet
-- reported.
create or replace function has_pro(uid uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select not paywall_enforced()
    or exists (
      select 1
      from subscriptions s
      where s.user_id = uid
        and s.active
        and (s.expires_at is null or s.expires_at > now() - interval '1 hour')
    )
$$;

-- Raised at the top of every call that plays a duel.
create or replace function require_pro()
returns void
language plpgsql
stable
security definer
set search_path = public
as $$
begin
  if not has_pro(auth.uid()) then
    raise exception 'subscription required';
  end if;
end;
$$;
