---
name: pose-detection-rules
description: Rules that any camera rep counter in OUTREPD must obey — landmark mapping, angle maths, confidence floor, and the checks a repetition has to pass before it scores. Load before touching anything under lib/reps/, adding an exercise definition, or changing how reps are counted or judged.
---

# Counting reps from a camera

The failure this exists to prevent: **a counter that scores any movement.**
Every rule below is one that a naive counter gets wrong, and each is locked by
a test in `apps/outrepd_flutter/test/rep_engine_test.dart`. Change a rule,
change its test, and never delete a test to make a change pass.

## What this project actually uses

ML Kit (`google_mlkit_pose_detection`), addressed by **name**, not index:
`PoseLandmarkType.leftShoulder`. Landmarks are mapped once, in
`lib/reps/pose_source_camera.dart`, into the app's own `Joint` enum. Nothing
downstream touches ML Kit types — that boundary is what lets the engine be
driven by test data and by the browser demo.

ML Kit and MediaPipe BlazePose share the same 33-landmark topology, so the
MediaPipe indices carry over if a reference ever needs them:

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
reach the maths. `z` is depth in the same units as `x`, measured from the
hips, negative toward the camera.

Depth is not optional. The phone stands **in front of** the lifter, because in
a match they have to see their own count and their opponent. Facing the lens,
a pressing arm moves mostly toward it, and a flat picture squashes that motion
to nearly nothing — a 2D angle would barely move through a full push-up.

Depth is estimated from one lens. It is good enough to keep an angle honest
and too noisy to measure with; never build a rule that needs precise `z`.

## The angle

Angle at `vertex`, between the limbs reaching to `a` and `b`, in three
dimensions:

```
u = a - vertex        v = b - vertex
angle = acos( (u · v) / (|u| · |v|) ) in degrees
```

180° is a straight limb, 0° is folded shut. Clamp the cosine to [-1, 1] before
`acos` — floating point drifts outside it and returns NaN, which silently
poisons every downstream comparison.

Measure both sides where visible and average them; a body turned slightly off
square still reads correctly. Fall back to whichever side is visible.

## Confidence floor

**0.7 for anything that feeds a measurement or a rule.** A joint the tracker
is guessing at must not move the meter, satisfy a form gate, or complete a
rep. Guessed joints are the direct cause of phantom reps.

Drawing the skeleton uses a lower floor (0.35) on purpose: a limb vanishing
from the picture is a smaller problem than a limb vanishing from the score.

If too little of the body clears the floor, **pause** — do not guess and do
not score. A bad camera angle must never cost someone a match.

## A repetition scores only if all of these hold

1. The meter entered the **bottom zone** (≤ 0.15 of travel), and
2. then reached the **top zone** (≥ 0.85), and
3. form was good **at the bottom** and **at the top**, and
4. no continuous stretch of bad form longer than **300 ms** in between, and
5. the climb took at least **300 ms**.

Notes that are easy to get wrong:

- **Two zones, not one threshold.** One line means a shiver on it counts twice.
- **Form at the bottom is decided once.** Do not let a later frame in the
  bottom zone overwrite it, or anyone who sags, tidies up, then presses gets a
  free rep.
- **Time the climb, from the last moment at the bottom.** Resting down there
  must not buy credit for a rep that was then jerked up.
- **Keep the minimum time low.** A competitive push-up test runs near a rep a
  second, so an honest climb can be half of that. The full-range requirement,
  not the clock, is what stops cheating.
- **Brief bad form is forgiven.** Under 300 ms is tracker noise, not a person.

## Calibration

Watch a **fixed window** (8 s of slow reps), then take the range from what was
seen, trimmed 8% at each end.

Do not end calibration on the first rep the default thresholds recognise. That
only ever sees the travel those thresholds already covered, so it learns a
truncated range, which compresses the meter and makes every later rep look
rushed. This bug shipped once; do not reintroduce it.

Refuse a range under 25° and keep the definition's own thresholds — standing
still must not teach a range of nothing.

## Adding an exercise

Add a definition to `kExercises` in `lib/reps/exercise.dart`. Never write
counting logic for a specific movement.

A definition names the driving angle, the bottom and top of the travel, and
the form gates. Bottom may be the larger number — a push-up folds shut at the
bottom, a sit-up at the top — so map between the two ends rather than assuming
an order.

Gates carry a phase (`always`, `bottom`, `top`) and a message a lifter can act
on. Depth is the meter's job; a gate never restates it. A gate that cannot be
measured returns null and must **pass** — a half-framed lifter should be
paused, not failed.

## Before claiming it works

Accuracy is the whole product. A counter that is wrong once is not trusted
again, and no amount of surrounding features recovers that.

The engine is pure Dart and driven by synthetic poses, so counting rules are
testable without a camera — write the test. But a green suite proves the rules
hold, not that detection works on a real body: lighting, clothing, camera
angle and phone speed only show up on a device. Say plainly which of the two
has actually been checked.
