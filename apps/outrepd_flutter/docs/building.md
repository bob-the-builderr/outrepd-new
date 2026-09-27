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
