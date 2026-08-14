/**
 * Test mode — build-time switch for QA/preview builds.
 *
 * When enabled it lets a tester get into the full app in one tap:
 *   - a real throwaway account is created on the backend (no email to type,
 *     no verification step), so every screen loads real data instead of
 *     sitting empty behind a 401
 *   - the subscription paywall gate is treated as satisfied
 *
 * It is driven by EXPO_PUBLIC_TEST_MODE, which is set ONLY in the `preview`
 * build profile in eas.json. Production builds never define it, so all of
 * this compiles away to `false` and none of the bypasses can be reached.
 */

import * as SecureStore from "expo-secure-store";
import { getApiUrl } from "@/utils/getApiUrl";
import { secureStoreOptions } from "@/utils/auth/store";
import { IS_DEMO_MODE, DEMO_AUTH } from "@/utils/demoData";

// Demo mode implies test mode: it also skips the paywall and shows the
// one-tap entry button.
export const IS_TEST_MODE =
  process.env.EXPO_PUBLIC_TEST_MODE === "1" || IS_DEMO_MODE;

// Remembers the throwaway credentials so relaunching the app returns to the
// same tester account (same profile, matches and rank) instead of a new one.
const TEST_ACCOUNT_KEY = "outrepd-test-account";
const TEST_PASSWORD = "test-mode-password";

async function readSavedAccount() {
  try {
    const raw = await SecureStore.getItemAsync(
      TEST_ACCOUNT_KEY,
      secureStoreOptions,
    );
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}

async function saveAccount(account) {
  try {
    await SecureStore.setItemAsync(
      TEST_ACCOUNT_KEY,
      JSON.stringify(account),
      secureStoreOptions,
    );
  } catch {
    // Not being able to remember the account only costs us a new one next
    // launch — never block sign-in over it.
  }
}

async function post(path, body) {
  const response = await fetch(getApiUrl(path), {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });
  const data = await response.json().catch(() => ({}));
  return { ok: response.ok, status: response.status, data };
}

/**
 * Signs into (or first creates) the throwaway tester account.
 * Returns the auth object to hand to setAuth(), or throws with a readable message.
 */
export async function signInAsTester() {
  // Demo builds have no backend to talk to — hand back a local session.
  if (IS_DEMO_MODE) {
    return DEMO_AUTH;
  }

  const saved = await readSavedAccount();

  if (saved?.email) {
    const signin = await post("/api/auth/mobile/signin", {
      email: saved.email,
      password: TEST_PASSWORD,
    });
    if (signin.ok && signin.data?.jwt) {
      return { jwt: signin.data.jwt, user: signin.data.user };
    }
    // Saved account no longer works (database reset, etc.) — fall through and
    // make a fresh one rather than stranding the tester.
  }

  const email = `tester-${Date.now()}-${Math.floor(Math.random() * 10000)}@outrepd.test`;
  const signup = await post("/api/auth/mobile/signup", {
    email,
    password: TEST_PASSWORD,
  });

  if (!signup.ok || !signup.data?.jwt) {
    throw new Error(
      signup.data?.error || `Test sign-in failed (${signup.status})`,
    );
  }

  await saveAccount({ email });
  return { jwt: signup.data.jwt, user: signup.data.user };
}
