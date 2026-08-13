import React from "react";
import { View, Text, TouchableOpacity } from "react-native";
import { EXPERIENCE_OPTIONS } from "@/constants/onboarding";

export const ExperienceStep = ({ selectedExperience, onSelect, error }) => {
  return (
    <View style={{ flex: 1 }}>
      <Text
        style={{
          color: "#FFFFFF",
          fontSize: 28,
          fontWeight: "900",
          textAlign: "center",
          marginBottom: 36,
          lineHeight: 34,
        }}
      >
        How experienced are you with working out?
      </Text>

      {error && (
        <View
          style={{
            backgroundColor: "#1A0808",
            borderWidth: 1,
            borderColor: "#FF4444",
            borderRadius: 10,
            padding: 12,
            marginBottom: 16,
          }}
        >
          <Text
            style={{
              color: "#FF4444",
              fontSize: 13,
              textAlign: "center",
            }}
          >
            {error}
          </Text>
        </View>
      )}

      <View style={{ gap: 12, marginBottom: 40 }}>
        {EXPERIENCE_OPTIONS.map((option) => {
          const selected = selectedExperience === option.key;
          return (
            <TouchableOpacity
              key={option.key}
              onPress={() => onSelect(option.key)}
              activeOpacity={0.7}
              style={{
                backgroundColor: "#111111",
                borderRadius: 14,
                padding: 18,
                borderWidth: 2,
                borderColor: selected ? "#4BB8FA" : "transparent",
              }}
            >
              <Text
                style={{
                  color: selected ? "#4BB8FA" : "#FFFFFF",
                  fontSize: 16,
                  fontWeight: selected ? "700" : "500",
                  textAlign: "center",
                }}
              >
                {option.label}
              </Text>
            </TouchableOpacity>
          );
        })}
      </View>
    </View>
  );
};
