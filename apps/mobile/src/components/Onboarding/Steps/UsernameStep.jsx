import React from "react";
import { View, Text, TextInput } from "react-native";

export const UsernameStep = ({
  username,
  onUsernameChange,
  error,
  checkingUsername,
  usernameAvailable,
}) => {
  const getUsernameHintColor = () => {
    if (username.trim().length === 0) return "#555";
    if (checkingUsername) return "#555";
    if (usernameAvailable === true) return "#4BB8FA";
    if (usernameAvailable === false) return "#FF4444";
    return "#555";
  };

  const getUsernameHint = () => {
    if (username.trim().length === 0)
      return "You can change your name later in your profile";
    if (checkingUsername) return "Checking availability…";
    if (usernameAvailable === true) return "✓ Username is available!";
    if (usernameAvailable === false) return "✗ Username is already taken";
    return "You can change your name later in your profile";
  };

  return (
    <View style={{ flex: 1 }}>
      <Text
        style={{
          color: "#FFFFFF",
          fontSize: 30,
          fontWeight: "900",
          textAlign: "center",
          marginBottom: 36,
          lineHeight: 36,
        }}
      >
        What should we{"\n"}call you?
      </Text>

      {error && (
        <View
          style={{
            backgroundColor: "#1A0808",
            borderWidth: 1,
            borderColor: "#FF4444",
            borderRadius: 10,
            padding: 12,
            marginBottom: 16,
          }}
        >
          <Text
            style={{
              color: "#FF4444",
              fontSize: 13,
              textAlign: "center",
            }}
          >
            {error}
          </Text>
        </View>
      )}

      <TextInput
        value={username}
        onChangeText={onUsernameChange}
        placeholder="Enter your username"
        placeholderTextColor="#333"
        autoCapitalize="none"
        autoCorrect={false}
        maxLength={20}
        style={{
          backgroundColor: "#111111",
          borderRadius: 14,
          padding: 18,
          color: "#FFFFFF",
          fontSize: 18,
          textAlign: "center",
          fontWeight: "600",
          marginBottom: 12,
        }}
      />

      <Text
        style={{
          color: getUsernameHintColor(),
          fontSize: 13,
          textAlign: "center",
          marginBottom: 40,
        }}
      >
        {getUsernameHint()}
      </Text>
    </View>
  );
};
