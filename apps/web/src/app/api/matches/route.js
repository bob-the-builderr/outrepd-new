import sql from "@/app/api/utils/sql";
import { getSession } from "@/app/api/utils/getSession";
import { requireSubscription } from "@/app/api/utils/subscription-middleware";

// GET list all matches for current user
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
    const date = searchParams.get("date"); // New: filter by specific date

    let matches;

    if (date) {
      // Fetch matches for a specific date
      matches = await sql`
        SELECT 
          m.id, m.user_id, m.opponent_id,
          COALESCE(up.username, m.opponent_name) AS opponent_name,
          COALESCE(up.profile_photo_url, m.opponent_photo_url) AS opponent_photo_url,
          m.opponent_tier_idx, m.opponent_div_idx,
          m.result, m.lp_change, m.lp_after,
          m.tier_idx_before, m.div_idx_before, m.tier_idx_after, m.div_idx_after,
          m.user_volume_kg, m.opponent_volume_kg,
          m.promoted, m.demoted, m.match_date, m.created_at
        FROM matches m
        LEFT JOIN user_profiles up ON m.opponent_id = up.user_id
        WHERE m.user_id = ${userId}
        AND DATE(m.match_date) = ${date}
        ORDER BY m.match_date DESC
      `;
    } else {
      // Fetch all matches with pagination
      matches = await sql`
        SELECT 
          m.id, m.user_id, m.opponent_id,
          COALESCE(up.username, m.opponent_name) AS opponent_name,
          COALESCE(up.profile_photo_url, m.opponent_photo_url) AS opponent_photo_url,
          m.opponent_tier_idx, m.opponent_div_idx,
          m.result, m.lp_change, m.lp_after,
          m.tier_idx_before, m.div_idx_before, m.tier_idx_after, m.div_idx_after,
          m.user_volume_kg, m.opponent_volume_kg,
          m.promoted, m.demoted, m.match_date, m.created_at
        FROM matches m
        LEFT JOIN user_profiles up ON m.opponent_id = up.user_id
        WHERE m.user_id = ${userId}
        ORDER BY m.match_date DESC
        LIMIT ${limit}
        OFFSET ${offset}
      `;
    }

    return Response.json({ matches });
  } catch (err) {
    console.error("GET /api/matches error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}

// POST create a new match result
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
    const {
      opponent_id,
      opponent_name,
      opponent_photo_url,
      opponent_tier_idx,
      opponent_div_idx,
      result,
      lp_change,
      lp_after,
      tier_idx_before,
      div_idx_before,
      tier_idx_after,
      div_idx_after,
      user_volume_kg,
      opponent_volume_kg,
      promoted,
      demoted,
    } = body;

    // Validate required fields
    if (!result || !["win", "loss"].includes(result)) {
      return Response.json({ error: "Invalid result" }, { status: 400 });
    }

    // Create match record
    const matchResult = await sql`
      INSERT INTO matches (
        user_id,
        opponent_id,
        opponent_name,
        opponent_photo_url,
        opponent_tier_idx,
        opponent_div_idx,
        result,
        lp_change,
        lp_after,
        tier_idx_before,
        div_idx_before,
        tier_idx_after,
        div_idx_after,
        user_volume_kg,
        opponent_volume_kg,
        promoted,
        demoted
      ) VALUES (
        ${userId},
        ${opponent_id || null},
        ${opponent_name || null},
        ${opponent_photo_url || null},
        ${opponent_tier_idx || null},
        ${opponent_div_idx || null},
        ${result},
        ${lp_change},
        ${lp_after},
        ${tier_idx_before},
        ${div_idx_before},
        ${tier_idx_after},
        ${div_idx_after},
        ${user_volume_kg || null},
        ${opponent_volume_kg || null},
        ${promoted || false},
        ${demoted || false}
      )
      RETURNING *
    `;

    // Update user profile stats
    const isWin = result === "win";
    await sql`
      UPDATE user_profiles
      SET
        tier_idx = ${tier_idx_after},
        div_idx = ${div_idx_after},
        lp = ${lp_after},
        total_matches = total_matches + 1,
        wins = wins + ${isWin ? 1 : 0},
        losses = losses + ${isWin ? 0 : 1},
        current_win_streak = ${isWin ? sql`current_win_streak + 1` : sql`0`},
        current_loss_streak = ${isWin ? sql`0` : sql`current_loss_streak + 1`},
        best_win_streak = ${isWin ? sql`GREATEST(best_win_streak, current_win_streak + 1)` : sql`best_win_streak`},
        last_match_at = CURRENT_TIMESTAMP,
        updated_at = CURRENT_TIMESTAMP
      WHERE user_id = ${userId}
    `;

    return Response.json({ match: matchResult[0] });
  } catch (err) {
    console.error("POST /api/matches error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
