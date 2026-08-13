import sql from "@/app/api/utils/sql";
import { getSession } from "@/app/api/utils/getSession";

// GET user profile
export async function GET(request) {
  try {
    const session = await getSession(request);
    if (!session || !session.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = session.user.id;

    const profiles = await sql`
      SELECT 
        up.*,
        au.name,
        au.email,
        au.image
      FROM user_profiles up
      JOIN auth_users au ON up.user_id = au.id
      WHERE up.user_id = ${userId}
      LIMIT 1
    `;

    const profile = profiles?.[0] || null;

    return Response.json({ profile });
  } catch (err) {
    console.error("GET /api/profile error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}

// POST create user profile (called after signup)
export async function POST(request) {
  try {
    const session = await getSession(request);
    if (!session || !session.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = session.user.id;
    const body = await request.json();
    const { username } = body || {};

    const existing =
      await sql`SELECT id FROM user_profiles WHERE user_id = ${userId}`;
    if (existing.length > 0) {
      return Response.json(
        { error: "Profile already exists" },
        { status: 400 },
      );
    }

    const result = await sql`
      INSERT INTO user_profiles (
        user_id, username, tier_idx, div_idx, lp
      ) VALUES (
        ${userId}, ${username || null}, 0, 0, 0
      )
      RETURNING *
    `;

    return Response.json({ profile: result[0] });
  } catch (err) {
    console.error("POST /api/profile error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}

// PUT update user profile
export async function PUT(request) {
  try {
    const session = await getSession(request);
    if (!session || !session.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = session.user.id;
    const body = await request.json();
    const {
      username,
      profile_photo_url,
      country,
      bodyweight_kg,
      height_cm,
      age,
    } = body || {};

    const setClauses = [];
    const values = [];

    if (typeof username === "string" && username.trim().length > 0) {
      setClauses.push(`username = $${values.length + 1}`);
      values.push(username.trim());
    }

    if (profile_photo_url !== undefined) {
      setClauses.push(`profile_photo_url = $${values.length + 1}`);
      values.push(profile_photo_url || null);
    }

    if (country !== undefined) {
      setClauses.push(`country = $${values.length + 1}`);
      values.push(country || null);
    }

    if (bodyweight_kg !== undefined) {
      const bw = parseFloat(bodyweight_kg);
      if (!isNaN(bw) && bw > 0) {
        setClauses.push(`bodyweight_kg = $${values.length + 1}`);
        values.push(bw);
      }
    }

    if (height_cm !== undefined) {
      const h = parseFloat(height_cm);
      if (!isNaN(h) && h >= 100 && h <= 250) {
        setClauses.push(`height_cm = $${values.length + 1}`);
        values.push(h);
      }
    }

    if (age !== undefined) {
      const a = parseInt(age, 10);
      if (!isNaN(a) && a >= 13 && a <= 100) {
        setClauses.push(`age = $${values.length + 1}`);
        values.push(a);
      }
    }

    setClauses.push(`updated_at = CURRENT_TIMESTAMP`);

    if (setClauses.length === 1) {
      return Response.json(
        { error: "No valid fields to update" },
        { status: 400 },
      );
    }

    const query = `
      UPDATE user_profiles 
      SET ${setClauses.join(", ")} 
      WHERE user_id = $${values.length + 1}
      RETURNING *
    `;

    const result = await sql(query, [...values, userId]);

    return Response.json({ profile: result[0] });
  } catch (err) {
    console.error("PUT /api/profile error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}

// DELETE user account
export async function DELETE(request) {
  try {
    const session = await getSession(request);
    if (!session || !session.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = session.user.id;

    // Delete the user from auth_users table
    // This will cascade delete all related data due to foreign key constraints
    await sql`
      DELETE FROM auth_users 
      WHERE id = ${userId}
    `;

    return Response.json({
      success: true,
      message: "Account deleted successfully",
    });
  } catch (err) {
    console.error("DELETE /api/profile error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
