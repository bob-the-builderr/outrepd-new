import React from "react";
import {
  View,
  Text,
  Pressable,
  ActivityIndicator,
  Animated,
} from "react-native";
import { Image } from "expo-image";
import Svg, { Circle } from "react-native-svg";
import { LOGO_URL } from "@/constants/onboarding";

const AnimatedCircle = Animated.createAnimatedComponent(Circle);

export const CommitmentStep = ({
  loading,
  isHolding,
  holdProgress,
  onPressIn,
  onPressOut,
}) => {
  const radius = 90;
  const circumference = 2 * Math.PI * radius;

  return (
    <View
      style={{
        flex: 1,
        justifyContent: "center",
        alignItems: "center",
        paddingTop: 40,
      }}
    >
      <Text
        style={{
          color: "#FFFFFF",
          fontSize: 28,
          fontWeight: "900",
          textAlign: "center",
          marginBottom: 16,
          lineHeight: 34,
          paddingHorizontal: 20,
        }}
      >
        Now let's make a commitment to your fitness journey
      </Text>

      <Text
        style={{
          color: "#888",
          fontSize: 16,
          textAlign: "center",
          marginBottom: 60,
          paddingHorizontal: 20,
        }}
      >
        Hold the logo to confirm you're ready
      </Text>

      <Pressable
        onPressIn={onPressIn}
        onPressOut={onPressOut}
        disabled={loading}
        style={{
          width: 200,
          height: 200,
          justifyContent: "center",
          alignItems: "center",
        }}
      >
        <Svg
          width={200}
          height={200}
          style={{
            position: "absolute",
            transform: [{ rotate: "-90deg" }],
          }}
        >
          <Circle
            cx={100}
            cy={100}
            r={radius}
            stroke="#1C1C1C"
            strokeWidth={8}
            fill="none"
          />
          <AnimatedCircle
            cx={100}
            cy={100}
            r={radius}
            stroke="#4BB8FA"
            strokeWidth={8}
            fill="none"
            strokeDasharray={circumference}
            strokeDashoffset={holdProgress.interpolate({
              inputRange: [0, 1],
              outputRange: [circumference, 0],
            })}
            strokeLinecap="round"
          />
        </Svg>

        <View
          style={{
            width: 140,
            height: 140,
            borderRadius: 70,
            backgroundColor: "#111111",
            justifyContent: "center",
            alignItems: "center",
            shadowColor: "#4BB8FA",
            shadowOffset: { width: 0, height: 4 },
            shadowOpacity: isHolding ? 0.4 : 0.15,
            shadowRadius: isHolding ? 16 : 8,
            elevation: 8,
          }}
        >
          {loading ? (
            <ActivityIndicator color="#4BB8FA" size="large" />
          ) : (
            <Image
              source={{ uri: LOGO_URL }}
              style={{ width: 80, height: 80 }}
              contentFit="contain"
            />
          )}
        </View>
      </Pressable>

      <Text
        style={{
          color: "#555",
          fontSize: 14,
          textAlign: "center",
          marginTop: 40,
        }}
      >
        {isHolding ? "Keep holding..." : "Press and hold"}
      </Text>
    </View>
  );
};
