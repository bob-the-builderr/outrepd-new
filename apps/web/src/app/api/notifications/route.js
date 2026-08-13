import { getSession } from "@/app/api/utils/getSession";
import sql from "@/app/api/utils/sql";

// Get notifications for current user
export async function GET(request) {
  const session = await getSession(request);
  if (!session?.user?.id) {
    return Response.json({ error: "Unauthorized" }, { status: 401 });
  }

  const { searchParams } = new URL(request.url);
  const unreadOnly = searchParams.get("unread") === "true";

  let notifications;
  if (unreadOnly) {
    notifications = await sql`
      SELECT * FROM notifications 
      WHERE user_id = ${session.user.id} AND is_read = false
      ORDER BY created_at DESC
      LIMIT 50
    `;
  } else {
    notifications = await sql`
      SELECT * FROM notifications 
      WHERE user_id = ${session.user.id}
      ORDER BY created_at DESC
      LIMIT 50
    `;
  }

  // Get unread count
  const unreadCount = await sql`
    SELECT COUNT(*) as count FROM notifications 
    WHERE user_id = ${session.user.id} AND is_read = false
  `;

  return Response.json({
    notifications,
    unreadCount: parseInt(unreadCount[0].count),
  });
}

// Create a notification (internal use)
export async function POST(request) {
  const session = await getSession(request);
  if (!session?.user?.id) {
    return Response.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = await request.json();
  const { user_id, type, title, message, data } = body;

  // Only allow creating notifications for self or if no user_id specified
  const targetUserId = user_id || session.user.id;

  const result = await sql`
    INSERT INTO notifications (user_id, type, title, message, data)
    VALUES (${targetUserId}, ${type}, ${title}, ${message}, ${data ? JSON.stringify(data) : null})
    RETURNING *
  `;

  return Response.json(result[0]);
}

// Mark notification(s) as read
export async function PATCH(request) {
  const session = await getSession(request);
  if (!session?.user?.id) {
    return Response.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = await request.json();
  const { notification_id, mark_all_read } = body;

  if (mark_all_read) {
    // Mark all notifications as read
    await sql`
      UPDATE notifications 
      SET is_read = true 
      WHERE user_id = ${session.user.id} AND is_read = false
    `;
    return Response.json({ success: true, marked: "all" });
  } else if (notification_id) {
    // Mark specific notification as read
    await sql`
      UPDATE notifications 
      SET is_read = true 
      WHERE id = ${notification_id} AND user_id = ${session.user.id}
    `;
    return Response.json({ success: true, marked: notification_id });
  }

  return Response.json({ error: "No notification specified" }, { status: 400 });
}
