import React from "react";
import { View, Text, TouchableOpacity } from "react-native";
import { Image } from "expo-image";
import { LinearGradient } from "expo-linear-gradient";

export const TrophyRoadHeader = ({
  insets,
  currentTier,
  currentDivName,
  playerState,
  shieldTooltipVisible,
  setShieldTooltipVisible,
}) => {
  return (
    <LinearGradient
      colors={["#010206", "#010206EE", "#01020600"]}
      style={{
        position: "absolute",
        top: 0,
        left: 0,
        right: 0,
        paddingTop: insets.top + 10,
        paddingBottom: 36,
        paddingHorizontal: 20,
      }}
      pointerEvents="box-none"
    >
      {/* Row: rank name left, shield right */}
      <View
        style={{
          flexDirection: "row",
          justifyContent: "space-between",
          alignItems: "center",
        }}
      >
        {/* Left side: app name instead of rank */}
        <View style={{ flexDirection: "row", alignItems: "center" }}>
          <Text
            style={{
              color: "#4BB8FA",
              fontSize: 24,
              fontWeight: "900",
              letterSpacing: 1.5,
            }}
          >
            OUTREPD
          </Text>
        </View>

        {/* Shield icon button */}
        <TouchableOpacity
          onPress={() => setShieldTooltipVisible((v) => !v)}
          style={{ padding: 6 }}
          pointerEvents="auto"
        >
          <Text style={{ fontSize: 26 }}>
            {playerState.demotionShield ? "🛡️" : "🩶"}
          </Text>
        </TouchableOpacity>
      </View>

      {/* Shield tooltip */}
      {shieldTooltipVisible && (
        <View
          style={{
            position: "absolute",
            top: insets.top + 52,
            right: 20,
            width: 230,
            backgroundColor: "#0F1A0F",
            borderRadius: 14,
            padding: 14,
            borderWidth: 1,
            borderColor: playerState.demotionShield
              ? currentTier.color + "66"
              : "#2A2A2A",
            zIndex: 99,
            shadowColor: "#000",
            shadowOffset: { width: 0, height: 4 },
            shadowOpacity: 0.6,
            shadowRadius: 12,
          }}
        >
          <Text
            style={{
              color: "#FFFFFF",
              fontWeight: "800",
              fontSize: 13,
              marginBottom: 6,
            }}
          >
            {playerState.demotionShield
              ? "🛡️ Demotion Shield — Active"
              : "🩶 Demotion Shield — Used"}
          </Text>
          <Text style={{ color: "#AAAAAA", fontSize: 12, lineHeight: 18 }}>
            {playerState.demotionShield
              ? "You are protected from demotion. If your LP drops below 0, the shield absorbs it and keeps you at 0 LP. One shield per division entry."
              : "Your shield has been used up. If you lose with 0 LP, you will be demoted to the previous division at 75 LP. Win to earn a new shield on promotion."}
          </Text>
          <TouchableOpacity
            onPress={() => setShieldTooltipVisible(false)}
            style={{ marginTop: 10, alignSelf: "flex-end" }}
          >
            <Text
              style={{
                color: currentTier.color,
                fontWeight: "700",
                fontSize: 12,
              }}
            >
              Got it
            </Text>
          </TouchableOpacity>
        </View>
      )}
    </LinearGradient>
  );
};
