import { syncSubscriptionStatus } from "@/app/api/utils/subscription-middleware";
import { getSession } from "@/app/api/utils/getSession";

/**
 * Sync subscription status from database
 * Called when app opens or user wants to refresh subscription status
 */
export async function POST(request) {
  try {
    const session = await getSession(request);
    if (!session?.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = session.user.id;

    // Sync subscription status
    const profile = await syncSubscriptionStatus(userId);

    return Response.json({
      success: true,
      subscription: {
        status: profile.subscription_status,
        tier: profile.subscription_tier,
        expiresAt: profile.subscription_expires_at,
      },
    });
  } catch (error) {
    console.error("Error syncing subscription:", error);
    return Response.json(
      {
        error: "Failed to sync subscription",
        message: error.message,
      },
      { status: 500 },
    );
  }
}
