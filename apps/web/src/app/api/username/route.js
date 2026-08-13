import { getSession } from "@/app/api/utils/getSession";
import sql from "@/app/api/utils/sql";

// Get or check username availability
export async function GET(request) {
  console.log("[Username API GET] === REQUEST RECEIVED ===");

  const { searchParams } = new URL(request.url);
  const checkUsername = searchParams.get("check");

  if (checkUsername) {
    console.log("[Username API GET] Checking availability for:", checkUsername);
    // Check if username is available
    const existing = await sql`
      SELECT id FROM user_profiles WHERE LOWER(username) = LOWER(${checkUsername})
    `;
    console.log(
      "[Username API GET] Availability check result:",
      existing.length === 0,
    );
    return Response.json({ available: existing.length === 0 });
  }

  // Get current user's username
  const session = await getSession(request);
  console.log("[Username API GET] Session user ID:", session?.user?.id);

  if (!session?.user?.id) {
    console.log("[Username API GET] No session - returning 401");
    return Response.json({ error: "Unauthorized" }, { status: 401 });
  }

  const profile = await sql`
    SELECT username FROM user_profiles WHERE user_id = ${session.user.id}
  `;

  console.log(
    "[Username API GET] Profile result:",
    profile[0]?.username || "null",
  );
  return Response.json({ username: profile[0]?.username || null });
}

// Set or update username
export async function POST(request) {
  const session = await getSession(request);
  if (!session?.user?.id) {
    return Response.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = await request.json();
  const { username } = body;

  if (!username || username.trim().length === 0) {
    return Response.json({ error: "Username is required" }, { status: 400 });
  }

  const trimmedUsername = username.trim();

  // Validate username format (alphanumeric, underscores, 3-20 chars)
  if (!/^[a-zA-Z0-9_]{3,20}$/.test(trimmedUsername)) {
    return Response.json(
      {
        error:
          "Username must be 3-20 characters and contain only letters, numbers, and underscores",
      },
      { status: 400 },
    );
  }

  // Check if username is already taken
  const existing = await sql`
    SELECT id FROM user_profiles 
    WHERE LOWER(username) = LOWER(${trimmedUsername}) AND user_id != ${session.user.id}
  `;

  if (existing.length > 0) {
    return Response.json({ error: "Username already taken" }, { status: 400 });
  }

  // Ensure user_profiles record exists (in case it wasn't created during signup)
  await sql`
    INSERT INTO user_profiles (user_id, username, tier_idx, div_idx, lp)
    VALUES (${session.user.id}, ${trimmedUsername}, 0, 0, 0)
    ON CONFLICT (user_id) 
    DO UPDATE SET username = ${trimmedUsername}, updated_at = CURRENT_TIMESTAMP
  `;

  return Response.json({ success: true, username: trimmedUsername });
}
