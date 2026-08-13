import sql from "@/app/api/utils/sql";
import { getSession } from "@/app/api/utils/getSession";

export async function GET(request, { params }) {
  const session = await getSession(request);
  if (!session?.user?.id) {
    return Response.json({ error: "Unauthorized" }, { status: 401 });
  }

  const { userId } = params;
  const targetUserId = parseInt(userId, 10);

  if (isNaN(targetUserId)) {
    return Response.json({ error: "Invalid user ID" }, { status: 400 });
  }

  try {
    // Fetch public profile data
    const profileResult = await sql`
      SELECT 
        up.user_id,
        up.username,
        up.tier_idx,
        up.div_idx,
        up.lp,
        up.total_matches,
        up.wins,
        up.losses,
        up.current_win_streak,
        up.best_win_streak,
        up.total_volume_kg,
        up.profile_photo_url,
        up.country,
        up.created_at,
        au.name
      FROM user_profiles up
      LEFT JOIN auth_users au ON up.user_id = au.id
      WHERE up.user_id = ${targetUserId}
      LIMIT 1
    `;

    if (profileResult.length === 0) {
      return Response.json({ error: "User not found" }, { status: 404 });
    }

    const profile = profileResult[0];

    // Fetch recent matches (last 10) — join user_profiles for live opponent data
    const matchesResult = await sql`
      SELECT 
        m.id,
        COALESCE(up.username, m.opponent_name) AS opponent_name,
        COALESCE(up.profile_photo_url, m.opponent_photo_url) AS opponent_photo_url,
        m.opponent_tier_idx,
        m.opponent_div_idx,
        m.result,
        m.lp_change,
        m.tier_idx_after,
        m.div_idx_after,
        m.user_volume_kg,
        m.opponent_volume_kg,
        m.match_date,
        m.promoted,
        m.demoted
      FROM matches m
      LEFT JOIN user_profiles up ON m.opponent_id = up.user_id
      WHERE m.user_id = ${targetUserId}
      ORDER BY m.match_date DESC
      LIMIT 10
    `;

    // Fetch achievements
    const achievementsResult = await sql`
      SELECT 
        a.achievement_key,
        a.title,
        a.description,
        a.icon,
        a.category,
        ua.earned_at
      FROM user_achievements ua
      JOIN achievements a ON ua.achievement_id = a.id
      WHERE ua.user_id = ${targetUserId}
      ORDER BY ua.earned_at DESC
    `;

    // Check friendship status
    const friendshipResult = await sql`
      SELECT status
      FROM friendships
      WHERE (user_id = ${session.user.id} AND friend_id = ${targetUserId})
         OR (user_id = ${targetUserId} AND friend_id = ${session.user.id})
      LIMIT 1
    `;

    const friendshipStatus =
      friendshipResult.length > 0 ? friendshipResult[0].status : null;

    return Response.json({
      profile,
      matches: matchesResult,
      achievements: achievementsResult,
      friendshipStatus,
      isOwnProfile: session.user.id === targetUserId,
    });
  } catch (error) {
    console.error("Error fetching user profile:", error);
    return Response.json({ error: "Internal server error" }, { status: 500 });
  }
}
