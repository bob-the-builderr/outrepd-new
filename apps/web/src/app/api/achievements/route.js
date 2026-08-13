import { getSession } from "@/app/api/utils/getSession";
import sql from "@/app/api/utils/sql";

// Get user's achievements
export async function GET(request) {
  const session = await getSession(request);
  if (!session?.user?.id) {
    return Response.json({ error: "Unauthorized" }, { status: 401 });
  }

  // Get all achievements with user's earned status
  const achievements = await sql`
    SELECT 
      a.*,
      ua.earned_at,
      CASE WHEN ua.id IS NOT NULL THEN true ELSE false END as earned
    FROM achievements a
    LEFT JOIN user_achievements ua ON a.id = ua.achievement_id AND ua.user_id = ${session.user.id}
    ORDER BY a.category, a.requirement_value
  `;

  return Response.json(achievements);
}

// Check and award achievements for a user (called internally after actions)
export async function POST(request) {
  const session = await getSession(request);
  if (!session?.user?.id) {
    return Response.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = await request.json();
  const { checkType } = body; // 'match_win', 'workout_complete', 'rank_up', 'volume'

  const userId = session.user.id;
  const newAchievements = [];

  try {
    // Get user profile stats
    const profile = await sql`
      SELECT wins, current_win_streak, tier_idx FROM user_profiles WHERE user_id = ${userId}
    `;

    if (profile.length === 0) {
      return Response.json({ newAchievements: [] });
    }

    const { wins, current_win_streak, tier_idx } = profile[0];

    // Check match-related achievements
    if (checkType === "match_win") {
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
          const awarded = await awardAchievement(userId, key);
          if (awarded) {
            newAchievements.push(awarded);
          }
        }
      }
    }

    // Check rank achievements
    if (checkType === "rank_up") {
      const tierChecks = [
        { key: "reach_gold", tier: 2 },
        { key: "reach_platinum", tier: 3 },
        { key: "reach_diamond", tier: 4 },
        { key: "reach_master", tier: 5 },
      ];

      for (const { key, tier } of tierChecks) {
        if (tier_idx >= tier) {
          const awarded = await awardAchievement(userId, key);
          if (awarded) {
            newAchievements.push(awarded);
          }
        }
      }
    }

    // Check workout count achievements
    if (checkType === "workout_complete") {
      const workoutCount = await sql`
        SELECT COUNT(*) as count FROM workout_logs WHERE user_id = ${userId}
      `;
      const count = parseInt(workoutCount[0].count);

      const workoutChecks = [
        { key: "workouts_10", count: 10 },
        { key: "workouts_50", count: 50 },
        { key: "workouts_100", count: 100 },
      ];

      for (const { key, count: required } of workoutChecks) {
        if (count >= required) {
          const awarded = await awardAchievement(userId, key);
          if (awarded) {
            newAchievements.push(awarded);
          }
        }
      }
    }

    // Check volume achievements
    if (checkType === "volume" && body.volume) {
      const volumeChecks = [
        { key: "volume_1000", volume: 1000 },
        { key: "volume_2000", volume: 2000 },
      ];

      for (const { key, volume: required } of volumeChecks) {
        if (body.volume >= required) {
          const awarded = await awardAchievement(userId, key);
          if (awarded) {
            newAchievements.push(awarded);
          }
        }
      }
    }

    return Response.json({ newAchievements });
  } catch (error) {
    console.error("Achievement check error:", error);
    return Response.json(
      { error: "Failed to check achievements" },
      { status: 500 },
    );
  }
}

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
