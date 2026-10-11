-- ─────────────────────────────── closed-test testers ─────────────────────────
--
-- Testers get Pro without buying it. A test purchase on Google Play renews
-- every few minutes and emails a receipt each time, then lapses and puts the
-- paywall back — so a tester who subscribed with the test card was mailed all
-- day and asked to pay again by evening. Instead their emails go on a list,
-- and an account that signs up with one is given Pro by RevenueCat, as a
-- promotional grant: no purchase, no receipts, nothing to renew.
--
-- Two ways an account and the list meet, and either hands the account to the
-- revenuecat-webhook function, which makes the grant:
--   - somebody types a listed email at sign-up. Caught when the email is
--     typed, before the code is, so the grant is in place by the time the
--     paywall would open;
--   - an email is added to the list after its owner already signed up.
--
-- The function checks the list itself, from the account's own record, and
-- grants each account once; whoever calls it can do nothing else with it.
-- Adding and removing testers: supabase/switches.sql.

create table if not exists beta_testers (
  email    text primary key check (email = lower(trim(email))),
  added_at timestamptz not null default now()
);
alter table beta_testers enable row level security;

-- Each account given its pass, so it is given once.
create table if not exists beta_tester_grants (
  user_id    uuid primary key references auth.users (id) on delete cascade,
  email      text not null,
  granted_at timestamptz not null default now()
);
alter table beta_tester_grants enable row level security;

create or replace function grant_tester_pro(for_user uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  perform net.http_post(
    url := 'https://pzhdakzjbjyxhspymjhb.supabase.co/functions/v1/revenuecat-webhook',
    headers := jsonb_build_object('Content-Type', 'application/json'),
    body := jsonb_build_object('tester', for_user)
  );
end;
$$;

-- On auth.users, so it runs inside every sign-up and sign-in. Nothing in it
-- may ever fail one: every error is caught and only warned about.
create or replace function tester_signed_up()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  begin
    if exists (
         select 1 from beta_testers b
          where b.email in (lower(trim(coalesce(new.email, ''))),
                            lower(trim(coalesce(new.email_change, ''))))
       )
       and not exists (
         select 1 from beta_tester_grants g where g.user_id = new.id
       ) then
      perform grant_tester_pro(new.id);
    end if;
  exception when others then
    raise warning 'tester pass not queued: %', sqlerrm;
  end;
  return new;
end;
$$;

drop trigger if exists tester_signed_up on auth.users;
create trigger tester_signed_up
  after insert or update of email, email_change on auth.users
  for each row execute function tester_signed_up();

create or replace function tester_added()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  account uuid;
begin
  begin
    for account in
      select u.id from auth.users u
       where lower(trim(u.email)) = new.email
         and not exists (select 1 from beta_tester_grants g where g.user_id = u.id)
    loop
      perform grant_tester_pro(account);
    end loop;
  exception when others then
    raise warning 'tester pass not queued: %', sqlerrm;
  end;
  return new;
end;
$$;

drop trigger if exists tester_added on beta_testers;
create trigger tester_added
  after insert on beta_testers
  for each row execute function tester_added();

revoke all on function grant_tester_pro(uuid) from public, anon, authenticated;
revoke all on function tester_signed_up() from public, anon, authenticated;
revoke all on function tester_added() from public, anon, authenticated;
