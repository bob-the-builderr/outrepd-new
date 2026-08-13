import React, { useRef, useEffect } from "react";
import {
  View,
  Text,
  Modal,
  TouchableOpacity,
  Animated as RNAnimated,
} from "react-native";
import { Image } from "expo-image";
import { TIERS, NEEDS_WHITE_TEXT, DIVISION_NAMES } from "@/constants/tiers";

const PARTICLE_COUNT = 14;

export const PromotionCeremony = ({ visible, tierIdx, divIdx, onContinue }) => {
  const scaleAnim = useRef(new RNAnimated.Value(0)).current;
  const opacityAnim = useRef(new RNAnimated.Value(0)).current;
  const glowRadius = useRef(new RNAnimated.Value(0)).current;

  const particles = useRef(
    Array.from({ length: PARTICLE_COUNT }, () => ({
      x: new RNAnimated.Value(0),
      y: new RNAnimated.Value(0),
      opacity: new RNAnimated.Value(0),
      scale: new RNAnimated.Value(0),
    })),
  ).current;

  useEffect(() => {
    if (!visible) {
      scaleAnim.setValue(0);
      opacityAnim.setValue(0);
      glowRadius.setValue(0);
      particles.forEach((p) => {
        p.x.setValue(0);
        p.y.setValue(0);
        p.opacity.setValue(0);
        p.scale.setValue(0);
      });
      return;
    }

    RNAnimated.timing(opacityAnim, {
      toValue: 1,
      duration: 350,
      useNativeDriver: true,
    }).start();

    RNAnimated.sequence([
      RNAnimated.delay(250),
      RNAnimated.spring(scaleAnim, {
        toValue: 1,
        tension: 45,
        friction: 5,
        useNativeDriver: true,
      }),
    ]).start();

    RNAnimated.sequence([
      RNAnimated.delay(600),
      RNAnimated.loop(
        RNAnimated.sequence([
          RNAnimated.timing(glowRadius, {
            toValue: 1,
            duration: 900,
            useNativeDriver: true,
          }),
          RNAnimated.timing(glowRadius, {
            toValue: 0.2,
            duration: 900,
            useNativeDriver: true,
          }),
        ]),
      ),
    ]).start();

    particles.forEach((p, i) => {
      const angle = (i / PARTICLE_COUNT) * Math.PI * 2;
      const dist = 85 + (i % 3) * 35;
      const size = i % 3 === 0 ? 1 : i % 3 === 1 ? 0.7 : 0.5;
      RNAnimated.sequence([
        RNAnimated.delay(280 + i * 25),
        RNAnimated.parallel([
          RNAnimated.timing(p.opacity, {
            toValue: 1,
            duration: 180,
            useNativeDriver: true,
          }),
          RNAnimated.timing(p.scale, {
            toValue: size,
            duration: 200,
            useNativeDriver: true,
          }),
          RNAnimated.timing(p.x, {
            toValue: Math.cos(angle) * dist,
            duration: 650,
            useNativeDriver: true,
          }),
          RNAnimated.timing(p.y, {
            toValue: Math.sin(angle) * dist,
            duration: 650,
            useNativeDriver: true,
          }),
        ]),
        RNAnimated.timing(p.opacity, {
          toValue: 0,
          duration: 400,
          useNativeDriver: true,
        }),
      ]).start();
    });
  }, [visible]);

  if (!visible) return null;
  const tier = TIERS[Math.min(tierIdx, 8)];
  const divName = DIVISION_NAMES[Math.min(divIdx, 3)];
  const btnTextColor = NEEDS_WHITE_TEXT.includes(tier.color) ? "#FFF" : "#000";

  return (
    <Modal visible={visible} transparent animationType="none">
      <RNAnimated.View
        style={{
          flex: 1,
          backgroundColor: "rgba(0,0,0,0.96)",
          justifyContent: "center",
          alignItems: "center",
          opacity: opacityAnim,
        }}
      >
        {/* Particle burst */}
        {particles.map((p, i) => (
          <RNAnimated.View
            key={`p${i}`}
            style={{
              position: "absolute",
              width: i % 3 === 0 ? 14 : i % 3 === 1 ? 10 : 6,
              height: i % 3 === 0 ? 14 : i % 3 === 1 ? 10 : 6,
              borderRadius: 7,
              backgroundColor: i % 2 === 0 ? tier.color : "#FFFFFF",
              transform: [
                { translateX: p.x },
                { translateY: p.y },
                { scale: p.scale },
              ],
              opacity: p.opacity,
            }}
          />
        ))}

        {/* Badge (Replaced circle with image + glow) */}
        <RNAnimated.View
          style={{
            transform: [{ scale: scaleAnim }],
            alignItems: "center",
            shadowColor: tier.color,
            shadowOffset: { width: 0, height: 0 },
            shadowOpacity: 0.8,
            shadowRadius: 40,
            elevation: 10,
          }}
        >
          <Image
            source={{ uri: tier.img }}
            style={{ width: 350, height: 350 }}
            contentFit="contain"
            cachePolicy="memory-disk"
          />
        </RNAnimated.View>

        <Text
          style={{
            color: "#666",
            fontSize: 13,
            fontWeight: "800",
            marginTop: 0,
            letterSpacing: 5,
          }}
        >
          RANK UP
        </Text>
        <Text
          style={{
            color: "#FFF",
            fontSize: 26,
            fontWeight: "900",
            marginTop: 6,
          }}
        >
          PROMOTED TO
        </Text>
        <Text
          style={{
            color: tier.color,
            fontSize: 44,
            fontWeight: "900",
            marginTop: 4,
            textShadowColor: tier.color,
            textShadowOffset: { width: 0, height: 0 },
            textShadowRadius: 22,
          }}
        >
          {tier.name} {divName}
        </Text>

        <View
          style={{
            marginTop: 20,
            backgroundColor: "#131313",
            paddingHorizontal: 22,
            paddingVertical: 11,
            borderRadius: 14,
            borderWidth: 1,
            borderColor: tier.color + "44",
          }}
        >
          <Text style={{ color: tier.color, fontWeight: "700", fontSize: 13 }}>
            🏆 {tier.reward} unlocked!
          </Text>
        </View>

        <TouchableOpacity
          onPress={onContinue}
          style={{
            marginTop: 52,
            backgroundColor: "#4BB8FA",
            paddingHorizontal: 58,
            paddingVertical: 20,
            borderRadius: 22,
          }}
        >
          <Text
            style={{
              color: "#000",
              fontWeight: "900",
              fontSize: 18,
              letterSpacing: 1,
            }}
          >
            CONTINUE
          </Text>
        </TouchableOpacity>
      </RNAnimated.View>
    </Modal>
  );
};
