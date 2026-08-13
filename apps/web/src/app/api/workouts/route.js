import sql from "@/app/api/utils/sql";
import { getSession } from "@/app/api/utils/getSession";
import { calculateModifiedVolume } from "@/app/api/utils/volumeMultipliers";
import { requireSubscription } from "@/app/api/utils/subscription-middleware";

// Helper function to award an achievement
async function awardAchievement(userId, achievementKey) {
  try {
    // Get achievement details
    const achievement = await sql`
      SELECT * FROM achievements WHERE achievement_key = ${achievementKey}
    `;

    if (achievement.length === 0) return null;

    // Check if user already has this achievement
    const existing = await sql`
      SELECT id FROM user_achievements 
      WHERE user_id = ${userId} AND achievement_id = ${achievement[0].id}
    `;

    if (existing.length > 0) return null;

    // Award the achievement
    await sql`
      INSERT INTO user_achievements (user_id, achievement_id)
      VALUES (${userId}, ${achievement[0].id})
    `;

    // Create notification
    await sql`
      INSERT INTO notifications (user_id, type, title, message, data)
      VALUES (
        ${userId}, 
        'achievement_unlocked',
        'Achievement Unlocked!',
        ${`You earned: ${achievement[0].title}`},
        ${JSON.stringify({ achievement_id: achievement[0].id, achievement_key: achievementKey })}
      )
    `;

    return achievement[0];
  } catch (error) {
    console.error("Award achievement error:", error);
    return null;
  }
}

// GET list all workouts for current user
export async function GET(request) {
  try {
    const session = await getSession(request);
    if (!session || !session.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = session.user.id;
    const { searchParams } = new URL(request.url);
    const limit = parseInt(searchParams.get("limit") || "50");
    const offset = parseInt(searchParams.get("offset") || "0");

    const workouts = await sql`
      SELECT * FROM workout_logs
      WHERE user_id = ${userId}
      ORDER BY workout_date DESC
      LIMIT ${limit}
      OFFSET ${offset}
    `;

    return Response.json({ workouts });
  } catch (err) {
    console.error("GET /api/workouts error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}

// POST create a new workout
export async function POST(request) {
  try {
    // Server-side subscription gate
    let userId;
    try {
      const sub = await requireSubscription(request);
      userId = sub.userId;
    } catch (subError) {
      return subError;
    }

    const body = await request.json();
    const { match_id, workout_name, exercises, duration_minutes, notes } = body;

    // Fetch user's bodyweight and height for volume multipliers
    const userProfile = await sql`
      SELECT bodyweight_kg, height_cm FROM user_profiles WHERE user_id = ${userId}
    `;
    const userBodyweight = userProfile?.[0]?.bodyweight_kg || null;
    const userHeight = userProfile?.[0]?.height_cm || null;

    // Calculate totals from exercises with multipliers
    let totalVolume = 0;
    let totalSets = 0;
    const totalExercises = exercises?.length || 0;

    exercises?.forEach((ex) => {
      ex.sets?.forEach((set) => {
        // Calculate modified volume with all multipliers
        const modifiedVolume = calculateModifiedVolume(
          parseFloat(set.weight_kg || 0),
          parseInt(set.reps || 0),
          set.equipment_type || "barbell",
          parseFloat(set.rep_quality || 1.0),
          userBodyweight,
          userHeight,
        );
        set.volume_kg = modifiedVolume; // Update set volume with modified value
        totalVolume += modifiedVolume;
        totalSets += 1;
      });
    });

    // Create workout log
    const workoutResult = await sql`
      INSERT INTO workout_logs (
        user_id,
        match_id,
        workout_name,
        total_volume_kg,
        total_exercises,
        total_sets,
        duration_minutes,
        notes
      ) VALUES (
        ${userId},
        ${match_id || null},
        ${workout_name || null},
        ${totalVolume},
        ${totalExercises},
        ${totalSets},
        ${duration_minutes || null},
        ${notes || null}
      )
      RETURNING *
    `;

    const workoutId = workoutResult[0].id;

    // Insert exercises and sets
    for (let i = 0; i < exercises?.length || 0; i++) {
      const exercise = exercises[i];
      let exerciseVolume = 0;
      let exerciseSets = exercise.sets?.length || 0;
      let exerciseReps = 0;

      exercise.sets?.forEach((set) => {
        exerciseVolume += parseFloat(set.volume_kg || 0);
        exerciseReps += parseInt(set.reps || 0);
      });

      const exerciseResult = await sql`
        INSERT INTO workout_exercises (
          workout_log_id,
          exercise_name,
          muscle_group,
          exercise_order,
          total_sets,
          total_reps,
          total_volume_kg,
          notes
        ) VALUES (
          ${workoutId},
          ${exercise.exercise_name},
          ${exercise.muscle_group},
          ${i},
          ${exerciseSets},
          ${exerciseReps},
          ${exerciseVolume},
          ${exercise.notes || null}
        )
        RETURNING *
      `;

      const exerciseId = exerciseResult[0].id;

      // Insert sets with new multiplier fields
      for (let j = 0; j < exercise.sets?.length || 0; j++) {
        const set = exercise.sets[j];
        await sql`
          INSERT INTO exercise_sets (
            workout_exercise_id,
            set_number,
            reps,
            weight_kg,
            volume_kg,
            equipment_type,
            rep_quality,
            is_warmup,
            is_failure,
            rpe,
            notes
          ) VALUES (
            ${exerciseId},
            ${j + 1},
            ${set.reps},
            ${set.weight_kg},
            ${set.volume_kg},
            ${set.equipment_type || "barbell"},
            ${set.rep_quality || 1.0},
            ${set.is_warmup || false},
            ${set.is_failure || false},
            ${set.rpe || null},
            ${set.notes || null}
          )
        `;
      }

      // Update or create personal record for this muscle group
      const existingPR = await sql`
        SELECT max_volume_kg FROM personal_records
        WHERE user_id = ${userId} AND muscle_group = ${exercise.muscle_group}
      `;

      if (existingPR.length === 0) {
        // Create new PR
        await sql`
          INSERT INTO personal_records (
            user_id,
            muscle_group,
            exercise_name,
            max_volume_kg,
            workout_exercise_id
          ) VALUES (
            ${userId},
            ${exercise.muscle_group},
            ${exercise.exercise_name},
            ${exerciseVolume},
            ${exerciseId}
          )
        `;
      } else if (exerciseVolume > parseFloat(existingPR[0].max_volume_kg)) {
        // Update existing PR
        await sql`
          UPDATE personal_records
          SET
            max_volume_kg = ${exerciseVolume},
            exercise_name = ${exercise.exercise_name},
            workout_exercise_id = ${exerciseId},
            achieved_at = CURRENT_TIMESTAMP
          WHERE user_id = ${userId} AND muscle_group = ${exercise.muscle_group}
        `;

        // Send PR notification
        await sql`
          INSERT INTO notifications (user_id, type, title, message, data)
          VALUES (
            ${userId},
            'personal_record',
            'New Personal Record! 🎉',
            ${`You set a new ${exercise.muscle_group} PR with ${exercise.exercise_name}: ${exerciseVolume}kg total volume!`},
            ${JSON.stringify({
              muscle_group: exercise.muscle_group,
              exercise_name: exercise.exercise_name,
              volume_kg: exerciseVolume,
              workout_id: workoutId,
            })}
          )
        `;
      }
    }

    // Update user profile total volume
    await sql`
      UPDATE user_profiles
      SET
        total_volume_kg = total_volume_kg + ${totalVolume},
        updated_at = CURRENT_TIMESTAMP
      WHERE user_id = ${userId}
    `;

    // Check achievements
    // Check workout count achievements
    const workoutCount = await sql`
      SELECT COUNT(*) as count FROM workout_logs WHERE user_id = ${userId}
    `;
    const count = parseInt(workoutCount[0].count);

    const workoutChecks = [
      { key: "workouts_10", count: 10 },
      { key: "workouts_50", count: 50 },
      { key: "workouts_100", count: 100 },
    ];

    for (const { key, count: required } of workoutChecks) {
      if (count >= required) {
        await awardAchievement(userId, key);
      }
    }

    // Check volume achievements for this workout
    const volumeChecks = [
      { key: "volume_1000", volume: 1000 },
      { key: "volume_2000", volume: 2000 },
    ];

    for (const { key, volume: required } of volumeChecks) {
      if (totalVolume >= required) {
        await awardAchievement(userId, key);
      }
    }

    return Response.json({ workout: workoutResult[0] });
  } catch (err) {
    console.error("POST /api/workouts error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
