import { create } from "zustand";
import * as SecureStore from "expo-secure-store";

export const authKey = `${process.env.EXPO_PUBLIC_PROJECT_GROUP_ID}-jwt`;

/**
 * Explicit Keychain options used on every SecureStore call in the auth flow.
 */
export const secureStoreOptions = {
  keychainService: "anything-auth",
  keychainAccessible: SecureStore.AFTER_FIRST_UNLOCK_THIS_DEVICE_ONLY,
  requireAuthentication: false,
};

/**
 * This store manages the authentication state of the application.
 * auth object shape: { jwt, user, hasUsername }
 */
export const useAuthStore = create((set) => ({
  isReady: false,
  auth: null,
  setAuth: (auth) => {
    if (auth) {
      SecureStore.setItemAsync(
        authKey,
        JSON.stringify(auth),
        secureStoreOptions,
      ).catch(() => {});
    } else {
      SecureStore.deleteItemAsync(authKey, secureStoreOptions).catch(() => {});
    }
    set({ auth });
  },
  // Helper to mark username as set without replacing the whole auth object
  setHasUsername: (hasUsername) => {
    set((state) => {
      const updated = { ...state.auth, hasUsername };
      SecureStore.setItemAsync(
        authKey,
        JSON.stringify(updated),
        secureStoreOptions,
      ).catch(() => {});
      return { auth: updated };
    });
  },
}));
