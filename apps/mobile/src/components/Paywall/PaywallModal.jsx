import React, { useState, useRef, useEffect } from "react";
import {
  View,
  Text,
  Modal,
  TouchableOpacity,
  ScrollView,
  ActivityIndicator,
  Animated,
  Alert,
  Linking,
} from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { StatusBar } from "expo-status-bar";
import {
  X,
  Zap,
  Trophy,
  BarChart2,
  Swords,
  Crown,
  Star,
  Check,
  Gift,
} from "lucide-react-native";
import { Image } from "expo-image";
import { useInAppPurchase } from "@/utils/iap";

// ── Trial helpers ──────────────────────────────────────────────
// RevenueCat exposes introductoryPrice on the product object when
// an introductory offer (free trial) is configured in App Store Connect.
function getTrialDays(pkg) {
  const intro = pkg?.product?.introductoryPrice;
  if (!intro || intro.paymentMode !== "FREE_TRIAL") return null;
  const unit = intro.periodUnit; // "DAY" | "WEEK" | "MONTH" | "YEAR"
  const count = intro.periodNumberOfUnits ?? intro.cycles ?? 1;
  if (unit === "DAY") return count;
  if (unit === "WEEK") return count * 7;
  // Fallback: assume 3 days if trial exists but period can't be parsed
  return 3;
}

function hasTrial(pkg) {
  return getTrialDays(pkg) !== null;
}

function trialLabel(pkg) {
  const days = getTrialDays(pkg);
  if (!days) return null;
  return `${days}-day free trial`;
}

// ── Plan type helpers ──────────────────────────────────────────
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
  const trial = trialLabel(pkg);
  const price = getPrice(pkg);
  if (trial) {
    const period = isWeekly(pkg) ? "week" : isAnnual(pkg) ? "year" : "period";
    return `${trial} · then ${price}/${period}`;
  }
  if (isWeekly(pkg)) return `${price} / week · billed weekly`;
  if (isAnnual(pkg)) return `${price} / year · billed annually`;
  return "";
}

// ──────────────────────────────────────────────────────────────

export function PaywallModal({ visible, onClose, onSubscribed }) {
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

  const shimmer = useRef(new Animated.Value(0)).current;
  const fadeIn = useRef(new Animated.Value(0)).current;
  const slideUp = useRef(new Animated.Value(40)).current;
  const trialBadgePulse = useRef(new Animated.Value(1)).current;

  useEffect(() => {
    if (visible) {
      fadeIn.setValue(0);
      slideUp.setValue(40);

      Animated.parallel([
        Animated.timing(fadeIn, {
          toValue: 1,
          duration: 350,
          useNativeDriver: true,
        }),
        Animated.timing(slideUp, {
          toValue: 0,
          duration: 350,
          useNativeDriver: true,
        }),
      ]).start();

      // CTA shimmer pulse
      Animated.loop(
        Animated.sequence([
          Animated.timing(shimmer, {
            toValue: 1,
            duration: 1800,
            useNativeDriver: true,
          }),
          Animated.timing(shimmer, {
            toValue: 0,
            duration: 1800,
            useNativeDriver: true,
          }),
        ]),
      ).start();

      // Trial badge heartbeat
      Animated.loop(
        Animated.sequence([
          Animated.timing(trialBadgePulse, {
            toValue: 1.06,
            duration: 900,
            useNativeDriver: true,
          }),
          Animated.timing(trialBadgePulse, {
            toValue: 1,
            duration: 900,
            useNativeDriver: true,
          }),
        ]),
      ).start();
    } else {
      fadeIn.setValue(0);
      slideUp.setValue(40);
    }
  }, [visible]);

  // Auto-select annual (best value) on open
  useEffect(() => {
    if (visible && isReady) {
      const pkgs = getAvailableSubscriptions();
      const annual = pkgs.find((p) => isAnnual(p));
      const weekly = pkgs.find((p) => isWeekly(p));
      setSelectedPkg(annual || weekly || pkgs[0] || null);
    }
  }, [visible, isReady]);

  const packages = getAvailableSubscriptions();

  // Whether ANY plan has a trial (drives hero messaging)
  const anyTrialAvailable = packages.some((p) => hasTrial(p));
  const trialDaysHero = anyTrialAvailable
    ? (getTrialDays(packages.find((p) => hasTrial(p))) ?? 3)
    : null;

  const handlePurchase = async () => {
    if (!selectedPkg) return;
    const result = await purchasePackage({ pkg: selectedPkg });
    if (result.success) {
      onSubscribed?.();
      onClose();
    } else if (!result.cancelled) {
      Alert.alert(
        "Purchase Failed",
        "Something went wrong. Please try again or restore purchases.",
        [{ text: "OK" }],
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
        Alert.alert("Restored!", "Your Pro subscription has been restored.", [
          {
            text: "Awesome!",
            onPress: () => {
              onSubscribed?.();
              onClose();
            },
          },
        ]);
      } else {
        Alert.alert(
          "No Active Subscription",
          "We couldn't find an active subscription tied to your account.",
          [{ text: "OK" }],
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
  const ctaLabel = selectedHasTrial
    ? `START ${trialDaysHero ?? 3}-DAY FREE TRIAL`
    : "START PRO";

  const ctaScale = shimmer.interpolate({
    inputRange: [0, 1],
    outputRange: [0.97, 1],
  });

  return (
    <Modal
      visible={visible}
      animationType="slide"
      presentationStyle="pageSheet"
      onRequestClose={onClose}
    >
      <View style={{ flex: 1, backgroundColor: "#010308" }}>
        <StatusBar style="light" />

        {/* Close */}
        <TouchableOpacity
          onPress={onClose}
          style={{
            position: "absolute",
            top: insets.top + 14,
            right: 20,
            zIndex: 10,
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

        <Animated.ScrollView
          style={{ opacity: fadeIn }}
          contentContainerStyle={{
            paddingTop: insets.top + 24,
            paddingBottom: insets.bottom + 200, // Extra space for sticky bottom
          }}
          showsVerticalScrollIndicator={false}
        >
          {/* ── Hero with Logo ── */}
          <Animated.View
            style={{
              transform: [{ translateY: slideUp }],
              alignItems: "center",
              paddingHorizontal: 24,
              paddingBottom: 28,
            }}
          >
            {/* App Logo */}
            <Image
              source={{
                uri: "https://dtvoeevhaseb5.cloudfront.net/user-uploads/10341004-1568-4639-9f40-8061c2cb7d4a.png",
              }}
              style={{
                width: 100,
                height: 100,
                borderRadius: 20,
                marginBottom: 24,
              }}
              contentFit="cover"
              transition={200}
            />

            {/* Unlock Full Access heading */}
            <Text
              style={{
                color: "#FFFFFF",
                fontSize: 28,
                fontWeight: "900",
                letterSpacing: 1,
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
                lineHeight: 21,
                maxWidth: 270,
              }}
            >
              Try everything free for 3 days. Cancel anytime before the trial
              ends and you won't be charged.
            </Text>
          </Animated.View>

          {/* ── Payment Process Timeline ── */}
          <Animated.View
            style={{
              transform: [{ translateY: slideUp }],
              paddingHorizontal: 20,
              marginBottom: 32,
            }}
          >
            <View
              style={{
                backgroundColor: "#0A0F18",
                borderRadius: 16,
                borderWidth: 1,
                borderColor: "#1A2630",
                padding: 18,
              }}
            >
              <View
                style={{
                  flexDirection: "row",
                  alignItems: "center",
                  justifyContent: "center",
                  marginBottom: 10,
                }}
              >
                {/* Step 1 dot - Free Trial (Green) */}
                <View style={{ alignItems: "center" }}>
                  <View
                    style={{
                      width: 12,
                      height: 12,
                      borderRadius: 6,
                      backgroundColor: "#22C55E",
                    }}
                  />
                  <Text
                    style={{
                      color: "#22C55E",
                      fontSize: 10,
                      fontWeight: "700",
                      marginTop: 6,
                    }}
                  >
                    FREE
                  </Text>
                </View>

                {/* Connector line */}
                <View
                  style={{
                    height: 2,
                    width: 60,
                    backgroundColor: "#1A2630",
                    marginHorizontal: 12,
                  }}
                />

                {/* Step 2 dot - Payment (Blue) */}
                <View style={{ alignItems: "center" }}>
                  <View
                    style={{
                      width: 12,
                      height: 12,
                      borderRadius: 6,
                      backgroundColor: "#4BB8FA",
                    }}
                  />
                  <Text
                    style={{
                      color: "#4BB8FA",
                      fontSize: 10,
                      fontWeight: "700",
                      marginTop: 6,
                    }}
                  >
                    DAY 3
                  </Text>
                </View>

                {/* Connector line */}
                <View
                  style={{
                    height: 2,
                    width: 60,
                    backgroundColor: "#1A2630",
                    marginHorizontal: 12,
                  }}
                />

                {/* Step 3 dot - Subscription (Gold) */}
                <View style={{ alignItems: "center" }}>
                  <View
                    style={{
                      width: 12,
                      height: 12,
                      borderRadius: 6,
                      backgroundColor: "#FFD700",
                    }}
                  />
                  <Text
                    style={{
                      color: "#FFD700",
                      fontSize: 10,
                      fontWeight: "700",
                      marginTop: 6,
                    }}
                  >
                    RENEW
                  </Text>
                </View>
              </View>

              {/* Divider */}
              <View
                style={{
                  height: 1,
                  backgroundColor: "#1A2630",
                  marginVertical: 16,
                }}
              />

              {/* Step 1 */}
              <View
                style={{
                  flexDirection: "row",
                  alignItems: "flex-start",
                  marginBottom: 14,
                }}
              >
                <View
                  style={{
                    width: 28,
                    height: 28,
                    borderRadius: 14,
                    backgroundColor: "#22C55E22",
                    borderWidth: 1,
                    borderColor: "#22C55E66",
                    alignItems: "center",
                    justifyContent: "center",
                    marginRight: 12,
                    marginTop: 1,
                  }}
                >
                  <Text
                    style={{
                      color: "#22C55E",
                      fontSize: 12,
                      fontWeight: "900",
                    }}
                  >
                    1
                  </Text>
                </View>
                <View style={{ flex: 1 }}>
                  <Text
                    style={{
                      color: "#FFF",
                      fontSize: 13,
                      fontWeight: "700",
                      marginBottom: 2,
                    }}
                  >
                    Today — No charge
                  </Text>
                  <Text style={{ color: "#556070", fontSize: 12 }}>
                    Full Pro access. No money required.
                  </Text>
                </View>
              </View>

              {/* Connector */}
              <View
                style={{
                  width: 1,
                  height: 12,
                  backgroundColor: "#1A2630",
                  marginLeft: 13,
                  marginBottom: 14,
                }}
              />

              {/* Step 2 */}
              <View
                style={{
                  flexDirection: "row",
                  alignItems: "flex-start",
                  marginBottom: 14,
                }}
              >
                <View
                  style={{
                    width: 28,
                    height: 28,
                    borderRadius: 14,
                    backgroundColor: "#4BB8FA18",
                    borderWidth: 1,
                    borderColor: "#4BB8FA44",
                    alignItems: "center",
                    justifyContent: "center",
                    marginRight: 12,
                    marginTop: 1,
                  }}
                >
                  <Text
                    style={{
                      color: "#4BB8FA",
                      fontSize: 12,
                      fontWeight: "900",
                    }}
                  >
                    2
                  </Text>
                </View>
                <View style={{ flex: 1 }}>
                  <Text
                    style={{
                      color: "#FFF",
                      fontSize: 13,
                      fontWeight: "700",
                      marginBottom: 2,
                    }}
                  >
                    Day 2 — Reminder
                  </Text>
                  <Text style={{ color: "#556070", fontSize: 12 }}>
                    Apple notifies you 1 day before trial ends.
                  </Text>
                </View>
              </View>

              {/* Connector */}
              <View
                style={{
                  width: 1,
                  height: 12,
                  backgroundColor: "#1A2630",
                  marginLeft: 13,
                  marginBottom: 14,
                }}
              />

              {/* Step 3 */}
              <View style={{ flexDirection: "row", alignItems: "flex-start" }}>
                <View
                  style={{
                    width: 28,
                    height: 28,
                    borderRadius: 14,
                    backgroundColor: "#FFD70018",
                    borderWidth: 1,
                    borderColor: "#FFD70044",
                    alignItems: "center",
                    justifyContent: "center",
                    marginRight: 12,
                    marginTop: 1,
                  }}
                >
                  <Text
                    style={{
                      color: "#FFD700",
                      fontSize: 12,
                      fontWeight: "900",
                    }}
                  >
                    3
                  </Text>
                </View>
                <View style={{ flex: 1 }}>
                  <Text
                    style={{
                      color: "#FFF",
                      fontSize: 13,
                      fontWeight: "700",
                      marginBottom: 2,
                    }}
                  >
                    Day 3 — Trial ends
                  </Text>
                  <Text style={{ color: "#556070", fontSize: 12 }}>
                    Subscription begins. Cancel anytime in Settings.
                  </Text>
                </View>
              </View>
            </View>
          </Animated.View>
        </Animated.ScrollView>

        {/* ── Sticky Bottom Section (Plans + CTA) ── */}
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
            transform: [{ translateY: slideUp }],
          }}
        >
          {/* Plan selector */}
          <View style={{ marginBottom: 16 }}>
            <Text
              style={{
                color: "#555",
                fontSize: 11,
                fontWeight: "700",
                letterSpacing: 1,
                marginBottom: 12,
              }}
            >
              CHOOSE YOUR PLAN
            </Text>

            {!isReady ? (
              <View
                style={{
                  height: 80,
                  alignItems: "center",
                  justifyContent: "center",
                }}
              >
                <ActivityIndicator color="#4BB8FA" />
              </View>
            ) : packages.length === 0 ? (
              <View
                style={{
                  height: 60,
                  alignItems: "center",
                  justifyContent: "center",
                }}
              >
                <Text style={{ color: "#556070", fontSize: 13 }}>
                  No plans available right now.
                </Text>
              </View>
            ) : (
              <View style={{ gap: 10 }}>
                {packages.map((pkg, i) => {
                  const isSelected =
                    selectedPkg?.product?.identifier ===
                    pkg.product?.identifier;
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
                        borderRadius: 16,
                        borderWidth: isSelected ? 1.5 : 1,
                        borderColor: isSelected ? "#4BB8FA" : "#1A2630",
                        padding: 16,
                        shadowColor: isSelected ? "#4BB8FA" : "transparent",
                        shadowOffset: { width: 0, height: 0 },
                        shadowOpacity: isSelected ? 0.18 : 0,
                        shadowRadius: 12,
                      }}
                    >
                      {/* Top row */}
                      <View
                        style={{ flexDirection: "row", alignItems: "center" }}
                      >
                        {/* Radio */}
                        <View
                          style={{
                            width: 22,
                            height: 22,
                            borderRadius: 11,
                            borderWidth: 2,
                            borderColor: isSelected ? "#4BB8FA" : "#2A3640",
                            alignItems: "center",
                            justifyContent: "center",
                            marginRight: 14,
                          }}
                        >
                          {isSelected && (
                            <View
                              style={{
                                width: 12,
                                height: 12,
                                borderRadius: 6,
                                backgroundColor: "#4BB8FA",
                              }}
                            />
                          )}
                        </View>

                        {/* Plan name + badges */}
                        <View style={{ flex: 1 }}>
                          <View
                            style={{
                              flexDirection: "row",
                              alignItems: "center",
                              gap: 6,
                              flexWrap: "wrap",
                              marginBottom: 3,
                            }}
                          >
                            <Text
                              style={{
                                color: "#FFF",
                                fontSize: 16,
                                fontWeight: "800",
                              }}
                            >
                              {getLabel(pkg)}
                            </Text>

                            {/* 3-day trial badge on the card */}
                            {pkgHasTrial && (
                              <View
                                style={{
                                  backgroundColor: "#0F2A1A",
                                  borderRadius: 6,
                                  borderWidth: 1,
                                  borderColor: "#22C55E66",
                                  paddingHorizontal: 7,
                                  paddingVertical: 2,
                                }}
                              >
                                <Text
                                  style={{
                                    color: "#22C55E",
                                    fontSize: 10,
                                    fontWeight: "800",
                                    letterSpacing: 0.3,
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
                                  paddingHorizontal: 7,
                                  paddingVertical: 2,
                                }}
                              >
                                <Text
                                  style={{
                                    color: "#4BB8FA",
                                    fontSize: 10,
                                    fontWeight: "800",
                                    letterSpacing: 0.3,
                                  }}
                                >
                                  BEST VALUE
                                </Text>
                              </View>
                            )}
                          </View>

                          {/* Price subtitle */}
                          <Text
                            style={{
                              color: pkgHasTrial ? "#22C55E99" : "#556070",
                              fontSize: 12,
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
                                  fontSize: 17,
                                  fontWeight: "900",
                                }}
                              >
                                FREE
                              </Text>
                              <Text style={{ color: "#556070", fontSize: 11 }}>
                                for {trialDays} days
                              </Text>
                            </>
                          ) : (
                            <>
                              <Text
                                style={{
                                  color: isSelected ? "#4BB8FA" : "#FFF",
                                  fontSize: 18,
                                  fontWeight: "900",
                                }}
                              >
                                {getPrice(pkg)}
                              </Text>
                              <Text style={{ color: "#556070", fontSize: 11 }}>
                                {isWeekly(pkg)
                                  ? "/ week"
                                  : annual
                                    ? "/ year"
                                    : ""}
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
          </View>

          {/* ── CTA ── */}
          <View style={{ gap: 12 }}>
            <Animated.View style={{ transform: [{ scale: ctaScale }] }}>
              <TouchableOpacity
                onPress={handlePurchase}
                disabled={isPurchasing || !selectedPkg || !isReady}
                activeOpacity={0.88}
                style={{
                  backgroundColor:
                    !selectedPkg || !isReady ? "#1A2630" : "#22C55E",
                  borderRadius: 16,
                  paddingVertical: 18,
                  alignItems: "center",
                  justifyContent: "center",
                  shadowColor: "#22C55E",
                  shadowOffset: { width: 0, height: 4 },
                  shadowOpacity: selectedPkg && isReady ? 0.45 : 0,
                  shadowRadius: 16,
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
                          marginTop: 3,
                        }}
                      >
                        No payment due today
                      </Text>
                    )}
                  </>
                )}
              </TouchableOpacity>
            </Animated.View>

            {/* Restore */}
            <TouchableOpacity
              onPress={handleRestore}
              disabled={isRestoring}
              style={{ alignItems: "center", paddingVertical: 6 }}
            >
              {isRestoring ? (
                <ActivityIndicator size="small" color="#556070" />
              ) : (
                <Text
                  style={{
                    color: "#556070",
                    fontSize: 13,
                    textDecorationLine: "underline",
                  }}
                >
                  Restore Purchases
                </Text>
              )}
            </TouchableOpacity>

            {/* Legal */}
            <Text
              style={{
                color: "#333A44",
                fontSize: 10,
                textAlign: "center",
                lineHeight: 14,
                paddingHorizontal: 8,
              }}
            >
              3-day free trial for new subscribers only. After the trial, your
              subscription auto-renews at the selected plan price unless
              cancelled at least 24 hours before renewal. Manage or cancel
              anytime in your Apple ID settings.{" "}
              <Text
                onPress={() =>
                  Linking.openURL("https://www.outrepd.com/privacy")
                }
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
          </View>
        </Animated.View>
      </View>
    </Modal>
  );
}
