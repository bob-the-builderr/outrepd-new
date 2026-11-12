-- An open app asking for invites, every five seconds per phone.
\set u random(1, :n)
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-' || lpad(to_hex(:u), 12, '0'), false);
set role authenticated;
select count(*) from my_live_invites();
reset role;
