import React from "react";
import { View, Text, TouchableOpacity } from "react-native";
import { THINK_SHAPE_OPTIONS } from "@/constants/onboarding";
import { StackIcon } from "@/components/Onboarding/StackIcon";

export const ThinkShapeStep = ({ selected, onSelect }) => {
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
        How often do you think about getting in shape?
      </Text>

      <View style={{ gap: 12, marginBottom: 40 }}>
        {THINK_SHAPE_OPTIONS.map((option) => {
          const isSelected = selected === option.key;
          return (
            <TouchableOpacity
              key={option.key}
              onPress={() => onSelect(option.key)}
              activeOpacity={0.7}
              style={{
                backgroundColor: "#111111",
                borderRadius: 14,
                padding: 18,
                paddingHorizontal: 24,
                borderWidth: 2,
                borderColor: isSelected ? "#4BB8FA" : "transparent",
                flexDirection: "row",
                alignItems: "center",
                gap: 18,
              }}
            >
              <StackIcon level={option.level} />
              <Text
                style={{
                  color: isSelected ? "#4BB8FA" : "#FFFFFF",
                  fontSize: 17,
                  fontWeight: isSelected ? "700" : "500",
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
