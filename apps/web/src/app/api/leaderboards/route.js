import { getSession } from "@/app/api/utils/getSession";
import sql from "@/app/api/utils/sql";

export async function GET(request) {
  try {
    const session = await getSession(request);
    if (!session?.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { searchParams } = new URL(request.url);
    const type = searchParams.get("type") || "global";
    const limit = parseInt(searchParams.get("limit") || "100");

    if (type === "global") {
      const leaderboard = await sql`
        SELECT
          up.user_id, up.username, up.lp, up.tier_idx, up.div_idx,
          up.wins, up.losses, up.total_matches, up.profile_photo_url,
          up.country, up.created_at, au.name
        FROM user_profiles up
        LEFT JOIN auth_users au ON up.user_id = au.id
        WHERE up.username IS NOT NULL
        ORDER BY up.lp DESC, up.created_at ASC
        LIMIT ${limit}
      `;

      const rankedLeaderboard = leaderboard.map((user, index) => ({
        ...user,
        rank: index + 1,
        is_current_user: String(user.user_id) === String(session.user.id),
      }));

      const inList = rankedLeaderboard.find((u) => u.is_current_user);
      let currentUser = null;

      if (!inList) {
        const [posRow] = await sql`
          SELECT COUNT(*) AS cnt FROM user_profiles
          WHERE lp > (SELECT lp FROM user_profiles WHERE user_id = ${session.user.id})
          OR (
            lp = (SELECT lp FROM user_profiles WHERE user_id = ${session.user.id})
            AND created_at < (SELECT created_at FROM user_profiles WHERE user_id = ${session.user.id})
          )
        `;

        const [userData] = await sql`
          SELECT up.user_id, up.username, up.lp, up.tier_idx, up.div_idx,
            up.wins, up.losses, up.total_matches, up.profile_photo_url,
            up.country, up.created_at, au.name
          FROM user_profiles up
          LEFT JOIN auth_users au ON up.user_id = au.id
          WHERE up.user_id = ${session.user.id}
        `;

        if (userData) {
          currentUser = {
            ...userData,
            rank: parseInt(posRow.cnt) + 1,
            is_current_user: true,
          };
        }
      }

      return Response.json({
        leaderboard: rankedLeaderboard,
        current_user: currentUser,
        type: "global",
      });
    }

    if (type === "local") {
      const [currentProfile] = await sql`
        SELECT country FROM user_profiles WHERE user_id = ${session.user.id}
      `;

      const userCountry = currentProfile?.country;

      if (!userCountry) {
        return Response.json({
          leaderboard: [],
          current_user: null,
          type: "local",
          no_country: true,
        });
      }

      const leaderboard = await sql`
        SELECT
          up.user_id, up.username, up.lp, up.tier_idx, up.div_idx,
          up.wins, up.losses, up.total_matches, up.profile_photo_url,
          up.country, up.created_at, au.name
        FROM user_profiles up
        LEFT JOIN auth_users au ON up.user_id = au.id
        WHERE up.country = ${userCountry}
          AND up.username IS NOT NULL
        ORDER BY up.lp DESC, up.created_at ASC
        LIMIT ${limit}
      `;

      const rankedLeaderboard = leaderboard.map((user, index) => ({
        ...user,
        rank: index + 1,
        is_current_user: String(user.user_id) === String(session.user.id),
      }));

      return Response.json({
        leaderboard: rankedLeaderboard,
        current_user: rankedLeaderboard.find((u) => u.is_current_user) || null,
        type: "local",
        country: userCountry,
      });
    }

    return Response.json({ error: "Invalid type" }, { status: 400 });
  } catch (error) {
    console.error("Error fetching leaderboards:", error);
    return Response.json(
      { error: "Failed to fetch leaderboards" },
      { status: 500 },
    );
  }
}
