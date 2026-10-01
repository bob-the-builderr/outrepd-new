# بيانات المتجر

الكلام اللي يتلصق في Google Play Console و App Store Connect. كل حاجة هنا
مكتوبة من اللي الأب بيعمله فعلًا، ومفيش ميزة مذكورة مش موجودة. عدد الحروف
جنب كل خانة هو الحد بتاع المتجر.

الإنجليزي هو اللغة الوحيدة في المتجرين. الأب مابقاش فيه عربي (اتشال ٢٩ سبتمبر ٢٠٢٦).

---

## الحاجات الثابتة

| الخانة | القيمة |
|---|---|
| التصنيف | Health & Fitness |
| التصنيف التاني (App Store) | Sports |
| السعر | التحميل مجاني، والاستخدام باشتراك |
| إعلانات | لأ |
| مشتريات جوه الأب | أيوه — اشتراك: أسبوعي ٤٫٩٩$، سنوي ٣٩٫٩٩$. الأب كله ورا الاشتراك |
| السن | الأب نفسه بيرفض أي حد أقل من ١٦ سنة في أول شاشة |
| الموقع | https://outrepd.com |
| سياسة الخصوصية | https://www.outrepd.com/privacy |
| الشروط | https://www.outrepd.com/terms |

---

## Google Play

### App name (30)

```
outrepd: Push-Up Duels
```

### Short description (80)

English:
```
Race real people in 60-second push-up duels. Your camera counts every rep.
```

### Full description (4000)

English:
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
outrepd needs a subscription: weekly or yearly. Payment is charged to your Google Play or Apple account. It renews automatically at the end of each period unless you cancel at least 24 hours before, and you can cancel anytime in your store account settings.
Terms: https://www.outrepd.com/terms
Privacy: https://www.outrepd.com/privacy

For ages 16 and up.
```

---

## App Store

### Name (30)

```
outrepd: Push-Up Duels
```

### Subtitle (30)

English:
```
Camera-counted push-up duels
```

### Promotional text (170)

English:
```
Race real people live, rep by rep. Your camera counts every push-up on your phone, and no video ever leaves it.
```

### Description (4000)

نفس الوصف الطويل بتاع Google Play فوق، بالإنجليزي. Apple بيطلب إن فقرة SUBSCRIPTION ولينكات الشروط والخصوصية تفضل فيه.

### Keywords (100، مفصولة بفاصلة من غير مسافات)

English:
```
pushup,push up,counter,workout,fitness,challenge,duel,rank,friends,rep counter,calisthenics,home
```

### What's New (أول نسخة)

English:
```
The first release of outrepd.
```

---

## الصور

الصور اللي في `outrepd-store-screenshots.zip` جاهزة بالمقاسات:
- Google Play: ‏1080×1920
- App Store: ‏1320×2868 (آيفون ٦.٩ بوصة، وده المقاس الوحيد المطلوب لآيفون)

الأب iPhone بس، فمفيش صور iPad مطلوبة.

أول صورة هي `00-live-match.png`: الماتش اللايف والعداد شغال. بتترسم من الأب
نفسه على CI (`tool/screenshots/live_match_test.dart`).

Google Play كمان بيطلب **Feature graphic** مقاس 1024×500، وهي جاهزة في `docs/store/feature-graphic.png` (PNG من غير شفافية).
