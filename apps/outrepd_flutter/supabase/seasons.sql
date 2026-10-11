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
-- and when it was played; the board is read from those.
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

-- What each lifter did in one month. `played` counts only the duels they
-- lifted in: racing somebody's set, or either side of a live match. Being
-- raced while away moves their points, as it moves their LP, but it is not
-- a duel they played.
create or replace function season_standings(of_season date)
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
language sql
stable
security definer
set search_path = public
as $$
  select s.place, p.id, p.username, p.tier_idx, p.div_idx, s.points, s.wins,
         s.played, p.avatar_url
    from season_places(season_of(now()), in_country) s
    join profiles p on p.id = s.profile_id
   order by s.place
   limit least(greatest(limit_to, 1), 500);
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
begin
  perform close_finished_seasons();
  return query
  with places as (select * from season_places(this_season)),
       mine as (select * from season_standings(this_season) s where s.profile_id = auth.uid())
  select this_season,
         ((this_season + interval '1 month')::timestamp at time zone 'UTC'),
         (select pl.place from places pl where pl.profile_id = auth.uid()),
         (select count(*)::int from places),
         coalesce((select m.points from mine m), 0),
         coalesce((select m.wins from mine m), 0),
         coalesce((select m.played from mine m), 0);
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
