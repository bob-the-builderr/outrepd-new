import { getSession } from "@/app/api/utils/getSession";
import sql from "@/app/api/utils/sql";

// GET - Get user's exercise selections for all muscle groups or a specific one
export async function GET(request) {
  try {
    const session = await getSession(request);
    if (!session || !session.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = session.user.id;
    const { searchParams } = new URL(request.url);
    const muscleGroup = searchParams.get("muscle_group");

    let selections;
    if (muscleGroup) {
      selections = await sql`
        SELECT * FROM user_exercise_selections
        WHERE user_id = ${userId} AND muscle_group = ${muscleGroup}
      `;
    } else {
      selections = await sql`
        SELECT * FROM user_exercise_selections
        WHERE user_id = ${userId}
        ORDER BY created_at DESC
      `;
    }

    return Response.json({ selections });
  } catch (err) {
    console.error("GET /api/exercise-selections error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}

// POST - Create or update exercise selection for a muscle group
export async function POST(request) {
  try {
    const session = await getSession(request);
    if (!session || !session.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = session.user.id;
    const body = await request.json();
    const { muscle_group, exercises } = body;

    if (!muscle_group || !exercises || !Array.isArray(exercises)) {
      return Response.json(
        { error: "muscle_group and exercises array are required" },
        { status: 400 },
      );
    }

    if (exercises.length !== 6) {
      return Response.json(
        { error: "Must select exactly 6 exercises" },
        { status: 400 },
      );
    }

    // Upsert exercise selection
    const result = await sql`
      INSERT INTO user_exercise_selections (user_id, muscle_group, exercises, updated_at)
      VALUES (${userId}, ${muscle_group}, ${JSON.stringify(exercises)}, CURRENT_TIMESTAMP)
      ON CONFLICT (user_id, muscle_group)
      DO UPDATE SET
        exercises = ${JSON.stringify(exercises)},
        updated_at = CURRENT_TIMESTAMP
      RETURNING *
    `;

    return Response.json({ selection: result[0] });
  } catch (err) {
    console.error("POST /api/exercise-selections error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}

// DELETE - Remove exercise selection for a muscle group
export async function DELETE(request) {
  try {
    const session = await getSession(request);
    if (!session || !session.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = session.user.id;
    const { searchParams } = new URL(request.url);
    const muscleGroup = searchParams.get("muscle_group");

    if (!muscleGroup) {
      return Response.json(
        { error: "muscle_group is required" },
        { status: 400 },
      );
    }

    await sql`
      DELETE FROM user_exercise_selections
      WHERE user_id = ${userId} AND muscle_group = ${muscleGroup}
    `;

    return Response.json({ success: true });
  } catch (err) {
    console.error("DELETE /api/exercise-selections error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
