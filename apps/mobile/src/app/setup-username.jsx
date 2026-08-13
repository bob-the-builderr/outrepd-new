import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  ActivityIndicator,
  KeyboardAvoidingView,
  Platform,
} from "react-native";
import { useState, useEffect } from "react";
import { useRouter } from "expo-router";
import { StatusBar } from "expo-status-bar";
import { authenticatedFetch } from "@/utils/authenticatedFetch";
import { useAuthStore } from "@/utils/auth/store";
import { useAuth } from "@/utils/auth/useAuth";

export default function SetupUsername() {
  const router = useRouter();
  const { auth, isReady } = useAuth();
  const { setHasUsername } = useAuthStore();
  const [username, setUsername] = useState("");
  const [error, setError] = useState("");
  const [checking, setChecking] = useState(false);
  const [loading, setLoading] = useState(false);

  // Auth guard - redirect to login if no session
  useEffect(() => {
    if (isReady && !auth) {
      router.replace("/login");
    }
  }, [isReady, auth, router]);

  const checkAvailability = async (value) => {
    if (value.length < 3) return;
    console.log("[Setup Username] Checking availability for:", value);
    setChecking(true);
    try {
      const response = await authenticatedFetch(
        `/api/username?check=${encodeURIComponent(value)}`,
      );
      console.log("[Setup Username] Check response status:", response.status);

      const data = await response.json();
      console.log("[Setup Username] Check result:", data);

      if (!data.available) {
        setError("Username already taken");
        console.log("[Setup Username] Username taken");
      } else {
        setError("");
        console.log("[Setup Username] Username available");
      }
    } catch (err) {
      console.error("[Setup Username] Check error:", err);
      console.error("[Setup Username] Error message:", err.message);
    }
    setChecking(false);
  };

  const handleSubmit = async () => {
    console.log("[Setup Username] Submitting username:", username);

    if (!username || username.trim().length < 3) {
      setError("Username must be at least 3 characters");
      return;
    }

    if (!/^[a-zA-Z0-9_]{3,20}$/.test(username.trim())) {
      setError("Only letters, numbers, and underscores allowed");
      return;
    }

    setLoading(true);
    setError("");

    try {
      const response = await authenticatedFetch("/api/username", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ username: username.trim() }),
      });

      console.log("[Setup Username] Submit response status:", response.status);
      const data = await response.json();
      console.log("[Setup Username] Submit result:", data);

      if (!response.ok) {
        setError(data.error || "Failed to set username");
        setLoading(false);
        return;
      }

      // Cache so the index screen never asks again
      setHasUsername(true);

      console.log("[Setup Username] Success! Navigating to main app");
      router.replace("/(tabs)");
    } catch (err) {
      console.error("[Setup Username] Submit error:", err.message);
      setError("Something went wrong. Please try again.");
      setLoading(false);
    }
  };

  const isDisabled = loading || checking || !!error || username.length < 3;

  return (
    <KeyboardAvoidingView
      style={{ flex: 1, backgroundColor: "#010308" }}
      behavior={Platform.OS === "ios" ? "padding" : "height"}
    >
      <StatusBar style="light" />
      <View
        style={{
          flex: 1,
          justifyContent: "center",
          alignItems: "center",
          padding: 24,
        }}
      >
        <View style={{ width: "100%", maxWidth: 400 }}>
          {/* Icon */}
          <Text style={{ fontSize: 64, textAlign: "center", marginBottom: 16 }}>
            ⚔️
          </Text>

          {/* Title */}
          <Text
            style={{
              color: "#FFF",
              fontSize: 28,
              fontWeight: "900",
              textAlign: "center",
              marginBottom: 8,
              letterSpacing: 1,
            }}
          >
            CHOOSE USERNAME
          </Text>
          <Text
            style={{
              color: "#666",
              fontSize: 14,
              textAlign: "center",
              marginBottom: 40,
            }}
          >
            This is how other players will see you
          </Text>

          {/* Username Input */}
          <View style={{ marginBottom: 24 }}>
            <Text
              style={{
                color: "#555",
                fontSize: 11,
                fontWeight: "700",
                letterSpacing: 1,
                marginBottom: 8,
              }}
            >
              USERNAME
            </Text>
            <TextInput
              value={username}
              onChangeText={(value) => {
                setUsername(value);
                setError("");
                if (value.length >= 3) {
                  checkAvailability(value);
                }
              }}
              placeholder="your_username"
              placeholderTextColor="#333"
              autoCapitalize="none"
              autoCorrect={false}
              maxLength={20}
              style={{
                backgroundColor: "#070D14",
                borderWidth: 1,
                borderColor: error ? "#FF4444" : "#1A2630",
                borderRadius: 12,
                padding: 14,
                color: "#FFF",
                fontSize: 15,
              }}
            />
            {checking && (
              <Text style={{ color: "#4BB8FA", fontSize: 12, marginTop: 6 }}>
                Checking availability...
              </Text>
            )}
            {error && (
              <Text style={{ color: "#FF4444", fontSize: 12, marginTop: 6 }}>
                {error}
              </Text>
            )}
            {!error && username.length >= 3 && !checking && (
              <Text style={{ color: "#00CC66", fontSize: 12, marginTop: 6 }}>
                ✓ Available
              </Text>
            )}
          </View>

          {/* Submit Button */}
          <TouchableOpacity
            onPress={handleSubmit}
            disabled={isDisabled}
            style={{
              backgroundColor: isDisabled ? "#1A3A4A" : "#4BB8FA",
              borderRadius: 14,
              padding: 16,
              alignItems: "center",
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
                CONTINUE
              </Text>
            )}
          </TouchableOpacity>

          <Text
            style={{
              color: "#444",
              fontSize: 12,
              textAlign: "center",
              marginTop: 20,
            }}
          >
            3-20 characters • Letters, numbers, underscores
          </Text>
        </View>
      </View>
    </KeyboardAvoidingView>
  );
}
