import { useState, useRef } from "react";
import { Animated } from "react-native";
import { router } from "expo-router";
import { authenticatedFetch } from "@/utils/authenticatedFetch";
import { IS_TEST_MODE } from "@/utils/testMode";
import {
  SCREEN_WIDTH,
  CONTAINER_WIDTH,
  TICK_WIDTH,
  HEIGHT_TICK_HEIGHT,
} from "@/constants/onboardingDimensions";

export const useOnboardingState = () => {
  const fadeAnim = useRef(new Animated.Value(1)).current;
  const holdProgress = useRef(new Animated.Value(0)).current;
  const buttonFadeAnim = useRef(new Animated.Value(0)).current;
  const ageScrollRef = useRef(null);
  const weightScrollRef = useRef(null);
  const heightScrollRef = useRef(null);
  const usernameTimeout = useRef(null);

  const [step, setStep] = useState(0);
  const [username, setUsername] = useState("");
  const [selectedExperience, setSelectedExperience] = useState(null);
  const [selectedFitnessGoal, setSelectedFitnessGoal] = useState(null);
  const [selectedGender, setSelectedGender] = useState(null);
  const [selectedAge, setSelectedAge] = useState(25);
  const [weightKg, setWeightKg] = useState("70.0");
  const [rulerWidth, setRulerWidth] = useState(SCREEN_WIDTH - 48);
  const [heightCm, setHeightCm] = useState("178");
  const [heightRulerHeight, setHeightRulerHeight] = useState(400);
  const [weightUnit, setWeightUnit] = useState("kg");
  const [heightUnit, setHeightUnit] = useState("cm");
  const [heightFeet, setHeightFeet] = useState("");
  const [heightInches, setHeightInches] = useState("");
  const [thinkAboutGettingInShape, setThinkAboutGettingInShape] =
    useState(null);
  const [energyLevels, setEnergyLevels] = useState(null);
  const [relateProgress, setRelateProgress] = useState(null);
  const [relateRoutine, setRelateRoutine] = useState(null);
  const [typingComplete, setTypingComplete] = useState(false);
  const [error, setError] = useState(null);
  const [loading, setLoading] = useState(false);
  const [checkingUsername, setCheckingUsername] = useState(false);
  const [usernameAvailable, setUsernameAvailable] = useState(null);
  const [isHolding, setIsHolding] = useState(false);
  const [headlineFinished, setHeadlineFinished] = useState(false);

  const TYPING_STEPS = new Set([8, 9, 14, 15, 16]);

  const fadeTransition = (toStep) => {
    Animated.timing(fadeAnim, {
      toValue: 0,
      duration: 150,
      useNativeDriver: true,
    }).start(() => {
      setStep(toStep);
      setError(null);
      if (TYPING_STEPS.has(toStep)) {
        setTypingComplete(false);
        buttonFadeAnim.setValue(0);
      } else {
        setTypingComplete(true);
        buttonFadeAnim.setValue(1);
      }
      Animated.timing(fadeAnim, {
        toValue: 1,
        duration: 150,
        useNativeDriver: true,
      }).start();
    });
  };

  const handleBack = () => {
    if (step === 0) {
      router.back();
    } else {
      fadeTransition(step - 1);
    }
  };

  const handleUsernameChange = (val) => {
    setUsername(val);
    setUsernameAvailable(null);
    setError(null);
    if (usernameTimeout.current) clearTimeout(usernameTimeout.current);
    if (val.trim().length < 3) return;
    usernameTimeout.current = setTimeout(async () => {
      setCheckingUsername(true);
      try {
        const res = await authenticatedFetch(
          `/api/username?check=${encodeURIComponent(val.trim())}`,
        );
        const data = await res.json();
        setUsernameAvailable(data.available);
      } catch {
        setUsernameAvailable(null);
      }
      setCheckingUsername(false);
    }, 600);
  };

  const completeOnboarding = async (data = {}) => {
    setLoading(true);
    try {
      const res = await authenticatedFetch("/api/user-onboarding", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(data),
      });
      const json = await res.json();
      if (!res.ok || json.error) {
        setError(json.error || "Something went wrong. Please try again.");
        setLoading(false);
        return;
      }
      // After onboarding, send to the hard paywall — except in test builds,
      // where the paywall has no store products to show.
      router.replace(IS_TEST_MODE ? "/(tabs)" : "/paywall");
    } catch {
      setError("Connection failed. Please try again.");
      setLoading(false);
    }
  };

  const getWeightInKg = () => {
    if (!weightKg || weightKg.trim() === "") return null;
    const value = parseFloat(weightKg);
    if (isNaN(value)) return null;
    return weightUnit === "lbs"
      ? (value / 2.20462).toFixed(2)
      : value.toFixed(2);
  };

  const getHeightInCm = () => {
    if (heightUnit === "cm") {
      if (!heightCm || heightCm.trim() === "") return null;
      const value = parseFloat(heightCm);
      return isNaN(value) ? null : value.toFixed(1);
    } else {
      const feet = parseFloat(heightFeet) || 0;
      const inches = parseFloat(heightInches) || 0;
      if (feet === 0 && inches === 0) return null;
      const totalInches = feet * 12 + inches;
      const cm = totalInches * 2.54;
      return cm.toFixed(1);
    }
  };

  const handleFinish = () => {
    const trimmed = username.trim();
    const finalWeightKg = getWeightInKg();
    const finalHeightCm = getHeightInCm();

    completeOnboarding({
      ...(trimmed.length >= 3 ? { username: trimmed } : {}),
      ...(selectedExperience ? { experienceLevel: selectedExperience } : {}),
      ...(selectedAge ? { age: selectedAge } : {}),
      ...(finalWeightKg ? { bodyweightKg: finalWeightKg } : {}),
      ...(finalHeightCm ? { heightCm: finalHeightCm } : {}),
      ...(thinkAboutGettingInShape ? { thinkAboutGettingInShape } : {}),
      ...(energyLevels ? { energyLevels } : {}),
      ...(relateProgress ? { relateProgress } : {}),
      ...(relateRoutine ? { relateRoutine } : {}),
    });
  };

  return {
    fadeAnim,
    holdProgress,
    buttonFadeAnim,
    ageScrollRef,
    weightScrollRef,
    heightScrollRef,
    step,
    setStep,
    username,
    setUsername,
    selectedExperience,
    setSelectedExperience,
    selectedFitnessGoal,
    setSelectedFitnessGoal,
    selectedGender,
    setSelectedGender,
    selectedAge,
    setSelectedAge,
    weightKg,
    setWeightKg,
    rulerWidth,
    setRulerWidth,
    heightCm,
    setHeightCm,
    heightRulerHeight,
    setHeightRulerHeight,
    weightUnit,
    setWeightUnit,
    heightUnit,
    setHeightUnit,
    heightFeet,
    setHeightFeet,
    heightInches,
    setHeightInches,
    thinkAboutGettingInShape,
    setThinkAboutGettingInShape,
    energyLevels,
    setEnergyLevels,
    relateProgress,
    setRelateProgress,
    relateRoutine,
    setRelateRoutine,
    typingComplete,
    setTypingComplete,
    error,
    setError,
    loading,
    setLoading,
    checkingUsername,
    setCheckingUsername,
    usernameAvailable,
    setUsernameAvailable,
    isHolding,
    setIsHolding,
    headlineFinished,
    setHeadlineFinished,
    fadeTransition,
    handleBack,
    handleUsernameChange,
    handleFinish,
  };
};
