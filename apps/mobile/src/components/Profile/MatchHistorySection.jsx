import React, { useState } from "react";
import { View, Text, TouchableOpacity } from "react-native";
import { Image } from "expo-image";
import { ChevronRight } from "lucide-react-native";
import { formatTime } from "@/utils/formatTime";
import { volumeToScore } from "@/utils/scoreSystem";
import { MatchDetailsModal } from "./MatchDetailsModal";
import { ProfileFrame } from "@/components/ProfileFrame";
import { TIERS } from "@/constants/tiers";

export function MatchHistorySection({ matches, onViewAll, userProfile }) {
  const recentMatches = matches.slice(0, 3);
  const [selectedMatchId, setSelectedMatchId] = useState(null);

  return (
    <View style={{ paddingTop: 24 }}>
      {/* Section header */}
      <View
        style={{
          flexDirection: "row",
          alignItems: "center",
          justifyContent: "space-between",
          paddingHorizontal: 20,
          marginBottom: 14,
        }}
      >
        <View style={{ flexDirection: "row", alignItems: "center", gap: 10 }}>
          <Text
            style={{
              color: "#FFF",
              fontSize: 17,
              fontWeight: "900",
              letterSpacing: 0.5,
            }}
          >
            MATCH HISTORY
          </Text>
        </View>
        <TouchableOpacity
          onPress={onViewAll}
          style={{ flexDirection: "row", alignItems: "center", gap: 4 }}
        >
          <Text style={{ color: "#4BB8FA", fontSize: 13, fontWeight: "700" }}>
            View all
          </Text>
          <ChevronRight size={14} color="#4BB8FA" />
        </TouchableOpacity>
      </View>

      {recentMatches.length === 0 ? (
        <View style={{ alignItems: "center", paddingVertical: 24 }}>
          <Image
            source={{
              uri: "https://dtvoeevhaseb5.cloudfront.net/user-uploads/10341004-1568-4639-9f40-8061c2cb7d4a.png",
            }}
            style={{ width: 40, height: 40 }}
            contentFit="contain"
          />
          <Text style={{ color: "#444", fontSize: 14, marginTop: 12 }}>
            No matches yet
          </Text>
          <Text style={{ color: "#333", fontSize: 12, marginTop: 4 }}>
            Challenge others to start your journey!
          </Text>
        </View>
      ) : (
        <View style={{ paddingHorizontal: 20 }}>
          {recentMatches.map((match) => {
            const isWin = match.result === "win";
            const userScore = volumeToScore(match.user_volume_kg || 0);
            const opponentScore = volumeToScore(match.opponent_volume_kg || 0);
            const opponentTier =
              TIERS[Math.min(match.opponent_tier_idx || 0, 8)];

            return (
              <TouchableOpacity
                key={match.id}
                onPress={() => setSelectedMatchId(match.id)}
                activeOpacity={0.8}
                style={{
                  backgroundColor: "#0D1218",
                  borderRadius: 16,
                  padding: 16,
                  marginBottom: 10,
                }}
              >
                {/* Photos row with usernames underneath */}
                <View
                  style={{
                    flexDirection: "row",
                    alignItems: "flex-start",
                    justifyContent: "space-between",
                    marginTop: 12,
                    marginBottom: 20,
                  }}
                >
                  <View style={{ flex: 1, alignItems: "center" }}>
                    <ProfileFrame
                      size={54}
                      tierIdx={userProfile?.tier_idx || 0}
                      photoUrl={userProfile?.profile_photo_url}
                      fallbackIcon={
                        TIERS[Math.min(userProfile?.tier_idx || 0, 8)]?.icon
                      }
                      glow={false}
                    />
                    <Text
                      style={{ color: "#666", fontSize: 11, marginTop: 8 }}
                      numberOfLines={1}
                    >
                      {userProfile?.username || "You"}
                    </Text>
                  </View>

                  <Image
                    source={{
                      uri: "https://dtvoeevhaseb5.cloudfront.net/user-uploads/10341004-1568-4639-9f40-8061c2cb7d4a.png",
                    }}
                    style={{ width: 34, height: 34, marginTop: 10 }}
                    contentFit="contain"
                  />

                  <View style={{ flex: 1, alignItems: "center" }}>
                    <ProfileFrame
                      size={54}
                      tierIdx={match.opponent_tier_idx || 0}
                      photoUrl={match.opponent_photo_url}
                      fallbackIcon={opponentTier?.icon}
                      glow={false}
                    />
                    <Text
                      style={{ color: "#666", fontSize: 11, marginTop: 8 }}
                      numberOfLines={1}
                    >
                      {match.opponent_name || "Unknown"}
                    </Text>
                  </View>
                </View>

                {/* Scores row: user score left, SCORE center, opponent score right */}
                <View
                  style={{
                    flexDirection: "row",
                    alignItems: "center",
                    marginBottom: 16,
                  }}
                >
                  <View style={{ flex: 1, alignItems: "center" }}>
                    <Text
                      style={{
                        color: "#FFF",
                        fontSize: 18,
                        fontWeight: "900",
                      }}
                    >
                      {userScore.toLocaleString()} pts
                    </Text>
                  </View>

                  <View style={{ alignItems: "center" }}>
                    <Text
                      style={{
                        color: "#555",
                        fontSize: 10,
                        fontWeight: "700",
                        letterSpacing: 1,
                      }}
                    >
                      SCORE
                    </Text>
                  </View>

                  <View style={{ flex: 1, alignItems: "center" }}>
                    <Text
                      style={{
                        color: "#FFF",
                        fontSize: 18,
                        fontWeight: "900",
                      }}
                    >
                      {opponentScore.toLocaleString()} pts
                    </Text>
                  </View>
                </View>

                {/* Footer with WIN/LOSS label */}
                <View
                  style={{
                    paddingTop: 10,
                    borderTopWidth: 1,
                    borderTopColor: "#1A2630",
                    flexDirection: "row",
                    alignItems: "center",
                  }}
                >
                  <View style={{ flex: 1, alignItems: "flex-start" }}>
                    <View
                      style={{
                        backgroundColor: isWin ? "#4BFA8820" : "#FF444420",
                        paddingHorizontal: 12,
                        paddingVertical: 6,
                        borderRadius: 8,
                      }}
                    >
                      <Text
                        style={{
                          color: isWin ? "#4BFA88" : "#FF4444",
                          fontSize: 11,
                          fontWeight: "900",
                        }}
                      >
                        {isWin ? "WIN" : "LOSS"}
                      </Text>
                    </View>
                  </View>
                  <View style={{ flex: 1, alignItems: "center" }}>
                    <Text style={{ color: "#555", fontSize: 11 }}>
                      {formatTime(match.match_date)}
                    </Text>
                  </View>
                  <View style={{ flex: 1, alignItems: "flex-end" }}>
                    <Text
                      style={{
                        color: match.lp_change > 0 ? "#4BFA88" : "#FF4444",
                        fontSize: 12,
                        fontWeight: "700",
                      }}
                    >
                      {match.lp_change > 0 ? "+" : ""}
                      {match.lp_change} LP
                    </Text>
                  </View>
                </View>
              </TouchableOpacity>
            );
          })}
        </View>
      )}

      <MatchDetailsModal
        visible={!!selectedMatchId}
        onClose={() => setSelectedMatchId(null)}
        matchId={selectedMatchId}
      />
    </View>
  );
}
