-- ───────────────────────── what a signed-out caller may do ───────────────────
--
-- Runs last, after every table and function exists.
--
-- Supabase grants every new function in `public` to anon and authenticated
-- by name — its default privileges — so the `revoke … from public` in the
-- files before this left anon, a request carrying no session at all, able
-- to call all of them. Most stop there, on a null auth.uid(); a few did not
-- need one to hand something back: a profile, a recorded set, the boards,
-- whether a username is taken.
--
-- Nobody uses the app signed out. A guest has an anonymous session, which is
-- `authenticated`, not anon. The one thing meant for whoever a link reaches
-- is the share card the website draws at /u/<username>.

--
-- From PUBLIC as well: Postgres itself lets PUBLIC — every role, anon among
-- them — run any new function, on top of Supabase's grants. Signed-in
-- callers keep what they had: Supabase granted authenticated each function
-- by name, and the ones taken from authenticated on purpose above (the rate
-- limiter, settling a live match) stay taken.
--
-- This file runs on every install, after everything else, so a function
-- added later is closed the next time install.sql is pasted.
revoke execute on all functions in schema public from public, anon;
alter default privileges in schema public revoke execute on functions from anon;
grant execute on function public_lifter_card(text) to anon;
grant execute on function public_challenge_card(text) to anon;

-- The tables, the same way. Every one has row level security and no policy
-- names anon, so anon already read and wrote nothing; this takes the
-- privilege itself away, so a table added later and given no policy yet is
-- not the exception.
revoke all on all tables in schema public from anon;
revoke all on all sequences in schema public from anon;
alter default privileges in schema public revoke all on tables from anon;
alter default privileges in schema public revoke all on sequences from anon;
