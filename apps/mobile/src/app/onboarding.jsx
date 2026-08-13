import React, { useState, useRef } from "react";
import {
  View,
  Text,
  TouchableOpacity,
  Animated,
  TextInput,
  KeyboardAvoidingView,
  Platform,
  ActivityIndicator,
  ScrollView,
} from "react-native";
import { Image } from "expo-image";
import { useRouter, useLocalSearchParams } from "expo-router";
import { StatusBar } from "expo-status-bar";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { ChevronRight, Mail, ArrowLeft } from "lucide-react-native";
import { useAuthStore } from "@/utils/auth/store";
import { getApiUrl } from "@/utils/getApiUrl";
import { ONBOARDING_IMAGES } from "@/constants/onboardingImages";

const LOGO_URL = ONBOARDING_IMAGES.logo;

const TIER_LIST = [
  { name: "Bronze", img: ONBOARDING_IMAGES.bronze },
  { name: "Silver", img: ONBOARDING_IMAGES.silver },
  { name: "Gold", img: ONBOARDING_IMAGES.gold },
  { name: "Master", img: ONBOARDING_IMAGES.master },
  { name: "Legend", img: ONBOARDING_IMAGES.legend },
];

// Pages 0-2 are info slides, page 3 is auth
const TOTAL_INFO_PAGES = 3;

export default function Onboarding() {
  const router = useRouter();
  const insets = useSafeAreaInsets();
  const { setAuth } = useAuthStore();
  const params = useLocalSearchParams();

  const [currentPage, setCurrentPage] = useState(
    params.page ? parseInt(params.page, 10) : 0
  );
  const fadeAnim = useRef(new Animated.Value(1)).current;

  // Magic link state
  const [email, setEmail] = useState("");
  const [code, setCode] = useState("");
  const [codeSent, setCodeSent] = useState(false);
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(false);

  const isAuthPage = currentPage === TOTAL_INFO_PAGES;

  const goToPage = (page) => {
    Animated.timing(fadeAnim, {
      toValue: 0,
      duration: 180,
      useNativeDriver: true,
    }).start(() => {
      setCurrentPage(page);
      Animated.timing(fadeAnim, {
        toValue: 1,
        duration: 180,
        useNativeDriver: true,
      }).start();
    });
  };

  const handleNext = () => {
    goToPage(currentPage + 1);
  };

  const handleSkip = () => {
    goToPage(TOTAL_INFO_PAGES);
  };

  // Step 1: send the magic code to the email
  const handleSendCode = async () => {
    setError(null);
    if (!email.trim()) {
      setError("Please enter your email");
      return;
    }
    setLoading(true);
    try {
      const url = getApiUrl("/api/auth/magic/request");
      const res = await fetch(url, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email: email.trim() }),
      });
      const data = await res.json();
      if (!res.ok || data.error) {
        setError(data.error || "Failed to send code. Please try again.");
        setLoading(false);
        return;
      }
      setCodeSent(true);
    } catch (err) {
      setError("Connection failed. Please check your internet connection.");
    }
    setLoading(false);
  };

  // Step 2: verify the code
  const handleVerifyCode = async () => {
    setError(null);
    if (!code.trim() || code.length !== 6) {
      setError("Please enter the 6-digit code");
      return;
    }
    setLoading(true);
    try {
      const url = getApiUrl("/api/auth/magic/verify");
      const res = await fetch(url, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email: email.trim(), code: code.trim() }),
      });
      const data = await res.json();
      if (!res.ok || data.error) {
        setError(data.error || "Invalid code. Please try again.");
        setLoading(false);
        return;
      }
      setAuth({ jwt: data.jwt, user: data.user });
      router.replace(data.onboardingCompleted ? "/" : "/user-onboarding");
    } catch (err) {
      setError("Connection failed. Please check your internet connection.");
      setLoading(false);
    }
  };

  const handleResend = () => {
    setCodeSent(false);
    setCode("");
    setError(null);
  };

  const bottomButtonLabel = isAuthPage
    ? codeSent
      ? "VERIFY CODE"
      : "SEND CODE"
    : "Next";

  const handleBottomButton = isAuthPage
    ? codeSent
      ? handleVerifyCode
      : handleSendCode
    : handleNext;

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === "ios" ? "padding" : "height"}
      style={{ flex: 1 }}
    >
      <View
        style={{
          flex: 1,
          backgroundColor: "#010308",
          paddingTop: insets.top,
          paddingBottom: insets.bottom,
        }}
      >
        <StatusBar style="light" />

        {/* Skip button — only on info pages */}
        {!isAuthPage && (
          <TouchableOpacity
            style={{
              position: "absolute",
              top: insets.top + 16,
              right: 24,
              zIndex: 10,
              paddingVertical: 8,
              paddingHorizontal: 16,
            }}
            onPress={handleSkip}
            activeOpacity={0.7}
          >
            <Text style={{ color: "#666", fontSize: 16, fontWeight: "600" }}>
              Skip
            </Text>
          </TouchableOpacity>
        )}

        {/* Page content */}
        <Animated.View
          style={{
            flex: 1,
            opacity: fadeAnim,
            alignItems: "center",
            justifyContent: "flex-start",
            paddingHorizontal: 28,
            paddingTop: isAuthPage ? 20 : 70,
          }}
        >
          {/* PAGE 1: Turn Your Workout Into a Battle */}
          {currentPage === 0 && (
            <View style={{ alignItems: "center", width: "100%" }}>
              <Text
                style={{
                  fontSize: 26,
                  fontWeight: "900",
                  color: "#FFFFFF",
                  textAlign: "center",
                  marginBottom: 14,
                  letterSpacing: 0.5,
                }}
              >
                Turn Your Workout Into a Battle
              </Text>
              <Text
                style={{
                  fontSize: 15,
                  color: "#888",
                  textAlign: "center",
                  lineHeight: 22,
                  marginBottom: 28,
                }}
              >
                Every set counts. Log your reps in real-time and compete for the
                highest volume to win LP and climb the ranks.
              </Text>
              <Image
                source={ONBOARDING_IMAGES.workoutBattle}
                style={{ width: "100%", height: 380 }}
                contentFit="contain"
                cachePolicy="disk"
              />
            </View>
          )}

          {/* PAGE 2: Climb the Ranks */}
          {currentPage === 1 && (
            <View style={{ alignItems: "center", width: "100%" }}>
              <Text
                style={{
                  fontSize: 26,
                  fontWeight: "900",
                  color: "#FFFFFF",
                  textAlign: "center",
                  marginBottom: 14,
                  letterSpacing: 0.5,
                }}
              >
                Reach Your Fitness Goals by Climbing the Ranks
              </Text>
              <View
                style={{
                  width: "100%",
                  height: 480,
                  position: "relative",
                  marginTop: 8,
                }}
              >
                <Image
                  source={TIER_LIST[0].img}
                  style={{
                    position: "absolute",
                    width: 150,
                    height: 150,
                    top: 0,
                    left: 12,
                  }}
                  contentFit="contain"
                  cachePolicy="disk"
                />
                <Image
                  source={TIER_LIST[3].img}
                  style={{
                    position: "absolute",
                    width: 150,
                    height: 150,
                    top: 0,
                    right: 12,
                  }}
                  contentFit="contain"
                  cachePolicy="disk"
                />
                <Image
                  source={TIER_LIST[4].img}
                  style={{
                    position: "absolute",
                    width: 220,
                    height: 220,
                    top: 135,
                    left: "50%",
                    marginLeft: -110,
                  }}
                  contentFit="contain"
                  cachePolicy="disk"
                />
                <Image
                  source={TIER_LIST[2].img}
                  style={{
                    position: "absolute",
                    width: 150,
                    height: 150,
                    top: 320,
                    left: 12,
                  }}
                  contentFit="contain"
                  cachePolicy="disk"
                />
                <Image
                  source={TIER_LIST[1].img}
                  style={{
                    position: "absolute",
                    width: 150,
                    height: 150,
                    top: 320,
                    right: 12,
                  }}
                  contentFit="contain"
                  cachePolicy="disk"
                />
              </View>
            </View>
          )}

          {/* PAGE 3: Challenge Friends */}
          {currentPage === 2 && (
            <View style={{ alignItems: "center", width: "100%" }}>
              <View style={{ height: 160, width: "100%" }}>
                <Text
                  style={{
                    fontSize: 26,
                    fontWeight: "900",
                    color: "#FFFFFF",
                    textAlign: "center",
                    marginBottom: 14,
                    letterSpacing: 0.5,
                  }}
                >
                  Challenge Friends
                </Text>
                <Text
                  style={{
                    fontSize: 15,
                    color: "#888",
                    textAlign: "center",
                    lineHeight: 22,
                    marginBottom: 28,
                  }}
                >
                  Send match invites, track your head-to-head record, and see
                  who dominates the leaderboards.
                </Text>
              </View>
              <Image
                source={ONBOARDING_IMAGES.challengeFriends}
                style={{ width: "100%", height: 380 }}
                contentFit="contain"
                cachePolicy="disk"
              />
            </View>
          )}

          {/* PAGE 4: Magic Link Auth */}
          {currentPage === 3 && (
            <ScrollView
              style={{ width: "100%" }}
              contentContainerStyle={{
                alignItems: "center",
                paddingBottom: 20,
              }}
              keyboardShouldPersistTaps="handled"
              showsVerticalScrollIndicator={false}
            >
              {/* Logo */}
              <View style={{ alignItems: "center", marginBottom: 32 }}>
                <Image
                  source={LOGO_URL}
                  style={{ width: 72, height: 72, marginBottom: 10 }}
                  contentFit="contain"
                  cachePolicy="disk"
                />
                <Text
                  style={{
                    color: "#FFF",
                    fontSize: 28,
                    fontWeight: "900",
                    letterSpacing: 1,
                    marginBottom: 4,
                  }}
                >
                  OUTREPD
                </Text>
                <Text style={{ color: "#444", fontSize: 13 }}>
                  Competitive Gym Battles
                </Text>
              </View>

              {/* Error */}
              {error && (
                <View
                  style={{
                    backgroundColor: "#1A0808",
                    borderWidth: 1,
                    borderColor: "#FF4444",
                    borderRadius: 10,
                    padding: 12,
                    marginBottom: 16,
                    width: "100%",
                  }}
                >
                  <Text
                    style={{
                      color: "#FF4444",
                      fontSize: 13,
                      textAlign: "center",
                    }}
                  >
                    {error}
                  </Text>
                </View>
              )}

              {/* Step 1: Email input */}
              {!codeSent && (
                <View style={{ width: "100%" }}>
                  <Text
                    style={{
                      color: "#888",
                      fontSize: 14,
                      textAlign: "center",
                      lineHeight: 20,
                      marginBottom: 24,
                    }}
                  >
                    Enter your email and we'll send you a 6-digit login code. No
                    password needed.
                  </Text>
                  <Text
                    style={{
                      color: "#555",
                      fontSize: 11,
                      fontWeight: "700",
                      letterSpacing: 1,
                      marginBottom: 8,
                    }}
                  >
                    EMAIL
                  </Text>
                  <TextInput
                    value={email}
                    onChangeText={setEmail}
                    placeholder="your@email.com"
                    placeholderTextColor="#444"
                    keyboardType="email-address"
                    autoCapitalize="none"
                    autoComplete="email"
                    autoFocus={false}
                    style={{
                      backgroundColor: "#070D14",
                      borderWidth: 1,
                      borderColor: "#1A2630",
                      borderRadius: 12,
                      padding: 14,
                      color: "#FFF",
                      fontSize: 15,
                    }}
                  />
                </View>
              )}

              {/* Step 2: Code input */}
              {codeSent && (
                <View style={{ width: "100%", alignItems: "center" }}>
                  {/* Email icon + message */}
                  <View
                    style={{
                      width: 64,
                      height: 64,
                      borderRadius: 32,
                      backgroundColor: "#0D1218",
                      borderWidth: 1,
                      borderColor: "#1A2630",
                      alignItems: "center",
                      justifyContent: "center",
                      marginBottom: 16,
                    }}
                  >
                    <Mail size={28} color="#4BB8FA" />
                  </View>
                  <Text
                    style={{
                      color: "#FFF",
                      fontSize: 18,
                      fontWeight: "700",
                      marginBottom: 8,
                      textAlign: "center",
                    }}
                  >
                    Check your email
                  </Text>
                  <Text
                    style={{
                      color: "#888",
                      fontSize: 13,
                      textAlign: "center",
                      lineHeight: 20,
                      marginBottom: 28,
                    }}
                  >
                    We sent a 6-digit code to{"\n"}
                    <Text style={{ color: "#4BB8FA", fontWeight: "600" }}>
                      {email}
                    </Text>
                  </Text>

                  <Text
                    style={{
                      color: "#555",
                      fontSize: 11,
                      fontWeight: "700",
                      letterSpacing: 1,
                      marginBottom: 8,
                      alignSelf: "flex-start",
                    }}
                  >
                    6-DIGIT CODE
                  </Text>
                  <TextInput
                    value={code}
                    onChangeText={(t) =>
                      setCode(t.replace(/[^0-9]/g, "").slice(0, 6))
                    }
                    placeholder="000000"
                    placeholderTextColor="#333"
                    keyboardType="number-pad"
                    maxLength={6}
                    autoFocus
                    style={{
                      backgroundColor: "#070D14",
                      borderWidth: 1,
                      borderColor: "#1A2630",
                      borderRadius: 12,
                      padding: 14,
                      color: "#FFF",
                      fontSize: 28,
                      fontWeight: "900",
                      letterSpacing: 10,
                      textAlign: "center",
                      width: "100%",
                    }}
                  />

                  {/* Resend / change email */}
                  <TouchableOpacity
                    onPress={handleResend}
                    style={{
                      marginTop: 20,
                      flexDirection: "row",
                      alignItems: "center",
                      gap: 6,
                    }}
                    activeOpacity={0.7}
                  >
                    <ArrowLeft size={14} color="#555" />
                    <Text style={{ color: "#555", fontSize: 13 }}>
                      Use a different email or resend code
                    </Text>
                  </TouchableOpacity>
                </View>
              )}
            </ScrollView>
          )}
        </Animated.View>

        {/* Progress dots — show on all 4 pages */}
        <View
          style={{
            flexDirection: "row",
            justifyContent: "center",
            gap: 8,
            marginBottom: 24,
          }}
        >
          {[0, 1, 2, 3].map((index) => (
            <View
              key={index}
              style={{
                width: currentPage === index ? 24 : 8,
                height: 8,
                borderRadius: 4,
                backgroundColor:
                  currentPage === index ? "#4BB8FA" : "rgba(255,255,255,0.2)",
              }}
            />
          ))}
        </View>

        {/* Bottom button — Next on info pages, Send Code / Verify on auth page */}
        <TouchableOpacity
          style={{
            flexDirection: "row",
            alignItems: "center",
            justifyContent: "center",
            backgroundColor: "#4BB8FA",
            marginHorizontal: 24,
            paddingVertical: 18,
            borderRadius: 16,
            marginBottom: 20,
            opacity: loading ? 0.7 : 1,
            shadowColor: "#4BB8FA",
            shadowOffset: { width: 0, height: 4 },
            shadowOpacity: 0.3,
            shadowRadius: 8,
            elevation: 5,
            gap: 8,
          }}
          onPress={handleBottomButton}
          disabled={loading}
          activeOpacity={0.8}
        >
          {loading ? (
            <ActivityIndicator color="#000" />
          ) : (
            <>
              <Text
                style={{
                  color: isAuthPage ? "#000" : "#FFFFFF",
                  fontSize: 18,
                  fontWeight: "700",
                  letterSpacing: 0.5,
                }}
              >
                {bottomButtonLabel}
              </Text>
              {!isAuthPage && (
                <ChevronRight size={20} color="#FFFFFF" strokeWidth={3} />
              )}
            </>
          )}
        </TouchableOpacity>
      </View>
    </KeyboardAvoidingView>
  );
}