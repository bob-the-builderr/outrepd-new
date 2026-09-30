# Data safety (Google Play) و App privacy (App Store)

الإجابات دي مكتوبة من اللي الكود بيعمله فعلًا يوم ٢٧ سبتمبر ٢٠٢٦: جداول
`supabase/schema.sql` و `social.sql` و `notify.sql`، و `lib/backend/`. لو
الأب اتغيّر بعد كده بحيث بقى بيجمع حاجة جديدة، لازم الإجابات دي تتغيّر كمان.

## اللي الأب بيجمعه

| البيانات | فين | إجباري؟ | ليه |
|---|---|---|---|
| اسم المستخدم | السيرفر | أيوه | يظهر في الرانكس والصحاب والماتشات |
| الإيميل | السيرفر (Supabase Auth) | لأ، بس لو عملت حساب بإيميل | الدخول واسترجاع الحساب |
| الدولة | السيرفر | لأ | لوحة ترتيب الدولة. بتتاخد من إعدادات لغة الموبايل، **مش من الموقع** |
| صورة البروفايل | السيرفر (Storage، public) | لأ | تظهر للناس التانية |
| السِتّات: عدد العدّات، توقيت كل عدّة، العمق، المدة، التاريخ | السيرفر | أيوه للماتشات | الماتش والرتبة |
| الماتشات والنتايج والرتبة | السيرفر | أيوه | الترتيب |
| الصحاب، البلوك، الكتم | السيرفر | لأ | الميزات الاجتماعية |
| البلاغات والنص اللي معاها | السيرفر | لأ | مراجعة البلاغات |
| الإشعارات جوه الأب | السيرفر | أيوه | شاشة الإشعارات |
| آخر ظهور | السيرفر | أيوه | علامة "أونلاين" عند الصحاب |
| اللقب اللي لابسه | السيرفر | لأ | يظهر تحت اسمك |
| الإعدادات (مين يتحداك، الظهور في اللوحة، الإشعارات) | السيرفر | أيوه | تنفيذ اختياراتك |
| الاشتراك: الخطة، البداية والتجديد أو الانتهاء، والمتجر | السيرفر (`subscriptions`) و RevenueCat | أيوه | الأب كله ورا اشتراك. الدفع نفسه عند Google Play/App Store، والأب ماعندوش بيانات كارت |

**اللي مابيخرجش من الموبايل خالص:** فيديو الكاميرا، ونقط الجسم (pose). تسجيل
نقط الجسم بيتحفظ على الموبايل بس عشان مقارنة دقة العداد. في جدول `sets` فيه
خانة `recording_path` لتسجيل، بس الأب ماعندوش أي كود بيرفعه.

**اتضاف يوم ٣٠ سبتمبر ٢٠٢٦ (`supabase/push.sql`، `lib/push.dart`، `lib/firebase.dart`):**
- عنوان push للموبايل (FCM token) ولغة الأب، في جدول `push_tokens`. اختياري:
  بس لو الموبايل سمح بالإشعارات. بيتمسح مع تسجيل الخروج أو مسح الحساب.
- Crash reports من Firebase Crashlytics: الغلطة، موديل الموبايل، نسخة النظام
  والأب، ومعرّف تثبيت بتاع Crashlytics. للإصلاح بس.
- التذكير اليومي بيتعمل على الموبايل ومابيوصلش السيرفر.

**مفيش:** إعلانات، أنالتكس، تتبع، موقع، جهات اتصال.

**جهات بتشيل البيانات بالنيابة عنك (service providers، مش "مشاركة"):**
- Supabase: السيرفر وقاعدة البيانات والصور.
- Resend: بيبعت ملف بياناتك بالإيميل لما تطلبه من الإعدادات.
- RevenueCat: بيدير الاشتراكات. بياخد الـ user ID وسجل الشراء من المتجر.
- Google Firebase: بيوصّل الإشعارات (Cloud Messaging) وبيجمع الـ crash
  reports (Crashlytics).

**Google ML Kit:** قراءة حركة الجسم بتحصل على الموبايل بمكتبة Google ML Kit.
شروط Google بتقول إن المكتبة ممكن تبعت لجوجل معلومات استخدام وأداء عن المكتبة
نفسها. راجع https://developers.google.com/ml-kit/terms قبل ما تقفل الفورم،
ولو فيها أي حاجة محتاجة تتذكر، ضيفها.

---

## Google Play: Data safety

**Does your app collect or share any of the required user data types?** Yes

**Is all of the user data collected by your app encrypted in transit?** Yes

**Do you provide a way for users to request that their data is deleted?** Yes
- جوه الأب: الإعدادات ← Data ← Delete account.
- من برّه الأب: https://www.outrepd.com/privacy#delete (Google بيطلب لينك
  ويب للطلب ده).

**Data shared with third parties:** None

**Data collected:**

| Category | Type | Optional? | Purpose |
|---|---|---|---|
| Personal info | Email address | Optional | Account management |
| Personal info | User IDs (username) | Required | App functionality, Account management |
| Personal info | Other info (country) | Optional | App functionality |
| Photos and videos | Photos (profile picture) | Optional | App functionality |
| Health and fitness | Fitness info (rep counts, sets) | Required | App functionality |
| App activity | In-app actions (duels, friends, blocks) | Required | App functionality |
| App activity | Other user-generated content (reports) | Optional | App functionality |
| Financial info | Purchase history (subscription) | Required | App functionality |
| App info and performance | Crash logs | Required | App functionality |
| App info and performance | Diagnostics | Required | App functionality |
| Device or other IDs | Device or other IDs (push token, Crashlytics installation ID) | Optional | App functionality |

كلها **Processed ephemerally: No**، و **not used for** advertising or
analytics.

---

## App Store: App privacy

**Do you or your third-party partners collect data from this app?** Yes

**Is any data used to track users?** No

**Data linked to the user** (كلها for *App Functionality*، ومفيش حاجة
for tracking or advertising):

| Category | Type |
|---|---|
| Contact Info | Email Address |
| Identifiers | User ID |
| Health & Fitness | Fitness |
| User Content | Photos or Videos (profile picture only) |
| User Content | Other User Content (reports) |
| Usage Data | Product Interaction |
| Purchases | Purchase History (subscription) |
| Identifiers | Device ID (push token) |

**Data not linked to the user** (for *App Functionality*):

| Category | Type |
|---|---|
| Diagnostics | Crash Data |
| Diagnostics | Other Diagnostic Data |

---

## Content rating (IARC / App Store age rating)

- مفيش عنف، ولا محتوى جنسي، ولا ألفاظ، ولا قمار، ولا مخدرات.
- **Users can interact:** Yes. فيه أسماء مستخدمين وصور بروفايل وبلاغات، بس
  مفيش شات.
- **Shares location:** No.
- **Digital purchases:** Yes — اشتراك أسبوعي وسنوي، جوه المتجر.
- الأب نفسه بيرفض أي حد أقل من ١٦ سنة.
