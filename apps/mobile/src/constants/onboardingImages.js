/**
 * All onboarding image URLs in one place.
 *
 * These are static assets hosted on CloudFront (not user-generated uploads).
 * They are prefetched into expo-image's disk cache during the splash screen
 * so every image is ready the moment the user reaches the onboarding flow.
 *
 * To update an image, replace the CloudFront URL here — all screens pick it up automatically.
 */

export const ONBOARDING_IMAGES = {
  logo: "https://dtvoeevhaseb5.cloudfront.net/user-uploads/b5e288ee-380e-4304-baca-7a0dd94bf717.png",
  workoutBattle:
    "https://dtvoeevhaseb5.cloudfront.net/user-uploads/8be797bc-f79a-45be-a3f8-ef992a4699e6.png",
  challengeFriends:
    "https://dtvoeevhaseb5.cloudfront.net/user-uploads/5ef7e1eb-aa33-475c-a27f-fd27a72bf313.png",
  bronze:
    "https://dtvoeevhaseb5.cloudfront.net/user-uploads/df62f95b-bf25-46e6-922e-d95c92677567.png",
  silver:
    "https://dtvoeevhaseb5.cloudfront.net/user-uploads/27715453-62b5-4cfd-99b8-9c25fa27685b.png",
  gold: "https://dtvoeevhaseb5.cloudfront.net/user-uploads/b7e694cc-0578-41f4-aa15-43dc9c045e4c.png",
  master:
    "https://dtvoeevhaseb5.cloudfront.net/user-uploads/eaed0e30-4166-4c0b-a7ac-eed0747ec8b2.png",
  legend:
    "https://dtvoeevhaseb5.cloudfront.net/user-uploads/ccbcc6ce-15da-4be0-9146-5d4e69a888b5.png",
  mountain:
    "https://dtvoeevhaseb5.cloudfront.net/user-uploads/cd899a18-04da-4b28-83ff-4bda2d7deeda.png",
  effortAlone:
    "https://dtvoeevhaseb5.cloudfront.net/user-uploads/61e563da-3ace-4c1d-a9ee-8e84b77d4319.png",
  trainingAlone:
    "https://dtvoeevhaseb5.cloudfront.net/user-uploads/5ba66272-4c58-4b29-98ec-079c3397b4bc.png",
};

// Every URL that must be downloaded before the splash screen hides.
// Includes both the public onboarding slides and the user-onboarding steps.
export const ALL_ONBOARDING_URLS = Object.values(ONBOARDING_IMAGES);
