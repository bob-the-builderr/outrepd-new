import React, { useState } from "react";
import { View, Animated } from "react-native";
import { Image } from "expo-image";
import { TypewriterText } from "@/components/Onboarding/TypewriterText";
import { SCREEN_WIDTH, SCREEN_HEIGHT } from "@/constants/onboardingDimensions";

export const ImageTransitionStep = ({
  headline,
  subtext,
  imageUrl,
  onComplete,
  buttonFadeAnim,
}) => {
  const [headlineFinished, setHeadlineFinished] = useState(false);

  return (
    <View
      style={{
        flex: 1,
        paddingHorizontal: 20,
        alignItems: "center",
        justifyContent: "space-between",
        minHeight: SCREEN_HEIGHT * 0.62,
      }}
    >
      <View style={{ alignItems: "center", width: "100%", height: 170 }}>
        <TypewriterText
          text={headline}
          onComplete={() => setHeadlineFinished(true)}
          style={{
            color: "#FFFFFF",
            fontSize: 28,
            fontWeight: "900",
            textAlign: "center",
            lineHeight: 36,
            marginBottom: 12,
          }}
        />
        {headlineFinished && (
          <TypewriterText
            text={subtext}
            onComplete={() => {
              onComplete();
              Animated.timing(buttonFadeAnim, {
                toValue: 1,
                duration: 300,
                useNativeDriver: true,
              }).start();
            }}
            style={{
              color: "#888888",
              fontSize: 16,
              fontWeight: "600",
              textAlign: "center",
              lineHeight: 24,
            }}
          />
        )}
      </View>

      <View
        style={{
          flex: 1,
          justifyContent: "center",
          alignItems: "center",
          marginVertical: 16,
        }}
      >
        <Image
          source={imageUrl}
          style={{
            width: SCREEN_WIDTH * 0.72,
            height: SCREEN_WIDTH * 0.72,
          }}
          contentFit="contain"
          cachePolicy="disk"
        />
      </View>
    </View>
  );
};
