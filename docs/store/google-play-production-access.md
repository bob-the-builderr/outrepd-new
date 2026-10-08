# طلب Production access على Google Play

بعد ما الـClosed test يكمّل **١٤ يوم ومعاه ١٢ تيستر على الأقل**، بيظهر في الـ
Dashboard زرار **Apply for production**. Google بيسأل حوالي ٩ أسئلة عن التجربة
والأب، وبيراجع الطلب في كام يوم.

**قاعدة مهمة:** الإجابات لازم تبقى حقيقية. أي حاجة بين `[قوسين]` املاها من اللي
حصل فعلاً في التست. Google بيقارن الإجابات باللي شايفه (عدد التيسترز، الفتح،
التحديثات)، والإجابة المؤلفة سبب رفض.

**خلال الـ١٤ يوم، عشان الإجابات دي تبقى حقيقية:**
- اجمع أي تعليق من التيسترز في مكان واحد (جروب واتساب مثلاً)، حتى لو صغير.
- ابعتلي التعليقات أول بأول، ونعمل تحديث واحد أو اتنين منها خلال التست.
- فكّرهم يفتحوا الأب في نص المدة.

---

## الجزء الأول: About your closed test

### How did you recruit users for your closed test?
اختار اللي حصل فعلاً (غالباً **Friends, family, or colleagues**، وكمان
**Testing communities** لو استخدمت جروبات تبادل التيست). وفي الخانة:
```
I invited [number] people I know personally — friends, family and people from my gym — who own Android phones and train at home or in a gym. [If used: I also joined a developer testing community where developers test each other's apps.] Each received a written guide: how to join the test, install the app, sign up, and try a practice set and a match.
```

### How easy was it to recruit testers for your app?
اختار الإجابة الحقيقية على الـscale.

### Describe the engagement you received from testers during your closed test
```
[number] testers joined and kept the app installed for the full 14 days. Most of them signed up, did the three push-up camera calibration, and played practice sets and duels; [number] played against each other live. I asked everyone to open the app a few times a week and reminded them halfway through the test. [Add anything real: who used it most, how many matches were played, which features they tried.]
```

### Provide a summary of the feedback that you received from testers. Include how you collected the feedback.
```
I collected feedback in a group chat with all the testers and by talking to them directly after they played. The main points were:
- [real feedback 1, e.g. how the rep counter felt on their phone and camera angle]
- [real feedback 2, e.g. something unclear in onboarding or the match screen]
- [real feedback 3, e.g. a crash, a slow phone, or a sign-up problem]
Overall, [one honest sentence about how testers found the app].
```

---

## الجزء التاني: About your app or game

### Who is the intended audience of your app?
```
People aged 16 and over who do bodyweight training — mostly push-ups — at home or in a gym, and who want a reason to keep going. The app is for anyone who enjoys friendly competition: it turns every set into a 60-second duel against a real person, with a ranked ladder from Iron to Master and challenges between friends. The app refuses anyone under 16 at the first screen.
```

### Describe how your app or game provides value to users
```
Training alone is hard to keep up and easy to cheat on. OUTREPD counts push-ups with the phone's front camera, entirely on the device (no video ever leaves the phone), and only full-depth reps score. Every set becomes a duel against a real person — live, or against a set they actually did — which gives a reason to do one more rep. Results move the user up a seven-tier ranked ladder, and friends can challenge each other and keep a head-to-head record. Users can download all their data or delete their account from inside the app.
```

### How many installs do you expect your app to have in your first year?
اختار الرينج الواقعي حسب خطتك للتسويق (مثلاً **1,000 – 10,000** لو هتعمل
تسويق بسيط على السوشيال).

---

## الجزء التالت: Your production readiness

### What changes did you make to your app based on what you learned during your closed test?
```
During the test I released [number] updates:
- [real change 1 from tester feedback, e.g. "a clearer message when the subscription plans cannot load, after a tester's phone blocked the store with a private DNS setting"]
- [real change 2]
- [real change 3]
I also fixed issues that testing exposed in sign-up when a phone had no connection to the server, and removed device permissions the app does not use (microphone, advertising ID).
```
> آخر سطر حقيقي (اتعمل في الكود ٤–٦ أكتوبر). سيبه لو التحديث ده وصل
> للتيسترز خلال التست؛ لو لأ، شيله.

### How did you decide that your app is ready for production?
```
The app was used by [number] testers on different Android phones for 14 days. [The crash reports in Firebase Crashlytics showed no open crashes / showed X, which were fixed.] Sign-up, the subscription with its free trial, practice sets, duels and account deletion worked for every tester. The rep counter is checked against labelled real push-up sets on every build, and the server's security rules are tested against a modified client on every build. The same version has been [approved by Apple / in Apple's review] for the App Store.
```

---

**بعد ما تبعت:** المراجعة بتاخد عادة من يوم لأسبوع. لو اترفض، Google بيقول
السبب (غالباً تفاعل قليل من التيسترز)، وبيطلب تكمّل تست أطول. ابعتلي الرسالة
وقتها.
