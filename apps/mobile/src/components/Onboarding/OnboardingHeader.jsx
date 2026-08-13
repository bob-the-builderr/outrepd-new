import React from "react";
import { View, Text, TouchableOpacity } from "react-native";
import { ChevronLeft } from "lucide-react-native";

export const OnboardingHeader = ({ onBack, progressFill, hideProgress }) => {
  return (
    <View
      style={{
        flexDirection: "row",
        alignItems: "center",
        paddingHorizontal: 20,
        marginBottom: 32,
        gap: 14,
      }}
    >
      <TouchableOpacity
        onPress={onBack}
        activeOpacity={0.7}
        style={{ padding: 4 }}
      >
        <ChevronLeft size={24} color="#FFFFFF" strokeWidth={2.5} />
      </TouchableOpacity>

      {!hideProgress && (
        <View
          style={{
            flex: 1,
            height: 4,
            backgroundColor: "#1C1C1C",
            borderRadius: 2,
            overflow: "hidden",
          }}
        >
          <View
            style={{
              width: `${progressFill * 100}%`,
              height: "100%",
              backgroundColor: "#4BB8FA",
              borderRadius: 2,
            }}
          />
        </View>
      )}
    </View>
  );
};
