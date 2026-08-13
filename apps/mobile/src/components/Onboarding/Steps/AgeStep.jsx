import React from "react";
import { View, Text, TouchableOpacity, FlatList } from "react-native";
import { ITEM_HEIGHT, AGES_LIST } from "@/constants/onboardingDimensions";

export const AgeStep = ({
  selectedAge,
  ageScrollRef,
  onScroll,
  onAgePress,
}) => {
  return (
    <View style={{ flex: 1, alignItems: "center" }}>
      <Text
        style={{
          color: "#FFFFFF",
          fontSize: 30,
          fontWeight: "900",
          textAlign: "center",
          marginBottom: 40,
          lineHeight: 36,
        }}
      >
        How old are you?
      </Text>

      <View
        style={{
          height: ITEM_HEIGHT * 7,
          width: "100%",
          justifyContent: "center",
          alignItems: "center",
          position: "relative",
        }}
      >
        {/* Selection Pill overlay */}
        <View
          pointerEvents="none"
          style={{
            position: "absolute",
            top: ITEM_HEIGHT * 3,
            height: ITEM_HEIGHT,
            width: "85%",
            borderWidth: 2.5,
            borderColor: "#4BB8FA",
            borderRadius: 30,
            backgroundColor: "rgba(28, 28, 28, 0.4)",
            shadowColor: "#4BB8FA",
            shadowOffset: { width: 0, height: 0 },
            shadowOpacity: 0.15,
            shadowRadius: 10,
            elevation: 2,
          }}
        />

        <FlatList
          ref={ageScrollRef}
          data={AGES_LIST}
          keyExtractor={(item, index) => index.toString()}
          snapToInterval={ITEM_HEIGHT}
          decelerationRate="fast"
          showsVerticalScrollIndicator={false}
          style={{ height: ITEM_HEIGHT * 7, width: "100%" }}
          contentContainerStyle={{ paddingVertical: 0 }}
          getItemLayout={(data, index) => ({
            length: ITEM_HEIGHT,
            offset: ITEM_HEIGHT * index,
            index,
          })}
          onScroll={onScroll}
          scrollEventThrottle={16}
          renderItem={({ item }) => {
            if (item === null) {
              return <View style={{ height: ITEM_HEIGHT }} />;
            }

            const isSelected = selectedAge === item;
            const diff = Math.abs(item - selectedAge);

            let fontSize = 16;
            let color = "#333333";
            let fontWeight = "500";

            if (diff === 0) {
              fontSize = 38;
              color = "#4BB8FA";
              fontWeight = "900";
            } else if (diff === 1) {
              fontSize = 24;
              color = "#888888";
              fontWeight = "700";
            } else if (diff === 2) {
              fontSize = 18;
              color = "#555555";
              fontWeight = "600";
            } else if (diff === 3) {
              fontSize = 13;
              color = "#333333";
              fontWeight = "500";
            } else {
              fontSize = 11;
              color = "#222222";
              fontWeight = "400";
            }

            return (
              <TouchableOpacity
                activeOpacity={0.8}
                onPress={() => onAgePress(item)}
                style={{
                  height: ITEM_HEIGHT,
                  justifyContent: "center",
                  alignItems: "center",
                }}
              >
                <Text
                  style={{
                    fontSize,
                    color,
                    fontWeight,
                    textAlign: "center",
                  }}
                >
                  {item}
                </Text>
              </TouchableOpacity>
            );
          }}
        />
      </View>
    </View>
  );
};
