import React from "react";
import { View, Text, TouchableOpacity } from "react-native";
import { ENERGY_LEVEL_OPTIONS } from "@/constants/onboarding";
import { BatteryIcon } from "@/components/Onboarding/BatteryIcon";

export const EnergyLevelStep = ({ selected, onSelect }) => {
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
        How are your energy levels during workouts?
      </Text>

      <View style={{ gap: 12, marginBottom: 40 }}>
        {ENERGY_LEVEL_OPTIONS.map((row, rIdx) => (
          <View key={rIdx} style={{ flexDirection: "row", gap: 12 }}>
            {row.map((option) => {
              const isSelected = selected === option.key;
              return (
                <TouchableOpacity
                  key={option.key}
                  onPress={() => onSelect(option.key)}
                  activeOpacity={0.7}
                  style={{
                    flex: 1,
                    backgroundColor: "#111111",
                    borderRadius: 16,
                    padding: 16,
                    height: 140,
                    justifyContent: "center",
                    alignItems: "center",
                    borderWidth: 2,
                    borderColor: isSelected ? "#4BB8FA" : "transparent",
                    gap: 14,
                  }}
                >
                  <BatteryIcon level={option.level} />
                  <Text
                    style={{
                      color: isSelected ? "#4BB8FA" : "#FFFFFF",
                      fontSize: 13,
                      fontWeight: "700",
                      textAlign: "center",
                      lineHeight: 18,
                    }}
                  >
                    {option.label}
                  </Text>
                </TouchableOpacity>
              );
            })}
          </View>
        ))}
      </View>
    </View>
  );
};
