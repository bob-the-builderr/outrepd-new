# The live project's server, as last pasted

`install.sql` here is the installer the live Supabase project was last
brought up to: 1.1.6 (supabase/install.sql as of commit 23f889f), pasted
by the user on 2026-11-02 over 1.1.5 (ba438e5). Checked against the live
project the same day: `friends_board`, `friends_leaderboard`,
`last_month_winners` and `my_week_place` answer an anon call with 42501
(there, and closed to anon).

`../upgrade_seed.sql` and `../upgrade_check.sql` were written for the
1.1.5 → 1.1.6 paste (LP to rating, the boards' points filled in). Against
this 1.1.6 base they check a paste over itself; make them about the next
upgrade when there is one.

CI installs it on a bare Postgres, fills it with accounts and duels
(`../upgrade_seed.sql`), pastes today's `supabase/install.sql` over it twice,
and checks nothing was lost and the new parts were filled in right
(`../upgrade_check.sql`). So the paste that upgrades the live project has
already been run once, over the same server, before anybody runs it there.

Once today's installer has been pasted into the live project, replace this
file with it.
