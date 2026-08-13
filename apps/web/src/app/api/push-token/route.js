import { getSession } from "@/app/api/utils/getSession";
import sql from "@/app/api/utils/sql";

// Update push notification token
export async function POST(request) {
  const session = await getSession(request);
  if (!session?.user?.id) {
    return Response.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = await request.json();
  const { push_token } = body;

  if (!push_token) {
    return Response.json({ error: "Push token is required" }, { status: 400 });
  }

  // Update push token in user_profiles
  await sql`
    UPDATE user_profiles 
    SET push_token = ${push_token}, updated_at = CURRENT_TIMESTAMP
    WHERE user_id = ${session.user.id}
  `;

  return Response.json({ success: true });
}

// Remove push notification token (e.g., on logout)
export async function DELETE(request) {
  const session = await getSession(request);
  if (!session?.user?.id) {
    return Response.json({ error: "Unauthorized" }, { status: 401 });
  }

  await sql`
    UPDATE user_profiles 
    SET push_token = NULL, updated_at = CURRENT_TIMESTAMP
    WHERE user_id = ${session.user.id}
  `;

  return Response.json({ success: true });
}
