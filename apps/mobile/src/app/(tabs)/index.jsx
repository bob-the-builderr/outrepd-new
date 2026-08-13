import React, { useState, useEffect, useRef, useCallback } from "react";
import {
  View,
  Text,
  ScrollView,
  TouchableOpacity,
  ActivityIndicator,
} from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";
import { useAuth } from "@/utils/auth/useAuth";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import KeyboardAvoidingAnimatedView from "@/components/KeyboardAvoidingAnimatedView";
import { TIERS, DIVISION_NAMES } from "@/constants/tiers";
import { SCREEN_H } from "@/constants/canvas";
import { ALL_NODES } from "@/utils/roadNodes";
import { getLPChange, applyLPChange } from "@/utils/lpSystem";
import {
  getWilksMultiplier,
  getEquipmentMultiplier,
  getHeightMultiplier,
} from "@/utils/volumeMultipliers";
import { EXERCISES_BY_MUSCLE } from "@/constants/exercises";
import { PromotionCeremony } from "@/components/PromotionCeremony/PromotionCeremony";
import { TrophyRoadCanvas } from "@/components/TrophyRoad/TrophyRoadCanvas";
import { TrophyRoadHeader } from "@/components/TrophyRoad/TrophyRoadHeader";
import { TrophyRoadButtons } from "@/components/TrophyRoad/TrophyRoadButtons";
import { MuscleSelectorModal } from "@/components/MuscleSelectorModal/MuscleSelectorModal";
import { VSScreen } from "@/components/VSScreen/VSScreen";
import { MatchHeader } from "@/components/ActiveMatch/MatchHeader";
import { WorkoutLogger } from "@/components/ActiveMatch/WorkoutLogger";
import { MatchFooter } from "@/components/ActiveMatch/MatchFooter";
import { ResultsScreen } from "@/components/ResultsScreen/ResultsScreen";
import { WaitingForOpponent } from "@/components/WaitingForOpponent/WaitingForOpponent";
import SearchingForMatch from "@/components/SearchingForMatch/SearchingForMatch";
import { JoinMatchScreen } from "@/components/JoinMatchScreen/JoinMatchScreen";
import { Swords } from "lucide-react-native";
import { authenticatedFetch } from "@/utils/authenticatedFetch";
import { volumeToScore } from "@/utils/scoreSystem";

// build a flat exercise-name → equipment lookup once at module level
const _allExercises = Object.values(EXERCISES_BY_MUSCLE).flat();
const EXERCISE_EQUIPMENT_MAP = {};
_allExercises.forEach((ex) => {
  EXERCISE_EQUIPMENT_MAP[ex.name] = ex.equipment?.toLowerCase() || "barbell";
});

export default function MatchScreen() {
  const insets = useSafeAreaInsets();
  const scrollRef = useRef(null);
  const { auth, isReady, signIn } = useAuth(); // Get signIn for login prompts
  const queryClient = useQueryClient();
  const pollRef = useRef(null);
  const activeForfeitPollRef = useRef(null); // detects opponent forfeit while match is active

  // ── Fetch user profile ──
  const { data: profileData } = useQuery({
    queryKey: ["profile"],
    queryFn: async () => {
      const response = await authenticatedFetch("/api/profile");
      if (!response.ok) {
        if (response.status === 401) return null;
        throw new Error("Failed to fetch profile");
      }
      return response.json();
    },
    enabled: !!auth,
  });

  // ── Fetch user settings (for units preference) ──
  const { data: settingsData } = useQuery({
    queryKey: ["settings"],
    queryFn: async () => {
      const response = await authenticatedFetch("/api/settings");
      if (!response.ok) return null;
      return response.json();
    },
    enabled: !!auth,
  });

  const units = settingsData?.units ?? "kg";
  const LBS_TO_KG = 0.453592;

  const createProfileMutation = useMutation({
    mutationFn: async (username) => {
      const response = await authenticatedFetch("/api/profile", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ username }),
      });
      if (!response.ok) throw new Error("Failed to create profile");
      return response.json();
    },
    onSuccess: () => queryClient.invalidateQueries(["profile"]),
  });

  const createWorkoutMutation = useMutation({
    mutationFn: async (workoutData) => {
      const response = await authenticatedFetch("/api/workouts", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(workoutData),
      });
      if (!response.ok) throw new Error("Failed to create workout");
      return response.json();
    },
  });

  // ── Player rank state ──
  const [playerState, setPlayerState] = useState({
    tierIdx: 3,
    divIdx: 1,
    lp: 65,
    demotionShield: true,
  });

  useEffect(() => {
    if (profileData?.profile) {
      setPlayerState({
        tierIdx: profileData.profile.tier_idx,
        divIdx: profileData.profile.div_idx,
        lp: profileData.profile.lp,
        demotionShield: profileData.profile.demotion_shield !== null,
      });
    }
  }, [profileData]);

  useEffect(() => {
    if (auth && !profileData?.profile) {
      createProfileMutation.mutate(auth.user?.name || "Player");
    }
  }, [auth, profileData]);

  const [showPromotion, setShowPromotion] = useState(false);
  const [promotedTo, setPromotedTo] = useState({ tierIdx: 3, divIdx: 2 });
  const [scrollY, setScrollY] = useState(0);

  // ── Game flow state ──
  const [gameState, setGameState] = useState("road");
  const [selectedMuscle, setSelectedMuscle] = useState(null);
  const [matchMode, setMatchMode] = useState("matchmaking"); // 'matchmaking' | 'challenge'
  const [countdown, setCountdown] = useState(3);
  const [matchTime, setMatchTime] = useState(7200);
  const [workout, setWorkout] = useState([]);
  const [volume, setVolume] = useState(0);
  const [baseVolume, setBaseVolume] = useState(0);
  const [lastLPChange, setLastLPChange] = useState(null);
  const [shieldTooltipVisible, setShieldTooltipVisible] = useState(false);

  // ── Multiplayer state ──
  const [inviteCode, setInviteCode] = useState(null);
  const [opponentData, setOpponentData] = useState(null);
  const [matchRole, setMatchRole] = useState(null); // 'host' | 'guest'
  const [createInviteLoading, setCreateInviteLoading] = useState(false);
  const [submitError, setSubmitError] = useState(null);
  const [resolvedMatch, setResolvedMatch] = useState(null); // backend result data
  const [exerciseConfigError, setExerciseConfigError] = useState(null);
  const [completedMatchId, setCompletedMatchId] = useState(null); // for VIEW FULL DETAILS

  // Helper: fetch most recent match ID after a match resolves
  const fetchLatestMatchId = async () => {
    try {
      const res = await authenticatedFetch("/api/matches?limit=1");
      if (!res.ok) return;
      const data = await res.json();
      const latest = data.matches?.[0];
      if (latest?.id) setCompletedMatchId(latest.id);
    } catch {
      /* silently ignore — details button will just show empty state */
    }
  };

  // ── Cleanup poll on unmount ──
  useEffect(() => {
    return () => {
      if (pollRef.current) clearInterval(pollRef.current);
      if (activeForfeitPollRef.current)
        clearInterval(activeForfeitPollRef.current);
    };
  }, []);

  // ── Poll for opponent forfeit while in active multiplayer match ──
  useEffect(() => {
    if (gameState !== "active" || !inviteCode) {
      if (activeForfeitPollRef.current) {
        clearInterval(activeForfeitPollRef.current);
        activeForfeitPollRef.current = null;
      }
      return;
    }
    activeForfeitPollRef.current = setInterval(async () => {
      try {
        const res = await authenticatedFetch(
          `/api/matches/invite/${inviteCode}`,
        );
        if (!res.ok) return;
        const data = await res.json();
        const m = data.match;
        if (m?.status === "cancelled") {
          clearInterval(activeForfeitPollRef.current);
          activeForfeitPollRef.current = null;
          const isHost = matchRole === "host";
          const lpChange = isHost
            ? parseInt(m.host_lp_change)
            : parseInt(m.guest_lp_change);
          setLastLPChange(lpChange);
          setOpponentData((prev) => ({ ...prev, volume: 0, forfeited: true }));
          try {
            const freshRes = await authenticatedFetch("/api/profile");
            const freshData = await freshRes.json();
            if (freshData?.profile) {
              const p = freshData.profile;
              const freshState = {
                tierIdx: p.tier_idx,
                divIdx: p.div_idx,
                lp: p.lp,
                demotionShield: p.demotion_shield !== null,
              };
              setPlayerState(freshState);
              if (
                freshState.tierIdx > playerState.tierIdx ||
                (freshState.tierIdx === playerState.tierIdx &&
                  freshState.divIdx > playerState.divIdx)
              ) {
                setPromotedTo({
                  tierIdx: freshState.tierIdx,
                  divIdx: freshState.divIdx,
                });
                setTimeout(() => setShowPromotion(true), 400);
              }
            }
          } catch {
            /* ignore */
          }
          queryClient.invalidateQueries(["profile"]);
          await fetchLatestMatchId();
          setGameState("results");
        }
      } catch {
        /* retry silently */
      }
    }, 5000);
    return () => {
      if (activeForfeitPollRef.current) {
        clearInterval(activeForfeitPollRef.current);
        activeForfeitPollRef.current = null;
      }
    };
  }, [gameState, inviteCode, matchRole]);

  // ── Derived rank info ──
  const currentNodeIdx = playerState.tierIdx * 4 + playerState.divIdx;
  const currentTier = TIERS[Math.min(playerState.tierIdx, 8)];
  const currentDivName = DIVISION_NAMES[Math.min(playerState.divIdx, 3)];
  const isLegendI = playerState.tierIdx === 8 && playerState.divIdx === 3;
  const lpToNext = 100 - playerState.lp;
  const currentRankOffset = ALL_NODES[currentNodeIdx].y - SCREEN_H * 0.48;
  const shouldShowDownToRank = scrollY < currentRankOffset - 400;
  const shouldShowUpToRank = scrollY > currentRankOffset + 400;
  const nextDivLabel =
    playerState.divIdx === 3
      ? TIERS[Math.min(playerState.tierIdx + 1, 8)]?.name + " IV"
      : DIVISION_NAMES[playerState.divIdx + 1];

  useEffect(() => {
    if (gameState === "road") {
      setTimeout(
        () =>
          scrollRef.current?.scrollTo({
            y: currentRankOffset,
            animated: false,
          }),
        130,
      );
    }
  }, [gameState, currentNodeIdx, currentRankOffset]);

  // ── VS countdown ──
  useEffect(() => {
    if (gameState === "vs" && countdown > 0) {
      const t = setTimeout(() => setCountdown((c) => c - 1), 1000);
      return () => clearTimeout(t);
    }
    if (gameState === "vs" && countdown === 0) {
      setMatchTime(7200);
      setGameState("active");
    }
  }, [gameState, countdown]);

  // ── Match timer ──
  useEffect(() => {
    if (gameState === "active" && matchTime > 0) {
      const t = setInterval(() => setMatchTime((s) => s - 1), 1000);
      return () => clearInterval(t);
    }
  }, [gameState, matchTime]);

  // Helper to check auth and prompt login if needed
  const requireAuth = useCallback(() => {
    if (!auth) {
      signIn();
      return false;
    }
    return true;
  }, [auth, signIn]);

  // Wrap protected actions with auth check
  const handleMuscleSelected = async (muscle) => {
    if (!requireAuth()) return; // Prompt login if not authenticated

    setSelectedMuscle(muscle);
  };

  // ════════════════════════════════════════
  // MULTIPLAYER — HOST CREATES INVITE
  // ════════════════════════════════════════
  const createInviteAndWait = async () => {
    if (!requireAuth()) return;
    if (!selectedMuscle) return;

    // Check if exercises are configured for this muscle group
    setExerciseConfigError(null);
    try {
      const exerciseRes = await authenticatedFetch(
        `/api/exercise-selections?muscle_group=${selectedMuscle}`,
      );
      if (!exerciseRes.ok) {
        setExerciseConfigError("Failed to load exercises. Please try again.");
        return;
      }
      const exerciseData = await exerciseRes.json();
      const selection = exerciseData.selections?.[0];

      if (
        !selection ||
        !selection.exercises ||
        selection.exercises.length !== 6
      ) {
        setExerciseConfigError(
          `You need to configure 6 exercises for ${selectedMuscle} in the Training tab before creating a match.`,
        );
        return;
      }

      // Pre-populate workout with user's selected exercises
      const initialWorkout = selection.exercises.map((exerciseName, idx) => ({
        id: Date.now() + idx,
        name: exerciseName,
        equipment: EXERCISE_EQUIPMENT_MAP[exerciseName] || "barbell",
        sets: [],
      }));
      setWorkout(initialWorkout);
    } catch (err) {
      console.error("Failed to fetch exercise selections:", err);
      setExerciseConfigError(
        "Failed to load your exercises. Please try again.",
      );
      return;
    }

    setCreateInviteLoading(true);
    try {
      const res = await authenticatedFetch("/api/matches/invite", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          muscle_group: selectedMuscle,
          tier_idx: playerState.tierIdx,
          div_idx: playerState.divIdx,
          lp: playerState.lp,
          demotion_shield: playerState.demotionShield,
        }),
      });
      if (!res.ok) throw new Error("Failed to create invite");
      const data = await res.json();
      const code = data.invite_code;
      setInviteCode(code);
      setMatchRole("host");
      setGameState("waiting-for-opponent");

      // Poll every 3s for guest joining
      pollRef.current = setInterval(async () => {
        try {
          const pollRes = await authenticatedFetch(
            `/api/matches/invite/${code}`,
          );
          if (!pollRes.ok) return;
          const pollData = await pollRes.json();
          if (pollData.match?.status === "active") {
            clearInterval(pollRef.current);
            setOpponentData({
              name:
                pollData.match.guest_username ||
                pollData.match.guest_name ||
                pollData.match.guest_email ||
                "Opponent",
              tierIdx: parseInt(pollData.match.guest_tier_idx) || 0,
              divIdx: parseInt(pollData.match.guest_div_idx) || 0,
              profilePhotoUrl: pollData.match.guest_profile_photo_url,
            });
            // Do NOT reset workout — host's exercises are already loaded
            setVolume(0);
            setCountdown(3);
            setGameState("vs");
          }
        } catch {
          /* silently retry */
        }
      }, 3000);
    } catch (err) {
      console.error("createInviteAndWait error", err);
      setExerciseConfigError("Failed to create match. Please try again.");
    } finally {
      setCreateInviteLoading(false);
    }
  };

  const cancelInvite = () => {
    if (pollRef.current) clearInterval(pollRef.current);
    setInviteCode(null);
    setMatchRole(null);
    setGameState("road");
  };

  // ════════════════════════════════════════
  // MATCHMAKING — FIND MATCH
  // ════════════════════════════════════════
  const findMatchAndWait = async () => {
    if (!requireAuth()) return;
    if (!selectedMuscle) return;

    // Check if exercises are configured for this muscle group
    setExerciseConfigError(null);
    try {
      const exerciseRes = await authenticatedFetch(
        `/api/exercise-selections?muscle_group=${selectedMuscle}`,
      );
      if (!exerciseRes.ok) {
        setExerciseConfigError("Failed to load exercises. Please try again.");
        return;
      }
      const exerciseData = await exerciseRes.json();
      const selection = exerciseData.selections?.[0];

      if (
        !selection ||
        !selection.exercises ||
        selection.exercises.length !== 6
      ) {
        setExerciseConfigError(
          `You need to configure 6 exercises for ${selectedMuscle} in the Training tab before searching for a match.`,
        );
        return;
      }

      // Pre-populate workout with user's selected exercises
      const initialWorkout = selection.exercises.map((exerciseName, idx) => ({
        id: Date.now() + idx,
        name: exerciseName,
        equipment: EXERCISE_EQUIPMENT_MAP[exerciseName] || "barbell",
        sets: [],
      }));
      setWorkout(initialWorkout);
    } catch (err) {
      console.error("Failed to fetch exercise selections:", err);
      setExerciseConfigError(
        "Failed to load your exercises. Please try again.",
      );
      return;
    }

    setCreateInviteLoading(true);
    try {
      // Join the matchmaking queue
      const joinRes = await authenticatedFetch("/api/matchmaking/queue", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          muscle_group: selectedMuscle,
          tier_idx: playerState.tierIdx,
          div_idx: playerState.divIdx,
          lp: playerState.lp,
          demotion_shield: playerState.demotionShield,
        }),
      });

      if (!joinRes.ok) {
        const errData = await joinRes.json().catch(() => ({}));
        if (errData.error === "height_required") {
          setExerciseConfigError(
            "📏 Set your height in Settings → Body Stats before entering ranked matches.",
          );
        } else {
          setExerciseConfigError(
            "Failed to join matchmaking. Please try again.",
          );
        }
        setCreateInviteLoading(false);
        return;
      }

      setGameState("searching-for-match");
      setCreateInviteLoading(false);

      // Poll every 3s for a match
      pollRef.current = setInterval(async () => {
        try {
          const searchRes = await authenticatedFetch("/api/matchmaking/search");
          if (!searchRes.ok) return;
          const searchData = await searchRes.json();

          if (searchData.match_found) {
            clearInterval(pollRef.current);
            setInviteCode(searchData.invite_code);
            setMatchRole(searchData.role);
            setOpponentData({
              name: searchData.opponent.name,
              tierIdx: searchData.opponent.tier_idx,
              divIdx: searchData.opponent.div_idx,
            });

            // Load exercises for the matched muscle group
            try {
              const exerciseRes = await authenticatedFetch(
                `/api/exercise-selections?muscle_group=${selectedMuscle}`,
              );
              if (exerciseRes.ok) {
                const exerciseData = await exerciseRes.json();
                const selection = exerciseData.selections?.[0];
                if (selection?.exercises?.length === 6) {
                  const initialWorkout = selection.exercises.map(
                    (exerciseName, idx) => ({
                      id: Date.now() + idx,
                      name: exerciseName,
                      equipment:
                        EXERCISE_EQUIPMENT_MAP[exerciseName] || "barbell",
                      sets: [],
                    }),
                  );
                  setWorkout(initialWorkout);
                } else {
                  setWorkout([]);
                }
              } else {
                setWorkout([]);
              }
            } catch {
              setWorkout([]);
            }

            setVolume(0);
            setCountdown(3);
            setGameState("vs");
          }
        } catch (err) {
          console.error("Match search poll error", err);
        }
      }, 3000);
    } catch (err) {
      console.error("findMatchAndWait error", err);
      setExerciseConfigError("Failed to start matchmaking. Please try again.");
      setCreateInviteLoading(false);
    }
  };

  const cancelMatchmaking = async () => {
    if (pollRef.current) clearInterval(pollRef.current);
    try {
      await authenticatedFetch("/api/matchmaking/queue", { method: "DELETE" });
    } catch (err) {
      console.error("Failed to leave matchmaking queue", err);
    }
    setGameState("road");
  };

  // ════════════════════════════════════════
  // MULTIPLAYER — GUEST JOINS
  // ════════════════════════════════════════
  const handleGuestJoin = async (joinData) => {
    // Check if exercises are configured for this muscle group
    try {
      const exerciseRes = await authenticatedFetch(
        `/api/exercise-selections?muscle_group=${joinData.muscleGroup}`,
      );
      if (exerciseRes.ok) {
        const exerciseData = await exerciseRes.json();
        const selection = exerciseData.selections?.[0];

        if (selection?.exercises?.length === 6) {
          // Pre-populate workout with user's selected exercises
          const initialWorkout = selection.exercises.map(
            (exerciseName, idx) => ({
              id: Date.now() + idx,
              name: exerciseName,
              equipment: EXERCISE_EQUIPMENT_MAP[exerciseName] || "barbell",
              sets: [],
            }),
          );
          setWorkout(initialWorkout);
        }
      }
    } catch (err) {
      console.error("Failed to fetch exercise selections:", err);
    }

    setInviteCode(joinData.inviteCode);
    setSelectedMuscle(joinData.muscleGroup);
    setOpponentData({
      name: joinData.opponentName,
      tierIdx: joinData.opponentTierIdx,
      divIdx: joinData.opponentDivIdx,
    });
    setMatchRole("guest");
    setVolume(0);
    setCountdown(3);
    setGameState("vs");
  };

  // ════════════════════════════════════════
  // MULTIPLAYER — SUBMIT VOLUME
  // ════════════════════════════════════════
  const handleSubmitVolume = async () => {
    setSubmitError(null);
    try {
      // Save workout log first
      const workoutExercises = workout.map((ex) => ({
        exercise_name: ex.name || "Unknown Exercise",
        muscle_group: selectedMuscle || "Unknown",
        sets: ex.sets.map((s) => ({
          reps: parseInt(s.reps) || 0,
          weight_kg:
            units === "lbs"
              ? (parseFloat(s.weight) || 0) * LBS_TO_KG
              : parseFloat(s.weight) || 0,
          volume_kg:
            (units === "lbs"
              ? (parseFloat(s.weight) || 0) * LBS_TO_KG
              : parseFloat(s.weight) || 0) * (parseInt(s.reps) || 0),
          equipment_type: ex.equipment || "barbell", // Include equipment type from exercise
        })),
      }));
      await createWorkoutMutation.mutateAsync({
        workout_name: `${currentTier?.name} Match — ${selectedMuscle}`,
        exercises: workoutExercises,
        duration_minutes: Math.floor((7200 - matchTime) / 60),
      });

      const res = await authenticatedFetch(
        `/api/matches/invite/${inviteCode}/submit`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ volume_kg: volume }),
        },
      );
      const data = await res.json();
      if (!res.ok) {
        setSubmitError(data.error || "Submit failed");
        return;
      }

      if (data.status === "completed") {
        handleMatchCompleted(data);
      } else {
        // Waiting for opponent to submit — poll GET endpoint
        setGameState("waiting-for-results");
        if (pollRef.current) clearInterval(pollRef.current);
        pollRef.current = setInterval(async () => {
          try {
            const pollRes = await authenticatedFetch(
              `/api/matches/invite/${inviteCode}`,
            );
            if (!pollRes.ok) return;
            const pollData = await pollRes.json();
            const m = pollData.match;
            if (m?.status === "completed" || m?.status === "cancelled") {
              clearInterval(pollRef.current);
              const isHost = matchRole === "host";
              const lpChange = isHost
                ? parseInt(m.host_lp_change)
                : parseInt(m.guest_lp_change);
              const opponentVolume = isHost
                ? parseFloat(m.guest_volume_kg || 0)
                : parseFloat(m.host_volume_kg || 0);
              setLastLPChange(lpChange);
              setOpponentData((prev) => ({
                ...prev,
                volume: opponentVolume,
                forfeited: m.status === "cancelled",
              }));
              // Fetch fresh profile so playerState is up-to-date for Results screen
              try {
                const freshProfile = await authenticatedFetch("/api/profile");
                const freshData = await freshProfile.json();
                if (freshData?.profile) {
                  const p = freshData.profile;
                  const freshState = {
                    tierIdx: p.tier_idx,
                    divIdx: p.div_idx,
                    lp: p.lp,
                    demotionShield: p.demotion_shield !== null,
                  };
                  setPlayerState(freshState);
                  if (
                    freshState.tierIdx > playerState.tierIdx ||
                    (freshState.tierIdx === playerState.tierIdx &&
                      freshState.divIdx > playerState.divIdx)
                  ) {
                    setPromotedTo({
                      tierIdx: freshState.tierIdx,
                      divIdx: freshState.divIdx,
                    });
                    setTimeout(() => setShowPromotion(true), 400);
                  }
                }
              } catch {
                /* ignore */
              }
              queryClient.invalidateQueries(["profile"]);
              await fetchLatestMatchId();
              setGameState("results");
            }
          } catch {
            /* retry silently */
          }
        }, 3000);
      }
    } catch (err) {
      console.error("handleSubmitVolume error", err);
      setSubmitError("Failed to submit. Please try again.");
    }
  };

  const handleMatchCompleted = (data) => {
    if (pollRef.current) clearInterval(pollRef.current);
    setResolvedMatch(data);
    const isHost = matchRole === "host";
    const lpChange = isHost ? data.host_lp_change : data.guest_lp_change;
    const newState = isHost ? data.host_new_state : data.guest_new_state;

    setLastLPChange(lpChange);
    setPlayerState({
      tierIdx: newState.tierIdx,
      divIdx: newState.divIdx,
      lp: newState.lp,
      demotionShield: newState.demotionShield,
    });

    const opponentVolume = isHost
      ? parseFloat(data.match?.guest_volume_kg || 0)
      : parseFloat(data.match?.host_volume_kg || 0);
    setOpponentData((prev) => ({ ...prev, volume: opponentVolume }));

    if (newState.promoted) {
      setPromotedTo({ tierIdx: newState.tierIdx, divIdx: newState.divIdx });
      setTimeout(() => setShowPromotion(true), 400);
    }
    queryClient.invalidateQueries(["profile"]);
    fetchLatestMatchId().then(() => setGameState("results"));
  };

  // ════════════════════════════════════════
  // OLD SOLO MATCH (kept for forfeit / back-compat)
  // ════════════════════════════════════════
  const applyMatchResult = async (won) => {
    const lpChange = getLPChange(won ? "win" : "loss", 3, playerState.tierIdx);
    setLastLPChange(lpChange);
    const newState = applyLPChange(playerState, lpChange);
    setPlayerState({
      tierIdx: newState.tierIdx,
      divIdx: newState.divIdx,
      lp: newState.lp,
      demotionShield: newState.demotionShield,
    });
    if (newState.promoted) {
      setPromotedTo({ tierIdx: newState.tierIdx, divIdx: newState.divIdx });
      setTimeout(() => setShowPromotion(true), 400);
    }
    setOpponentData({ name: "Opponent", volume: volume * (won ? 0.9 : 1.1) });
    setGameState("results");
  };

  // ════════════════════════════════════════
  // FORFEIT — multiplayer-aware
  // ════════════════════════════════════════
  const handleForfeit = async () => {
    if (activeForfeitPollRef.current)
      clearInterval(activeForfeitPollRef.current);
    if (pollRef.current) clearInterval(pollRef.current);

    if (!inviteCode) {
      applyMatchResult(false);
      return;
    }

    try {
      const res = await authenticatedFetch(
        `/api/matches/invite/${inviteCode}/forfeit`,
        { method: "POST" },
      );
      const data = await res.json();
      if (res.ok) {
        const lpChange = data.forfeiter_lp_change;
        const newState = data.forfeiter_new_state;
        setLastLPChange(lpChange);
        setPlayerState({
          tierIdx: newState.tierIdx,
          divIdx: newState.divIdx,
          lp: newState.lp,
          demotionShield: newState.demotionShield,
        });
        setOpponentData((prev) => ({ ...prev, volume: 0 }));
        queryClient.invalidateQueries(["profile"]);
        await fetchLatestMatchId();
        setGameState("results");
      } else {
        applyMatchResult(false);
      }
    } catch {
      applyMatchResult(false);
    }
  };

  // ── Workout handlers ──
  const handleUpdateSet = (exId, setIdx, field, val) => {
    const next = workout.map((ex) =>
      ex.id !== exId
        ? ex
        : {
            ...ex,
            sets: ex.sets.map((s, i) =>
              i !== setIdx ? s : { ...s, [field]: val },
            ),
          },
    );
    setWorkout(next);

    const bodyweightKg = profileData?.profile?.bodyweight_kg;
    const heightCm = profileData?.profile?.height_cm;
    const wilksMult = getWilksMultiplier(bodyweightKg);
    const heightMult = getHeightMultiplier(heightCm) ?? 1.0;

    let rawTotal = 0;
    let adjustedTotal = 0;
    next.forEach((ex) => {
      // Use the exercise's equipment property directly (already normalized to lowercase)
      const equipMult = getEquipmentMultiplier(ex.equipment || "barbell");
      ex.sets.forEach((s) => {
        // Always convert to kg before volume calculation so scores are always comparable
        const weightKg =
          units === "lbs"
            ? (parseFloat(s.weight) || 0) * LBS_TO_KG
            : parseFloat(s.weight) || 0;
        const base = weightKg * (parseFloat(s.reps) || 0);
        rawTotal += base;
        adjustedTotal += base * equipMult * wilksMult * heightMult;
      });
    });
    setBaseVolume(rawTotal);
    setVolume(adjustedTotal);
  };

  const handleAddSet = (exId) =>
    setWorkout((w) =>
      w.map((ex) =>
        ex.id !== exId
          ? ex
          : {
              ...ex,
              sets: [
                ...ex.sets,
                {
                  weight: "",
                  reps: "",
                  equipment: ex.equipment || "barbell", // Auto-set equipment from exercise definition
                },
              ],
            },
      ),
    );

  // ════════════════════════════════════════
  // STATE — TROPHY ROAD
  // ════════════════════════════════════════
  const renderTrophyRoad = () => (
    <View style={{ flex: 1, backgroundColor: "#010308" }}>
      <ScrollView
        ref={scrollRef}
        showsVerticalScrollIndicator={false}
        contentContainerStyle={{
          paddingBottom: SCREEN_H * 0.6 + insets.bottom,
        }}
        scrollEventThrottle={16}
        onScroll={(event) => setScrollY(event.nativeEvent.contentOffset.y)}
      >
        <TrophyRoadCanvas
          currentNodeIdx={currentNodeIdx}
          currentTier={currentTier}
          playerLp={playerState.lp}
        />
      </ScrollView>

      {shouldShowDownToRank && (
        <TouchableOpacity
          activeOpacity={0.85}
          onPress={() =>
            scrollRef.current?.scrollTo({
              y: currentRankOffset,
              animated: true,
            })
          }
          style={{
            position: "absolute",
            right: 18,
            bottom: insets.bottom + 108,
            width: 46,
            height: 46,
            borderRadius: 23,
            backgroundColor: "#4BB8FA",
            justifyContent: "center",
            alignItems: "center",
            elevation: 8,
            zIndex: 50,
          }}
        >
          <Text style={{ color: "#000", fontSize: 25, fontWeight: "900" }}>
            ↓
          </Text>
        </TouchableOpacity>
      )}
      {shouldShowUpToRank && (
        <TouchableOpacity
          activeOpacity={0.85}
          onPress={() =>
            scrollRef.current?.scrollTo({
              y: currentRankOffset,
              animated: true,
            })
          }
          style={{
            position: "absolute",
            right: 18,
            top: insets.top + 92,
            width: 46,
            height: 46,
            borderRadius: 23,
            backgroundColor: "#4BB8FA",
            justifyContent: "center",
            alignItems: "center",
            elevation: 8,
            zIndex: 50,
          }}
        >
          <Text style={{ color: "#000", fontSize: 25, fontWeight: "900" }}>
            ↑
          </Text>
        </TouchableOpacity>
      )}

      <TrophyRoadHeader
        insets={insets}
        currentTier={currentTier}
        currentDivName={currentDivName}
        playerState={playerState}
        shieldTooltipVisible={shieldTooltipVisible}
        setShieldTooltipVisible={setShieldTooltipVisible}
        isLegendI={isLegendI}
        lpToNext={lpToNext}
        nextDivLabel={nextDivLabel}
      />

      <TrophyRoadButtons
        currentTier={currentTier}
        onFindMatchPress={() => {
          setSelectedMuscle(null);
          setMatchMode("matchmaking");
          setGameState("waiting");
        }}
        onChallengePress={() => {
          setSelectedMuscle(null);
          setMatchMode("challenge");
          setGameState("waiting");
        }}
        onJoinPress={() => setGameState("joining")}
      />
    </View>
  );

  // ════════════════════════════════════════
  // STATE — ACTIVE MATCH
  // ════════════════════════════════════════
  const renderActiveMatch = () => (
    <KeyboardAvoidingAnimatedView style={{ flex: 1 }} behavior="padding">
      <View style={{ flex: 1, backgroundColor: "#0D0D0D" }}>
        <MatchHeader
          insets={insets}
          matchTime={matchTime}
          selectedMuscle={selectedMuscle}
          currentTier={currentTier}
          onForfeit={handleForfeit}
        />
        <WorkoutLogger
          workout={workout}
          setWorkout={setWorkout}
          currentTier={currentTier}
          handleUpdateSet={handleUpdateSet}
          handleAddSet={handleAddSet}
          units={units}
        />
        <MatchFooter
          insets={insets}
          volume={volume}
          currentTier={currentTier}
          onSubmit={
            inviteCode ? handleSubmitVolume : () => applyMatchResult(true)
          }
          units={units}
        />
        {submitError && (
          <View
            style={{
              position: "absolute",
              bottom: 120,
              left: 20,
              right: 20,
              backgroundColor: "#1A0808",
              borderRadius: 12,
              padding: 12,
            }}
          >
            <Text
              style={{
                color: "#FF4444",
                textAlign: "center",
                fontWeight: "700",
              }}
            >
              {submitError}
            </Text>
          </View>
        )}
      </View>
    </KeyboardAvoidingAnimatedView>
  );

  // ════════════════════════════════════════
  // STATE — WAITING FOR RESULTS
  // ════════════════════════════════════════
  const renderWaitingForResults = () => (
    <View
      style={{
        flex: 1,
        backgroundColor: "#010308",
        justifyContent: "center",
        alignItems: "center",
        paddingHorizontal: 32,
      }}
    >
      <Swords
        color={currentTier.color}
        size={56}
        style={{ marginBottom: 24 }}
      />
      <Text
        style={{
          color: "#FFF",
          fontSize: 22,
          fontWeight: "900",
          textAlign: "center",
          marginBottom: 12,
        }}
      >
        WORKOUT SUBMITTED!
      </Text>
      <Text
        style={{
          color: "#555",
          fontSize: 16,
          textAlign: "center",
          marginBottom: 32,
        }}
      >
        Waiting for {opponentData?.name || "your opponent"} to finish their
        workout...
      </Text>
      <ActivityIndicator color={currentTier.color} size="large" />
      <Text
        style={{
          color: "#333",
          fontSize: 12,
          marginTop: 24,
          textAlign: "center",
        }}
      >
        Your score: {volumeToScore(volume || 0).toLocaleString()} pts
      </Text>
    </View>
  );

  // Remove the auth blocking - only check if auth system is ready
  if (!isReady) {
    return (
      <View
        style={{
          flex: 1,
          backgroundColor: "#010308",
          justifyContent: "center",
          alignItems: "center",
        }}
      >
        <ActivityIndicator color="#4BB8FA" size="large" />
      </View>
    );
  }

  // Guest state UI when not authenticated
  if (!auth) {
    return (
      <View style={{ flex: 1, backgroundColor: "#010308" }}>
        <View style={{ flex: 1 }}>
          <TrophyRoadHeader
            insets={insets}
            currentTier={{ name: "Unranked", color: "#666" }}
            currentDivName="Guest"
            playerState={{ lp: 0 }}
            shieldTooltipVisible={false}
            setShieldTooltipVisible={() => {}}
            isLegendI={false}
            lpToNext={100}
            nextDivLabel=""
          />

          <View
            style={{
              flex: 1,
              justifyContent: "center",
              alignItems: "center",
              paddingHorizontal: 32,
            }}
          >
            <Text
              style={{
                fontSize: 24,
                fontWeight: "700",
                color: "#fff",
                textAlign: "center",
                marginBottom: 8,
              }}
            >
              Welcome to Gym Clash
            </Text>
            <Text
              style={{
                fontSize: 16,
                color: "#888",
                textAlign: "center",
                marginBottom: 24,
              }}
            >
              Sign in to compete, track workouts, and climb the ranks
            </Text>
            <TouchableOpacity
              onPress={() => signIn()}
              style={{
                backgroundColor: "#4BB8FA",
                paddingHorizontal: 32,
                paddingVertical: 14,
                borderRadius: 12,
              }}
            >
              <Text style={{ fontSize: 16, fontWeight: "700", color: "#000" }}>
                SIGN IN
              </Text>
            </TouchableOpacity>
          </View>

          <TrophyRoadButtons
            currentTier={{ name: "Unranked", color: "#666" }}
            onFindMatchPress={() => signIn()}
            onChallengePress={() => signIn()}
            onJoinPress={() => signIn()}
          />
        </View>
      </View>
    );
  }

  // Data will be pre-loaded from cache, no need for separate loading screen
  // If profileData is still loading, render main UI with activity indicators in sections

  // ════════════════════════════════════════
  // ROOT RENDER
  // ════════════════════════════════════════
  return (
    <View style={{ flex: 1, backgroundColor: "#010206" }}>
      {gameState === "road" && renderTrophyRoad()}

      {gameState === "joining" && (
        <JoinMatchScreen
          insets={insets}
          currentTier={currentTier}
          playerState={playerState}
          onJoin={handleGuestJoin}
          onCancel={() => setGameState("road")}
        />
      )}

      {gameState === "waiting-for-opponent" && inviteCode && (
        <WaitingForOpponent
          insets={insets}
          inviteCode={inviteCode}
          muscleGroup={selectedMuscle}
          currentTier={currentTier}
          onCancel={cancelInvite}
        />
      )}

      {gameState === "searching-for-match" && (
        <SearchingForMatch
          insets={insets}
          muscleGroup={selectedMuscle}
          currentTier={currentTier}
          currentDivName={currentDivName}
          playerLp={playerState.lp}
          onCancel={cancelMatchmaking}
        />
      )}

      {gameState === "vs" && (
        <VSScreen
          currentTier={currentTier}
          currentDivName={currentDivName}
          selectedMuscle={selectedMuscle}
          countdown={countdown}
          opponentName={opponentData?.name}
          opponentTierIdx={opponentData?.tierIdx ?? 0}
          opponentDivIdx={opponentData?.divIdx ?? 0}
          userPhotoUrl={profileData?.profile?.profile_photo_url}
          opponentPhotoUrl={opponentData?.profilePhotoUrl}
        />
      )}

      {gameState === "active" && renderActiveMatch()}

      {gameState === "waiting-for-results" && renderWaitingForResults()}

      {gameState === "results" && (
        <ResultsScreen
          insets={insets}
          lastLPChange={lastLPChange}
          volume={volume}
          opponentVolume={opponentData?.volume}
          opponentName={opponentData?.name}
          opponentForfeited={opponentData?.forfeited}
          currentTier={currentTier}
          currentDivName={currentDivName}
          playerState={playerState}
          isLegendI={isLegendI}
          matchId={completedMatchId}
          userPhotoUrl={profileData?.profile?.profile_photo_url}
          opponentTierIdx={opponentData?.tierIdx ?? 0}
          onBackToRoad={() => {
            setGameState("road");
            setInviteCode(null);
            setOpponentData(null);
            setMatchRole(null);
            setResolvedMatch(null);
            setCompletedMatchId(null);
          }}
        />
      )}

      <MuscleSelectorModal
        visible={gameState === "waiting"}
        insets={insets}
        selectedMuscle={selectedMuscle}
        setSelectedMuscle={setSelectedMuscle}
        currentTier={currentTier}
        onSharePress={createInviteAndWait}
        onFindMatchPress={findMatchAndWait}
        onJoinPress={() => {
          setGameState("joining");
        }}
        onCancel={() => {
          setGameState("road");
          setExerciseConfigError(null);
        }}
        loading={createInviteLoading}
        errorMessage={exerciseConfigError}
        mode={matchMode}
      />

      <PromotionCeremony
        visible={showPromotion}
        tierIdx={promotedTo.tierIdx}
        divIdx={promotedTo.divIdx}
        onContinue={() => {
          setShowPromotion(false);
          setGameState("road");
        }}
      />
    </View>
  );
}
