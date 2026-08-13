import sql from "@/app/api/utils/sql";
import { getSession } from "@/app/api/utils/getSession";

// GET all personal records for current user
export async function GET(request) {
  try {
    const session = await getSession(request);
    if (!session || !session.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = session.user.id;

    const records = await sql`
      SELECT * FROM personal_records
      WHERE user_id = ${userId}
      ORDER BY muscle_group, achieved_at DESC
    `;

    return Response.json({ records });
  } catch (err) {
    console.error("GET /api/personal-records error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
