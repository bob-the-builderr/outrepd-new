-- Searching for a live opponent: every three seconds per phone.
\set u random(1, :n)
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-' || lpad(to_hex(:u), 12, '0'), false);
set role authenticated;
select count(*) from live_online();
select load_try('select count(*) from find_live_opponent()');
reset role;
