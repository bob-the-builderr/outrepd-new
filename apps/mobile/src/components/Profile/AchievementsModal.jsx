import React from "react";
import { View, Text, ScrollView, TouchableOpacity, Modal } from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { StatusBar } from "expo-status-bar";
import { Lock, X } from "lucide-react-native";
import { CATEGORY_TITLES } from "@/constants/achievements";

export function AchievementsModal({ visible, onClose, achievements }) {
  const insets = useSafeAreaInsets();
  const earnedCount = achievements.filter((a) => a.earned).length;

  const grouped = achievements.reduce((acc, a) => {
    const cat = a.category || "other";
    if (!acc[cat]) acc[cat] = [];
    acc[cat].push(a);
    return acc;
  }, {});

  return (
    <Modal
      visible={visible}
      animationType="slide"
      presentationStyle="pageSheet"
      onRequestClose={onClose}
    >
      <View style={{ flex: 1, backgroundColor: "#010308" }}>
        <StatusBar style="light" />
        <View
          style={{
            paddingTop: insets.top + 16,
            paddingHorizontal: 20,
            paddingBottom: 16,
            borderBottomWidth: 1,
            borderBottomColor: "#1A2630",
            flexDirection: "row",
            alignItems: "center",
            justifyContent: "space-between",
          }}
        >
          <View>
            <Text
              style={{
                color: "#FFF",
                fontSize: 22,
                fontWeight: "900",
                letterSpacing: 1,
              }}
            >
              ACHIEVEMENTS
            </Text>
            <Text style={{ color: "#4BB8FA", fontSize: 13, marginTop: 2 }}>
              {earnedCount} of {achievements.length} unlocked
            </Text>
          </View>
          <TouchableOpacity
            onPress={onClose}
            style={{
              backgroundColor: "#1A2630",
              borderRadius: 20,
              width: 36,
              height: 36,
              alignItems: "center",
              justifyContent: "center",
            }}
          >
            <X size={18} color="#888" />
          </TouchableOpacity>
        </View>

        <ScrollView
          contentContainerStyle={{ paddingBottom: insets.bottom + 24 }}
          showsVerticalScrollIndicator={false}
        >
          {Object.keys(grouped).map((category) => (
            <View
              key={category}
              style={{ paddingHorizontal: 20, paddingTop: 24 }}
            >
              <Text
                style={{
                  color: "#555",
                  fontSize: 11,
                  fontWeight: "700",
                  letterSpacing: 1,
                  marginBottom: 12,
                }}
              >
                {CATEGORY_TITLES[category] || category.toUpperCase()}
              </Text>
              {grouped[category].map((achievement) => (
                <View
                  key={achievement.id}
                  style={{
                    backgroundColor: achievement.earned ? "#0D1218" : "#0F1419",
                    borderWidth: 1,
                    borderColor: achievement.earned ? "#4BB8FA44" : "#2A3540",
                    borderRadius: 16,
                    padding: 16,
                    marginBottom: 10,
                    flexDirection: "row",
                    alignItems: "center",
                    opacity: achievement.earned ? 1 : 0.85,
                  }}
                >
                  <View
                    style={{
                      width: 52,
                      height: 52,
                      borderRadius: 26,
                      backgroundColor: achievement.earned
                        ? "#1A3A4A"
                        : "#1A2630",
                      alignItems: "center",
                      justifyContent: "center",
                      marginRight: 14,
                      borderWidth: 2,
                      borderColor: achievement.earned ? "#4BB8FA" : "#2A3540",
                    }}
                  >
                    {achievement.earned ? (
                      <Text style={{ fontSize: 26 }}>{achievement.icon}</Text>
                    ) : (
                      <Lock size={22} color="#556677" />
                    )}
                  </View>
                  <View style={{ flex: 1 }}>
                    <Text
                      style={{
                        color: achievement.earned ? "#FFF" : "#8A9AAA",
                        fontSize: 15,
                        fontWeight: "700",
                        marginBottom: 3,
                      }}
                    >
                      {achievement.title}
                    </Text>
                    <Text
                      style={{
                        color: achievement.earned ? "#888" : "#556677",
                        fontSize: 12,
                      }}
                    >
                      {achievement.description}
                    </Text>
                    {achievement.earned && achievement.earned_at && (
                      <Text
                        style={{ color: "#4BB8FA", fontSize: 11, marginTop: 4 }}
                      >
                        Unlocked{" "}
                        {new Date(achievement.earned_at).toLocaleDateString()}
                      </Text>
                    )}
                  </View>
                  {achievement.earned && (
                    <View
                      style={{
                        backgroundColor: "#0D3A1A",
                        borderRadius: 8,
                        paddingHorizontal: 8,
                        paddingVertical: 4,
                        borderWidth: 1,
                        borderColor: "#1A6A2A",
                      }}
                    >
                      <Text
                        style={{
                          color: "#4BFA88",
                          fontSize: 10,
                          fontWeight: "700",
                        }}
                      >
                        EARNED
                      </Text>
                    </View>
                  )}
                </View>
              ))}
            </View>
          ))}
        </ScrollView>
      </View>
    </Modal>
  );
}
