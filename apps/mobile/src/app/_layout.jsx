import { useAuth } from "@/utils/auth/useAuth";
import { useInAppPurchase } from "@/utils/iap";
import { Stack } from "expo-router";
import { StatusBar } from "expo-status-bar";
import * as SplashScreen from "expo-splash-screen";
import { useEffect, useState } from "react";
import { GestureHandlerRootView } from "react-native-gesture-handler";
import { QueryClientProvider } from "@tanstack/react-query";
import queryClient from "@/utils/queryClient";

// Prevent the native splash screen from auto-hiding
SplashScreen.preventAutoHideAsync();

export default function RootLayout() {
  const { initiate, isReady, auth } = useAuth();
  const { initiate: initiateIAP } = useInAppPurchase();

  useEffect(() => {
    initiate();
  }, [initiate]);

  // Onboarding images ship inside the binary, so there is nothing to download
  // before the first screen — the splash only waits on auth now.
  useEffect(() => {
    if (isReady) {
      SplashScreen.hideAsync();
    }
  }, [isReady]);

  if (!isReady) {
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
