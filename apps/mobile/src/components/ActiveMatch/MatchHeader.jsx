import React, { useState } from "react";
import { View, Text, TouchableOpacity, Modal } from "react-native";
import { MoreVertical } from "lucide-react-native";

export const MatchHeader = ({
  insets,
  matchTime,
  selectedMuscle,
  currentTier,
  onForfeit,
}) => {
  const [showForfeitMenu, setShowForfeitMenu] = useState(false);
  const [showForfeitConfirm, setShowForfeitConfirm] = useState(false);

  const formatTime = (s) => {
    const h = Math.floor(s / 3600);
    const m = Math.floor((s % 3600) / 60);
    const sec = s % 60;
    return `⏱ ${h}:${m.toString().padStart(2, "0")}:${sec
      .toString()
      .padStart(2, "0")}`;
  };

  return (
    <View
      style={{
        paddingTop: insets.top,
        backgroundColor: "#131313",
        paddingBottom: 16,
        borderBottomWidth: 1,
        borderBottomColor: "#222",
      }}
    >
      <View
        style={{
          flexDirection: "row",
          justifyContent: "space-between",
          paddingHorizontal: 20,
          alignItems: "center",
        }}
      >
        <Text
          style={{
            color: matchTime < 600 ? "#FF4444" : "#FFF",
            fontSize: 17,
            fontWeight: "900",
          }}
        >
          {formatTime(matchTime)}
        </Text>
        <Text
          style={{
            color: currentTier.color,
            fontWeight: "900",
            fontSize: 12,
          }}
        >
          ⚔️ {selectedMuscle?.toUpperCase() ?? "CHEST"} BATTLE
        </Text>
        {/* Three dots button — replaced OPPONENT LOGGING badge */}
        <TouchableOpacity
          onPress={() => setShowForfeitMenu(true)}
          style={{
            width: 36,
            height: 36,
            borderRadius: 18,
            backgroundColor: "#1A1A1A",
            alignItems: "center",
            justifyContent: "center",
            borderWidth: 1,
            borderColor: "#333",
          }}
        >
          <MoreVertical size={20} color="#888" />
        </TouchableOpacity>
      </View>

      {/* Forfeit menu bottom sheet */}
      <Modal
        visible={showForfeitMenu}
        transparent={true}
        animationType="fade"
        onRequestClose={() => setShowForfeitMenu(false)}
      >
        <TouchableOpacity
          activeOpacity={1}
          onPress={() => setShowForfeitMenu(false)}
          style={{
            flex: 1,
            backgroundColor: "rgba(0,0,0,0.5)",
            justifyContent: "flex-end",
          }}
        >
          <View
            style={{
              backgroundColor: "#1A1A1A",
              borderTopLeftRadius: 20,
              borderTopRightRadius: 20,
              paddingBottom: (insets?.bottom ?? 0) + 20,
              paddingTop: 20,
              paddingHorizontal: 20,
              marginBottom: 12,
            }}
          >
            <TouchableOpacity
              onPress={() => {
                setShowForfeitMenu(false);
                setShowForfeitConfirm(true);
              }}
              style={{
                paddingVertical: 16,
                borderRadius: 12,
                backgroundColor: "#2A0A0A",
                borderWidth: 1,
                borderColor: "#FF4444",
                alignItems: "center",
              }}
            >
              <Text
                style={{ color: "#FF4444", fontWeight: "700", fontSize: 16 }}
              >
                Forfeit Match
              </Text>
            </TouchableOpacity>
            <TouchableOpacity
              onPress={() => setShowForfeitMenu(false)}
              style={{
                paddingVertical: 16,
                alignItems: "center",
                marginTop: 8,
              }}
            >
              <Text style={{ color: "#888", fontWeight: "600" }}>Cancel</Text>
            </TouchableOpacity>
          </View>
        </TouchableOpacity>
      </Modal>

      {/* Forfeit confirmation modal */}
      <Modal
        visible={showForfeitConfirm}
        transparent={true}
        animationType="fade"
        onRequestClose={() => setShowForfeitConfirm(false)}
      >
        <View
          style={{
            flex: 1,
            backgroundColor: "rgba(0,0,0,0.7)",
            justifyContent: "center",
            alignItems: "center",
            paddingHorizontal: 32,
          }}
        >
          <View
            style={{
              backgroundColor: "#1A1A1A",
              borderRadius: 20,
              padding: 24,
              width: "100%",
              maxWidth: 400,
              borderWidth: 1,
              borderColor: "#333",
            }}
          >
            <Text
              style={{
                color: "#FFF",
                fontSize: 20,
                fontWeight: "900",
                textAlign: "center",
                marginBottom: 12,
              }}
            >
              Forfeit Match?
            </Text>
            <Text
              style={{
                color: "#888",
                fontSize: 14,
                textAlign: "center",
                marginBottom: 24,
                lineHeight: 20,
              }}
            >
              You will lose LP and this match will count as a loss. Are you sure
              you want to forfeit?
            </Text>
            <TouchableOpacity
              onPress={() => {
                setShowForfeitConfirm(false);
                onForfeit();
              }}
              style={{
                backgroundColor: "#FF4444",
                paddingVertical: 14,
                borderRadius: 12,
                alignItems: "center",
                marginBottom: 12,
              }}
            >
              <Text style={{ color: "#FFF", fontWeight: "700", fontSize: 16 }}>
                Yes, Forfeit
              </Text>
            </TouchableOpacity>
            <TouchableOpacity
              onPress={() => setShowForfeitConfirm(false)}
              style={{
                backgroundColor: "#2A2A2A",
                paddingVertical: 14,
                borderRadius: 12,
                alignItems: "center",
              }}
            >
              <Text style={{ color: "#FFF", fontWeight: "700", fontSize: 16 }}>
                Cancel
              </Text>
            </TouchableOpacity>
          </View>
        </View>
      </Modal>
    </View>
  );
};
