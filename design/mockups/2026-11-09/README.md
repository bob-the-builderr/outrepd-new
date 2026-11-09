# Mockups, 2026-11-09

A challenge by link: send your set, a friend opens the link and tries to beat
it. Each phone is 412×915, the real size, beside the built screen.

- `challenge_a.html`: A. The Share button stays, and its match card carries
  "Can you beat 18?" and the challenge link.
- `challenge_b.html`: B. Share becomes a Challenge button, and it sends a card
  with one big number.
- `challenge_c.html`: C. A "Challenge a friend" card on the home screen that
  sends your best set.
- `challenge_flow.html`: what happens after the link is sent, the same for A,
  B and C:
  - the website page for someone without the app;
  - the challenge opened in the app;
  - the taker's result, with everyone who took it;
  - the sender's push and their "Your challenge" page.

`challenge.js` draws the pages. Faces are cut from screens on the `ci-results`
branch, so each person keeps one face:

- `now_result_win.png` is `result_win`. The sender, "mokhtar", is its "You".
- `now_ranks_top.png` is `tab_ranks_top`. It gives iron_mike, squat_queen and
  benchgod.
- `now_tab_match.png` is `tab_match`.

The chat is an example messenger.

Rewarded ads: a short video the player chooses to watch, for something that
never touches the ranked ladder. Pro gets the reward with no video, and
watching one means no interstitial after that match. The pages load
`challenge.js` for its helpers.

- `rewarded_a.html`: A. "Double it" on the result screen's XP card.
- `rewarded_b.html`: B. A home card that brings back a streak the rest days
  could not cover, once a week.
- `rewarded_c.html`: C. A locked Pro part can be worn free for a day.

Pictures come from the `result_win`, `tab_match`, `tab_profile` and
`pro_parts_1` screens of `ci-results`.
