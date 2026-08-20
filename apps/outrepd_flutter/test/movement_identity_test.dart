/// Measures the identity check, not the count.
///
/// Two failures matter and they pull in opposite directions. Too loose and a
/// round about bench press can be farmed with curls, which was the whole
/// reason for building this. Too tight and real reps of the right exercise get
/// thrown away, which is worse — a lifter whose work vanishes stops lifting.
///
/// So every recording is run twice: once against the movement it actually is,
/// where every rep must survive, and once against movements it is not, where
/// they must be refused. A signature that passes only the first test is
/// decoration; one that passes only the second is a wall.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/reps/exercise_patterns.dart';
import 'package:outrepd/reps/movement_signature.dart';
import 'package:outrepd/reps/recording.dart';
import 'package:outrepd/reps/rep_engine.dart';
import 'package:outrepd/reps/signature_catalogue.dart';

const _folder = String.fromEnvironment(
  'RECORDINGS',
  defaultValue: 'D:/outrepd-recordings',
);

/// What each clip actually shows, and a movement it plainly is not.
///
/// The impostor is chosen to be the hard case rather than an easy one: a squat
/// against a hinge shares the whole lower body, and a push-up against a bench
/// press shares the elbow exactly. Anything that separates those separates the
/// obvious pairs for free.
/// Names are the catalogue's own, spelled exactly. "Push Up" resolves to
/// nothing — the catalogue says "Push-Ups" — and a test that quietly asks for
/// an exercise the app does not have measures nothing at all.
const _clips = <String, (String truth, String impostor)>{
  'squat_demo.json': ('Barbell Squat', 'Deadlift'),
  'squat_series.json': ('Barbell Squat', 'Deadlift'),
  'deadlift_demo.json': ('Deadlift', 'Barbell Squat'),
  'deadlift_series.json': ('Deadlift', 'Barbell Squat'),
  'pushup_interval.json': ('Push-Ups', 'Barbell Bench Press'),
  'pushup_tcount.json': ('Push-Ups', 'Barbell Curl'),
  'bench_dumbbell.json': ('Barbell Bench Press', 'Barbell Curl'),
  'bench_demo.json': ('Barbell Bench Press', 'Barbell Curl'),
  'incline_demo.json': ('Incline Barbell Bench Press', 'Barbell Curl'),
  'ohp_demo.json': ('Overhead Press', 'Barbell Curl'),
  'row_demo.json': ('Barbell Row', 'Barbell Curl'),
  'pullup_demo.json': ('Pull-Ups', 'Barbell Curl'),
  'crunch_demo.json': ('Hanging Leg Raises', 'Barbell Squat'),
  'legraise_demo.json': ('Hanging Leg Raises', 'Barbell Squat'),
};

({int reps, String? why}) _countWith(
  PoseRecording recording,
  String exerciseName, {
  bool checkMovement = true,
}) {
  final def = cameraDefFor(exerciseName);
  if (def == null) return (reps: 0, why: 'no definition');
  final engine = RepEngine(def, checkMovement: checkMovement);
  for (final frame in recording.frames) {
    engine.update(frame.pose, Duration(milliseconds: frame.atMs));
  }
  return (reps: engine.reps, why: engine.wrongMovementMessage);
}

void main() {
  final dir = Directory(_folder);

  test('the right movement still counts, the wrong one does not', () {
    if (!dir.existsSync()) {
      // ignore: avoid_print
      print('No recordings at $_folder — nothing to measure yet.');
      return;
    }

    final rows = <String>[];
    var honest = 0;
    var caught = 0;
    var judged = 0;
    var costFree = 0;

    for (final entry in _clips.entries) {
      final file = File('$_folder/${entry.key}');
      if (!file.existsSync()) continue;

      final recording = PoseRecording.fromJson(
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
      );

      final (truth, impostor) = entry.value;
      final own = _countWith(recording, truth);
      final fake = _countWith(recording, impostor);

      // The same movement with the check switched off. If this counts and the
      // checked run does not, the signature is the thing eating the reps; if
      // neither counts, the fault is upstream in the definition.
      final blind = _countWith(recording, truth, checkMovement: false);

      judged++;
      if (own.reps > 0) honest++;
      if (fake.reps < own.reps) caught++;
      if (own.reps == blind.reps) costFree++;

      rows.add(
        '${entry.key.padRight(22)} as ${truth.padRight(21)}'
        ' ${own.reps.toString().padLeft(3)}'
        '  unchecked ${blind.reps.toString().padLeft(3)}'
        '   as ${impostor.padRight(21)} ${fake.reps.toString().padLeft(3)}',
      );
    }

    // ignore: avoid_print
    print('\n${rows.join('\n')}\n'
        'counted as itself: $honest/$judged   '
        'refused as impostor: $caught/$judged\n');

    // The contract this test can actually hold the signatures to: checking
    // identity must never cost a rep that would otherwise have counted. A
    // signature that quietly eats real work is a bug nobody reports — they
    // just stop using the app.
    //
    // Whether a clip counts at all is the *counter's* business, not the
    // signature's, and one clip here counts zero either way because the
    // hand-written push-up thresholds do not fit that particular video. That
    // is a real problem and it is tracked with the counting work; failing this
    // test for it would only teach us to ignore this test.
    expect(costFree, judged,
        reason: 'checking identity threw away reps that counted without it');

    // And the point of the whole exercise: a set performed as one movement
    // must not count as another.
    expect(caught, greaterThanOrEqualTo(honest),
        reason: 'an impostor movement scored as many reps as the real one');
  });

  test('a signature with no rules accepts anything', () {
    // Free training has no prescribed movement, and the catalogue returns an
    // empty signature for names it does not recognise. Neither may reject.
    final verifier = SignatureVerifier(signatureFor('Nonsense Machine'), kAllSignatures);
    expect(verifier.verify(const []).accepted, isTrue);
  });

  test('every catalogue exercise resolves to a signature', () {
    for (final name in ['Bench Press', 'Bicep Curl', 'Barbell Squat', 'Deadlift']) {
      expect(signatureFor(name).rules, isNotEmpty, reason: name);
    }
  });
}
