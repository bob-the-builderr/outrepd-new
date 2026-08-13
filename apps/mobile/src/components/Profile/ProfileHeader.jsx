import React from "react";
import { View, Text, TouchableOpacity } from "react-native";
import { TIERS, DIVISION_NAMES } from "@/constants/tiers";
import { Edit2 } from "lucide-react-native";
import { ProfileFrame } from "@/components/ProfileFrame";

export function ProfileHeader({ profile, user, onEditPress }) {
  const tierIndex = Math.min(profile.tier_idx || 0, (TIERS?.length || 1) - 1);
  const currentTier = TIERS?.[tierIndex] || {
    name: "Bronze",
    color: "#CD7F32",
    icon: "🥉",
  };
  const currentDivName =
    DIVISION_NAMES?.[Math.min(profile.div_idx || 0, 3)] || "IV";

  return (
    <View
      style={{
        paddingBottom: 32,
        alignItems: "center",
        borderBottomWidth: 1,
        borderBottomColor: "#1A2630",
      }}
    >
      <TouchableOpacity onPress={onEditPress} style={{ alignItems: "center" }}>
        {/* Profile photo with rank frame */}
        <ProfileFrame
          size={110}
          tierIdx={tierIndex}
          photoUrl={profile.profile_photo_url}
          fallbackIcon={currentTier.icon}
          glow
        />

        {/* Edit button */}
        <View
          style={{
            position: "absolute",
            bottom: 10,
            right: -2,
            backgroundColor: "#4BB8FA",
            width: 32,
            height: 32,
            borderRadius: 16,
            alignItems: "center",
            justifyContent: "center",
            borderWidth: 3,
            borderColor: "#010308",
            shadowColor: "#4BB8FA",
            shadowOffset: { width: 0, height: 0 },
            shadowOpacity: 0.5,
            shadowRadius: 8,
            elevation: 5,
          }}
        >
          <Edit2 size={14} color="#000" />
        </View>
      </TouchableOpacity>

      <Text
        style={{
          color: "#FFF",
          fontSize: 26,
          fontWeight: "900",
          letterSpacing: 0.5,
          marginTop: 8,
        }}
      >
        {profile.username || user?.name || "Gym Warrior"}
      </Text>

      <View style={{ marginTop: 8 }}>
        <View
          style={{
            backgroundColor: `${currentTier.color}22`,
            borderRadius: 20,
            paddingHorizontal: 14,
            paddingVertical: 5,
            borderWidth: 1,
            borderColor: `${currentTier.color}55`,
          }}
        >
          <Text
            style={{
              color: currentTier.color,
              fontWeight: "800",
              fontSize: 13,
            }}
          >
            {currentTier.name} {currentDivName}
          </Text>
        </View>
      </View>

      <View style={{ width: "75%", marginTop: 20 }}>
        <View
          style={{
            flexDirection: "row",
            justifyContent: "space-between",
            marginBottom: 6,
          }}
        >
          <Text style={{ color: "#555", fontSize: 11, fontWeight: "700" }}>
            {profile.lp || 0} LP
          </Text>
          <Text style={{ color: "#555", fontSize: 11, fontWeight: "700" }}>
            100 LP
          </Text>
        </View>
        <View
          style={{
            height: 8,
            backgroundColor: "#1A2630",
            borderRadius: 4,
            overflow: "hidden",
          }}
        >
          <View
            style={{
              height: "100%",
              backgroundColor: currentTier.color,
              width: `${Math.min(profile.lp || 0, 100)}%`,
              borderRadius: 4,
            }}
          />
        </View>
        <Text
          style={{
            color: "#444",
            fontSize: 11,
            marginTop: 5,
            textAlign: "center",
          }}
        >
          {100 - (profile.lp || 0)} LP to next division
        </Text>
      </View>
    </View>
  );
}
