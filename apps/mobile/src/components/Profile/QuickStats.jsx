import React from "react";
import { View, Text } from "react-native";
import { Target, TrendingUp, Flame, Trophy } from "lucide-react-native";

export function QuickStats({ profile }) {
  const winRate =
    (profile.total_matches || 0) > 0
      ? Math.round(((profile.wins || 0) / profile.total_matches) * 100)
      : 0;
  const streak = profile.current_win_streak || 0;
  const lossStreak = profile.current_loss_streak || 0;
  const totalVolumeFormatted = profile.total_volume_kg
    ? profile.total_volume_kg >= 1000
      ? `${(profile.total_volume_kg / 1000).toFixed(1)}t`
      : `${Math.round(profile.total_volume_kg)}kg`
    : "0kg";

  const stats = [
    {
      label: "MATCHES",
      value: profile.total_matches || 0,
      icon: <Target size={16} color="#4BB8FA" />,
    },
    {
      label: "WIN RATE",
      value: `${winRate}%`,
      icon: <TrendingUp size={16} color="#4BFA88" />,
    },
    {
      label: "STREAK",
      value: streak >= lossStreak ? `${streak}` : `${lossStreak}`,
      icon: (
        <Flame size={16} color={streak >= lossStreak ? "#FF6B35" : "#4BB8FA"} />
      ),
    },
    {
      label: "VOLUME",
      value: totalVolumeFormatted,
      icon: <Trophy size={16} color="#FFD700" />,
    },
  ];

  return (
    <View style={{ flexDirection: "row", padding: 16, gap: 10 }}>
      {stats.map((stat, i) => (
        <View
          key={i}
          style={{
            flex: 1,
            backgroundColor: "#0D1218",
            borderRadius: 16,
            padding: 12,
            alignItems: "center",
            borderWidth: 1,
            borderColor: "#1A2630",
          }}
        >
          <Text
            style={{
              color: "#FFF",
              fontSize: 15,
              fontWeight: "900",
            }}
          >
            {stat.value}
          </Text>
          <Text
            style={{
              color: "#444",
              fontSize: 9,
              fontWeight: "700",
              marginTop: 2,
            }}
          >
            {stat.label}
          </Text>
        </View>
      ))}
    </View>
  );
}
