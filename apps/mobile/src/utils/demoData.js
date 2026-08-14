/**
 * Offline demo data.
 *
 * When EXPO_PUBLIC_DEMO_MODE is on, the app answers its own API calls from
 * this file instead of hitting the backend. That makes the whole UI walkable
 * with no server, no account and no network — useful for reviewing screens
 * and flows while the backend is unavailable.
 *
 * Anything not listed in HANDLERS falls back to an empty 200 so a screen we
 * forgot about degrades to "no data" instead of crashing.
 */

export const IS_DEMO_MODE = process.env.EXPO_PUBLIC_DEMO_MODE === "1";

// Mutable so writes during a session (finishing onboarding, changing
// settings) stick until the app is restarted.
const state = {
  onboardingCompleted: false,
  profile: {
    user_id: 1,
    username: "demo_lifter",
    name: "Demo Lifter",
    email: "demo@outrepd.test",
    country: "EG",
    age: 25,
    height_cm: 178,
    bodyweight_kg: 82,
    profile_photo_url: null,
    tier_idx: 3,
    div_idx: 2,
    lp: 64,
    total_matches: 27,
    wins: 18,
    losses: 9,
    current_win_streak: 4,
    best_win_streak: 7,
    current_loss_streak: 0,
    total_volume_kg: 184320,
    onboarding_completed: true,
    subscription_status: "active",
    subscription_tier: "premium",
    subscription_expires_at: new Date(
      Date.now() + 30 * 24 * 60 * 60 * 1000,
    ).toISOString(),
  },
  settings: {
    user_id: 1,
    units: "kg",
    allow_match_invites: true,
    allow_friend_requests: true,
    country: "EG",
  },
};

const RIVALS = [
  { username: "iron_mike", tier_idx: 5, div_idx: 1, lp: 88, wins: 41, losses: 12 },
  { username: "squat_queen", tier_idx: 4, div_idx: 3, lp: 72, wins: 35, losses: 15 },
  { username: "demo_lifter", tier_idx: 3, div_idx: 2, lp: 64, wins: 18, losses: 9 },
  { username: "benchgod", tier_idx: 3, div_idx: 1, lp: 51, wins: 22, losses: 20 },
  { username: "cardio_hater", tier_idx: 2, div_idx: 4, lp: 39, wins: 14, losses: 17 },
  { username: "newbie_gains", tier_idx: 1, div_idx: 2, lp: 21, wins: 6, losses: 11 },
];

const leaderboard = (type) => ({
  leaderboard: RIVALS.map((r, i) => ({ ...r, rank: i + 1, name: r.username })),
  current_user: { ...RIVALS[2], rank: 3, name: RIVALS[2].username },
  type,
});

const daysAgo = (n) =>
  new Date(Date.now() - n * 24 * 60 * 60 * 1000).toISOString();

const MATCHES = [
  {
    id: 1,
    muscle_group: "Chest",
    result: "win",
    user_volume_kg: 7420,
    opponent_volume_kg: 6890,
    opponent_username: "benchgod",
    lp_change: 18,
    match_date: daysAgo(1),
  },
  {
    id: 2,
    muscle_group: "Back",
    result: "loss",
    user_volume_kg: 8100,
    opponent_volume_kg: 9240,
    opponent_username: "iron_mike",
    lp_change: -14,
    match_date: daysAgo(3),
  },
  {
    id: 3,
    muscle_group: "Legs",
    result: "win",
    user_volume_kg: 12650,
    opponent_volume_kg: 11020,
    opponent_username: "cardio_hater",
    lp_change: 21,
    match_date: daysAgo(6),
  },
];

const ACHIEVEMENTS = [
  { id: 1, key: "first_match", name: "First Blood", description: "Complete your first match", category: "matches", earned: true, earned_at: daysAgo(20) },
  { id: 2, key: "win_streak_3", name: "On a Roll", description: "Win 3 matches in a row", category: "streaks", earned: true, earned_at: daysAgo(5) },
  { id: 3, key: "win_streak_10", name: "Unstoppable", description: "Win 10 matches in a row", category: "streaks", earned: false, earned_at: null },
  { id: 4, key: "volume_100k", name: "Six Figures", description: "Lift 100,000 kg total", category: "volume", earned: true, earned_at: daysAgo(9) },
  { id: 5, key: "tier_gold", name: "Golden Era", description: "Reach Gold tier", category: "rank", earned: false, earned_at: null },
];

const NOTIFICATIONS = [
  { id: 1, type: "match_result", title: "You won!", body: "You beat benchgod on Chest day", read: false, created_at: daysAgo(1) },
  { id: 2, type: "friend_request", title: "New friend request", body: "squat_queen wants to connect", read: false, created_at: daysAgo(2) },
  { id: 3, type: "achievement", title: "Achievement unlocked", body: "On a Roll — 3 wins in a row", read: true, created_at: daysAgo(5) },
];

const FRIENDS = [
  { id: 2, username: "iron_mike", tier_idx: 5, div_idx: 1, lp: 88, status: "accepted" },
  { id: 3, username: "squat_queen", tier_idx: 4, div_idx: 3, lp: 72, status: "accepted" },
];

// endpoint path (without query) -> handler(method, body) => data
const HANDLERS = {
  "/api/user-onboarding": (method, body) => {
    if (method === "POST") {
      state.onboardingCompleted = true;
      if (body && typeof body === "object") Object.assign(state.profile, body);
      return { success: true };
    }
    return { onboardingCompleted: state.onboardingCompleted };
  },
  "/api/profile": (method, body) => {
    if (method === "POST" || method === "PUT" || method === "PATCH") {
      if (body && typeof body === "object") Object.assign(state.profile, body);
      return { success: true, profile: state.profile };
    }
    return { profile: state.profile };
  },
  "/api/settings": (method, body) => {
    if (method !== "GET") {
      if (body && typeof body === "object") Object.assign(state.settings, body);
      return { success: true, ...state.settings };
    }
    return state.settings;
  },
  "/api/achievements": () => ACHIEVEMENTS,
  "/api/notifications": () => ({
    notifications: NOTIFICATIONS,
    unreadCount: NOTIFICATIONS.filter((n) => !n.read).length,
  }),
  "/api/matches": () => ({ matches: MATCHES }),
  "/api/friends": () => ({ friends: FRIENDS }),
  "/api/stats": () => ({
    basic: {
      total_matches: state.profile.total_matches,
      wins: state.profile.wins,
      losses: state.profile.losses,
      current_win_streak: state.profile.current_win_streak,
    },
    premium: null,
    isPremium: true,
  }),
  "/api/personal-records": () => ({ records: [] }),
  "/api/training-splits": () => ({ splits: [] }),
  "/api/workouts": () => ({ workouts: [] }),
  "/api/exercise-selections": () => ({ selections: [] }),
  "/api/username": (method, body) => {
    if (method !== "GET" && body?.username) state.profile.username = body.username;
    return { available: true, username: state.profile.username, success: true };
  },
  "/api/user-search": () => ({ users: [] }),
  "/api/users/search": () => ({ users: [] }),
  "/api/push-token": () => ({ success: true }),
  "/api/subscription/status": () => ({
    hasActiveSubscription: true,
    subscription: {
      tier: state.profile.subscription_tier,
      status: state.profile.subscription_status,
      expiresAt: state.profile.subscription_expires_at,
    },
  }),
  "/api/subscription/sync": () => ({ success: true }),
  "/api/subscription/history": () => ({ history: [] }),

  // Auth screens post straight to these, so demo them too — any email works
  // and any 6-digit code is accepted.
  "/api/auth/magic/request": () => ({ success: true }),
  "/api/auth/magic/verify": () => ({ ...DEMO_AUTH, success: true }),
  "/api/auth/mobile/signin": () => ({ ...DEMO_AUTH, success: true }),
  "/api/auth/mobile/signup": () => ({ ...DEMO_AUTH, success: true }),
};

/**
 * Returns a fake Response for `endpoint`, mirroring what the real API sends.
 */
export function demoResponse(endpoint, options = {}) {
  const method = (options.method || "GET").toUpperCase();
  const path = String(endpoint).split("?")[0].replace(/\/$/, "");

  let body = null;
  if (options.body) {
    try {
      body = typeof options.body === "string" ? JSON.parse(options.body) : options.body;
    } catch {
      body = null;
    }
  }

  let data;
  if (HANDLERS[path]) {
    data = HANDLERS[path](method, body);
  } else if (path.startsWith("/api/leaderboards")) {
    const type = String(endpoint).includes("local") ? "local" : "global";
    data = leaderboard(type);
  } else {
    // Unknown endpoint: stay quiet rather than blowing up a screen.
    console.log("[demo] unhandled endpoint, returning empty:", path);
    data = {};
  }

  return new Response(JSON.stringify(data), {
    status: 200,
    headers: { "Content-Type": "application/json" },
  });
}

export const DEMO_AUTH = {
  jwt: "demo-mode-token",
  user: { id: "1", email: state.profile.email, name: state.profile.name },
  hasUsername: true,
};

/**
 * Routes every in-app API request to the local data above.
 *
 * Some screens (sign-in, sign-up) call `fetch` directly rather than going
 * through authenticatedFetch, so patching fetch itself is the only way to
 * cover them all from one place. Non-API requests pass straight through.
 */
export function installDemoFetch() {
  if (!IS_DEMO_MODE || globalThis.__demoFetchInstalled) return;
  globalThis.__demoFetchInstalled = true;

  const originalFetch = globalThis.fetch;

  globalThis.fetch = async (input, init = {}) => {
    const url = typeof input === "string" ? input : (input?.url ?? "");
    const match = url.match(/(\/api\/[^?#]*)/);
    if (match) {
      return demoResponse(match[1] + (url.includes("?") ? url.slice(url.indexOf("?")) : ""), init || {});
    }
    return originalFetch(input, init);
  };
}
