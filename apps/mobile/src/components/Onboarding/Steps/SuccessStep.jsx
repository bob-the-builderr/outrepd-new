import React from "react";
import { View, Text, TouchableOpacity, ActivityIndicator } from "react-native";
import { Image } from "expo-image";
import { LinearGradient } from "expo-linear-gradient";
import Svg, {
  Text as SvgText,
  Defs,
  LinearGradient as SvgLinearGradient,
  Stop,
} from "react-native-svg";
import { ONBOARDING_IMAGES } from "@/constants/onboardingImages";

export const SuccessStep = ({ loading, onFinish }) => {
  return (
    <View
      style={{
        flex: 1,
        justifyContent: "center",
        alignItems: "center",
        paddingHorizontal: 24,
      }}
    >
      {/* App Logo */}
      <View
        style={{
          marginBottom: 48,
          alignItems: "center",
        }}
      >
        <Image
          source={ONBOARDING_IMAGES.logo}
          style={{ width: 100, height: 100 }}
          contentFit="contain"
          cachePolicy="disk"
        />
      </View>

      {/* Main text with gradient "3 days free" */}
      <View style={{ alignItems: "center", marginBottom: 60 }}>
        <Text
          style={{
            color: "#FFFFFF",
            fontSize: 28,
            fontWeight: "800",
            textAlign: "center",
            lineHeight: 40,
          }}
        >
          We offer
        </Text>

        <Svg height={44} width={260}>
          <Defs>
            <SvgLinearGradient id="blueGrad" x1="0" y1="0" x2="1" y2="0">
              <Stop offset="0" stopColor="#1A8CFF" />
              <Stop offset="0.5" stopColor="#4BB8FA" />
              <Stop offset="1" stopColor="#7DD4FF" />
            </SvgLinearGradient>
          </Defs>
          <SvgText
            fill="url(#blueGrad)"
            fontSize="30"
            fontWeight="900"
            x="130"
            y="33"
            textAnchor="middle"
          >
            3 days free
          </SvgText>
        </Svg>

        <Text
          style={{
            color: "#FFFFFF",
            fontSize: 28,
            fontWeight: "800",
            textAlign: "center",
            lineHeight: 40,
          }}
        >
          so you can try OUTREPD
        </Text>
      </View>

      {/* CTA Button */}
      <TouchableOpacity
        onPress={onFinish}
        disabled={loading}
        activeOpacity={0.85}
        style={{
          width: "100%",
          borderRadius: 16,
          overflow: "hidden",
          opacity: loading ? 0.7 : 1,
          shadowColor: "#4BB8FA",
          shadowOffset: { width: 0, height: 6 },
          shadowOpacity: 0.35,
          shadowRadius: 12,
          elevation: 8,
        }}
      >
        <LinearGradient
          colors={["#1A8CFF", "#4BB8FA"]}
          start={{ x: 0, y: 0 }}
          end={{ x: 1, y: 0 }}
          style={{
            paddingVertical: 18,
            alignItems: "center",
            justifyContent: "center",
            borderRadius: 16,
          }}
        >
          {loading ? (
            <ActivityIndicator color="#000" />
          ) : (
            <Text
              style={{
                color: "#000000",
                fontSize: 18,
                fontWeight: "900",
                letterSpacing: 1.5,
              }}
            >
              TRY FOR FREE
            </Text>
          )}
        </LinearGradient>
      </TouchableOpacity>
    </View>
  );
};