import 'package:flutter/material.dart' show IconData, Icons;

import 'l10n/app_localizations.dart';

/// Exercise catalogue, mirrored from the original app so the two stay in sync.
class Exercise {
  final String name;
  final String equipment;
  final bool compound;

  const Exercise(this.name, this.equipment, {this.compound = false});
}

const exercisesByMuscle = <String, List<Exercise>>{
  'Chest': [
    Exercise('Barbell Bench Press', 'Barbell', compound: true),
    Exercise('Incline Barbell Bench Press', 'Barbell', compound: true),
    Exercise('Decline Barbell Bench Press', 'Barbell', compound: true),
    Exercise('Dumbbell Bench Press', 'Dumbbell', compound: true),
    Exercise('Incline Dumbbell Press', 'Dumbbell', compound: true),
    Exercise('Decline Dumbbell Press', 'Dumbbell', compound: true),
    Exercise('Dumbbell Flyes', 'Dumbbell'),
    Exercise('Incline Dumbbell Flyes', 'Dumbbell'),
    Exercise('Cable Flyes', 'Cable'),
    Exercise('Cable Crossovers', 'Cable'),
    Exercise('Chest Press Machine', 'Machine', compound: true),
    Exercise('Pec Deck Machine', 'Machine'),
    Exercise('Push-Ups', 'Bodyweight', compound: true),
    Exercise('Dips (Chest Focus)', 'Bodyweight', compound: true),
  ],
  'Back': [
    Exercise('Barbell Deadlift', 'Barbell', compound: true),
    Exercise('Barbell Row', 'Barbell', compound: true),
    Exercise('T-Bar Row', 'Barbell', compound: true),
    Exercise('Dumbbell Row', 'Dumbbell', compound: true),
    Exercise('Pull-Ups', 'Bodyweight', compound: true),
    Exercise('Chin-Ups', 'Bodyweight', compound: true),
    Exercise('Lat Pulldown', 'Cable', compound: true),
    Exercise('Cable Row', 'Cable', compound: true),
    Exercise('Wide Grip Lat Pulldown', 'Cable', compound: true),
    Exercise('Close Grip Lat Pulldown', 'Cable', compound: true),
    Exercise('Face Pulls', 'Cable'),
    Exercise('Shrugs', 'Dumbbell'),
    Exercise('Barbell Shrugs', 'Barbell'),
    Exercise('Machine Row', 'Machine', compound: true),
    Exercise('Chest Supported Row', 'Machine', compound: true),
  ],
  'Legs': [
    Exercise('Barbell Squat', 'Barbell', compound: true),
    Exercise('Front Squat', 'Barbell', compound: true),
    Exercise('Romanian Deadlift', 'Barbell', compound: true),
    Exercise('Leg Press', 'Machine', compound: true),
    Exercise('Hack Squat', 'Machine', compound: true),
    Exercise('Bulgarian Split Squat', 'Dumbbell', compound: true),
    Exercise('Walking Lunges', 'Dumbbell', compound: true),
    Exercise('Leg Extension', 'Machine'),
    Exercise('Leg Curl', 'Machine'),
    Exercise('Calf Raises', 'Machine'),
    Exercise('Seated Calf Raises', 'Machine'),
    Exercise('Goblet Squat', 'Dumbbell', compound: true),
    Exercise('Leg Press (Single Leg)', 'Machine', compound: true),
    Exercise('Glute Bridge', 'Bodyweight', compound: true),
    Exercise('Hip Thrust', 'Barbell', compound: true),
  ],
  'Shoulders': [
    Exercise('Overhead Press', 'Barbell', compound: true),
    Exercise('Dumbbell Shoulder Press', 'Dumbbell', compound: true),
    Exercise('Arnold Press', 'Dumbbell', compound: true),
    Exercise('Lateral Raises', 'Dumbbell'),
    Exercise('Front Raises', 'Dumbbell'),
    Exercise('Rear Delt Flyes', 'Dumbbell'),
    Exercise('Cable Lateral Raises', 'Cable'),
    Exercise('Cable Front Raises', 'Cable'),
    Exercise('Face Pulls', 'Cable'),
    Exercise('Upright Row', 'Barbell'),
    Exercise('Machine Shoulder Press', 'Machine', compound: true),
    Exercise('Reverse Pec Deck', 'Machine'),
  ],
  'Arms': [
    Exercise('Barbell Curl', 'Barbell'),
    Exercise('Dumbbell Curl', 'Dumbbell'),
    Exercise('Hammer Curl', 'Dumbbell'),
    Exercise('Preacher Curl', 'Machine'),
    Exercise('Cable Curl', 'Cable'),
    Exercise('Concentration Curl', 'Dumbbell'),
    Exercise('Close Grip Bench Press', 'Barbell', compound: true),
    Exercise('Tricep Dips', 'Bodyweight', compound: true),
    Exercise('Skull Crushers', 'Barbell'),
    Exercise('Overhead Tricep Extension', 'Dumbbell'),
    Exercise('Cable Tricep Pushdown', 'Cable'),
    Exercise('Cable Tricep Overhead Extension', 'Cable'),
    Exercise('Dumbbell Kickbacks', 'Dumbbell'),
  ],
  'Core': [
    Exercise('Plank', 'Bodyweight', compound: true),
    Exercise('Side Plank', 'Bodyweight', compound: true),
    Exercise('Crunches', 'Bodyweight'),
    Exercise('Russian Twists', 'Bodyweight'),
    Exercise('Leg Raises', 'Bodyweight'),
    Exercise('Hanging Leg Raises', 'Bodyweight'),
    Exercise('Cable Crunches', 'Cable'),
    Exercise('Ab Wheel Rollout', 'Equipment', compound: true),
    Exercise('Mountain Climbers', 'Bodyweight', compound: true),
    Exercise('Dead Bug', 'Bodyweight'),
  ],
};

List<Exercise> exercisesFor(String muscle) => exercisesByMuscle[muscle] ?? const [];

/// The three ways a body pushes, pulls and stands up, which is how lifters
/// already talk about their week.
///
/// Six muscle groups made a fine catalogue and a poor menu: picking a match by
/// "Shoulders" or "Arms" leaves an opponent guessing what they are in for, and
/// half the pairings were lopsided before anyone lifted. Push, pull and legs
/// are the split most people already train on, so a challenge in one of them
/// needs no explaining.
enum Discipline { push, pull, legs }

extension DisciplineLabel on Discipline {
  String label(L l) => switch (this) {
        Discipline.push => l.discPush,
        Discipline.pull => l.discPull,
        Discipline.legs => l.discLegs,
      };

  String hint(L l) => switch (this) {
        Discipline.push => l.discPushHint,
        Discipline.pull => l.discPullHint,
        Discipline.legs => l.discLegsHint,
      };

  IconData get icon => switch (this) {
        Discipline.push => Icons.fitness_center,
        Discipline.pull => Icons.rowing,
        Discipline.legs => Icons.directions_walk,
      };
}

extension DisciplineExercises on Discipline {
  /// The muscle groups this discipline draws from. Arms are split rather than
  /// given a home: a curl is a pull and a pushdown is a push, and putting both
  /// under one heading is what made "Arms" a meaningless round to be matched
  /// on.
  List<Exercise> get exercises => switch (this) {
        Discipline.push => [
            ...exercisesFor('Chest'),
            ...exercisesFor('Shoulders'),
            ...exercisesFor('Arms').where(_isPush),
          ],
        Discipline.pull => [
            ...exercisesFor('Back'),
            ...exercisesFor('Arms').where((e) => !_isPush(e)),
          ],
        Discipline.legs => [
            ...exercisesFor('Legs'),
            ...exercisesFor('Core'),
          ],
      };

  static bool _isPush(Exercise e) {
    final n = e.name.toLowerCase();
    return n.contains('tricep') ||
        n.contains('pushdown') ||
        n.contains('extension') ||
        n.contains('skull') ||
        n.contains('dip') ||
        n.contains('kickback');
  }
}

/// How many exercises each player brings to a match, and how many rounds that
/// makes once both players' picks are on the card.
///
/// Three each rather than six between them: a match where you only ever lift
/// what you chose is a personal best, not a contest. Half the card being your
/// opponent's picks is what makes it one.
const kPicksPerPlayer = 3;
const kRoundsPerMatch = kPicksPerPlayer * 2;

/// One round of work, then rest before the next.
///
/// A fixed window rather than a fixed number of reps, so both players face the
/// same question — how many can you do in ninety seconds — instead of racing
/// to a target where the faster lifter simply finishes earlier and waits.
///
/// Six rounds at these lengths is about seventeen minutes, which is a real set
/// of work and still short enough to finish in one visit to the gym.
const kRoundWork = Duration(seconds: 90);
const kRoundRest = Duration(seconds: 75);

/// A single logged set inside a match.
class WorkoutSet {
  String weight;
  String reps;

  WorkoutSet({this.weight = '', this.reps = ''});

  double get volume {
    final w = _number(weight);
    final r = _number(reps);
    return w * r;
  }

  /// Reads whatever digits the keyboard produced. An Arabic keyboard types ١٢
  /// and `double.tryParse` refuses it, so a set logged on an Arabic phone would
  /// silently count as zero volume — a lost match nobody could explain.
  static double _number(String text) {
    const arabicIndic = '٠١٢٣٤٥٦٧٨٩';
    final western = text.trim().split('').map((c) {
      final i = arabicIndic.indexOf(c);
      return i == -1 ? c : '$i';
    }).join();
    return double.tryParse(western) ?? 0;
  }

  bool get isComplete => volume > 0;
}

/// One exercise being logged, with its sets.
class WorkoutEntry {
  final String name;
  final List<WorkoutSet> sets;

  WorkoutEntry({required this.name, List<WorkoutSet>? sets})
      : sets = sets ?? [WorkoutSet()];

  double get volume => sets.fold(0.0, (sum, s) => sum + s.volume);
}
