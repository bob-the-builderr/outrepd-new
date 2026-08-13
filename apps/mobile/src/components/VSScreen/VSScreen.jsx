import React from "react";
import { View, Text } from "react-native";
import { Image } from "expo-image";
import { TIERS, DIVISION_NAMES } from "@/constants/tiers";
import { ProfileFrame } from "@/components/ProfileFrame";

export const VSScreen = ({
  currentTier,
  currentDivName,
  selectedMuscle,
  countdown,
  opponentName,
  opponentTierIdx,
  opponentDivIdx,
  userPhotoUrl,
  opponentPhotoUrl,
}) => {
  const userTierIdx = TIERS.indexOf(currentTier);
  const opponentTier =
    TIERS[Math.min(opponentTierIdx ?? 0, TIERS.length - 1)] || TIERS[0];
  const opponentDivName = DIVISION_NAMES[opponentDivIdx] ?? "IV";
  const displayOpponentName = opponentName || "OPPONENT";

  return (
    <View
      style={{
        flex: 1,
        backgroundColor: "#0A0A0A",
        justifyContent: "center",
        alignItems: "center",
      }}
    >
      <View
        style={{
          flexDirection: "row",
          alignItems: "center",
          justifyContent: "space-between",
          width: "100%",
          paddingHorizontal: 20,
        }}
      >
        {/* USER side */}
        <View style={{ flex: 1, alignItems: "center" }}>
          <ProfileFrame
            size={120}
            tierIdx={userTierIdx >= 0 ? userTierIdx : 0}
            photoUrl={userPhotoUrl}
            glow
          />
          <Text
            style={{
              color: "#FFF",
              fontWeight: "900",
              marginTop: 12,
              fontSize: 18,
            }}
          >
            YOU
          </Text>
          <Text
            style={{
              color: currentTier.color,
              fontSize: 12,
              fontWeight: "700",
              marginTop: 2,
            }}
          >
            {currentTier.name} {currentDivName}
          </Text>
        </View>

        <Image
          source={{
            uri: "https://dtvoeevhaseb5.cloudfront.net/user-uploads/9613a25b-2616-4f30-be6b-ced22f46d915.png",
          }}
          style={{ width: 60, height: 60 }}
          contentFit="contain"
        />

        {/* OPPONENT side */}
        <View style={{ flex: 1, alignItems: "center" }}>
          <ProfileFrame
            size={120}
            tierIdx={opponentTierIdx ?? 0}
            photoUrl={opponentPhotoUrl}
            glow
          />
          <Text
            style={{
              color: "#FFF",
              fontWeight: "900",
              marginTop: 12,
              fontSize: 18,
            }}
            numberOfLines={1}
          >
            {displayOpponentName.slice(0, 12).toUpperCase()}
          </Text>
          <Text
            style={{
              color: opponentTier.color,
              fontSize: 12,
              fontWeight: "700",
              marginTop: 2,
            }}
          >
            {opponentTier.name} {opponentDivName}
          </Text>
        </View>
      </View>

      <Text
        style={{
          color: currentTier.color,
          fontWeight: "900",
          fontSize: 22,
          marginTop: 40,
        }}
      >
        💪 {selectedMuscle?.toUpperCase() ?? "CHEST"} BATTLE
      </Text>

      <View style={{ marginTop: 60, alignItems: "center" }}>
        <Text
          style={{
            color: "#555",
            fontSize: 16,
            fontWeight: "bold",
            letterSpacing: 4,
          }}
        >
          GET READY
        </Text>
        <Text
          style={{
            color: "#FFF",
            fontSize: 96,
            fontWeight: "900",
            textShadowColor: currentTier.color,
            textShadowOffset: { width: 0, height: 0 },
            textShadowRadius: 32,
          }}
        >
          {countdown}
        </Text>
      </View>
    </View>
  );
};
