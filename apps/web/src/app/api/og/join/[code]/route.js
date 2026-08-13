import sql from "@/app/api/utils/sql";

// PUBLIC — no auth required so link crawlers (Slack, Telegram, iMessage, etc.) can fetch it
export async function GET(request, { params }) {
  const { code } = params;

  try {
    const [match] = await sql`
      SELECT
        pm.muscle_group,
        pm.status,
        pm.expires_at,
        up.username      AS host_username,
        up.profile_photo_url AS host_photo,
        up.tier_idx      AS host_tier_idx,
        up.div_idx       AS host_div_idx
      FROM pending_matches pm
      JOIN auth_users     hu ON hu.id = pm.host_user_id
      LEFT JOIN user_profiles up ON up.user_id = pm.host_user_id
      WHERE pm.invite_code = ${code}
      LIMIT 1
    `;

    const username = match?.host_username || "Player";
    const photoUrl = match?.host_photo || null;
    const muscleGroup = match?.muscle_group || "";
    const isExpired =
      !match ||
      match.status !== "waiting" ||
      new Date(match.expires_at) <= new Date();

    // Initials fallback for host avatar
    const initials = username.slice(0, 2).toUpperCase();

    // Logo URL (the uploaded project logo)
    const logoUrl =
      "https://dtvoeevhaseb5.cloudfront.net/user-uploads/9613a25b-2616-4f30-be6b-ced22f46d915.png";

    const svg = `
<svg width="1200" height="630" viewBox="0 0 1200 630" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
  <defs>
    <clipPath id="hostClip">
      <circle cx="250" cy="270" r="110"/>
    </clipPath>
    <clipPath id="opponentClip">
      <circle cx="950" cy="270" r="110"/>
    </clipPath>
    <clipPath id="logoClip">
      <rect x="525" y="185" width="150" height="150" rx="24"/>
    </clipPath>
    <radialGradient id="bgGrad" cx="50%" cy="50%" r="70%">
      <stop offset="0%"   stop-color="#0D1A2A"/>
      <stop offset="100%" stop-color="#010308"/>
    </radialGradient>
    <radialGradient id="glowBlue" cx="50%" cy="50%" r="50%">
      <stop offset="0%"   stop-color="#4BB8FA" stop-opacity="0.18"/>
      <stop offset="100%" stop-color="#4BB8FA" stop-opacity="0"/>
    </radialGradient>
    <radialGradient id="glowRed" cx="50%" cy="50%" r="50%">
      <stop offset="0%"   stop-color="#FF4444" stop-opacity="0.14"/>
      <stop offset="100%" stop-color="#FF4444" stop-opacity="0"/>
    </radialGradient>
  </defs>

  <!-- Background -->
  <rect width="1200" height="630" fill="url(#bgGrad)"/>

  <!-- Subtle glow behind host -->
  <ellipse cx="250" cy="310" rx="260" ry="200" fill="url(#glowBlue)"/>

  <!-- Subtle glow behind opponent placeholder -->
  <ellipse cx="950" cy="310" rx="260" ry="200" fill="url(#glowRed)"/>

  <!-- Divider lines -->
  <line x1="430" y1="160" x2="430" y2="470" stroke="#1A2A3A" stroke-width="1.5"/>
  <line x1="770" y1="160" x2="770" y2="470" stroke="#1A2A3A" stroke-width="1.5"/>

  <!-- ── HOST SIDE ── -->
  <!-- Avatar circle bg -->
  <circle cx="250" cy="270" r="114" fill="#0D1A26" stroke="#4BB8FA" stroke-width="3"/>

  ${
    photoUrl
      ? `<image href="${photoUrl}" x="140" y="160" width="220" height="220" clip-path="url(#hostClip)" preserveAspectRatio="xMidYMid slice"/>`
      : `<circle cx="250" cy="270" r="110" fill="#0D1A26"/>
       <text x="250" y="298" text-anchor="middle" font-family="system-ui, -apple-system, sans-serif" font-size="72" font-weight="900" fill="#4BB8FA">${initials}</text>`
  }

  <!-- Username -->
  <text x="250" y="420" text-anchor="middle" font-family="system-ui, -apple-system, sans-serif" font-size="30" font-weight="800" fill="#FFFFFF">${username}</text>

  <!-- "CHALLENGER" label -->
  <rect x="170" y="438" width="160" height="28" rx="8" fill="#4BB8FA22"/>
  <text x="250" y="457" text-anchor="middle" font-family="system-ui, -apple-system, sans-serif" font-size="13" font-weight="700" fill="#4BB8FA" letter-spacing="2">CHALLENGER</text>

  <!-- ── CENTER LOGO ── -->
  <image href="${logoUrl}" x="525" y="185" width="150" height="150" clip-path="url(#logoClip)" preserveAspectRatio="xMidYMid meet"/>

  <!-- VS text -->
  <text x="600" y="385" text-anchor="middle" font-family="system-ui, -apple-system, sans-serif" font-size="28" font-weight="900" fill="#4BB8FA" letter-spacing="3">VS</text>

  ${
    muscleGroup
      ? `
  <!-- Muscle group pill -->
  <rect x="520" y="400" width="160" height="32" rx="10" fill="#0D1A26" stroke="#1A2A3A" stroke-width="1"/>
  <text x="600" y="421" text-anchor="middle" font-family="system-ui, -apple-system, sans-serif" font-size="13" font-weight="700" fill="#888888" letter-spacing="1">${muscleGroup.toUpperCase()}</text>
  `
      : ""
  }

  <!-- ── OPPONENT SIDE ── -->
  <!-- Avatar circle bg (grey / unknown) -->
  <circle cx="950" cy="270" r="114" fill="#0D1218" stroke="#2A2A3A" stroke-width="3" stroke-dasharray="8 5"/>

  <!-- ? mark -->
  <text x="950" y="300" text-anchor="middle" font-family="system-ui, -apple-system, sans-serif" font-size="100" font-weight="900" fill="#333344">?</text>

  <!-- "You?" label -->
  <text x="950" y="420" text-anchor="middle" font-family="system-ui, -apple-system, sans-serif" font-size="30" font-weight="800" fill="#555566">You?</text>

  <!-- Searching label -->
  <rect x="870" y="438" width="160" height="28" rx="8" fill="#FFFFFF0A"/>
  <text x="950" y="457" text-anchor="middle" font-family="system-ui, -apple-system, sans-serif" font-size="13" font-weight="700" fill="#555566" letter-spacing="2">SEARCHING...</text>

  <!-- ── BOTTOM BAR ── -->
  <rect x="0" y="560" width="1200" height="70" fill="#070D14"/>
  <line x1="0" y1="560" x2="1200" y2="560" stroke="#1A2A3A" stroke-width="1"/>

  <!-- Invite code badge -->
  <rect x="80" y="582" width="320" height="36" rx="10" fill="#0D1A26" stroke="#1A2A3A" stroke-width="1"/>
  <text x="98" y="605" font-family="system-ui, -apple-system, sans-serif" font-size="12" font-weight="700" fill="#555" letter-spacing="1">CODE</text>
  <text x="148" y="605" font-family="system-ui, -apple-system, sans-serif" font-size="17" font-weight="900" fill="#4BB8FA" letter-spacing="4">${code}</text>

  <!-- CTA -->
  <rect x="760" y="576" width="360" height="42" rx="12" fill="#4BB8FA"/>
  <text x="940" y="602" text-anchor="middle" font-family="system-ui, -apple-system, sans-serif" font-size="16" font-weight="900" fill="#000000" letter-spacing="1">JOIN THE BATTLE →</text>
</svg>`;

    return new Response(svg, {
      headers: {
        "Content-Type": "image/svg+xml",
        "Cache-Control": "public, max-age=60, s-maxage=60",
      },
    });
  } catch (err) {
    console.error("OG image error:", err);

    // Minimal fallback SVG
    const fallback = `
<svg width="1200" height="630" xmlns="http://www.w3.org/2000/svg">
  <rect width="1200" height="630" fill="#010308"/>
  <text x="600" y="320" text-anchor="middle" font-family="system-ui" font-size="48" font-weight="900" fill="#4BB8FA">OUTREPD</text>
  <text x="600" y="380" text-anchor="middle" font-family="system-ui" font-size="22" fill="#888">Competitive Gym Battles</text>
</svg>`;
    return new Response(fallback, {
      headers: { "Content-Type": "image/svg+xml" },
    });
  }
}
