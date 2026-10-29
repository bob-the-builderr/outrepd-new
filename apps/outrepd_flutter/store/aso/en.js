// The en-US source, and the English storefronts that share it. The name is
// the original, brand first, in every locale (the keyword-led "Push Up
// Challenge: OUTREPD" was tried and taken back, 2026-10-24); the subtitle
// carries "rep counter", "1v1" and "battles".
const description = `One minute. One opponent. Every push-up counts.

OUTREPD turns push-ups into a live 1v1 challenge. Prop your phone up, get into position, and go for 60 seconds while the camera counts your reps. Your opponent is a real person, and whoever does more wins.

COUNTED BY THE CAMERA, ON YOUR PHONE
Pose detection runs on your device. Two lines on the bar show how low to go and how high to come back, so a half rep never counts. No video leaves your phone, ever.

RACE REAL PEOPLE, LIVE
A ranked match finds somebody on camera at the same moment as you. Start together and watch each other's count move as you lift. If nobody near your rank is live within fifteen seconds, you race a real person's recorded set, at the pace they actually did it. No bots, no made-up numbers.

CLIMB THE RANKS
Your first match puts you on the ladder at Iron V. Then climb from Iron through Bronze, Silver, Gold, Platinum and Diamond to Master. Beat a higher rank and you earn more LP. Once you reach a tier, you keep it.

LEVEL UP WITH EVERY REP
Every push-up earns XP, and every win 20 more; a lost match earns nothing. Your level shows beside your name everywhere, and it never goes down.

WEEKLY AND MONTHLY RACES
A new board every Monday, and a monthly race with awards for the top ten.

CHALLENGE YOUR FRIENDS
Add friends with a friend code, see who is online, and challenge them to a live duel. Your record against each friend is kept, so there is always something to settle.

TRACK YOUR PROGRESS
Your last ten results at a glance, every match by day, your best set, your streak, and 46 titles to earn.

YOUR DATA IS YOURS
Download everything the app holds about you, or delete your account and all of it from inside the app.

Available in English, German, Spanish, French, Hindi, Indonesian, Italian, Japanese, Korean, Portuguese, Russian, Turkish and Chinese.

SUBSCRIPTION
OUTREPD needs a subscription, weekly or yearly. It renews automatically unless you cancel at least 24 hours before the end of the period; manage or cancel it anytime in your Apple account settings.
Terms of Use: https://www.outrepd.com/terms
Privacy Policy: https://www.outrepd.com/privacy`;

const promo =
  'Two people. 60 seconds. One winner. Your camera counts every push-up. New: level up with every rep, and a weekly race that starts fresh each Monday.';

const base = {
  name: 'OUTREPD: Push-up Battles',
  subtitle: 'Rep Counter & Live 1v1 Battles',
  keywords: 'pushups,tracker,duel,ai,camera,workout,game,fitness,daily,100,streak,compete,ranked,strength,level',
  promo,
  description,
};

module.exports = {
  'en-US': base,
  // The UK types "press up" as often as "push up": "press" makes "press up
  // challenge" and "press up counter" with the name and subtitle.
  'en-GB': {
    ...base,
    keywords: 'press,pushups,tracker,duel,ai,camera,workout,game,fitness,daily,100,streak,compete,ranked,strength',
  },
  'en-AU': base,
  'en-CA': base,
};
