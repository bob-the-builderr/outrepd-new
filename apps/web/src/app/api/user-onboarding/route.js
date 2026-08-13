import { getSession } from "@/app/api/utils/getSession";
import sql from "@/app/api/utils/sql";

// GET: check onboarding status
export async function GET(request) {
  const session = await getSession(request);
  if (!session?.user?.id) {
    return Response.json({ error: "Unauthorized" }, { status: 401 });
  }

  const profile = await sql`
    SELECT onboarding_completed FROM user_profiles WHERE user_id = ${session.user.id} LIMIT 1
  `;

  return Response.json({
    onboardingCompleted: profile[0]?.onboarding_completed ?? false,
  });
}

// POST: save onboarding data and mark as complete
export async function POST(request) {
  const session = await getSession(request);
  if (!session?.user?.id) {
    return Response.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = await request.json();
  const { username, experienceLevel, age, bodyweightKg, heightCm } = body;

  // Validate + save username if provided
  if (username && username.trim().length > 0) {
    const trimmed = username.trim();

    if (!/^[a-zA-Z0-9_]{3,20}$/.test(trimmed)) {
      return Response.json(
        {
          error:
            "Username must be 3-20 characters and contain only letters, numbers, and underscores",
        },
        { status: 400 },
      );
    }

    // Check if taken by another user
    const existing = await sql`
      SELECT id FROM user_profiles
      WHERE LOWER(username) = LOWER(${trimmed}) AND user_id != ${session.user.id}
    `;

    if (existing.length > 0) {
      return Response.json(
        { error: "Username already taken" },
        { status: 400 },
      );
    }
  }

  // Build update
  const updates = { onboarding_completed: true };
  if (username && username.trim()) updates.username = username.trim();
  if (experienceLevel) updates.experience_level = experienceLevel;
  if (age) updates.age = age;
  if (bodyweightKg) updates.bodyweight_kg = parseFloat(bodyweightKg);
  if (heightCm) updates.height_cm = parseFloat(heightCm);

  await sql`
    UPDATE user_profiles SET
      username = COALESCE(${updates.username || null}, username),
      experience_level = COALESCE(${updates.experience_level || null}, experience_level),
      age = COALESCE(${updates.age || null}, age),
      bodyweight_kg = COALESCE(${updates.bodyweight_kg || null}, bodyweight_kg),
      height_cm = COALESCE(${updates.height_cm || null}, height_cm),
      onboarding_completed = true,
      updated_at = CURRENT_TIMESTAMP
    WHERE user_id = ${session.user.id}
  `;

  return Response.json({ success: true });
}
