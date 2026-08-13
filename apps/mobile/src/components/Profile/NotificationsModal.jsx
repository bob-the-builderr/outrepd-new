import React from "react";
import { View, Text, ScrollView, TouchableOpacity, Modal } from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { StatusBar } from "expo-status-bar";
import { Bell, X } from "lucide-react-native";
import { NOTIFICATION_META } from "@/constants/notifications";
import { formatTime } from "@/utils/formatTime";

export function NotificationsModal({
  visible,
  onClose,
  notifications,
  onMarkAllRead,
}) {
  const insets = useSafeAreaInsets();
  const unreadCount = notifications.filter((n) => !n.is_read).length;

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
              NOTIFICATIONS
            </Text>
            {unreadCount > 0 && (
              <Text style={{ color: "#4BB8FA", fontSize: 13, marginTop: 2 }}>
                {unreadCount} unread
              </Text>
            )}
          </View>
          <View style={{ flexDirection: "row", gap: 8, alignItems: "center" }}>
            {unreadCount > 0 && (
              <TouchableOpacity
                onPress={onMarkAllRead}
                style={{
                  backgroundColor: "#1A2630",
                  borderRadius: 20,
                  paddingHorizontal: 12,
                  paddingVertical: 8,
                }}
              >
                <Text
                  style={{ color: "#4BB8FA", fontSize: 12, fontWeight: "700" }}
                >
                  Mark all read
                </Text>
              </TouchableOpacity>
            )}
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
        </View>

        <ScrollView
          contentContainerStyle={{ paddingBottom: insets.bottom + 24 }}
          showsVerticalScrollIndicator={false}
        >
          {notifications.length === 0 ? (
            <View style={{ alignItems: "center", paddingTop: 70 }}>
              <Bell size={52} color="#1A2630" />
              <Text
                style={{
                  color: "#444",
                  fontSize: 16,
                  marginTop: 16,
                  fontWeight: "700",
                }}
              >
                No notifications yet
              </Text>
              <Text style={{ color: "#333", fontSize: 13, marginTop: 6 }}>
                We'll notify you about matches & achievements
              </Text>
            </View>
          ) : (
            <View style={{ paddingHorizontal: 20, paddingTop: 12 }}>
              {notifications.map((notif) => {
                const meta = NOTIFICATION_META[notif.type] || {
                  icon: <Bell size={20} color="#888" />,
                  bg: "#1A2630",
                };
                return (
                  <View
                    key={notif.id}
                    style={{
                      backgroundColor: notif.is_read ? "#070A0F" : "#0D1218",
                      borderWidth: 1,
                      borderColor: notif.is_read ? "#1A2630" : "#4BB8FA33",
                      borderRadius: 16,
                      padding: 14,
                      marginBottom: 10,
                      flexDirection: "row",
                      alignItems: "flex-start",
                    }}
                  >
                    <View
                      style={{
                        width: 44,
                        height: 44,
                        borderRadius: 22,
                        backgroundColor: meta.bg,
                        alignItems: "center",
                        justifyContent: "center",
                        marginRight: 12,
                      }}
                    >
                      {meta.icon}
                    </View>
                    <View style={{ flex: 1 }}>
                      <View
                        style={{
                          flexDirection: "row",
                          alignItems: "center",
                          gap: 6,
                          marginBottom: 3,
                        }}
                      >
                        {!notif.is_read && (
                          <View
                            style={{
                              width: 7,
                              height: 7,
                              borderRadius: 4,
                              backgroundColor: "#4BB8FA",
                            }}
                          />
                        )}
                        <Text
                          style={{
                            color: "#FFF",
                            fontSize: 14,
                            fontWeight: "700",
                            flex: 1,
                          }}
                          numberOfLines={1}
                        >
                          {notif.title}
                        </Text>
                      </View>
                      <Text
                        style={{
                          color: notif.is_read ? "#555" : "#AAA",
                          fontSize: 13,
                          lineHeight: 18,
                        }}
                      >
                        {notif.message}
                      </Text>
                      <Text
                        style={{ color: "#444", fontSize: 11, marginTop: 5 }}
                      >
                        {formatTime(notif.created_at)}
                      </Text>
                    </View>
                  </View>
                );
              })}
            </View>
          )}
        </ScrollView>
      </View>
    </Modal>
  );
}
