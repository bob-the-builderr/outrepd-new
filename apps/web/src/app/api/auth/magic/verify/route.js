import sql from "@/app/api/utils/sql";
import { corsResponse, handleCorsPreFlight } from "@/app/api/utils/cors";
import { encode } from "@auth/core/jwt";

export async function OPTIONS(request) {
  return handleCorsPreFlight(request);
}

export async function POST(request) {
  try {
    const { email, code } = await request.json();

    if (!email || !code) {
      return corsResponse(
        { error: "Email and code are required" },
        { status: 400 },
        request,
      );
    }

    const normalizedEmail = email.trim().toLowerCase();

    // Look up the token
    const tokens = await sql`
      SELECT * FROM auth_verification_token
      WHERE identifier = ${normalizedEmail}
        AND token = ${code}
        AND expires > NOW()
      LIMIT 1
    `;

    if (tokens.length === 0) {
      return corsResponse(
        { error: "Invalid or expired code. Please request a new one." },
        { status: 401 },
        request,
      );
    }

    // Consume the token
    await sql`
      DELETE FROM auth_verification_token
      WHERE identifier = ${normalizedEmail}
    `;

    // Get or create the user
    let user;
    const existing = await sql`
      SELECT * FROM auth_users WHERE LOWER(email) = ${normalizedEmail} LIMIT 1
    `;

    if (existing.length > 0) {
      user = existing[0];
    } else {
      // Create a new user
      const created = await sql`
        INSERT INTO auth_users (email, name, "emailVerified", image)
        VALUES (${normalizedEmail}, ${normalizedEmail.split("@")[0]}, NOW(), NULL)
        RETURNING *
      `;
      user = created[0];

      // Create profile and settings for new user
      await sql`
        INSERT INTO user_profiles (user_id, tier_idx, div_idx, lp, total_matches, wins, losses)
        VALUES (${user.id}, 0, 0, 0, 0, 0, 0)
        ON CONFLICT (user_id) DO NOTHING
      `;
      await sql`
        INSERT INTO user_settings (user_id, units, allow_match_invites, allow_friend_requests)
        VALUES (${user.id}, 'kg', true, true)
        ON CONFLICT (user_id) DO NOTHING
      `;
    }

    // Encode a JWT session token
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

    // Store the session
    const expires = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000);
    await sql`DELETE FROM auth_sessions WHERE "userId" = ${user.id}`;
    await sql`
      INSERT INTO auth_sessions ("userId", expires, "sessionToken")
      VALUES (${user.id}, ${expires}, ${jwt})
    `;

    // Check if user has completed onboarding
    const profile = await sql`
      SELECT username, onboarding_completed FROM user_profiles WHERE user_id = ${user.id} LIMIT 1
    `;
    const onboardingCompleted =
      profile.length > 0 && !!profile[0].onboarding_completed;

    return corsResponse(
      {
        success: true,
        jwt,
        user: { id: String(user.id), email: user.email, name: user.name },
        onboardingCompleted,
      },
      {},
      request,
    );
  } catch (err) {
    console.error("[Magic Verify] Error:", err);
    return corsResponse(
      { error: "Something went wrong. Please try again." },
      { status: 500 },
      request,
    );
  }
}
