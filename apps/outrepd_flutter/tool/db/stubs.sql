-- What a Supabase project already has before install.sql is pasted into it,
-- stood up on a bare Postgres so CI can run the installer for real. Only
-- what the installer touches: the two roles a request runs as, auth.users and
-- auth.uid(), the storage tables the avatar policies are written on, and
-- pg_net's one call. Nothing here is installed on the real project.

create role anon nologin;
create role authenticated nologin;
create role service_role nologin bypassrls;

grant usage on schema public to anon, authenticated, service_role;
alter default privileges in schema public
  grant select, insert, update, delete on tables to anon, authenticated, service_role;

create schema auth;
create table auth.users (id uuid primary key);
grant usage on schema auth to anon, authenticated;

-- Supabase's own definition: the `sub` claim of the request's token.
create function auth.uid() returns uuid
language sql stable
as $$
  select coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;
grant execute on function auth.uid() to anon, authenticated;

create schema storage;
grant usage on schema storage to anon, authenticated;
create table storage.buckets (
  id text primary key,
  name text,
  public boolean,
  file_size_limit bigint,
  allowed_mime_types text[]
);
create table storage.objects (
  id uuid primary key default gen_random_uuid(),
  bucket_id text,
  name text
);
alter table storage.objects enable row level security;
grant select, insert, update, delete on storage.objects to anon, authenticated;
create function storage.foldername(name text) returns text[]
language sql immutable
as $$ select (string_to_array(name, '/'))[1:array_length(string_to_array(name, '/'), 1) - 1] $$;

-- pg_net queues an HTTP call; here it only says it did.
create schema net;
create function net.http_post(url text, headers jsonb, body jsonb)
returns bigint
language sql
as $$ select 1::bigint $$;
