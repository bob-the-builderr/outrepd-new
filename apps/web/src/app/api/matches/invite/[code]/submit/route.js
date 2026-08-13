import sql from "@/app/api/utils/sql";
import { getSession } from "@/app/api/utils/getSession";
import { getLPChange, applyLPChange } from "@/app/api/utils/lpSystem";
import { requireSubscription } from "@/app/api/utils/subscription-middleware";

// Helper function to award an achievement
async function awardAchievement(userId, achievementKey) {
  try {
    // Get achievement details
    const achievement = await sql`
      SELECT * FROM achievements WHERE achievement_key = ${achievementKey}
    `;

    if (achievement.length === 0) return null;

    // Check if user already has this achievement
    const existing = await sql`
      SELECT id FROM user_achievements 
      WHERE user_id = ${userId} AND achievement_id = ${achievement[0].id}
    `;

    if (existing.length > 0) return null;

    // Award the achievement
    await sql`
      INSERT INTO user_achievements (user_id, achievement_id)
      VALUES (${userId}, ${achievement[0].id})
    `;

    // Create notification
    await sql`
      INSERT INTO notifications (user_id, type, title, message, data)
      VALUES (
        ${userId}, 
        'achievement_unlocked',
        'Achievement Unlocked!',
        ${`You earned: ${achievement[0].title}`},
        ${JSON.stringify({ achievement_id: achievement[0].id, achievement_key: achievementKey })}
      )
    `;

    return achievement[0];
  } catch (error) {
    console.error("Award achievement error:", error);
    return null;
  }
}

// Helper function to check achievements after a match
async function checkMatchAchievements(userId, won, newState) {
  try {
    if (!won) return;

    // Get user profile stats
    const profile = await sql`
      SELECT wins, current_win_streak, tier_idx FROM user_profiles WHERE user_id = ${userId}
    `;

    if (profile.length === 0) return;

    const { wins, current_win_streak, tier_idx } = profile[0];

    // Check match-related achievements
    const achievementsToCheck = [
      { key: "first_win", condition: wins >= 1 },
      { key: "total_wins_10", condition: wins >= 10 },
      { key: "total_wins_50", condition: wins >= 50 },
      { key: "total_wins_100", condition: wins >= 100 },
      { key: "win_streak_3", condition: current_win_streak >= 3 },
      { key: "win_streak_10", condition: current_win_streak >= 10 },
    ];

    for (const { key, condition } of achievementsToCheck) {
      if (condition) {
        await awardAchievement(userId, key);
      }
    }

    // Check rank achievements if promoted
    if (newState.promoted) {
      const tierChecks = [
        { key: "reach_gold", tier: 2 },
        { key: "reach_platinum", tier: 3 },
        { key: "reach_diamond", tier: 4 },
        { key: "reach_master", tier: 5 },
      ];

      for (const { key, tier } of tierChecks) {
        if (tier_idx >= tier) {
          await awardAchievement(userId, key);
        }
      }
    }
  } catch (error) {
    console.error("Check match achievements error:", error);
  }
}

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
        losses = losses + 0,
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
        wins = wins + 0,
        losses = losses + 1,
        current_win_streak = 0,
        current_loss_streak = current_loss_streak + 1,
        last_match_at = CURRENT_TIMESTAMP,
        updated_at = CURRENT_TIMESTAMP
      WHERE user_id = ${userId}
    `;
  }
}

// POST /api/matches/invite/[code]/submit — submit workout volume
export async function POST(request, { params }) {
  try {
    // Server-side subscription gate
    let userId;
    try {
      const sub = await requireSubscription(request);
      userId = parseInt(sub.userId);
    } catch (subError) {
      return subError;
    }

    const { code } = params;
    const body = await request.json();
    const { volume_kg } = body;

    if (volume_kg === undefined || volume_kg === null) {
      return Response.json({ error: "volume_kg is required" }, { status: 400 });
    }

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

    // Store this player's volume
    if (isHost) {
      await sql`UPDATE pending_matches SET host_volume_kg = ${volume_kg} WHERE invite_code = ${code}`;
    } else {
      await sql`UPDATE pending_matches SET guest_volume_kg = ${volume_kg} WHERE invite_code = ${code}`;
    }

    // Re-fetch to check if both submitted
    const [refreshed] =
      await sql`SELECT * FROM pending_matches WHERE invite_code = ${code}`;

    const bothSubmitted =
      refreshed.host_volume_kg !== null && refreshed.guest_volume_kg !== null;

    if (!bothSubmitted) {
      return Response.json({
        status: "waiting_for_opponent",
        match: refreshed,
      });
    }

    // Both submitted — resolve the match
    const hostVolume = parseFloat(refreshed.host_volume_kg);
    const guestVolume = parseFloat(refreshed.guest_volume_kg);
    const hostWon = hostVolume >= guestVolume;

    // Fetch current profiles for both players
    const [hostProfile] =
      await sql`SELECT * FROM user_profiles WHERE user_id = ${refreshed.host_user_id}`;
    const [guestProfile] =
      await sql`SELECT * FROM user_profiles WHERE user_id = ${refreshed.guest_user_id}`;

    // Calc LP changes
    const hostLpChange = getLPChange(
      hostWon ? "win" : "loss",
      parseInt(refreshed.guest_tier_idx),
      parseInt(refreshed.host_tier_idx),
    );
    const guestLpChange = getLPChange(
      !hostWon ? "win" : "loss",
      parseInt(refreshed.host_tier_idx),
      parseInt(refreshed.guest_tier_idx),
    );

    const hostNewState = applyLPChange(
      {
        tierIdx: hostProfile.tier_idx,
        divIdx: hostProfile.div_idx,
        lp: hostProfile.lp,
        demotionShield: !!hostProfile.demotion_shield,
      },
      hostLpChange,
    );
    const guestNewState = applyLPChange(
      {
        tierIdx: guestProfile.tier_idx,
        divIdx: guestProfile.div_idx,
        lp: guestProfile.lp,
        demotionShield: !!guestProfile.demotion_shield,
      },
      guestLpChange,
    );

    // Mark match completed
    await sql`
      UPDATE pending_matches SET
        status = 'completed',
        host_result = ${hostWon ? "win" : "loss"},
        guest_result = ${!hostWon ? "win" : "loss"},
        host_lp_change = ${hostLpChange},
        guest_lp_change = ${guestLpChange}
      WHERE invite_code = ${code}
    `;

    // Update profiles
    await updateProfile(refreshed.host_user_id, hostNewState, hostWon);
    await updateProfile(refreshed.guest_user_id, guestNewState, !hostWon);

    // Create match records
    const hostOpponentName = guestProfile.username || "Opponent";
    const guestOpponentName = hostProfile.username || "Opponent";
    const hostOpponentPhoto = guestProfile.profile_photo_url || null;
    const guestOpponentPhoto = hostProfile.profile_photo_url || null;

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
        ${refreshed.host_user_id}, ${refreshed.guest_user_id}, ${hostOpponentName}, ${hostOpponentPhoto},
        ${refreshed.guest_tier_idx}, ${refreshed.guest_div_idx},
        ${hostWon ? "win" : "loss"}, ${hostLpChange}, ${hostNewState.lp},
        ${hostProfile.tier_idx}, ${hostProfile.div_idx},
        ${hostNewState.tierIdx}, ${hostNewState.divIdx},
        ${hostVolume}, ${guestVolume},
        ${hostNewState.promoted || false}, ${hostNewState.demoted || false}
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
        ${refreshed.guest_user_id}, ${refreshed.host_user_id}, ${guestOpponentName}, ${guestOpponentPhoto},
        ${refreshed.host_tier_idx}, ${refreshed.host_div_idx},
        ${!hostWon ? "win" : "loss"}, ${guestLpChange}, ${guestNewState.lp},
        ${guestProfile.tier_idx}, ${guestProfile.div_idx},
        ${guestNewState.tierIdx}, ${guestNewState.divIdx},
        ${guestVolume}, ${hostVolume},
        ${guestNewState.promoted || false}, ${guestNewState.demoted || false}
      )
    `;

    // Update friendship records if they are friends
    const [friendship] = await sql`
      SELECT * FROM friendships 
      WHERE ((user_id = ${refreshed.host_user_id} AND friend_id = ${refreshed.guest_user_id})
         OR (user_id = ${refreshed.guest_user_id} AND friend_id = ${refreshed.host_user_id}))
        AND status = 'accepted'
    `;

    if (friendship) {
      // Determine which user is which in the friendship record
      const isHostPrimaryUser = friendship.user_id === refreshed.host_user_id;

      if (isHostPrimaryUser) {
        // Host is the primary user in friendship record
        await sql`
          UPDATE friendships SET
            wins_against_friend = ${hostWon ? friendship.wins_against_friend + 1 : friendship.wins_against_friend},
            losses_against_friend = ${hostWon ? friendship.losses_against_friend : friendship.losses_against_friend + 1},
            total_matches_against_friend = total_matches_against_friend + 1,
            updated_at = CURRENT_TIMESTAMP
          WHERE id = ${friendship.id}
        `;
      } else {
        // Guest is the primary user in friendship record
        await sql`
          UPDATE friendships SET
            wins_against_friend = ${!hostWon ? friendship.wins_against_friend + 1 : friendship.wins_against_friend},
            losses_against_friend = ${!hostWon ? friendship.losses_against_friend : friendship.losses_against_friend + 1},
            total_matches_against_friend = total_matches_against_friend + 1,
            updated_at = CURRENT_TIMESTAMP
          WHERE id = ${friendship.id}
        `;
      }
    }

    // Check achievements for both players
    await checkMatchAchievements(refreshed.host_user_id, hostWon, hostNewState);
    await checkMatchAchievements(
      refreshed.guest_user_id,
      !hostWon,
      guestNewState,
    );

    // Send match result notifications
    await sql`
      INSERT INTO notifications (user_id, type, title, message, data)
      VALUES (
        ${refreshed.host_user_id},
        'match_result',
        ${hostWon ? "Victory!" : "Defeat"},
        ${
          hostWon
            ? `You beat ${guestOpponentName}! +${hostLpChange} LP`
            : `You lost to ${guestOpponentName}. ${hostLpChange} LP`
        },
        ${JSON.stringify({
          match_code: code,
          result: hostWon ? "win" : "loss",
          lp_change: hostLpChange,
          opponent_id: refreshed.guest_user_id,
        })}
      )
    `;

    await sql`
      INSERT INTO notifications (user_id, type, title, message, data)
      VALUES (
        ${refreshed.guest_user_id},
        'match_result',
        ${!hostWon ? "Victory!" : "Defeat"},
        ${
          !hostWon
            ? `You beat ${hostOpponentName}! +${guestLpChange} LP`
            : `You lost to ${hostOpponentName}. ${guestLpChange} LP`
        },
        ${JSON.stringify({
          match_code: code,
          result: !hostWon ? "win" : "loss",
          lp_change: guestLpChange,
          opponent_id: refreshed.host_user_id,
        })}
      )
    `;

    const [finalMatch] =
      await sql`SELECT * FROM pending_matches WHERE invite_code = ${code}`;

    return Response.json({
      status: "completed",
      match: finalMatch,
      host_lp_change: hostLpChange,
      guest_lp_change: guestLpChange,
      host_new_state: hostNewState,
      guest_new_state: guestNewState,
      host_won: hostWon,
    });
  } catch (err) {
    console.error("POST /api/matches/invite/[code]/submit error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
