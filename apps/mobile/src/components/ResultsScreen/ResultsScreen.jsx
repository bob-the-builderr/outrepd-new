import React, { useState } from "react";
import { View, Text, TouchableOpacity } from "react-native";
import { Crown } from "lucide-react-native";
import { useQuery } from "@tanstack/react-query";
import { MatchDetailsModal } from "@/components/Profile/MatchDetailsModal";
import { ProfileFrame } from "@/components/ProfileFrame";
import { TIERS } from "@/constants/tiers";
import { volumeToScore } from "@/utils/scoreSystem";
import { authenticatedFetch } from "@/utils/authenticatedFetch";

export const ResultsScreen = ({
  insets,
  lastLPChange,
  volume,
  opponentVolume,
  opponentName,
  opponentForfeited,
  currentTier,
  currentDivName,
  playerState,
  isLegendI,
  onBackToRoad,
  matchId,
  userPhotoUrl,
  opponentTierIdx,
}) => {
  const [showDetails, setShowDetails] = useState(false);

  // Fetch fresh profile directly so we always show the correct photo URL,
  // even if the parent's cached profileData was just invalidated after the match.
  const { data: freshProfile } = useQuery({
    queryKey: ["profile"],
    queryFn: async () => {
      const res = await authenticatedFetch("/api/profile");
      if (!res.ok) throw new Error("Failed to fetch profile");
      return res.json();
    },
    staleTime: 0,
  });

  // Prefer the freshly fetched photo, fall back to the prop passed from parent
  const resolvedPhotoUrl =
    freshProfile?.profile?.profile_photo_url || userPhotoUrl || null;

  const won = lastLPChange !== null && lastLPChange > 0;
  const displayOpponentName = (opponentName || "OPPONENT")
    .slice(0, 12)
    .toUpperCase();

  // Convert volumes to scores for display — hides the raw formula from users
  const userScore = volumeToScore(volume || 0);
  const opponentScore =
    opponentVolume !== undefined && opponentVolume !== null
      ? volumeToScore(opponentVolume)
      : null;
  const displayOpponentScore =
    opponentScore !== null ? opponentScore.toLocaleString() : "???";

  const userTierIdx = TIERS.indexOf(currentTier);

  return (
    <View
      style={{ flex: 1, backgroundColor: "#0A0A0A", paddingHorizontal: 20 }}
    >
      <View style={{ paddingTop: insets.top + 40, alignItems: "center" }}>
        <Text
          style={{
            color: "#555",
            fontWeight: "900",
            fontSize: 14,
            letterSpacing: 4,
          }}
        >
          ⚔️ MATCH RESULT
        </Text>
        <Text
          style={{
            color: won ? "#00C853" : "#FF4444",
            fontWeight: "900",
            fontSize: 48,
            marginTop: 8,
          }}
        >
          {won ? "YOU WIN!" : "DEFEATED"}
        </Text>
      </View>

      <View
        style={{
          flexDirection: "row",
          justifyContent: "space-between",
          marginTop: 40,
          alignItems: "center",
        }}
      >
        {/* USER side */}
        <View
          style={{ alignItems: "center", flex: 1, opacity: won ? 1 : 0.55 }}
        >
          <View style={{ position: "relative", alignItems: "center" }}>
            {won && (
              <Crown
                color={currentTier.color}
                size={28}
                style={{ position: "absolute", top: -16, zIndex: 10 }}
              />
            )}
            <ProfileFrame
              size={100}
              tierIdx={userTierIdx >= 0 ? userTierIdx : 0}
              photoUrl={resolvedPhotoUrl}
              glow={won}
            />
          </View>
          <Text style={{ color: "#FFF", fontWeight: "bold", marginTop: 12 }}>
            YOU
          </Text>
          <Text
            style={{
              color: won ? currentTier.color : "#888",
              fontSize: 22,
              fontWeight: "900",
            }}
          >
            {userScore.toLocaleString()} PTS
          </Text>
        </View>

        <Text style={{ color: "#222", fontSize: 26, fontWeight: "900" }}>
          VS
        </Text>

        {/* OPPONENT side */}
        <View
          style={{ alignItems: "center", flex: 1, opacity: won ? 0.45 : 1 }}
        >
          <View style={{ position: "relative", alignItems: "center" }}>
            {!won && (
              <Crown
                color="#FF4444"
                size={28}
                style={{ position: "absolute", top: -16, zIndex: 10 }}
              />
            )}
            <ProfileFrame
              size={100}
              tierIdx={opponentTierIdx ?? 0}
              photoUrl={null}
              fallbackIcon="🏋️"
              glow={!won}
            />
          </View>
          <Text style={{ color: "#FFF", fontWeight: "bold", marginTop: 12 }}>
            {displayOpponentName}
          </Text>
          <Text
            style={{
              color: !won ? "#FF4444" : "#888",
              fontSize: 22,
              fontWeight: "900",
            }}
          >
            {displayOpponentScore} PTS
          </Text>
        </View>
      </View>

      {/* Forfeit notice */}
      {opponentForfeited && (
        <View
          style={{
            backgroundColor: "#1A0A00",
            borderRadius: 12,
            paddingVertical: 8,
            paddingHorizontal: 16,
            marginTop: 16,
            alignSelf: "center",
            borderWidth: 1,
            borderColor: "#FF6B0044",
          }}
        >
          <Text
            style={{
              color: "#FF6B00",
              fontWeight: "900",
              fontSize: 13,
              letterSpacing: 1,
              textAlign: "center",
            }}
          >
            🏳️ OPPONENT FORFEITED
          </Text>
        </View>
      )}

      {/* LP change card */}
      <View
        style={{
          backgroundColor: "#111",
          padding: 24,
          borderRadius: 24,
          marginTop: 36,
          alignItems: "center",
          borderWidth: 1,
          borderColor: "#1E1E1E",
        }}
      >
        <Text
          style={{
            color: won ? "#00C853" : "#FF4444",
            fontSize: 36,
            fontWeight: "900",
          }}
        >
          {lastLPChange !== null && lastLPChange >= 0 ? "+" : ""}
          {lastLPChange ?? 0} LP
        </Text>
        <View
          style={{
            height: 7,
            backgroundColor: "#0A0A0A",
            width: "100%",
            borderRadius: 4,
            marginTop: 16,
            overflow: "hidden",
          }}
        >
          <View
            style={{
              height: "100%",
              backgroundColor: currentTier.color,
              width: `${playerState.lp}%`,
              borderRadius: 4,
            }}
          />
        </View>
        <Text style={{ color: "#444", marginTop: 8, fontSize: 12 }}>
          {currentTier.name} {currentDivName} · {playerState.lp} /{" "}
          {isLegendI ? "∞" : "100"} LP
        </Text>
        {playerState.demotionShield && (
          <Text style={{ color: "#2A3A2A", fontSize: 11, marginTop: 4 }}>
            🛡 Demotion shield active
          </Text>
        )}
      </View>

      <View style={{ flex: 1 }} />

      <View style={{ marginBottom: insets.bottom + 20, gap: 12 }}>
        <TouchableOpacity
          style={{
            backgroundColor: "#111",
            height: 58,
            borderRadius: 20,
            justifyContent: "center",
            alignItems: "center",
            borderWidth: 1,
            borderColor: "#1E1E1E",
          }}
          onPress={() => setShowDetails(true)}
        >
          <Text style={{ color: "#FFF", fontWeight: "bold" }}>
            VIEW FULL DETAILS
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={{
            backgroundColor: "#4BB8FA",
            height: 58,
            borderRadius: 20,
            justifyContent: "center",
            alignItems: "center",
            shadowColor: "#4BB8FA",
            shadowOffset: { width: 0, height: 4 },
            shadowOpacity: 0.5,
            shadowRadius: 14,
          }}
          onPress={onBackToRoad}
        >
          <Text style={{ color: "#000", fontWeight: "900" }}>
            BACK TO TROPHY ROAD
          </Text>
        </TouchableOpacity>
      </View>

      <MatchDetailsModal
        visible={showDetails}
        onClose={() => setShowDetails(false)}
        matchId={matchId}
      />
    </View>
  );
};
