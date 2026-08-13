import React from "react";
import {
  View,
  Text,
  Modal,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
} from "react-native";
import Animated, { FadeIn } from "react-native-reanimated";
import { MUSCLE_GROUPS, NEEDS_WHITE_TEXT } from "@/constants/tiers";

export const MuscleSelectorModal = ({
  visible,
  insets,
  selectedMuscle,
  setSelectedMuscle,
  currentTier,
  onSharePress, // challenge mode → Create Room
  onFindMatchPress, // matchmaking mode → Find Match
  onJoinPress, // challenge mode → Join with Code
  onCancel,
  loading,
  errorMessage,
  mode, // 'matchmaking' | 'challenge'
}) => {
  const isChallengeMode = mode === "challenge";

  return (
    <Modal visible={visible} transparent animationType="slide">
      <View
        style={{
          flex: 1,
          backgroundColor: "rgba(0,0,0,0.85)",
          justifyContent: "flex-end",
        }}
      >
        <View
          style={{
            backgroundColor: "#0E120E",
            borderTopLeftRadius: 32,
            borderTopRightRadius: 32,
            padding: 24,
            paddingBottom: insets.bottom + 24,
            borderTopWidth: 1,
            borderColor: "#1A261A",
          }}
        >
          {/* Handle bar */}
          <View
            style={{
              width: 40,
              height: 4,
              backgroundColor: "#1E2E1E",
              borderRadius: 2,
              alignSelf: "center",
              marginBottom: 24,
            }}
          />

          {/* Title */}
          <Text
            style={{
              color: "#FFF",
              fontSize: 20,
              fontWeight: "900",
              textAlign: "center",
              marginBottom: 8,
            }}
          >
            {isChallengeMode ? "CHALLENGE A FRIEND" : "FIND A MATCH"}
          </Text>
          <Text
            style={{
              color: "#444",
              fontSize: 13,
              textAlign: "center",
              marginBottom: 24,
            }}
          >
            {isChallengeMode
              ? "Create a room or join with a code"
              : "Select a muscle group to search online"}
          </Text>

          {/* Error Message */}
          {errorMessage ? (
            <View
              style={{
                backgroundColor: "#2A1515",
                borderRadius: 12,
                padding: 16,
                marginBottom: 20,
                borderWidth: 1,
                borderColor: "#4A2020",
              }}
            >
              <Text
                style={{
                  color: "#FF6B6B",
                  fontSize: 13,
                  fontWeight: "600",
                  textAlign: "center",
                  lineHeight: 18,
                }}
              >
                {errorMessage}
              </Text>
            </View>
          ) : null}

          {/* Muscle group selector */}
          <ScrollView
            horizontal
            showsHorizontalScrollIndicator={false}
            style={{ marginBottom: 28, flexGrow: 0 }}
            contentContainerStyle={{ flexGrow: 1, justifyContent: "center" }}
          >
            <View style={{ flexDirection: "row", gap: 10 }}>
              {MUSCLE_GROUPS.map((mg) => (
                <TouchableOpacity
                  key={mg}
                  onPress={() => setSelectedMuscle(mg)}
                  style={{
                    paddingHorizontal: 20,
                    paddingVertical: 10,
                    borderRadius: 20,
                    backgroundColor:
                      selectedMuscle === mg ? currentTier.color : "#141A14",
                    borderWidth: 1,
                    borderColor:
                      selectedMuscle === mg ? currentTier.color : "#1E2A1E",
                  }}
                >
                  <Text
                    style={{
                      color:
                        selectedMuscle === mg
                          ? NEEDS_WHITE_TEXT.includes(currentTier.color)
                            ? "#FFF"
                            : "#000"
                          : "#FFF",
                      fontWeight: "bold",
                    }}
                  >
                    {mg}
                  </Text>
                </TouchableOpacity>
              ))}
            </View>
          </ScrollView>

          {/* ── CHALLENGE MODE ── */}
          {isChallengeMode && (
            <Animated.View entering={FadeIn}>
              {/* Create Room — requires muscle selection */}
              <TouchableOpacity
                style={{
                  backgroundColor: selectedMuscle ? "#4BB8FA" : "#1A2A3A",
                  height: 56,
                  borderRadius: 16,
                  justifyContent: "center",
                  alignItems: "center",
                  marginBottom: 12,
                  shadowColor: selectedMuscle ? "#4BB8FA" : "transparent",
                  shadowOffset: { width: 0, height: 4 },
                  shadowOpacity: 0.45,
                  shadowRadius: 12,
                  opacity: loading ? 0.7 : 1,
                }}
                onPress={selectedMuscle ? onSharePress : undefined}
                disabled={!!loading || !selectedMuscle}
              >
                {loading ? (
                  <ActivityIndicator color="#000" />
                ) : (
                  <Text
                    style={{
                      color: selectedMuscle ? "#000" : "#555",
                      fontWeight: "900",
                      fontSize: 15,
                    }}
                  >
                    🏠 CREATE ROOM
                  </Text>
                )}
              </TouchableOpacity>

              {/* Join with Code */}
              <TouchableOpacity
                style={{
                  backgroundColor: "#0A1520",
                  height: 56,
                  borderRadius: 16,
                  justifyContent: "center",
                  alignItems: "center",
                  marginBottom: 16,
                  borderWidth: 1.5,
                  borderColor: "#4BB8FA44",
                  opacity: loading ? 0.7 : 1,
                }}
                onPress={onJoinPress}
                disabled={!!loading}
              >
                <Text
                  style={{ color: "#4BB8FA", fontWeight: "900", fontSize: 15 }}
                >
                  🔗 JOIN WITH CODE
                </Text>
              </TouchableOpacity>
            </Animated.View>
          )}

          {/* ── MATCHMAKING MODE ── */}
          {!isChallengeMode && selectedMuscle && (
            <Animated.View entering={FadeIn} style={{ marginBottom: 16 }}>
              <TouchableOpacity
                style={{
                  backgroundColor: "#4BB8FA",
                  height: 56,
                  borderRadius: 16,
                  justifyContent: "center",
                  alignItems: "center",
                  shadowColor: "#4BB8FA",
                  shadowOffset: { width: 0, height: 4 },
                  shadowOpacity: 0.45,
                  shadowRadius: 12,
                  opacity: loading ? 0.7 : 1,
                }}
                onPress={onFindMatchPress}
                disabled={!!loading}
              >
                {loading ? (
                  <ActivityIndicator color="#000" />
                ) : (
                  <Text
                    style={{ color: "#000", fontWeight: "900", fontSize: 15 }}
                  >
                    🔍 FIND MATCH
                  </Text>
                )}
              </TouchableOpacity>
            </Animated.View>
          )}

          <TouchableOpacity onPress={onCancel} disabled={!!loading}>
            <Text
              style={{
                color: "#FF4444",
                fontWeight: "bold",
                textAlign: "center",
              }}
            >
              CANCEL
            </Text>
          </TouchableOpacity>
        </View>
      </View>
    </Modal>
  );
};
