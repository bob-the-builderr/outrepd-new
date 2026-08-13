import React from "react";
import { View, Text, TouchableOpacity, FlatList } from "react-native";
import {
  HEIGHT_TICK_HEIGHT,
  SCREEN_HEIGHT,
} from "@/constants/onboardingDimensions";

export const HeightStep = ({
  heightCm,
  heightFeet,
  heightInches,
  heightUnit,
  heightRulerHeight,
  heightScrollRef,
  onHeightScroll,
  onHeightPress,
  onSetHeightUnit,
  onHeightRulerLayout,
}) => {
  let heightData;
  let displayValue;
  let displayUnit;

  if (heightUnit === "cm") {
    const minH = 100;
    const maxH = 250;
    heightData = Array.from(
      { length: (maxH - minH) * 2 + 1 },
      (_, i) => minH + i * 0.5,
    );
    const val = parseFloat(heightCm) || 178;
    displayValue = Math.round(val).toString();
    displayUnit = "cm";
  } else {
    const minH = 36; // 3ft
    const maxH = 96; // 8ft
    heightData = Array.from(
      { length: (maxH - minH) * 2 + 1 },
      (_, i) => minH + i * 0.5,
    );
    const ft = parseInt(heightFeet) || 5;
    const inch = parseInt(heightInches) || 10;
    displayValue = `${ft}'${inch}"`;
    displayUnit = "ft";
  }

  const heightRulerPadding = heightRulerHeight / 2 - HEIGHT_TICK_HEIGHT / 2;

  return (
    <View style={{ flex: 1 }}>
      <Text
        style={{
          color: "#FFFFFF",
          fontSize: 30,
          fontWeight: "900",
          textAlign: "center",
          marginBottom: 24,
          lineHeight: 36,
        }}
      >
        How tall are you?
      </Text>

      {/* Unit Toggle Pill */}
      <View
        style={{
          flexDirection: "row",
          backgroundColor: "#111111",
          borderRadius: 24,
          padding: 4,
          width: 180,
          alignSelf: "center",
          marginBottom: 24,
        }}
      >
        <TouchableOpacity
          onPress={() => onSetHeightUnit("ft")}
          activeOpacity={0.8}
          style={{
            flex: 1,
            paddingVertical: 10,
            borderRadius: 20,
            backgroundColor: heightUnit === "ft" ? "#4BB8FA" : "transparent",
            alignItems: "center",
          }}
        >
          <Text
            style={{
              color: "#FFFFFF",
              fontSize: 16,
              fontWeight: "700",
            }}
          >
            ft/in
          </Text>
        </TouchableOpacity>

        <TouchableOpacity
          onPress={() => onSetHeightUnit("cm")}
          activeOpacity={0.8}
          style={{
            flex: 1,
            paddingVertical: 10,
            borderRadius: 20,
            backgroundColor: heightUnit === "cm" ? "#4BB8FA" : "transparent",
            alignItems: "center",
          }}
        >
          <Text
            style={{
              color: "#FFFFFF",
              fontSize: 16,
              fontWeight: "700",
            }}
          >
            cm
          </Text>
        </TouchableOpacity>
      </View>

      {/* Main content: Display + Ruler */}
      <View
        style={{
          height: SCREEN_HEIGHT * 0.55,
          justifyContent: "center",
          alignItems: "center",
          position: "relative",
        }}
      >
        {/* Large display value */}
        <View
          style={{
            justifyContent: "center",
            alignItems: "center",
          }}
        >
          <View style={{ position: "relative" }}>
            <Text
              style={{
                color: "#FFFFFF",
                fontSize: 64,
                fontWeight: "900",
              }}
            >
              {displayValue}
            </Text>
            <Text
              style={{
                position: "absolute",
                left: "100%",
                bottom: 12,
                marginLeft: 6,
                color: "#888888",
                fontSize: 20,
                fontWeight: "700",
              }}
            >
              {displayUnit}
            </Text>
          </View>
        </View>

        {/* Right side: Vertical Ruler */}
        <View
          onLayout={onHeightRulerLayout}
          style={{
            position: "absolute",
            right: 0,
            width: 60,
            height: SCREEN_HEIGHT * 0.55,
            justifyContent: "center",
            alignItems: "center",
          }}
        >
          <FlatList
            ref={heightScrollRef}
            data={heightData}
            showsVerticalScrollIndicator={false}
            snapToInterval={HEIGHT_TICK_HEIGHT}
            snapToAlignment="center"
            decelerationRate="fast"
            disableIntervalMomentum={false}
            scrollEventThrottle={16}
            onScroll={onHeightScroll}
            ListHeaderComponent={
              <View style={{ height: heightRulerPadding }} />
            }
            ListFooterComponent={
              <View style={{ height: heightRulerPadding }} />
            }
            getItemLayout={(data, index) => ({
              length: HEIGHT_TICK_HEIGHT,
              offset: HEIGHT_TICK_HEIGHT * index,
              index,
            })}
            keyExtractor={(item) => item.toString()}
            renderItem={({ item }) => {
              const isInteger = item % 1 === 0;
              return (
                <TouchableOpacity
                  activeOpacity={0.8}
                  onPress={() => onHeightPress(item)}
                  style={{
                    width: 60,
                    height: HEIGHT_TICK_HEIGHT,
                    justifyContent: "center",
                    alignItems: "flex-end",
                  }}
                >
                  <View
                    style={{
                      height: 2,
                      width: isInteger ? 35 : 18,
                      backgroundColor: isInteger
                        ? "rgba(255, 255, 255, 0.6)"
                        : "rgba(255, 255, 255, 0.3)",
                      borderRadius: 1,
                    }}
                  />
                </TouchableOpacity>
              );
            }}
          />

          {/* Fixed Center Blue Indicator */}
          <View
            pointerEvents="none"
            style={{
              position: "absolute",
              width: 55,
              height: 3,
              backgroundColor: "#4BB8FA",
              borderRadius: 1.5,
              top: heightRulerHeight / 2 - 1.5,
              right: 0,
            }}
          />
        </View>
      </View>
    </View>
  );
};
