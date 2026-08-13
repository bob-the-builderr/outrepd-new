import React, { useState } from "react";
import {
  View,
  Text,
  ScrollView,
  TouchableOpacity,
  Modal,
  TextInput,
  Alert,
  ActivityIndicator,
} from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { StatusBar } from "expo-status-bar";
import * as ImagePicker from "expo-image-picker";
import { Image } from "expo-image";
import useUpload from "@/utils/useUpload";
import { X, Camera } from "lucide-react-native";
import { useAuth } from "@/utils/auth/useAuth"; // Import useAuth

export function EditProfileModal({ visible, onClose, profile, onUpdate }) {
  const insets = useSafeAreaInsets();
  const { auth, signIn } = useAuth(); // Get auth and signIn
  const [username, setUsername] = useState(profile?.username || "");
  const [age, setAge] = useState(profile?.age?.toString() || "");
  const [upload, { loading: uploading }] = useUpload();
  const [selectedImage, setSelectedImage] = useState(
    profile?.profile_photo_url || null,
  );
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Reset state when modal opens
  React.useEffect(() => {
    if (visible) {
      setUsername(profile?.username || "");
      setAge(profile?.age?.toString() || "");
      setSelectedImage(profile?.profile_photo_url || null);
    }
  }, [visible, profile]);

  const pickImage = async () => {
    // Check if user is authenticated before allowing upload
    if (!auth) {
      Alert.alert(
        "Sign In Required",
        "Please sign in to upload a profile photo",
        [
          { text: "Cancel", style: "cancel" },
          {
            text: "Sign In",
            onPress: () => {
              onClose(); // Close this modal first
              setTimeout(() => signIn(), 300); // Then trigger sign in
            },
          },
        ],
      );
      return;
    }

    const { status } = await ImagePicker.requestMediaLibraryPermissionsAsync();
    if (status !== "granted") {
      Alert.alert(
        "Permission needed",
        "We need camera roll permissions to upload a photo",
      );
      return;
    }

    const result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.Images,
      allowsEditing: true,
      aspect: [1, 1],
      quality: 0.8,
    });

    if (!result.canceled && result.assets?.[0]) {
      const asset = result.assets[0];
      const uploadResult = await upload({
        reactNativeAsset: {
          uri: asset.uri,
          type: asset.type || "image",
          name: asset.fileName || "photo.jpg",
        },
      });

      if (uploadResult.error) {
        Alert.alert("Upload failed", uploadResult.error);
      } else if (uploadResult.url) {
        setSelectedImage(uploadResult.url);
      }
    }
  };

  const handleSave = async () => {
    if (!username.trim()) {
      Alert.alert("Invalid username", "Please enter a username");
      return;
    }

    const parsedAge = parseInt(age, 10);
    if (age && (isNaN(parsedAge) || parsedAge < 13 || parsedAge > 100)) {
      Alert.alert("Invalid age", "Please enter a valid age between 13 and 100");
      return;
    }

    setIsSubmitting(true);
    try {
      await onUpdate({
        username: username.trim(),
        profile_photo_url: selectedImage,
        ...(age ? { age: parsedAge } : {}),
      });
      onClose();
    } catch (error) {
      Alert.alert("Error", "Failed to update profile");
    } finally {
      setIsSubmitting(false);
    }
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
          <Text
            style={{
              color: "#FFF",
              fontSize: 22,
              fontWeight: "900",
              letterSpacing: 1,
            }}
          >
            EDIT PROFILE
          </Text>
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

        <ScrollView
          contentContainerStyle={{
            paddingHorizontal: 20,
            paddingTop: 32,
            paddingBottom: insets.bottom + 40,
          }}
          showsVerticalScrollIndicator={false}
        >
          {/* Profile Photo */}
          <View style={{ alignItems: "center", marginBottom: 32 }}>
            <TouchableOpacity onPress={pickImage} disabled={uploading}>
              <View
                style={{
                  width: 120,
                  height: 120,
                  borderRadius: 60,
                  backgroundColor: "#0D1218",
                  alignItems: "center",
                  justifyContent: "center",
                  borderWidth: 3,
                  borderColor: "#4BB8FA",
                  overflow: "hidden",
                }}
              >
                {selectedImage ? (
                  <Image
                    source={{ uri: selectedImage }}
                    style={{ width: "100%", height: "100%" }}
                    contentFit="cover"
                  />
                ) : (
                  <Camera size={40} color="#4BB8FA" />
                )}
                {uploading && (
                  <View
                    style={{
                      position: "absolute",
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      backgroundColor: "rgba(0,0,0,0.7)",
                      alignItems: "center",
                      justifyContent: "center",
                    }}
                  >
                    <ActivityIndicator size="large" color="#4BB8FA" />
                  </View>
                )}
              </View>
              <View
                style={{
                  position: "absolute",
                  bottom: 0,
                  right: 0,
                  backgroundColor: "#4BB8FA",
                  width: 36,
                  height: 36,
                  borderRadius: 18,
                  alignItems: "center",
                  justifyContent: "center",
                  borderWidth: 3,
                  borderColor: "#010308",
                }}
              >
                <Camera size={18} color="#000" />
              </View>
            </TouchableOpacity>
            <Text style={{ color: "#888", fontSize: 13, marginTop: 12 }}>
              Tap to {selectedImage ? "change" : "upload"} photo
            </Text>
          </View>

          {/* Username */}
          <View style={{ marginBottom: 24 }}>
            <Text
              style={{
                color: "#888",
                fontSize: 13,
                fontWeight: "700",
                marginBottom: 8,
              }}
            >
              USERNAME
            </Text>
            <TextInput
              value={username}
              onChangeText={setUsername}
              placeholder="Enter username"
              placeholderTextColor="#444"
              style={{
                backgroundColor: "#0D1218",
                borderWidth: 1,
                borderColor: "#1A2630",
                borderRadius: 12,
                padding: 16,
                color: "#FFF",
                fontSize: 16,
                fontWeight: "600",
              }}
              maxLength={50}
            />
          </View>

          {/* Age */}
          <View style={{ marginBottom: 24 }}>
            <Text
              style={{
                color: "#888",
                fontSize: 13,
                fontWeight: "700",
                marginBottom: 8,
              }}
            >
              AGE
            </Text>
            <TextInput
              value={age}
              onChangeText={setAge}
              placeholder="Enter your age"
              placeholderTextColor="#444"
              keyboardType="number-pad"
              style={{
                backgroundColor: "#0D1218",
                borderWidth: 1,
                borderColor: "#1A2630",
                borderRadius: 12,
                padding: 16,
                color: "#FFF",
                fontSize: 16,
                fontWeight: "600",
              }}
              maxLength={3}
            />
          </View>

          {/* Save Button */}
          <TouchableOpacity
            onPress={handleSave}
            disabled={isSubmitting || uploading}
            style={{
              backgroundColor:
                isSubmitting || uploading ? "#1A3A4A" : "#4BB8FA",
              borderRadius: 16,
              padding: 16,
              alignItems: "center",
              opacity: isSubmitting || uploading ? 0.5 : 1,
            }}
          >
            {isSubmitting ? (
              <ActivityIndicator color="#000" />
            ) : (
              <Text
                style={{
                  color: "#000",
                  fontSize: 16,
                  fontWeight: "900",
                  letterSpacing: 1,
                }}
              >
                SAVE CHANGES
              </Text>
            )}
          </TouchableOpacity>
        </ScrollView>
      </View>
    </Modal>
  );
}
