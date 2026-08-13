/**
 * getSession(request)
 *
 * Drop-in replacement for auth() that works for BOTH web and mobile.
 *
 * Web:    auth() reads the platform session cookie and returns the user.
 * Mobile: auth() fails because the mobile JWT is encoded differently.
 *         We fall back to decoding the mobile JWT directly from the Cookie header.
 *
 * Usage in any API route:
 *   import { getSession } from "@/app/api/utils/getSession";
 *   const session = await getSession(request);
 *   if (!session?.user?.id) return Response.json({ error: "Unauthorized" }, { status: 401 });
 */

import { auth } from "@/auth";
import { decode } from "@auth/core/jwt";

export async function getSession(request) {
  // 1. Try the standard platform auth() first (works for web users)
  try {
    const session = await auth();
    if (session?.user?.id) {
      return session;
    }
  } catch (e) {
    // auth() may throw in some contexts — fall through to mobile decode
  }

  // 2. Mobile fallback: decode the JWT directly from the Cookie header
  try {
    const cookieHeader =
      (request?.headers?.get
        ? request.headers.get("cookie")
        : request?.headers?.["cookie"]) || "";

    if (!cookieHeader) return null;

    // Extract the JWT from either cookie name
    const cookieNames = [
      "__Secure-authjs.session-token",
      "authjs.session-token",
    ];

    let jwt = null;
    for (const name of cookieNames) {
      // Cookie header format: "name=value; name2=value2"
      const escaped = name.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
      const match = cookieHeader.match(
        new RegExp(`(?:^|;\\s*)${escaped}=([^;]+)`),
      );
      if (match?.[1]) {
        jwt = decodeURIComponent(match[1]);
        break;
      }
    }

    if (!jwt) return null;

    // Try decoding with both salts — one of them will match how it was encoded
    const salts = ["__Secure-authjs.session-token", "authjs.session-token"];

    for (const salt of salts) {
      try {
        const decoded = await decode({
          token: jwt,
          secret: process.env.AUTH_SECRET,
          salt,
        });

        if (decoded?.sub) {
          return {
            user: {
              id: decoded.sub,
              email: decoded.email ?? null,
              name: decoded.name ?? null,
              image: decoded.picture ?? null,
            },
          };
        }
      } catch {
        // Wrong salt — try the next one
      }
    }
  } catch (err) {
    console.error("[getSession] Mobile JWT decode error:", err);
  }

  return null;
}
