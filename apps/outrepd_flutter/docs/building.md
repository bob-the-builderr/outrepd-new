# البناء

## المعاينة على الويب

```bash
flutter build web --release --no-tree-shake-icons
```

## الـAPK

```bash
flutter build apk --release --no-tree-shake-icons \
  --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```

المفاتيح في `supabase/keys.env`، والملف ده مش في git.

## التوقيع لـ Google Play

نسخة الـ release بتتوقّع بمفتاح الرفع لو لقت `android/key.properties`، ولو
مش موجود بتتوقّع بمفتاح التطوير. نسخة متوقّعة بمفتاح التطوير بتشتغل على
الموبايل عادي، بس Google Play بيرفضها.

اعمل المفتاح مرة واحدة بس، وخلّيه برّه الريبو:

```bash
keytool -genkey -v -keystore ~/outrepd-upload.jks -keyalg RSA \
  -keysize 2048 -validity 10000 -alias upload
```

وبعدين اعمل `android/key.properties` (الملف ده في `.gitignore`):

```properties
storeFile=/المسار/الكامل/outrepd-upload.jks
storePassword=...
keyAlias=upload
keyPassword=...
```

خد نسخة احتياطي من الـ `.jks` والباسوردات في مكان آمن. لو اتفعّل Play App
Signing، Google بيقدر يغيّرلك مفتاح الرفع لو ضاع، بس ده بياخد وقت.

للرفع على Play اعمل bundle مش APK:

```bash
flutter build appbundle --release --no-tree-shake-icons \
  --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
```

## Google Play من GitHub (من غير الكمبيوتر)

الـ workflow في `.github/workflows/android-apk.yml` بيبني الـ APK والـ App
Bundle على GitHub مع كل push، وبيوقّعهم بمفتاح الرفع لو لقاه في الـ Secrets.
الملفين بيبقوا في **Artifacts** في صفحة الـ run، ورقم البناء بيزيد لوحده
(١٠٠ + رقم الـ run)، فكل رفع على Play أعلى من اللي قبله.

**مرة واحدة: اعمل مفتاح الرفع** (PowerShell، على الـ C: مش الـ D:):

```powershell
& "$env:USERPROFILE\jdk17\jdk-17.0.20+8\bin\keytool.exe" -genkeypair -v `
  -keystore "$env:USERPROFILE\outrepd-upload.jks" `
  -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

هيسألك على باسورد (اختار واحد طويل، **من غير `\`**)، وبعدين اسمك وبيانات
تانية — ممكن تسيبها فاضية بـ Enter — وآخر حاجة اكتب `yes`.

وبعدين انسخ المفتاح كنص:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("$env:USERPROFILE\outrepd-upload.jks")) | Set-Clipboard
```

**ضيف ٣ Secrets** في GitHub (Settings ← Secrets and variables ← Actions ←
New repository secret):

| الاسم | القيمة |
|---|---|
| `UPLOAD_KEYSTORE_BASE64` | Ctrl+V — النص اللي اتنسخ فوق |
| `UPLOAD_KEYSTORE_PASSWORD` | الباسورد |
| `UPLOAD_KEY_ALIAS` | `upload` |

⚠️ **خد نسخة من `outrepd-upload.jks` والباسورد في مكان آمن** — مدير باسوردات
أو درايف — **ومش على قرص D**. لو ضاعوا، Google بيقدر يغيّر مفتاح الرفع بس ده
بياخد أيام، وفي الوقت ده مفيش تحديثات.

بعدها أي push (أو Actions ← Android APK ← Run workflow) بيطلّع
`OUTREPD-aab-…` جاهز يترفع على Play، والـ APK كمان متوقّع بنفس المفتاح — فكل
APK جديد بيتنزّل فوق اللي قبله من غير ما تمسحه.

## ليه `--no-tree-shake-icons`

فلاتر بيقلّص خط الأيقونات من ١.٦ ميجا لـ٢٩ كيلو بإنه يشيل الأيقونات اللي
شايف إنها مش مستعملة. المشكلة إنه بيشيل أيقونات **مستعملة فعلًا**، ومن غير
أي تحذير — الأيقونة بترسم فاضية وخلاص.

اتمسكت في شاشة البلاغ (٢٣ سبتمبر ٢٠٢٦): `Icons.radio_button_checked`
و`radio_button_unchecked` اختفوا، يعني **مفيش طريقة تعرف بيها انت مختار
أنهي سبب**. مش مشكلة شكلية — الشاشة بقت مش قابلة للاستخدام.

واللي بيخلي الموضوع أصعب إنه مش متوقَّع: في نفس الـ`switch`، `Icons.public`
و`Icons.people_outline` فضلوا و`Icons.do_not_disturb_on_outlined` اتشال.
والقص خارج بنفس الحجم بالظبط (٢٨٨٢٠ بايت) في كل مرة، يعني مش عشوائي —
بس برضو مفيش قاعدة تقدر تتنبأ بيها قبل ما تشوف الشاشة.

اللي اتشال لحد دلوقتي: `radio_button_checked`، `radio_button_unchecked`،
`block`، `shield_outlined`، `insights_outlined`،
`do_not_disturb_on_outlined`، `how_to_reg_outlined`.

الفرق في الحجم ١.٦ ميجا. ده تمن معقول مقابل إن كل أيقونة في التطبيق ترسم،
بدل ما نكتشف كل مرة أيقونة ناقصة بالصدفة وإحنا بنتفرج على المعاينة.

لو حبيت ترجّع التقليص يوم ما، لازم تتفرج على كل شاشة فيها أيقونة قبل
الإصدار — مش على اللي اتغيّرت بس.

## آيفون

لازم ماك عليه Xcode و Flutter و CocoaPods (`brew install cocoapods`)، وحساب
Apple Developer (٩٩ دولار في السنة).

مرة واحدة بس:

1. في [developer.apple.com](https://developer.apple.com/account/resources/identifiers/list)
   اعمل App ID بالـ Bundle ID ده بالظبط: `com.outrepd.outrepd`.
2. في [App Store Connect](https://appstoreconnect.apple.com) اعمل App جديد
   بنفس الـ Bundle ID.
3. انقل `supabase/keys.env` من الويندوز لنفس المكان على الماك.
4. افتح `ios/Runner.xcworkspace` في Xcode (الـ workspace مش الـ xcodeproj)
   ← Runner ← Signing & Capabilities ← اختار الـ Team بتاعك، وسيب
   "Automatically manage signing" متعلّم.

كل مرة:

```bash
bash tool/build_ios.sh
```

السكريبت بيعمل الأرشيف ويفتحه في Xcode. من هناك: Distribute App ← App Store
Connect ← Upload. بعد ربع ساعة تقريبًا النسخة بتظهر في TestFlight.

قبل كل رفع جديد زوّد رقم البناء في `pubspec.yaml` (`version: 1.0.0+2`،
`+3`، ...). Apple و Google الاتنين بيرفضوا رقم بناء اترفع قبل كده.

## آيفون من ويندوز (من غير ماك)

Codemagic بيبني الأب على ماك عندهم ويرفعه على TestFlight لوحده. فيه ٥٠٠
دقيقة مجانًا في الشهر، والبناء الواحد بياخد حوالي ١٥ دقيقة. الإعدادات
موجودة في `codemagic.yaml` في أول الريبو.

مرة واحدة بس:

1. **حساب Apple Developer** (٩٩ دولار في السنة). أسهل طريقة تشترك بيها من
   تطبيق Apple Developer على الآيفون، أو من developer.apple.com.
2. **App ID**: من developer.apple.com ← Identifiers ← `+` ← App IDs،
   والـ Bundle ID بالظبط `com.outrepd.outrepd`. الـ Capabilities سيبها زي
   ما هي.
3. **الأب في App Store Connect**: من appstoreconnect.apple.com ← Apps ← `+`
   ← New App، واختار نفس الـ Bundle ID. بعد ما يتعمل افتح App Information،
   وانسخ الـ **Apple ID** (رقم زي 6741234567).
4. **مفتاح API**: من App Store Connect ← Users and Access ← Integrations ←
   App Store Connect API ← `+`، وخلّي الصلاحية **App Manager**. نزّل ملف
   الـ `.p8` واحفظه في مكان آمن، لأنه بيتنزّل مرة واحدة بس. خد كمان الـ
   **Issuer ID** والـ **Key ID**.
5. **Codemagic**: اعمل حساب على codemagic.io بحساب GitHub، واختار الريبو
   `outrepd-new`.
6. من Codemagic ← Team settings ← Integrations ← Developer Portal ← Manage
   keys ← Add key:
   - الاسم لازم يبقى بالظبط **`outrepd`**.
   - حط الـ Issuer ID والـ Key ID، وارفع ملف الـ `.p8`.
7. من صفحة الأب في Codemagic ← Environment variables، ضيف:
   - `SUPABASE_URL` و `SUPABASE_ANON_KEY` (نفس اللي في `supabase\keys.env`)
     في group اسمه **`supabase`**، وعلّم Secure.
   - `APP_STORE_APPLE_ID` بالرقم اللي خدته في الخطوة ٣، في نفس الـ group.
8. من Codemagic ← Code signing identities ← iOS certificates ← Generate
   certificate. Codemagic بيعمل شهادة التوزيع بالمفتاح اللي ضفته.

كل مرة:

- من Codemagic ← Start new build، واختار الفرع و **iOS → TestFlight**.
- بعد ما يخلص، النسخة بتظهر في App Store Connect ← TestFlight بعد ربع ساعة
  تقريبًا. نزّل تطبيق TestFlight على الآيفون وجرّب منه.
- لما تبقى جاهز: App Store Connect ← صفحة الأب ← اختار النسخة ← Add for
  Review.

رقم البناء بيزيد لوحده، فمش محتاج تغيّره في `pubspec.yaml` عشان آيفون.
