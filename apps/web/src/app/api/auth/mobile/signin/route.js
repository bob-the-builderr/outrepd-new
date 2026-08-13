/**
 * Mobile signin — bypasses the HTTP auth dance entirely.
 * Directly queries the DB, verifies with argon2, and encodes a JWT.
 */
import { neon } from "@neondatabase/serverless";
import { verify } from "argon2";
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
    console.log("[Mobile Signin] Attempt for:", email);

    if (!email || !password) {
      return Response.json(
        { error: "Email and password are required" },
        { status: 400, headers: cors },
      );
    }

    // 1. Look up user + credentials account directly from DB
    const rows = await sql(
      `SELECT u.id, u.name, u.email, u.image, a.password
       FROM auth_users u
       JOIN auth_accounts a ON a."userId" = u.id
       WHERE LOWER(u.email) = LOWER($1)
         AND a.provider = 'credentials'
       LIMIT 1`,
      [email.trim()],
    );

    if (rows.length === 0) {
      console.log("[Mobile Signin] User not found:", email);
      return Response.json(
        { error: "Incorrect email or password" },
        { status: 401, headers: cors },
      );
    }

    const user = rows[0];

    // 2. Verify password with argon2
    const valid = await verify(user.password, password);
    if (!valid) {
      console.log("[Mobile Signin] Wrong password for:", email);
      return Response.json(
        { error: "Incorrect email or password" },
        { status: 401, headers: cors },
      );
    }

    // 3. Encode a JWT that will serve as the session token
    const isSecure = process.env.AUTH_URL?.startsWith("https") ?? false;
    const salt = isSecure
      ? "__Secure-authjs.session-token"
      : "authjs.session-token";

    const jwt = await encode({
      token: {
        sub: String(user.id),
        email: user.email,
        name: user.name,
        picture: user.image,
      },
      secret: process.env.AUTH_SECRET,
      salt,
      maxAge: 30 * 24 * 60 * 60, // 30 days
    });

    // 4. Store the JWT itself as the session token in the database
    const expires = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000); // 30 days

    // Delete any existing sessions for this user (optional - single device)
    await sql(`DELETE FROM auth_sessions WHERE "userId" = $1`, [user.id]);

    // Insert new session
    await sql(
      `INSERT INTO auth_sessions ("userId", expires, "sessionToken")
       VALUES ($1, $2, $3)`,
      [user.id, expires, jwt],
    );

    console.log("[Mobile Signin] Success for:", email);
    return Response.json(
      {
        success: true,
        jwt,
        user: { id: String(user.id), email: user.email, name: user.name },
      },
      { status: 200, headers: cors },
    );
  } catch (err) {
    console.error("[Mobile Signin] Error:", err);
    return Response.json(
      { error: "Something went wrong. Please try again." },
      { status: 500, headers: cors },
    );
  }
}
