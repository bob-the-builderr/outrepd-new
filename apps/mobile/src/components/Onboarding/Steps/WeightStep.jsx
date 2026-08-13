import React from "react";
import { View, Text, TouchableOpacity, FlatList } from "react-native";
import { TICK_WIDTH } from "@/constants/onboardingDimensions";

export const WeightStep = ({
  weightKg,
  weightUnit,
  rulerWidth,
  weightScrollRef,
  onWeightScroll,
  onWeightPress,
  onSetWeightUnit,
  onRulerLayout,
}) => {
  const minWeight = weightUnit === "kg" ? 30 : 70;
  const maxWeight = weightUnit === "kg" ? 220 : 480;
  const weightData = Array.from(
    { length: (maxWeight - minWeight) * 2 + 1 },
    (_, i) => minWeight + i * 0.5,
  );
  const parsedWeight = parseFloat(weightKg) || (weightUnit === "kg" ? 70 : 154);
  const rulerPadding = rulerWidth / 2 - TICK_WIDTH / 2;

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
        What's your current weight?
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
          marginBottom: 48,
        }}
      >
        <TouchableOpacity
          onPress={() => onSetWeightUnit("kg")}
          activeOpacity={0.8}
          style={{
            flex: 1,
            paddingVertical: 10,
            borderRadius: 20,
            backgroundColor: weightUnit === "kg" ? "#4BB8FA" : "transparent",
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
            kg
          </Text>
        </TouchableOpacity>

        <TouchableOpacity
          onPress={() => onSetWeightUnit("lbs")}
          activeOpacity={0.8}
          style={{
            flex: 1,
            paddingVertical: 10,
            borderRadius: 20,
            backgroundColor: weightUnit === "lbs" ? "#4BB8FA" : "transparent",
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
            lbs
          </Text>
        </TouchableOpacity>
      </View>

      {/* Large Display Value */}
      <View
        style={{
          flexDirection: "row",
          justifyContent: "center",
          alignItems: "center",
          marginBottom: 40,
        }}
      >
        <View style={{ position: "relative" }}>
          <Text
            style={{
              color: "#FFFFFF",
              fontSize: 64,
              fontWeight: "900",
              textAlign: "center",
            }}
          >
            {parsedWeight.toFixed(1)}
          </Text>
          <Text
            style={{
              position: "absolute",
              left: "100%",
              bottom: 12,
              marginLeft: 8,
              color: "#888888",
              fontSize: 20,
              fontWeight: "700",
            }}
          >
            {weightUnit}
          </Text>
        </View>
      </View>

      {/* Ruler Selector Container */}
      <View
        onLayout={onRulerLayout}
        style={{
          height: 100,
          width: "100%",
          justifyContent: "center",
          alignItems: "center",
          position: "relative",
          marginBottom: 48,
        }}
      >
        <FlatList
          ref={weightScrollRef}
          data={weightData}
          horizontal
          showsHorizontalScrollIndicator={false}
          snapToInterval={TICK_WIDTH}
          snapToAlignment="center"
          decelerationRate="fast"
          disableIntervalMomentum={false}
          scrollEventThrottle={16}
          onScroll={onWeightScroll}
          ListHeaderComponent={<View style={{ width: rulerPadding }} />}
          ListFooterComponent={<View style={{ width: rulerPadding }} />}
          getItemLayout={(data, index) => ({
            length: TICK_WIDTH,
            offset: TICK_WIDTH * index,
            index,
          })}
          keyExtractor={(item) => item.toString()}
          renderItem={({ item }) => {
            const isInteger = item % 1 === 0;
            return (
              <TouchableOpacity
                activeOpacity={0.8}
                onPress={() => onWeightPress(item)}
                style={{
                  width: TICK_WIDTH,
                  height: 60,
                  justifyContent: "center",
                  alignItems: "center",
                }}
              >
                <View
                  style={{
                    width: 2,
                    height: isInteger ? 35 : 18,
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
            height: 55,
            width: 3,
            backgroundColor: "#4BB8FA",
            borderRadius: 1.5,
            left: rulerWidth / 2 - 1.5,
          }}
        />
      </View>

      {/* Private Info Card */}
      <View
        style={{
          backgroundColor: "#111111",
          borderRadius: 20,
          padding: 20,
          width: "100%",
          gap: 8,
        }}
      >
        <Text
          style={{
            color: "#888888",
            fontSize: 14,
            fontWeight: "600",
            textAlign: "left",
            lineHeight: 20,
          }}
        >
          Your information is private and will not be shared with anyone.
        </Text>
        <Text
          style={{
            color: "#888888",
            fontSize: 14,
            fontWeight: "600",
            textAlign: "left",
            lineHeight: 20,
          }}
        >
          Body weight is essential to calculate your rank.
        </Text>
      </View>
    </View>
  );
};
