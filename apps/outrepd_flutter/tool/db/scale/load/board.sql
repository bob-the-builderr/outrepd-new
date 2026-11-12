-- The boards opened: this week's, and where I am on it.
\set u random(1, :n)
select set_config('request.jwt.claim.sub', '00000000-0000-4000-8000-' || lpad(to_hex(:u), 12, '0'), false);
set role authenticated;
select count(*) from week_board(null, 100);
select count(*) from my_week_place(null);
select count(*) from friends_board(false);
reset role;
