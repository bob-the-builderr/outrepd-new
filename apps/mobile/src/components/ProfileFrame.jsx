import React from "react";
import { View, Text } from "react-native";
import { Image } from "expo-image";
import { TIERS } from "@/constants/tiers";

/**
 * ProfileFrame
 *
 * Renders a circular profile photo with the tier-appropriate frame PNG
 * overlaid on top.
 *
 * Props:
 *  - size        {number}  Diameter of the inner photo circle (default 100)
 *  - tierIdx     {number}  Index into TIERS array
 *  - photoUrl    {string}  URL of the user's profile photo (optional)
 *  - fallbackIcon {string} Emoji to show if no photo (optional)
 *  - glow        {boolean} Whether to show the tier color glow (default true)
 */
export function ProfileFrame({
  size = 100,
  tierIdx = 0,
  photoUrl,
  fallbackIcon,
  glow = true,
}) {
  const clampedIdx = Math.min(Math.max(tierIdx || 0, 0), TIERS.length - 1);
  const tier = TIERS[clampedIdx];

  // Frame image is rendered larger than the photo so the ornamental
  // parts (wings, spikes, jewels) extend visually beyond the circle.
  const frameSize = size * 1.55;
  const frameOffset = (frameSize - size) / 2;

  return (
    <View
      style={{
        width: size,
        height: size,
        // Extra space so the frame doesn't get clipped by parent overflow
        // We use margin so siblings aren't shifted
        marginHorizontal: frameOffset,
        marginBottom: frameOffset * 0.4,
      }}
    >
      {/* Glow shadow ring */}
      {glow && (
        <View
          style={{
            position: "absolute",
            width: size,
            height: size,
            borderRadius: size / 2,
            shadowColor: tier.color,
            shadowOffset: { width: 0, height: 0 },
            shadowOpacity: 0.65,
            shadowRadius: 14,
            elevation: 10,
            backgroundColor: "transparent",
          }}
        />
      )}

      {/* Profile photo — circular clip */}
      <View
        style={{
          width: size,
          height: size,
          borderRadius: size / 2,
          backgroundColor: "#0D1218",
          overflow: "hidden",
          alignItems: "center",
          justifyContent: "center",
        }}
      >
        {photoUrl ? (
          <Image
            source={{ uri: photoUrl }}
            style={{ width: "100%", height: "100%" }}
            contentFit="cover"
          />
        ) : (
          <Text style={{ fontSize: size * 0.42 }}>
            {fallbackIcon || tier.icon}
          </Text>
        )}
      </View>

      {/* Frame PNG — overlaid absolutely, centred, larger than the photo */}
      {tier.frame && (
        <Image
          source={{ uri: tier.frame }}
          style={{
            position: "absolute",
            width: frameSize,
            height: frameSize,
            top: -frameOffset,
            left: -frameOffset,
            pointerEvents: "none",
          }}
          contentFit="contain"
        />
      )}
    </View>
  );
}
