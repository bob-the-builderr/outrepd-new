import React, { useState, useEffect, useRef } from "react";
import { View, ActivityIndicator } from "react-native";
import { Redirect } from "expo-router";
import { useAuth } from "@/utils/auth/useAuth";
import { useAuthStore } from "@/utils/auth/store";
import { authenticatedFetch } from "@/utils/authenticatedFetch";
import { useQueryClient } from "@tanstack/react-query";
import LoadingScreen from "@/components/LoadingScreen";
import { iapStore } from "@/utils/iap";

export default function Index() {
  const { auth, isReady } = useAuth();
  const queryClient = useQueryClient();
  const [checkingOnboarding, setCheckingOnboarding] = useState(false);
  const [onboardingCompleted, setOnboardingCompleted] = useState(null);
  const [prefetchingData, setPrefetchingData] = useState(false);
  const [currentLoadingStep, setCurrentLoadingStep] = useState(0);

  // IAP subscription state — read from module-level store
  const [iapReady, setIapReady] = useState(iapStore.isIAPReady);
  const [isSubscribed, setIsSubscribed] = useState(iapStore.isSubscribed);
  const iapTimeoutRef = useRef(null);

  const loadingSteps = [
    "Loading profile...",
    "Loading settings...",
    "Loading achievements...",
    "Loading notifications...",
    "Loading match history...",
    "Loading leaderboards...",
  ];

  useEffect(() => {
    if (!isReady || !auth) return;
    checkOnboarding();
  }, [auth, isReady]);

  // Listen to IAP store for when it becomes ready
  useEffect(() => {
    const unsub = iapStore.subscribe(() => {
      setIapReady(iapStore.isIAPReady);
      setIsSubscribed(iapStore.isSubscribed);
    });

    // Safety timeout — if IAP never becomes ready in 6s, treat as not subscribed
    // so the user still sees the paywall (safe default)
    iapTimeoutRef.current = setTimeout(() => {
      if (!iapStore.isIAPReady) {
        setIapReady(true);
      }
    }, 6000);

    return () => {
      unsub();
      if (iapTimeoutRef.current) clearTimeout(iapTimeoutRef.current);
    };
  }, []);

  const checkOnboarding = async () => {
    setCheckingOnboarding(true);
    try {
      const response = await authenticatedFetch("/api/user-onboarding");
      if (!response.ok) {
        // On failure, don't block — let them into the app
        setOnboardingCompleted(true);
        setCheckingOnboarding(false);
        return;
      }
      const data = await response.json();
      setOnboardingCompleted(data.onboardingCompleted ?? false);
    } catch (error) {
      console.error("[Index] Onboarding check error:", error.message);
      setOnboardingCompleted(true);
    }
    setCheckingOnboarding(false);
  };

  // Pre-fetch all tab data after onboarding check passes
  useEffect(() => {
    if (
      !auth ||
      onboardingCompleted !== true ||
      prefetchingData ||
      !iapReady ||
      !isSubscribed
    )
      return;
    prefetchAllTabData();
  }, [auth, onboardingCompleted, iapReady, isSubscribed]);

  const prefetchAllTabData = async () => {
    setPrefetchingData(true);
    try {
      await queryClient.invalidateQueries();

      setCurrentLoadingStep(0);
      await queryClient.prefetchQuery({
        queryKey: ["profile"],
        queryFn: async () => {
          const res = await authenticatedFetch("/api/profile");
          if (!res.ok) throw new Error("Failed to fetch profile");
          return res.json();
        },
      });

      setCurrentLoadingStep(1);
      await queryClient.prefetchQuery({
        queryKey: ["settings"],
        queryFn: async () => {
          const res = await authenticatedFetch("/api/settings");
          if (!res.ok) throw new Error("Failed to fetch settings");
          return res.json();
        },
      });

      setCurrentLoadingStep(2);
      await queryClient.prefetchQuery({
        queryKey: ["achievements"],
        queryFn: async () => {
          const res = await authenticatedFetch("/api/achievements");
          if (!res.ok) throw new Error("Failed to fetch achievements");
          return res.json();
        },
      });

      setCurrentLoadingStep(3);
      await queryClient.prefetchQuery({
        queryKey: ["notifications"],
        queryFn: async () => {
          const res = await authenticatedFetch("/api/notifications");
          if (!res.ok) throw new Error("Failed to fetch notifications");
          return res.json();
        },
      });

      setCurrentLoadingStep(4);
      await queryClient.prefetchQuery({
        queryKey: ["matches"],
        queryFn: async () => {
          const res = await authenticatedFetch("/api/matches?limit=50");
          if (!res.ok) throw new Error("Failed to fetch matches");
          return res.json();
        },
      });

      setCurrentLoadingStep(5);
      await Promise.all([
        queryClient.prefetchQuery({
          queryKey: ["leaderboards", "global"],
          queryFn: async () => {
            const res = await authenticatedFetch(
              "/api/leaderboards?type=global",
            );
            if (!res.ok) throw new Error("Failed to fetch global leaderboard");
            return res.json();
          },
        }),
        queryClient.prefetchQuery({
          queryKey: ["leaderboards", "local"],
          queryFn: async () => {
            const res = await authenticatedFetch(
              "/api/leaderboards?type=local",
            );
            if (!res.ok) throw new Error("Failed to fetch local leaderboard");
            return res.json();
          },
        }),
      ]);
    } catch (error) {
      console.error("[Index] Error pre-fetching data:", error);
    } finally {
      setPrefetchingData(false);
    }
  };

  // Loading states
  if (
    !isReady ||
    (auth && checkingOnboarding) ||
    (auth && onboardingCompleted === null)
  ) {
    return (
      <View
        style={{
          flex: 1,
          backgroundColor: "#010308",
          justifyContent: "center",
          alignItems: "center",
        }}
      >
        <ActivityIndicator color="#4BB8FA" size="large" />
      </View>
    );
  }

  // Wait for IAP to be ready before deciding where to send the user
  if (auth && onboardingCompleted === true && !iapReady) {
    return (
      <View
        style={{
          flex: 1,
          backgroundColor: "#010308",
          justifyContent: "center",
          alignItems: "center",
        }}
      >
        <ActivityIndicator color="#4BB8FA" size="large" />
      </View>
    );
  }

  if (auth && onboardingCompleted === true && prefetchingData) {
    return (
      <LoadingScreen
        message="Loading your data..."
        steps={loadingSteps}
        currentStep={currentLoadingStep}
      />
    );
  }

  if (!auth) return <Redirect href="/welcome" />;
  if (onboardingCompleted === false)
    return <Redirect href="/user-onboarding" />;

  // Onboarding done — enforce subscription gate
  if (!isSubscribed) return <Redirect href="/paywall" />;

  return <Redirect href="/(tabs)" />;
}
