import { Platform } from "react-native";

/**
 * Returns the full API URL for Expo apps (both web and mobile).
 * Expo web is served from a different domain than the API, so we need the full proxy URL.
 */
export function getApiUrl(path) {
  const proxyUrl = process.env.EXPO_PUBLIC_PROXY_BASE_URL;
  const baseUrl = process.env.EXPO_PUBLIC_BASE_URL;

  console.log("[getApiUrl] Platform:", Platform.OS);
  console.log("[getApiUrl] EXPO_PUBLIC_PROXY_BASE_URL:", proxyUrl);
  console.log("[getApiUrl] EXPO_PUBLIC_BASE_URL:", baseUrl);
  console.log("[getApiUrl] Input path:", path);

  // For Expo Web, use relative URLs to avoid CORS issues
  // The Expo dev server proxies API requests to the backend
  if (Platform.OS === "web") {
    console.log("[getApiUrl] Using relative URL for web platform:", path);
    return path;
  }

  // For native mobile, we need the full URL
  const finalBase = proxyUrl || baseUrl;

  if (!finalBase) {
    console.error(
      "[getApiUrl] ERROR: Missing both EXPO_PUBLIC_PROXY_BASE_URL and EXPO_PUBLIC_BASE_URL",
    );
    console.error(
      "[getApiUrl] Returning raw path (this will likely fail):",
      path,
    );
    return path;
  }

  // Remove trailing slash from baseUrl and leading slash from path
  const cleanBase = finalBase.replace(/\/$/, "");
  const cleanPath = path.replace(/^\//, "");

  const fullUrl = `${cleanBase}/${cleanPath}`;
  console.log("[getApiUrl] Final URL:", fullUrl);

  return fullUrl;
}
