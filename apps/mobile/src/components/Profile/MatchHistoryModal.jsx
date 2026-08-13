import React, { useState } from "react";
import { View, Text, ScrollView, TouchableOpacity, Modal } from "react-native";
import { Image } from "expo-image";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { StatusBar } from "expo-status-bar";
import { Swords, X } from "lucide-react-native";
import { formatTime } from "@/utils/formatTime";
import { volumeToScore } from "@/utils/scoreSystem";
import { MatchDetailsModal } from "./MatchDetailsModal";
import { ProfileFrame } from "@/components/ProfileFrame";
import { TIERS } from "@/constants/tiers";

export function MatchHistoryModal({ visible, onClose, matches, userProfile }) {
  const insets = useSafeAreaInsets();
  const [selectedMatchId, setSelectedMatchId] = useState(null);

  const renderMatchCard = (match) => {
    const isWin = match.result === "win";
    const userScore = volumeToScore(match.user_volume_kg || 0);
    const opponentScore = volumeToScore(match.opponent_volume_kg || 0);
    const opponentTier = TIERS[Math.min(match.opponent_tier_idx || 0, 8)];

    return (
      <TouchableOpacity
        key={match.id}
        onPress={() => setSelectedMatchId(match.id)}
        activeOpacity={0.8}
        style={{
          backgroundColor: "#0D1218",
          borderRadius: 16,
          padding: 16,
          marginBottom: 12,
        }}
      >
        {/* Photos row with usernames underneath */}
        <View
          style={{
            flexDirection: "row",
            alignItems: "flex-start",
            justifyContent: "center",
            marginTop: 12,
            marginBottom: 20,
          }}
        >
          <View style={{ alignItems: "center" }}>
            <ProfileFrame
              size={60}
              tierIdx={userProfile?.tier_idx || 0}
              photoUrl={userProfile?.profile_photo_url}
              fallbackIcon={
                TIERS[Math.min(userProfile?.tier_idx || 0, 8)]?.icon
              }
              glow={false}
            />
            <Text
              style={{ color: "#666", fontSize: 12, marginTop: 8 }}
              numberOfLines={1}
            >
              {userProfile?.username || "You"}
            </Text>
          </View>

          <View
            style={{
              marginHorizontal: 30,
              width: 42,
              height: 42,
              borderRadius: 21,
              backgroundColor: "#4BB8FA18",
              alignItems: "center",
              justifyContent: "center",
              marginTop: 10,
            }}
          >
            <Image
              source={{
                uri: "https://dtvoeevhaseb5.cloudfront.net/user-uploads/10341004-1568-4639-9f40-8061c2cb7d4a.png",
              }}
              style={{ width: 34, height: 34 }}
              contentFit="contain"
            />
          </View>

          <View style={{ alignItems: "center" }}>
            <ProfileFrame
              size={60}
              tierIdx={match.opponent_tier_idx || 0}
              photoUrl={match.opponent_photo_url}
              fallbackIcon={opponentTier?.icon}
              glow={false}
            />
            <Text
              style={{ color: "#666", fontSize: 12, marginTop: 8 }}
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
                fontSize: 20,
                fontWeight: "900",
              }}
            >
              {userScore.toLocaleString()} pts
            </Text>
          </View>

          <View style={{ marginHorizontal: 30, alignItems: "center" }}>
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
                fontSize: 20,
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
            paddingTop: 12,
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
                paddingHorizontal: 14,
                paddingVertical: 7,
                borderRadius: 10,
              }}
            >
              <Text
                style={{
                  color: isWin ? "#4BFA88" : "#FF4444",
                  fontSize: 12,
                  fontWeight: "900",
                }}
              >
                {isWin ? "WIN" : "LOSS"}
              </Text>
            </View>
          </View>
          <View style={{ flex: 1, alignItems: "center" }}>
            <Text style={{ color: "#666", fontSize: 12 }}>
              {formatTime(match.match_date)}
            </Text>
          </View>
          <View style={{ flex: 1, alignItems: "flex-end" }}>
            <Text
              style={{
                color: match.lp_change > 0 ? "#4BFA88" : "#FF4444",
                fontSize: 13,
                fontWeight: "700",
              }}
            >
              {match.lp_change > 0 ? "+" : ""}
              {match.lp_change} LP
            </Text>
          </View>
        </View>

        {(match.promoted || match.demoted) && (
          <View
            style={{
              marginTop: 12,
              paddingTop: 12,
              borderTopWidth: 1,
              borderTopColor: "#1A2630",
              alignItems: "center",
            }}
          >
            <View
              style={{
                backgroundColor: match.promoted ? "#0D3A1A" : "#3A0D0D",
                borderRadius: 8,
                paddingHorizontal: 10,
                paddingVertical: 6,
                borderWidth: 1,
                borderColor: match.promoted ? "#1A6A2A" : "#6A1A1A",
              }}
            >
              <Text
                style={{
                  color: match.promoted ? "#4BFA88" : "#FF4444",
                  fontSize: 11,
                  fontWeight: "700",
                }}
              >
                {match.promoted ? "⬆️ PROMOTED" : "⬇️ DEMOTED"}
              </Text>
            </View>
          </View>
        )}
      </TouchableOpacity>
    );
  };

  return (
    <Modal
      visible={visible}
      animationType="slide"
      presentationStyle="pageSheet"
      onRequestClose={onClose}
    >
      <View style={{ flex: 1, backgroundColor: "#010308" }}>
        <StatusBar style="light" />
        <View
          style={{
            paddingTop: insets.top + 16,
            paddingHorizontal: 20,
            paddingBottom: 16,
            borderBottomWidth: 1,
            borderBottomColor: "#1A2630",
            flexDirection: "row",
            alignItems: "center",
            justifyContent: "space-between",
          }}
        >
          <View>
            <Text
              style={{
                color: "#FFF",
                fontSize: 22,
                fontWeight: "900",
                letterSpacing: 1,
              }}
            >
              MATCH HISTORY
            </Text>
            <Text style={{ color: "#4BB8FA", fontSize: 13, marginTop: 2 }}>
              {matches.length} {matches.length === 1 ? "match" : "matches"}
            </Text>
          </View>
          <TouchableOpacity
            onPress={onClose}
            style={{
              backgroundColor: "#1A2630",
              borderRadius: 20,
              width: 36,
              height: 36,
              alignItems: "center",
              justifyContent: "center",
            }}
          >
            <X size={18} color="#888" />
          </TouchableOpacity>
        </View>

        <ScrollView
          contentContainerStyle={{
            paddingHorizontal: 20,
            paddingTop: 16,
            paddingBottom: insets.bottom + 24,
          }}
          showsVerticalScrollIndicator={false}
        >
          {matches.length === 0 ? (
            <View style={{ alignItems: "center", paddingTop: 70 }}>
              <Swords size={52} color="#1A2630" />
              <Text
                style={{
                  color: "#444",
                  fontSize: 16,
                  marginTop: 16,
                  fontWeight: "700",
                }}
              >
                No matches yet
              </Text>
              <Text style={{ color: "#333", fontSize: 13, marginTop: 6 }}>
                Start battling to build your history
              </Text>
            </View>
          ) : (
            matches.map((match) => renderMatchCard(match))
          )}
        </ScrollView>

        <MatchDetailsModal
          visible={!!selectedMatchId}
          onClose={() => setSelectedMatchId(null)}
          matchId={selectedMatchId}
        />
      </View>
    </Modal>
  );
}
