import sql from "@/app/api/utils/sql";
import { getSession } from "@/app/api/utils/getSession";

/**
 * Get subscription history for authenticated user
 */
export async function GET(request) {
  try {
    const session = await getSession(request);
    if (!session?.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = session.user.id;

    // Get subscription history
    const history = await sql`
      SELECT 
        id,
        product_id,
        store,
        subscription_status,
        expires_at,
        purchased_at,
        event_type,
        is_sandbox,
        created_at
      FROM subscriptions
      WHERE user_id = ${userId}
      ORDER BY created_at DESC
      LIMIT 50
    `;

    return Response.json({
      success: true,
      history,
    });
  } catch (error) {
    console.error("Error fetching subscription history:", error);
    return Response.json(
      {
        error: "Failed to fetch subscription history",
        message: error.message,
      },
      { status: 500 },
    );
  }
}
