import React, { useState, useRef, useEffect } from "react";
import {
  View,
  Text,
  TouchableOpacity,
  ScrollView,
  ActivityIndicator,
  Animated,
  Alert,
  Linking,
} from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { StatusBar } from "expo-status-bar";
import { router } from "expo-router";
import { Image } from "expo-image";
import { Unlock, Bell, Star } from "lucide-react-native";
import { useInAppPurchase } from "@/utils/iap";
import { LinearGradient } from "expo-linear-gradient";
import { IS_TEST_MODE } from "@/utils/testMode";

function getTrialDays(pkg) {
  const intro = pkg?.product?.introductoryPrice;
  if (!intro || intro.paymentMode !== "FREE_TRIAL") return null;
  const unit = intro.periodUnit;
  const count = intro.periodNumberOfUnits ?? intro.cycles ?? 1;
  if (unit === "DAY") return count;
  if (unit === "WEEK") return count * 7;
  return 3;
}

function hasTrial(pkg) {
  return getTrialDays(pkg) !== null;
}

function isWeekly(pkg) {
  return (
    pkg?.packageType === "WEEKLY" ||
    pkg?.product?.identifier?.includes("weekly") ||
    pkg?.product?.subscriptionPeriod === "P1W"
  );
}

function isAnnual(pkg) {
  return (
    pkg?.packageType === "ANNUAL" ||
    pkg?.product?.identifier?.includes("annual") ||
    pkg?.product?.subscriptionPeriod === "P1Y"
  );
}

function getLabel(pkg) {
  if (isWeekly(pkg)) return "Weekly";
  if (isAnnual(pkg)) return "Annual";
  return pkg?.product?.title || "Plan";
}

function getPrice(pkg) {
  return pkg?.product?.priceString || pkg?.product?.localizedPrice || "—";
}

function getPriceSubtitle(pkg) {
  const trialDays = getTrialDays(pkg);
  const price = getPrice(pkg);
  if (trialDays) {
    const period = isWeekly(pkg) ? "week" : isAnnual(pkg) ? "year" : "period";
    return `${trialDays}-day free trial · then ${price}/${period}`;
  }
  if (isWeekly(pkg)) return `${price} / week · billed weekly`;
  if (isAnnual(pkg)) return `${price} / year · billed annually`;
  return "";
}

export default function PaywallScreen() {
  const insets = useSafeAreaInsets();
  const {
    getAvailableSubscriptions,
    purchasePackage,
    restorePurchases,
    isReady,
    isPurchasing,
  } = useInAppPurchase();

  const [selectedPkg, setSelectedPkg] = useState(null);
  const [isRestoring, setIsRestoring] = useState(false);

  const fadeIn = useRef(new Animated.Value(0)).current;
  const slideUp = useRef(new Animated.Value(40)).current;

  useEffect(() => {
    Animated.parallel([
      Animated.timing(fadeIn, {
        toValue: 1,
        duration: 400,
        useNativeDriver: true,
      }),
      Animated.timing(slideUp, {
        toValue: 0,
        duration: 400,
        useNativeDriver: true,
      }),
    ]).start();
  }, []);

  useEffect(() => {
    if (isReady) {
      const pkgs = getAvailableSubscriptions();
      const annual = pkgs.find((p) => isAnnual(p));
      const weekly = pkgs.find((p) => isWeekly(p));
      setSelectedPkg(annual || weekly || pkgs[0] || null);
    }
  }, [isReady]);

  const packages = getAvailableSubscriptions();
  const anyTrialAvailable = packages.some((p) => hasTrial(p));
  const trialDaysHero = anyTrialAvailable
    ? getTrialDays(packages.find((p) => hasTrial(p))) ?? 3
    : null;

  // ── Timeline data (drives the "Today / Reminder / Billing starts" card) ──
  const trialDaysForTimeline = trialDaysHero ?? 3;
  const reminderDay = Math.max(trialDaysForTimeline - 1, 1);

  const timelineSteps = [
    {
      icon: Unlock,
      color: "#22C55E",
      filled: true,
      label: "Today",
      sub: "Full Pro access instantly. No money required.",
    },
    {
      icon: Bell,
      color: "#4BB8FA",
      filled: true,
      label: `Day ${reminderDay}`,
      sub: "Apple notifies you 1 day before your trial ends.",
    },
    {
      icon: Star,
      color: "#FFD700",
      filled: false,
      label: `Day ${trialDaysForTimeline}`,
      sub: "Subscription begins. Cancel anytime in Settings.",
    },
  ];

  const handlePurchase = async () => {
    if (!selectedPkg) return;
    const result = await purchasePackage({ pkg: selectedPkg });
    if (result.success) {
      router.replace("/(tabs)");
    } else if (!result.cancelled) {
      Alert.alert(
        "Purchase Failed",
        "Something went wrong. Please try again or restore purchases.",
        [{ text: "OK" }]
      );
    }
  };

  const handleRestore = async () => {
    setIsRestoring(true);
    const result = await restorePurchases();
    setIsRestoring(false);
    if (result.success) {
      const active = result.customerInfo?.entitlements?.active || {};
      if (Object.keys(active).length > 0) {
        router.replace("/(tabs)");
      } else {
        Alert.alert(
          "No Active Subscription",
          "We couldn't find an active subscription tied to your account.",
          [{ text: "OK" }]
        );
      }
    } else {
      Alert.alert("Restore Failed", "Please try again later.", [
        { text: "OK" },
      ]);
    }
  };

  const selectedHasTrial = selectedPkg
    ? hasTrial(selectedPkg)
    : anyTrialAvailable;
  const ctaLabel = "Continue";

  return (
    <View style={{ flex: 1, backgroundColor: "#010308" }}>
      <StatusBar style="light" />

      {/* ── Scrollable Top Content ── */}
      <Animated.ScrollView
        style={{ opacity: fadeIn }}
        contentContainerStyle={{
          paddingTop: insets.top + 32,
          paddingBottom: 300, // space for sticky bottom
        }}
        showsVerticalScrollIndicator={false}
      >
        {/* ── Hero: Logo + Heading ── */}
        <Animated.View
          style={{
            transform: [{ translateY: slideUp }],
            alignItems: "center",
            paddingHorizontal: 24,
            paddingBottom: 32,
          }}
        >
          {/* App Logo */}
          <Image
            source={{
              uri: "https://dtvoeevhaseb5.cloudfront.net/user-uploads/10341004-1568-4639-9f40-8061c2cb7d4a.png",
            }}
            style={{
              width: 96,
              height: 96,
              borderRadius: 22,
              marginBottom: 24,
            }}
            contentFit="contain"
            transition={200}
          />

          <Text
            style={{
              color: "#FFFFFF",
              fontSize: 30,
              fontWeight: "900",
              letterSpacing: 0.5,
              marginBottom: 12,
              textAlign: "center",
            }}
          >
            Unlock Full Access
          </Text>

          <Text
            style={{
              color: "#778899",
              fontSize: 14,
              textAlign: "center",
              lineHeight: 22,
              maxWidth: 280,
            }}
          >
            Try everything free for {trialDaysHero ?? 3} days. Cancel anytime
            before the trial ends and you won't be charged.
          </Text>
        </Animated.View>

        {/* ── Payment Process: Vertical Timeline ── */}
        <Animated.View
          style={{
            transform: [{ translateY: slideUp }],
            paddingHorizontal: 28,
            marginBottom: 28,
          }}
        >
          <View style={{ position: "relative" }}>
            {/* Continuous Left Bar Track */}
            <View
              style={{
                position: "absolute",
                left: 0,
                top: -4,
                bottom: -15, // Extends slightly past the last icon to fade out
                width: 32,
                borderRadius: 16,
                backgroundColor: "#4BB8FA",
                overflow: "hidden",
              }}
            >
              <LinearGradient
                colors={["#4BB8FA", "#4BB8FA", "rgba(75, 184, 250, 0)"]}
                locations={[0, 0.5, 1]}
                style={{
                  position: "absolute",
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                }}
              />
            </View>

            {timelineSteps.map((step, idx) => {
              const Icon = step.icon;
              const isLast = idx === timelineSteps.length - 1;

              return (
                <View
                  key={idx}
                  style={{
                    flexDirection: "row",
                    marginBottom: isLast ? 0 : 28,
                  }}
                >
                  {/* Icon column (aligned over the absolute track) */}
                  <View
                    style={{
                      width: 32,
                      height: 32,
                      alignItems: "center",
                      justifyContent: "center",
                      marginRight: 16,
                    }}
                  >
                    <Icon size={16} color="#FFFFFF" strokeWidth={2.5} />
                  </View>

                  {/* Text column */}
                  <View style={{ flex: 1, justifyContent: "center" }}>
                    <Text
                      style={{
                        color: "#FFFFFF",
                        fontSize: 18,
                        fontWeight: "800",
                        marginBottom: 4,
                      }}
                    >
                      {step.label}
                    </Text>
                    <Text
                      style={{
                        color: "#778899",
                        fontSize: 13,
                        lineHeight: 18,
                      }}
                    >
                      {step.sub}
                    </Text>
                  </View>
                </View>
              );
            })}
          </View>
        </Animated.View>
      </Animated.ScrollView>

      {/* ── Sticky Bottom: Plans + CTA ── */}
      <Animated.View
        style={{
          position: "absolute",
          bottom: 0,
          left: 0,
          right: 0,
          backgroundColor: "#010308",
          borderTopWidth: 1,
          borderTopColor: "#1A2630",
          paddingTop: 16,
          paddingBottom: insets.bottom + 16,
          paddingHorizontal: 20,
          opacity: fadeIn,
        }}
      >
        {/* Plan selector */}
        <Text
          style={{
            color: "#555",
            fontSize: 11,
            fontWeight: "700",
            letterSpacing: 1,
            marginBottom: 10,
          }}
        >
          CHOOSE YOUR PLAN
        </Text>

        {!isReady ? (
          <View
            style={{
              height: 60,
              alignItems: "center",
              justifyContent: "center",
            }}
          >
            <ActivityIndicator color="#4BB8FA" />
          </View>
        ) : packages.length === 0 ? (
          <View
            style={{
              height: 50,
              alignItems: "center",
              justifyContent: "center",
            }}
          >
            <Text style={{ color: "#556070", fontSize: 13 }}>
              No plans available right now.
            </Text>
          </View>
        ) : (
          <View style={{ gap: 8, marginBottom: 14 }}>
            {packages.map((pkg, i) => {
              const isSelected =
                selectedPkg?.product?.identifier === pkg.product?.identifier;
              const annual = isAnnual(pkg);
              const pkgHasTrial = hasTrial(pkg);
              const trialDays = getTrialDays(pkg);

              return (
                <TouchableOpacity
                  key={i}
                  onPress={() => setSelectedPkg(pkg)}
                  activeOpacity={0.85}
                  style={{
                    backgroundColor: isSelected ? "#0E1F2E" : "#0A0F18",
                    borderRadius: 14,
                    borderWidth: isSelected ? 1.5 : 1,
                    borderColor: isSelected ? "#4BB8FA" : "#1A2630",
                    padding: 14,
                  }}
                >
                  <View style={{ flexDirection: "row", alignItems: "center" }}>
                    {/* Radio */}
                    <View
                      style={{
                        width: 20,
                        height: 20,
                        borderRadius: 10,
                        borderWidth: 2,
                        borderColor: isSelected ? "#4BB8FA" : "#2A3640",
                        alignItems: "center",
                        justifyContent: "center",
                        marginRight: 12,
                      }}
                    >
                      {isSelected && (
                        <View
                          style={{
                            width: 10,
                            height: 10,
                            borderRadius: 5,
                            backgroundColor: "#4BB8FA",
                          }}
                        />
                      )}
                    </View>

                    {/* Labels */}
                    <View style={{ flex: 1 }}>
                      <View
                        style={{
                          flexDirection: "row",
                          alignItems: "center",
                          gap: 6,
                          flexWrap: "wrap",
                          marginBottom: 2,
                        }}
                      >
                        <Text
                          style={{
                            color: "#FFF",
                            fontSize: 15,
                            fontWeight: "800",
                          }}
                        >
                          {getLabel(pkg)}
                        </Text>
                        {pkgHasTrial && (
                          <View
                            style={{
                              backgroundColor: "#0F2A1A",
                              borderRadius: 6,
                              borderWidth: 1,
                              borderColor: "#22C55E66",
                              paddingHorizontal: 6,
                              paddingVertical: 2,
                            }}
                          >
                            <Text
                              style={{
                                color: "#22C55E",
                                fontSize: 10,
                                fontWeight: "800",
                              }}
                            >
                              {trialDays}D FREE
                            </Text>
                          </View>
                        )}
                        {annual && (
                          <View
                            style={{
                              backgroundColor: "#4BB8FA22",
                              borderRadius: 6,
                              borderWidth: 1,
                              borderColor: "#4BB8FA55",
                              paddingHorizontal: 6,
                              paddingVertical: 2,
                            }}
                          >
                            <Text
                              style={{
                                color: "#4BB8FA",
                                fontSize: 10,
                                fontWeight: "800",
                              }}
                            >
                              BEST VALUE
                            </Text>
                          </View>
                        )}
                      </View>
                      <Text
                        style={{
                          color: pkgHasTrial ? "#22C55E99" : "#556070",
                          fontSize: 11,
                        }}
                      >
                        {getPriceSubtitle(pkg)}
                      </Text>
                    </View>

                    {/* Price */}
                    <View style={{ alignItems: "flex-end" }}>
                      {pkgHasTrial ? (
                        <>
                          <Text
                            style={{
                              color: "#22C55E",
                              fontSize: 16,
                              fontWeight: "900",
                            }}
                          >
                            FREE
                          </Text>
                          <Text style={{ color: "#556070", fontSize: 10 }}>
                            for {trialDays} days
                          </Text>
                        </>
                      ) : (
                        <>
                          <Text
                            style={{
                              color: isSelected ? "#4BB8FA" : "#FFF",
                              fontSize: 16,
                              fontWeight: "900",
                            }}
                          >
                            {getPrice(pkg)}
                          </Text>
                          <Text style={{ color: "#556070", fontSize: 10 }}>
                            {isWeekly(pkg) ? "/ week" : annual ? "/ year" : ""}
                          </Text>
                        </>
                      )}
                    </View>
                  </View>
                </TouchableOpacity>
              );
            })}
          </View>
        )}

        {/* CTA Button */}
        <View style={{ marginBottom: 10 }}>
          <TouchableOpacity
            onPress={handlePurchase}
            disabled={isPurchasing || !selectedPkg || !isReady}
            activeOpacity={0.88}
            style={{
              backgroundColor: !selectedPkg || !isReady ? "#1A2630" : "#4BB8FA",
              borderRadius: 16,
              paddingVertical: 17,
              alignItems: "center",
              justifyContent: "center",
            }}
          >
            {isPurchasing ? (
              <ActivityIndicator color="#000" />
            ) : (
              <>
                <Text
                  style={{
                    color: !selectedPkg || !isReady ? "#444" : "#000",
                    fontSize: 16,
                    fontWeight: "900",
                    letterSpacing: 1.2,
                  }}
                >
                  {ctaLabel}
                </Text>
                {selectedHasTrial && selectedPkg && (
                  <Text
                    style={{
                      color: "#00000077",
                      fontSize: 11,
                      fontWeight: "600",
                      marginTop: 2,
                    }}
                  >
                    No payment due today
                  </Text>
                )}
              </>
            )}
          </TouchableOpacity>
        </View>

        {/* Test builds: always leave a way out of the paywall */}
        {IS_TEST_MODE && (
          <TouchableOpacity
            onPress={() => router.replace("/(tabs)")}
            style={{
              alignItems: "center",
              paddingVertical: 10,
              marginBottom: 6,
              borderRadius: 12,
              borderWidth: 1,
              borderStyle: "dashed",
              borderColor: "#4BB8FA",
            }}
          >
            <Text style={{ color: "#4BB8FA", fontSize: 13, fontWeight: "700" }}>
              ⚡ Skip payment (test build)
            </Text>
          </TouchableOpacity>
        )}

        {/* Restore + Legal */}
        <TouchableOpacity
          onPress={handleRestore}
          disabled={isRestoring}
          style={{ alignItems: "center", paddingVertical: 4, marginBottom: 6 }}
        >
          {isRestoring ? (
            <ActivityIndicator size="small" color="#556070" />
          ) : (
            <Text
              style={{
                color: "#556070",
                fontSize: 12,
                textDecorationLine: "underline",
              }}
            >
              Restore Purchases
            </Text>
          )}
        </TouchableOpacity>

        <Text
          style={{
            color: "#333A44",
            fontSize: 10,
            textAlign: "center",
            lineHeight: 14,
          }}
        >
          {trialDaysHero ?? 3}-day free trial for new subscribers only.
          Auto-renews unless cancelled 24h before renewal. Manage in Apple ID
          settings.{" "}
          <Text
            onPress={() => Linking.openURL("https://www.outrepd.com/privacy")}
            style={{ color: "#556070", textDecorationLine: "underline" }}
          >
            Privacy Policy
          </Text>
          {" · "}
          <Text
            onPress={() => Linking.openURL("https://www.outrepd.com/terms")}
            style={{ color: "#556070", textDecorationLine: "underline" }}
          >
            Terms of Service
          </Text>
        </Text>
      </Animated.View>
    </View>
  );
}