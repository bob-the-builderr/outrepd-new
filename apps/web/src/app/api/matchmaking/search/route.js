import sql from "@/app/api/utils/sql";
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

// GET /api/matchmaking/search — search for a match
export async function GET(request) {
  try {
    // Server-side subscription gate — blocks non-subscribers
    let userId;
    try {
      const sub = await requireSubscription(request);
      userId = parseInt(sub.userId);
    } catch (subError) {
      return subError;
    }

    // First check if user was matched by someone else (as guest)
    const existingMatch = await sql`
      SELECT pm.*, au.name as host_name, au.email as host_email, up.username as host_username
      FROM pending_matches pm
      JOIN auth_users au ON pm.host_user_id = au.id
      LEFT JOIN user_profiles up ON au.id = up.user_id
      WHERE pm.guest_user_id = ${userId}
        AND pm.status = 'active'
        AND pm.created_at > CURRENT_TIMESTAMP - INTERVAL '5 minutes'
      ORDER BY pm.created_at DESC
      LIMIT 1
    `;

    if (existingMatch.length > 0) {
      const match = existingMatch[0];
      return Response.json({
        match_found: true,
        invite_code: match.invite_code,
        pending_match: match,
        opponent: {
          name:
            match.host_username ||
            match.host_name ||
            match.host_email ||
            "Opponent",
          tier_idx: match.host_tier_idx,
          div_idx: match.host_div_idx,
        },
        role: "guest", // This user is the guest
      });
    }

    // Get user's queue entry
    const [myEntry] = await sql`
      SELECT * FROM matchmaking_queue WHERE user_id = ${userId}
    `;

    if (!myEntry) {
      return Response.json({ error: "Not in queue" }, { status: 404 });
    }

    // Remove expired entries
    await sql`
      DELETE FROM matchmaking_queue
      WHERE expires_at < CURRENT_TIMESTAMP
    `;

    // Search for opponents with same muscle group and similar rank
    // Allow matching within same tier or adjacent tiers
    const minTierIdx = Math.max(0, myEntry.tier_idx - 1);
    const maxTierIdx = Math.min(8, myEntry.tier_idx + 1);

    const potentialOpponents = await sql`
      SELECT mq.*, au.name, au.email, up.username, up.profile_photo_url
      FROM matchmaking_queue mq
      JOIN auth_users au ON mq.user_id = au.id
      LEFT JOIN user_profiles up ON au.id = up.user_id
      WHERE mq.user_id != ${userId}
        AND mq.muscle_group = ${myEntry.muscle_group}
        AND mq.tier_idx >= ${minTierIdx}
        AND mq.tier_idx <= ${maxTierIdx}
        AND mq.expires_at > CURRENT_TIMESTAMP
      ORDER BY 
        ABS(mq.tier_idx - ${myEntry.tier_idx}),
        ABS(mq.div_idx - ${myEntry.div_idx}),
        mq.created_at ASC
      LIMIT 1
    `;

    if (potentialOpponents.length === 0) {
      return Response.json({ match_found: false });
    }

    const opponent = potentialOpponents[0];

    // Generate unique invite code
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

    // Create pending match
    const [pendingMatch] = await sql`
      INSERT INTO pending_matches (
        invite_code, host_user_id, guest_user_id, muscle_group,
        host_tier_idx, host_div_idx, host_lp, host_demotion_shield,
        guest_tier_idx, guest_div_idx, guest_lp, guest_demotion_shield,
        status
      ) VALUES (
        ${inviteCode}, ${userId}, ${opponent.user_id}, ${myEntry.muscle_group},
        ${myEntry.tier_idx}, ${myEntry.div_idx}, ${myEntry.lp}, ${myEntry.demotion_shield},
        ${opponent.tier_idx}, ${opponent.div_idx}, ${opponent.lp}, ${opponent.demotion_shield},
        'active'
      )
      RETURNING *
    `;

    // Remove both users from queue
    await sql`
      DELETE FROM matchmaking_queue 
      WHERE user_id IN (${userId}, ${opponent.user_id})
    `;

    return Response.json({
      match_found: true,
      invite_code: inviteCode,
      pending_match: pendingMatch,
      opponent: {
        name:
          opponent.username || opponent.name || opponent.email || "Opponent",
        tier_idx: opponent.tier_idx,
        div_idx: opponent.div_idx,
        profile_photo_url: opponent.profile_photo_url,
      },
      role: "host", // User who called this endpoint becomes host
    });
  } catch (err) {
    console.error("GET /api/matchmaking/search error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
