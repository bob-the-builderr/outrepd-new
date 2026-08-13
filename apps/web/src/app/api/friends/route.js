import sql from "@/app/api/utils/sql";
import { getSession } from "@/app/api/utils/getSession";

// GET /api/friends — list all friends and incoming requests for the current user
export async function GET(request) {
  try {
    const session = await getSession(request);
    if (!session?.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = parseInt(session.user.id);

    // Get all accepted friendships for this user
    const friends = await sql`
      SELECT 
        f.id as friendship_id,
        f.wins_against_friend,
        f.losses_against_friend,
        f.total_matches_against_friend,
        f.created_at,
        au.id as user_id,
        au.name,
        au.email,
        up.username,
        up.tier_idx,
        up.div_idx,
        up.lp,
        up.profile_photo_url,
        up.wins,
        up.losses,
        up.total_matches
      FROM friendships f
      JOIN auth_users au ON (
        CASE 
          WHEN f.user_id = ${userId} THEN f.friend_id 
          ELSE f.user_id 
        END = au.id
      )
      JOIN user_profiles up ON au.id = up.user_id
      WHERE (f.user_id = ${userId} OR f.friend_id = ${userId})
        AND f.status = 'accepted'
      ORDER BY up.tier_idx DESC, up.div_idx DESC, up.lp DESC
    `;

    // Get incoming friend requests (where this user is the friend_id and status is pending)
    const incomingRequests = await sql`
      SELECT 
        f.id as friendship_id,
        f.created_at,
        au.id as user_id,
        au.name,
        au.email,
        up.username,
        up.tier_idx,
        up.div_idx,
        up.lp,
        up.profile_photo_url,
        up.wins,
        up.losses,
        up.total_matches
      FROM friendships f
      JOIN auth_users au ON f.user_id = au.id
      JOIN user_profiles up ON au.id = up.user_id
      WHERE f.friend_id = ${userId}
        AND f.status = 'pending'
      ORDER BY f.created_at DESC
    `;

    return Response.json({ friends, incoming_requests: incomingRequests });
  } catch (err) {
    console.error("GET /api/friends error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}

// POST /api/friends — send a friend request by username
export async function POST(request) {
  try {
    const session = await getSession(request);
    if (!session?.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = parseInt(session.user.id);
    const body = await request.json();
    const { username } = body;

    if (!username) {
      return Response.json({ error: "username is required" }, { status: 400 });
    }

    // Find the target user by username
    const [targetProfile] = await sql`
      SELECT user_id FROM user_profiles WHERE LOWER(username) = LOWER(${username})
    `;

    if (!targetProfile) {
      return Response.json({ error: "User not found" }, { status: 404 });
    }

    const friendId = targetProfile.user_id;

    if (friendId === userId) {
      return Response.json(
        { error: "You cannot add yourself as a friend" },
        { status: 400 },
      );
    }

    // Check if friendship already exists (in either direction)
    const existing = await sql`
      SELECT * FROM friendships 
      WHERE (user_id = ${userId} AND friend_id = ${friendId})
         OR (user_id = ${friendId} AND friend_id = ${userId})
    `;

    if (existing.length > 0) {
      const status = existing[0].status;
      if (status === "accepted") {
        return Response.json(
          { error: "You are already friends" },
          { status: 400 },
        );
      } else if (status === "pending") {
        return Response.json(
          { error: "Friend request already pending" },
          { status: 400 },
        );
      }
    }

    // Create friendship with pending status
    const [friendship] = await sql`
      INSERT INTO friendships (user_id, friend_id, status)
      VALUES (${userId}, ${friendId}, 'pending')
      RETURNING *
    `;

    // Send notification to the target user
    const [senderProfile] = await sql`
      SELECT username FROM user_profiles WHERE user_id = ${userId}
    `;
    const senderName = senderProfile?.username || "Someone";

    await sql`
      INSERT INTO notifications (user_id, type, title, message, data)
      VALUES (
        ${friendId},
        'friend_request',
        'New Friend Request',
        ${`${senderName} wants to be your friend!`},
        ${JSON.stringify({ from_user_id: userId, friendship_id: friendship.id })}
      )
    `;

    return Response.json({ friendship, message: "Friend request sent" });
  } catch (err) {
    console.error("POST /api/friends error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}

// PATCH /api/friends — accept or reject a friend request
export async function PATCH(request) {
  try {
    const session = await getSession(request);
    if (!session?.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = parseInt(session.user.id);
    const body = await request.json();
    const { friendship_id, action } = body; // action: 'accept' or 'reject'

    if (!friendship_id || !action) {
      return Response.json(
        { error: "friendship_id and action are required" },
        { status: 400 },
      );
    }

    if (!["accept", "reject"].includes(action)) {
      return Response.json(
        { error: "action must be 'accept' or 'reject'" },
        { status: 400 },
      );
    }

    // Verify the user is the recipient of this friend request
    const [friendship] = await sql`
      SELECT * FROM friendships WHERE id = ${friendship_id}
    `;

    if (!friendship) {
      return Response.json({ error: "Friendship not found" }, { status: 404 });
    }

    if (friendship.friend_id !== userId) {
      return Response.json(
        { error: "You are not authorized to respond to this request" },
        { status: 403 },
      );
    }

    if (friendship.status !== "pending") {
      return Response.json(
        { error: "This request has already been responded to" },
        { status: 400 },
      );
    }

    if (action === "accept") {
      await sql`
        UPDATE friendships 
        SET status = 'accepted', updated_at = CURRENT_TIMESTAMP
        WHERE id = ${friendship_id}
      `;

      // Send notification to requester
      const [accepterProfile] = await sql`
        SELECT username FROM user_profiles WHERE user_id = ${userId}
      `;
      const accepterName = accepterProfile?.username || "Someone";

      await sql`
        INSERT INTO notifications (user_id, type, title, message, data)
        VALUES (
          ${friendship.user_id},
          'friend_accepted',
          'Friend Request Accepted',
          ${`${accepterName} accepted your friend request!`},
          ${JSON.stringify({ friend_id: userId, friendship_id: friendship_id })}
        )
      `;

      return Response.json({ message: "Friend request accepted" });
    } else {
      // Reject - delete the friendship
      await sql`DELETE FROM friendships WHERE id = ${friendship_id}`;
      return Response.json({ message: "Friend request rejected" });
    }
  } catch (err) {
    console.error("PATCH /api/friends error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}

// DELETE /api/friends — remove a friend
export async function DELETE(request) {
  try {
    const session = await getSession(request);
    if (!session?.user?.id) {
      return Response.json({ error: "Unauthorized" }, { status: 401 });
    }

    const userId = parseInt(session.user.id);
    const body = await request.json();
    const { friend_id } = body;

    if (!friend_id) {
      return Response.json({ error: "friend_id is required" }, { status: 400 });
    }

    // Delete friendship (works in either direction)
    const result = await sql`
      DELETE FROM friendships 
      WHERE (user_id = ${userId} AND friend_id = ${friend_id})
         OR (user_id = ${friend_id} AND friend_id = ${userId})
      RETURNING *
    `;

    if (result.length === 0) {
      return Response.json({ error: "Friendship not found" }, { status: 404 });
    }

    return Response.json({ message: "Friend removed" });
  } catch (err) {
    console.error("DELETE /api/friends error", err);
    return Response.json({ error: "Internal Server Error" }, { status: 500 });
  }
}
