import sql from "@/app/api/utils/sql";

/**
 * RevenueCat Webhook Handler
 * Handles subscription lifecycle events from RevenueCat
 *
 * Event Types:
 * - INITIAL_PURCHASE: First time subscription purchase
 * - RENEWAL: Subscription renewed
 * - CANCELLATION: User cancelled (still active until expiration)
 * - UNCANCELLATION: User re-enabled auto-renewal
 * - NON_RENEWING_PURCHASE: One-time purchase
 * - EXPIRATION: Subscription expired
 * - BILLING_ISSUE: Payment failed
 * - PRODUCT_CHANGE: User changed subscription tier
 */

export async function POST(request) {
  try {
    // Validate webhook secret to ensure request is from RevenueCat
    const webhookSecret = process.env.REVENUECAT_WEBHOOK_SECRET;
    if (webhookSecret) {
      const authHeader = request.headers.get("Authorization");
      // Strip "Bearer " prefix from both sides — works regardless of how RevenueCat sends it
      const incomingToken = (authHeader || "")
        .replace(/^Bearer\s+/i, "")
        .trim();
      const expectedToken = webhookSecret.replace(/^Bearer\s+/i, "").trim();
      if (!incomingToken || incomingToken !== expectedToken) {
        console.warn("[RevenueCat Webhook] Unauthorized — secret mismatch");
        return Response.json({ error: "Unauthorized" }, { status: 401 });
      }
    }

    const body = await request.json();

    // Log webhook for debugging
    console.log("RevenueCat Webhook Received:", {
      type: body.event?.type,
      appUserId: body.event?.app_user_id,
      productId: body.event?.product_id,
    });

    const event = body.event;
    if (!event) {
      return Response.json(
        { error: "Invalid webhook payload" },
        { status: 400 },
      );
    }

    // Extract key data from webhook
    const {
      type: eventType,
      app_user_id: revenuecatUserId,
      product_id: productId,
      purchased_at_ms,
      expiration_at_ms,
      grace_period_expires_at_ms,
      unsubscribe_detected_at_ms,
      billing_issues_detected_at_ms,
      store,
      is_trial_conversion,
      environment,
    } = event;

    // Map RevenueCat app_user_id to our auth_users.id
    // The app_user_id should be set to auth_users.id when configuring RevenueCat
    const userId = parseInt(revenuecatUserId);
    if (!userId || isNaN(userId)) {
      console.error("Invalid user ID from RevenueCat:", revenuecatUserId);
      return Response.json({ error: "Invalid user ID" }, { status: 400 });
    }

    // Determine subscription status based on event type
    let subscriptionStatus = "free";
    let subscriptionTier = "free";

    switch (eventType) {
      case "INITIAL_PURCHASE":
      case "RENEWAL":
      case "UNCANCELLATION":
      case "PRODUCT_CHANGE":
        subscriptionStatus = "active";
        subscriptionTier = mapProductIdToTier(productId);
        break;

      case "CANCELLATION":
        // Still active until expiration
        subscriptionStatus = "cancelled";
        subscriptionTier = mapProductIdToTier(productId);
        break;

      case "BILLING_ISSUE":
        subscriptionStatus = "billing_issue";
        subscriptionTier = mapProductIdToTier(productId);
        break;

      case "EXPIRATION":
        subscriptionStatus = "expired";
        subscriptionTier = "free";
        break;

      case "NON_RENEWING_PURCHASE":
        subscriptionStatus = "active";
        subscriptionTier = mapProductIdToTier(productId);
        break;

      default:
        console.warn("Unknown event type:", eventType);
        subscriptionStatus = "free";
        subscriptionTier = "free";
    }

    // Convert timestamps
    const purchasedAt = purchased_at_ms
      ? new Date(purchased_at_ms)
      : new Date();
    const expiresAt = expiration_at_ms ? new Date(expiration_at_ms) : null;
    const gracePeriodExpiresAt = grace_period_expires_at_ms
      ? new Date(grace_period_expires_at_ms)
      : null;
    const unsubscribeDetectedAt = unsubscribe_detected_at_ms
      ? new Date(unsubscribe_detected_at_ms)
      : null;
    const billingIssuesDetectedAt = billing_issues_detected_at_ms
      ? new Date(billing_issues_detected_at_ms)
      : null;

    // Insert subscription event into history table
    await sql`
      INSERT INTO subscriptions (
        user_id,
        revenuecat_subscriber_id,
        product_id,
        store,
        subscription_status,
        expires_at,
        purchased_at,
        grace_period_expires_at,
        unsubscribe_detected_at,
        billing_issues_detected_at,
        is_sandbox,
        event_type,
        raw_event
      ) VALUES (
        ${userId},
        ${revenuecatUserId},
        ${productId},
        ${store},
        ${subscriptionStatus},
        ${expiresAt},
        ${purchasedAt},
        ${gracePeriodExpiresAt},
        ${unsubscribeDetectedAt},
        ${billingIssuesDetectedAt},
        ${environment === "SANDBOX"},
        ${eventType},
        ${JSON.stringify(event)}
      )
    `;

    // Update user_profiles with current subscription status
    await sql`
      UPDATE user_profiles
      SET 
        subscription_status = ${subscriptionStatus},
        subscription_expires_at = ${expiresAt},
        subscription_tier = ${subscriptionTier},
        updated_at = CURRENT_TIMESTAMP
      WHERE user_id = ${userId}
    `;

    // On EXPIRATION only: wipe all sessions so the user is forced to re-authenticate
    // on next app open. They'll land on the welcome screen and hit the paywall.
    if (eventType === "EXPIRATION") {
      await sql`
        DELETE FROM auth_sessions
        WHERE "userId" = ${userId}
      `;
      console.log(
        `[RevenueCat Webhook] Sessions wiped for expired user ${userId} — will be logged out on next app open`,
      );
    }

    console.log("Subscription updated successfully:", {
      userId,
      status: subscriptionStatus,
      tier: subscriptionTier,
      expiresAt,
    });

    return Response.json({
      received: true,
      userId,
      status: subscriptionStatus,
      tier: subscriptionTier,
    });
  } catch (error) {
    console.error("RevenueCat webhook error:", error);
    return Response.json(
      {
        error: "Webhook processing failed",
        message: error.message,
      },
      { status: 500 },
    );
  }
}

/**
 * Map RevenueCat product ID to subscription tier
 * OUTREPD is a single-tier premium app — all paid products map to "premium"
 */
function mapProductIdToTier(productId) {
  if (!productId) return "free";
  // Single-tier app: any paid subscription = premium
  return "premium";
}
