import sql from "@/app/api/utils/sql";
import { getSession } from "@/app/api/utils/getSession";

// GET list all training splits for current user
export async function GET(request) {
  try {
    const session = await getSession(request);
    if (!session || !session.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = session.user.id;

    const splits = await sql`
      SELECT * FROM training_splits
      WHERE user_id = ${userId}
      ORDER BY is_active DESC, created_at DESC
    `;

    // Get days for each split
    for (let split of splits) {
      const days = await sql`
        SELECT * FROM split_days
        WHERE training_split_id = ${split.id}
        ORDER BY day_number
      `;
      split.days = days;
    }

    return Response.json({ splits });
  } catch (err) {
    console.error("GET /api/training-splits error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}

// POST create a new training split
export async function POST(request) {
  try {
    const session = await getSession(request);
    if (!session || !session.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = session.user.id;
    const body = await request.json();
    const { split_name, is_active, days_per_week, description, days } = body;

    // If setting this split as active, deactivate all others
    if (is_active) {
      await sql`
        UPDATE training_splits
        SET is_active = false
        WHERE user_id = ${userId}
      `;
    }

    // Create training split
    const splitResult = await sql`
      INSERT INTO training_splits (
        user_id,
        split_name,
        is_active,
        days_per_week,
        description
      ) VALUES (
        ${userId},
        ${split_name},
        ${is_active || false},
        ${days_per_week || null},
        ${description || null}
      )
      RETURNING *
    `;

    const splitId = splitResult[0].id;

    // Insert days
    for (let i = 0; i < days?.length || 0; i++) {
      const day = days[i];
      await sql`
        INSERT INTO split_days (
          training_split_id,
          day_number,
          day_name,
          muscle_groups,
          notes
        ) VALUES (
          ${splitId},
          ${i + 1},
          ${day.day_name},
          ${day.muscle_groups || []},
          ${day.notes || null}
        )
      `;
    }

    return Response.json({ split: splitResult[0] });
  } catch (err) {
    console.error("POST /api/training-splits error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}

// PUT update training split (mainly to set active/inactive)
export async function PUT(request) {
  try {
    const session = await getSession(request);
    if (!session || !session.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = session.user.id;
    const body = await request.json();
    const { split_id, is_active } = body;

    if (!split_id) {
      return Response.json({ error: "split_id required" }, { status: 400 });
    }

    // If setting as active, deactivate all others
    if (is_active) {
      await sql`
        UPDATE training_splits
        SET is_active = false
        WHERE user_id = ${userId}
      `;
    }

    const result = await sql`
      UPDATE training_splits
      SET
        is_active = ${is_active},
        updated_at = CURRENT_TIMESTAMP
      WHERE id = ${split_id} AND user_id = ${userId}
      RETURNING *
    `;

    if (result.length === 0) {
      return Response.json({ error: "Split not found" }, { status: 404 });
    }

    return Response.json({ split: result[0] });
  } catch (err) {
    console.error("PUT /api/training-splits error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
