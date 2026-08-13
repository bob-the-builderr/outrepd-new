import sql from "@/app/api/utils/sql";
import { getSession } from "@/app/api/utils/getSession";
import { requireSubscription } from "@/app/api/utils/subscription-middleware";

// POST /api/matchmaking/queue — join the matchmaking queue
export async function POST(request) {
  try {
    // Server-side subscription gate — blocks non-subscribers from ranked play
    let userId;
    try {
      const sub = await requireSubscription(request);
      userId = parseInt(sub.userId);
    } catch (subError) {
      return subError;
    }

    const body = await request.json();
    const { muscle_group, tier_idx, div_idx, lp, demotion_shield } = body;

    if (!muscle_group) {
      return Response.json(
        { error: "muscle_group is required" },
        { status: 400 },
      );
    }

    // Check that user has set their height — required for ranked matches
    const [userProfile] = await sql`
      SELECT height_cm FROM user_profiles WHERE user_id = ${userId}
    `;

    if (
      !userProfile ||
      userProfile.height_cm === null ||
      userProfile.height_cm === undefined
    ) {
      return Response.json(
        {
          error: "height_required",
          message:
            "You must set your height in Settings before entering ranked matches.",
        },
        { status: 403 },
      );
    }

    // Remove any expired entries first
    await sql`
      DELETE FROM matchmaking_queue
      WHERE expires_at < CURRENT_TIMESTAMP
    `;

    // Check if user is already in queue
    const existing = await sql`
      SELECT id FROM matchmaking_queue WHERE user_id = ${userId}
    `;

    if (existing.length > 0) {
      // Update existing entry
      const [updated] = await sql`
        UPDATE matchmaking_queue SET
          muscle_group = ${muscle_group},
          tier_idx = ${tier_idx ?? 0},
          div_idx = ${div_idx ?? 0},
          lp = ${lp ?? 0},
          demotion_shield = ${demotion_shield ?? false},
          created_at = CURRENT_TIMESTAMP,
          expires_at = CURRENT_TIMESTAMP + INTERVAL '10 minutes'
        WHERE user_id = ${userId}
        RETURNING *
      `;
      return Response.json({ queue_entry: updated });
    }

    // Insert new entry
    const [queueEntry] = await sql`
      INSERT INTO matchmaking_queue (
        user_id, muscle_group, tier_idx, div_idx, lp, demotion_shield
      ) VALUES (
        ${userId}, ${muscle_group}, ${tier_idx ?? 0}, ${div_idx ?? 0}, 
        ${lp ?? 0}, ${demotion_shield ?? false}
      )
      RETURNING *
    `;

    return Response.json({ queue_entry: queueEntry });
  } catch (err) {
    console.error("POST /api/matchmaking/queue error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}

// DELETE /api/matchmaking/queue — leave the matchmaking queue
export async function DELETE(request) {
  try {
    const session = await getSession(request);
    if (!session?.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = parseInt(session.user.id);

    await sql`
      DELETE FROM matchmaking_queue WHERE user_id = ${userId}
    `;

    return Response.json({ success: true });
  } catch (err) {
    console.error("DELETE /api/matchmaking/queue error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
