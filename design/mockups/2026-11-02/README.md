# Mockups, 2026-11-02

The pages the user picked from that day (the rendered PNGs are on the
Desktop in `OUTREPD-ui-cleanup/`):

- `index.html` — direction A vs B for home, friends, settings (B picked).
- `rp.html` — Ranks and Profile in direction B (`data-p="ranks"` or
  `"profile"`).
- `simple_ranks.html` — a simpler Ranks: A one strip, B you first,
  C three cards (A picked).
- `friends_rank.html` — your place among friends: A a Friends tab, B
  Friends beside World/Country, C a card on Friends (B picked).
- `howpoints.html` — where "How points work" goes (A picked).

They draw over CI screenshots: put the `screens/*.png` they name from the
`ci-results` branch next to them (`now/`, `ci_a/`), set `data-p` on
`<body>` to the option, and render with headless Chrome as `CLAUDE.md`
says. Each phone is 412×915, the real size.
