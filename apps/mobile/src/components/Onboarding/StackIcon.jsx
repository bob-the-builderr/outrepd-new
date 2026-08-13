import React from "react";
import { View } from "react-native";

export const StackIcon = ({ level }) => {
  return (
    <View style={{ gap: 3, width: 20, alignItems: "center" }}>
      <View
        style={{
          height: 3.5,
          width: 18,
          backgroundColor: level >= 3 ? "#4BB8FA" : "#333333",
          borderRadius: 1.5,
        }}
      />
      <View
        style={{
          height: 3.5,
          width: 18,
          backgroundColor: level >= 2 ? "#4BB8FA" : "#333333",
          borderRadius: 1.5,
        }}
      />
      <View
        style={{
          height: 3.5,
          width: 18,
          backgroundColor: level >= 1 ? "#4BB8FA" : "#333333",
          borderRadius: 1.5,
        }}
      />
    </View>
  );
};
