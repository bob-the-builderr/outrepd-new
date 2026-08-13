import React from "react";
import { View, Text, TouchableOpacity, ActivityIndicator } from "react-native";
import { Image } from "expo-image";
import { X } from "lucide-react-native";

export default function SearchingForMatch({
  insets,
  muscleGroup,
  currentTier,
  currentDivName,
  playerLp,
  onCancel,
}) {
  return (
    <View
      style={{
        flex: 1,
        backgroundColor: "#010308",
        justifyContent: "center",
        alignItems: "center",
        paddingHorizontal: 32,
      }}
    >
      {/* Cancel Button */}
      <TouchableOpacity
        onPress={onCancel}
        style={{
          position: "absolute",
          top: insets.top + 16,
          right: 20,
          backgroundColor: "#1A2630",
          borderRadius: 20,
          width: 40,
          height: 40,
          alignItems: "center",
          justifyContent: "center",
          borderWidth: 1,
          borderColor: "#FF444444",
        }}
      >
        <X size={20} color="#FF4444" />
      </TouchableOpacity>

      {/* Title */}
      <Text
        style={{
          color: "#FFF",
          fontSize: 24,
          fontWeight: "900",
          textAlign: "center",
          marginBottom: 12,
        }}
      >
        SEARCHING FOR OPPONENT
      </Text>

      {/* Subtitle */}
      <Text
        style={{
          color: "#555",
          fontSize: 15,
          textAlign: "center",
          marginBottom: 24,
          lineHeight: 22,
        }}
      >
        Finding someone in your rank range who wants to battle {muscleGroup}...
      </Text>

      {/* Rank Badge */}
      <Image
        source={{ uri: currentTier.img }}
        contentFit="contain"
        style={{ width: 300, height: 300 }}
      />

      {/* Rank Name + LP */}
      <Text
        style={{
          color: currentTier.color,
          fontSize: 18,
          fontWeight: "900",
          letterSpacing: 1,
          marginTop: 12,
        }}
      >
        {currentTier.name}
        {currentDivName ? ` ${currentDivName}` : ""}
      </Text>
      <Text
        style={{
          color: "#888",
          fontSize: 14,
          fontWeight: "700",
          marginTop: 4,
          marginBottom: 32,
        }}
      >
        {playerLp ?? 0} LP
      </Text>

      {/* Loading Indicator */}
      <ActivityIndicator color={currentTier.color} size="large" />

      {/* Cancel Text Hint */}
      <Text
        style={{
          position: "absolute",
          bottom: insets.bottom + 32,
          color: "#333",
          fontSize: 13,
          textAlign: "center",
        }}
      >
        Tap the X button to cancel search
      </Text>
    </View>
  );
}
