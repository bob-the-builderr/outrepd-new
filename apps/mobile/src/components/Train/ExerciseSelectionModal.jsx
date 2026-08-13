import React, { useState, useEffect } from "react";
import {
  View,
  Text,
  Modal,
  ScrollView,
  TouchableOpacity,
  TextInput,
} from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { X, Search, Check } from "lucide-react-native";
import { getExercisesForMuscle } from "@/constants/exercises";

export default function ExerciseSelectionModal({
  visible,
  muscleGroup,
  currentSelection = [],
  onClose,
  onSave,
}) {
  const insets = useSafeAreaInsets();
  const [selectedExercises, setSelectedExercises] = useState(currentSelection);
  const [searchQuery, setSearchQuery] = useState("");

  // Sync selected exercises when modal opens or muscle group changes
  useEffect(() => {
    if (visible) {
      setSelectedExercises(currentSelection);
      setSearchQuery("");
    }
  }, [visible, muscleGroup]);

  const allExercises = muscleGroup ? getExercisesForMuscle(muscleGroup) : [];

  const filteredExercises = allExercises.filter((ex) =>
    ex.name.toLowerCase().includes(searchQuery.toLowerCase()),
  );

  const toggleExercise = (exerciseName) => {
    if (selectedExercises.includes(exerciseName)) {
      setSelectedExercises(selectedExercises.filter((e) => e !== exerciseName));
    } else {
      if (selectedExercises.length < 6) {
        setSelectedExercises([...selectedExercises, exerciseName]);
      }
    }
  };

  const handleSave = () => {
    if (selectedExercises.length === 6) {
      onSave(selectedExercises);
      onClose();
    }
  };

  const handleClose = () => {
    setSelectedExercises(currentSelection);
    setSearchQuery("");
    onClose();
  };

  return (
    <Modal visible={visible} animationType="slide" transparent>
      <View style={{ flex: 1, backgroundColor: "rgba(0,0,0,0.95)" }}>
        <View style={{ flex: 1, paddingTop: insets.top }}>
          {/* Header */}
          <View
            style={{
              flexDirection: "row",
              justifyContent: "space-between",
              alignItems: "center",
              paddingHorizontal: 20,
              paddingVertical: 16,
              borderBottomWidth: 1,
              borderBottomColor: "#222",
            }}
          >
            <View style={{ flex: 1 }}>
              <Text style={{ color: "#FFF", fontSize: 24, fontWeight: "900" }}>
                SELECT EXERCISES
              </Text>
              <Text style={{ color: "#888", fontSize: 14, fontWeight: "bold" }}>
                {muscleGroup} • {selectedExercises.length}/6 selected
              </Text>
            </View>
            <TouchableOpacity onPress={handleClose}>
              <X color="#888" size={28} />
            </TouchableOpacity>
          </View>

          {/* Search Bar */}
          <View style={{ paddingHorizontal: 20, paddingTop: 16 }}>
            <View
              style={{
                backgroundColor: "#1A1A1A",
                borderRadius: 12,
                flexDirection: "row",
                alignItems: "center",
                paddingHorizontal: 16,
              }}
            >
              <Search color="#555" size={20} />
              <TextInput
                placeholder="Search exercises..."
                placeholderTextColor="#555"
                value={searchQuery}
                onChangeText={setSearchQuery}
                style={{
                  flex: 1,
                  color: "#FFF",
                  paddingVertical: 14,
                  paddingHorizontal: 12,
                  fontSize: 16,
                  fontWeight: "600",
                }}
              />
            </View>
          </View>

          {/* Exercise List */}
          <ScrollView
            contentContainerStyle={{
              padding: 20,
              paddingBottom: insets.bottom + 120,
            }}
          >
            {filteredExercises.map((exercise, idx) => {
              const isSelected = selectedExercises.includes(exercise.name);
              const selectionIndex = selectedExercises.indexOf(exercise.name);

              return (
                <TouchableOpacity
                  key={idx}
                  onPress={() => toggleExercise(exercise.name)}
                  style={{
                    backgroundColor: isSelected ? "#1E3A52" : "#1A1A1A",
                    borderRadius: 16,
                    padding: 16,
                    marginBottom: 12,
                    borderWidth: 2,
                    borderColor: isSelected ? "#4BB8FA" : "transparent",
                    flexDirection: "row",
                    alignItems: "center",
                    justifyContent: "space-between",
                  }}
                >
                  <View style={{ flex: 1 }}>
                    <Text
                      style={{
                        color: "#FFF",
                        fontSize: 16,
                        fontWeight: "900",
                        marginBottom: 4,
                      }}
                    >
                      {exercise.name}
                    </Text>
                    <Text
                      style={{
                        color: "#888",
                        fontSize: 12,
                        fontWeight: "bold",
                      }}
                    >
                      {exercise.equipment}
                      {exercise.compound ? " • Compound" : " • Isolation"}
                    </Text>
                  </View>
                  {isSelected && (
                    <View
                      style={{
                        backgroundColor: "#4BB8FA",
                        width: 32,
                        height: 32,
                        borderRadius: 16,
                        justifyContent: "center",
                        alignItems: "center",
                      }}
                    >
                      <Text
                        style={{
                          color: "#000",
                          fontWeight: "900",
                          fontSize: 14,
                        }}
                      >
                        {selectionIndex + 1}
                      </Text>
                    </View>
                  )}
                </TouchableOpacity>
              );
            })}
          </ScrollView>

          {/* Save Button */}
          <View
            style={{
              position: "absolute",
              bottom: 0,
              left: 0,
              right: 0,
              padding: 20,
              paddingBottom: insets.bottom + 20,
              backgroundColor: "#0D0D0D",
              borderTopWidth: 1,
              borderTopColor: "#222",
            }}
          >
            <TouchableOpacity
              onPress={handleSave}
              disabled={selectedExercises.length !== 6}
              style={{
                backgroundColor:
                  selectedExercises.length === 6 ? "#4BB8FA" : "#333",
                height: 56,
                borderRadius: 16,
                justifyContent: "center",
                alignItems: "center",
              }}
            >
              <Text
                style={{
                  color: selectedExercises.length === 6 ? "#000" : "#666",
                  fontWeight: "900",
                  fontSize: 16,
                }}
              >
                {selectedExercises.length === 6
                  ? "SAVE EXERCISES"
                  : `SELECT ${6 - selectedExercises.length} MORE`}
              </Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>
    </Modal>
  );
}
