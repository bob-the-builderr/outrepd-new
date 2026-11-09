-- OUTREPD — beat your past self (the user's pick, 2026-11-09).
--
-- A six-week plan from the lifter's best minute: a goal, a few training days
-- a week, and each week a race against their own best minute of the week
-- before, at the pace they really lifted it. The phone works the plan out;
-- the account keeps it, so a new phone carries on where the old one was, and
-- hands back the minute to race. Nothing here touches the ladder.

-- ─────────────────────────────────── the plan ───────────────────────────────────

create table if not exists training_plans (
  profile_id uuid primary key references profiles on delete cascade,
  plan       jsonb not null,
  updated_at timestamptz not null default now(),
  constraint training_plans_object check (jsonb_typeof(plan) = 'object'),
  constraint training_plans_size check (pg_column_size(plan) <= 4096)
);

alter table training_plans enable row level security;

-- A plan as the phone sent it, kept to what a plan is: the starting best and
-- the goal in reps, three to five days a week, the day it began, and two
-- small tallies — sets done on each day, the best race of each week. Null
-- for anything that is not a plan.
create or replace function plan_clean(p jsonb)
returns jsonb
language plpgsql
immutable
set search_path = public
as $$
declare
  start_reps bigint;
  goal bigint;
  days bigint;
  began bigint;
  done_sets jsonb;
  races jsonb;
begin
  if p is null or jsonb_typeof(p) <> 'object' then
    return null;
  end if;
  start_reps := rewards_int(p, 'start');
  goal := rewards_int(p, 'goal');
  days := rewards_int(p, 'days');
  began := rewards_int(p, 'began');
  if start_reps not between 1 and 300
     or goal not between start_reps + 1 and 300
     or days not between 3 and 5
     or began not between 1 and 200000 then
    return null;
  end if;
  -- Days as day numbers since 1970, the latest sixty: a plan is six weeks.
  select coalesce(jsonb_object_agg(e.key,
           least(greatest(round((e.value #>> '{}')::numeric), 0), 20)::int), '{}'::jsonb)
    into done_sets
    from (select key, value
            from jsonb_each(case when jsonb_typeof(p -> 'sets') = 'object'
                                 then p -> 'sets' else '{}'::jsonb end)
           where key ~ '^[0-9]{1,6}$' and jsonb_typeof(value) = 'number'
           order by key::int desc
           limit 60) e;
  -- Weeks one to six.
  select coalesce(jsonb_object_agg(e.key,
           least(greatest(round((e.value #>> '{}')::numeric), 0), 300)::int), '{}'::jsonb)
    into races
    from (select key, value
            from jsonb_each(case when jsonb_typeof(p -> 'races') = 'object'
                                 then p -> 'races' else '{}'::jsonb end)
           where key ~ '^[1-6]$' and jsonb_typeof(value) = 'number') e;
  return jsonb_build_object('start', start_reps, 'goal', goal, 'days', days,
                            'began', began, 'sets', done_sets, 'races', races);
end;
$$;

-- The caller's plan, or null when they are on none.
create or replace function my_plan()
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select t.plan from training_plans t where t.profile_id = auth.uid();
$$;

-- Keeps [new_plan] as the caller's plan, the latest copy winning: one
-- lifter, one plan, changed only from their own phones. Null stops it.
-- Returns what was kept.
create or replace function save_plan(new_plan jsonb)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  me uuid := auth.uid();
  clean jsonb;
begin
  if me is null then
    raise exception 'not signed in';
  end if;
  if new_plan is null or jsonb_typeof(new_plan) = 'null' then
    delete from training_plans where profile_id = me;
    return null;
  end if;
  clean := plan_clean(new_plan);
  if clean is null then
    raise exception 'not a plan';
  end if;
  insert into training_plans (profile_id, plan, updated_at)
  values (me, clean, now())
  on conflict (profile_id) do update
    set plan = excluded.plan, updated_at = now();
  return clean;
end;
$$;

-- ─────────────────────────────── the minute to race ─────────────────────────────

-- The caller's best whole minute lifted from [since] up to [before], with
-- the times of its reps: what "last week's you" lifted, and how. Only a
-- minute the way challenge_set_ok (challenge.sql) takes one — lifted to the
-- end, with its times — because a race against a count with no pace is a
-- race against a progress bar. Null when there is none.
create or replace function my_best_minute(since timestamptz, before timestamptz)
returns jsonb
language sql
stable
security definer
set search_path = public
as $$
  select jsonb_build_object('reps', s.reps, 'rep_times', to_jsonb(s.rep_times),
                            'at', s.created_at)
    from sets s
   where s.profile_id = auth.uid()
     and s.created_at >= since
     and s.created_at < before
     and challenge_set_ok(s)
   order by s.reps desc, s.created_at desc
   limit 1;
$$;

revoke all on function plan_clean(jsonb) from public, anon, authenticated;
revoke all on function my_plan() from public;
grant execute on function my_plan() to authenticated;
revoke all on function save_plan(jsonb) from public;
grant execute on function save_plan(jsonb) to authenticated;
revoke all on function my_best_minute(timestamptz, timestamptz) from public;
grant execute on function my_best_minute(timestamptz, timestamptz) to authenticated;
