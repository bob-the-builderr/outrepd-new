import React, { useState, useCallback, useEffect } from "react";
import {
  View,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
  RefreshControl,
  Text,
} from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { StatusBar } from "expo-status-bar";
import { useAuth } from "@/utils/auth/useAuth";
import useUser from "@/utils/auth/useUser";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { Bell, Settings } from "lucide-react-native";
import { ProfileHeader } from "@/components/Profile/ProfileHeader";
import { QuickStats } from "@/components/Profile/QuickStats";
import { AchievementsSection } from "@/components/Profile/AchievementsSection";
import { MatchHistorySection } from "@/components/Profile/MatchHistorySection";
import { NotificationsModal } from "@/components/Profile/NotificationsModal";
import { AchievementsModal } from "@/components/Profile/AchievementsModal";
import { MatchHistoryModal } from "@/components/Profile/MatchHistoryModal";
import { SettingsModal } from "@/components/Profile/SettingsModal";
import { EditProfileModal } from "@/components/Profile/EditProfileModal";
import { PaywallModal } from "@/components/Paywall/PaywallModal";
import { useLocalSearchParams, useRouter } from "expo-router";
import { authenticatedFetch } from "@/utils/authenticatedFetch";

export default function ProfileScreen() {
  const insets = useSafeAreaInsets();
  const { auth, isReady, signIn, signOut } = useAuth();
  const { data: user } = useUser();
  const queryClient = useQueryClient();
  const router = useRouter();
  const { openSettings } = useLocalSearchParams();
  const [showAchievements, setShowAchievements] = useState(false);
  const [showNotifications, setShowNotifications] = useState(false);
  const [showSettings, setShowSettings] = useState(false);
  const [showMatchHistory, setShowMatchHistory] = useState(false);
  const [showEditProfile, setShowEditProfile] = useState(false);
  const [showPaywall, setShowPaywall] = useState(false);

  useEffect(() => {
    if (openSettings === "true") {
      setShowSettings(true);
      router.setParams({ openSettings: undefined });
    }
  }, [openSettings]);

  const {
    data: profileData,
    isLoading: profileLoading,
    refetch: refetchProfile,
  } = useQuery({
    queryKey: ["profile"],
    queryFn: async () => {
      const res = await authenticatedFetch("/api/profile");
      if (!res.ok) throw new Error("Failed to fetch profile");
      return res.json();
    },
    enabled: !!auth,
  });

  const { data: achievements = [], refetch: refetchAchievements } = useQuery({
    queryKey: ["achievements"],
    queryFn: async () => {
      const res = await authenticatedFetch("/api/achievements");
      if (!res.ok) throw new Error("Failed to fetch achievements");
      return res.json();
    },
    enabled: !!auth,
  });

  const { data: settings, refetch: refetchSettings } = useQuery({
    queryKey: ["settings"],
    queryFn: async () => {
      const res = await authenticatedFetch("/api/settings");
      if (!res.ok) throw new Error("Failed to fetch settings");
      return res.json();
    },
    enabled: !!auth,
  });

  const { data: notificationsData, refetch: refetchNotifications } = useQuery({
    queryKey: ["notifications"],
    queryFn: async () => {
      const res = await authenticatedFetch("/api/notifications");
      if (!res.ok) throw new Error("Failed to fetch notifications");
      return res.json();
    },
    enabled: !!auth,
  });

  const { data: matchesData, refetch: refetchMatches } = useQuery({
    queryKey: ["matches"],
    queryFn: async () => {
      const res = await authenticatedFetch("/api/matches?limit=50");
      if (!res.ok) throw new Error("Failed to fetch matches");
      return res.json();
    },
    enabled: !!auth,
  });

  const updateSettingMutation = useMutation({
    mutationFn: async (update) => {
      const res = await authenticatedFetch("/api/settings", {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(update),
      });
      if (!res.ok) throw new Error("Failed to update setting");
      return res.json();
    },
    onSuccess: (data) => queryClient.setQueryData(["settings"], data),
  });

  const updateCountryMutation = useMutation({
    mutationFn: async (country) => {
      const res = await authenticatedFetch("/api/profile", {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ country }),
      });
      if (!res.ok) throw new Error("Failed to update country");
      return res.json();
    },
    onSuccess: (data) => {
      queryClient.setQueryData(["profile"], data);
      queryClient.invalidateQueries({ queryKey: ["leaderboards"] });
    },
  });

  const updateBodyweightMutation = useMutation({
    mutationFn: async (bodyweight_kg) => {
      const res = await authenticatedFetch("/api/profile", {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ bodyweight_kg }),
      });
      if (!res.ok) throw new Error("Failed to update bodyweight");
      return res.json();
    },
    onSuccess: (data) => {
      queryClient.setQueryData(["profile"], data);
    },
  });

  const updateHeightMutation = useMutation({
    mutationFn: async (height_cm) => {
      const res = await authenticatedFetch("/api/profile", {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ height_cm }),
      });
      if (!res.ok) throw new Error("Failed to update height");
      return res.json();
    },
    onSuccess: (data) => {
      queryClient.setQueryData(["profile"], data);
    },
  });

  const markAllReadMutation = useMutation({
    mutationFn: async () => {
      const res = await authenticatedFetch("/api/notifications", {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ mark_all_read: true }),
      });
      if (!res.ok) throw new Error("Failed to mark notifications read");
      return res.json();
    },
    onSuccess: () => refetchNotifications(),
  });

  const updateProfileMutation = useMutation({
    mutationFn: async (update) => {
      const res = await authenticatedFetch("/api/profile", {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(update),
      });
      if (!res.ok) throw new Error("Failed to update profile");
      return res.json();
    },
    onSuccess: (data) => {
      queryClient.setQueryData(["profile"], data);
      refetchProfile();
    },
  });

  const handleSignOut = () => {
    signOut();
  };

  const onRefresh = useCallback(async () => {
    if (!auth) return;
    await Promise.all([
      refetchProfile(),
      refetchAchievements(),
      refetchSettings(),
      refetchNotifications(),
      refetchMatches(),
    ]);
  }, [
    auth,
    refetchProfile,
    refetchAchievements,
    refetchSettings,
    refetchNotifications,
    refetchMatches,
  ]);

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
        <ActivityIndicator color="#4BB8FA" size="large" />
      </View>
    );
  }

  const profile = profileData?.profile || {};
  const notifications = notificationsData?.notifications || [];
  const unreadCount = notifications.filter((n) => !n.is_read).length;
  const matches = matchesData?.matches || [];

  return (
    <View style={{ flex: 1, backgroundColor: "#010308" }}>
      <StatusBar style="light" />

      {/* Modals */}
      <SettingsModal
        visible={showSettings}
        onClose={() => setShowSettings(false)}
        settings={settings}
        onUpdateSetting={(update) => updateSettingMutation.mutate(update)}
        user={user}
        profile={profile}
        onUpdateCountry={(country) => updateCountryMutation.mutate(country)}
        isUpdatingCountry={updateCountryMutation.isPending}
        onUpdateBodyweight={(bw) => updateBodyweightMutation.mutate(bw)}
        isUpdatingBodyweight={updateBodyweightMutation.isPending}
        onUpdateHeight={(h) => updateHeightMutation.mutate(h)}
        isUpdatingHeight={updateHeightMutation.isPending}
        onSignOut={handleSignOut}
        onOpenPaywall={() => {
          setShowSettings(false);
          setShowPaywall(true);
        }}
      />
      <PaywallModal
        visible={showPaywall}
        onClose={() => setShowPaywall(false)}
        onSubscribed={() => setShowPaywall(false)}
      />
      <EditProfileModal
        visible={showEditProfile}
        onClose={() => setShowEditProfile(false)}
        profile={profile}
        onUpdate={(update) => updateProfileMutation.mutate(update)}
      />
      <NotificationsModal
        visible={showNotifications}
        onClose={() => setShowNotifications(false)}
        notifications={notifications}
        onMarkAllRead={() => markAllReadMutation.mutate()}
      />
      <AchievementsModal
        visible={showAchievements}
        onClose={() => setShowAchievements(false)}
        achievements={achievements}
      />
      <MatchHistoryModal
        visible={showMatchHistory}
        onClose={() => setShowMatchHistory(false)}
        matches={matches}
        userProfile={profile}
      />

      {/* Guest view */}
      {!auth && (
        <View style={{ flex: 1, paddingTop: insets.top }}>
          <View
            style={{
              paddingHorizontal: 20,
              paddingVertical: 24,
              alignItems: "center",
            }}
          >
            <View
              style={{
                width: 100,
                height: 100,
                borderRadius: 50,
                backgroundColor: "#0D1218",
                justifyContent: "center",
                alignItems: "center",
                marginBottom: 16,
              }}
            >
              <Text style={{ fontSize: 48, color: "#444" }}>👤</Text>
            </View>
            <Text
              style={{
                fontSize: 24,
                fontWeight: "700",
                color: "#fff",
                marginBottom: 4,
              }}
            >
              Guest
            </Text>
            <Text style={{ fontSize: 14, color: "#888", marginBottom: 20 }}>
              Not signed in
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
          <View
            style={{
              marginHorizontal: 20,
              marginTop: 20,
              padding: 20,
              backgroundColor: "#0D1218",
              borderRadius: 12,
              borderWidth: 1,
              borderColor: "#1A2630",
            }}
          >
            <Text
              style={{
                fontSize: 16,
                fontWeight: "600",
                color: "#fff",
                marginBottom: 8,
              }}
            >
              Sign in to unlock:
            </Text>
            <View style={{ marginLeft: 8 }}>
              <Text style={{ fontSize: 14, color: "#aaa", marginBottom: 6 }}>
                • Track your workouts and progress
              </Text>
              <Text style={{ fontSize: 14, color: "#aaa", marginBottom: 6 }}>
                • Compete in ranked matches
              </Text>
              <Text style={{ fontSize: 14, color: "#aaa", marginBottom: 6 }}>
                • Earn achievements and climb the ranks
              </Text>
              <Text style={{ fontSize: 14, color: "#aaa", marginBottom: 6 }}>
                • Challenge friends and rivals
              </Text>
            </View>
          </View>
        </View>
      )}

      {/* Loading state */}
      {auth && profileLoading && (
        <View
          style={{ flex: 1, justifyContent: "center", alignItems: "center" }}
        >
          <ActivityIndicator color="#4BB8FA" size="large" />
        </View>
      )}
      {/* Authenticated view */}
      {auth && (
        <>
          {/* Bell icon — top left */}
          <TouchableOpacity
            onPress={() => setShowNotifications(true)}
            style={{
              position: "absolute",
              top: insets.top + 20,
              left: 20,
              zIndex: 100,
              backgroundColor: "#0D1218",
              width: 46,
              height: 46,
              borderRadius: 23,
              alignItems: "center",
              justifyContent: "center",
              borderWidth: 1,
              borderColor: unreadCount > 0 ? "#4BB8FA55" : "#1A2630",
            }}
          >
            <Bell size={22} color={unreadCount > 0 ? "#4BB8FA" : "#555"} />
            {unreadCount > 0 && (
              <View
                style={{
                  position: "absolute",
                  top: -3,
                  right: -3,
                  backgroundColor: "#FF4444",
                  borderRadius: 10,
                  minWidth: 20,
                  height: 20,
                  alignItems: "center",
                  justifyContent: "center",
                  paddingHorizontal: 5,
                  borderWidth: 2,
                  borderColor: "#010308",
                }}
              >
                <Text
                  style={{ color: "#FFF", fontSize: 10, fontWeight: "900" }}
                >
                  {unreadCount > 9 ? "9+" : unreadCount}
                </Text>
              </View>
            )}
          </TouchableOpacity>

          {/* Gear icon — top right */}
          <TouchableOpacity
            onPress={() => setShowSettings(true)}
            style={{
              position: "absolute",
              top: insets.top + 20,
              right: 20,
              zIndex: 100,
              backgroundColor: "#0D1218",
              width: 46,
              height: 46,
              borderRadius: 23,
              alignItems: "center",
              justifyContent: "center",
              borderWidth: 1,
              borderColor: "#1A2630",
            }}
          >
            <Settings size={22} color="#555" />
          </TouchableOpacity>

          <ScrollView
            showsVerticalScrollIndicator={false}
            refreshControl={
              <RefreshControl
                refreshing={false}
                onRefresh={onRefresh}
                tintColor="#4BB8FA"
              />
            }
            contentContainerStyle={{ paddingBottom: insets.bottom + 40 }}
          >
            <View style={{ paddingTop: insets.top + 70 }}>
              <ProfileHeader
                profile={profile}
                user={user}
                onEditPress={() => setShowEditProfile(true)}
              />
            </View>
            <QuickStats profile={profile} />
            <AchievementsSection
              achievements={achievements}
              onViewAll={() => setShowAchievements(true)}
            />
            <MatchHistorySection
              matches={matches}
              onViewAll={() => setShowMatchHistory(true)}
              userProfile={profile}
            />
          </ScrollView>
        </>
      )}
    </View>
  );
}
