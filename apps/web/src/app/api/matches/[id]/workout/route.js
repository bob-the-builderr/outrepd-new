import sql from "@/app/api/utils/sql";
import { getSession } from "@/app/api/utils/getSession";

// GET workout details for a specific match (both user and opponent)
export async function GET(request, { params }) {
  try {
    const session = await getSession(request);
    if (!session || !session.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = session.user.id;
    const matchId = params.id;

    // Get match details
    const matches = await sql`
      SELECT * FROM matches
      WHERE id = ${matchId} AND user_id = ${userId}
      LIMIT 1
    `;

    if (matches.length === 0) {
      return Response.json({ error: "Match not found" }, { status: 404 });
    }

    const match = matches[0];

    // Get user's workout for this match
    const userWorkouts = await sql`
      SELECT * FROM workout_logs
      WHERE user_id = ${userId} AND match_id = ${matchId}
      LIMIT 1
    `;

    let userWorkout = null;
    if (userWorkouts.length > 0) {
      userWorkout = userWorkouts[0];

      // Get exercises for user's workout
      const exercises = await sql`
        SELECT * FROM workout_exercises
        WHERE workout_log_id = ${userWorkout.id}
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

      userWorkout.exercises = exercises;
    }

    // Get opponent's workout if opponent_id exists
    let opponentWorkout = null;
    if (match.opponent_id) {
      const opponentWorkouts = await sql`
        SELECT * FROM workout_logs
        WHERE user_id = ${match.opponent_id} AND match_id = ${matchId}
        LIMIT 1
      `;

      if (opponentWorkouts.length > 0) {
        opponentWorkout = opponentWorkouts[0];

        // Get exercises for opponent's workout
        const exercises = await sql`
          SELECT * FROM workout_exercises
          WHERE workout_log_id = ${opponentWorkout.id}
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

        opponentWorkout.exercises = exercises;
      }
    }

    return Response.json({
      match,
      userWorkout,
      opponentWorkout,
    });
  } catch (err) {
    console.error("GET /api/matches/[id]/workout error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
