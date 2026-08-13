import sql from "@/app/api/utils/sql";
import { getSession } from "@/app/api/utils/getSession";

// GET /api/matches/invite/[code] — poll match status
export async function GET(request, { params }) {
  try {
    const session = await getSession(request);
    if (!session?.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const { code } = params;

    const [match] = await sql`
      SELECT
        pm.*,
        hu.name AS host_name,
        hu.email AS host_email,
        gu.name AS guest_name,
        gu.email AS guest_email,
        hup.username AS host_username,
        gup.username AS guest_username,
        hup.profile_photo_url AS host_profile_photo_url,
        gup.profile_photo_url AS guest_profile_photo_url
      FROM pending_matches pm
      JOIN auth_users hu ON hu.id = pm.host_user_id
      LEFT JOIN auth_users gu ON gu.id = pm.guest_user_id
      LEFT JOIN user_profiles hup ON hup.user_id = pm.host_user_id
      LEFT JOIN user_profiles gup ON gup.user_id = pm.guest_user_id
      WHERE pm.invite_code = ${code}
    `;

    if (!match) {
      return Response.json({ error: "Invite not found" }, { status: 404 });
    }

    // Check if actually expired by time or non-waiting status
    const isExpiredByTime = new Date(match.expires_at) <= new Date();
    const isExpiredByStatus = match.status !== "waiting";

    return Response.json({
      match,
      expired: isExpiredByTime || isExpiredByStatus,
    });
  } catch (err) {
    console.error("GET /api/matches/invite/[code] error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}

// POST /api/matches/invite/[code] — guest joins the match
export async function POST(request, { params }) {
  try {
    const session = await getSession(request);
    if (!session?.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = parseInt(session.user.id);
    const { code } = params;
    const body = await request.json();
    const { tier_idx, div_idx, lp, demotion_shield } = body;

    const [match] = await sql`
      SELECT * FROM pending_matches
      WHERE invite_code = ${code}
        AND status = 'waiting'
        AND expires_at > NOW()
    `;

    if (!match) {
      return Response.json(
        { error: "Invite not found, already taken, or expired" },
        { status: 404 },
      );
    }

    if (match.host_user_id === userId) {
      return Response.json(
        { error: "You cannot join your own match" },
        { status: 400 },
      );
    }

    const [updated] = await sql`
      UPDATE pending_matches
      SET
        guest_user_id = ${userId},
        guest_tier_idx = ${tier_idx ?? 0},
        guest_div_idx = ${div_idx ?? 0},
        guest_lp = ${lp ?? 0},
        guest_demotion_shield = ${demotion_shield ?? false},
        status = 'active'
      WHERE invite_code = ${code} AND status = 'waiting'
      RETURNING *
    `;

    if (!updated) {
      return Response.json(
        { error: "Match was already taken" },
        { status: 409 },
      );
    }

    // Fetch host info
    const [hostUser] = await sql`
      SELECT name FROM auth_users WHERE id = ${match.host_user_id}
    `;

    // Get guest username
    const [guestProfile] = await sql`
      SELECT username FROM user_profiles WHERE user_id = ${userId}
    `;
    const guestName = guestProfile?.username || "Someone";

    // Send notification to host
    await sql`
      INSERT INTO notifications (user_id, type, title, message, data)
      VALUES (
        ${match.host_user_id},
        'match_invite',
        'Match Started!',
        ${`${guestName} has joined your match. Time to battle!`},
        ${JSON.stringify({ match_code: code, opponent_id: userId })}
      )
    `;

    return Response.json({ match: updated, host_name: hostUser?.name });
  } catch (err) {
    console.error("POST /api/matches/invite/[code] error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
