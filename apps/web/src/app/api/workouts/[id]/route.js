import sql from "@/app/api/utils/sql";
import { getSession } from "@/app/api/utils/getSession";

// GET single workout with exercises and sets
export async function GET(request, { params }) {
  try {
    const session = await getSession(request);
    if (!session || !session.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = session.user.id;
    const workoutId = params.id;

    // Get workout log
    const workouts = await sql`
      SELECT * FROM workout_logs
      WHERE id = ${workoutId} AND user_id = ${userId}
      LIMIT 1
    `;

    if (workouts.length === 0) {
      return Response.json({ error: "Workout not found" }, { status: 404 });
    }

    const workout = workouts[0];

    // Get exercises for this workout
    const exercises = await sql`
      SELECT * FROM workout_exercises
      WHERE workout_log_id = ${workoutId}
      ORDER BY exercise_order
    `;

    // Get sets for each exercise
    for (let exercise of exercises) {
      const sets = await sql`
        SELECT * FROM exercise_sets
        WHERE workout_exercise_id = ${exercise.id}
        ORDER BY set_number
      `;
      exercise.sets = sets;
    }

    workout.exercises = exercises;

    return Response.json({ workout });
  } catch (err) {
    console.error("GET /api/workouts/[id] error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
