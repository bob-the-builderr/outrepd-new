import React from "react";
import { View, Text, TouchableOpacity } from "react-native";
import Svg, { Circle, Line } from "react-native-svg";

export const GenderStep = ({ selectedGender, onSelect }) => {
  return (
    <View style={{ flex: 1 }}>
      <Text
        style={{
          color: "#FFFFFF",
          fontSize: 30,
          fontWeight: "900",
          textAlign: "center",
          marginBottom: 8,
          lineHeight: 36,
        }}
      >
        Alright! Lets get{"\n"}some basic info
      </Text>

      <Text
        style={{
          color: "#888",
          fontSize: 18,
          fontWeight: "600",
          textAlign: "center",
          marginBottom: 48,
        }}
      >
        I am...
      </Text>

      <View style={{ flexDirection: "row", gap: 16, marginBottom: 40 }}>
        {/* Male */}
        <TouchableOpacity
          onPress={() => onSelect("male")}
          activeOpacity={0.85}
          style={{
            flex: 1,
            aspectRatio: 1,
            backgroundColor: "#111111",
            borderRadius: 20,
            borderWidth: 2.5,
            borderColor: selectedGender === "male" ? "#4BB8FA" : "#444",
            justifyContent: "center",
            alignItems: "center",
            shadowColor: selectedGender === "male" ? "#4BB8FA" : "transparent",
            shadowOffset: { width: 0, height: 6 },
            shadowOpacity: selectedGender === "male" ? 0.4 : 0,
            shadowRadius: 14,
            elevation: selectedGender === "male" ? 8 : 0,
          }}
        >
          <Svg width={80} height={80} viewBox="0 0 24 24" fill="none">
            <Circle
              cx="10"
              cy="14"
              r="6"
              stroke="#4BB8FA"
              strokeWidth="2.5"
              fill="none"
            />
            <Line
              x1="14.5"
              y1="9.5"
              x2="21"
              y2="3"
              stroke="#4BB8FA"
              strokeWidth="2.5"
              strokeLinecap="round"
            />
            <Line
              x1="16"
              y1="3"
              x2="21"
              y2="3"
              stroke="#4BB8FA"
              strokeWidth="2.5"
              strokeLinecap="round"
            />
            <Line
              x1="21"
              y1="3"
              x2="21"
              y2="8"
              stroke="#4BB8FA"
              strokeWidth="2.5"
              strokeLinecap="round"
            />
          </Svg>
        </TouchableOpacity>

        {/* Female */}
        <TouchableOpacity
          onPress={() => onSelect("female")}
          activeOpacity={0.85}
          style={{
            flex: 1,
            aspectRatio: 1,
            backgroundColor: "#111111",
            borderRadius: 20,
            borderWidth: 2.5,
            borderColor: selectedGender === "female" ? "#FF5C8D" : "#444",
            justifyContent: "center",
            alignItems: "center",
            shadowColor:
              selectedGender === "female" ? "#FF5C8D" : "transparent",
            shadowOffset: { width: 0, height: 6 },
            shadowOpacity: selectedGender === "female" ? 0.4 : 0,
            shadowRadius: 14,
            elevation: selectedGender === "female" ? 8 : 0,
          }}
        >
          <Svg width={80} height={80} viewBox="0 0 24 24" fill="none">
            <Circle
              cx="12"
              cy="10"
              r="6"
              stroke="#FF5C8D"
              strokeWidth="2.5"
              fill="none"
            />
            <Line
              x1="12"
              y1="16"
              x2="12"
              y2="22"
              stroke="#FF5C8D"
              strokeWidth="2.5"
              strokeLinecap="round"
            />
            <Line
              x1="9"
              y1="19"
              x2="15"
              y2="19"
              stroke="#FF5C8D"
              strokeWidth="2.5"
              strokeLinecap="round"
            />
          </Svg>
        </TouchableOpacity>
      </View>
    </View>
  );
};
