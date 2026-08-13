import React from "react";
import {
  View,
  Text,
  ScrollView,
  TextInput,
  TouchableOpacity,
} from "react-native";
import { Plus, Trash2 } from "lucide-react-native";

export const WorkoutLogger = ({
  workout,
  setWorkout,
  currentTier,
  handleUpdateSet,
  handleAddSet,
  units = "kg",
}) => {
  return (
    <>
      <ScrollView contentContainerStyle={{ padding: 20, paddingBottom: 200 }}>
        {workout.map((ex) => {
          return (
            <View
              key={ex.id}
              style={{
                backgroundColor: "#131313",
                borderRadius: 20,
                padding: 20,
                marginBottom: 20,
              }}
            >
              <Text
                style={{
                  color: "#FFF",
                  fontSize: 17,
                  fontWeight: "900",
                  borderBottomWidth: 1,
                  borderBottomColor: "#222",
                  paddingBottom: 8,
                  marginBottom: 16,
                }}
              >
                {ex.name}
              </Text>
              {ex.sets.map((set, idx) => (
                <View key={idx} style={{ marginBottom: 16 }}>
                  <View
                    style={{
                      flexDirection: "row",
                      gap: 10,
                      alignItems: "center",
                    }}
                  >
                    <Text
                      style={{
                        color: "#555",
                        width: 36,
                        fontWeight: "bold",
                        fontSize: 13,
                      }}
                    >
                      S{idx + 1}
                    </Text>
                    <TextInput
                      placeholder={units.toUpperCase()}
                      placeholderTextColor="#333"
                      keyboardType="numeric"
                      value={set.weight}
                      onChangeText={(val) =>
                        handleUpdateSet(ex.id, idx, "weight", val)
                      }
                      style={{
                        flex: 1,
                        backgroundColor: "#0A0A0A",
                        borderRadius: 8,
                        padding: 12,
                        color: "#FFF",
                        fontWeight: "bold",
                      }}
                    />
                    <Text style={{ color: "#444" }}>×</Text>
                    <TextInput
                      placeholder="REPS"
                      placeholderTextColor="#333"
                      keyboardType="numeric"
                      value={set.reps}
                      onChangeText={(val) =>
                        handleUpdateSet(ex.id, idx, "reps", val)
                      }
                      style={{
                        flex: 1,
                        backgroundColor: "#0A0A0A",
                        borderRadius: 8,
                        padding: 12,
                        color: "#FFF",
                        fontWeight: "bold",
                      }}
                    />
                    <TouchableOpacity
                      onPress={() =>
                        setWorkout(
                          workout.map((item) =>
                            item.id !== ex.id
                              ? item
                              : {
                                  ...item,
                                  sets: item.sets.filter((_, i) => i !== idx),
                                },
                          ),
                        )
                      }
                    >
                      <Trash2 color="#FF4444" size={20} />
                    </TouchableOpacity>
                  </View>
                </View>
              ))}
              <TouchableOpacity
                style={{
                  flexDirection: "row",
                  alignItems: "center",
                  marginTop: 10,
                }}
                onPress={() => handleAddSet(ex.id)}
              >
                <Plus color={currentTier.color} size={20} />
                <Text
                  style={{
                    color: currentTier.color,
                    fontWeight: "bold",
                    marginLeft: 8,
                  }}
                >
                  ADD SET
                </Text>
              </TouchableOpacity>
            </View>
          );
        })}
      </ScrollView>
    </>
  );
};
