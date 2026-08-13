import sql from "@/app/api/utils/sql";
import { getSession } from "@/app/api/utils/getSession";

/**
 * Subscription verification middleware
 * Checks if user has an active subscription server-side
 *
 * Usage:
 * import { requireSubscription } from "@/app/api/utils/subscription-middleware";
 *
 * export async function POST(request) {
 *   const { userId, profile } = await requireSubscription(request);
 *   // Your protected code here
 * }
 */

/**
 * Check if user has active subscription
 * @param {Request} request
 * @param {Object} options - Configuration options
 * @param {string[]} options.allowedTiers - Array of allowed tiers (default: ['premium', 'elite'])
 * @param {boolean} options.allowFree - Allow free users (default: false)
 * @returns {Promise<{userId: number, profile: Object}>}
 * @throws {Response} Returns 401/403 response if unauthorized
 */
export async function requireSubscription(request, options = {}) {
  const { allowedTiers = ["premium", "elite"], allowFree = false } = options;

  // Get authenticated user session
  const session = await getSession(request);
  if (!session?.user?.id) {
    throw Response.json({ error: "Unauthorized" }, { status: 401 });
  }

  const userId = session.user.id;

  // Fetch user profile with subscription status
  const profile = await sql`
    SELECT 
      id,
      user_id,
      subscription_status,
      subscription_tier,
      subscription_expires_at
    FROM user_profiles
    WHERE user_id = ${userId}
  `.then((rows) => rows[0]);

  if (!profile) {
    throw Response.json({ error: "Profile not found" }, { status: 404 });
  }

  // Check if subscription is active
  const hasActiveSubscription = await isSubscriptionActive(profile);

  // Allow free users if configured
  if (allowFree && !hasActiveSubscription) {
    return { userId, profile };
  }

  // Check if user has valid subscription
  if (!hasActiveSubscription) {
    throw Response.json(
      {
        error: "Subscription required",
        message: "This feature requires an active subscription",
        subscriptionStatus: profile.subscription_status,
        tier: profile.subscription_tier,
      },
      { status: 403 }
    );
  }

  // Check if user's tier is allowed
  if (!allowedTiers.includes(profile.subscription_tier)) {
    throw Response.json(
      {
        error: "Insufficient subscription tier",
        message: `This feature requires ${allowedTiers.join(
          " or "
        )} subscription`,
        currentTier: profile.subscription_tier,
        requiredTiers: allowedTiers,
      },
      { status: 403 }
    );
  }

  return { userId, profile };
}

/**
 * Check subscription status without throwing errors
 * Useful for routes that want to provide different behavior for subscribers
 *
 * @param {Request} request
 * @returns {Promise<{userId: number, profile: Object, hasActiveSubscription: boolean}>}
 */
export async function checkSubscription(request) {
  try {
    const session = await getSession(request);
    if (!session?.user?.id) {
      return { userId: null, profile: null, hasActiveSubscription: false };
    }

    const userId = session.user.id;

    const profile = await sql`
      SELECT 
        id,
        user_id,
        subscription_status,
        subscription_tier,
        subscription_expires_at
      FROM user_profiles
      WHERE user_id = ${userId}
    `.then((rows) => rows[0]);

    if (!profile) {
      return { userId, profile: null, hasActiveSubscription: false };
    }

    const hasActiveSubscription = await isSubscriptionActive(profile);

    return { userId, profile, hasActiveSubscription };
  } catch (error) {
    console.error("Error checking subscription:", error);
    return { userId: null, profile: null, hasActiveSubscription: false };
  }
}

/**
 * Verify if subscription is currently active
 * @param {Object} profile - User profile with subscription data
 * @returns {Promise<boolean>}
 */
async function isSubscriptionActive(profile) {
  const { subscription_status, subscription_expires_at } = profile;

  // If status is active or cancelled (but not expired), check expiration date
  if (subscription_status === "active" || subscription_status === "cancelled") {
    if (!subscription_expires_at) {
      // No expiration means lifetime or error - treat as active for now
      return true;
    }

    const expiresAt = new Date(subscription_expires_at);
    const now = new Date();

    // Active if hasn't expired yet
    return now < expiresAt;
  }

  // All other statuses (expired, billing_issue, free) are not active
  return false;
}

/**
 * Sync subscription status from RevenueCat
 * Call this periodically or when user opens app to ensure data is fresh
 *
 * @param {number} userId
 * @returns {Promise<Object>} Updated profile
 */
export async function syncSubscriptionStatus(userId) {
  try {
    // Get latest subscription from history
    const latestSub = await sql`
      SELECT *
      FROM subscriptions
      WHERE user_id = ${userId}
      ORDER BY created_at DESC
      LIMIT 1
    `.then((rows) => rows[0]);

    if (!latestSub) {
      // No subscription history, ensure user is set to free
      await sql`
        UPDATE user_profiles
        SET 
          subscription_status = 'free',
          subscription_tier = 'free',
          subscription_expires_at = NULL,
          updated_at = CURRENT_TIMESTAMP
        WHERE user_id = ${userId}
      `;
      return await sql`
        SELECT *
        FROM user_profiles
        WHERE user_id = ${userId}
      `.then((rows) => rows[0]);
    }

    // Check if subscription has expired
    let status = latestSub.subscription_status;
    let tier = latestSub.subscription_tier;

    if (latestSub.expires_at) {
      const expiresAt = new Date(latestSub.expires_at);
      const now = new Date();

      if (now >= expiresAt && status !== "expired") {
        status = "expired";
        tier = "free";
      }
    }

    // Update user profile
    await sql`
      UPDATE user_profiles
      SET 
        subscription_status = ${status},
        subscription_tier = ${tier},
        subscription_expires_at = ${latestSub.expires_at},
        updated_at = CURRENT_TIMESTAMP
      WHERE user_id = ${userId}
    `;

    return await sql`
      SELECT *
      FROM user_profiles
      WHERE user_id = ${userId}
    `.then((rows) => rows[0]);
  } catch (error) {
    console.error("Error syncing subscription:", error);
    throw error;
  }
}