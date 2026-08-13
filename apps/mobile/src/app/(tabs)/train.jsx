import React, { useState, useEffect } from "react";
import {
  View,
  Text,
  ScrollView,
  TouchableOpacity,
  Alert,
  Modal,
  ActivityIndicator,
} from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { Calendar } from "react-native-calendars";
import {
  CheckCircle2,
  Edit2,
  Dumbbell,
  Flame,
  Info,
  X,
} from "lucide-react-native";
import { MUSCLE_GROUPS } from "@/constants/exercises";
import ExerciseSelectionModal from "@/components/Train/ExerciseSelectionModal";
import { useUser, useAuth } from "@/utils/auth";
import { authenticatedFetch } from "@/utils/authenticatedFetch";

const MUSCLE_META = {
  Chest: { color: "#4BB8FA" },
  Back: { color: "#4BB8FA" },
  Legs: { color: "#4BB8FA" },
  Shoulders: { color: "#4BB8FA" },
  Arms: { color: "#4BB8FA" },
};

// Returns a local-timezone YYYY-MM-DD string for a given Date object
const getLocalDateStr = (date) => {
  const y = date.getFullYear();
  const m = String(date.getMonth() + 1).padStart(2, "0");
  const d = String(date.getDate()).padStart(2, "0");
  return `${y}-${m}-${d}`;
};

export default function TrainScreen() {
  const insets = useSafeAreaInsets();
  const { data: user } = useUser();
  const { auth, isReady, signIn } = useAuth();

  const [exerciseSelections, setExerciseSelections] = useState({});
  const [selectedMuscle, setSelectedMuscle] = useState(null);
  const [modalVisible, setModalVisible] = useState(false);
  const [howItWorksVisible, setHowItWorksVisible] = useState(false);
  const [loading, setLoading] = useState(true);
  const [markedDates, setMarkedDates] = useState({});
  const [streak, setStreak] = useState(0);
  const [selectedDate, setSelectedDate] = useState(null);
  const [dayMatches, setDayMatches] = useState([]);
  const [dayWorkouts, setDayWorkouts] = useState([]);
  const [dayDetailsVisible, setDayDetailsVisible] = useState(false);

  useEffect(() => {
    if (auth) {
      fetchExerciseSelections();
      fetchWorkoutHistory();
    } else {
      setLoading(false);
    }
  }, [auth]);

  const fetchExerciseSelections = async () => {
    try {
      const response = await authenticatedFetch("/api/exercise-selections");
      if (response.ok) {
        const data = await response.json();
        const map = {};
        data.selections.forEach((sel) => {
          map[sel.muscle_group] = sel.exercises;
        });
        setExerciseSelections(map);
      }
    } catch (error) {
      console.error("Failed to fetch exercise selections:", error);
    } finally {
      setLoading(false);
    }
  };

  const fetchWorkoutHistory = async () => {
    try {
      const [workoutsRes, matchesRes] = await Promise.all([
        authenticatedFetch("/api/workouts"),
        authenticatedFetch("/api/matches"),
      ]);

      const workoutsData = workoutsRes.ok
        ? await workoutsRes.json()
        : { workouts: [] };
      const matchesData = matchesRes.ok
        ? await matchesRes.json()
        : { matches: [] };

      const workouts = workoutsData.workouts || [];
      const matches = matchesData.matches || [];

      // Build marked dates — one style for all active days
      const dates = {};
      const addDate = (dateStr) => {
        if (dateStr && !dates[dateStr]) {
          dates[dateStr] = {
            marked: true,
            dotColor: "#4BB8FA",
          };
        }
      };

      workouts.forEach(
        (w) =>
          w.workout_date && addDate(getLocalDateStr(new Date(w.workout_date))),
      );
      matches.forEach(
        (m) => m.match_date && addDate(getLocalDateStr(new Date(m.match_date))),
      );

      setMarkedDates(dates);

      // Calculate streak using local dates to avoid UTC midnight drift
      let s = 0;
      const today = new Date();
      for (let i = 0; i < 60; i++) {
        const d = new Date(today);
        d.setDate(today.getDate() - i);
        const key = getLocalDateStr(d);
        if (dates[key]) {
          s++;
        } else if (i > 0) {
          break;
        }
      }
      setStreak(s);
    } catch (error) {
      console.error("Failed to fetch workout history:", error);
    }
  };

  const handleMusclePress = (muscle) => {
    if (!auth) {
      signIn();
      return;
    }
    setSelectedMuscle(muscle);
    setModalVisible(true);
  };

  const handleSaveExercises = async (exercises) => {
    try {
      const response = await authenticatedFetch("/api/exercise-selections", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          muscle_group: selectedMuscle,
          exercises,
        }),
      });
      if (response.ok) {
        setExerciseSelections((prev) => ({
          ...prev,
          [selectedMuscle]: exercises,
        }));
        Alert.alert(
          "Saved!",
          `${selectedMuscle} exercises updated. You're ready to battle!`,
        );
      } else {
        Alert.alert("Error", "Failed to save exercises. Try again.");
      }
    } catch (error) {
      console.error("Failed to save exercises:", error);
      Alert.alert("Error", "Failed to save exercises. Try again.");
    }
  };

  const handleDayPress = async (day) => {
    const dateStr = day.dateString;
    setSelectedDate(dateStr);

    try {
      // Fetch matches for this date
      const matchesRes = await authenticatedFetch(
        `/api/matches?date=${dateStr}`,
      );
      const matchesData = matchesRes.ok
        ? await matchesRes.json()
        : { matches: [] };

      // Fetch workouts for this date
      const workoutsRes = await authenticatedFetch("/api/workouts");
      const workoutsData = workoutsRes.ok
        ? await workoutsRes.json()
        : { workouts: [] };
      const dayWorkoutsFiltered = (workoutsData.workouts || []).filter((w) => {
        const wDate = w.workout_date
          ? getLocalDateStr(new Date(w.workout_date))
          : null;
        return wDate === dateStr;
      });

      setDayMatches(matchesData.matches || []);
      setDayWorkouts(dayWorkoutsFiltered);
      setDayDetailsVisible(true);
    } catch (error) {
      console.error("Failed to fetch day details:", error);
    }
  };

  const configuredCount = MUSCLE_GROUPS.filter(
    (m) => exerciseSelections[m]?.length === 6,
  ).length;

  if (!isReady) {
    return (
      <View
        style={{
          flex: 1,
          backgroundColor: "#0D0D0D",
          justifyContent: "center",
        }}
      >
        <ActivityIndicator size="large" color="#4BB8FA" />
      </View>
    );
  }

  if (!auth) {
    return (
      <View style={{ flex: 1, backgroundColor: "#0D0D0D" }}>
        {/* Header */}
        <View
          style={{
            paddingTop: insets.top + 20,
            paddingHorizontal: 20,
            paddingBottom: 10,
          }}
        >
          <Text style={{ color: "#FFF", fontSize: 32, fontWeight: "900" }}>
            TRAINING
          </Text>
          <Text style={{ color: "#888", fontWeight: "bold" }}>
            Sign in to configure exercises
          </Text>
        </View>

        <ScrollView
          contentContainerStyle={{
            padding: 20,
            paddingBottom: insets.bottom + 100,
          }}
          showsVerticalScrollIndicator={false}
        >
          {/* Guest Message */}
          <View
            style={{
              backgroundColor: "#1A1A1A",
              borderRadius: 20,
              padding: 24,
              alignItems: "center",
              marginBottom: 24,
            }}
          >
            <Dumbbell size={48} color="#444" style={{ marginBottom: 16 }} />
            <Text
              style={{
                fontSize: 20,
                fontWeight: "700",
                color: "#fff",
                marginBottom: 8,
                textAlign: "center",
              }}
            >
              Sign in to start training
            </Text>
            <Text
              style={{
                fontSize: 14,
                color: "#888",
                marginBottom: 20,
                textAlign: "center",
              }}
            >
              Configure your exercises, log workouts, and track your progress
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

          {/* Preview of muscle groups (disabled) */}
          <View>
            <Text
              style={{
                fontSize: 16,
                fontWeight: "600",
                color: "#888",
                marginBottom: 12,
              }}
            >
              Muscle Groups
            </Text>
            {MUSCLE_GROUPS.map((muscle) => {
              const meta = MUSCLE_META[muscle] || { color: "#4BB8FA" };

              return (
                <View
                  key={muscle}
                  style={{
                    backgroundColor: "#0D1218",
                    borderRadius: 16,
                    padding: 16,
                    marginBottom: 12,
                    borderWidth: 1,
                    borderColor: "#1A2630",
                    opacity: 0.5,
                  }}
                >
                  <View
                    style={{
                      flexDirection: "row",
                      alignItems: "center",
                      justifyContent: "space-between",
                    }}
                  >
                    <View style={{ flex: 1 }}>
                      <View
                        style={{
                          flexDirection: "row",
                          alignItems: "center",
                          gap: 8,
                          marginBottom: 6,
                        }}
                      >
                        <View
                          style={{
                            width: 4,
                            height: 16,
                            backgroundColor: meta.color,
                            borderRadius: 2,
                          }}
                        />
                        <Text
                          style={{
                            color: "#FFF",
                            fontSize: 16,
                            fontWeight: "900",
                          }}
                        >
                          {muscle.toUpperCase()}
                        </Text>
                      </View>
                      <Text
                        style={{
                          color: "#666",
                          fontSize: 12,
                          fontWeight: "600",
                          marginLeft: 12,
                        }}
                      >
                        Sign in to configure
                      </Text>
                    </View>
                    <Edit2 color="#555" size={18} />
                  </View>
                </View>
              );
            })}
          </View>
        </ScrollView>
      </View>
    );
  }

  return (
    <View style={{ flex: 1, backgroundColor: "#0D0D0D" }}>
      {/* Header */}
      <View
        style={{
          paddingTop: insets.top + 20,
          paddingHorizontal: 20,
          paddingBottom: 10,
        }}
      >
        <Text style={{ color: "#FFF", fontSize: 32, fontWeight: "900" }}>
          TRAINING
        </Text>
        <Text style={{ color: "#888", fontWeight: "bold" }}>
          {configuredCount}/{MUSCLE_GROUPS.length} muscle groups configured
        </Text>
      </View>

      <ScrollView
        contentContainerStyle={{
          padding: 20,
          paddingBottom: insets.bottom + 100,
        }}
        showsVerticalScrollIndicator={false}
      >
        {/* Streak Banner */}
        <View
          style={{
            backgroundColor: "#1A1A1A",
            borderRadius: 20,
            padding: 20,
            flexDirection: "row",
            alignItems: "center",
            gap: 14,
            marginBottom: 24,
          }}
        >
          <View
            style={{
              backgroundColor: "#2A1A0A",
              borderRadius: 14,
              padding: 12,
            }}
          >
            <Flame color="#FF6B00" size={28} />
          </View>
          <View style={{ flex: 1 }}>
            <Text style={{ color: "#888", fontSize: 12, fontWeight: "bold" }}>
              ACTIVE STREAK
            </Text>
            <Text style={{ color: "#FFF", fontSize: 26, fontWeight: "900" }}>
              {streak} {streak === 1 ? "day" : "days"}
            </Text>
            <Text style={{ color: "#666", fontSize: 12 }}>
              {streak === 0
                ? "Log a workout to start your streak!"
                : streak >= 7
                  ? "You're on fire! Keep it up 🔥"
                  : "Keep showing up!"}
            </Text>
          </View>
        </View>

        {/* Calendar */}
        <View
          style={{
            backgroundColor: "#1A1A1A",
            borderRadius: 20,
            overflow: "hidden",
            padding: 10,
            marginBottom: 28,
          }}
        >
          <Calendar
            theme={{
              backgroundColor: "transparent",
              calendarBackground: "transparent",
              textSectionTitleColor: "#555",
              selectedDayBackgroundColor: "#4BB8FA",
              selectedDayTextColor: "#000",
              todayTextColor: "#FF6B00",
              todayBackgroundColor: "transparent",
              dayTextColor: "#FFF",
              textDisabledColor: "#333",
              dotColor: "#4BB8FA",
              monthTextColor: "#FFF",
              indicatorColor: "#4BB8FA",
              textDayFontWeight: "bold",
              textMonthFontWeight: "900",
              textDayHeaderFontWeight: "bold",
              arrowColor: "#4BB8FA",
            }}
            markedDates={markedDates}
            onDayPress={handleDayPress}
          />
        </View>

        {/* Muscle Group Cards */}
        <View
          style={{
            flexDirection: "row",
            alignItems: "center",
            justifyContent: "space-between",
            marginBottom: 14,
          }}
        >
          <Text
            style={{
              color: "#FFF",
              fontSize: 20,
              fontWeight: "900",
            }}
          >
            MY EXERCISES
          </Text>
          <TouchableOpacity
            onPress={() => setHowItWorksVisible(true)}
            style={{
              backgroundColor: "#1A2630",
              borderRadius: 20,
              width: 36,
              height: 36,
              alignItems: "center",
              justifyContent: "center",
              borderWidth: 1,
              borderColor: "#4BB8FA44",
            }}
          >
            <Info size={18} color="#4BB8FA" />
          </TouchableOpacity>
        </View>

        <View style={{ gap: 12 }}>
          {MUSCLE_GROUPS.map((muscle) => {
            const isConfigured = exerciseSelections[muscle]?.length === 6;
            const meta = MUSCLE_META[muscle] || { color: "#4BB8FA" };

            return (
              <TouchableOpacity
                key={muscle}
                onPress={() => handleMusclePress(muscle)}
                activeOpacity={0.8}
                style={{
                  backgroundColor: "#0D1218",
                  borderRadius: 16,
                  padding: 16,
                  borderWidth: 1,
                  borderColor: isConfigured ? `${meta.color}44` : "#1A2630",
                }}
              >
                <View
                  style={{
                    flexDirection: "row",
                    alignItems: "center",
                    justifyContent: "space-between",
                  }}
                >
                  <View style={{ flex: 1 }}>
                    <View
                      style={{
                        flexDirection: "row",
                        alignItems: "center",
                        gap: 8,
                        marginBottom: 6,
                      }}
                    >
                      <View
                        style={{
                          width: 4,
                          height: 16,
                          backgroundColor: meta.color,
                          borderRadius: 2,
                        }}
                      />
                      <Text
                        style={{
                          color: "#FFF",
                          fontSize: 16,
                          fontWeight: "900",
                        }}
                      >
                        {muscle.toUpperCase()}
                      </Text>
                    </View>
                    <Text
                      style={{
                        color: "#666",
                        fontSize: 12,
                        fontWeight: "600",
                        marginLeft: 12,
                      }}
                    >
                      Tap to configure
                    </Text>
                  </View>
                  {isConfigured ? (
                    <CheckCircle2 color="#4BB8FA" size={20} />
                  ) : (
                    <Edit2 color="#555" size={18} />
                  )}
                </View>

                {isConfigured && (
                  <View
                    style={{
                      marginTop: 12,
                      paddingTop: 12,
                      borderTopWidth: 1,
                      borderTopColor: "#1A2630",
                      gap: 4,
                    }}
                  >
                    {exerciseSelections[muscle].slice(0, 3).map((ex, idx) => (
                      <Text
                        key={idx}
                        style={{
                          color: "#666",
                          fontSize: 12,
                          fontWeight: "600",
                        }}
                      >
                        {idx + 1}. {ex}
                      </Text>
                    ))}
                    {exerciseSelections[muscle].length > 3 && (
                      <Text
                        style={{
                          color: "#555",
                          fontSize: 11,
                          fontWeight: "600",
                          marginTop: 2,
                        }}
                      >
                        +{exerciseSelections[muscle].length - 3} more
                      </Text>
                    )}
                  </View>
                )}
              </TouchableOpacity>
            );
          })}
        </View>
      </ScrollView>

      <ExerciseSelectionModal
        visible={modalVisible}
        muscleGroup={selectedMuscle}
        currentSelection={exerciseSelections[selectedMuscle] || []}
        onClose={() => setModalVisible(false)}
        onSave={handleSaveExercises}
      />

      {/* How It Works Modal */}
      <Modal
        visible={howItWorksVisible}
        animationType="fade"
        transparent
        onRequestClose={() => setHowItWorksVisible(false)}
      >
        <View
          style={{
            flex: 1,
            backgroundColor: "rgba(0,0,0,0.85)",
            justifyContent: "center",
            alignItems: "center",
            padding: 20,
          }}
        >
          <View
            style={{
              backgroundColor: "#0D1218",
              borderRadius: 20,
              padding: 24,
              width: "100%",
              maxWidth: 400,
              borderWidth: 1,
              borderColor: "#1A2630",
            }}
          >
            <View
              style={{
                flexDirection: "row",
                alignItems: "center",
                justifyContent: "space-between",
                marginBottom: 20,
              }}
            >
              <View
                style={{ flexDirection: "row", alignItems: "center", gap: 10 }}
              >
                <View
                  style={{
                    backgroundColor: "#1A3A4A",
                    borderRadius: 12,
                    padding: 8,
                  }}
                >
                  <Dumbbell color="#4BB8FA" size={20} />
                </View>
                <Text
                  style={{ color: "#FFF", fontSize: 18, fontWeight: "900" }}
                >
                  HOW IT WORKS
                </Text>
              </View>
              <TouchableOpacity
                onPress={() => setHowItWorksVisible(false)}
                style={{
                  backgroundColor: "#1A2630",
                  borderRadius: 20,
                  width: 32,
                  height: 32,
                  alignItems: "center",
                  justifyContent: "center",
                }}
              >
                <X size={16} color="#888" />
              </TouchableOpacity>
            </View>

            <View style={{ gap: 14 }}>
              {[
                "Pick a muscle group above",
                "Choose exactly 6 exercises",
                "Your picks are saved automatically",
                "When you start a match, those exercises load in",
                "Just log your sets — no typing needed",
              ].map((step, idx) => (
                <View
                  key={idx}
                  style={{
                    flexDirection: "row",
                    alignItems: "flex-start",
                    gap: 12,
                  }}
                >
                  <View
                    style={{
                      backgroundColor: "#1A3A4A",
                      width: 24,
                      height: 24,
                      borderRadius: 12,
                      alignItems: "center",
                      justifyContent: "center",
                      borderWidth: 1,
                      borderColor: "#4BB8FA44",
                    }}
                  >
                    <Text
                      style={{
                        color: "#4BB8FA",
                        fontSize: 12,
                        fontWeight: "900",
                      }}
                    >
                      {idx + 1}
                    </Text>
                  </View>
                  <Text
                    style={{
                      color: "#AAA",
                      fontSize: 14,
                      lineHeight: 22,
                      flex: 1,
                    }}
                  >
                    {step}
                  </Text>
                </View>
              ))}
            </View>
          </View>
        </View>
      </Modal>
    </View>
  );
}
