import { ONBOARDING_IMAGES } from "@/constants/onboardingImages";

export const LOGO_URL = ONBOARDING_IMAGES.logo;

export const TOTAL_STEPS = 18;

export const EXPERIENCE_OPTIONS = [
  { key: "none", label: "I've never worked out" },
  { key: "beginner", label: "Beginner – Tried it before" },
  { key: "intermediate", label: "Intermediate – Regular training" },
  { key: "advanced", label: "Advanced – Years of experience" },
];

export const FITNESS_GOAL_OPTIONS = [
  { key: "stronger", label: "Become stronger" },
  { key: "consistent", label: "Become more consistent" },
  { key: "lean", label: "Lose weight and get lean" },
  { key: "mass", label: "Build muscle mass" },
];

export const THINK_SHAPE_OPTIONS = [
  { key: "never", label: "Never", level: 0 },
  { key: "sometimes", label: "Sometimes", level: 1 },
  { key: "often", label: "Often", level: 2 },
  { key: "all_time", label: "All The Time", level: 3 },
];

export const ENERGY_LEVEL_OPTIONS = [
  [
    {
      key: "low",
      label: "Low energy, I feel drained all day",
      level: 1,
    },
    {
      key: "drops",
      label: "Performance drops mid-session",
      level: 2,
    },
  ],
  [
    {
      key: "hard",
      label: "Hard to push through the last set",
      level: 3,
    },
    {
      key: "high",
      label: "High and steady from start to finish",
      level: 4,
    },
  ],
];
