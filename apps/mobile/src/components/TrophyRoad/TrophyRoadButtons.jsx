import React from "react";
import { TouchableOpacity, Text, View } from "react-native";
import { LinearGradient } from "expo-linear-gradient";

export const TrophyRoadButtons = ({ onFindMatchPress, onChallengePress }) => {
  return (
    <LinearGradient
      colors={["#00000000", "#010206CC", "#010206"]}
      style={{
        position: "absolute",
        bottom: 0,
        left: 0,
        right: 0,
        paddingTop: 44,
        paddingBottom: 16,
        paddingHorizontal: 20,
      }}
    >
      <View style={{ flexDirection: "row", gap: 10 }}>
        {/* Primary: online matchmaking */}
        <TouchableOpacity
          style={{
            flex: 1,
            backgroundColor: "#4BB8FA",
            height: 56,
            borderRadius: 16,
            justifyContent: "center",
            alignItems: "center",
            shadowColor: "#4BB8FA",
            shadowOffset: { width: 0, height: 4 },
            shadowOpacity: 0.5,
            shadowRadius: 12,
          }}
          onPress={onFindMatchPress}
        >
          <Text
            style={{
              color: "#000",
              fontWeight: "900",
              fontSize: 14,
              letterSpacing: 0.5,
            }}
          >
            FIND MATCH
          </Text>
        </TouchableOpacity>

        {/* Secondary: create or join a friend room */}
        <TouchableOpacity
          style={{
            flex: 1,
            borderColor: "#4BB8FA44",
            borderWidth: 1.5,
            height: 56,
            borderRadius: 16,
            justifyContent: "center",
            alignItems: "center",
            backgroundColor: "#0A1520",
          }}
          onPress={onChallengePress}
        >
          <Text
            style={{
              color: "#4BB8FA",
              fontWeight: "900",
              fontSize: 14,
              letterSpacing: 0.5,
            }}
          >
            CHALLENGE FRIEND
          </Text>
        </TouchableOpacity>
      </View>
    </LinearGradient>
  );
};
