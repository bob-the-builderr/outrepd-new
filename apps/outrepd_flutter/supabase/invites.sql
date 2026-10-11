-- OUTREPD — bringing a friend in.
--
-- A yearly subscriber's friend code is an invite code: the link they send
-- (outrepd.com/u/<name>) shows it, and a new account types it once, in its
-- first week, for Pro free for seven days. Only the yearly plan carries one,
-- and the one who invited gets nothing for it: it is a thing to give, not a
-- scheme to earn from, so nobody has a reason to farm it.
--
-- The seven days are a RevenueCat promotional grant, given by the
-- revenuecat-webhook function, which is asked here the way testers.sql asks
-- it for a tester's pass. What it gives is read from this table, never from
-- what it was asked: a row not yet given is the only thing it acts on, and
-- it marks the row once given.

create table if not exists invites (
  invitee    uuid primary key references profiles on delete cascade,
  inviter    uuid not null references profiles on delete cascade,
  created_at timestamptz not null default now(),
  -- When RevenueCat gave the invitee their seven days.
  granted_at timestamptz,
  check (invitee <> inviter)
);
create index if not exists invites_inviter_idx on invites (inviter);
alter table invites enable row level security;

-- Whether [who] is on the yearly plan right now, and paying for it: an
-- active subscription to a product named for a year, past its free days.
-- The product ids differ by store (`com.outrepd.outrepd.pro.yearly`,
-- `pro_yearly`, `..._annual_...` in the test store), and every one of them
-- says which it is.
create or replace function on_yearly_plan(who uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select exists (
    select 1 from subscriptions s
     where s.user_id = who
       and s.active
       and (s.expires_at is null or s.expires_at > now())
       and s.product_id ~* '(year|annual)'
       and s.period_type is distinct from 'trial'
  );
$$;

-- Asks the webhook function to give [who] the week they are owed.
create or replace function ask_invite_grant(who uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  perform net.http_post(
    url := 'https://pzhdakzjbjyxhspymjhb.supabase.co/functions/v1/revenuecat-webhook',
    headers := jsonb_build_object('Content-Type', 'application/json'),
    body := jsonb_build_object('invite_grant', who)
  );
end;
$$;

-- The new account types a friend's code. Answers with what happened:
--   'claimed'       the seven days are on their way
--   'unknown_code'  no lifter has that code
--   'not_yearly'    that lifter's plan does not carry a code
--   'own_code'      their own
--   'already'       this account already used a code
--   'too_late'      the account is more than a week old
--   'full'          that code has been used as much as a month allows
create or replace function claim_invite(code text)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  me profiles;
  them uuid;
  cleaned text := trim(leading '#' from trim(coalesce(code, '')));
begin
  select * into me from profiles where id = auth.uid();
  if me is null then
    raise exception 'no profile for this account';
  end if;
  -- Ten tries an hour: a code is six digits, and guessing them is not how
  -- anybody should be finding one.
  if not within_rate('claim_invite', interval '1 hour', 10) then
    raise exception 'too many tries, wait a while';
  end if;
  if exists (select 1 from invites i where i.invitee = me.id) then
    return 'already';
  end if;
  if me.created_at < now() - interval '7 days' then
    return 'too_late';
  end if;
  select p.id into them from profiles p where p.friend_code = cleaned;
  if them is null then
    return 'unknown_code';
  end if;
  if them = me.id then
    return 'own_code';
  end if;
  -- Somebody either of them blocked is nobody to have been brought in by.
  if exists (
    select 1 from blocks b
     where (b.blocker = me.id and b.blocked = them)
        or (b.blocker = them and b.blocked = me.id)
  ) then
    return 'unknown_code';
  end if;
  if not on_yearly_plan(them) then
    return 'not_yearly';
  end if;
  -- Twenty a month on any one code: more than anybody brings in by hand,
  -- and a ceiling on one code passed around for free weeks.
  if (select count(*) from invites i
       where i.inviter = them
         and i.created_at > now() - interval '30 days') >= 20 then
    return 'full';
  end if;

  insert into invites (invitee, inviter) values (me.id, them);
  perform ask_invite_grant(me.id);
  return 'claimed';
end;
$$;

-- The inviter's side, for the invite card: whether their plan carries a
-- code, and how many friends have come in on it.
create or replace function my_invites()
returns table (can_invite boolean, joined int)
language sql
stable
security definer
set search_path = public
as $$
  select on_yearly_plan(auth.uid()),
         (select count(*)::int from invites i where i.inviter = auth.uid());
$$;

-- Who brought the caller in, if anybody, for the sign-up screen to say the
-- seven days are theirs.
create or replace function my_inviter()
returns table (inviter_name text, claimed_at timestamptz)
language sql
stable
security definer
set search_path = public
as $$
  select p.username, i.created_at
    from invites i
    join profiles p on p.id = i.inviter
   where i.invitee = auth.uid();
$$;

revoke all on function on_yearly_plan(uuid) from public, anon, authenticated;
revoke all on function ask_invite_grant(uuid) from public, anon, authenticated;
revoke all on function claim_invite(text) from public, anon;
grant execute on function claim_invite(text) to authenticated;
revoke all on function my_invites() from public, anon;
grant execute on function my_invites() to authenticated;
revoke all on function my_inviter() from public, anon;
grant execute on function my_inviter() to authenticated;
