-- Somebody's profile opened from a board.
\set u random(1, :n)
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-' || lpad(to_hex(:u), 12, '0'), false);
set role authenticated;
\set o random(1, :n)
select count(*) from lifter_profile(('00000000-0000-4000-8000-' || lpad(to_hex(:o), 12, '0'))::uuid);
select count(*) from lifter_showcase(('00000000-0000-4000-8000-' || lpad(to_hex(:o), 12, '0'))::uuid);
reset role;
