import React from "react";
import { View, Text, ScrollView, TouchableOpacity } from "react-native";
import { Lock, ChevronRight } from "lucide-react-native";

export function AchievementsSection({ achievements, onViewAll }) {
  const earnedAchievements = achievements.filter((a) => a.earned);
  const recentAchievements = [...earnedAchievements].slice(0, 6);
  const lockedSample = achievements
    .filter((a) => !a.earned)
    .slice(0, Math.max(0, 6 - recentAchievements.length));
  const previewAchievements = [...recentAchievements, ...lockedSample];

  return (
    <View style={{ paddingTop: 8 }}>
      <View
        style={{
          flexDirection: "row",
          alignItems: "center",
          justifyContent: "space-between",
          paddingHorizontal: 20,
          marginBottom: 14,
        }}
      >
        <View style={{ flexDirection: "row", alignItems: "center", gap: 10 }}>
          <Text
            style={{
              color: "#FFF",
              fontSize: 17,
              fontWeight: "900",
              letterSpacing: 0.5,
            }}
          >
            ACHIEVEMENTS
          </Text>
          {/* removed count badge */}
        </View>
        <TouchableOpacity
          onPress={onViewAll}
          style={{ flexDirection: "row", alignItems: "center", gap: 4 }}
        >
          <Text style={{ color: "#4BB8FA", fontSize: 13, fontWeight: "700" }}>
            View all
          </Text>
          <ChevronRight size={14} color="#4BB8FA" />
        </TouchableOpacity>
      </View>

      {previewAchievements.length === 0 ? (
        <View style={{ alignItems: "center", paddingVertical: 24 }}>
          <Text style={{ color: "#444", fontSize: 14 }}>
            Complete challenges to earn achievements!
          </Text>
        </View>
      ) : (
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={{ paddingHorizontal: 20, gap: 10 }}
          style={{ flexGrow: 0 }}
        >
          {previewAchievements.map((ach, i) => (
            <TouchableOpacity
              key={ach.id || i}
              onPress={onViewAll}
              style={{
                width: 88,
                height: 100,
                backgroundColor: ach.earned ? "#0D1218" : "#0F1419",
                borderRadius: 18,
                alignItems: "center",
                justifyContent: "center",
                borderWidth: 1,
                borderColor: ach.earned ? "#4BB8FA44" : "#2A3540",
                opacity: ach.earned ? 1 : 0.8,
                padding: 10,
              }}
            >
              {ach.earned ? (
                <Text style={{ fontSize: 30, marginBottom: 6 }}>
                  {ach.icon}
                </Text>
              ) : (
                <View
                  style={{
                    width: 40,
                    height: 40,
                    borderRadius: 20,
                    backgroundColor: "#1F2A35",
                    alignItems: "center",
                    justifyContent: "center",
                    marginBottom: 6,
                    borderWidth: 1,
                    borderColor: "#2A3540",
                  }}
                >
                  <Lock size={18} color="#556677" />
                </View>
              )}
              <Text
                style={{
                  color: ach.earned ? "#DDD" : "#6A7888",
                  fontSize: 9,
                  fontWeight: "700",
                  textAlign: "center",
                }}
                numberOfLines={2}
              >
                {ach.title?.toUpperCase()}
              </Text>
            </TouchableOpacity>
          ))}

          <TouchableOpacity
            onPress={onViewAll}
            style={{
              width: 88,
              height: 100,
              backgroundColor: "#0D1218",
              borderRadius: 18,
              alignItems: "center",
              justifyContent: "center",
              borderWidth: 1,
              borderColor: "#4BB8FA44",
              padding: 10,
            }}
          >
            <ChevronRight size={24} color="#4BB8FA" />
            <Text
              style={{
                color: "#4BB8FA",
                fontSize: 9,
                fontWeight: "700",
                marginTop: 6,
                textAlign: "center",
              }}
            >
              VIEW ALL
            </Text>
          </TouchableOpacity>
        </ScrollView>
      )}
    </View>
  );
}
