import { router } from "expo-router";
import * as SecureStore from "expo-secure-store";
import { useCallback, useEffect } from "react";
import queryClient from "@/utils/queryClient";
import { useAuthStore, authKey, secureStoreOptions } from "./store";

/**
 * This hook provides authentication functionality.
 */
export const useAuth = () => {
  const { isReady, auth, setAuth } = useAuthStore();

  const initiate = useCallback(() => {
    // The auth state machine must always reach a terminal state. SecureStore
    // can throw or hang in TestFlight release builds (Keychain access denied,
    // missing keychain-access-groups entitlement after EAS migration, locked
    // device first-unlock state, or iOS 26 TurboModule rethrow). Without a
    // catch the unhandled rejection leaves isReady=false forever and the
    // RootLayout renders null — the user sees a blank screen indefinitely.
    Promise.race([
      SecureStore.getItemAsync(authKey, secureStoreOptions),
      new Promise((resolve) => setTimeout(() => resolve(null), 3000)),
    ])
      .then((stored) => {
        useAuthStore.setState({
          auth: stored ? JSON.parse(stored) : null,
          isReady: true,
        });
      })
      .catch(() => {
        useAuthStore.setState({ auth: null, isReady: true });
      });
  }, []);

  useEffect(() => {}, []);

  const signIn = useCallback(() => {
    // Navigate to native login screen
    router.push("/onboarding?page=3&mode=signin");
  }, []);

  const signUp = useCallback(() => {
    // Navigate to native signup screen
    router.push("/onboarding?page=3&mode=signup");
  }, []);

  const signOut = useCallback(async () => {
    try {
      // 1. Fire-and-forget server-side session invalidation
      fetch("/api/auth/signout", {
        method: "POST",
        redirect: "manual",
        credentials: "include",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
      }).catch(() => {});

      // 2. Wipe SecureStore token.
      await SecureStore.deleteItemAsync(authKey, secureStoreOptions).catch(
        () => {},
      );

      // 3. Clear Zustand auth state.
      setAuth(null);

      // 4. Clear React Query cache.
      queryClient.clear();

      // 5. Fire-and-forget push token cleanup.
      fetch("/api/push-token", {
        method: "DELETE",
        credentials: "include",
      }).catch(() => {});

      // 6. Navigate to welcome screen
      router.replace("/welcome");
    } catch (error) {
      console.error("Sign-out error:", error);
      // Always attempt navigation even if sign-out partially failed
      // so the button never stays stuck.
      try {
        router.replace("/welcome");
      } catch (navError) {
        console.error("Navigation fallback failed:", navError);
      }
    }
  }, [setAuth]);

  return {
    isReady,
    isAuthenticated: isReady ? !!auth : null,
    signIn,
    signOut,
    signUp,
    auth,
    setAuth,
    initiate,
  };
};

/**
 * This hook will automatically navigate to login if the user is not authenticated.
 */
export const useRequireAuth = (options) => {
  const { isAuthenticated, isReady } = useAuth();

  useEffect(() => {
    if (!isAuthenticated && isReady) {
      router.replace("/welcome");
    }
  }, [isAuthenticated, isReady]);
};

export default useAuth;
