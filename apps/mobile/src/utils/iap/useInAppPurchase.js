import { useState, useCallback, useRef, useEffect } from "react";
import Purchases from "react-native-purchases";
import { Platform } from "react-native";
import { iapStore } from "./iapStore";
import { authenticatedFetch } from "@/utils/authenticatedFetch";

let isConfigured = false;

const getRevenueCatAPIKey = () => {
  if (process.env.EXPO_PUBLIC_CREATE_ENV === "DEVELOPMENT") {
    return process.env.EXPO_PUBLIC_REVENUE_CAT_TEST_STORE_API_KEY;
  }
  if (Platform.OS === "ios") {
    return process.env.EXPO_PUBLIC_REVENUE_CAT_APP_STORE_API_KEY;
  }
  if (Platform.OS === "android") {
    return process.env.EXPO_PUBLIC_REVENUE_CAT_PLAY_STORE_API_KEY;
  }
  console.warn(
    "Running on unknown platform, defaulting to Test Store RevenueCat API key"
  );
  return process.env.EXPO_PUBLIC_REVENUE_CAT_TEST_STORE_API_KEY;
};

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

export function useInAppPurchase() {
  const [isReady, setIsReady] = useState(iapStore.isIAPReady);
  const [offerings, setOfferings] = useState(iapStore.offerings);
  const [isSubscribed, setIsSubscribed] = useState(iapStore.isSubscribed);
  const [isPurchasing, setIsPurchasing] = useState(false);
  const initiatedRef = useRef(false);

  // Stay in sync with the global store (in case another instance updated it)
  useEffect(() => {
    const unsub = iapStore.subscribe(() => {
      setIsReady(iapStore.isIAPReady);
      setOfferings(iapStore.offerings);
      setIsSubscribed(iapStore.isSubscribed);
    });
    return unsub;
  }, []);

  const initiate = useCallback(async (userId) => {
    if (initiatedRef.current) return;
    initiatedRef.current = true;

    try {
      const apiKey = getRevenueCatAPIKey();
      if (!apiKey) {
        console.warn("[IAP] No RevenueCat API key found — skipping configure");
        setIsReady(true);
        iapStore.setReady(true);
        return;
      }

      if (!isConfigured) {
        Purchases.configure({ apiKey });
        isConfigured = true;
      }

      // Set user ID for RevenueCat (critical for webhook to identify user)
      if (userId) {
        try {
          await Purchases.logIn(String(userId));
          console.log("[IAP] User ID set in RevenueCat:", userId);
        } catch (e) {
          console.warn("[IAP] Failed to set user ID:", e.message);
        }
      }

      // Retry logic for offerings
      let fetchedOfferings = null;
      for (let attempt = 0; attempt < 3; attempt++) {
        try {
          fetchedOfferings = await Purchases.getOfferings();
          if (fetchedOfferings?.current) break;
        } catch (e) {
          console.warn(
            `[IAP] Offerings attempt ${attempt + 1} failed:`,
            e.message
          );
        }
        if (attempt < 2) await sleep(1500);
      }

      // Sync offerings to global store so all hook instances can read them
      setOfferings(fetchedOfferings);
      iapStore.setOfferings(fetchedOfferings);

      // Debug: log what RevenueCat returned so we can diagnose missing plans
      console.log("[IAP] offerings.current:", fetchedOfferings?.current);
      console.log(
        "[IAP] offerings.all keys:",
        fetchedOfferings?.all ? Object.keys(fetchedOfferings.all) : "none"
      );
      const allPkgs =
        fetchedOfferings?.current?.availablePackages ??
        Object.values(fetchedOfferings?.all ?? {}).flatMap(
          (o) => o.availablePackages ?? []
        );
      console.log(
        "[IAP] total packages found:",
        allPkgs.length,
        allPkgs.map((p) => p.packageType)
      );

      // Check subscription status
      try {
        const customerInfo = await Purchases.getCustomerInfo();
        const activeEntitlements = customerInfo?.entitlements?.active || {};
        const subscribed = Object.keys(activeEntitlements).length > 0;
        setIsSubscribed(subscribed);
        iapStore.setSubscribed(subscribed);

        // Sync with backend
        await syncSubscriptionWithBackend();
      } catch (e) {
        console.warn("[IAP] Could not check customer info:", e.message);
      }
    } catch (e) {
      console.error("[IAP] Initiation error:", e);
    } finally {
      setIsReady(true);
      iapStore.setReady(true);
    }
  }, []);

  const getAvailablePackages = useCallback(() => {
    const o = iapStore.offerings ?? offerings;
    // Try current offering first, fall back to all offerings combined
    const fromCurrent = o?.current?.availablePackages ?? [];
    if (fromCurrent.length > 0) return fromCurrent;
    return Object.values(o?.all ?? {}).flatMap(
      (off) => off.availablePackages ?? []
    );
  }, [offerings]);

  const getAvailableSubscriptions = useCallback(() => {
    const o = iapStore.offerings ?? offerings;
    // Try current offering first, fall back to all offerings combined
    const fromCurrent = o?.current?.availablePackages ?? [];
    const allPkgs =
      fromCurrent.length > 0
        ? fromCurrent
        : Object.values(o?.all ?? {}).flatMap(
            (off) => off.availablePackages ?? []
          );
    return allPkgs.filter(
      (pkg) => pkg.packageType !== "LIFETIME" && pkg.packageType !== "UNKNOWN"
    );
  }, [offerings]);

  const purchasePackage = useCallback(async ({ pkg }) => {
    setIsPurchasing(true);
    try {
      const { customerInfo } = await Purchases.purchasePackage(pkg);
      const activeEntitlements = customerInfo?.entitlements?.active || {};
      const subscribed = Object.keys(activeEntitlements).length > 0;
      setIsSubscribed(subscribed);
      iapStore.setSubscribed(subscribed);

      // Sync with backend after purchase
      await syncSubscriptionWithBackend();

      return { success: true, customerInfo, cancelled: false };
    } catch (e) {
      if (e.userCancelled) {
        return { success: false, customerInfo: null, cancelled: true };
      }
      console.error("[IAP] Purchase error:", e);
      return { success: false, customerInfo: null, cancelled: false };
    } finally {
      setIsPurchasing(false);
    }
  }, []);

  const restorePurchases = useCallback(async () => {
    setIsPurchasing(true);
    try {
      const customerInfo = await Purchases.restorePurchases();
      const activeEntitlements = customerInfo?.entitlements?.active || {};
      const subscribed = Object.keys(activeEntitlements).length > 0;
      setIsSubscribed(subscribed);
      iapStore.setSubscribed(subscribed);

      // Sync with backend after restore
      await syncSubscriptionWithBackend();

      return { success: true, customerInfo };
    } catch (e) {
      console.error("[IAP] Restore error:", e);
      return { success: false, customerInfo: null };
    } finally {
      setIsPurchasing(false);
    }
  }, []);

  return {
    isReady,
    offerings,
    isSubscribed,
    isPurchasing,
    initiate,
    getAvailablePackages,
    getAvailableSubscriptions,
    purchasePackage,
    restorePurchases,
  };
}

/**
 * Sync subscription status with backend
 */
async function syncSubscriptionWithBackend() {
  try {
    const response = await authenticatedFetch("/api/subscription/sync", {
      method: "POST",
    });

    if (!response.ok) {
      console.warn("[IAP] Failed to sync subscription with backend");
    } else {
      console.log("[IAP] Subscription synced with backend");
    }
  } catch (error) {
    console.error("[IAP] Error syncing subscription:", error);
  }
}