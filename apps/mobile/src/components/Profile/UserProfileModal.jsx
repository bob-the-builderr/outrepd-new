import React from "react";
import {
  View,
  Text,
  Modal,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
} from "react-native";
import { Image } from "expo-image";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { StatusBar } from "expo-status-bar";
import { X, Calendar } from "lucide-react-native";
import { TIERS, DIVISION_NAMES } from "@/constants/tiers";
import { useQuery } from "@tanstack/react-query";
import { authenticatedFetch } from "@/utils/authenticatedFetch";
import { ProfileFrame } from "@/components/ProfileFrame";

export function UserProfileModal({ visible, onClose, userId }) {
  const insets = useSafeAreaInsets();

  const { data, isLoading } = useQuery({
    queryKey: ["user-profile", userId],
    queryFn: async () => {
      const res = await authenticatedFetch(`/api/users/${userId}`);
      if (!res.ok) throw new Error("Failed to fetch user profile");
      return res.json();
    },
    enabled: visible && !!userId,
    staleTime: 0,
  });

  const profile = data?.profile || {};
  const matches = data?.matches || [];
  const achievements = data?.achievements || [];
  const friendshipStatus = data?.friendshipStatus;
  const isOwnProfile = data?.isOwnProfile;

  const tier = TIERS[Math.min(profile.tier_idx || 0, 8)];
  const divName = DIVISION_NAMES[Math.min(profile.div_idx || 0, 3)];
  const winRate =
    profile.total_matches > 0
      ? ((profile.wins / profile.total_matches) * 100).toFixed(0)
      : 0;

  const recentAchievements = achievements.slice(0, 3);
  const recentMatches = matches.slice(0, 5);

  return (
    <Modal
      visible={visible}
      animationType="slide"
      presentationStyle="pageSheet"
      onRequestClose={onClose}
    >
      <View style={{ flex: 1, backgroundColor: "#010308" }}>
        <StatusBar style="light" />

        {/* Close button */}
        <TouchableOpacity
          onPress={onClose}
          style={{
            position: "absolute",
            top: insets.top + 12,
            right: 20,
            zIndex: 100,
            backgroundColor: "#0D1218",
            width: 40,
            height: 40,
            borderRadius: 20,
            alignItems: "center",
            justifyContent: "center",
            borderWidth: 1,
            borderColor: "#1A2630",
          }}
        >
          <X size={20} color="#888" />
        </TouchableOpacity>

        {isLoading ? (
          <View
            style={{
              flex: 1,
              justifyContent: "center",
              alignItems: "center",
            }}
          >
            <ActivityIndicator color="#4BB8FA" size="large" />
          </View>
        ) : (
          <ScrollView
            showsVerticalScrollIndicator={false}
            contentContainerStyle={{ paddingBottom: insets.bottom + 40 }}
          >
            {/* Header */}
            <View
              style={{
                paddingTop: insets.top + 60,
                paddingHorizontal: 20,
                alignItems: "center",
                marginBottom: 24,
              }}
            >
              {/* Profile Photo with ProfileFrame */}
              <View style={{ marginBottom: 16 }}>
                <ProfileFrame
                  size={100}
                  tierIdx={profile.tier_idx || 0}
                  photoUrl={profile.profile_photo_url}
                  fallbackIcon={tier?.icon}
                  glow={true}
                />
              </View>

              {/* Username */}
              <Text
                style={{
                  fontSize: 24,
                  fontWeight: "900",
                  color: "#FFF",
                  marginBottom: 4,
                }}
              >
                {profile.username}
              </Text>

              {/* Rank */}
              <View
                style={{
                  backgroundColor: tier?.color + "22" || "#4BB8FA22",
                  paddingHorizontal: 16,
                  paddingVertical: 6,
                  borderRadius: 20,
                  marginBottom: 8,
                }}
              >
                <Text
                  style={{
                    fontSize: 14,
                    fontWeight: "700",
                    color: tier?.color || "#4BB8FA",
                  }}
                >
                  {tier?.name} {divName}
                </Text>
              </View>

              {/* LP */}
              <Text style={{ fontSize: 16, fontWeight: "700", color: "#888" }}>
                {profile.lp} LP
              </Text>

              {/* Country */}
              {profile.country && (
                <Text
                  style={{
                    fontSize: 14,
                    color: "#666",
                    marginTop: 8,
                  }}
                >
                  🌍 {profile.country}
                </Text>
              )}
            </View>

            {/* Quick Stats */}
            <View style={{ paddingHorizontal: 20, marginBottom: 24 }}>
              <View
                style={{
                  backgroundColor: "#0D1218",
                  borderRadius: 20,
                  padding: 16,
                  borderWidth: 1,
                  borderColor: "#1A2630",
                }}
              >
                <View
                  style={{
                    flexDirection: "row",
                    justifyContent: "space-around",
                  }}
                >
                  {/* Wins */}
                  <View style={{ alignItems: "center" }}>
                    <Text
                      style={{
                        fontSize: 22,
                        fontWeight: "900",
                        color: "#FFF",
                      }}
                    >
                      {profile.wins || 0}
                    </Text>
                    <Text style={{ fontSize: 11, color: "#888" }}>WINS</Text>
                  </View>

                  {/* Losses */}
                  <View style={{ alignItems: "center" }}>
                    <Text
                      style={{
                        fontSize: 22,
                        fontWeight: "900",
                        color: "#FFF",
                      }}
                    >
                      {profile.losses || 0}
                    </Text>
                    <Text style={{ fontSize: 11, color: "#888" }}>LOSSES</Text>
                  </View>

                  {/* Win Rate */}
                  <View style={{ alignItems: "center" }}>
                    <Text
                      style={{
                        fontSize: 22,
                        fontWeight: "900",
                        color: "#FFF",
                      }}
                    >
                      {winRate}%
                    </Text>
                    <Text style={{ fontSize: 11, color: "#888" }}>
                      WIN RATE
                    </Text>
                  </View>

                  {/* Streak */}
                  <View style={{ alignItems: "center" }}>
                    <Text
                      style={{
                        fontSize: 22,
                        fontWeight: "900",
                        color: "#FFF",
                      }}
                    >
                      {profile.current_win_streak || 0}
                    </Text>
                    <Text style={{ fontSize: 11, color: "#888" }}>STREAK</Text>
                  </View>
                </View>

                {/* Best Streak */}
                <View
                  style={{
                    marginTop: 16,
                    paddingTop: 16,
                    borderTopWidth: 1,
                    borderColor: "#1A2630",
                    flexDirection: "row",
                    justifyContent: "center",
                  }}
                >
                  <Text style={{ color: "#666", fontSize: 12 }}>
                    Best Streak:{" "}
                  </Text>
                  <Text
                    style={{ color: "#FFF", fontSize: 12, fontWeight: "700" }}
                  >
                    {profile.best_win_streak || 0} wins
                  </Text>
                </View>
              </View>
            </View>

            {/* Achievements */}
            {recentAchievements.length > 0 && (
              <View style={{ paddingHorizontal: 20, marginBottom: 24 }}>
                <Text
                  style={{
                    fontSize: 16,
                    fontWeight: "900",
                    color: "#FFF",
                    marginBottom: 12,
                    letterSpacing: 0.5,
                  }}
                >
                  RECENT ACHIEVEMENTS
                </Text>
                {recentAchievements.map((ach, idx) => (
                  <View
                    key={idx}
                    style={{
                      backgroundColor: "#0D1218",
                      borderRadius: 14,
                      padding: 14,
                      marginBottom: 8,
                      borderWidth: 1,
                      borderColor: "#1A2630",
                      flexDirection: "row",
                      alignItems: "center",
                    }}
                  >
                    <Text style={{ fontSize: 28, marginRight: 12 }}>
                      {ach.icon || "🏆"}
                    </Text>
                    <View style={{ flex: 1 }}>
                      <Text
                        style={{
                          color: "#FFF",
                          fontSize: 14,
                          fontWeight: "700",
                          marginBottom: 2,
                        }}
                      >
                        {ach.title}
                      </Text>
                      <Text style={{ color: "#888", fontSize: 12 }}>
                        {ach.description}
                      </Text>
                    </View>
                  </View>
                ))}
                {achievements.length > 3 && (
                  <Text style={{ color: "#666", fontSize: 12, marginTop: 4 }}>
                    + {achievements.length - 3} more
                  </Text>
                )}
              </View>
            )}

            {/* Recent Matches */}
            {recentMatches.length > 0 && (
              <View style={{ paddingHorizontal: 20, marginBottom: 24 }}>
                <Text
                  style={{
                    fontSize: 16,
                    fontWeight: "900",
                    color: "#FFF",
                    marginBottom: 12,
                    letterSpacing: 0.5,
                  }}
                >
                  RECENT MATCHES
                </Text>
                {recentMatches.map((match, idx) => {
                  const matchTier =
                    TIERS[Math.min(match.tier_idx_after || 0, 8)];
                  const matchDiv =
                    DIVISION_NAMES[Math.min(match.div_idx_after || 0, 3)];
                  const isWin = match.result === "win";

                  return (
                    <View
                      key={idx}
                      style={{
                        backgroundColor: "#0D1218",
                        borderRadius: 14,
                        padding: 14,
                        marginBottom: 8,
                        borderWidth: 1,
                        borderColor: isWin ? "#00C85322" : "#FF444422",
                      }}
                    >
                      <View
                        style={{
                          flexDirection: "row",
                          justifyContent: "space-between",
                          alignItems: "center",
                        }}
                      >
                        <View style={{ flex: 1 }}>
                          <View
                            style={{
                              flexDirection: "row",
                              alignItems: "center",
                              gap: 8,
                              marginBottom: 4,
                            }}
                          >
                            <View
                              style={{
                                backgroundColor: isWin ? "#00C853" : "#FF4444",
                                paddingHorizontal: 8,
                                paddingVertical: 3,
                                borderRadius: 6,
                              }}
                            >
                              <Text
                                style={{
                                  color: "#000",
                                  fontSize: 10,
                                  fontWeight: "900",
                                }}
                              >
                                {isWin ? "WIN" : "LOSS"}
                              </Text>
                            </View>
                            <Text
                              style={{
                                color: "#FFF",
                                fontSize: 14,
                                fontWeight: "700",
                              }}
                            >
                              vs {match.opponent_name}
                            </Text>
                          </View>
                          <Text style={{ color: "#666", fontSize: 12 }}>
                            {matchTier?.name} {matchDiv} •{" "}
                            {match.lp_change >= 0 ? "+" : ""}
                            {match.lp_change} LP
                          </Text>
                        </View>
                        <Text
                          style={{
                            color: isWin ? "#00C853" : "#FF4444",
                            fontSize: 16,
                            fontWeight: "900",
                          }}
                        >
                          {match.user_volume_kg}kg
                        </Text>
                      </View>
                    </View>
                  );
                })}
                {matches.length > 5 && (
                  <Text style={{ color: "#666", fontSize: 12, marginTop: 4 }}>
                    + {matches.length - 5} more matches
                  </Text>
                )}
              </View>
            )}

            {/* Empty states */}
            {achievements.length === 0 && matches.length === 0 && (
              <View
                style={{
                  paddingHorizontal: 20,
                  paddingTop: 20,
                  alignItems: "center",
                }}
              >
                <Calendar size={40} color="#444" />
                <Text
                  style={{
                    color: "#666",
                    fontSize: 14,
                    marginTop: 12,
                    textAlign: "center",
                  }}
                >
                  No activity yet
                </Text>
              </View>
            )}
          </ScrollView>
        )}
      </View>
    </Modal>
  );
}
