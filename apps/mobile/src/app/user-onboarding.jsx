import React from "react";
import {
  View,
  ScrollView,
  KeyboardAvoidingView,
  Platform,
  Animated,
} from "react-native";
import { Image } from "expo-image";
import { StatusBar } from "expo-status-bar";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import Svg, { Rect, Defs, LinearGradient, Stop } from "react-native-svg";
import { LOGO_URL, TOTAL_STEPS } from "@/constants/onboarding";
import { SCREEN_HEIGHT } from "@/constants/onboardingDimensions";
import { OnboardingHeader } from "@/components/Onboarding/OnboardingHeader";
import { OnboardingFooter } from "@/components/Onboarding/OnboardingFooter";
import { UsernameStep } from "@/components/Onboarding/Steps/UsernameStep";
import { ExperienceStep } from "@/components/Onboarding/Steps/ExperienceStep";
import { FitnessGoalStep } from "@/components/Onboarding/Steps/FitnessGoalStep";
import { CommitmentStep } from "@/components/Onboarding/Steps/CommitmentStep";
import { GenderStep } from "@/components/Onboarding/Steps/GenderStep";
import { AgeStep } from "@/components/Onboarding/Steps/AgeStep";
import { WeightStep } from "@/components/Onboarding/Steps/WeightStep";
import { HeightStep } from "@/components/Onboarding/Steps/HeightStep";
import { TransitionStep } from "@/components/Onboarding/Steps/TransitionStep";
import { ThinkShapeStep } from "@/components/Onboarding/Steps/ThinkShapeStep";
import { EnergyLevelStep } from "@/components/Onboarding/Steps/EnergyLevelStep";
import { StatementStep } from "@/components/Onboarding/Steps/StatementStep";
import { ImageTransitionStep } from "@/components/Onboarding/Steps/ImageTransitionStep";
import { MountainTransitionStep } from "@/components/Onboarding/Steps/MountainTransitionStep";
import { SuccessStep } from "@/components/Onboarding/Steps/SuccessStep";
import { TypewriterText } from "@/components/Onboarding/TypewriterText";
import { useOnboardingState } from "@/utils/useOnboardingState";
import { useOnboardingHandlers } from "@/utils/useOnboardingHandlers";
import { ONBOARDING_IMAGES } from "@/constants/onboardingImages";

export default function UserOnboarding() {
  const insets = useSafeAreaInsets();
  const state = useOnboardingState();
  const handlers = useOnboardingHandlers(state);

  const {
    fadeAnim,
    holdProgress,
    buttonFadeAnim,
    ageScrollRef,
    weightScrollRef,
    heightScrollRef,
    step,
    username,
    selectedExperience,
    setSelectedExperience,
    selectedFitnessGoal,
    setSelectedFitnessGoal,
    selectedGender,
    setSelectedGender,
    selectedAge,
    weightKg,
    rulerWidth,
    setRulerWidth,
    heightCm,
    heightFeet,
    heightInches,
    heightUnit,
    heightRulerHeight,
    setHeightRulerHeight,
    weightUnit,
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
    loading,
    checkingUsername,
    usernameAvailable,
    isHolding,
    fadeTransition,
    handleBack,
    handleUsernameChange,
    handleFinish,
    headlineFinished,
    setHeadlineFinished,
  } = state;

  const {
    handleAgeScroll,
    handleAgePress,
    handleWeightScroll,
    handleWeightPress,
    handleSetWeightUnit,
    handleHeightScroll,
    handleHeightPress,
    handleSetHeightUnit,
    handlePressIn,
    handlePressOut,
  } = handlers;

  const progressFill = (step + 1) / TOTAL_STEPS;

  const handleUsernameNext = async () => {
    const trimmed = username.trim();
    if (trimmed.length === 0) {
      fadeTransition(1);
      return;
    }
    if (!/^[a-zA-Z0-9_]{3,20}$/.test(trimmed)) {
      state.setError("3-20 characters: letters, numbers, underscores only");
      return;
    }
    if (usernameAvailable === false) {
      state.setError("That username is already taken");
      return;
    }
    fadeTransition(1);
  };

  const getCanProceed = () => {
    switch (step) {
      case 0:
        // Username must be at least 3 chars and not already taken
        return (
          username.trim().length >= 3 &&
          /^[a-zA-Z0-9_]{3,20}$/.test(username.trim()) &&
          usernameAvailable !== false
        );
      case 1:
        return selectedExperience !== null;
      case 2:
        return selectedFitnessGoal !== null;
      case 4:
        return selectedGender !== null;
      case 10:
        return thinkAboutGettingInShape !== null;
      case 11:
        return energyLevels !== null;
      case 12:
        return relateProgress !== null;
      case 13:
        return relateRoutine !== null;
      default:
        // Age (5), Weight (6), Height (7) always have defaults so always valid.
        // Typing/transition steps (8, 9, 14, 15, 16) are gated by typingComplete.
        return true;
    }
  };

  const getNextHandler = () => {
    if (step === 0) return handleUsernameNext;
    if (step === 8) return () => fadeTransition(9);
    if (step === 9) return () => fadeTransition(10);
    if (step === 10) return () => fadeTransition(11);
    if (step === 11) return () => fadeTransition(12);
    if (step === 12) return () => fadeTransition(13);
    if (step === 13) return () => fadeTransition(14);
    if (step === 14) return () => fadeTransition(15);
    if (step === 15) return () => fadeTransition(16);
    if (step === 16) return () => fadeTransition(17);
    return () => fadeTransition(step + 1);
  };

  return (
    <KeyboardAvoidingView
      behavior={Platform.OS === "ios" ? "padding" : "height"}
      style={{ flex: 1 }}
    >
      <View
        style={{
          flex: 1,
          backgroundColor: "#000000",
          paddingTop: insets.top + 16,
          paddingBottom: insets.bottom,
        }}
      >
        <StatusBar style="light" />

        {/* Background gradients for steps 14 and 15 */}
        {(step === 14 || step === 15) && (
          <View
            style={{
              position: "absolute",
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
            }}
          >
            <Svg height="100%" width="100%">
              <Defs>
                <LinearGradient
                  id="backgroundGrad"
                  x1="0%"
                  y1="0%"
                  x2="0%"
                  y2="100%"
                >
                  <Stop offset="0%" stopColor="#000000" stopOpacity={1} />
                  <Stop offset="100%" stopColor="#6D0000" stopOpacity={1} />
                </LinearGradient>
              </Defs>
              <Rect width="100%" height="100%" fill="url(#backgroundGrad)" />
            </Svg>
          </View>
        )}

        {/* Mountain background for step 16 — outside ScrollView so it ignores padding */}
        {step === 16 && (
          <View
            style={{
              position: "absolute",
              left: 0,
              right: 0,
              bottom: 0,
              height: SCREEN_HEIGHT * 0.45,
              zIndex: 1,
            }}
          >
            <Image
              source={{ uri: ONBOARDING_IMAGES.mountain }}
              style={{ width: "100%", height: "100%" }}
              contentFit="cover"
              cachePolicy="disk"
            />
          </View>
        )}

        {/* Rank image for step 16 — pinned 4px above the mountain top */}
        {step === 16 && (
          <View
            style={{
              position: "absolute",
              left: 0,
              right: 0,
              bottom: SCREEN_HEIGHT * 0.4 - 12,
              alignItems: "center",
              zIndex: 2,
            }}
          >
            <Image
              source={{ uri: ONBOARDING_IMAGES.legend }}
              style={{ width: 200, height: 200 }}
              contentFit="contain"
              cachePolicy="disk"
            />
          </View>
        )}

        {/* Top bar */}
        {step !== 3 && step !== 17 && (
          <OnboardingHeader
            onBack={handleBack}
            progressFill={progressFill}
            hideProgress={step === 14 || step === 15 || step === 16}
          />
        )}

        {/* Animated page content */}
        <Animated.View
          style={{
            flex: 1,
            opacity: fadeAnim,
            zIndex: step === 16 ? 2 : undefined,
          }}
        >
          <ScrollView
            scrollEnabled={
              step !== 5 &&
              step !== 6 &&
              step !== 7 &&
              step !== 8 &&
              step !== 9 &&
              step !== 14 &&
              step !== 15 &&
              step !== 16
            }
            contentContainerStyle={{
              paddingHorizontal: 24,
              paddingBottom: 20,
              flexGrow: 1,
            }}
            keyboardShouldPersistTaps="handled"
            showsVerticalScrollIndicator={false}
          >
            {/* Logo */}
            {step !== 3 &&
              step !== 14 &&
              step !== 15 &&
              step !== 16 &&
              step !== 17 && (
                <View style={{ alignItems: "center", marginBottom: 36 }}>
                  <Image
                    source={{ uri: LOGO_URL }}
                    style={{ width: 64, height: 64 }}
                    contentFit="contain"
                    cachePolicy="disk"
                  />
                </View>
              )}

            {step === 0 && (
              <UsernameStep
                username={username}
                onUsernameChange={handleUsernameChange}
                error={error}
                checkingUsername={checkingUsername}
                usernameAvailable={usernameAvailable}
              />
            )}

            {step === 1 && (
              <ExperienceStep
                selectedExperience={selectedExperience}
                onSelect={setSelectedExperience}
                error={error}
              />
            )}

            {step === 2 && (
              <FitnessGoalStep
                selectedFitnessGoal={selectedFitnessGoal}
                onSelect={setSelectedFitnessGoal}
                error={error}
              />
            )}

            {step === 3 && (
              <CommitmentStep
                loading={loading}
                isHolding={isHolding}
                holdProgress={holdProgress}
                onPressIn={handlePressIn}
                onPressOut={handlePressOut}
              />
            )}

            {step === 4 && (
              <GenderStep
                selectedGender={selectedGender}
                onSelect={setSelectedGender}
              />
            )}

            {step === 5 && (
              <AgeStep
                selectedAge={selectedAge}
                ageScrollRef={ageScrollRef}
                onScroll={handleAgeScroll}
                onAgePress={handleAgePress}
              />
            )}

            {step === 6 && (
              <WeightStep
                weightKg={weightKg}
                weightUnit={weightUnit}
                rulerWidth={rulerWidth}
                weightScrollRef={weightScrollRef}
                onWeightScroll={handleWeightScroll}
                onWeightPress={handleWeightPress}
                onSetWeightUnit={handleSetWeightUnit}
                onRulerLayout={(e) => {
                  const w = e.nativeEvent.layout.width;
                  if (w > 0 && w !== rulerWidth) {
                    setRulerWidth(w);
                  }
                }}
              />
            )}

            {step === 7 && (
              <HeightStep
                heightCm={heightCm}
                heightFeet={heightFeet}
                heightInches={heightInches}
                heightUnit={heightUnit}
                heightRulerHeight={heightRulerHeight}
                heightScrollRef={heightScrollRef}
                onHeightScroll={handleHeightScroll}
                onHeightPress={handleHeightPress}
                onSetHeightUnit={handleSetHeightUnit}
                onHeightRulerLayout={(e) => {
                  const h = e.nativeEvent.layout.height;
                  if (h > 0 && h !== heightRulerHeight) {
                    setHeightRulerHeight(h);
                  }
                }}
              />
            )}

            {step === 8 && (
              <TransitionStep
                text="This journey is all about you..."
                onComplete={() => {
                  setTypingComplete(true);
                  Animated.timing(buttonFadeAnim, {
                    toValue: 1,
                    duration: 300,
                    useNativeDriver: true,
                  }).start();
                }}
              />
            )}

            {step === 9 && (
              <TransitionStep
                text="...so let's make sure you're truly part of it!"
                onComplete={() => {
                  setTypingComplete(true);
                  Animated.timing(buttonFadeAnim, {
                    toValue: 1,
                    duration: 300,
                    useNativeDriver: true,
                  }).start();
                }}
              />
            )}

            {step === 10 && (
              <ThinkShapeStep
                selected={thinkAboutGettingInShape}
                onSelect={setThinkAboutGettingInShape}
              />
            )}

            {step === 11 && (
              <EnergyLevelStep
                selected={energyLevels}
                onSelect={setEnergyLevels}
              />
            )}

            {step === 12 && (
              <StatementStep
                statement="Sometimes, it's hard to notice progress when I workout"
                selected={relateProgress}
                onSelect={setRelateProgress}
              />
            )}

            {step === 13 && (
              <StatementStep
                statement="I don't know which body part really needs work so I usually follow the same routine"
                selected={relateRoutine}
                onSelect={setRelateRoutine}
              />
            )}

            {step === 14 && (
              <ImageTransitionStep
                headline="Effort no one sees is easy to quit"
                subtext="When there's no one to prove yourself against, progress feels slow and effort feels pointless"
                imageUrl={ONBOARDING_IMAGES.effortAlone}
                onComplete={() => setTypingComplete(true)}
                buttonFadeAnim={buttonFadeAnim}
              />
            )}

            {step === 15 && (
              <ImageTransitionStep
                headline="Training alone is boring"
                subtext="No one's watching. No one's counting. It's easy to skip a rep. or the whole set"
                imageUrl={ONBOARDING_IMAGES.trainingAlone}
                onComplete={() => setTypingComplete(true)}
                buttonFadeAnim={buttonFadeAnim}
              />
            )}

            {step === 16 && (
              <View
                style={{
                  flex: 1,
                  paddingHorizontal: 20,
                  alignItems: "center",
                  justifyContent: "flex-start",
                  minHeight: SCREEN_HEIGHT * 0.62,
                  position: "relative",
                }}
              >
                <View
                  style={{ alignItems: "center", width: "100%", height: 170 }}
                >
                  <TypewriterText
                    text="The grind hits different with a rival"
                    onComplete={() => {
                      setHeadlineFinished(true);
                    }}
                    style={{
                      color: "#FFFFFF",
                      fontSize: 28,
                      fontWeight: "900",
                      textAlign: "center",
                      lineHeight: 36,
                      marginBottom: 12,
                    }}
                  />
                  {headlineFinished && (
                    <TypewriterText
                      text="Every match puts you against a real opponent, put in the work, and prove who trained harder."
                      onComplete={() => {
                        setTypingComplete(true);
                        Animated.timing(buttonFadeAnim, {
                          toValue: 1,
                          duration: 300,
                          useNativeDriver: true,
                        }).start();
                      }}
                      style={{
                        color: "#888888",
                        fontSize: 16,
                        fontWeight: "600",
                        textAlign: "center",
                        lineHeight: 24,
                      }}
                    />
                  )}
                </View>
              </View>
            )}

            {step === 17 && (
              <SuccessStep loading={loading} onFinish={handleFinish} />
            )}
          </ScrollView>
        </Animated.View>

        {/* Bottom buttons */}
        {step !== 3 && step !== 17 && (
          <View style={step === 16 ? { zIndex: 3 } : undefined}>
            <OnboardingFooter
              step={step}
              loading={loading}
              typingComplete={typingComplete}
              buttonFadeAnim={buttonFadeAnim}
              onNext={getNextHandler()}
              canProceed={getCanProceed()}
            />
          </View>
        )}
      </View>
    </KeyboardAvoidingView>
  );
}
