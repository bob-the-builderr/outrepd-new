// Comprehensive exercise database organized by muscle group
export const MUSCLE_GROUPS = ["Chest", "Back", "Legs", "Shoulders", "Arms"];

export const EXERCISES_BY_MUSCLE = {
  Chest: [
    { name: "Barbell Bench Press", equipment: "Barbell", compound: true },
    {
      name: "Incline Barbell Bench Press",
      equipment: "Barbell",
      compound: true,
    },
    {
      name: "Decline Barbell Bench Press",
      equipment: "Barbell",
      compound: true,
    },
    { name: "Dumbbell Bench Press", equipment: "Dumbbell", compound: true },
    { name: "Incline Dumbbell Press", equipment: "Dumbbell", compound: true },
    { name: "Decline Dumbbell Press", equipment: "Dumbbell", compound: true },
    { name: "Dumbbell Flyes", equipment: "Dumbbell", compound: false },
    { name: "Incline Dumbbell Flyes", equipment: "Dumbbell", compound: false },
    { name: "Cable Flyes", equipment: "Cable", compound: false },
    { name: "Cable Crossovers", equipment: "Cable", compound: false },
    { name: "Chest Press Machine", equipment: "Machine", compound: true },
    { name: "Pec Deck Machine", equipment: "Machine", compound: false },
    { name: "Push-Ups", equipment: "Bodyweight", compound: true },
    { name: "Dips (Chest Focus)", equipment: "Bodyweight", compound: true },
  ],
  Back: [
    { name: "Barbell Deadlift", equipment: "Barbell", compound: true },
    { name: "Barbell Row", equipment: "Barbell", compound: true },
    { name: "T-Bar Row", equipment: "Barbell", compound: true },
    { name: "Dumbbell Row", equipment: "Dumbbell", compound: true },
    { name: "Pull-Ups", equipment: "Bodyweight", compound: true },
    { name: "Chin-Ups", equipment: "Bodyweight", compound: true },
    { name: "Lat Pulldown", equipment: "Cable", compound: true },
    { name: "Cable Row", equipment: "Cable", compound: true },
    { name: "Wide Grip Lat Pulldown", equipment: "Cable", compound: true },
    { name: "Close Grip Lat Pulldown", equipment: "Cable", compound: true },
    { name: "Face Pulls", equipment: "Cable", compound: false },
    { name: "Shrugs", equipment: "Dumbbell", compound: false },
    { name: "Barbell Shrugs", equipment: "Barbell", compound: false },
    { name: "Machine Row", equipment: "Machine", compound: true },
    { name: "Chest Supported Row", equipment: "Machine", compound: true },
  ],
  Legs: [
    { name: "Barbell Squat", equipment: "Barbell", compound: true },
    { name: "Front Squat", equipment: "Barbell", compound: true },
    { name: "Romanian Deadlift", equipment: "Barbell", compound: true },
    { name: "Leg Press", equipment: "Machine", compound: true },
    { name: "Hack Squat", equipment: "Machine", compound: true },
    { name: "Bulgarian Split Squat", equipment: "Dumbbell", compound: true },
    { name: "Walking Lunges", equipment: "Dumbbell", compound: true },
    { name: "Leg Extension", equipment: "Machine", compound: false },
    { name: "Leg Curl", equipment: "Machine", compound: false },
    { name: "Calf Raises", equipment: "Machine", compound: false },
    { name: "Seated Calf Raises", equipment: "Machine", compound: false },
    { name: "Goblet Squat", equipment: "Dumbbell", compound: true },
    { name: "Leg Press (Single Leg)", equipment: "Machine", compound: true },
    { name: "Glute Bridge", equipment: "Bodyweight", compound: true },
    { name: "Hip Thrust", equipment: "Barbell", compound: true },
  ],
  Shoulders: [
    { name: "Overhead Press", equipment: "Barbell", compound: true },
    { name: "Dumbbell Shoulder Press", equipment: "Dumbbell", compound: true },
    { name: "Arnold Press", equipment: "Dumbbell", compound: true },
    { name: "Lateral Raises", equipment: "Dumbbell", compound: false },
    { name: "Front Raises", equipment: "Dumbbell", compound: false },
    { name: "Rear Delt Flyes", equipment: "Dumbbell", compound: false },
    { name: "Cable Lateral Raises", equipment: "Cable", compound: false },
    { name: "Cable Front Raises", equipment: "Cable", compound: false },
    { name: "Face Pulls", equipment: "Cable", compound: false },
    { name: "Upright Row", equipment: "Barbell", compound: false },
    { name: "Machine Shoulder Press", equipment: "Machine", compound: true },
    { name: "Reverse Pec Deck", equipment: "Machine", compound: false },
  ],
  Arms: [
    { name: "Barbell Curl", equipment: "Barbell", compound: false },
    { name: "Dumbbell Curl", equipment: "Dumbbell", compound: false },
    { name: "Hammer Curl", equipment: "Dumbbell", compound: false },
    { name: "Preacher Curl", equipment: "Machine", compound: false },
    { name: "Cable Curl", equipment: "Cable", compound: false },
    { name: "Concentration Curl", equipment: "Dumbbell", compound: false },
    { name: "Close Grip Bench Press", equipment: "Barbell", compound: true },
    { name: "Tricep Dips", equipment: "Bodyweight", compound: true },
    { name: "Skull Crushers", equipment: "Barbell", compound: false },
    {
      name: "Overhead Tricep Extension",
      equipment: "Dumbbell",
      compound: false,
    },
    { name: "Cable Tricep Pushdown", equipment: "Cable", compound: false },
    {
      name: "Cable Tricep Overhead Extension",
      equipment: "Cable",
      compound: false,
    },
    { name: "Dumbbell Kickbacks", equipment: "Dumbbell", compound: false },
  ],
  Core: [
    { name: "Plank", equipment: "Bodyweight", compound: true },
    { name: "Side Plank", equipment: "Bodyweight", compound: true },
    { name: "Crunches", equipment: "Bodyweight", compound: false },
    { name: "Russian Twists", equipment: "Bodyweight", compound: false },
    { name: "Leg Raises", equipment: "Bodyweight", compound: false },
    { name: "Hanging Leg Raises", equipment: "Bodyweight", compound: false },
    { name: "Cable Crunches", equipment: "Cable", compound: false },
    { name: "Ab Wheel Rollout", equipment: "Equipment", compound: true },
    { name: "Mountain Climbers", equipment: "Bodyweight", compound: true },
    { name: "Dead Bug", equipment: "Bodyweight", compound: false },
  ],
};

// Get all exercises for a specific muscle group
export function getExercisesForMuscle(muscleGroup) {
  return EXERCISES_BY_MUSCLE[muscleGroup] || [];
}

// Get exercise names only
export function getExerciseNames(muscleGroup) {
  return getExercisesForMuscle(muscleGroup).map((ex) => ex.name);
}
