# الرد على App Review (2.1 Information Needed)

Apple طالب ٧ حاجات. الأولى فيديو إنت اللي هتسجله من الآيفون، والباقي مكتوب
تحت بالإنجليزي جاهز يتلصق.

---

## ١. الفيديو (إنت اللي تسجله)

**قبل ما تبدأ:**
- الآيفون على **آخر iOS** (Settings ← General ← Software Update).
- App Store Connect ← Users and Access ← Sandbox ← حساب التيستر ← **Clear Purchase History**.
- امسح الأب من الآيفون ونزّله تاني من TestFlight (build 134).
- حط زرار **Screen Recording** في Control Center لو مش موجود
  (Settings ← Control Center).

**سجّل الكل في فيديو واحد، بالترتيب ده** (حوالي ٤–٦ دقايق، عادي):

1. ابدأ التسجيل من Control Center، وبعدين **افتح الأب** (لازم الفيديو يبدأ بفتح الأب).
2. **Get started** ← عدّي شاشات الشرح ← سؤال السن **16 or over** ← علّم على
   الموافقة ← **Allow camera**.
3. حط الموبايل على الأرض وعدّي خطوة الكادر، واعمل **٣ ضغطات** المعايرة.
4. **Find my first opponent** ← **Sign up with email** ← اكتب يوزرنيم وإيميل
   حقيقي ← هات الكود من الإيميل واكتبه. (ده **إنشاء الحساب**.)
5. **شاشة الاشتراك**: وقف عليها ثانيتين عشان الأسعار والمدة تبان، ودوس على
   **Terms** و **Privacy** (كل واحد يفتح ويرجع).
6. اختار خطة ← **Start my 3-day free trial** ← أكّد الشراء بحساب Sandbox.
7. جوه الأب: افتح **Match** وابدأ **Practice** ثواني، وبعدين **Ranks**.
8. **البلاغ والبلوك**: من Ranks افتح بروفايل أي حد ← **⋮** فوق ←
   **Report** (وريّ الأسباب، وابعته أو اقفله) ← **⋮** تاني ← **Block** ← أكّد.
9. **Profile** ← ⚙️ ← **Sign out** ← أكّد.
10. **تسجيل الدخول**: **I already have an account** ← نفس الإيميل ← الكود من
    الإيميل ← تدخل.
11. **مسح الحساب**: Profile ← ⚙️ ← **Delete account** ← أكّد ← يرجع لأول شاشة.
12. وقّف التسجيل.

**الفيديو بيتحفظ في Photos.** ارفعه على **Google Drive** وخلي الشير
**Anyone with the link** (أو YouTube **Unlisted**)، وخد اللينك. اللينك ده
بيتحط مكان `[VIDEO LINK]` تحت في الاتنين.

---

## ٢. الرد في App Store Connect

App Review ← الرسالة ← **Reply**. الصق ده (وغيّر `[VIDEO LINK]`):

```
Hello, and thank you for reviewing OUTREPD. Here is the information you asked for.

1. SCREEN RECORDINGS
Recorded on a physical iPhone running the latest iOS. Each recording begins with launching the app.
- Recording 1: [DRIVE LINK 1]
  The app's main features, switching to another account (signing out and signing back in), playing a match, and deleting the account.
- Recording 2: [DRIVE LINK 2]
  Registering a new account after that deletion: the onboarding with its camera calibration, sign-up with an email code, and the subscription screen, then playing another match.
- Recording 3 (attached to this message): reporting and blocking another user from their profile.

2. PURPOSE AND AUDIENCE
OUTREPD is a competitive push-up app for people aged 16 and over who train with their own body weight. Training alone is hard to keep up and easy to cheat on, so OUTREPD makes every set a 60-second duel against a real person. The front camera counts each push-up on the device, only full-depth reps score, and results move the user up a seven-tier ranked ladder (Iron to Master). Users can also add and challenge friends, earn titles and see their history.

3. HOW TO ACCESS THE APP
Review account (no subscription, so the paywall appears after sign-in): on the first screen tap "I already have an account", enter appreview@outrepd.com, tap "Send code", and type the six-digit password from App Review Information into the code boxes. This account is never sent an email; every other account signs in with a one-time code sent to its email.
New account: "Get started", the onboarding (16+ age check, health notice, camera permission, phone placement, a three push-up calibration), then "Find my first opponent", "Sign up with email", and the code from that email.
Features: Match tab (Find a match: ranked, 60 seconds, a live opponent or a real person's recorded set; Challenge a friend; Practice). Stand the phone on the floor about one metre in front of you, facing you. Friends tab (search, friend codes, challenges), Ranks tab (global, country and friends leaderboards), Profile tab (titles, history; the gear icon opens Settings).
User-generated content is limited to usernames and profile photos. Report (with reasons, reviewed within 24 hours) and Block are in the top-right menu of any other user's profile; Settings also has "Report a problem" and "Blocked accounts". Usernames are filtered on the server.
Account deletion: Profile > gear > Delete account, also reachable from the paywall's "Account" link without subscribing.
No sample files are needed.

4. EXTERNAL SERVICES
- Supabase: sign-in with email codes, database, profile photo storage, Realtime for live matches, server functions.
- Apple In-App Purchase: payment processor.
- RevenueCat: subscription management.
- Google ML Kit Pose Detection: counts push-ups on the device; no images or video leave the phone.
- Firebase Cloud Messaging (via APNs) and Firebase Crashlytics: push notifications and crash reports.
- Resend: emails users the data export they request.
No generative AI services are used.

5. REGIONAL DIFFERENCES
The app works the same in every region: 13 interface languages, prices in local currency from the App Store, and a country leaderboard based on the device's region. No feature or content differs by region.

6. REGULATED INDUSTRY OR THIRD-PARTY MATERIAL
Not applicable. OUTREPD is not a medical device, gives no medical or training advice, and contains no protected third-party material.

7. IN-APP PURCHASES
One auto-renewable subscription group, "OUTREPD Pro", that unlocks the whole app:
- Pro Weekly: 1 week, $4.99 (US)
- Pro Yearly: 1 year, $39.99 (US)
Each has a 3-day free trial for eligible new subscribers. The subscription screen appears by itself after signing up or signing in without an active subscription, and shows each plan's name, length and price, the price after the trial, Restore, and the Terms of Use and Privacy Policy links. Subscriptions are managed in Settings > Apple Account > Subscriptions.

Thank you.
```

---

## ٣. خانة Notes في App Review Information

App Review Information ← **Notes**: امسح اللي فيها والصق ده (أقل من ٤٠٠٠ حرف،
وده الحد بتاعها). وغيّر `[VIDEO LINK]`.

```
SCREEN RECORDINGS: [DRIVE LINK 1] (main features, switching accounts, a match, account deletion); [DRIVE LINK 2] (registration after deletion, calibration, subscription screen, a match); [DRIVE LINK 3] (reporting and blocking a user).

PURPOSE: OUTREPD is a competitive push-up app for people aged 16+. The front camera counts push-ups on the device (only full-depth reps score), and each 60-second set is a duel against a real person that moves the user up a seven-tier ranked ladder. Friends, challenges, titles and history.

SIGN-IN: On the first screen tap "I already have an account", enter appreview@outrepd.com, tap "Send code", and type the six-digit password above into the code boxes. This account is never sent an email; all other accounts sign in with a one-time code sent to their email. New accounts: "Get started", onboarding (16+ age check, camera permission, three push-up calibration), then sign-up with email and a code.

FEATURES: Match tab (Find a match, Challenge a friend, Practice; stand the phone on the floor about 1 m in front of you, facing you). Friends tab, Ranks tab (leaderboards), Profile tab (gear icon = Settings).

USER CONTENT: usernames and profile photos only. Report and Block are in the top-right menu of any other user's profile; Settings has "Report a problem" and "Blocked accounts". Usernames are filtered on the server.

ACCOUNT DELETION: Profile > gear > Delete account, or the paywall's "Account" link.

IN-APP PURCHASES: subscription group "OUTREPD Pro": Pro Weekly (1 week, $4.99) and Pro Yearly (1 year, $39.99), each with a 3-day free trial for eligible new subscribers; unlocks the whole app. The paywall appears after sign-up or sign-in for any account without a subscription, with plan names, lengths, prices, Restore, Terms of Use and Privacy Policy.

SERVICES: Supabase (auth with email codes, database, storage, realtime), Apple In-App Purchase, RevenueCat (subscriptions), Google ML Kit Pose Detection (on-device only; no images leave the phone), Firebase Cloud Messaging and Crashlytics, Resend (data export emails). No generative AI.

REGIONS: identical in every region; 13 languages; local currency prices.

REGULATED / THIRD-PARTY MATERIAL: not applicable. Not a medical device; no medical or training advice.
```

اضغط **Save** فوق.
