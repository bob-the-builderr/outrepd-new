# The live project's server, as last pasted

`install.sql` here is the installer the live Supabase project was last
brought up to: 1.1.5 (commit ba438e5). Checked against the live project on
2026-11-02 — what 1.1.5 added is there (`my_rewards`, `my_days`,
`live_result_presence`), what came after it is not (`profiles.lifter`,
`last_month_winners`, `duels.pts_challenger`).

CI installs it on a bare Postgres, fills it with accounts and duels
(`../upgrade_seed.sql`), pastes today's `supabase/install.sql` over it twice,
and checks nothing was lost and the new parts were filled in right
(`../upgrade_check.sql`). So the paste that upgrades the live project has
already been run once, over the same server, before anybody runs it there.

Once today's installer has been pasted into the live project, replace this
file with it.
