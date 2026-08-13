import { Award, Swords, Trophy, Flame, Users } from "lucide-react-native";

export const NOTIFICATION_META = {
  achievement: { icon: <Award size={20} color="#FFD700" />, bg: "#2A1F00" },
  match_invite: { icon: <Swords size={20} color="#4BB8FA" />, bg: "#0D1F2A" },
  match_result: { icon: <Trophy size={20} color="#4BFA88" />, bg: "#0D2A1A" },
  personal_record: { icon: <Flame size={20} color="#FF6B35" />, bg: "#2A1200" },
  friend_request: { icon: <Users size={20} color="#A8D8EA" />, bg: "#0D1A2A" },
};
