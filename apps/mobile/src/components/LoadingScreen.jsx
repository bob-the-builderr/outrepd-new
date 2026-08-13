import React, { useEffect, useRef } from "react";
import { View, Text, Animated, Easing } from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { Dumbbell } from "lucide-react-native";

export default function LoadingScreen({
  message = "Loading...",
  steps = null,
  currentStep = 0,
}) {
  const insets = useSafeAreaInsets();
  const rotateAnim = useRef(new Animated.Value(0)).current;
  const barWidth = useRef(new Animated.Value(0)).current;

  // Compute target progress (0–100)
  const totalSteps = steps && steps.length > 0 ? steps.length : 1;
  const targetProgress = Math.round(((currentStep + 1) / totalSteps) * 100);

  useEffect(() => {
    // Continuous dumbbell rotation
    Animated.loop(
      Animated.timing(rotateAnim, {
        toValue: 1,
        duration: 1500,
        easing: Easing.linear,
        useNativeDriver: true,
      }),
    ).start();
  }, []);

  // Animate progress bar whenever step changes
  useEffect(() => {
    Animated.timing(barWidth, {
      toValue: targetProgress,
      duration: 600,
      easing: Easing.out(Easing.cubic),
      useNativeDriver: false,
    }).start();
  }, [targetProgress]);

  const rotate = rotateAnim.interpolate({
    inputRange: [0, 1],
    outputRange: ["0deg", "360deg"],
  });

  return (
    <View style={{ flex: 1, backgroundColor: "#010308" }}>
      {/* Spinning dumbbell — centered */}
      <View style={{ flex: 1, justifyContent: "center", alignItems: "center" }}>
        <Animated.View style={{ transform: [{ rotate }] }}>
          <Dumbbell color="#4BB8FA" size={64} strokeWidth={2.5} />
        </Animated.View>
      </View>

      {/* Progress bar — pinned to the bottom */}
      <View
        style={{
          paddingHorizontal: 32,
          paddingBottom: insets.bottom + 32,
        }}
      >
        <View
          style={{
            width: "100%",
            height: 4,
            backgroundColor: "#1A2230",
            borderRadius: 4,
            overflow: "hidden",
            marginBottom: 10,
          }}
        >
          <Animated.View
            style={{
              height: "100%",
              backgroundColor: "#4BB8FA",
              borderRadius: 4,
              width: barWidth.interpolate({
                inputRange: [0, 100],
                outputRange: ["0%", "100%"],
              }),
            }}
          />
        </View>

        <Text
          style={{
            color: "#3A6080",
            fontSize: 13,
            fontWeight: "600",
            letterSpacing: 1,
            textAlign: "center",
          }}
        >
          {targetProgress}%
        </Text>
      </View>
    </View>
  );
}
