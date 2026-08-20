/// What each movement in the catalogue must look like.
///
/// The five patterns in `exercise_patterns.dart` make eighty exercises
/// countable. These signatures make them *distinguishable*, which is a
/// different job: a curl and an overhead press share the elbow-bend pattern
/// entirely, and only the shoulder tells them apart.
///
/// Ten signatures cover the catalogue. They are deliberately coarse. The
/// question is never "was that a good bench press" — the meter's zones already
/// judge depth — it is only "was that a press rather than a curl". Bands wide
/// enough to hold every body type still separate movements that use different
/// joints, and a tight band would refuse real reps from people built
/// differently, which is the worse failure by far.
library;

import 'movement_signature.dart';

/// Every band below comes from  run over the
/// recorded clips, not from imagination. The first version of this file was
/// written from what the movements *ought* to measure and it refused every
/// push-up in the set: it asked the hip to hold within 30 degrees when a real
/// push-up's hip reads a range of 95, and it put the bench press band at a
/// torso pitch of 45 when a real bench measures 42.
///
/// Where a first guess and a measurement disagree, the measurement is right.

/// Pressing something away from a lying or reclined torso: bench, chest press,
/// dips, close-grip work.
///
/// Told from a push-up by where the hands are: pressing up off a bench puts
/// them above the chest (measured -0.3 torso lengths), pressing up off the
/// floor puts them below the shoulders (+1.3). That sign holds at any camera
/// angle, which nothing about the torso does.
const kPressHorizontal = MovementSignature('bench press', [
  Moves(Channel.elbow, 40, 'Bend and straighten the arms fully'),
  Within(Channel.wristHeight, -3.5, 0.4, 'Hands go above your chest'),
]);

/// Pressing overhead: shoulder press, push press, military, Arnold.
const kPressOverhead = MovementSignature('overhead press', [
  Moves(Channel.elbow, 40, 'Bend and straighten the arms fully'),
  Moves(Channel.shoulder, 40, 'Take it all the way overhead'),
  Within(Channel.torsoPitch, 0, 50, 'Stand or sit tall'),
  Within(Channel.wristHeight, -3.5, 0.3, 'Finish with the hands above you'),
]);

/// The elbow bending with the upper arm parked: every curl.
///
/// The shoulder is the whole test. A bench set moves it through 163 degrees
/// and a curl cannot, so this one rule is what stops a round of presses being
/// farmed with curls and the reverse.
const kCurl = MovementSignature('curl', [
  Moves(Channel.elbow, 40, 'Bend and straighten the arms fully'),
  Holds(Channel.shoulder, 45, 'Keep the upper arm still'),
  Within(Channel.torsoPitch, 0, 50, 'Stand tall'),
  Within(Channel.wristHeight, -0.4, 2.5, 'Hands stay below the shoulders'),
]);

/// The elbow straightening with the upper arm parked: pushdowns,
/// skullcrushers, kickbacks, overhead extensions.
const kExtension = MovementSignature('triceps extension', [
  Moves(Channel.elbow, 40, 'Bend and straighten the arms fully'),
  Holds(Channel.shoulder, 45, 'Keep the upper arm still'),
]);

/// Pulling something towards you with the torso tipped: every row.
const kRow = MovementSignature('row', [
  Moves(Channel.elbow, 35, 'Pull all the way in'),
  Moves(Channel.shoulder, 25, 'Drive the elbows back'),
  Within(Channel.torsoPitch, 20, 85, 'Hinge over — this round is a row'),
]);

/// Pulling down from above: pulldowns, pull-ups, chin-ups.
const kPulldown = MovementSignature('pulldown', [
  Moves(Channel.elbow, 40, 'Pull all the way down'),
  Moves(Channel.shoulder, 35, 'Start with the arms overhead'),
  Within(Channel.wristHeight, -3.5, 0.2, 'Hands start above your head'),
]);

/// The arm sweeping at the shoulder with the elbow fixed: raises, flyes,
/// crossovers, pullovers.
const kRaise = MovementSignature('lateral raise', [
  Moves(Channel.shoulder, 35, 'Take the arms further out'),
  Holds(Channel.elbow, 55, 'Keep the elbows fixed'),
  Within(Channel.torsoPitch, 0, 60, 'Stay tall'),
]);

/// The knee bending under an upright torso: squats, leg press, lunges.
///
/// The knee separates this from a hinge cleanly: a squat's knee travels 118
/// degrees in the recordings, a deadlift's 31.
const kSquat = MovementSignature('squat', [
  Moves(Channel.knee, 45, 'Go deeper'),
  Moves(Channel.hip, 30, 'Sit back as you descend'),
  Within(Channel.torsoPitch, 0, 50, 'Keep the chest up'),
]);

/// Folding at the hip with the knees fairly straight: deadlifts, good
/// mornings, hinges, bridges, most ab work.
const kHinge = MovementSignature('hinge', [
  Moves(Channel.hip, 40, 'Fold further at the hips'),
  Holds(Channel.knee, 55, 'Keep the knees mostly straight'),
]);

/// Body held in a line, elbows bending: push-ups and their variants.
///
/// No rule on the hip. A real push-up's hip angle reads a range near 95 in the
/// recordings — the estimate is noisy when the body is horizontal and
/// foreshortened — so asking it to hold still refuses every honest rep.
const kPushup = MovementSignature('push-up', [
  Moves(Channel.elbow, 35, 'Go all the way down'),
  Within(Channel.torsoPitch, 35, 90, 'Get into a push-up position'),
  Within(Channel.wristHeight, 0.4, 3.0, 'Hands go under your shoulders'),
]);

/// Rising onto the toes.
const kCalfRaise = MovementSignature('calf raise', [
  Holds(Channel.knee, 40, 'Keep the legs straight'),
  Holds(Channel.hip, 40, 'Only the ankles move'),
]);

/// Everything the verifier weighs a rep against. A movement has to fit its own
/// signature *and* beat every one of these.
const kAllSignatures = <MovementSignature>[
  kPressHorizontal,
  kPressOverhead,
  kCurl,
  kExtension,
  kRow,
  kPulldown,
  kRaise,
  kSquat,
  kHinge,
  kPushup,
  kCalfRaise,
];

/// Which signature an exercise name belongs to.
///
/// Order matters and is not alphabetical: "Leg Press" must reach the squat
/// rule before the press rule sees the word "press", and "Overhead Press"
/// must be claimed before the plain press. Every list here is read top to
/// bottom, first match wins.
MovementSignature signatureFor(String exerciseName) {
  final name = exerciseName.toLowerCase();

  bool has(List<String> words) => words.any(name.contains);

  // Legs first: they carry words that upper-body rules would otherwise steal.
  if (has(['calf', 'toe raise'])) return kCalfRaise;
  if (has(['leg press', 'squat', 'lunge', 'leg extension', 'step up'])) {
    return kSquat;
  }
  if (has([
    'deadlift',
    'hinge',
    'good morning',
    'bridge',
    'thrust',
    'hyperextension',
    'crunch',
    'sit up',
    'situp',
    'leg raise',
    'leg curl',
    'plank',
  ])) {
    return kHinge;
  }

  // Push-ups before presses, for the same reason.
  if (has(['push up', 'push-up', 'pushup', 'press up'])) return kPushup;

  if (has(['pull up', 'pull-up', 'pullup', 'chin', 'pulldown', 'lat pull'])) {
    return kPulldown;
  }
  if (has(['row'])) return kRow;

  if (has(['overhead press', 'shoulder press', 'military', 'arnold'])) {
    return kPressOverhead;
  }
  if (has(['curl'])) return kCurl;
  if (has(['extension', 'pushdown', 'push down', 'kickback', 'skull'])) {
    return kExtension;
  }
  if (has(['raise', 'fly', 'flye', 'crossover', 'pullover', 'lateral'])) {
    return kRaise;
  }
  if (has(['press', 'dip'])) return kPressHorizontal;

  // Nothing recognised. An unknown movement must not be judged against a
  // signature it was never meant to match, so it counts on shape alone.
  return const MovementSignature('any', []);
}
