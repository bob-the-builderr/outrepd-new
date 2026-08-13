import { getSession } from "@/app/api/utils/getSession";
import sql from "@/app/api/utils/sql";

// Get user settings
export async function GET(request) {
  const session = await getSession(request);
  if (!session?.user?.id) {
    return Response.json({ error: "Unauthorized" }, { status: 401 });
  }

  // Get or create default settings
  let settings = await sql`
    SELECT * FROM user_settings WHERE user_id = ${session.user.id}
  `;

  if (settings.length === 0) {
    // Create default settings
    settings = await sql`
      INSERT INTO user_settings (user_id, units, allow_match_invites, allow_friend_requests)
      VALUES (${session.user.id}, 'kg', true, true)
      RETURNING *
    `;
  }

  // Also get the country from user_profiles
  const profile = await sql`
    SELECT country FROM user_profiles WHERE user_id = ${session.user.id}
  `;

  return Response.json({
    ...settings[0],
    country: profile[0]?.country || null,
  });
}

// Update user settings
export async function PATCH(request) {
  const session = await getSession(request);
  if (!session?.user?.id) {
    return Response.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = await request.json();
  const { units, allow_match_invites, allow_friend_requests, country } = body;

  // Validate units if provided
  if (units && !["kg", "lbs"].includes(units)) {
    return Response.json(
      { error: "Units must be 'kg' or 'lbs'" },
      { status: 400 },
    );
  }

  // Build update query dynamically
  const updates = [];
  const values = [];
  let paramCount = 1;

  if (units !== undefined) {
    updates.push(`units = $${paramCount++}`);
    values.push(units);
  }
  if (allow_match_invites !== undefined) {
    updates.push(`allow_match_invites = $${paramCount++}`);
    values.push(allow_match_invites);
  }
  if (allow_friend_requests !== undefined) {
    updates.push(`allow_friend_requests = $${paramCount++}`);
    values.push(allow_friend_requests);
  }

  if (updates.length === 0) {
    return Response.json({ error: "No settings to update" }, { status: 400 });
  }

  updates.push(`updated_at = CURRENT_TIMESTAMP`);
  values.push(session.user.id);

  const query = `
    UPDATE user_settings 
    SET ${updates.join(", ")}
    WHERE user_id = $${paramCount}
    RETURNING *
  `;

  const result = await sql(query, values);

  // Update country in user_profiles if provided
  if (country !== undefined) {
    await sql`
      UPDATE user_profiles
      SET country = ${country}
      WHERE user_id = ${session.user.id}
    `;
  }

  // Fetch the updated settings with country
  const updatedSettings = await sql`
    SELECT * FROM user_settings WHERE user_id = ${session.user.id}
  `;

  const profile = await sql`
    SELECT country FROM user_profiles WHERE user_id = ${session.user.id}
  `;

  return Response.json({
    ...updatedSettings[0],
    country: profile[0]?.country || null,
  });
}
