# رفع الأب على Google Play

بالترتيب. الحاجات اللي محتاجة Play Console كلها مستنية **تأكيد الهوية** يخلص.
الكلام اللي بيتلصق جاهز في المربعات.

**الصور** في `Desktop\google-play-marketing`:
- `icon-512.png`: أيقونة الأب ٥١٢×٥١٢
- `feature-graphic-1024x500.png`: الصورة العريضة اللي فوق الصفحة
- `01` لـ `04`: الصور الدعائية ١٠٨٠×٢١٦٠ (Play مابيقبلش صورة طولها أكتر من
  ضعف عرضها، فالجناب اتوسعت شوية بنفس الخلفية)

وصور الأب نفسه في `Desktop\google-play-1080x1920\english`.

---

## ١. قبل أي حاجة: ١٢ شخص

الحساب شخصي، فـ Google بيطلب **Closed testing فيه ١٢ شخص على الأقل، مشتركين
١٤ يوم ورا بعض**، قبل ما يسمحلك تنزّل للكل. لمّ **إيميلات Gmail لـ١٢ صاحب أو
أكتر** (خلّيهم ١٥ عشان لو حد خرج). كل واحد هيدوس على لينك، ويوافق، وينزّل الأب
من Play، **ومايمسحوش** طول الـ١٤ يوم.

---

## ٢. إنشاء الأب (Play Console ← Create app)

- App name: `OUTREPD: Push-Up Duels`
- Default language: **English (United States)**
- App or game: **App**
- Free or paid: **Free** (الفلوس من الاشتراك جوه الأب)
- علّم على الإقرارات ← **Create app**

---

## ٣. Store listing (Grow ← Store presence ← Main store listing)

**App name**
```
OUTREPD: Push-Up Duels
```

**Short description**
```
Race real people in 60-second push-up duels. Your camera counts every rep.
```

**Full description**: نفس وصف App Store في `app-store-submit.md`، بس فقرة
SUBSCRIPTION دي مكان اللي هناك:
```
SUBSCRIPTION
outrepd needs a subscription: weekly or yearly. New subscribers get the first 3 days free; payment is charged to your Google Play account when the free trial ends. The subscription renews automatically at the end of each period unless you cancel, and you can cancel anytime in Google Play > Payments & subscriptions.
Terms of Use: https://www.outrepd.com/terms
Privacy Policy: https://www.outrepd.com/privacy
```

**Graphics**
- App icon: `icon-512.png`
- Feature graphic: `feature-graphic-1024x500.png`
- Phone screenshots (لحد ٨): الـ٤ الدعائية الأول، وبعدهم ٤ من صور الأب
  (`07-won`، `08-awards`، `05-profile`، `02-ranks`)

**Store settings** (Grow ← Store presence ← Store settings)
- Category: **Health & Fitness**
- Email: `support@outrepd.com`
- Website: `https://www.outrepd.com`

---

## ٤. App content (Policy ← App content)

**Privacy policy**
```
https://www.outrepd.com/privacy
```

**App access** ← All or some functionality is restricted ← Add instructions:
- Name: `Review account`
- Username: `appreview@outrepd.com`
- Password: نفس الـ٦ أرقام بتوع Apple
- Any other information:
```
On the first screen tap "I already have an account", enter appreview@outrepd.com, tap "Send code", and type the six-digit password above into the code boxes. This account is never sent an email; every other account signs in with a one-time code sent to its email. The account has no subscription, so the subscription screen appears after sign-in.
```

**Ads**: **No, my app does not contain ads**

**Content rating** ← Start questionnaire:
- Email: `support@outrepd.com`
- Category: **All Other App Types**
- Violence / Sexuality / Language / Controlled substances / Gambling: **No** لكل حاجة
- Users can interact or exchange content: **Yes** (أسماء وصور بروفايل، من غير شات)
- Shares the user's current physical location: **No**
- Allows users to purchase digital goods: **Yes**
- Unrestricted internet access: **No**

**Target audience and content**
- Age groups: **16–17** و **18 and over** بس
- Appeal to children: **No**

**News apps**: **No**

**Data safety**: الإجابات في `data-safety.md` تحت **Google Play: Data safety**،
مع تعديل واحد: **Purchase history** ← Purpose: **App functionality** و
**Analytics** (RevenueCat بيعمل منها تقارير). ولينك مسح الحساب:
```
https://www.outrepd.com/privacy#deleting-your-account
```

**Health apps**: علّم على **Activity and fitness** بس (عدّ التمارين). مفيش
Health Connect ولا بيانات طبية.

**Government apps**: **No** · **Financial features**: **None**

**Advertising ID**: هيتحدد من تقرير البيلد (`play-check.txt`). لو مفيش
`AD_ID` في الـpermissions: **No**.

---

## ٥. الاشتراكات (Monetize ← Products ← Subscriptions)

محتاج **Payments profile** متفعّل (Play Console ← Settings ← Payments profile).

اعمل اتنين، بنفس أسعار iPhone:

| | Product ID | Base plan ID | المدة | السعر |
|---|---|---|---|---|
| أسبوعي | `pro_weekly` | `weekly` | 1 week, auto-renewing | $4.99 |
| سنوي | `pro_yearly` | `yearly` | 1 year, auto-renewing | $29.99 |

في كل base plan ← **Add offer** ← Offer ID `trial3` ← Eligibility: **New
customer acquisition** ← Phase: **Free trial, 3 days** ← **Activate**.
وبعدين **Activate** للـbase plan نفسه.

---

## ٦. RevenueCat

1. RevenueCat ← Project OUTREPD ← **Apps** ← **+ New** ← **Play Store**
   ← package `com.outrepd.outrepd`.
2. **Service account credentials**: RevenueCat بيشرح الخطوات في نفس الصفحة
   (Google Cloud ← service account ← JSON key ← تديله صلاحيات في Play Console
   ← Users and permissions). الـJSON يتحط في RevenueCat بس، **مايتبعتش هنا**.
3. **Products** ← Import ← `pro_weekly:weekly` و `pro_yearly:yearly`.
4. اربطهم بالـentitlement **`pro`**.
5. **Offerings** ← `default` ← package **Weekly** ← ضيف `pro_weekly:weekly`،
   و **Annual** ← ضيف `pro_yearly:yearly`.
6. **API keys** ← المفتاح العام بتاع Play (بيبدأ بـ`goog_`) ← GitHub ← Settings
   ← Secrets ← Actions ← **`REVENUECAT_ANDROID_KEY`**.

بعد كده أول بيلد أندرويد هيبقى فيه شاشة الاشتراك (`paywall key yes` في الـsummary).

---

## ٧. التجربة والنشر

1. **License testing** (Settings ← License testing): ضيف إيميلك عشان تشتري
   من غير فلوس.
2. **Internal testing** ← Create release ← ارفع الـ**AAB** (من GitHub ←
   Actions ← آخر run ← Artifacts ← `OUTREPD-aab-…`) ← جرّب الشراء.
3. **Closed testing** ← Create track ← نفس الـAAB ← Testers: الـ١٢+ إيميل
   ← ابعتلهم لينك الاشتراك ← **ابدأ عدّ الـ١٤ يوم**.
4. بعد ١٤ يوم: **Apply for production access** (أسئلة عن التجربة) ← بعد
   الموافقة: **Production** ← Create release ← نفس الـAAB أو أحدث.
