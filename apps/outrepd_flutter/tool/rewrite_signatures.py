"""Rewrites the movement signatures from the measured channel table.

The numbers below are medians and extremes read off the fourteen recordings by
signature_probe_test, not guesses:

  movement   shoulder-median  torso-median  wrist-median  wrist-min
  curl              32              1           +0.7        -2.3
  overhead          40              5           +0.5        -5.1
  pull-up          162              2           -0.8        -1.3
  row               57             34           +1.3        -0.9
  bench             62             42           -0.3        -3.1
  squat             56              7           +0.1        -0.1
  deadlift          33             16           +1.3         1.0
  push-up           72             58           +1.3        -0.0
"""

import io

CATALOGUE = '''/// Pressing something away from a lying or reclined torso: bench, chest press,
/// close-grip work.
///
/// Told from a push-up by where the hands are: pressing off a bench puts them
/// above the chest, pressing off the floor puts them below the shoulders. And
/// told from a curl by the shoulder, which travels through sixty degrees here
/// and barely moves in a curl.
const kPressHorizontal = MovementSignature('bench press', [
  Moves(Channel.elbow, 40, 'Bend and straighten the arms fully'),
  Moves(Channel.shoulder, 30, 'Press away from your chest, not just at the elbow'),
  Within(Channel.wristHeight, -3.5, 0.6, 'Hands go above your chest'),
  Within(Channel.torsoPitch, 20, 90, 'Lie back to press'),
]);

/// Pressing overhead: shoulder press, push press, military, Arnold.
///
/// The hands finish above the head — a wrist height of -5 in the recordings
/// where a curl reaches -2.3 at its most generous. That single fact is what
/// separates the two, and only a rule about where a movement REACHES can see
/// it; both have near-identical medians.
const kPressOverhead = MovementSignature('overhead press', [
  Moves(Channel.elbow, 40, 'Bend and straighten the arms fully'),
  Moves(Channel.shoulder, 40, 'Take it all the way overhead'),
  Reaches(Channel.wristHeight, -2.6, 'Finish with the hands above your head',
      above: false),
  Within(Channel.torsoPitch, 0, 30, 'Stand or sit tall'),
]);

/// The elbow bending with the upper arm parked: every curl.
///
/// Upright, hands never above the head, shoulder still. A press fails the last
/// of those and an overhead press fails the middle one.
const kCurl = MovementSignature('curl', [
  Moves(Channel.elbow, 40, 'Bend and straighten the arms fully'),
  Holds(Channel.shoulder, 55, 'Keep the upper arm still'),
  Within(Channel.torsoPitch, 0, 22, 'Stand tall'),
  Within(Channel.wristHeight, -1.2, 2.5, 'Hands stay below the shoulders'),
]);

/// The elbow straightening with the upper arm parked: pushdowns,
/// skullcrushers, kickbacks, overhead extensions.
const kExtension = MovementSignature('triceps extension', [
  Moves(Channel.elbow, 40, 'Bend and straighten the arms fully'),
  Holds(Channel.shoulder, 55, 'Keep the upper arm still'),
  Within(Channel.torsoPitch, 0, 40, 'Stay tall'),
]);

/// Pulling something towards you with the torso tipped: every row.
///
/// The hinge is the tell. A row is performed bent over — a torso pitch near 34
/// in the recordings — where a curl stands at 1 and a pulldown at 2.
const kRow = MovementSignature('row', [
  Moves(Channel.elbow, 35, 'Pull all the way in'),
  Moves(Channel.shoulder, 25, 'Drive the elbows back'),
  Within(Channel.torsoPitch, 18, 75, 'Hinge over — this round is a row'),
  Within(Channel.wristHeight, 0.3, 3.0, 'Hands stay below your chest'),
]);

/// Pulling down from above: pulldowns, pull-ups, chin-ups.
///
/// Unmistakable once measured: the shoulder sits at 162 degrees through the
/// whole set because the arms are overhead the entire time. Nothing else in
/// the catalogue passes 72.
const kPulldown = MovementSignature('pulldown', [
  Moves(Channel.elbow, 40, 'Pull all the way down'),
  Within(Channel.shoulder, 110, 180, 'Start with the arms overhead'),
  Within(Channel.wristHeight, -3.0, 0.2, 'Hands stay above your shoulders'),
]);

/// The arm sweeping at the shoulder with the elbow fixed: raises, flyes,
/// crossovers, pullovers.
const kRaise = MovementSignature('lateral raise', [
  Moves(Channel.shoulder, 35, 'Take the arms further out'),
  Holds(Channel.elbow, 55, 'Keep the elbows fixed'),
  Within(Channel.torsoPitch, 0, 35, 'Stay tall'),
]);

/// The knee bending under an upright torso: squats, leg press, lunges.
///
/// The knee separates this from a hinge cleanly: a squat's knee travels 118
/// degrees in the recordings, a deadlift's 31.
const kSquat = MovementSignature('squat', [
  Moves(Channel.knee, 45, 'Go deeper'),
  Moves(Channel.hip, 30, 'Sit back as you descend'),
  Within(Channel.torsoPitch, 0, 40, 'Keep the chest up'),
  Holds(Channel.elbow, 60, 'The arms stay out of this one'),
]);

/// Folding at the hip with the knees fairly straight: deadlifts, good
/// mornings, hinges, bridges, most ab work.
const kHinge = MovementSignature('hinge', [
  Moves(Channel.hip, 40, 'Fold further at the hips'),
  Holds(Channel.knee, 55, 'Keep the knees mostly straight'),
  Holds(Channel.elbow, 60, 'Let the arms hang'),
]);

/// Body held in a line, elbows bending: push-ups and their variants.
///
/// No rule on the hip. A real push-up's hip angle reads a range near 95 in the
/// recordings — the estimate is noisy when the body is horizontal and
/// foreshortened — so asking it to hold still refuses every honest rep.
const kPushup = MovementSignature('push-up', [
  Moves(Channel.elbow, 35, 'Go all the way down'),
  Within(Channel.torsoPitch, 40, 90, 'Get into a push-up position'),
  Within(Channel.wristHeight, 0.4, 3.0, 'Hands go under your shoulders'),
]);

/// Rising onto the toes.
const kCalfRaise = MovementSignature('calf raise', [
  Holds(Channel.knee, 40, 'Keep the legs straight'),
  Holds(Channel.hip, 40, 'Only the ankles move'),
  Holds(Channel.elbow, 60, 'Only the ankles move'),
]);

'''

path = 'lib/reps/signature_catalogue.dart'
t = io.open(path, encoding='utf-8').read()
start = t.index('/// Pressing something away')
end = t.index('/// Everything the verifier weighs')
io.open(path, 'w', encoding='utf-8', newline='\n').write(
    t[:start] + CATALOGUE + t[end:])
print('signatures rewritten from the measured table')
