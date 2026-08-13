import { useEffect } from "react";
import { Animated } from "react-native";
import {
  ITEM_HEIGHT,
  TICK_WIDTH,
  HEIGHT_TICK_HEIGHT,
} from "@/constants/onboardingDimensions";

export const useOnboardingHandlers = (state) => {
  const {
    step,
    selectedAge,
    weightKg,
    weightUnit,
    heightCm,
    heightFeet,
    heightInches,
    heightUnit,
    ageScrollRef,
    weightScrollRef,
    heightScrollRef,
    setSelectedAge,
    setWeightKg,
    setHeightCm,
    setHeightFeet,
    setHeightInches,
    setWeightUnit,
    setHeightUnit,
    setTypingComplete,
    setIsHolding,
    buttonFadeAnim,
    holdProgress,
    fadeTransition,
    setHeadlineFinished,
  } = state;

  // Age scroll handler
  const handleAgeScroll = (event) => {
    const y = event.nativeEvent.contentOffset.y;
    const index = Math.round(y / ITEM_HEIGHT);
    const age = index + 13;
    if (age >= 13 && age <= 100 && age !== selectedAge) {
      setSelectedAge(age);
    }
  };

  const handleAgePress = (age) => {
    if (ageScrollRef.current) {
      ageScrollRef.current.scrollToOffset({
        offset: (age - 13) * ITEM_HEIGHT,
        animated: true,
      });
    }
  };

  // Weight scroll handler
  const handleWeightScroll = (event) => {
    const x = event.nativeEvent.contentOffset.x;
    const minWeight = weightUnit === "kg" ? 30 : 70;
    const index = Math.round(x / TICK_WIDTH);
    const val = minWeight + index * 0.5;
    const maxWeight = weightUnit === "kg" ? 220 : 480;
    if (
      val >= minWeight &&
      val <= maxWeight &&
      val.toFixed(1) !== parseFloat(weightKg).toFixed(1)
    ) {
      setWeightKg(val.toFixed(1));
    }
  };

  const handleWeightPress = (weight) => {
    const minWeight = weightUnit === "kg" ? 30 : 70;
    if (weightScrollRef.current) {
      weightScrollRef.current.scrollToOffset({
        offset: ((weight - minWeight) / 0.5) * TICK_WIDTH,
        animated: true,
      });
    }
  };

  const handleSetWeightUnit = (unit) => {
    if (unit === weightUnit) return;
    setWeightUnit(unit);
    const currentVal = parseFloat(weightKg) || (weightUnit === "kg" ? 70 : 154);
    if (unit === "kg") {
      const converted = Math.round((currentVal / 2.20462) * 2) / 2;
      setWeightKg(converted.toFixed(1));
    } else {
      const converted = Math.round(currentVal * 2.20462 * 2) / 2;
      setWeightKg(converted.toFixed(1));
    }
  };

  // Height scroll handler
  const handleHeightScroll = (event) => {
    const y = event.nativeEvent.contentOffset.y;
    const index = Math.round(y / HEIGHT_TICK_HEIGHT);
    if (heightUnit === "cm") {
      const minH = 100;
      const maxH = 250;
      const val = minH + index * 0.5;
      if (val >= minH && val <= maxH) {
        const display = val % 1 === 0 ? val.toString() : val.toFixed(1);
        if (display !== heightCm) setHeightCm(display);
      }
    } else {
      const minH = 36;
      const maxH = 96;
      const val = minH + index * 0.5;
      if (val >= minH && val <= maxH) {
        const roundedInches = Math.round(val);
        const ft = Math.floor(roundedInches / 12).toString();
        const inch = (roundedInches % 12).toString();
        if (ft !== heightFeet || inch !== heightInches) {
          setHeightFeet(ft);
          setHeightInches(inch);
        }
      }
    }
  };

  const handleHeightPress = (value) => {
    const minH = heightUnit === "cm" ? 100 : 36;
    if (heightScrollRef.current) {
      heightScrollRef.current.scrollToOffset({
        offset: ((value - minH) / 0.5) * HEIGHT_TICK_HEIGHT,
        animated: true,
      });
    }
  };

  const handleSetHeightUnit = (unit) => {
    if (unit === heightUnit) return;
    if (unit === "ft") {
      const cm = parseFloat(heightCm) || 178;
      const totalInches = cm / 2.54;
      const ft = Math.floor(totalInches / 12);
      const inch = Math.round(totalInches % 12);
      setHeightFeet(ft.toString());
      setHeightInches(inch.toString());
    } else {
      const feet = parseFloat(heightFeet) || 5;
      const inches = parseFloat(heightInches) || 10;
      const totalInches = feet * 12 + inches;
      const cm = Math.round(totalInches * 2.54);
      setHeightCm(cm.toString());
    }
    setHeightUnit(unit);
  };

  // Commitment hold handlers
  const handlePressIn = () => {
    setIsHolding(true);
    Animated.timing(holdProgress, {
      toValue: 1,
      duration: 2000,
      useNativeDriver: true,
    }).start(({ finished }) => {
      if (finished) {
        fadeTransition(4);
      }
    });
  };

  const handlePressOut = () => {
    setIsHolding(false);
    Animated.timing(holdProgress, {
      toValue: 0,
      duration: 200,
      useNativeDriver: true,
    }).start();
  };

  // Initialize scroll positions
  useEffect(() => {
    if (step === 5 && ageScrollRef.current) {
      setTimeout(() => {
        ageScrollRef.current?.scrollToOffset({
          offset: (selectedAge - 13) * ITEM_HEIGHT,
          animated: false,
        });
      }, 100);
    }
  }, [step]);

  useEffect(() => {
    if (step === 6 && weightScrollRef.current) {
      const val = parseFloat(weightKg) || (weightUnit === "kg" ? 70 : 154);
      const minWeight = weightUnit === "kg" ? 30 : 70;
      const targetIndex = (val - minWeight) / 0.5;
      setTimeout(() => {
        weightScrollRef.current?.scrollToOffset({
          offset: targetIndex * TICK_WIDTH,
          animated: false,
        });
      }, 100);
    }
  }, [step, weightUnit]);

  useEffect(() => {
    if (step === 7 && heightScrollRef.current) {
      let targetIndex;
      if (heightUnit === "cm") {
        const val = parseFloat(heightCm) || 178;
        targetIndex = (val - 100) / 0.5;
      } else {
        const feet = parseFloat(heightFeet) || 5;
        const inches = parseFloat(heightInches) || 10;
        const totalInches = feet * 12 + inches;
        targetIndex = (totalInches - 36) / 0.5;
      }
      setTimeout(() => {
        heightScrollRef.current?.scrollToOffset({
          offset: targetIndex * HEIGHT_TICK_HEIGHT,
          animated: false,
        });
      }, 100);
    }
  }, [step, heightUnit]);

  // Typing complete management
  useEffect(() => {
    if (step === 8 || step === 9 || step === 14 || step === 15 || step === 16) {
      setTypingComplete(false);
      buttonFadeAnim.setValue(0);
      if (step === 16) {
        setHeadlineFinished(false);
      }
    } else {
      setTypingComplete(true);
      buttonFadeAnim.setValue(1);
    }
  }, [step]);

  return {
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
  };
};
