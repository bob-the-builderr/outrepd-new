-- OUTREPD — push notifications.
--
-- notify.sql writes a notice when somebody races your set, asks to be your
-- friend, accepts, or wants a rematch. Until this file you only saw it the
-- next time you happened to open the app. Now each new notice is also sent
-- to the phones signed in to the account, through Firebase.
--
-- Three pieces:
--   push_tokens          each phone's Firebase address, and the language the
--                        app on it is in, so a push reads like the app does.
--   register/forget      the only way a phone writes that table: as the
--                        signed-in account, and only its own rows.
--   a trigger            on every new notice, calls the `push` edge function
--                        with the notice's id and nothing else.
--
-- Nothing here holds a secret. The function looks the notice up itself with
-- the service key Supabase gives every edge function, and marks it pushed as
-- it sends, so a call can only ever push a notice once — whoever makes it.
-- See supabase/functions/push/index.ts for deploying it.

create table if not exists push_tokens (
  token       text primary key,
  profile_id  uuid not null references profiles on delete cascade,
  platform    text not null default 'android'
              check (platform in ('android', 'ios')),
  -- A language the app ships in; the function falls back to English.
  language    text not null default 'en',
  updated_at  timestamptz not null default now()
);

create index if not exists push_tokens_profile_idx on push_tokens (profile_id);

-- No policies: nobody reads or writes it directly. The functions below are
-- the whole of the phone's access, and the edge function uses the service key.
alter table push_tokens enable row level security;

-- When a notice went out. Set by the edge function as it sends, and the
-- reason a second call for the same notice sends nothing.
alter table notifications add column if not exists pushed_at timestamptz;

-- This phone is where the signed-in account's pushes go. A token already on
-- another account moves: a phone gets one address, and whoever signed in on
-- it last is who it belongs to.
create or replace function register_push_token(
  push_token text,
  push_platform text default 'android',
  push_language text default 'en'
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'not signed in';
  end if;
  if push_token is null or length(push_token) < 20 or length(push_token) > 4096 then
    raise exception 'not a push token';
  end if;

  insert into push_tokens (token, profile_id, platform, language, updated_at)
  values (
    push_token,
    auth.uid(),
    case when push_platform = 'ios' then 'ios' else 'android' end,
    coalesce(nullif(left(push_language, 8), ''), 'en'),
    now()
  )
  on conflict (token) do update
    set profile_id = excluded.profile_id,
        platform   = excluded.platform,
        language   = excluded.language,
        updated_at = excluded.updated_at;
end;
$$;

revoke all on function register_push_token(text, text, text) from public, anon;
grant execute on function register_push_token(text, text, text) to authenticated;

-- Before signing out: this phone stops getting the account's pushes. Only
-- the account's own row; somebody else's token is not this account's to drop.
create or replace function forget_push_token(push_token text)
returns void
language sql
security definer
set search_path = public
as $$
  delete from push_tokens
   where token = push_token
     and profile_id = auth.uid();
$$;

revoke all on function forget_push_token(text) from public, anon;
grant execute on function forget_push_token(text) to authenticated;

-- Every new notice is handed to the `push` edge function. pg_net queues the
-- call and returns at once, so storing the notice never waits on Firebase;
-- and any failure here is swallowed, because a push that cannot be sent must
-- never be the reason a notice is not stored.
create extension if not exists pg_net;

create or replace function send_push()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  begin
    perform net.http_post(
      url := 'https://pzhdakzjbjyxhspymjhb.supabase.co/functions/v1/push',
      headers := jsonb_build_object('Content-Type', 'application/json'),
      body := jsonb_build_object('id', new.id)
    );
  exception when others then
    raise warning 'push not queued: %', sqlerrm;
  end;
  return new;
end;
$$;

revoke all on function send_push() from public, anon, authenticated;

drop trigger if exists send_push on notifications;
create trigger send_push
  after insert on notifications
  for each row execute function send_push();
