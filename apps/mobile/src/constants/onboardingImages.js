/**
 * All onboarding images, bundled into the app.
 *
 * These used to be remote CloudFront URLs, which meant the splash screen had
 * to wait on a network download before onboarding could render. They are now
 * local assets packaged with the binary, so they display instantly and work
 * offline. No prefetching is required.
 *
 * Each value is a Metro asset reference — pass it straight to an <Image>
 * `source` prop (`source={ONBOARDING_IMAGES.logo}`), NOT wrapped in `{ uri }`.
 *
 * To update an image, replace the file in assets/images/onboarding/.
 */

export const ONBOARDING_IMAGES = {
  logo: require("../../assets/images/onboarding/logo.png"),
  workoutBattle: require("../../assets/images/onboarding/workout-battle.png"),
  challengeFriends: require("../../assets/images/onboarding/challenge-friends.png"),
  bronze: require("../../assets/images/onboarding/bronze.png"),
  silver: require("../../assets/images/onboarding/silver.png"),
  gold: require("../../assets/images/onboarding/gold.png"),
  master: require("../../assets/images/onboarding/master.png"),
  legend: require("../../assets/images/onboarding/legend.png"),
  mountain: require("../../assets/images/onboarding/mountain.png"),
  effortAlone: require("../../assets/images/onboarding/effort-alone.png"),
  trainingAlone: require("../../assets/images/onboarding/training-alone.png"),
};

// Kept for backwards compatibility. Bundled assets need no prefetching, so
// this is now an empty list and callers can drop their prefetch step.
export const ALL_ONBOARDING_URLS = [];
