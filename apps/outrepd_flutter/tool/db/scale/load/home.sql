-- The home screen opened.
\set u random(1, :n)
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-' || lpad(to_hex(:u), 12, '0'), false);
set role authenticated;
select * from profiles where id = auth.uid();
select unread_notifications();
select count(*) from my_challenges();
select count(*) from my_plan();
select count(*) from my_rewards();
reset role;
