import {
  View,
  Text,
  ScrollView,
  ActivityIndicator,
  TouchableOpacity,
} from "react-native";
import { useState, useEffect } from "react";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { StatusBar } from "expo-status-bar";
import { Lock, Trophy } from "lucide-react-native";
import { useAuth } from "@/utils/auth/useAuth";
import { getApiUrl } from "@/utils/getApiUrl";

export default function Achievements() {
  const insets = useSafeAreaInsets();
  const { auth, isReady, signIn } = useAuth();
  const [achievements, setAchievements] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (auth) {
      loadAchievements();
    } else {
      setLoading(false);
    }
  }, [auth]);

  const loadAchievements = async () => {
    try {
      const response = await fetch(getApiUrl("/api/achievements"));
      const data = await response.json();
      const list = Array.isArray(data) ? data : data.achievements || [];
      setAchievements(list);
    } catch (error) {
      console.error("Load achievements error:", error);
      setAchievements([]);
    }
    setLoading(false);
  };

  const groupByCategory = (achievements) => {
    const groups = {};
    achievements.forEach((achievement) => {
      const category = achievement.category || "other";
      if (!groups[category]) {
        groups[category] = [];
      }
      groups[category].push(achievement);
    });
    return groups;
  };

  const getCategoryTitle = (category) => {
    const titles = {
      matches: "BATTLE ACHIEVEMENTS",
      workouts: "WORKOUT ACHIEVEMENTS",
      volume: "STRENGTH ACHIEVEMENTS",
      rank: "RANK ACHIEVEMENTS",
    };
    return titles[category] || "OTHER";
  };

  if (!isReady || loading) {
    return (
      <View
        style={{
          flex: 1,
          backgroundColor: "#010308",
          justifyContent: "center",
          alignItems: "center",
        }}
      >
        <ActivityIndicator size="large" color="#4BB8FA" />
      </View>
    );
  }

  // Guest state
  if (!auth) {
    return (
      <View
        style={{ flex: 1, backgroundColor: "#010308", paddingTop: insets.top }}
      >
        <StatusBar style="light" />
        {/* Header */}
        <View
          style={{
            padding: 20,
            paddingBottom: 16,
            borderBottomWidth: 1,
            borderBottomColor: "#1A2630",
          }}
        >
          <Text
            style={{
              color: "#FFF",
              fontSize: 28,
              fontWeight: "900",
              letterSpacing: 1,
            }}
          >
            ACHIEVEMENTS
          </Text>
          <Text style={{ color: "#666", fontSize: 14, marginTop: 4 }}>
            Sign in to unlock achievements
          </Text>
        </View>

        <View
          style={{
            flex: 1,
            justifyContent: "center",
            alignItems: "center",
            paddingHorizontal: 32,
          }}
        >
          <Trophy size={64} color="#444" style={{ marginBottom: 24 }} />
          <Text
            style={{
              fontSize: 20,
              fontWeight: "700",
              color: "#fff",
              marginBottom: 8,
              textAlign: "center",
            }}
          >
            Earn Achievements
          </Text>
          <Text
            style={{
              fontSize: 14,
              color: "#888",
              marginBottom: 24,
              textAlign: "center",
            }}
          >
            Complete challenges and unlock badges by signing in
          </Text>
          <TouchableOpacity
            onPress={() => signIn()}
            style={{
              backgroundColor: "#4BB8FA",
              paddingHorizontal: 32,
              paddingVertical: 12,
              borderRadius: 10,
            }}
          >
            <Text style={{ fontSize: 16, fontWeight: "700", color: "#000" }}>
              SIGN IN
            </Text>
          </TouchableOpacity>
        </View>
      </View>
    );
  }

  const grouped = groupByCategory(achievements);
  const earnedCount = achievements.filter((a) => a.earned).length;

  return (
    <View
      style={{ flex: 1, backgroundColor: "#010308", paddingTop: insets.top }}
    >
      <StatusBar style="light" />

      {/* Header */}
      <View
        style={{
          padding: 20,
          paddingBottom: 16,
          borderBottomWidth: 1,
          borderBottomColor: "#1A2630",
        }}
      >
        <Text
          style={{
            color: "#FFF",
            fontSize: 28,
            fontWeight: "900",
            letterSpacing: 1,
          }}
        >
          ACHIEVEMENTS
        </Text>
        <Text style={{ color: "#666", fontSize: 14, marginTop: 4 }}>
          {earnedCount} of {achievements.length} unlocked
        </Text>
      </View>

      <ScrollView
        style={{ flex: 1 }}
        contentContainerStyle={{ paddingBottom: insets.bottom + 20 }}
        showsVerticalScrollIndicator={false}
      >
        {Object.keys(grouped).map((category) => (
          <View key={category} style={{ padding: 20, paddingTop: 24 }}>
            <Text
              style={{
                color: "#555",
                fontSize: 11,
                fontWeight: "700",
                letterSpacing: 1,
                marginBottom: 12,
              }}
            >
              {getCategoryTitle(category)}
            </Text>

            {grouped[category].map((achievement) => (
              <View
                key={achievement.id}
                style={{
                  backgroundColor: achievement.earned ? "#0D1218" : "#070A0F",
                  borderWidth: 1,
                  borderColor: achievement.earned ? "#4BB8FA" : "#1A2630",
                  borderRadius: 16,
                  padding: 16,
                  marginBottom: 12,
                  opacity: achievement.earned ? 1 : 0.5,
                }}
              >
                <View style={{ flexDirection: "row", alignItems: "center" }}>
                  <View
                    style={{
                      width: 56,
                      height: 56,
                      borderRadius: 28,
                      backgroundColor: achievement.earned
                        ? "#1A3A4A"
                        : "#0D1218",
                      alignItems: "center",
                      justifyContent: "center",
                      marginRight: 16,
                      borderWidth: 2,
                      borderColor: achievement.earned ? "#4BB8FA" : "#1A2630",
                    }}
                  >
                    {achievement.earned ? (
                      <Text style={{ fontSize: 28 }}>{achievement.icon}</Text>
                    ) : (
                      <Lock size={24} color="#333" />
                    )}
                  </View>

                  <View style={{ flex: 1 }}>
                    <Text
                      style={{
                        color: achievement.earned ? "#FFF" : "#444",
                        fontSize: 16,
                        fontWeight: "700",
                        marginBottom: 4,
                      }}
                    >
                      {achievement.title}
                    </Text>
                    <Text
                      style={{
                        color: achievement.earned ? "#888" : "#333",
                        fontSize: 13,
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
                </View>
              </View>
            ))}
          </View>
        ))}
      </ScrollView>
    </View>
  );
}
