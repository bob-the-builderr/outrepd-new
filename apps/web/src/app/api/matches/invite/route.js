import sql from "@/app/api/utils/sql";
import { getSession } from "@/app/api/utils/getSession";
import { requireSubscription } from "@/app/api/utils/subscription-middleware";

function generateInviteCode() {
  const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  let code = "";
  for (let i = 0; i < 8; i++) {
    if (i === 4) code += "-";
    code += chars[Math.floor(Math.random() * chars.length)];
  }
  return code;
}

// POST /api/matches/invite — create a new pending match invite
export async function POST(request) {
  try {
    // Server-side subscription gate
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

    // Cancel any existing waiting invites for this user
    await sql`
      UPDATE pending_matches
      SET status = 'cancelled'
      WHERE host_user_id = ${userId} AND status = 'waiting'
    `;

    // Generate a unique invite code (retry if collision)
    let inviteCode;
    let attempts = 0;
    while (attempts < 10) {
      inviteCode = generateInviteCode();
      const existing = await sql`
        SELECT id FROM pending_matches WHERE invite_code = ${inviteCode}
      `;
      if (existing.length === 0) break;
      attempts++;
    }

    const [pendingMatch] = await sql`
      INSERT INTO pending_matches (
        invite_code, host_user_id, muscle_group,
        host_tier_idx, host_div_idx, host_lp, host_demotion_shield
      ) VALUES (
        ${inviteCode}, ${userId}, ${muscle_group},
        ${tier_idx ?? 0}, ${div_idx ?? 0}, ${lp ?? 0}, ${demotion_shield ?? false}
      )
      RETURNING *
    `;

    return Response.json({ invite: pendingMatch, invite_code: inviteCode });
  } catch (err) {
    console.error("POST /api/matches/invite error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
