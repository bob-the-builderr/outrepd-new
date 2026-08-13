import * as SecureStore from "expo-secure-store";
import { authKey, secureStoreOptions } from "@/utils/auth/store";
import { getApiUrl } from "@/utils/getApiUrl";

/**
 * Makes an authenticated fetch request by including the JWT token from SecureStore
 * as a cookie header. Use this for all API calls that require authentication.
 *
 * @param {string} endpoint - The API endpoint (e.g., "/api/profile")
 * @param {RequestInit} options - Standard fetch options
 * @returns {Promise<Response>} - The fetch response
 */
export async function authenticatedFetch(endpoint, options = {}) {
  try {
    // Get the JWT token from SecureStore
    const authData = await SecureStore.getItemAsync(
      authKey,
      secureStoreOptions,
    );

    if (!authData) {
      throw new Error("No authentication token found");
    }

    const { jwt } = JSON.parse(authData);

    if (!jwt) {
      throw new Error("Invalid authentication data");
    }

    // Make the fetch request with the full URL and auth headers
    const url = getApiUrl(endpoint);

    // Send BOTH cookie names to ensure one matches the backend's AUTH_URL setting
    // The backend will use whichever one matches its JWT encoding salt
    const secureCookie = `__Secure-authjs.session-token=${jwt}`;
    const regularCookie = `authjs.session-token=${jwt}`;

    console.log("[authenticatedFetch] Request:", {
      endpoint,
      url,
      jwtLength: jwt?.length,
    });

    // Merge headers with both authentication cookies
    const headers = {
      ...options.headers,
      Cookie: `${secureCookie}; ${regularCookie}`,
    };

    const response = await fetch(url, {
      ...options,
      headers,
    });

    console.log("[authenticatedFetch] Response:", {
      status: response.status,
      ok: response.ok,
    });

    return response;
  } catch (error) {
    console.error("[authenticatedFetch] Error:", error);
    throw error;
  }
}
