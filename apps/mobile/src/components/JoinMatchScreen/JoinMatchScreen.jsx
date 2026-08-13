import React, { useState } from "react";
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  ActivityIndicator,
  KeyboardAvoidingView,
  Platform,
  Keyboard,
} from "react-native";
import { Swords } from "lucide-react-native";
import { authenticatedFetch } from "@/utils/authenticatedFetch";

const TIER_NAMES = [
  "Iron",
  "Bronze",
  "Silver",
  "Gold",
  "Platinum",
  "Emerald",
  "Diamond",
  "Master",
  "Legend",
];
const DIV_NAMES = ["IV", "III", "II", "I"];

export const JoinMatchScreen = ({
  insets,
  currentTier,
  playerState,
  onJoin,
  onCancel,
}) => {
  const [code, setCode] = useState("");
  const [matchPreview, setMatchPreview] = useState(null);
  const [looking, setLooking] = useState(false);
  const [joining, setJoining] = useState(false);
  const [error, setError] = useState(null);

  const formattedCode = code.toUpperCase().replace(/[^A-Z0-9]/g, "");

  const handleLookup = async () => {
    const clean = formattedCode.replace(/-/g, "");
    if (clean.length < 8) {
      setError("Please enter the full 8-character code.");
      return;
    }
    const withDash = clean.slice(0, 4) + "-" + clean.slice(4);
    setLooking(true);
    setError(null);
    setMatchPreview(null);
    try {
      const res = await authenticatedFetch(`/api/matches/invite/${withDash}`);
      const data = await res.json();
      if (!res.ok) {
        setError(data.error || "Code not found.");
        return;
      }
      if (data.match.status !== "waiting") {
        setError("This match has already started or expired.");
        return;
      }
      Keyboard.dismiss();
      setMatchPreview({ ...data.match, invite_code: withDash });
    } catch {
      setError("Could not look up that code.");
    } finally {
      setLooking(false);
    }
  };

  const handleJoin = async () => {
    if (!matchPreview) return;
    setJoining(true);
    setError(null);
    try {
      const res = await authenticatedFetch(
        `/api/matches/invite/${matchPreview.invite_code}`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            tier_idx: playerState.tierIdx,
            div_idx: playerState.divIdx,
            lp: playerState.lp,
            demotion_shield: playerState.demotionShield,
          }),
        },
      );
      const data = await res.json();
      if (!res.ok) {
        setError(data.error || "Could not join match.");
        return;
      }
      // Join succeeded — pass match data up
      onJoin({
        inviteCode: matchPreview.invite_code,
        muscleGroup: matchPreview.muscle_group,
        opponentName:
          matchPreview.host_username || matchPreview.host_name || "Opponent",
        opponentTierIdx: matchPreview.host_tier_idx,
        opponentDivIdx: matchPreview.host_div_idx,
        opponentPhotoUrl: matchPreview.host_profile_photo_url,
        role: "guest",
      });
    } catch {
      setError("Failed to join match. Please try again.");
    } finally {
      setJoining(false);
    }
  };

  return (
    <KeyboardAvoidingView
      style={{ flex: 1, backgroundColor: "#010308" }}
      behavior={Platform.OS === "ios" ? "padding" : undefined}
    >
      <View
        style={{
          flex: 1,
          paddingTop: insets.top + 24,
          paddingHorizontal: 24,
          paddingBottom: insets.bottom + 24,
        }}
      >
        {/* Header */}
        <View style={{ alignItems: "center", marginBottom: 40 }}>
          <Swords
            color={currentTier.color}
            size={48}
            style={{ marginBottom: 12 }}
          />
          <Text style={{ color: "#FFF", fontSize: 22, fontWeight: "900" }}>
            JOIN A MATCH
          </Text>
          <Text
            style={{
              color: "#555",
              fontSize: 14,
              marginTop: 6,
              textAlign: "center",
            }}
          >
            Enter the invite code from your friend
          </Text>
        </View>

        {/* Code Input */}
        <View
          style={{
            backgroundColor: "#0D1218",
            borderRadius: 20,
            padding: 24,
            borderWidth: 1,
            borderColor: "#1A2630",
            marginBottom: 16,
          }}
        >
          <Text
            style={{
              color: "#555",
              fontSize: 11,
              fontWeight: "800",
              letterSpacing: 2,
              marginBottom: 12,
            }}
          >
            INVITE CODE
          </Text>
          <TextInput
            value={formattedCode}
            onChangeText={(t) => {
              setCode(
                t
                  .toUpperCase()
                  .replace(/[^A-Z0-9]/g, "")
                  .slice(0, 8),
              );
              setMatchPreview(null);
              setError(null);
            }}
            placeholder="ABCD1234"
            placeholderTextColor="#2A3540"
            autoCapitalize="characters"
            autoCorrect={false}
            maxLength={8}
            style={{
              color: "#4BB8FA",
              fontSize: 32,
              fontWeight: "900",
              letterSpacing: 6,
              borderBottomWidth: 2,
              borderBottomColor:
                formattedCode.length === 8 ? "#4BB8FA" : "#1A2630",
              paddingBottom: 8,
              marginBottom: 16,
              textAlign: "center",
            }}
          />
          <TouchableOpacity
            onPress={handleLookup}
            disabled={looking || formattedCode.length < 8}
            style={{
              backgroundColor:
                formattedCode.length === 8 ? currentTier.color : "#111D26",
              height: 48,
              borderRadius: 12,
              justifyContent: "center",
              alignItems: "center",
            }}
          >
            {looking ? (
              <ActivityIndicator color="#FFF" />
            ) : (
              <Text style={{ color: "#FFF", fontWeight: "900", fontSize: 14 }}>
                FIND MATCH
              </Text>
            )}
          </TouchableOpacity>
        </View>

        {error && (
          <View
            style={{
              backgroundColor: "#1A0808",
              borderRadius: 12,
              padding: 14,
              marginBottom: 16,
              borderWidth: 1,
              borderColor: "#330000",
            }}
          >
            <Text
              style={{
                color: "#FF4444",
                fontWeight: "700",
                textAlign: "center",
              }}
            >
              {error}
            </Text>
          </View>
        )}

        {/* Match Preview */}
        {matchPreview && (
          <View
            style={{
              backgroundColor: "#0A1008",
              borderRadius: 20,
              padding: 24,
              borderWidth: 1,
              borderColor: "#0E200E",
              marginBottom: 20,
              alignItems: "center",
            }}
          >
            <Text
              style={{
                color: "#00C853",
                fontSize: 11,
                fontWeight: "800",
                letterSpacing: 2,
                marginBottom: 12,
              }}
            >
              MATCH FOUND!
            </Text>
            <Text style={{ color: "#FFF", fontSize: 22, fontWeight: "900" }}>
              {matchPreview.host_username ||
                matchPreview.host_name ||
                "Unknown Player"}
            </Text>
            <Text
              style={{
                color: "#888",
                fontSize: 14,
                marginTop: 4,
                marginBottom: 16,
              }}
            >
              {TIER_NAMES[matchPreview.host_tier_idx] ?? "Iron"}{" "}
              {DIV_NAMES[matchPreview.host_div_idx] ?? "IV"}
            </Text>
            <View
              style={{
                backgroundColor: "#060E06",
                borderRadius: 10,
                padding: 12,
                width: "100%",
                alignItems: "center",
                marginBottom: 20,
              }}
            >
              <Text style={{ color: "#FFF", fontSize: 18, fontWeight: "900" }}>
                💪 {matchPreview.muscle_group?.toUpperCase()}
              </Text>
            </View>
            <TouchableOpacity
              onPress={handleJoin}
              disabled={joining}
              style={{
                backgroundColor: "#4BB8FA",
                height: 56,
                borderRadius: 16,
                justifyContent: "center",
                alignItems: "center",
                width: "100%",
                shadowColor: "#4BB8FA",
                shadowOffset: { width: 0, height: 4 },
                shadowOpacity: 0.45,
                shadowRadius: 12,
              }}
            >
              {joining ? (
                <ActivityIndicator color="#000" />
              ) : (
                <Text
                  style={{ color: "#000", fontWeight: "900", fontSize: 15 }}
                >
                  ⚔️ JOIN BATTLE
                </Text>
              )}
            </TouchableOpacity>
          </View>
        )}

        <View style={{ flex: 1 }} />

        <TouchableOpacity onPress={onCancel} style={{ alignItems: "center" }}>
          <Text style={{ color: "#555", fontWeight: "bold", fontSize: 14 }}>
            CANCEL
          </Text>
        </TouchableOpacity>
      </View>
    </KeyboardAvoidingView>
  );
};
