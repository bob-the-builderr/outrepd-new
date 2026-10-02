# رفع الأب على App Store

الخطوات بالترتيب، والكلام اللي بيتلصق جاهز في المربعات. الصور جاهزة في
`Desktop\app-store-upload` (٩ صور، 1320×2868، من غير شفافية).

---

## ١. حساب المراجعة (Supabase)

المراجع بتاع Apple مايقدرش يستلم كود على إيميل. فيه إيميل واحد الأب مابيبعتلوش
كود: `appreview@outrepd.com`، والكود بتاعه هو الباسورد بتاع الحساب.

1. Supabase ← **Authentication** ← **Users** ← **Add user** ← **Create new user**.
2. Email: `appreview@outrepd.com`
3. Password: **٦ أرقام** إنت تختارهم (أرقام بس، عشان خانات الكود مابتقبلش غير أرقام).
4. علّم على **Auto Confirm User** ← **Create user**.
5. جرّبه من TestFlight: أول شاشة ← **I already have an account** ←
   `appreview@outrepd.com` ← **Send code** ← اكتب الـ٦ أرقام.

بعد ما الأب يتقبل، تقدر تقفل الحساب ده من نفس الصفحة (**Ban user**) لحد المراجعة الجاية.

---

## ٢. صفحة النسخة (iOS App ← 1.0)

### Screenshots
App Store Connect بيطلب مقاس حسب الخانة:
- **iPhone 6.5"**: ‏1284×2778 ← `Desktop\app-store-1284x2778` (فيه `marketing` و `app`)
- **iPhone 6.9"**: ‏1320×2868 ← `Desktop\app-store-marketing` و `Desktop\app-store-upload`

لحد ١٠ صور: الـ٤ بتوع `marketing` الأول، وبعدهم صور من الأب.

### Promotional Text
```
Race real people live, rep by rep. Your camera counts every push-up on your phone, and no video ever leaves it.
```

### Description
نسخة App Store: مفيهاش أي ذكر لـ Google Play (Apple بترفض لو اتذكر متجر تاني).
```
One minute. One opponent. Every push-up counts.

outrepd turns push-ups into a duel. Prop your phone up, get into position, and go for 60 seconds while the camera counts your reps. Your opponent is a real person, and the one who does more wins.

COUNTED BY THE CAMERA, ON YOUR PHONE
Pose detection runs on your device. It watches how low you go and how far you come back up, so a half rep does not count. No video leaves your phone, ever.

RACE REAL PEOPLE, LIVE
A ranked match looks for somebody on camera at the same moment as you. You both get ten seconds to get down, start together, and watch each other's count move as you lift. If nobody near your rank is live within fifteen seconds, you race a real person's recorded set instead, at the pace they actually did it. No bots, no made-up numbers.

CLIMB THE RANKS
Five placement matches set your starting rank. From there, win to climb from Iron through Bronze, Silver, Gold, Platinum and Diamond to Master. Once you reach a tier, you keep it: a bad day can cost divisions, never the tier itself.

CHALLENGE YOUR FRIENDS
Add friends with a friend code, see who is online, and go live together right now, or send a set they can race whenever they are ready. Your record against each friend is kept, so there is always something to settle.

EARN TITLES
46 titles for matches, wins, streaks, clean sets, early mornings, late nights and more. Wear the one you are proudest of and it shows beside your name.

SHARE YOUR WINS
After a duel, share a card with your count, who you beat and the LP it earned. Or make one with your rank and stats and post it anywhere.

YOUR DATA IS YOURS
Download everything the app holds about you, or delete your account and all of it from inside the app.

Available in English, German, Spanish, French, Hindi, Indonesian, Italian, Japanese, Korean, Portuguese, Russian, Turkish and Chinese.

SUBSCRIPTION
outrepd needs a subscription: weekly or yearly. New subscribers get the first 3 days free; payment is charged to your Apple account when the free trial ends. The subscription renews automatically at the end of each period unless you cancel at least 24 hours before, and you can cancel anytime in your Apple account settings.
Terms of Use: https://www.outrepd.com/terms
Privacy Policy: https://www.outrepd.com/privacy

For ages 16 and up.
```

### Keywords
```
pushup,push up,counter,workout,fitness,challenge,duel,rank,friends,rep counter,calisthenics,home
```

### Support URL
```
https://www.outrepd.com/privacy
```
(فيها إيميل الدعم `support@outrepd.com`. مفيش صفحة `/support` على الموقع.)

### Marketing URL (اختياري)
```
https://www.outrepd.com
```

### Version / Copyright
- Version: `1.0`
- Copyright: `2026 Mokhtar Yasser`

### Build
**Add Build** ← اختار أحدث build (134 أو أعلى).

### In-App Purchases and Subscriptions
اختار الاتنين: الأسبوعي (`com.outrepd.outrepd.pro.weekly`) والسنوي
(`com.outrepd.outrepd.pro.yearly`). أول اشتراك
لازم يتبعت مع نسخة من الأب، وده المكان.

### App Review Information
- **Sign-in required:** ✓
- **User name:** `appreview@outrepd.com`
- **Password:** الـ٦ أرقام بتوعك
- Contact: اسمك وتليفونك وإيميلك
- **Notes:**
```
Signing in: on the first screen tap "I already have an account", enter appreview@outrepd.com, tap "Send code", and type the six-digit password above into the code boxes. This review account is never sent an email; every other account signs in with a one-time code sent to its email.

The app is behind an auto-renewable subscription (weekly or yearly, with a 3-day free trial for new subscribers). After signing in, the paywall appears; purchases work in the sandbox. Restore, Terms, Privacy and account deletion (the "Account" link on the paywall, or Settings > Data > Delete account) are all reachable without paying.

Push-ups are counted with the front camera using on-device pose detection (Google ML Kit). No video or image leaves the device. To try a duel, stand the phone on the floor about one metre in front of you, facing you, and get into a push-up position so your shoulders and hands are in view.

New accounts start from "Get started": a short onboarding with a three push-up calibration on the camera, then sign-up with an email and a one-time code.
```

### Version Release
**Manually release this version** (عشان تختار إمتى ينزل بعد القبول).

---

## ٣. App Information

- Category: **Health & Fitness**، والتاني **Sports**
- Content Rights: **No, it does not contain, show, or access third-party content**
- **Age Rating:** جاوب كل الأسئلة بـ None/No، ما عدا إن المستخدمين بيتفاعلوا مع
  بعض (أسماء وصور بروفايل، من غير شات). لو ظهرلك اختيار إنك ترفع التقييم، خليه
  **16+**، لأن الأب نفسه بيرفض أي حد أقل من ١٦.

---

## ٤. App Privacy

- Privacy Policy URL: `https://www.outrepd.com/privacy`
- الإجابات كلها في `docs/store/data-safety.md`، تحت **App Store: App privacy**.
  - Tracking: **No**
  - Linked to the user (App Functionality): Email Address، User ID، Fitness،
    Photos or Videos، Other User Content، Product Interaction، Purchase History،
    Device ID
  - Not linked (App Functionality): Crash Data، Other Diagnostic Data

---

## ٥. Pricing and Availability

- Price: **Free** (الفلوس من الاشتراك)
- Availability: كل الدول

---

## ٦. الإرسال

صفحة النسخة ← **Add for Review** ← **Submit to App Review**.
