import { checkSubscription } from "@/app/api/utils/subscription-middleware";

/**
 * Get current subscription status for authenticated user
 */
export async function GET(request) {
  try {
    const { userId, profile, hasActiveSubscription } =
      await checkSubscription(request);

    if (!userId) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    if (!profile) {
      return Response.json({ error: "Profile not found" }, { status: 404 });
    }

    return Response.json({
      hasActiveSubscription,
      subscription: {
        status: profile.subscription_status,
        tier: profile.subscription_tier,
        expiresAt: profile.subscription_expires_at,
      },
    });
  } catch (error) {
    console.error("Error fetching subscription status:", error);
    return Response.json(
      {
        error: "Failed to fetch subscription status",
        message: error.message,
      },
      { status: 500 },
    );
  }
}
