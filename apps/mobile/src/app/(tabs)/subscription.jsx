import React, { useState, useEffect } from "react";
import {
  View,
  Text,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
  Alert,
  Linking,
  Platform,
} from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { StatusBar } from "expo-status-bar";
import { useRouter } from "expo-router";
import {
  ArrowLeft,
  Sparkles,
  RefreshCw,
  ExternalLink,
} from "lucide-react-native";
import { useInAppPurchase } from "@/utils/iap/useInAppPurchase";
import { authenticatedFetch } from "@/utils/authenticatedFetch";

export default function SubscriptionScreen() {
  const insets = useSafeAreaInsets();
  const router = useRouter();
  const { restorePurchases, isPurchasing } = useInAppPurchase();

  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [subscription, setSubscription] = useState(null);

  useEffect(() => {
    fetchSubscriptionStatus();
  }, []);

  const fetchSubscriptionStatus = async () => {
    try {
      const response = await authenticatedFetch("/api/subscription/status");
      if (response.ok) {
        const data = await response.json();
        setSubscription(data.subscription);
      } else {
        console.error("Failed to fetch subscription status");
      }
    } catch (error) {
      console.error("Error fetching subscription:", error);
    } finally {
      setLoading(false);
    }
  };

  const handleRefresh = async () => {
    setRefreshing(true);
    await fetchSubscriptionStatus();
    setRefreshing(false);
  };

  const handleManageSubscription = () => {
    if (Platform.OS === "ios") {
      Linking.openURL("https://apps.apple.com/account/subscriptions");
    } else if (Platform.OS === "android") {
      Linking.openURL("https://play.google.com/store/account/subscriptions");
    }
  };

  const handleRestorePurchases = async () => {
    const result = await restorePurchases();
    if (result.success) {
      Alert.alert(
        "Purchases Restored",
        "Your purchases have been restored successfully.",
        [{ text: "OK", onPress: handleRefresh }],
      );
    } else {
      Alert.alert(
        "Restore Failed",
        "Could not restore purchases. Please try again or contact support.",
        [{ text: "OK" }],
      );
    }
  };

  const getStatusColor = (status) => {
    switch (status?.toLowerCase()) {
      case "active":
        return "#22C55E";
      case "trial":
        return "#F59E0B";
      case "expired":
      case "cancelled":
        return "#6B7280";
      default:
        return "#6B7280";
    }
  };

  const getStatusLabel = (status) => {
    if (!status) return "Free";
    return status.charAt(0).toUpperCase() + status.slice(1).toLowerCase();
  };

  const getPlanName = (tier) => {
    if (!tier || tier === "free") return "Free Plan";
    return `${tier.charAt(0).toUpperCase()}${tier.slice(1)} Plan`;
  };

  const formatDate = (dateString) => {
    if (!dateString) return "N/A";
    const date = new Date(dateString);
    return date.toLocaleDateString("en-US", {
      month: "long",
      day: "numeric",
      year: "numeric",
    });
  };

  const isActive = subscription?.status === "active";

  if (loading) {
    return (
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
          }}
        >
          <TouchableOpacity
            onPress={() => router.back()}
            style={{
              marginRight: 16,
              width: 36,
              height: 36,
              alignItems: "center",
              justifyContent: "center",
            }}
          >
            <ArrowLeft size={24} color="#FFF" />
          </TouchableOpacity>
          <Text
            style={{
              color: "#FFF",
              fontSize: 22,
              fontWeight: "900",
              letterSpacing: 1,
            }}
          >
            SUBSCRIPTION
          </Text>
        </View>
        <View
          style={{ flex: 1, alignItems: "center", justifyContent: "center" }}
        >
          <ActivityIndicator size="large" color="#4BB8FA" />
        </View>
      </View>
    );
  }

  return (
    <View style={{ flex: 1, backgroundColor: "#010308" }}>
      <StatusBar style="light" />

      {/* Header */}
      <View
        style={{
          paddingTop: insets.top + 16,
          paddingHorizontal: 20,
          paddingBottom: 16,
          borderBottomWidth: 1,
          borderBottomColor: "#1A2630",
          flexDirection: "row",
          alignItems: "center",
        }}
      >
        <TouchableOpacity
          onPress={() => router.back()}
          style={{
            marginRight: 16,
            width: 36,
            height: 36,
            alignItems: "center",
            justifyContent: "center",
          }}
        >
          <ArrowLeft size={24} color="#FFF" />
        </TouchableOpacity>
        <Text
          style={{
            color: "#FFF",
            fontSize: 22,
            fontWeight: "900",
            letterSpacing: 1,
            flex: 1,
          }}
        >
          SUBSCRIPTION
        </Text>
        <TouchableOpacity
          onPress={handleRefresh}
          disabled={refreshing}
          style={{
            width: 36,
            height: 36,
            alignItems: "center",
            justifyContent: "center",
          }}
        >
          {refreshing ? (
            <ActivityIndicator size="small" color="#4BB8FA" />
          ) : (
            <RefreshCw size={20} color="#4BB8FA" />
          )}
        </TouchableOpacity>
      </View>

      <ScrollView
        contentContainerStyle={{
          paddingHorizontal: 20,
          paddingTop: 24,
          paddingBottom: insets.bottom + 40,
        }}
        showsVerticalScrollIndicator={false}
      >
        {/* Subscription Card */}
        <View
          style={{
            backgroundColor: "#0D1218",
            borderRadius: 20,
            borderWidth: 1,
            borderColor: isActive ? "#4BB8FA33" : "#1A2630",
            padding: 20,
            marginBottom: 32,
          }}
        >
          {/* Current Plan */}
          <View style={{ marginBottom: 20 }}>
            <Text
              style={{
                color: "#888",
                fontSize: 12,
                fontWeight: "600",
                marginBottom: 6,
                letterSpacing: 0.5,
              }}
            >
              CURRENT PLAN
            </Text>
            <View
              style={{ flexDirection: "row", alignItems: "center", gap: 8 }}
            >
              {isActive && <Sparkles size={20} color="#4BB8FA" />}
              <Text
                style={{
                  color: "#FFF",
                  fontSize: 20,
                  fontWeight: "800",
                  letterSpacing: 0.5,
                }}
              >
                {getPlanName(subscription?.tier)}
              </Text>
            </View>
          </View>

          {/* Divider */}
          <View
            style={{
              height: 1,
              backgroundColor: "#1A2630",
              marginBottom: 20,
            }}
          />

          {/* Status */}
          <View style={{ marginBottom: 16 }}>
            <Text
              style={{
                color: "#888",
                fontSize: 12,
                fontWeight: "600",
                marginBottom: 6,
                letterSpacing: 0.5,
              }}
            >
              STATUS
            </Text>
            <View
              style={{ flexDirection: "row", alignItems: "center", gap: 8 }}
            >
              <View
                style={{
                  width: 8,
                  height: 8,
                  borderRadius: 4,
                  backgroundColor: getStatusColor(subscription?.status),
                }}
              />
              <Text
                style={{
                  color: getStatusColor(subscription?.status),
                  fontSize: 16,
                  fontWeight: "700",
                }}
              >
                {getStatusLabel(subscription?.status)}
              </Text>
            </View>
          </View>

          {/* Next Billing Date */}
          {isActive && subscription?.expiresAt && (
            <View style={{ marginBottom: 16 }}>
              <Text
                style={{
                  color: "#888",
                  fontSize: 12,
                  fontWeight: "600",
                  marginBottom: 6,
                  letterSpacing: 0.5,
                }}
              >
                NEXT BILLING DATE
              </Text>
              <Text
                style={{
                  color: "#FFF",
                  fontSize: 15,
                  fontWeight: "600",
                }}
              >
                Renews on {formatDate(subscription.expiresAt)}
              </Text>
            </View>
          )}

          {/* Auto-Renew */}
          {isActive && (
            <View>
              <Text
                style={{
                  color: "#888",
                  fontSize: 12,
                  fontWeight: "600",
                  marginBottom: 6,
                  letterSpacing: 0.5,
                }}
              >
                AUTO-RENEW
              </Text>
              <Text
                style={{
                  color: "#FFF",
                  fontSize: 15,
                  fontWeight: "600",
                }}
              >
                Yes
              </Text>
            </View>
          )}
        </View>

        {/* Manage Section */}
        <Text
          style={{
            color: "#555",
            fontSize: 11,
            fontWeight: "700",
            letterSpacing: 1,
            marginBottom: 12,
          }}
        >
          MANAGE
        </Text>

        <View
          style={{
            backgroundColor: "#0D1218",
            borderRadius: 16,
            borderWidth: 1,
            borderColor: "#1A2630",
            overflow: "hidden",
            marginBottom: 32,
          }}
        >
          {/* Manage Subscription */}
          <TouchableOpacity
            onPress={handleManageSubscription}
            style={{
              flexDirection: "row",
              alignItems: "center",
              padding: 16,
              borderBottomWidth: 1,
              borderBottomColor: "#1A2630",
            }}
          >
            <View
              style={{
                backgroundColor: "#1A2630",
                width: 40,
                height: 40,
                borderRadius: 20,
                alignItems: "center",
                justifyContent: "center",
                marginRight: 12,
              }}
            >
              <ExternalLink size={20} color="#4BB8FA" />
            </View>
            <View style={{ flex: 1 }}>
              <Text
                style={{
                  color: "#FFF",
                  fontSize: 15,
                  fontWeight: "600",
                  marginBottom: 2,
                }}
              >
                Manage Subscription
              </Text>
              <Text style={{ color: "#666", fontSize: 12 }}>
                Open {Platform.OS === "ios" ? "App Store" : "Play Store"}{" "}
                settings
              </Text>
            </View>
            <ExternalLink size={16} color="#666" />
          </TouchableOpacity>

          {/* Restore Purchases */}
          <TouchableOpacity
            onPress={handleRestorePurchases}
            disabled={isPurchasing}
            style={{
              flexDirection: "row",
              alignItems: "center",
              padding: 16,
            }}
          >
            <View
              style={{
                backgroundColor: "#1A2630",
                width: 40,
                height: 40,
                borderRadius: 20,
                alignItems: "center",
                justifyContent: "center",
                marginRight: 12,
              }}
            >
              <RefreshCw size={20} color="#4BB8FA" />
            </View>
            <View style={{ flex: 1 }}>
              <Text
                style={{
                  color: "#FFF",
                  fontSize: 15,
                  fontWeight: "600",
                  marginBottom: 2,
                }}
              >
                Restore Purchases
              </Text>
              <Text style={{ color: "#666", fontSize: 12 }}>
                Sync previous purchases
              </Text>
            </View>
            {isPurchasing ? (
              <ActivityIndicator size="small" color="#4BB8FA" />
            ) : (
              <RefreshCw size={16} color="#666" />
            )}
          </TouchableOpacity>
        </View>

        {/* Footer Information */}
        <View
          style={{
            backgroundColor: "#0A0E14",
            borderRadius: 12,
            padding: 16,
            borderWidth: 1,
            borderColor: "#1A2630",
          }}
        >
          <Text
            style={{
              color: "#666",
              fontSize: 12,
              lineHeight: 18,
              textAlign: "center",
            }}
          >
            Subscription billing is managed by{" "}
            {Platform.OS === "ios" ? "Apple" : "Google"}. Changes or
            cancellations take effect according to your{" "}
            {Platform.OS === "ios" ? "App Store" : "Play Store"} subscription
            settings.
          </Text>
        </View>
      </ScrollView>
    </View>
  );
}
