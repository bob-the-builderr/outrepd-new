import React, { useState } from "react";
import { View, Text, TouchableOpacity, Share, Modal } from "react-native";
import { Image } from "expo-image";
import { Copy, Share2, Info, X } from "lucide-react-native";
import * as Clipboard from "expo-clipboard";

export const WaitingForOpponent = ({
  insets,
  inviteCode,
  muscleGroup,
  currentTier,
  onCancel,
}) => {
  const [showInstructions, setShowInstructions] = useState(false);

  const baseUrl =
    process.env.EXPO_PUBLIC_BASE_URL ||
    process.env.EXPO_PUBLIC_PROXY_BASE_URL ||
    "";
  const inviteUrl = `${baseUrl}/join/${inviteCode}`;

  const handleShare = async () => {
    try {
      await Share.share({
        message: `💪 I'm challenging you to a ${muscleGroup} battle on OUTREPD!\n\nEnter code: ${inviteCode}\n\nOr open: ${inviteUrl}`,
        title: "OUTREPD Battle Invite",
      });
    } catch (err) {
      console.error("Share failed", err);
    }
  };

  const handleCopy = async () => {
    await Clipboard.setStringAsync(inviteCode);
  };

  return (
    <View
      style={{
        flex: 1,
        backgroundColor: "#010308",
        paddingTop: insets.top + 24,
        paddingHorizontal: 24,
        paddingBottom: insets.bottom + 24,
        alignItems: "center",
      }}
    >
      {/* Info Button - Top Right */}
      <TouchableOpacity
        onPress={() => setShowInstructions(true)}
        style={{
          position: "absolute",
          top: insets.top + 16,
          right: 24,
          backgroundColor: "#111D26",
          width: 40,
          height: 40,
          borderRadius: 12,
          justifyContent: "center",
          alignItems: "center",
          borderWidth: 1,
          borderColor: "#1A2A3A",
          zIndex: 10,
        }}
      >
        <Info color="#4BB8FA" size={20} />
      </TouchableOpacity>

      {/* Instructions Modal */}
      <Modal
        visible={showInstructions}
        transparent
        animationType="fade"
        onRequestClose={() => setShowInstructions(false)}
      >
        <TouchableOpacity
          activeOpacity={1}
          onPress={() => setShowInstructions(false)}
          style={{
            flex: 1,
            backgroundColor: "rgba(0,0,0,0.85)",
            justifyContent: "center",
            alignItems: "center",
            padding: 24,
          }}
        >
          <View
            style={{
              backgroundColor: "#0D1218",
              borderRadius: 20,
              padding: 24,
              width: "100%",
              maxWidth: 360,
              borderWidth: 1,
              borderColor: "#1A2630",
            }}
          >
            <TouchableOpacity
              onPress={() => setShowInstructions(false)}
              style={{
                position: "absolute",
                top: 16,
                right: 16,
                zIndex: 1,
              }}
            >
              <X color="#888" size={24} />
            </TouchableOpacity>

            <Text
              style={{
                color: "#FFF",
                fontSize: 18,
                fontWeight: "900",
                marginBottom: 16,
              }}
            >
              HOW TO INVITE
            </Text>
            <Text
              style={{
                color: "#AAA",
                fontSize: 14,
                lineHeight: 22,
              }}
            >
              Ask your friend to open OUTREPD, tap{" "}
              <Text style={{ color: "#FFF", fontWeight: "700" }}>
                JOIN A MATCH
              </Text>{" "}
              and enter this code.{"\n\n"}
              The match starts once they join!
            </Text>
          </View>
        </TouchableOpacity>
      </Modal>

      {/* Header */}
      <View style={{ alignItems: "center", marginBottom: 48 }}>
        <View style={{ marginBottom: 16 }}>
          <Image
            source="https://dtvoeevhaseb5.cloudfront.net/user-uploads/9613a25b-2616-4f30-be6b-ced22f46d915.png"
            style={{ width: 80, height: 80 }}
            contentFit="contain"
          />
        </View>
        <Text
          style={{
            color: "#FFF",
            fontSize: 22,
            fontWeight: "900",
            textAlign: "center",
          }}
        >
          WAITING FOR OPPONENT
        </Text>
        <Text
          style={{
            color: "#555",
            fontSize: 14,
            marginTop: 8,
            textAlign: "center",
          }}
        >
          💪 {muscleGroup?.toUpperCase()} BATTLE
        </Text>
      </View>

      {/* Invite Code Card */}
      <View
        style={{
          width: "100%",
          backgroundColor: "#0D1218",
          borderRadius: 24,
          borderWidth: 1,
          borderColor: "#1A2630",
          padding: 28,
          alignItems: "center",
          marginBottom: 20,
        }}
      >
        <Text
          style={{
            color: "#555",
            fontSize: 11,
            fontWeight: "800",
            letterSpacing: 2,
            marginBottom: 12,
          }}
        >
          INVITE CODE
        </Text>
        <Text
          style={{
            color: "#4BB8FA",
            fontSize: 38,
            fontWeight: "900",
            letterSpacing: 6,
            marginBottom: 20,
          }}
        >
          {inviteCode}
        </Text>

        <TouchableOpacity
          onPress={handleCopy}
          style={{
            flexDirection: "row",
            alignItems: "center",
            gap: 8,
            backgroundColor: "#111D26",
            paddingHorizontal: 20,
            paddingVertical: 10,
            borderRadius: 12,
            borderWidth: 1,
            borderColor: "#1A2A3A",
          }}
        >
          <Copy color="#4BB8FA" size={16} />
          <Text style={{ color: "#4BB8FA", fontWeight: "700", fontSize: 13 }}>
            Copy Code
          </Text>
        </TouchableOpacity>
      </View>

      {/* Share Button */}
      <TouchableOpacity
        onPress={handleShare}
        style={{
          width: "100%",
          backgroundColor: "#4BB8FA",
          height: 56,
          borderRadius: 16,
          flexDirection: "row",
          justifyContent: "center",
          alignItems: "center",
          gap: 10,
          marginBottom: 14,
          shadowColor: "#4BB8FA",
          shadowOffset: { width: 0, height: 4 },
          shadowOpacity: 0.45,
          shadowRadius: 12,
        }}
      >
        <Share2 color="#000" size={20} />
        <Text style={{ color: "#000", fontWeight: "900", fontSize: 15 }}>
          SHARE INVITE LINK
        </Text>
      </TouchableOpacity>

      {/* Cancel */}
      <TouchableOpacity onPress={onCancel}>
        <Text style={{ color: "#FF4444", fontWeight: "bold", fontSize: 14 }}>
          CANCEL MATCH
        </Text>
      </TouchableOpacity>
    </View>
  );
};
