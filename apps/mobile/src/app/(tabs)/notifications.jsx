import {
  View,
  Text,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
} from "react-native";
import { useState, useEffect } from "react";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { StatusBar } from "expo-status-bar";
import {
  Trophy,
  UserPlus,
  Swords,
  TrendingUp,
  CheckCircle,
  Bell,
} from "lucide-react-native";
import { useAuth } from "@/utils/auth/useAuth";
import { getApiUrl } from "@/utils/getApiUrl";

export default function Notifications() {
  const insets = useSafeAreaInsets();
  const { auth, isReady, signIn } = useAuth();
  const [notifications, setNotifications] = useState([]);
  const [unreadCount, setUnreadCount] = useState(0);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (auth) {
      loadNotifications();
    } else {
      setLoading(false);
    }
  }, [auth]);

  const loadNotifications = async () => {
    try {
      const response = await fetch(getApiUrl("/api/notifications"));
      const data = await response.json();
      setNotifications(data.notifications || []);
      setUnreadCount(data.unreadCount || 0);
    } catch (error) {
      console.error("Load notifications error:", error);
    }
    setLoading(false);
  };

  const markAsRead = async (notificationId) => {
    try {
      await fetch(getApiUrl("/api/notifications"), {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ notification_id: notificationId }),
      });

      setNotifications((prev) =>
        prev.map((n) =>
          n.id === notificationId ? { ...n, is_read: true } : n,
        ),
      );
      setUnreadCount((prev) => Math.max(0, prev - 1));
    } catch (error) {
      console.error("Mark as read error:", error);
    }
  };

  const markAllAsRead = async () => {
    try {
      await fetch(getApiUrl("/api/notifications"), {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ mark_all_read: true }),
      });

      setNotifications((prev) => prev.map((n) => ({ ...n, is_read: true })));
      setUnreadCount(0);
    } catch (error) {
      console.error("Mark all as read error:", error);
    }
  };

  const getIcon = (type) => {
    const iconProps = { size: 20, color: "#4BB8FA" };
    switch (type) {
      case "achievement_unlocked":
        return <Trophy {...iconProps} />;
      case "friend_request":
        return <UserPlus {...iconProps} />;
      case "match_invite":
        return <Swords {...iconProps} />;
      case "match_result":
        return <TrendingUp {...iconProps} />;
      default:
        return <CheckCircle {...iconProps} />;
    }
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
            NOTIFICATIONS
          </Text>
          <Text style={{ color: "#666", fontSize: 14, marginTop: 4 }}>
            Sign in to view notifications
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
          <Bell size={64} color="#444" style={{ marginBottom: 24 }} />
          <Text
            style={{
              fontSize: 20,
              fontWeight: "700",
              color: "#fff",
              marginBottom: 8,
              textAlign: "center",
            }}
          >
            Stay Updated
          </Text>
          <Text
            style={{
              fontSize: 14,
              color: "#888",
              marginBottom: 24,
              textAlign: "center",
            }}
          >
            Sign in to receive notifications about matches, achievements, and
            friend requests
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
        <View
          style={{
            flexDirection: "row",
            alignItems: "center",
            justifyContent: "space-between",
          }}
        >
          <View>
            <Text
              style={{
                color: "#FFF",
                fontSize: 28,
                fontWeight: "900",
                letterSpacing: 1,
              }}
            >
              NOTIFICATIONS
            </Text>
            {unreadCount > 0 && (
              <Text style={{ color: "#4BB8FA", fontSize: 14, marginTop: 4 }}>
                {unreadCount} unread
              </Text>
            )}
          </View>

          {unreadCount > 0 && (
            <TouchableOpacity
              onPress={markAllAsRead}
              style={{
                backgroundColor: "#1A2630",
                paddingHorizontal: 16,
                paddingVertical: 8,
                borderRadius: 10,
              }}
            >
              <Text
                style={{ color: "#4BB8FA", fontWeight: "700", fontSize: 13 }}
              >
                Mark all read
              </Text>
            </TouchableOpacity>
          )}
        </View>
      </View>

      <ScrollView
        style={{ flex: 1 }}
        contentContainerStyle={{ paddingBottom: insets.bottom + 20 }}
        showsVerticalScrollIndicator={false}
      >
        {notifications.length === 0 ? (
          <View
            style={{
              flex: 1,
              alignItems: "center",
              justifyContent: "center",
              paddingTop: 100,
            }}
          >
            <Text style={{ fontSize: 48, marginBottom: 16 }}>🔔</Text>
            <Text style={{ color: "#666", fontSize: 16, fontWeight: "600" }}>
              No notifications yet
            </Text>
            <Text style={{ color: "#444", fontSize: 14, marginTop: 8 }}>
              You'll see updates here
            </Text>
          </View>
        ) : (
          <View style={{ padding: 20, paddingTop: 16 }}>
            {notifications.map((notification) => (
              <TouchableOpacity
                key={notification.id}
                onPress={() =>
                  !notification.is_read && markAsRead(notification.id)
                }
                style={{
                  backgroundColor: notification.is_read ? "#070A0F" : "#0D1218",
                  borderWidth: 1,
                  borderColor: notification.is_read ? "#1A2630" : "#4BB8FA",
                  borderRadius: 16,
                  padding: 16,
                  marginBottom: 12,
                  flexDirection: "row",
                  alignItems: "flex-start",
                }}
              >
                <View
                  style={{
                    width: 40,
                    height: 40,
                    borderRadius: 20,
                    backgroundColor: notification.is_read
                      ? "#0D1218"
                      : "#1A3A4A",
                    alignItems: "center",
                    justifyContent: "center",
                    marginRight: 12,
                  }}
                >
                  {getIcon(notification.type)}
                </View>

                <View style={{ flex: 1 }}>
                  <View
                    style={{
                      flexDirection: "row",
                      alignItems: "center",
                      marginBottom: 4,
                    }}
                  >
                    <Text
                      style={{
                        color: notification.is_read ? "#888" : "#FFF",
                        fontSize: 15,
                        fontWeight: "700",
                        flex: 1,
                      }}
                    >
                      {notification.title}
                    </Text>
                    {!notification.is_read && (
                      <View
                        style={{
                          width: 8,
                          height: 8,
                          borderRadius: 4,
                          backgroundColor: "#4BB8FA",
                          marginLeft: 8,
                        }}
                      />
                    )}
                  </View>
                  <Text
                    style={{
                      color: notification.is_read ? "#555" : "#888",
                      fontSize: 13,
                      marginBottom: 6,
                    }}
                  >
                    {notification.message}
                  </Text>
                  <Text style={{ color: "#444", fontSize: 11 }}>
                    {new Date(notification.created_at).toLocaleString()}
                  </Text>
                </View>
              </TouchableOpacity>
            ))}
          </View>
        )}
      </ScrollView>
    </View>
  );
}
