import { getToken } from "@auth/core/jwt";
import { handleCorsPreFlight, addCorsHeaders } from "@/app/api/utils/cors";

export async function OPTIONS(request) {
  return handleCorsPreFlight(request);
}

export async function GET(request) {
  console.log("[Token API] === REQUEST RECEIVED ===");

  const isSecure =
    process.env.AUTH_URL?.startsWith("https") ??
    request.url?.startsWith("https") ??
    false;

  console.log("[Token API] isSecure:", isSecure);
  console.log("[Token API] Request URL:", request.url);

  const [token, jwt] = await Promise.all([
    getToken({
      req: request,
      secret: process.env.AUTH_SECRET,
      secureCookie: isSecure,
      raw: true,
    }),
    getToken({
      req: request,
      secret: process.env.AUTH_SECRET,
      secureCookie: isSecure,
    }),
  ]);

  console.log("[Token API] Token exists:", !!token);
  console.log("[Token API] JWT exists:", !!jwt);
  console.log("[Token API] JWT user ID:", jwt?.sub);
  console.log("[Token API] JWT email:", jwt?.email);

  const origin = request.headers.get("origin");
  console.log("[Token API] Origin:", origin);

  if (!jwt) {
    console.log("[Token API] No JWT found - returning 401");
    return addCorsHeaders(
      new Response(JSON.stringify({ error: "Unauthorized" }), {
        status: 401,
        headers: {
          "Content-Type": "application/json",
        },
      }),
      origin,
    );
  }

  console.log("[Token API] Success - returning JWT and user data");
  return addCorsHeaders(
    new Response(
      JSON.stringify({
        jwt: token,
        user: {
          id: jwt.sub,
          email: jwt.email,
          name: jwt.name,
        },
      }),
      {
        headers: {
          "Content-Type": "application/json",
        },
      },
    ),
    origin,
  );
}
