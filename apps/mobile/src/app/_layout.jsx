import { useAuth } from "@/utils/auth/useAuth";
import { useInAppPurchase } from "@/utils/iap";
import { Stack } from "expo-router";
import { StatusBar } from "expo-status-bar";
import * as SplashScreen from "expo-splash-screen";
import { useEffect, useState } from "react";
import { GestureHandlerRootView } from "react-native-gesture-handler";
import { QueryClientProvider } from "@tanstack/react-query";
import queryClient from "@/utils/queryClient";
import { Image } from "expo-image";
import { ALL_ONBOARDING_URLS } from "@/constants/onboardingImages";

// Prevent the native splash screen from auto-hiding
SplashScreen.preventAutoHideAsync();

export default function RootLayout() {
  const { initiate, isReady, auth } = useAuth();
  const { initiate: initiateIAP } = useInAppPurchase();
  const [imagesReady, setImagesReady] = useState(false);

  useEffect(() => {
    initiate();
  }, [initiate]);

  // Prefetch every onboarding image into expo-image's disk cache
  // in parallel with auth — so both finish as fast as possible.
  useEffect(() => {
    let cancelled = false;
    async function prefetchAll() {
      try {
        await Promise.all(
          ALL_ONBOARDING_URLS.map((url) =>
            Image.prefetch(url, { cachePolicy: "disk" }).catch(() => {
              // Never let a single failed image block the whole app
            }),
          ),
        );
      } catch (e) {
        // Fallback: if anything unexpected throws, still proceed
        console.warn("[Prefetch] Onboarding images prefetch failed:", e);
      } finally {
        if (!cancelled) setImagesReady(true);
      }
    }
    prefetchAll();
    return () => {
      cancelled = true;
    };
  }, []);

  // Hide splash ONLY when auth AND every image are both ready
  useEffect(() => {
    if (isReady && imagesReady) {
      SplashScreen.hideAsync();
    }
  }, [isReady, imagesReady]);

  if (!isReady || !imagesReady) {
    return null; // Splash screen stays visible
  }

  return (
    <QueryClientProvider client={queryClient}>
      <GestureHandlerRootView style={{ flex: 1 }}>
        <StatusBar style="light" />
        <Stack
          screenOptions={{
            headerShown: false,
            contentStyle: { backgroundColor: "#010308" },
          }}
        >
          {/* Screens */}
        </Stack>
      </GestureHandlerRootView>
    </QueryClientProvider>
  );
}
