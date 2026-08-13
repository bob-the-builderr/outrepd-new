import React from "react";
import {
  View,
  Text,
  ScrollView,
  TouchableOpacity,
  Modal,
  ActivityIndicator,
} from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { StatusBar } from "expo-status-bar";
import { X, Trophy, Dumbbell } from "lucide-react-native";
import { useQuery } from "@tanstack/react-query";
import { authenticatedFetch } from "@/utils/authenticatedFetch";
import { volumeToScore } from "@/utils/scoreSystem";

export function MatchDetailsModal({ visible, onClose, matchId }) {
  const insets = useSafeAreaInsets();

  const { data, isLoading } = useQuery({
    queryKey: ["match-workout", matchId],
    queryFn: async () => {
      const res = await authenticatedFetch(`/api/matches/${matchId}/workout`);
      if (!res.ok) throw new Error("Failed to fetch match workout");
      return res.json();
    },
    enabled: visible && !!matchId,
  });

  const match = data?.match;
  const userWorkout = data?.userWorkout;
  const opponentWorkout = data?.opponentWorkout;
  const isWin = match?.result === "win";

  const renderWorkoutSection = (workout, title, isUser) => {
    if (!workout) {
      return (
        <View style={{ marginBottom: 24 }}>
          <Text
            style={{
              color: "#FFF",
              fontSize: 16,
              fontWeight: "900",
              marginBottom: 12,
            }}
          >
            {title}
          </Text>
          <View
            style={{
              backgroundColor: "#0D1218",
              borderRadius: 12,
              padding: 20,
              alignItems: "center",
            }}
          >
            <Text style={{ color: "#666", fontSize: 14 }}>
              No workout data available
            </Text>
          </View>
        </View>
      );
    }

    return (
      <View style={{ marginBottom: 24 }}>
        <View
          style={{
            flexDirection: "row",
            alignItems: "center",
            justifyContent: "space-between",
            marginBottom: 12,
          }}
        >
          <Text
            style={{
              color: "#FFF",
              fontSize: 16,
              fontWeight: "900",
            }}
          >
            {title}
          </Text>
          <View
            style={{
              backgroundColor: isUser
                ? isWin
                  ? "#0D3A1A"
                  : "#3A0D0D"
                : isWin
                  ? "#3A0D0D"
                  : "#0D3A1A",
              paddingHorizontal: 10,
              paddingVertical: 5,
              borderRadius: 8,
              borderWidth: 1,
              borderColor: isUser
                ? isWin
                  ? "#1A6A2A"
                  : "#6A1A1A"
                : isWin
                  ? "#6A1A1A"
                  : "#1A6A2A",
            }}
          >
            <Text
              style={{
                color: isUser
                  ? isWin
                    ? "#4BFA88"
                    : "#FF4444"
                  : isWin
                    ? "#FF4444"
                    : "#4BFA88",
                fontSize: 11,
                fontWeight: "900",
              }}
            >
              {volumeToScore(workout.total_volume_kg || 0).toLocaleString()} pts
            </Text>
          </View>
        </View>

        {workout.exercises?.map((exercise, idx) => (
          <View
            key={idx}
            style={{
              backgroundColor: "#0D1218",
              borderRadius: 12,
              padding: 14,
              marginBottom: 10,
              borderWidth: 1,
              borderColor: "#1A2630",
            }}
          >
            <View
              style={{
                flexDirection: "row",
                alignItems: "center",
                marginBottom: 10,
              }}
            >
              <Dumbbell size={16} color="#4BB8FA" />
              <Text
                style={{
                  color: "#FFF",
                  fontSize: 14,
                  fontWeight: "700",
                  marginLeft: 8,
                  flex: 1,
                }}
              >
                {exercise.exercise_name}
              </Text>
              <Text style={{ color: "#666", fontSize: 11 }}>
                {exercise.muscle_group}
              </Text>
            </View>

            {exercise.sets?.map((set, setIdx) => (
              <View
                key={setIdx}
                style={{
                  flexDirection: "row",
                  alignItems: "center",
                  paddingVertical: 6,
                  borderTopWidth: setIdx === 0 ? 0 : 1,
                  borderTopColor: "#1A2630",
                }}
              >
                <View
                  style={{
                    width: 28,
                    height: 28,
                    borderRadius: 14,
                    backgroundColor: "#1A2630",
                    alignItems: "center",
                    justifyContent: "center",
                    marginRight: 12,
                  }}
                >
                  <Text
                    style={{
                      color: "#4BB8FA",
                      fontSize: 12,
                      fontWeight: "700",
                    }}
                  >
                    {setIdx + 1}
                  </Text>
                </View>
                <View
                  style={{
                    flex: 1,
                    flexDirection: "row",
                    justifyContent: "space-between",
                  }}
                >
                  <View>
                    <Text style={{ color: "#888", fontSize: 11 }}>Weight</Text>
                    <Text
                      style={{
                        color: "#FFF",
                        fontSize: 14,
                        fontWeight: "700",
                      }}
                    >
                      {parseFloat(set.weight_kg).toFixed(1)}kg
                    </Text>
                  </View>
                  <View style={{ alignItems: "center" }}>
                    <Text style={{ color: "#888", fontSize: 11 }}>Reps</Text>
                    <Text
                      style={{
                        color: "#FFF",
                        fontSize: 14,
                        fontWeight: "700",
                      }}
                    >
                      {set.reps}
                    </Text>
                  </View>
                </View>
              </View>
            ))}

            <View
              style={{
                marginTop: 10,
                paddingTop: 10,
                borderTopWidth: 1,
                borderTopColor: "#1A2630",
              }}
            >
              <Text style={{ color: "#666", fontSize: 11 }}>
                {exercise.total_sets} sets • {exercise.total_reps} reps
              </Text>
            </View>
          </View>
        ))}
      </View>
    );
  };

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
              MATCH DETAILS
            </Text>
            {match && (
              <Text style={{ color: "#4BB8FA", fontSize: 13, marginTop: 2 }}>
                {isWin ? "VICTORY" : "DEFEAT"} •{" "}
                {match.lp_change > 0 ? "+" : ""}
                {match.lp_change} LP
              </Text>
            )}
          </View>
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
            contentContainerStyle={{
              paddingHorizontal: 20,
              paddingTop: 20,
              paddingBottom: insets.bottom + 24,
            }}
            showsVerticalScrollIndicator={false}
          >
            {renderWorkoutSection(userWorkout, "YOUR WORKOUT", true)}
            {renderWorkoutSection(
              opponentWorkout,
              match?.opponent_name?.toUpperCase() || "OPPONENT",
              false,
            )}
          </ScrollView>
        )}
      </View>
    </Modal>
  );
}
