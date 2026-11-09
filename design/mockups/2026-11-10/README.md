# Mockups, 2026-11-10

Beat your past self: a six-week plan built from your best set. Each training
day has short sets that the camera counts. Each Sunday you race your own best
set from the week before. Every phone is 412×915.

- `past_a.html`: A. Once you are on a plan, the home's Today's goal card
  becomes Today's plan.
- `past_b.html`: B. A separate gold "Beat last week's you" card sits above
  Today's goal.
- `past_flow.html`: the plan itself, the same for A and B:
  - setup;
  - the plan page;
  - the race against last week's you;
  - the result.

`past.js` draws the pages, using the helpers and styles in `../2026-11-09`.
The built screens come from the `challenge_home`, `vs_challenge`,
`result_win` and `tab_ranks_top` screens of `ci-results` at cfa9f20. The race
screen puts a grey copy of your own lifter where the opponent's goes.
