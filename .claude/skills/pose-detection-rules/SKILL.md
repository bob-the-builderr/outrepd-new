---
name: pose-detection-rules
description: Rules that any camera rep counter in OUTREPD must obey — landmark mapping, the push-up signal, confidence floor, and the checks a repetition has to pass before it scores. Load before touching anything under lib/reps/, or changing how reps are counted, judged, or drawn on the bar.
---

# Counting reps from a camera

The failure this exists to prevent: **a counter that scores any movement** —
and its twin, **a counter that misses real reps**. Every rule below is one that
a naive counter gets wrong. They are locked by tests in
`apps/outrepd_flutter/test/counting_test.dart` (synthetic, through the actual
screen) and `test/replay_test.dart` (fourteen labelled real sets). Change a
rule, change its test, and never delete a test to make a change pass.

## What this project actually uses

ML Kit (`google_mlkit_pose_detection`), addressed by **name**, not index:
`PoseLandmarkType.leftShoulder`. Landmarks are mapped once, in
`lib/reps/pose_source_camera.dart`, into the app's own `Joint` enum. Nothing
downstream touches ML Kit types — that boundary is what lets the counter be
driven by test data and by the browser demo.

ML Kit and MediaPipe BlazePose share the same 33-landmark topology, so the
MediaPipe indices carry over (the offline bench extracts poses with MediaPipe):

| Index | Landmark | `Joint` |
|---|---|---|
| 0 | nose | `nose` |
| 11 / 12 | left / right shoulder | `leftShoulder` / `rightShoulder` |
| 13 / 14 | left / right elbow | `leftElbow` / `rightElbow` |
| 15 / 16 | left / right wrist | `leftWrist` / `rightWrist` |
| 23 / 24 | left / right hip | `leftHip` / `rightHip` |
| 25 / 26 | left / right knee | `leftKnee` / `rightKnee` |
| 27 / 28 | left / right ankle | `leftAnkle` / `rightAnkle` |

Odd indices are the left side, even the right. Do **not** introduce numeric
indices into app code; add to the `Joint` enum and the mapping instead.

## Coordinates

Normalised to 0..1 across the frame, so resolution and letterboxing never
reach the maths.

The phone stands **in front of** the lifter, on the floor, because in a match
they have to see their own count and their opponent. Head-on, the arm and the
torso project onto nearly the same line — an arm-to-body angle reads 3–6°
through real push-ups — and the ankles are hidden in most frames. Never build
a rule on an angle, on the ankles, or on precise `z`.

## Confidence floor

**0.7 for anything that feeds a measurement or a rule.** A joint the tracker
is guessing at must not move the bar or complete a rep. Guessed joints are the
direct cause of phantom reps.

Drawing the skeleton uses a lower floor (0.35) on purpose: a limb vanishing
from the picture is a smaller problem than a limb vanishing from the score.

## The signal — one, and the bar is it

`lib/reps/pushup_counter.dart`, `PushupTracker`. **The nose's height above the
planted hands, in shoulder widths.** On all fourteen labelled sets, across
cameras and angles, it sits near **1.0 at lockout** and near the floor at the
bottom of a full rep.

- **The bar** is that height as a share of *this lifter's* lockout (median of
  the last five tops, seeded with two priors of 1.0; tops outside 0.6–1.8× the
  reference are not tops). 0 on the floor, 1 at the top.
- **The number and the bar come from the same tracker on the same frame.**
  Never add a second counter for the screen, and never re-score the set at the
  end with something else: a lifter watching one number and being handed
  another is how this app lost trust before.
- **Everything is timed in milliseconds**, never in frames. A 120 fps clip
  once counted six push-ups as twenty because every window was a frame count.
  Poses carry no timestamp: the screen stamps them with `clock.stopwatch()`
  (package:clock), which also follows a widget test's fake clock.
- Shoulder width is the 80th percentile of the last 3 s — it only ever reads
  wrong *low* (one shoulder hides behind the other at an angle).

## A repetition scores only if all of these hold

1. The bar went **down to 0.5 or lower** (the bottom line), and
2. then came **back up to 0.75 or higher** (the top line), and
3. the **hands were planted** at that moment (at most 35% of the last 0.4 s
   with a hand off its floor point), and
4. at least **0.35 s** since the last rep, and
5. the tracker was armed: it had seen the body at the top with the hands
   down (or the hands settled after a top, before the bottom line).

Notes that are easy to get wrong:

- **Two lines, not one.** One line means a shiver on it counts twice.
- **Half means half.** Every real rep bottomed at 0.05–0.44 of lockout (one at
  0.50); deliberate half reps stopped at 0.59–0.79. Do not loosen the bottom
  line to rescue a set; find out why the reading was wrong.
- **The top line is below lockout on purpose** — tired arms stop short of
  locking out, and the count lands the moment the bar crosses it.
- **Hands, not body shape.** A push-up is the one movement where the hands
  stay planted and the body travels to them. Floor points are per hand,
  tolerate a label swap onto the other hand's point, re-plant a hand unseen
  for 1 s, and re-plant a hand settled somewhere new for 0.8 s. Getting up at
  the end is refused because the hands leave the floor before the head gets
  back to the top line.
- **The round restarts the count, not the tracker.** The screen runs the
  tracker from the moment the camera opens so it already knows the hands and
  lockout when the countdown ends (`restartCount`). A rep already on its way
  up at the whistle does not count.
- **Unsure, not wrong.** A rep that bottomed within 0.05 under the line, a dip
  that stopped within 0.05 above it, or a swing refused for a hand off the
  floor — *between the first and last rep* — marks the set unsure, and the
  confirm screen asks. A miss must never be reported as certain.

## Before claiming it works

Accuracy is the whole product. A counter that is wrong once is not trusted
again, and no amount of surrounding features recovers that.

1. **Replay the labelled sets**: `flutter test test/replay_test.dart` (floor:
   every set within one, nine in ten exact).
2. **Keep the Python reference in step**: `D:/outrepd-tools/bench/counter.py`
   mirrors the Dart line for line and must print the same counts; `sweep.py`
   checks each setting sits on a plateau, not a knife edge.
3. **Synthetic bodies must have real proportions** — nose about 1.0 shoulder
   width above the hands at lockout (`test/support/synthetic_poses.dart`). A
   body drawn any other way tests a counter against nobody.

A green suite proves the rules hold on recordings, not that detection works on
a real body: lighting, clothing, camera angle and phone speed only show up on
a device. Say plainly which of the two has actually been checked.
