/**
 * Mobile signup — bypasses the HTTP auth dance entirely.
 * Directly creates user in DB, hashes with argon2, encodes a JWT.
 */
import { neon } from "@neondatabase/serverless";
import { hash } from "argon2";
import { encode } from "@auth/core/jwt";

const sql = neon(process.env.DATABASE_URL);

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "Content-Type",
  "Content-Type": "application/json",
};

export async function OPTIONS() {
  return new Response(null, {
    status: 200,
    headers: { ...cors, "Access-Control-Allow-Methods": "POST, OPTIONS" },
  });
}

export async function POST(request) {
  try {
    const { email, password } = await request.json();
    console.log("[Mobile Signup] Attempt for:", email);

    if (!email || !password) {
      return Response.json(
        { error: "Email and password are required" },
        { status: 400, headers: cors },
      );
    }

    if (password.length < 6) {
      return Response.json(
        { error: "Password must be at least 6 characters" },
        { status: 400, headers: cors },
      );
    }

    // 1. Check if user already exists
    const existing = await sql(
      `SELECT id FROM auth_users WHERE LOWER(email) = LOWER($1) LIMIT 1`,
      [email.trim()],
    );

    if (existing.length > 0) {
      console.log("[Mobile Signup] Email already in use:", email);
      return Response.json(
        { error: "An account with this email already exists" },
        { status: 409, headers: cors },
      );
    }

    // 2. Create user
    const newUsers = await sql(
      `INSERT INTO auth_users (email, name, "emailVerified", image)
       VALUES ($1, $2, NULL, NULL)
       RETURNING id, email, name`,
      [email.trim().toLowerCase(), email.trim().split("@")[0]],
    );

    const user = newUsers[0];

    // 3. Hash password and link credentials account
    const hashedPassword = await hash(password);

    await sql(
      `INSERT INTO auth_accounts ("userId", provider, type, "providerAccountId", password)
       VALUES ($1, 'credentials', 'credentials', $2, $3)`,
      [user.id, String(user.id), hashedPassword],
    );

    // 4. Create user profile for the new user
    await sql(
      `INSERT INTO user_profiles (user_id, tier_idx, div_idx, lp, total_matches, wins, losses)
       VALUES ($1, 0, 0, 0, 0, 0, 0)
       ON CONFLICT (user_id) DO NOTHING`,
      [user.id],
    );

    // 5. Create user settings
    await sql(
      `INSERT INTO user_settings (user_id, units, allow_match_invites, allow_friend_requests)
       VALUES ($1, 'kg', true, true)
       ON CONFLICT (user_id) DO NOTHING`,
      [user.id],
    );

    // 6. Encode a JWT that will serve as the session token
    const isSecure = process.env.AUTH_URL?.startsWith("https") ?? false;
    const salt = isSecure
      ? "__Secure-authjs.session-token"
      : "authjs.session-token";

    const jwt = await encode({
      token: {
        sub: String(user.id),
        email: user.email,
        name: user.name,
        picture: null,
      },
      secret: process.env.AUTH_SECRET,
      salt,
      maxAge: 30 * 24 * 60 * 60, // 30 days
    });

    // 7. Store the JWT itself as the session token in the database
    const expires = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000); // 30 days

    await sql(
      `INSERT INTO auth_sessions ("userId", expires, "sessionToken")
       VALUES ($1, $2, $3)`,
      [user.id, expires, jwt],
    );

    console.log("[Mobile Signup] Created user:", email, "id:", user.id);
    return Response.json(
      {
        success: true,
        jwt,
        user: { id: String(user.id), email: user.email, name: user.name },
      },
      { status: 200, headers: cors },
    );
  } catch (err) {
    console.error("[Mobile Signup] Error:", err);
    return Response.json(
      { error: "Something went wrong. Please try again." },
      { status: 500, headers: cors },
    );
  }
}
