-- OUTREPD — what a rewarded video gives (the user's pick, 2026-11-09).
--
-- A short video the player chooses to watch, for something that never
-- touches the ladder: the match's experience again, or a Pro part worn for a
-- day. (The third, a streak brought back once a week, is the rewards copy's
-- own — adventure.sql, rewards_merge — and needs nothing here.) Pro gets
-- each with no video.
--
-- The server takes the phone's word that the video was watched: experience
-- and a part's look are cosmetic, so a check with LevelPlay's servers would
-- guard nothing worth its cost. What it does guard is how often, and that
-- the duel is the caller's own and just played.

-- ─────────────────────────────── the match's XP twice ─────────────────────────

-- One row per duel doubled for one of its lifters: once, and no more.
create table if not exists xp_doubles (
  duel_id     uuid not null references duels on delete cascade,
  profile_id  uuid not null references profiles on delete cascade,
  xp          int  not null,
  at          timestamptz not null default now(),
  primary key (duel_id, profile_id)
);

create index if not exists xp_doubles_profile_idx on xp_doubles (profile_id);

alter table xp_doubles enable row level security;

-- The experience [of_duel] paid the caller, paid again: the reps of their
-- set and the twenty for the match (xp_for_duel, live.sql). Only for a duel
-- the caller won — a loss pays nothing to double — that was played in the
-- last half hour, by the caller: the challenger of any duel, the defender
-- of a live one (whose set was lifted then too, not raced while away).
-- Returns what was added; nothing for a duel that does not qualify or was
-- doubled already.
create or replace function double_duel_xp(of_duel uuid)
returns int
language plpgsql
security definer
set search_path = public
as $$
declare
  me uuid := auth.uid();
  d duels;
  live boolean;
  my_set uuid;
  gained int;
begin
  if me is null then
    raise exception 'not signed in';
  end if;
  select * into d from duels where id = of_duel;
  if d.id is null or d.created_at < now() - interval '30 minutes' then
    return 0;
  end if;
  live := exists (select 1 from live_matches m where m.duel = d.id);
  if d.challenger = me then
    my_set := d.challenger_set;
  elsif d.defender = me and live then
    my_set := d.defender_set;
  else
    return 0;
  end if;
  if d.winner is not null and d.winner <> me then
    return 0;
  end if;
  if exists (select 1 from xp_doubles x
              where x.duel_id = d.id and x.profile_id = me) then
    return 0;
  end if;
  if not within_rate('xp_double', interval '1 day', 40) then
    return 0;
  end if;

  select coalesce(s.reps, 0) + 20 into gained from sets s where s.id = my_set;
  gained := coalesce(gained, 20);
  insert into xp_doubles (duel_id, profile_id, xp) values (d.id, me, gained);

  perform set_config('outrepd.settling', 'on', true);
  update profiles set xp = xp + gained where id = me;
  perform set_config('outrepd.settling', 'off', true);
  return gained;
end;
$$;

-- ─────────────────────────────── a Pro part for a day ─────────────────────────

-- The caller wears one Pro part for a day: [part_key] is the lifter's own
-- key for it (lib/lifter/catalog.dart, Lifter.toJson — 'hair', 'gear' …),
-- [part_id] the part, [was_id] what that key held before, so the day can
-- end by putting it back. The phone saves the lifter with the part on as it
-- always saves it; this is the record of until when it may stay, which
-- pro_looks (account.sql) reads: past it, everybody else sees [was_id]
-- again. A new day for another part replaces the old one. Returns the end.
create or replace function start_pro_trial(part_key text, part_id text, was_id text)
returns timestamptz
language plpgsql
security definer
set search_path = public
as $$
declare
  me uuid := auth.uid();
  until timestamptz := now() + interval '1 day';
begin
  if me is null then
    raise exception 'not signed in';
  end if;
  if part_key !~ '^[a-zA-Z]{1,24}$'
     or part_id !~ '^[a-z0-9_]{1,40}$'
     or (was_id is not null and was_id !~ '^[a-z0-9_#]{1,40}$') then
    raise exception 'not a part';
  end if;
  if not within_rate('pro_trial', interval '1 day', 3) then
    raise exception 'that is enough parts for today';
  end if;

  perform set_config('outrepd.settling', 'on', true);
  update profiles
     set pro_trial = jsonb_build_object(
           'key', part_key, 'id', part_id, 'was', was_id, 'until', until)
   where id = me;
  perform set_config('outrepd.settling', 'off', true);
  return until;
end;
$$;

-- [lifter] as everybody else sees it: a Pro part worn for a day comes off
-- once the day is over, unless the account has Pro by then.
create or replace function lifter_as_seen(lifter jsonb, trial jsonb, pro boolean)
returns jsonb
language sql
stable
set search_path = public
as $$
  select case
    when lifter is null or trial is null or pro then lifter
    when (trial ->> 'until')::timestamptz > now() then lifter
    when lifter ->> (trial ->> 'key') is distinct from trial ->> 'id' then lifter
    else lifter || jsonb_build_object(trial ->> 'key', trial -> 'was')
  end;
$$;

revoke all on function double_duel_xp(uuid) from public;
grant execute on function double_duel_xp(uuid) to authenticated;
revoke all on function start_pro_trial(text, text, text) from public;
grant execute on function start_pro_trial(text, text, text) to authenticated;
revoke all on function lifter_as_seen(jsonb, jsonb, boolean) from public, anon, authenticated;
