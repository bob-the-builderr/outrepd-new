import React, { useState } from "react";
import { View, Animated } from "react-native";
import { Image } from "expo-image";
import { TypewriterText } from "@/components/Onboarding/TypewriterText";
import { SCREEN_WIDTH, SCREEN_HEIGHT } from "@/constants/onboardingDimensions";
import { ONBOARDING_IMAGES } from "@/constants/onboardingImages";

export const MountainTransitionStep = ({
  headline,
  subtext,
  onComplete,
  buttonFadeAnim,
}) => {
  const [headlineFinished, setHeadlineFinished] = useState(false);

  return (
    <>
      {/* Mountain background */}
      <View
        style={{
          position: "absolute",
          bottom: 0,
          left: 0,
          right: 0,
          height: SCREEN_HEIGHT * 0.5,
          zIndex: 0,
        }}
      >
        <Image
          source={{ uri: ONBOARDING_IMAGES.mountain }}
          style={{ width: "100%", height: "100%" }}
          contentFit="cover"
          contentPosition="top"
          cachePolicy="disk"
        />
      </View>

      {/* Badge icon above mountain */}
      <View
        style={{
          position: "absolute",
          bottom: SCREEN_HEIGHT * 0.5 - 100,
          left: 0,
          right: 0,
          alignItems: "center",
          zIndex: 1,
        }}
      >
        <Image
          source={{ uri: ONBOARDING_IMAGES.legend }}
          style={{ width: 200, height: 200 }}
          contentFit="contain"
          cachePolicy="disk"
        />
      </View>

      {/* Text content */}
      <View
        style={{
          flex: 1,
          paddingHorizontal: 20,
          alignItems: "center",
          justifyContent: "space-between",
          minHeight: SCREEN_HEIGHT * 0.62,
          position: "relative",
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
      </View>
    </>
  );
};
