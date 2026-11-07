# Mockups, 2026-11-07

Another player's profile, three directions beside the built screen. Each
phone is 412×915, the real size.

- `other_a.html` — A, the order and cards of your own profile (**picked**,
  with a name opening the profile straight, no quick card first).
- `other_b.html` — B, the match between the two of you first.
- `other_c.html` — C, a big player card in the tier's colours.

`parts.js` is `lib/tier_badge.dart`'s painters; `other.js` draws the pages,
cutting the framed pictures from `now_other.png` and `now_me.png`, the
`store_1320x2868_04-otherprofile` and `tab_profile` screens of `ci-results`.
Page C also needs `now_other_data.js`, left out of git because it is only
`now_other.png` again: `const NOW_OTHER = 'data:image/png;base64,...';`.

Ranks among friends on the Friends tab, the same way:

- `friends_a.html` — A, a section above the list.
- `friends_b.html` — B, Friends and Ranks as a strip (**picked**).
- `friends_c.html` — C, a strip of cards to swipe.

`friends.js` cuts its pictures from `now_friends.png` and `now_ranks_top.png`
(`tab_friends` and `tab_ranks_top` of `ci-results`). The tab bar in these is a
sketch to show the room it takes; the real one is not touched.
