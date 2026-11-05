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
Thank you for reviewing OUTREPD. Here is the information requested.

1. SCREEN RECORDINGS
Recorded on a physical iPhone running the latest iOS. Each recording begins with launching the app.
- Recording 1: [DRIVE LINK 1]
  The app's main features, switching to another account, playing a match, and deleting the account.
- Recording 2: [DRIVE LINK 2]
  Registering a new account after that deletion: the onboarding with its camera calibration, sign-up with an email code, and the subscription screen, then playing another match.
- Recording 3 (attached to this message): reporting and blocking another user from their profile.

2. PURPOSE AND AUDIENCE
OUTREPD is a competitive push-up app for people aged 16 and over who train with their own body weight. Training alone is hard to keep up and easy to cheat on, so OUTREPD makes every set a 60-second duel against a real person. The front camera counts each push-up on the device, only full-depth reps score, and results move the user up a seven-tier ranked ladder (Iron to Master). Plus friends, challenges, titles and history.

3. HOW TO ACCESS THE APP
Review account (no subscription, so the paywall appears after sign-in): on the first screen tap "I already have an account", enter appreview@outrepd.com, tap "Send code", and type the six-digit password from App Review Information into the code boxes. This account is never sent an email; every other account signs in with a one-time code sent to its email.
New account: "Get started", the onboarding (16+ age check, health notice, camera permission, phone placement, a three push-up calibration), then "Find my first opponent", "Sign up with email", and the code from that email.
Features: Match tab (Find a match: ranked, 60 seconds, a live opponent or a real person's recorded set; Challenge a friend; Practice). Stand the phone on the floor about one metre in front of you, facing you. Friends tab (search, friend codes, challenges), Ranks tab (global, country and friends leaderboards), Profile tab (titles, history; the gear icon opens Settings).
User-generated content is limited to usernames and profile photos. Report (with reasons, reviewed within 24 hours) and Block are in the top-right menu of any other user's profile; Settings also has "Report a problem" and "Blocked accounts".
Account deletion: Profile > gear > Delete account, also reachable from the paywall's "Account" link without subscribing.

4. EXTERNAL SERVICES
- Supabase: sign-in with email codes, database, profile photo storage, Realtime for live matches, server functions.
- Apple In-App Purchase: payment processor.
- RevenueCat: subscription management.
- Google ML Kit Pose Detection: counts push-ups on the device; no images or video leave the phone.
- Firebase Cloud Messaging (via APNs) and Firebase Crashlytics: push notifications and crash reports.
- Resend: emails users the data export they request.
No generative AI services are used.

5. REGIONAL DIFFERENCES
The app works the same in every region (13 interface languages; prices in local currency). No feature or content differs by region.

6. REGULATED INDUSTRY OR THIRD-PARTY MATERIAL
Not applicable. OUTREPD is not a medical device, gives no medical or training advice, and contains no protected third-party material.

7. IN-APP PURCHASES
One auto-renewable subscription group, "OUTREPD Pro", that unlocks the whole app:
- Pro Weekly: 1 week, $4.99 (US)
- Pro Yearly: 1 year, $29.99 (US)
Each has a 3-day free trial for eligible new subscribers. The subscription screen appears by itself after signing up or signing in without an active subscription, and shows each plan's name, length and price, the price after the trial, Restore, and the Terms of Use and Privacy Policy links. Subscriptions are managed in Settings > Apple Account > Subscriptions.

Thank you.
```

---

## ٣. خانة Notes في App Review Information

App Review Information ← **Notes** (1.1.6، 2026-11-05): امسح اللي فيها والصق ده. **شيل علامة Sign-in required**: مفيش دخول بإيميل في الأبلكيشن، فالمراجع بيدخل بـ Sign in with Apple (أكاونت appreview@ لسه في الكود بس مالوش زرار).

```
PURPOSE: OUTREPD is a competitive push-up app for people aged 16+. The front camera counts push-ups on the device: only full-depth reps with the hands on the floor score. A ranked match is a live 60-second duel against a real person; if nobody near the user's rank is live within 15 seconds, the match is against a real person's recorded set, at the pace they did it. Results move the account on a seven-tier rated ladder. Also: Adventure (140 fights against monsters, works offline), friends and friend challenges, weekly and monthly boards, titles and history.

SIGN-IN: Sign in with Apple or Google. There is no email or password sign-in, so no demo account is needed: tap "Get started" (16+ age check, camera permission, a three push-up calibration), then Sign in with Apple creates the account and asks for a username. A returning user taps "I already have an account" on the first screen.

TRYING A MATCH: stand the phone on the floor about one metre in front of you, facing you, and get into a push-up position with your head, shoulders and hands in view. Match tab > Find a match (live ranked), or Adventure.

ADS AND IN-APP PURCHASES: every mode can be played without paying. An interstitial ad plays when the user leaves the result of a game (Unity LevelPlay, with Google AdMob as fallback); App Tracking Transparency is asked first, after a short explanation screen. Subscription group "OUTREPD Pro": Pro Weekly and Pro Yearly, with no free trial. Pro removes the ads and unlocks extra looks for the user's avatar (hair, faces, outfits, characters) and moving profile covers. The Pro screen is offered once at sign-up ("Not now" closes it), from the PRO button beside the bell, and after every fifth game; it shows plan names, lengths, prices, Restore, Terms of Use and Privacy Policy.

USER CONTENT: usernames, profile photos, avatars and Pro profile cover photos. Report and Block are in the menu of any other user's profile; Settings has "Report a problem" and "Blocked accounts". Usernames are filtered on the server.

ACCOUNT DELETION: Profile > gear icon > Delete account.

SERVICES: Supabase (sign-in, database, storage, realtime), Apple In-App Purchase through RevenueCat, Google ML Kit Pose Detection (on the device; no video or image leaves the phone), Apple Health (optional: finished sets are saved as workouts when the user allows it), Firebase Cloud Messaging and Crashlytics, Unity LevelPlay and Google AdMob (ads), Resend (emails for data exports). No generative AI.

REGIONS: the same app in every region; 13 languages; prices in local currency.

Not a medical device; no medical or training advice.
```

اضغط **Save** فوق.
