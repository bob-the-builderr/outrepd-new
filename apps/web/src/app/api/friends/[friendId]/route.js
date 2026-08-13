import sql from "@/app/api/utils/sql";
import { getSession } from "@/app/api/utils/getSession";

// GET /api/friends/[friendId] — get friend profile and match record between you and them
export async function GET(request, { params }) {
  try {
    const session = await getSession(request);
    if (!session?.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = parseInt(session.user.id);
    const friendId = parseInt(params.friendId);

    // Verify friendship exists
    const [friendship] = await sql`
      SELECT * FROM friendships 
      WHERE ((user_id = ${userId} AND friend_id = ${friendId})
         OR (user_id = ${friendId} AND friend_id = ${userId}))
        AND status = 'accepted'
    `;

    if (!friendship) {
      return Response.json({ error: "Friendship not found" }, { status: 404 });
    }

    // Get friend profile
    const [friendProfile] = await sql`
      SELECT 
        up.*,
        au.name,
        au.email
      FROM user_profiles up
      JOIN auth_users au ON up.user_id = au.id
      WHERE up.user_id = ${friendId}
    `;

    if (!friendProfile) {
      return Response.json(
        { error: "Friend profile not found" },
        { status: 404 },
      );
    }

    // Get match history between these two users
    const matches = await sql`
      SELECT * FROM matches 
      WHERE user_id = ${userId} AND opponent_id = ${friendId}
      ORDER BY match_date DESC
      LIMIT 20
    `;

    // Calculate win/loss/draw record
    const wins = matches.filter((m) => m.result === "win").length;
    const losses = matches.filter((m) => m.result === "loss").length;
    const draws = matches.filter((m) => m.result === "draw").length;

    return Response.json({
      friend: friendProfile,
      match_record: {
        wins,
        losses,
        draws,
        total: matches.length,
      },
      recent_matches: matches,
    });
  } catch (err) {
    console.error("GET /api/friends/[friendId] error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
