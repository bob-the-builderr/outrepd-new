/**
 * Add CORS headers to a Response object
 */
export function addCorsHeaders(response, origin) {
  response.headers.set("Access-Control-Allow-Origin", origin || "*");
  response.headers.set(
    "Access-Control-Allow-Methods",
    "GET, POST, PUT, DELETE, PATCH, OPTIONS",
  );
  response.headers.set(
    "Access-Control-Allow-Headers",
    "Content-Type, Authorization, Accept",
  );
  response.headers.set("Access-Control-Allow-Credentials", "true");
  return response;
}

/**
 * Handle OPTIONS preflight requests
 */
export function handleCorsPreFlight(request) {
  const origin = request.headers.get("origin");
  return addCorsHeaders(new Response(null, { status: 200 }), origin);
}

/**
 * Wrap a Response with CORS headers
 */
export function corsResponse(data, options = {}, request = null) {
  const origin = request?.headers?.get("origin");
  const response = Response.json(data, options);
  return addCorsHeaders(response, origin);
}
