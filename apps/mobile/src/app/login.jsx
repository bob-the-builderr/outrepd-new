import { useState } from "react";
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  ActivityIndicator,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
} from "react-native";
import { Image } from "expo-image";
import { router } from "expo-router";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { StatusBar } from "expo-status-bar";
import { Mail, ArrowLeft } from "lucide-react-native";
import { useAuthStore } from "@/utils/auth/store";
import { getApiUrl } from "@/utils/getApiUrl";

export default function LoginScreen() {
  const insets = useSafeAreaInsets();
  const { setAuth } = useAuthStore();

  const [email, setEmail] = useState("");
  const [code, setCode] = useState("");
  const [codeSent, setCodeSent] = useState(false);
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(false);

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

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === "ios" ? "padding" : "height"}
      style={{ flex: 1, backgroundColor: "#010308" }}
    >
      <StatusBar style="light" />
      <ScrollView
        contentContainerStyle={{
          flexGrow: 1,
          paddingTop: insets.top + 40,
          paddingBottom: insets.bottom + 24,
          paddingHorizontal: 24,
        }}
        keyboardShouldPersistTaps="handled"
      >
        {/* Logo */}
        <View style={{ alignItems: "center", marginBottom: 40 }}>
          <Image
            source={{
              uri: "https://dtvoeevhaseb5.cloudfront.net/user-uploads/10341004-1568-4639-9f40-8061c2cb7d4a.png",
            }}
            style={{ width: 72, height: 72, marginBottom: 8 }}
            contentFit="contain"
          />
          <Text
            style={{
              color: "#FFF",
              fontSize: 28,
              fontWeight: "900",
              marginBottom: 4,
              letterSpacing: 1,
            }}
          >
            OUTREPD
          </Text>
          <Text style={{ color: "#444", fontSize: 13 }}>
            Competitive Gym Battles
          </Text>
        </View>

        {/* Form Card */}
        <View
          style={{
            backgroundColor: "#0D1218",
            borderWidth: 1,
            borderColor: "#1A2630",
            borderRadius: 24,
            padding: 32,
          }}
        >
          <Text
            style={{
              color: "#FFF",
              fontSize: 20,
              fontWeight: "900",
              marginBottom: 8,
              textAlign: "center",
            }}
          >
            SIGN IN
          </Text>
          <Text
            style={{
              color: "#444",
              fontSize: 12,
              textAlign: "center",
              marginBottom: 24,
            }}
          >
            {codeSent ? "Enter the code we sent you" : "No password needed"}
          </Text>

          {error && (
            <View
              style={{
                backgroundColor: "#1A0808",
                borderWidth: 1,
                borderColor: "#FF4444",
                borderRadius: 10,
                padding: 12,
                marginBottom: 20,
              }}
            >
              <Text
                style={{ color: "#FF4444", fontSize: 13, textAlign: "center" }}
              >
                {error}
              </Text>
            </View>
          )}

          {/* Step 1: Email input */}
          {!codeSent && (
            <View>
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
                style={{
                  backgroundColor: "#070D14",
                  borderWidth: 1,
                  borderColor: "#1A2630",
                  borderRadius: 12,
                  padding: 14,
                  color: "#FFF",
                  fontSize: 15,
                  marginBottom: 24,
                }}
              />
            </View>
          )}

          {/* Step 2: Code input */}
          {codeSent && (
            <View style={{ alignItems: "center" }}>
              <View
                style={{
                  width: 64,
                  height: 64,
                  borderRadius: 32,
                  backgroundColor: "#070D14",
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
                  color: "#888",
                  fontSize: 13,
                  textAlign: "center",
                  lineHeight: 20,
                  marginBottom: 24,
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
                  marginBottom: 20,
                }}
              />

              <TouchableOpacity
                onPress={handleResend}
                style={{
                  flexDirection: "row",
                  alignItems: "center",
                  gap: 6,
                  marginBottom: 24,
                }}
                activeOpacity={0.7}
              >
                <ArrowLeft size={14} color="#555" />
                <Text style={{ color: "#555", fontSize: 13 }}>
                  Use a different email or resend
                </Text>
              </TouchableOpacity>
            </View>
          )}

          <TouchableOpacity
            onPress={codeSent ? handleVerifyCode : handleSendCode}
            disabled={loading}
            style={{
              backgroundColor: "#4BB8FA",
              borderRadius: 14,
              padding: 16,
              alignItems: "center",
              opacity: loading ? 0.7 : 1,
            }}
          >
            {loading ? (
              <ActivityIndicator color="#000" />
            ) : (
              <Text
                style={{
                  color: "#000",
                  fontWeight: "900",
                  fontSize: 15,
                  letterSpacing: 1,
                }}
              >
                {codeSent ? "VERIFY CODE" : "SEND CODE"}
              </Text>
            )}
          </TouchableOpacity>

          <TouchableOpacity
            onPress={() => router.push("/signup")}
            style={{ marginTop: 20 }}
          >
            <Text style={{ color: "#444", fontSize: 13, textAlign: "center" }}>
              No account?{" "}
              <Text style={{ color: "#4BB8FA", fontWeight: "700" }}>
                Sign up
              </Text>
            </Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}
