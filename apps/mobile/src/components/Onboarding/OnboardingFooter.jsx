import React from "react";
import {
  View,
  Text,
  TouchableOpacity,
  ActivityIndicator,
  Animated,
} from "react-native";

export const OnboardingFooter = ({
  step,
  loading,
  typingComplete,
  buttonFadeAnim,
  onNext,
  canProceed = true,
}) => {
  const isDisabled = loading || !typingComplete || !canProceed;

  return (
    <Animated.View
      style={{
        opacity: buttonFadeAnim,
        paddingHorizontal: 24,
        paddingBottom: 20,
        gap: 12,
      }}
    >
      <TouchableOpacity
        onPress={onNext}
        disabled={isDisabled}
        activeOpacity={0.85}
        style={{
          backgroundColor: isDisabled ? "#1A2A3A" : "#4BB8FA",
          borderRadius: 16,
          paddingVertical: 18,
          alignItems: "center",
          opacity: isDisabled ? 0.5 : 1,
          shadowColor: "#4BB8FA",
          shadowOffset: { width: 0, height: 4 },
          shadowOpacity: isDisabled ? 0 : 0.25,
          shadowRadius: 8,
          elevation: isDisabled ? 0 : 5,
        }}
      >
        {loading ? (
          <ActivityIndicator color="#000" />
        ) : (
          <Text
            style={{
              color: isDisabled ? "#556070" : "#000000",
              fontSize: 18,
              fontWeight: "800",
              letterSpacing: 0.5,
            }}
          >
            {step === 9 ? "LET'S GO!" : "NEXT"}
          </Text>
        )}
      </TouchableOpacity>
    </Animated.View>
  );
};
