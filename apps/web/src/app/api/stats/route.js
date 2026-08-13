import sql from "@/app/api/utils/sql";
import { getSession } from "@/app/api/utils/getSession";

// GET user stats
export async function GET(request) {
  try {
    const session = await getSession(request);
    if (!session || !session.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = session.user.id;

    // Get profile stats
    const profiles = await sql`
      SELECT
        tier_idx,
        div_idx,
        lp,
        total_matches,
        wins,
        losses,
        current_win_streak,
        current_loss_streak,
        best_win_streak,
        total_volume_kg,
        last_match_at
      FROM user_profiles
      WHERE user_id = ${userId}
      LIMIT 1
    `;

    const profile = profiles[0] || {
      tier_idx: 0,
      div_idx: 0,
      lp: 0,
      total_matches: 0,
      wins: 0,
      losses: 0,
      current_win_streak: 0,
      current_loss_streak: 0,
      best_win_streak: 0,
      total_volume_kg: 0,
      last_match_at: null,
    };

    // Get recent matches
    const recentMatches = await sql`
      SELECT * FROM matches
      WHERE user_id = ${userId}
      ORDER BY match_date DESC
      LIMIT 10
    `;

    // Get personal records
    const personalRecords = await sql`
      SELECT * FROM personal_records
      WHERE user_id = ${userId}
      ORDER BY achieved_at DESC
    `;

    // Calculate win rate
    const winRate =
      profile.total_matches > 0
        ? ((profile.wins / profile.total_matches) * 100).toFixed(1)
        : 0;

    const stats = {
      ...profile,
      win_rate: parseFloat(winRate),
      recent_matches: recentMatches,
      personal_records: personalRecords,
    };

    return Response.json({ stats });
  } catch (err) {
    console.error("GET /api/stats error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
