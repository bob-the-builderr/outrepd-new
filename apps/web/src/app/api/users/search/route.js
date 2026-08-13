import sql from "@/app/api/utils/sql";
import { getSession } from "@/app/api/utils/getSession";

// GET /api/users/search?q=username — search users by username
export async function GET(request) {
  try {
    const session = await getSession(request);
    if (!session?.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = parseInt(session.user.id);
    const { searchParams } = new URL(request.url);
    const query = searchParams.get("q");

    if (!query || query.trim().length === 0) {
      return Response.json({ users: [] });
    }

    // Build the LIKE pattern separately to avoid neon template interpolation issues
    const searchPattern = "%" + query.trim().toLowerCase() + "%";

    // Use function form of sql with explicit $1/$2 to safely handle LIKE wildcards
    const users = await sql(
      `SELECT 
        au.id as user_id,
        au.name,
        up.username,
        up.tier_idx,
        up.div_idx,
        up.lp,
        up.profile_photo_url,
        up.wins,
        up.losses,
        up.total_matches,
        (
          SELECT status FROM friendships 
          WHERE (user_id = $2 AND friend_id = au.id)
             OR (user_id = au.id AND friend_id = $2)
          LIMIT 1
        ) as friendship_status
      FROM auth_users au
      JOIN user_profiles up ON au.id = up.user_id
      WHERE LOWER(up.username) LIKE $1
        AND au.id != $2
      ORDER BY up.username ASC
      LIMIT 20`,
      [searchPattern, userId],
    );

    return Response.json({ users });
  } catch (err) {
    console.error("GET /api/users/search error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
