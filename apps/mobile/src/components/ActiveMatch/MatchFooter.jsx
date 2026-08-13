import React from "react";
import { Text, TouchableOpacity } from "react-native";

export const MatchFooter = ({ insets, volume, onSubmit }) => {
  return (
    <TouchableOpacity
      style={{
        position: "absolute",
        bottom: (insets?.bottom ?? 0) + 16,
        left: 24,
        right: 24,
        backgroundColor: volume > 0 ? "#00C853" : "#1A1A1A",
        height: 54,
        borderRadius: 27,
        justifyContent: "center",
        alignItems: "center",
        borderWidth: volume > 0 ? 0 : 1,
        borderColor: "#2A2A2A",
      }}
      onPress={onSubmit}
      disabled={volume === 0}
      activeOpacity={0.85}
    >
      <Text style={{ color: "#FFF", fontWeight: "900", fontSize: 16 }}>
        SUBMIT WORKOUT
      </Text>
    </TouchableOpacity>
  );
};
