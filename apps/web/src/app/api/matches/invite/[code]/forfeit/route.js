import sql from "@/app/api/utils/sql";
import { getSession } from "@/app/api/utils/getSession";
import { getLPChange, applyLPChange } from "@/app/api/utils/lpSystem";

async function updateProfile(userId, newState, won) {
  if (won) {
    await sql`
      UPDATE user_profiles SET
        tier_idx = ${newState.tierIdx},
        div_idx = ${newState.divIdx},
        lp = ${newState.lp},
        demotion_shield = ${newState.demotionShield ? new Date().toISOString() : null},
        total_matches = total_matches + 1,
        wins = wins + 1,
        current_win_streak = current_win_streak + 1,
        current_loss_streak = 0,
        best_win_streak = GREATEST(best_win_streak, current_win_streak + 1),
        last_match_at = CURRENT_TIMESTAMP,
        updated_at = CURRENT_TIMESTAMP
      WHERE user_id = ${userId}
    `;
  } else {
    await sql`
      UPDATE user_profiles SET
        tier_idx = ${newState.tierIdx},
        div_idx = ${newState.divIdx},
        lp = ${newState.lp},
        demotion_shield = ${newState.demotionShield ? new Date().toISOString() : null},
        total_matches = total_matches + 1,
        losses = losses + 1,
        current_win_streak = 0,
        current_loss_streak = current_loss_streak + 1,
        last_match_at = CURRENT_TIMESTAMP,
        updated_at = CURRENT_TIMESTAMP
      WHERE user_id = ${userId}
    `;
  }
}

// POST /api/matches/invite/[code]/forfeit — forfeiting player loses instantly
export async function POST(request, { params }) {
  try {
    const session = await getSession(request);
    if (!session?.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = parseInt(session.user.id);
    const { code } = params;

    // Fetch the active match
    const [match] = await sql`
      SELECT * FROM pending_matches
      WHERE invite_code = ${code} AND status = 'active'
    `;

    if (!match) {
      return Response.json(
        { error: "Active match not found" },
        { status: 404 },
      );
    }

    const isHost = match.host_user_id === userId;
    const isGuest = match.guest_user_id === userId;

    if (!isHost && !isGuest) {
      return Response.json(
        { error: "You are not in this match" },
        { status: 403 },
      );
    }

    // Forfeiter loses, opponent wins
    const forfeiterId = userId;
    const winnerId = isHost ? match.guest_user_id : match.host_user_id;

    const [forfeiterProfile] =
      await sql`SELECT * FROM user_profiles WHERE user_id = ${forfeiterId}`;
    const [winnerProfile] =
      await sql`SELECT * FROM user_profiles WHERE user_id = ${winnerId}`;

    const forfeiterTierIdx = isHost
      ? parseInt(match.host_tier_idx)
      : parseInt(match.guest_tier_idx);
    const winnerTierIdx = isHost
      ? parseInt(match.guest_tier_idx)
      : parseInt(match.host_tier_idx);

    const forfeiterLpChange = getLPChange(
      "loss",
      winnerTierIdx,
      forfeiterTierIdx,
    );
    const winnerLpChange = getLPChange("win", forfeiterTierIdx, winnerTierIdx);

    const forfeiterNewState = applyLPChange(
      {
        tierIdx: forfeiterProfile.tier_idx,
        divIdx: forfeiterProfile.div_idx,
        lp: forfeiterProfile.lp,
        demotionShield: !!forfeiterProfile.demotion_shield,
      },
      forfeiterLpChange,
    );
    const winnerNewState = applyLPChange(
      {
        tierIdx: winnerProfile.tier_idx,
        divIdx: winnerProfile.div_idx,
        lp: winnerProfile.lp,
        demotionShield: !!winnerProfile.demotion_shield,
      },
      winnerLpChange,
    );

    // Mark the match cancelled with results so the opponent's poll can pick it up
    const hostWon = isGuest; // host wins if guest forfeited, vice-versa
    await sql`
      UPDATE pending_matches SET
        status = 'cancelled',
        host_result   = ${hostWon ? "win" : "loss"},
        guest_result  = ${hostWon ? "loss" : "win"},
        host_lp_change  = ${isHost ? forfeiterLpChange : winnerLpChange},
        guest_lp_change = ${isGuest ? forfeiterLpChange : winnerLpChange},
        host_volume_kg  = COALESCE(host_volume_kg, 0),
        guest_volume_kg = COALESCE(guest_volume_kg, 0)
      WHERE invite_code = ${code}
    `;

    // Update profiles
    await updateProfile(forfeiterId, forfeiterNewState, false);
    await updateProfile(winnerId, winnerNewState, true);

    // Persist match records for history
    const [forfeiterData] =
      await sql`SELECT username, profile_photo_url FROM user_profiles WHERE user_id = ${forfeiterId}`;
    const [winnerData] =
      await sql`SELECT username, profile_photo_url FROM user_profiles WHERE user_id = ${winnerId}`;
    const forfeiterName = forfeiterData?.username || "Opponent";
    const winnerName = winnerData?.username || "Opponent";
    const forfeiterPhoto = forfeiterData?.profile_photo_url || null;
    const winnerPhoto = winnerData?.profile_photo_url || null;

    await sql`
      INSERT INTO matches (
        user_id, opponent_id, opponent_name, opponent_photo_url,
        opponent_tier_idx, opponent_div_idx,
        result, lp_change, lp_after,
        tier_idx_before, div_idx_before,
        tier_idx_after, div_idx_after,
        user_volume_kg, opponent_volume_kg,
        promoted, demoted
      ) VALUES (
        ${forfeiterId}, ${winnerId}, ${winnerName}, ${winnerPhoto},
        ${winnerTierIdx}, ${isHost ? parseInt(match.guest_div_idx) : parseInt(match.host_div_idx)},
        'loss', ${forfeiterLpChange}, ${forfeiterNewState.lp},
        ${forfeiterProfile.tier_idx}, ${forfeiterProfile.div_idx},
        ${forfeiterNewState.tierIdx}, ${forfeiterNewState.divIdx},
        0, 0,
        ${forfeiterNewState.demoted || false}, ${false}
      )
    `;

    await sql`
      INSERT INTO matches (
        user_id, opponent_id, opponent_name, opponent_photo_url,
        opponent_tier_idx, opponent_div_idx,
        result, lp_change, lp_after,
        tier_idx_before, div_idx_before,
        tier_idx_after, div_idx_after,
        user_volume_kg, opponent_volume_kg,
        promoted, demoted
      ) VALUES (
        ${winnerId}, ${forfeiterId}, ${forfeiterName}, ${forfeiterPhoto},
        ${forfeiterTierIdx}, ${isHost ? parseInt(match.host_div_idx) : parseInt(match.guest_div_idx)},
        'win', ${winnerLpChange}, ${winnerNewState.lp},
        ${winnerProfile.tier_idx}, ${winnerProfile.div_idx},
        ${winnerNewState.tierIdx}, ${winnerNewState.divIdx},
        0, 0,
        ${winnerNewState.promoted || false}, ${false}
      )
    `;

    // Notify the winner that their opponent forfeited
    await sql`
      INSERT INTO notifications (user_id, type, title, message, data)
      VALUES (
        ${winnerId},
        'match_result',
        'Victory! Opponent Forfeited',
        ${`${forfeiterName} forfeited. You win! +${winnerLpChange} LP`},
        ${JSON.stringify({ match_code: code, result: "win", lp_change: winnerLpChange, opponent_id: forfeiterId, forfeit: true })}
      )
    `;

    return Response.json({
      status: "cancelled",
      forfeiter_lp_change: forfeiterLpChange,
      forfeiter_new_state: forfeiterNewState,
    });
  } catch (err) {
    console.error("POST /api/matches/invite/[code]/forfeit error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
