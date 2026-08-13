import React, { useState } from "react";
import {
  View,
  Text,
  TouchableOpacity,
  ActivityIndicator,
  Alert,
} from "react-native";
import { Image } from "expo-image";
import { useRouter } from "expo-router";
import { StatusBar } from "expo-status-bar";
import { useSafeAreaInsets } from "react-native-safe-area-context";

import { ONBOARDING_IMAGES } from "@/constants/onboardingImages";
import { useAuthStore } from "@/utils/auth/store";
import { IS_TEST_MODE, signInAsTester } from "@/utils/testMode";

const LOGO = ONBOARDING_IMAGES.logo;

export default function Welcome() {
  const router = useRouter();
  const insets = useSafeAreaInsets();
  const { setAuth } = useAuthStore();
  const [testLoading, setTestLoading] = useState(false);

  const handleTestSkip = async () => {
    setTestLoading(true);
    try {
      const auth = await signInAsTester();
      setAuth(auth);
      router.replace("/");
    } catch (error) {
      Alert.alert("Test sign-in failed", error.message);
    } finally {
      setTestLoading(false);
    }
  };

  return (
    <View
      style={{
        flex: 1,
        backgroundColor: "#010308",
        justifyContent: "space-between",
        paddingTop: insets.top,
        paddingBottom: insets.bottom,
      }}
    >
      <StatusBar style="light" />

      {/* Logo and branding section - centered vertically */}
      <View
        style={{
          flex: 1,
          justifyContent: "center",
          alignItems: "center",
          paddingHorizontal: 40,
        }}
      >
        {/* App Logo */}
        <Image
          source={LOGO}
          style={{ width: 160, height: 160, marginBottom: 28 }}
          contentFit="contain"
        />

        {/* App Name */}
        <Text
          style={{
            fontSize: 48,
            fontWeight: "900",
            color: "#FFFFFF",
            letterSpacing: 2,
            marginBottom: 12,
            textAlign: "center",
          }}
        >
          OUTREPD
        </Text>

        {/* Slogan */}
        <Text
          style={{
            fontSize: 18,
            fontWeight: "600",
            color: "#4BB8FA",
            letterSpacing: 0.5,
            textAlign: "center",
          }}
        >
          {"Don't get outrepd!"}
        </Text>
      </View>

      {/* Buttons at the bottom */}
      <View style={{ paddingHorizontal: 24, paddingBottom: 20, gap: 16 }}>
        <TouchableOpacity
          style={{
            backgroundColor: "#4BB8FA",
            paddingVertical: 18,
            borderRadius: 16,
            alignItems: "center",
            shadowColor: "#4BB8FA",
            shadowOffset: { width: 0, height: 4 },
            shadowOpacity: 0.3,
            shadowRadius: 8,
            elevation: 5,
          }}
          onPress={() => router.push("/onboarding")}
          activeOpacity={0.8}
        >
          <Text
            style={{
              color: "#FFFFFF",
              fontSize: 18,
              fontWeight: "700",
              letterSpacing: 0.5,
            }}
          >
            Get Started
          </Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={{
            backgroundColor: "transparent",
            paddingVertical: 18,
            borderRadius: 16,
            alignItems: "center",
            borderWidth: 2,
            borderColor: "rgba(255, 255, 255, 0.2)",
          }}
          onPress={() => router.push("/onboarding?page=3&mode=signin")}
          activeOpacity={0.8}
        >
          <Text
            style={{
              color: "#FFFFFF",
              fontSize: 16,
              fontWeight: "600",
              letterSpacing: 0.5,
            }}
          >
            I have an account
          </Text>
        </TouchableOpacity>

        {IS_TEST_MODE && (
          <TouchableOpacity
            style={{
              backgroundColor: "rgba(75, 184, 250, 0.12)",
              paddingVertical: 16,
              borderRadius: 16,
              alignItems: "center",
              borderWidth: 1,
              borderStyle: "dashed",
              borderColor: "#4BB8FA",
              opacity: testLoading ? 0.6 : 1,
            }}
            onPress={handleTestSkip}
            disabled={testLoading}
            activeOpacity={0.8}
          >
            {testLoading ? (
              <ActivityIndicator color="#4BB8FA" />
            ) : (
              <Text
                style={{
                  color: "#4BB8FA",
                  fontSize: 15,
                  fontWeight: "700",
                  letterSpacing: 0.5,
                }}
              >
                ⚡ Skip — enter as tester
              </Text>
            )}
          </TouchableOpacity>
        )}
      </View>
    </View>
  );
}