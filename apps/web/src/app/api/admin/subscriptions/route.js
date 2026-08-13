import sql from "@/app/api/utils/sql";
import { getSession } from "@/app/api/utils/getSession";

/**
 * Admin endpoint to view all subscriptions (for debugging)
 * In production, you should add proper admin authentication
 */
export async function GET(request) {
  try {
    const session = await getSession(request);
    if (!session?.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    // TODO: Add admin role check here
    // For now, this is open to any authenticated user
    // You should add proper admin authorization before deploying

    const { searchParams } = new URL(request.url);
    const userId = searchParams.get("userId");
    const status = searchParams.get("status");
    const limit = parseInt(searchParams.get("limit") || "100");

    let query = sql`
      SELECT 
        s.id,
        s.user_id,
        u.email,
        u.name,
        s.product_id,
        s.store,
        s.subscription_status,
        s.expires_at,
        s.purchased_at,
        s.event_type,
        s.is_sandbox,
        s.created_at
      FROM subscriptions s
      JOIN auth_users u ON s.user_id = u.id
      WHERE 1=1
    `;

    const conditions = [];
    const params = [];

    if (userId) {
      conditions.push(`s.user_id = ${userId}`);
    }

    if (status) {
      conditions.push(`s.subscription_status = ${status}`);
    }

    const subscriptions = await sql`
      SELECT 
        s.id,
        s.user_id,
        u.email,
        u.name,
        s.product_id,
        s.store,
        s.subscription_status,
        s.expires_at,
        s.purchased_at,
        s.event_type,
        s.is_sandbox,
        s.created_at
      FROM subscriptions s
      JOIN auth_users u ON s.user_id = u.id
      ${userId ? sql`WHERE s.user_id = ${parseInt(userId)}` : sql``}
      ORDER BY s.created_at DESC
      LIMIT ${limit}
    `;

    // Get summary stats
    const stats = await sql`
      SELECT 
        COUNT(*) as total_subscriptions,
        COUNT(DISTINCT user_id) as unique_subscribers,
        COUNT(*) FILTER (WHERE subscription_status = 'active') as active_count,
        COUNT(*) FILTER (WHERE subscription_status = 'cancelled') as cancelled_count,
        COUNT(*) FILTER (WHERE subscription_status = 'expired') as expired_count
      FROM subscriptions
    `.then((rows) => rows[0]);

    return Response.json({
      success: true,
      subscriptions,
      stats,
    });
  } catch (error) {
    console.error("Error fetching subscriptions:", error);
    return Response.json(
      {
        error: "Failed to fetch subscriptions",
        message: error.message,
      },
      { status: 500 },
    );
  }
}
