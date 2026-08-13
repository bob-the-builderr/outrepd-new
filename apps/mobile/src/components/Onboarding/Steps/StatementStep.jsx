import React from "react";
import { View, Text, TouchableOpacity } from "react-native";

export const StatementStep = ({ statement, selected, onSelect }) => {
  return (
    <View style={{ flex: 1 }}>
      <Text
        style={{
          color: "#FFFFFF",
          fontSize: 28,
          fontWeight: "900",
          textAlign: "center",
          marginBottom: 48,
          lineHeight: 34,
        }}
      >
        Do you relate to the statement below?
      </Text>

      <View
        style={{
          backgroundColor: "#11111C",
          borderRadius: 24,
          paddingVertical: 32,
          paddingHorizontal: 24,
          alignItems: "center",
          position: "relative",
          marginBottom: 36,
          borderWidth: 1,
          borderColor: "#1E1E2F",
        }}
      >
        <View
          style={{
            position: "absolute",
            top: -20,
            width: 40,
            height: 40,
            borderRadius: 20,
            backgroundColor: "#1E1E2F",
            justifyContent: "center",
            alignItems: "center",
          }}
        >
          <Text
            style={{
              color: "#4BB8FA",
              fontSize: 24,
              fontWeight: "900",
              marginTop: 8,
            }}
          >
            "
          </Text>
        </View>
        <Text
          style={{
            color: "#FFFFFF",
            fontSize: 18,
            fontStyle: "italic",
            textAlign: "center",
            lineHeight: 26,
          }}
        >
          {statement}
        </Text>
      </View>

      <View style={{ flexDirection: "row", gap: 16, marginBottom: 40 }}>
        {/* Yes */}
        <TouchableOpacity
          onPress={() => onSelect("yes")}
          activeOpacity={0.7}
          style={{
            flex: 1,
            height: 120,
            borderRadius: 20,
            backgroundColor: "#111111",
            justifyContent: "center",
            alignItems: "center",
            borderWidth: 2,
            borderColor: selected === "yes" ? "#4BB8FA" : "transparent",
            gap: 10,
          }}
        >
          <View
            style={{
              width: 36,
              height: 36,
              borderRadius: 18,
              backgroundColor:
                selected === "yes" ? "rgba(75, 184, 250, 0.15)" : "#222",
              borderWidth: 1.5,
              borderColor: selected === "yes" ? "#4BB8FA" : "#444",
              justifyContent: "center",
              alignItems: "center",
            }}
          >
            <Text
              style={{
                color: selected === "yes" ? "#4BB8FA" : "#888",
                fontSize: 16,
                fontWeight: "900",
              }}
            >
              ✓
            </Text>
          </View>
          <Text
            style={{
              color: selected === "yes" ? "#4BB8FA" : "#FFFFFF",
              fontSize: 16,
              fontWeight: "700",
            }}
          >
            Yes
          </Text>
        </TouchableOpacity>

        {/* No */}
        <TouchableOpacity
          onPress={() => onSelect("no")}
          activeOpacity={0.7}
          style={{
            flex: 1,
            height: 120,
            borderRadius: 20,
            backgroundColor: "#111111",
            justifyContent: "center",
            alignItems: "center",
            borderWidth: 2,
            borderColor: selected === "no" ? "#FF4444" : "transparent",
            gap: 10,
          }}
        >
          <View
            style={{
              width: 36,
              height: 36,
              borderRadius: 18,
              backgroundColor:
                selected === "no" ? "rgba(255, 68, 68, 0.15)" : "#222",
              borderWidth: 1.5,
              borderColor: selected === "no" ? "#FF4444" : "#444",
              justifyContent: "center",
              alignItems: "center",
            }}
          >
            <Text
              style={{
                color: selected === "no" ? "#FF4444" : "#888",
                fontSize: 16,
                fontWeight: "900",
              }}
            >
              ✗
            </Text>
          </View>
          <Text
            style={{
              color: selected === "no" ? "#FF4444" : "#FFFFFF",
              fontSize: 16,
              fontWeight: "700",
            }}
          >
            No
          </Text>
        </TouchableOpacity>
      </View>
    </View>
  );
};
