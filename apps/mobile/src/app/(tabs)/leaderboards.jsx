import React, { useState } from "react";
import {
  View,
  Text,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
} from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { StatusBar } from "expo-status-bar";
import { useAuth } from "@/utils/auth/useAuth";
import { useQuery } from "@tanstack/react-query";
import { TIERS, DIVISION_NAMES } from "@/constants/tiers";
import { Trophy, Globe, MapPin, Settings } from "lucide-react-native";
import { useRouter } from "expo-router";
import { authenticatedFetch } from "@/utils/authenticatedFetch";
import { UserProfileModal } from "@/components/Profile/UserProfileModal";

export default function LeaderboardsScreen() {
  const insets = useSafeAreaInsets();
  const { auth, isReady, signIn } = useAuth();
  const [selectedTab, setSelectedTab] = useState("global");
  const [selectedUserId, setSelectedUserId] = useState(null);
  const [showUserProfile, setShowUserProfile] = useState(false);
  const router = useRouter();

  const { data, isLoading, isFetching } = useQuery({
    queryKey: ["leaderboards", selectedTab],
    queryFn: async () => {
      const response = await authenticatedFetch(
        `/api/leaderboards?type=${selectedTab}`,
      );
      if (!response.ok) throw new Error("Failed to fetch leaderboards");
      return response.json();
    },
    enabled: !!auth,
    staleTime: 30000,
    refetchOnMount: "always",
  });

  // Only show loading when auth isn't ready yet
  if (!isReady) {
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

  // Guest state - keep existing implementation
  if (!auth) {
    return (
      <View
        style={{
          flex: 1,
          backgroundColor: "#010308",
          justifyContent: "center",
          alignItems: "center",
          paddingHorizontal: 32,
        }}
      >
        <Trophy color="#4BB8FA" size={64} />
        <Text
          style={{
            color: "#fff",
            fontSize: 24,
            fontWeight: "bold",
            marginTop: 24,
            marginBottom: 16,
            textAlign: "center",
          }}
        >
          Leaderboards
        </Text>
        <Text
          style={{
            color: "#888",
            fontSize: 16,
            marginBottom: 32,
            textAlign: "center",
          }}
        >
          Sign in to compete and view rankings
        </Text>
        <TouchableOpacity
          onPress={() => signIn()}
          style={{
            backgroundColor: "#4BB8FA",
            paddingHorizontal: 32,
            paddingVertical: 16,
            borderRadius: 12,
          }}
        >
          <Text style={{ color: "#000", fontSize: 18, fontWeight: "bold" }}>
            Sign In
          </Text>
        </TouchableOpacity>
      </View>
    );
  }

  // Data will be pre-loaded from cache, render UI directly
  const leaderboard = data?.leaderboard || [];
  const currentUser = data?.current_user;
  const noCountry = data?.no_country;
  const country = data?.country;

  const renderRow = (user) => {
    const tier = TIERS[Math.min(user.tier_idx || 0, 8)];
    const divName = DIVISION_NAMES[Math.min(user.div_idx || 0, 3)];
    const isCurrentUser = user.is_current_user;
    const isTopThree = user.rank <= 3;

    const rankBg =
      user.rank === 1
        ? "#FFD700"
        : user.rank === 2
          ? "#C0C0C0"
          : user.rank === 3
            ? "#CD7F32"
            : "#1A1A1A";
    const rankColor = isTopThree ? "#000" : "#FFF";

    const handlePress = () => {
      if (!isCurrentUser) {
        setSelectedUserId(user.user_id);
        setShowUserProfile(true);
      }
    };

    return (
      <TouchableOpacity
        key={user.user_id}
        onPress={handlePress}
        disabled={isCurrentUser}
        activeOpacity={0.7}
      >
        <View
          style={{
            backgroundColor: isCurrentUser ? "#4BB8FA18" : "#0D1218",
            borderRadius: 16,
            padding: 14,
            marginBottom: 10,
            flexDirection: "row",
            alignItems: "center",
            borderWidth: isCurrentUser ? 1.5 : 1,
            borderColor: isCurrentUser ? "#4BB8FA" : "#1A2630",
          }}
        >
          {/* Rank badge */}
          <View
            style={{
              width: 44,
              height: 44,
              borderRadius: 22,
              backgroundColor: rankBg,
              justifyContent: "center",
              alignItems: "center",
              marginRight: 14,
            }}
          >
            <Text style={{ color: rankColor, fontSize: 16, fontWeight: "900" }}>
              {user.rank}
            </Text>
          </View>

          {/* Info */}
          <View style={{ flex: 1 }}>
            <View
              style={{
                flexDirection: "row",
                alignItems: "center",
                gap: 6,
                marginBottom: 3,
              }}
            >
              <Text style={{ color: "#FFF", fontSize: 15, fontWeight: "700" }}>
                {user.username}
              </Text>
              {isCurrentUser && (
                <View
                  style={{
                    backgroundColor: "#4BB8FA33",
                    borderRadius: 6,
                    paddingHorizontal: 6,
                    paddingVertical: 2,
                  }}
                >
                  <Text
                    style={{
                      color: "#4BB8FA",
                      fontSize: 10,
                      fontWeight: "700",
                    }}
                  >
                    YOU
                  </Text>
                </View>
              )}
            </View>
            <View
              style={{ flexDirection: "row", alignItems: "center", gap: 6 }}
            >
              <Text
                style={{
                  color: tier?.color || "#888",
                  fontSize: 12,
                  fontWeight: "600",
                }}
              >
                {tier?.name} {divName}
              </Text>
              <Text style={{ color: "#444", fontSize: 12 }}>•</Text>
              <Text style={{ color: "#666", fontSize: 12 }}>
                {user.wins}W {user.losses}L
              </Text>
            </View>
          </View>

          {/* LP */}
          <View style={{ alignItems: "flex-end" }}>
            <Text
              style={{
                color: tier?.color || "#4BB8FA",
                fontSize: 20,
                fontWeight: "900",
              }}
            >
              {user.lp}
            </Text>
            <Text style={{ color: "#555", fontSize: 11 }}>LP</Text>
          </View>
        </View>
      </TouchableOpacity>
    );
  };

  return (
    <View style={{ flex: 1, backgroundColor: "#010308" }}>
      <StatusBar style="light" />

      {/* Header */}
      <View
        style={{
          paddingTop: insets.top + 20,
          paddingHorizontal: 20,
          paddingBottom: 16,
        }}
      >
        <Text
          style={{
            color: "#FFF",
            fontSize: 32,
            fontWeight: "900",
            letterSpacing: 1,
          }}
        >
          LEADERBOARDS
        </Text>
        <Text style={{ color: "#888", fontWeight: "600", fontSize: 13 }}>
          {selectedTab === "local" && country
            ? `🏴 ${country}`
            : "Compete with the best"}
        </Text>
      </View>

      {/* Tabs */}
      <View
        style={{
          flexDirection: "row",
          paddingHorizontal: 20,
          paddingBottom: 16,
          gap: 10,
        }}
      >
        <TouchableOpacity
          onPress={() => setSelectedTab("global")}
          style={{
            flex: 1,
            backgroundColor: selectedTab === "global" ? "#4BB8FA" : "#0D1218",
            paddingVertical: 12,
            borderRadius: 14,
            flexDirection: "row",
            justifyContent: "center",
            alignItems: "center",
            gap: 8,
            borderWidth: 1,
            borderColor: selectedTab === "global" ? "#4BB8FA" : "#1A2630",
          }}
        >
          <Globe color={selectedTab === "global" ? "#000" : "#888"} size={18} />
          <Text
            style={{
              color: selectedTab === "global" ? "#000" : "#888",
              fontWeight: "700",
              fontSize: 14,
            }}
          >
            GLOBAL
          </Text>
        </TouchableOpacity>
        <TouchableOpacity
          onPress={() => setSelectedTab("local")}
          style={{
            flex: 1,
            backgroundColor: selectedTab === "local" ? "#4BB8FA" : "#0D1218",
            paddingVertical: 12,
            borderRadius: 14,
            flexDirection: "row",
            justifyContent: "center",
            alignItems: "center",
            gap: 8,
            borderWidth: 1,
            borderColor: selectedTab === "local" ? "#4BB8FA" : "#1A2630",
          }}
        >
          <MapPin color={selectedTab === "local" ? "#000" : "#888"} size={18} />
          <Text
            style={{
              color: selectedTab === "local" ? "#000" : "#888",
              fontWeight: "700",
              fontSize: 14,
            }}
          >
            LOCAL
          </Text>
        </TouchableOpacity>
      </View>

      <ScrollView
        contentContainerStyle={{
          paddingHorizontal: 20,
          paddingBottom: insets.bottom + 100,
        }}
        showsVerticalScrollIndicator={false}
      >
        {/* No country set */}
        {noCountry ? (
          <View
            style={{
              backgroundColor: "#0D1218",
              borderRadius: 20,
              padding: 32,
              alignItems: "center",
              borderWidth: 1,
              borderColor: "#1A2630",
              marginTop: 8,
            }}
          >
            <MapPin color="#4BB8FA" size={52} />
            <Text
              style={{
                color: "#FFF",
                fontSize: 18,
                fontWeight: "900",
                marginTop: 16,
                marginBottom: 8,
                textAlign: "center",
              }}
            >
              Set Your Country
            </Text>
            <Text
              style={{
                color: "#888",
                textAlign: "center",
                fontSize: 14,
                lineHeight: 20,
                marginBottom: 24,
              }}
            >
              Choose your country in Settings to compete in local rankings
            </Text>
            <TouchableOpacity
              onPress={() => router.push("/(tabs)/profile?openSettings=true")}
              style={{
                backgroundColor: "#4BB8FA",
                borderRadius: 12,
                paddingHorizontal: 24,
                paddingVertical: 12,
                flexDirection: "row",
                alignItems: "center",
                gap: 8,
              }}
            >
              <Settings size={16} color="#000" />
              <Text style={{ color: "#000", fontWeight: "900", fontSize: 14 }}>
                GO TO SETTINGS
              </Text>
            </TouchableOpacity>
          </View>
        ) : isFetching && leaderboard.length === 0 ? (
          <View style={{ alignItems: "center", paddingTop: 40 }}>
            <ActivityIndicator color="#4BB8FA" />
          </View>
        ) : leaderboard.length === 0 ? (
          <View
            style={{
              backgroundColor: "#0D1218",
              borderRadius: 20,
              padding: 32,
              alignItems: "center",
              borderWidth: 1,
              borderColor: "#1A2630",
            }}
          >
            <Trophy color="#444" size={52} />
            <Text
              style={{
                color: "#FFF",
                fontSize: 18,
                fontWeight: "900",
                marginTop: 16,
                marginBottom: 8,
              }}
            >
              No Rankings Yet
            </Text>
            <Text style={{ color: "#888", textAlign: "center" }}>
              {selectedTab === "local"
                ? "No players from your country yet — be the first!"
                : "Be the first to compete!"}
            </Text>
          </View>
        ) : (
          <>
            {leaderboard.map((user) => renderRow(user))}

            {/* Current user outside top list */}
            {currentUser && !leaderboard.find((u) => u.is_current_user) && (
              <>
                <View style={{ alignItems: "center", paddingVertical: 12 }}>
                  <Text
                    style={{ color: "#444", fontSize: 18, letterSpacing: 4 }}
                  >
                    • • •
                  </Text>
                </View>
                {renderRow(currentUser)}
              </>
            )}
          </>
        )}
      </ScrollView>

      {/* User Profile Modal */}
      <UserProfileModal
        visible={showUserProfile}
        onClose={() => setShowUserProfile(false)}
        userId={selectedUserId}
      />
    </View>
  );
}
