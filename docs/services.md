# خريطة خدمات OUTREPD

كل خدمة الأب بيعتمد عليها: بتعمل إيه، فين إعداداتها، وإيه اللي المفروض يكون
فيها. أي حاجة تلاقيها في dashboard ومش مكتوبة هنا يا إما زيادة تتمسح، يا إما
الملف ده ناقص ويتحدّث.

**المفاتيح السرية:** مكتوب هنا **أسماءها ومكانها بس**، أبداً مش قيمها. القيم
بتتحط في الـdashboard بتاعها ومش بتتكتب في الريبو ولا في الشات.

---

## ١. Supabase: السيرفر وقاعدة البيانات

**Project ref:** `pzhdakzjbjyxhspymjhb` · **URL:** `https://pzhdakzjbjyxhspymjhb.supabase.co`

### قاعدة البيانات
كلها جاية من `apps/outrepd_flutter/supabase/*.sql`، متجمعة في `install.sql`
(بيتولد بـ`tool/build_install.py`). بيتلصق كله في **SQL Editor** وينفع يتلصق
أكتر من مرة.

| الجدول | فيه إيه |
|---|---|
| `profiles` | الأكونتات: الاسم، الرانك، الدولة، الإعدادات |
| `sets` | كل سِت ضغط: العدد وتوقيت كل عدّة |
| `duels` | الماتشات ونتايجها |
| `set_offers` | السِت اللي السيرفر سلّمه لكل حد عشان يلاعبه |
| `live_matches`, `live_queue` | الماتشات اللايف والطابور |
| `friendships`, `blocks`, `mutes` | الصحاب والبلوك والكتم |
| `reports` | البلاغات |
| `notifications`, `push_tokens` | الإشعارات وعناوين الموبايلات |
| `subscriptions` | مين مشترك، بيكتبه `revenuecat-webhook` بس |
| `server_switches` | مفاتيح السيرفر (`paywall_enforced`)، بتتغير بـ`switches.sql` |
| `beta_testers`, `beta_tester_grants` | إيميلات تيسترز الـclosed test، ومين خد الـPro المجاني (`testers.sql`) |
| `rate_events` | عدّاد الحدود (كام تغيير اسم/دعوة في الساعة) |

**الحماية:** كل جدول عليه Row Level Security. الأب بيتكلم مع السيرفر من خلال
functions بس. اللي مالوش أكونت ممنوع من كل حاجة غير `public_lifter_card`
(كارت الشير على الموقع). الاختبارات: `tool/db/security_test.sql`.

**كل السيرفر في الريبو:** مفيش حاجة اتعملت يدوي برّه `install.sql`. الـtriggers
اللي بتنادي functions (`send_push`، `send_report_alert`، `tester_signed_up`،
`tester_added`) كلها فيه، ومن غير أي قيمة سرية جواها.

### Edge Functions (لازم يبقوا ٤ بالظبط)

| الاسم | بتعمل إيه | Verify JWT | السيكرتس اللي بتستخدمها |
|---|---|---|---|
| `push` | تبعت الإشعار للموبايل عن طريق Firebase | **مقفول** | `FCM_SERVICE_ACCOUNT` |
| `email-my-data` | تبعت لليوزر نسخة من بياناته بالإيميل | مفتوح أو مقفول، الاتنين شغالين | `RESEND_API_KEY`, `EXPORT_FROM` |
| `report-alert` | تبعتلك إيميل مع كل بلاغ (مرة واحدة لكل بلاغ) | **مقفول** | `RESEND_API_KEY`, `EXPORT_FROM`, `REPORTS_TO` |
| `revenuecat-webhook` | تحدّث جدول الاشتراكات من RevenueCat، وتدي التيسترز Pro شهرين | **مقفول** | `REVENUECAT_SECRET_KEY`, `REVENUECAT_WEBHOOK_AUTH` |

الكود في `apps/outrepd_flutter/supabase/functions/<الاسم>/index.ts`، وفي أول
كل ملف خطوات النشر.

### Edge Function Secrets (لازم يبقوا ٦ بالظبط، غير بتوع Supabase التلقائية)
`FCM_SERVICE_ACCOUNT` · `RESEND_API_KEY` · `EXPORT_FROM` · `REPORTS_TO` ·
`REVENUECAT_SECRET_KEY` · `REVENUECAT_WEBHOOK_AUTH`

(`SUPABASE_URL`، `SUPABASE_ANON_KEY`، `SUPABASE_SERVICE_ROLE_KEY`،
`SUPABASE_DB_URL` بيحطهم Supabase لوحده، متلمسهمش.)

### Authentication
- **Email:** مفتوح، الدخول بكود ٦ أرقام. الـtemplates بتاعة **Magic Link** و
  **Change Email Address** متغيرة لإيميلات فيها الكود (نسخها في `docs/email/`).
- **Anonymous sign-ins:** مفتوح (الضيف قبل التسجيل).
- **Google / Apple sign-in:** مقفولين (اتشالوا من الأب).
- **Site URL:** `https://www.outrepd.com`
- **Rate limits:** anonymous users **500** في الساعة (الافتراضي ٣٠ كان بيقفل
  الأب على الشبكات المشتركة).
- **SMTP:** الإيميلات بتطلع من **Resend** (الخطة المجانية: **١٠٠ إيميل في
  اليوم**). Supabase نفسه محدد ٣٠ إيميل في الساعة. كفاية للتجربة؛ **قبل
  الإطلاق** يا إما Resend Pro (٢٠$ في الشهر) يا إما SMTP بتاع Google Workspace
  (حوالي ٢٠٠٠ في اليوم من غير فلوس زيادة)، وبعدها يترفع حد الساعة في Supabase.
- **أكونت المراجعة:** `appreview@outrepd.com`، باسوورد ٦ أرقام، مستخدم لمراجعي
  Apple وGoogle. متمسحهوش.

### Storage
- Bucket واحد: `avatars` (public)، الصورة في `<user id>/photo.jpg` بس.

### الخطة
- دلوقتي **Free**: من غير backups يومية. **يتنقل لـPro يوم الإطلاق.**

---

## ٢. RevenueCat: الاشتراكات

**Project:** `OUTREPD`

| الحاجة | المفروض يكون |
|---|---|
| **Apps** | `OUTREPD (App Store)` · `OUTREPD (Play Store)` · **Test Store** (بيستخدمه بيلد "outrepd test" على GitHub عشان يجرب الشراء من غير فلوس) |
| **Entitlement** | `pro` واحد بس |
| **Offering** | `default` (Current) فيه **Weekly** (`$rc_weekly`) و**Annual** (`$rc_annual`) |
| **Products** | App Store: `com.outrepd.outrepd.pro.weekly`، `com.outrepd.outrepd.pro.yearly` · Play: `pro_weekly:weekly`، `pro_yearly:yearly`. الأربعة على `pro` |
| **Webhook** | `Supabase` → `https://pzhdakzjbjyxhspymjhb.supabase.co/functions/v1/revenuecat-webhook`، production + sandbox، الـAuthorization = `REVENUECAT_WEBHOOK_AUTH` |
| **Apple Server Notifications** | متوصلة (App Store Connect → App Information) |
| **Google Real-time notifications** | مش متوصلة (محتاجة Pub/Sub بكارت). الاشتراكات بتوصل برضه بس أبطأ |
| **API keys** | Public: `appl_…` (في GitHub `REVENUECAT_APPLE_KEY`) · `goog_…` (`REVENUECAT_ANDROID_KEY`) · Test Store (`REVENUECAT_TEST_KEY`) · Secret V1: `supabase-webhook` (في Supabase `REVENUECAT_SECRET_KEY`) |

**يتمسح لو لسه موجود:** تطبيقات GymRank القديمة ومنتجاتها، وأي offering غير
`default`، وأي secret key غير `supabase-webhook`.

---

## ٣. App Store Connect

- **App:** `OUTREPD : Push-up Duels` · Apple ID `6817853725` · Bundle `com.outrepd.outrepd`
- **Subscription group:** `OUTREPD Pro`: `Pro Weekly` ($4.99)، `Pro Yearly` ($39.99)، الاتنين فيهم Free 3 days
- **Sandbox tester:** `mokhtar200301sandbox1@gmail.com`
- **App Review account:** `appreview@outrepd.com`
- **Server notifications:** لينك RevenueCat (Production + Sandbox، Version 2)
- **Age rating:** 16+ · **Category:** Health & Fitness / Sports
- **الخطوات والنصوص:** `docs/store/app-store-submit.md`، `docs/store/app-review-reply.md`

## ٤. Google Play Console

- **Package:** `com.outrepd.outrepd` · **Developer name:** `OUTREPD`
- **Subscriptions:** `pro_weekly` (base plan `weekly`، $4.99) · `pro_yearly` (`yearly`، $39.99)، الاتنين فيهم offer `trial3` (٣ أيام، Never had any subscription)
- **Tracks:** Internal testing (إيميلك بس) · Closed testing - Alpha (التيسترز)
- **License testing:** إيميلك وإيميلات التيسترز
- **Service account لـRevenueCat:** في Google Cloud، متدي صلاحيات في Users and permissions
- **الخطوات:** `docs/store/google-play-submit.md`، `docs/store/google-play-production-access.md`

## ٥. Firebase

- **Cloud Messaging** (الإشعارات) و**Crashlytics** (تقارير الكراش). مفيش Analytics.
- إعدادات الأب: GitHub secrets `GOOGLE_SERVICES_JSON` (Android) و`GOOGLE_SERVICE_INFO_PLIST` (iPhone).
- مفتاح الإرسال: Supabase secret `FCM_SERVICE_ACCOUNT`.

## ٦. GitHub

- **Repo:** `bob-the-builderr/outrepd-new` (private) · الفرع: `camera-rep-counter`
- **Branches تانية:** `ci-results` (نتايج التست والصور) · `ci-builds` (تقارير البيلد)
- **Workflows:** `android-apk.yml` (APK + AAB + التستات + السيرفر) · `ios.yml` (iPhone، بس لما الـcommit فيه `[ios]`)
- **Secrets:** `SUPABASE_URL` · `SUPABASE_ANON_KEY` · `UPLOAD_KEYSTORE_BASE64` · `UPLOAD_KEYSTORE_PASSWORD` · `UPLOAD_KEY_ALIAS` · `UPLOAD_KEY_PASSWORD` · `GOOGLE_SERVICES_JSON` · `GOOGLE_SERVICE_INFO_PLIST` · `REVENUECAT_ANDROID_KEY` · `REVENUECAT_APPLE_KEY` · `REVENUECAT_TEST_KEY` · `APPLE_TEAM_ID` · `ASC_KEY_ID` · `ASC_ISSUER_ID` · `ASC_KEY_P8`
- **Actions:** الدقايق المجانية خلصت أكتوبر. بترجع ١ نوفمبر أو بـbudget.
- **مفتاح الرفع (upload key):** `C:\Users\MA\outrepd-upload.jks` على الجهاز ده، ونسخة في GitHub secrets.

## ٧. الدومين والإيميل والموقع

- **الدومين:** `outrepd.com`، الإيميل عليه **Google Workspace** (`support@outrepd.com`)
- **الموقع:** `https://www.outrepd.com`: `/privacy`، `/terms`، `/u/<username>` (كارت الشير)
- **Resend:** بيبعت إيميل نسخة البيانات وتنبيهات البلاغات (`RESEND_API_KEY`)
