import 'package:flutter_test/flutter_test.dart';

import 'package:outrepd/exercises.dart';
import 'package:outrepd/reps/exercise_patterns.dart';
import 'package:outrepd/reps/pose.dart';

void main() {
  final catalogue = [
    for (final group in exercisesByMuscle.values)
      for (final exercise in group) exercise.name,
  ];

  test('every exercise in the catalogue can be counted', () {
    final missed = [
      for (final name in catalogue)
        if (cameraDefFor(name) == null) name,
    ];

    expect(
      missed,
      isEmpty,
      reason: 'these have no pattern and would fall back to being worked out '
          'from the movement: $missed',
    );
  });

  group('names land on the joint the movement actually bends', () {
    void expectsVertex(String name, Joint vertex) {
      test(name, () => expect(cameraDefFor(name)!.driver.vertex, vertex));
    }

    expectsVertex('Barbell Bench Press', Joint.leftElbow);
    expectsVertex('Lat Pulldown', Joint.leftElbow);
    expectsVertex('Preacher Curl', Joint.leftElbow);
    expectsVertex('Cable Tricep Pushdown', Joint.leftElbow);

    expectsVertex('Lateral Raises', Joint.leftShoulder);
    expectsVertex('Cable Crossovers', Joint.leftShoulder);
    expectsVertex('Rear Delt Flyes', Joint.leftShoulder);

    expectsVertex('Barbell Squat', Joint.leftKnee);
    expectsVertex('Walking Lunges', Joint.leftKnee);
    expectsVertex('Leg Extension', Joint.leftKnee);

    expectsVertex('Romanian Deadlift', Joint.leftHip);
    expectsVertex('Hip Thrust', Joint.leftHip);
    expectsVertex('Hanging Leg Raises', Joint.leftHip);

    expectsVertex('Calf Raises', Joint.leftAnkle);
  });

  group('the traps in the naming', () {
    test('a leg press is a leg movement, not a press', () {
      expect(cameraDefFor('Leg Press')!.driver.vertex, Joint.leftKnee);
    });

    test('an upright row is a raise, not a row', () {
      expect(cameraDefFor('Upright Row')!.driver.vertex, Joint.leftShoulder);
    });

    test('a close grip bench press is still a press', () {
      expect(
        cameraDefFor('Close Grip Bench Press')!.driver.vertex,
        Joint.leftElbow,
      );
    });

    test('a leg curl bends the knee, not the elbow', () {
      expect(cameraDefFor('Leg Curl')!.driver.vertex, Joint.leftKnee);
    });

    test('a pec deck is a flye, not a press', () {
      expect(
        cameraDefFor('Pec Deck Machine')!.driver.vertex,
        Joint.leftShoulder,
      );
    });
  });

  test('hand-written definitions keep their form rules', () {
    // Push-ups are defined by hand and carry a rule about the body line. The
    // pattern lookup must not quietly replace that with a bare counter.
    final pushup = cameraDefFor('Push-Ups')!;
    expect(pushup.gates, isNotEmpty);
  });

  test('an unknown movement gets no pattern rather than a wrong one', () {
    expect(cameraDefFor('Interpretive Dance'), isNull);
  });
}
