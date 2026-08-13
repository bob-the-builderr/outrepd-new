import React from "react";
import { View } from "react-native";
import { TypewriterText } from "@/components/Onboarding/TypewriterText";
import { SCREEN_HEIGHT } from "@/constants/onboardingDimensions";

export const TransitionStep = ({ text, onComplete }) => {
  return (
    <View
      style={{
        flex: 1,
        justifyContent: "center",
        alignItems: "center",
        paddingHorizontal: 20,
        minHeight: SCREEN_HEIGHT * 0.45,
      }}
    >
      <TypewriterText
        text={text}
        onComplete={onComplete}
        style={{
          color: "#FFFFFF",
          fontSize: 28,
          fontWeight: "900",
          textAlign: "center",
          lineHeight: 36,
        }}
      />
    </View>
  );
};
