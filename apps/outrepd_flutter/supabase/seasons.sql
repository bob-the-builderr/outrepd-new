-- ─────────────────────────────── the monthly board ───────────────────────────
--
-- A race that starts again every month, beside the rank that never goes
-- down. The rank is a promise — once a tier is reached it is kept — so the
-- month is not a reset of it but a board of its own: the LP won, less the LP
-- lost, in ranked duels since the month began. Everybody starts the month
-- level, whatever their tier, and at its end the best of it are named for
-- good: #1 Champion, #2–3 Podium, #4–10 Top 10, and a badge for anybody who
-- played twenty ranked duels in it.
--
-- Nothing new is recorded for it. Every duel already carries both sides' LP
-- and when it was played; the board is read from those, through running
-- totals each duel adds itself to (season_points below).
--
-- A month is a calendar month in UTC, named by its first day. It is closed —
-- its awards written, once — by the first request after it ends, so nothing
-- has to be scheduled.

-- The month's duels, found without reading the rest.
create index if not exists duels_ranked_month_idx
  on duels (created_at) where ranked;

create or replace function season_of(at timestamptz)
returns date
language sql
immutable
set search_path = public
as $$
  select (date_trunc('month', at at time zone 'UTC'))::date
$$;

-- What each lifter did in one month, kept as it happens.
--
-- The board used to add up the month's duels every time anybody opened it:
-- fine for a few hundred duels, and most of a second by the end of a month
-- with ten thousand lifters in it, for every lifter who looked. Now each
-- duel adds itself to this table when it is written, and the board reads
-- the totals. Still nothing new is recorded: every row here can be worked
-- out again from the duels (season_points_rebuild), and is, whenever a duel
-- is deleted from under it.
create table if not exists season_points (
  season     date not null,
  profile_id uuid not null references profiles on delete cascade,
  points     int not null default 0,
  wins       int not null default 0,
  played     int not null default 0,
  primary key (season, profile_id)
);
alter table season_points enable row level security;
create index if not exists season_points_profile_idx on season_points (profile_id);
-- The board's order, best first, so showing its top hundred reads a
-- hundred-odd rows rather than sorting the month.
create index if not exists season_points_board_idx
  on season_points (season, points desc, wins desc);

-- Months whose totals no longer match their duels, to be worked out again
-- before anything reads them.
create table if not exists season_points_stale (
  season date primary key
);
alter table season_points_stale enable row level security;

-- The month's totals as the duels have them. `played` counts only the duels
-- they lifted in: racing somebody's set, or either side of a live match.
-- Being raced while away moves their points, as it moves their LP, but it is
-- not a duel they played.
create or replace function season_points_from_duels(of_season date)
returns table (profile_id uuid, points int, wins int, played int)
language sql
stable
security definer
set search_path = public
as $$
  with month_duels as (
    select d.challenger, d.defender, d.winner, d.lp_challenger, d.lp_defender,
           exists (select 1 from live_matches m where m.duel = d.id) as live
      from duels d
     where d.ranked
       and d.created_at >= (of_season::timestamp at time zone 'UTC')
       and d.created_at < ((of_season + interval '1 month')::timestamp at time zone 'UTC')
  ),
  sides as (
    select challenger as profile_id, lp_challenger as lp,
           winner = challenger as won, true as played
      from month_duels
    union all
    select defender, lp_defender, winner = defender, live
      from month_duels
  )
  select profile_id,
         sum(lp)::int,
         (count(*) filter (where won))::int,
         (count(*) filter (where played))::int
    from sides
   group by profile_id
$$;

-- One month's totals worked out again from its duels.
create or replace function season_points_rebuild(of_season date)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  delete from season_points sp where sp.season = of_season;
  insert into season_points (season, profile_id, points, wins, played)
  select of_season, s.profile_id, s.points, s.wins, s.played
    from season_points_from_duels(of_season) s
    -- A side whose account is already gone.
    join profiles p on p.id = s.profile_id;
  delete from season_points_stale st where st.season = of_season;
end;
$$;

-- Every month that needs it, worked out again. Called before the totals are
-- read; nearly always there is nothing to do.
create or replace function season_points_refresh()
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  stale date;
begin
  if not exists (select 1 from season_points_stale) then
    return;
  end if;
  -- One at a time: two rebuilds of the same month would add it up twice.
  perform pg_advisory_xact_lock(hashtext('outrepd.season_points'));
  for stale in select st.season from season_points_stale st loop
    perform season_points_rebuild(stale);
  end loop;
end;
$$;

-- A duel adds itself to its month. Deferred to the end of the transaction
-- that wrote it: a live match names its duel only after the duel is written
-- (settle_live), and whether it was live decides whether the defender
-- played it. Read back from the table rather than from NEW, which is the row
-- as it was first inserted.
create or replace function season_points_add()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  d duels;
  defender_played boolean;
  this_season date;
begin
  select * into d from duels where id = new.id;
  if d.id is null or not d.ranked then
    return null;
  end if;
  this_season := season_of(d.created_at);
  defender_played := exists (select 1 from live_matches m where m.duel = d.id);
  insert into season_points as sp (season, profile_id, points, wins, played)
  values (this_season, d.challenger, d.lp_challenger,
          (d.winner = d.challenger)::int, 1)
  on conflict (season, profile_id) do update
    set points = sp.points + excluded.points,
        wins = sp.wins + excluded.wins,
        played = sp.played + excluded.played;
  insert into season_points as sp (season, profile_id, points, wins, played)
  values (this_season, d.defender, d.lp_defender,
          (d.winner = d.defender)::int, defender_played::int)
  on conflict (season, profile_id) do update
    set points = sp.points + excluded.points,
        wins = sp.wins + excluded.wins,
        played = sp.played + excluded.played;
  return null;
end;
$$;

drop trigger if exists season_points_add on duels;
create constraint trigger season_points_add
  after insert on duels
  deferrable initially deferred
  for each row execute function season_points_add();

-- A deleted duel (an account deleted, and its duels with it) leaves its
-- month to be worked out again: the totals were always the duels that are
-- there, and the other side's points from it go with it.
create or replace function season_points_forget()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if old.ranked then
    insert into season_points_stale (season) values (season_of(old.created_at))
    on conflict (season) do nothing;
  end if;
  return null;
end;
$$;

drop trigger if exists season_points_forget on duels;
create trigger season_points_forget
  after delete on duels
  for each row execute function season_points_forget();

-- The first install of this table: every month already played is worked
-- out from its duels the first time it is read.
do $$
begin
  if not exists (select 1 from season_points) then
    insert into season_points_stale (season)
    select distinct season_of(d.created_at) from duels d where d.ranked
    on conflict (season) do nothing;
  end if;
end $$;

-- What each lifter did in one month: the totals above.
create or replace function season_standings(of_season date)
returns table (profile_id uuid, points int, wins int, played int)
language sql
stable
security definer
set search_path = public
as $$
  select sp.profile_id, sp.points, sp.wins, sp.played
    from season_points sp
   where sp.season = of_season
$$;

-- The places, among the lifters a board shows: placed, and not asked to be
-- left off. Ties go to more wins, then to the name, so a place never moves
-- between two readings of the same duels.
create or replace function season_places(of_season date, in_country text default null)
returns table (place int, profile_id uuid, points int, wins int, played int)
language sql
stable
security definer
set search_path = public
as $$
  select (row_number() over (order by s.points desc, s.wins desc, p.username))::int,
         s.profile_id, s.points, s.wins, s.played
    from season_standings(of_season) s
    join profiles p on p.id = s.profile_id
   where p.placements_done >= 5
     and p.show_on_board
     and (in_country is null or (p.country = in_country and p.show_country))
$$;

-- ── the board ─────────────────────────────────────────────────────────────────

create or replace function month_board(in_country text default null, limit_to int default 100)
returns table (
  place int,
  id uuid,
  username text,
  tier_idx int,
  div_idx int,
  points int,
  wins int,
  played int,
  avatar_url text
)
language plpgsql
security definer
set search_path = public
as $$
begin
  perform season_points_refresh();
  -- season_places' rules and order, written out rather than called: a
  -- security definer function is never folded into the query that calls
  -- it, so calling it ranked every lifter in the month to hand back a
  -- hundred. Here the limit reaches the ranking, and it stops at the last
  -- place shown (season_points_board_idx).
  return query
  select (row_number() over (order by sp.points desc, sp.wins desc, p.username))::int,
         p.id, p.username, p.tier_idx, p.div_idx, sp.points, sp.wins,
         sp.played, p.avatar_url
    from season_points sp
    join profiles p on p.id = sp.profile_id
   where sp.season = season_of(now())
     and p.placements_done >= 5
     and p.show_on_board
     and (in_country is null or (p.country = in_country and p.show_country))
   -- The place's own order, spelled out: ordered by the place itself, the
   -- whole month is ranked before the limit can stop it.
   order by sp.points desc, sp.wins desc, p.username
   limit least(greatest(limit_to, 1), 500);
end;
$$;

-- Where the caller stands this month, and when it ends. Also closes any month
-- that has ended — this is called each time the app opens the board, which
-- makes it the first request after a month ends.
create or replace function my_month_place()
returns table (
  season date,
  ends_at timestamptz,
  place int,
  of_total int,
  points int,
  wins int,
  played int
)
language plpgsql
security definer
set search_path = public
as $$
declare
  this_season date := season_of(now());
  mine season_points;
  me profiles;
begin
  perform season_points_refresh();
  perform close_finished_seasons();
  select * into mine from season_points sp
   where sp.season = this_season and sp.profile_id = auth.uid();
  select * into me from profiles p where p.id = auth.uid();
  -- The place is how many on the board are ahead, by season_places' order
  -- (more points, then more wins, then the name), counted rather than
  -- ranking everybody to find one row. Null off the board: no duel this
  -- month, still in placements, or asked to be left off.
  return query
  select this_season,
         ((this_season + interval '1 month')::timestamp at time zone 'UTC'),
         case when mine.profile_id is not null
                   and me.placements_done >= 5 and me.show_on_board then (
           select count(*)::int + 1
             from season_points sp
             join profiles p on p.id = sp.profile_id
            where sp.season = this_season
              and p.placements_done >= 5
              and p.show_on_board
              and (sp.points > mine.points
                or (sp.points = mine.points and sp.wins > mine.wins)
                or (sp.points = mine.points and sp.wins = mine.wins
                    and p.username < me.username))
         ) end,
         (select count(*)::int
            from season_points sp
            join profiles p on p.id = sp.profile_id
           where sp.season = this_season
             and p.placements_done >= 5
             and p.show_on_board),
         coalesce(mine.points, 0),
         coalesce(mine.wins, 0),
         coalesce(mine.played, 0);
end;
$$;

-- ── closing a month ───────────────────────────────────────────────────────────

create table if not exists season_awards (
  season     date not null,
  profile_id uuid not null references profiles on delete cascade,
  award      text not null check (award in ('champion', 'podium', 'top10', 'regular')),
  -- On the board, for the three that come from a place; null for the badge.
  place      int,
  points     int not null,
  played     int not null,
  -- When the lifter was shown it, so the app tells them once.
  seen_at    timestamptz,
  created_at timestamptz not null default now(),
  primary key (season, profile_id, award)
);
alter table season_awards enable row level security;
create index if not exists season_awards_profile_idx on season_awards (profile_id);

create table if not exists season_closings (
  season    date primary key,
  closed_at timestamptz not null default now()
);
alter table season_closings enable row level security;

-- Every month that has ended and is not closed yet, oldest first. Of two
-- requests at once, the one whose insert lands closes it; the other waits on
-- that row and then skips the month.
create or replace function close_finished_seasons()
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  this_season date := season_of(now());
  next_open date;
begin
  select coalesce(
           (select (max(season) + interval '1 month')::date from season_closings),
           (select season_of(min(created_at)) from duels where ranked))
    into next_open;
  if next_open is null then
    return;
  end if;

  -- Awards are written from the totals, so they are made right first.
  perform season_points_refresh();
  while next_open < this_season loop
    insert into season_closings (season) values (next_open)
    on conflict (season) do nothing;
    if found then
      -- The three from a place, for points actually won.
      insert into season_awards (season, profile_id, award, place, points, played)
      select next_open, s.profile_id,
             case when s.place = 1 then 'champion'
                  when s.place <= 3 then 'podium'
                  else 'top10' end,
             s.place, s.points, s.played
        from season_places(next_open) s
       where s.place <= 10 and s.points > 0;
      -- The badge, for showing up: twenty duels lifted in, anywhere.
      insert into season_awards (season, profile_id, award, place, points, played)
      select next_open, s.profile_id, 'regular', null, s.points, s.played
        from season_standings(next_open) s
        join profiles p on p.id = s.profile_id
       where s.played >= 20;
    end if;
    next_open := (next_open + interval '1 month')::date;
  end loop;
end;
$$;

-- The caller's awards, newest first, for the profile and for telling them.
create or replace function my_season_awards()
returns table (season date, award text, place int, points int, played int, seen bool)
language plpgsql
security definer
set search_path = public
as $$
begin
  perform close_finished_seasons();
  return query
  select a.season, a.award, a.place, a.points, a.played, a.seen_at is not null
    from season_awards a
   where a.profile_id = auth.uid()
   order by a.season desc, a.place nulls last;
end;
$$;

create or replace function mark_season_awards_seen()
returns void
language sql
security definer
set search_path = public
as $$
  update season_awards set seen_at = now()
   where profile_id = auth.uid() and seen_at is null;
$$;

-- Another lifter's awards, for their profile card. Nothing to hide in them —
-- they are on the board for everyone — except to somebody they blocked or
-- who blocked them, who sees nothing of that profile at all.
create or replace function lifter_season_awards(their_id uuid)
returns table (season date, award text, place int)
language sql
stable
security definer
set search_path = public
as $$
  select a.season, a.award, a.place
    from season_awards a
   where a.profile_id = their_id
     and not exists (
       select 1 from blocks b
        where (b.blocker = auth.uid() and b.blocked = their_id)
           or (b.blocker = their_id and b.blocked = auth.uid())
     )
   order by a.season desc, a.place nulls last;
$$;

revoke all on function season_points_from_duels(date) from public, anon, authenticated;
revoke all on function season_points_rebuild(date) from public, anon, authenticated;
revoke all on function season_points_refresh() from public, anon, authenticated;
revoke all on function season_points_add() from public, anon, authenticated;
revoke all on function season_points_forget() from public, anon, authenticated;
revoke all on function season_standings(date) from public, anon, authenticated;
revoke all on function season_places(date, text) from public, anon, authenticated;
revoke all on function close_finished_seasons() from public, anon, authenticated;
revoke all on function month_board(text, int) from public, anon;
grant execute on function month_board(text, int) to authenticated;
revoke all on function my_month_place() from public, anon;
grant execute on function my_month_place() to authenticated;
revoke all on function my_season_awards() from public, anon;
grant execute on function my_season_awards() to authenticated;
revoke all on function mark_season_awards_seen() from public, anon;
grant execute on function mark_season_awards_seen() to authenticated;
revoke all on function lifter_season_awards(uuid) from public, anon;
grant execute on function lifter_season_awards(uuid) to authenticated;
