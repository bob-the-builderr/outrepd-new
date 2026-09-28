// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class LAr extends L {
  LAr([String locale = 'ar']) : super(locale);

  @override
  String get tabFriends => 'الأصدقاء';

  @override
  String get tabRanks => 'الرتب';

  @override
  String get tabMatch => 'المباراة';

  @override
  String get tabProfile => 'حسابي';

  @override
  String get challengeFriend => 'تحدَّ صديقًا';

  @override
  String get matchHistory => 'سجل المباريات';

  @override
  String get allMatches => 'جميع المباريات';

  @override
  String get wins => 'انتصارات';

  @override
  String get losses => 'هزائم';

  @override
  String get winRate => 'نسبة الفوز';

  @override
  String get streak => 'السلسلة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get accountSection => 'الحساب';

  @override
  String get duelSection => 'المنازلة';

  @override
  String get hapticsEachRep => 'اهتزاز مع كل عدة';

  @override
  String get showSkeleton => 'إظهار الهيكل فوق الصورة';

  @override
  String get showSkeletonHint => 'بيه تعرف إن الكاميرا شايفاك';

  @override
  String get manageNotifications => 'إدارة الإشعارات';

  @override
  String switchesOn(String on, String all) {
    return '$on من $all مفعّلة';
  }

  @override
  String get whoCanChallenge => 'مين يقدر يتحداني';

  @override
  String get blockedAccounts => 'الحسابات المحظورة';

  @override
  String get reportProblem => 'الإبلاغ عن مشكلة';

  @override
  String get onDeviceNote =>
      'قراءة الوضعية بتحصل على الموبايل ده. مفيش فيديو ولا بيانات وضعية بتترفع خالص.';

  @override
  String get visibilitySection => 'الظهور';

  @override
  String get showMyCountry => 'إظهار دولتي';

  @override
  String get showMyCountryHint => 'لو قفلته هتختفي من لوحة دولتك';

  @override
  String get safetySection => 'الأمان';

  @override
  String get socialSection => 'اجتماعي';

  @override
  String get noticeRaced => 'حد سابق مجموعتي';

  @override
  String get noticeRacedHint => 'الطريقة الوحيدة تعرف بيها إن فيه ماتش حصل';

  @override
  String get noticeFriendOk => 'اتقبل طلب بعته';

  @override
  String get noticesStoredNote =>
      'قفل أي واحد معناه إنه مابيتخزنش أصلًا، مش إنه بيتخزن ويتخبى.';

  @override
  String get notSaved => 'ماتسجلش';

  @override
  String get blockedIntro =>
      'الحساب المحظور مش هيقدر يتحداك ولا يلاقيك ولا يبعتلك طلب. وهو مش هيتقاله.';

  @override
  String blockedWhen(String when) {
    return 'اتحظر $when';
  }

  @override
  String get unblock => 'إلغاء الحظر';

  @override
  String get noBlockedTitle => 'مفيش حد محظور';

  @override
  String get noBlockedBody => 'تقدر تحظر أي حد من صفحته أو من شاشة البلاغ.';

  @override
  String get whatHappened => 'إيه اللي حصل';

  @override
  String get reasonCheating => 'غش أو عدات مزيفة';

  @override
  String get reasonHarassment => 'تحرش أو إساءة';

  @override
  String get reasonContent => 'محتوى غير لائق';

  @override
  String get reasonImpersonation => 'انتحال شخصية';

  @override
  String get reasonOther => 'حاجة تانية';

  @override
  String get addDetails => 'تفاصيل زيادة (اختياري)';

  @override
  String get alsoBlock => 'احظر الحساب ده كمان';

  @override
  String get sendReport => 'إرسال البلاغ';

  @override
  String get reportSent => 'اتبعت البلاغ';

  @override
  String get reportingThisAccount => 'بتبلّغ عن الحساب ده';

  @override
  String get exportIntro =>
      'هنبعتلك ملف بكل اللي السيرفر شايله عنك على الإيميل. عادةً بياخد دقيقة.';

  @override
  String get whatsIncluded => 'اللي جواه';

  @override
  String get incProfile => 'بروفايلك ورتبتك';

  @override
  String get incSets => 'كل مجموعة وكل عدد عدات';

  @override
  String get incDuels => 'تاريخ المباريات وتغيّر النقاط';

  @override
  String get incFriends => 'الأصدقاء والحسابات المحظورة';

  @override
  String get incNotices => 'الإشعارات اللي اتبعتتلك';

  @override
  String get noLandmarksNote =>
      'نقاط الجسم مش جواه، ومكانتش أصلًا. الكاميرا بتقراها على موبايلك ومابتتبعتش لحد.';

  @override
  String get sendItTo => 'ابعته على';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get passwordHint => 'كلمة المرور';

  @override
  String get codeHint => 'رمز التحقق';

  @override
  String get createAccountTitle => 'إنشاء حساب';

  @override
  String get createAccountBody =>
      'أضف بريدًا إلكترونيًا وكلمة مرور حتى لا يكون فقدان هذا الحساب على بُعد هاتف واحد فقط.';

  @override
  String get createAccountAction => 'إنشاء حساب';

  @override
  String get signInTitle => 'تسجيل الدخول';

  @override
  String get signInBody =>
      'سجّل الدخول بالبريد الإلكتروني وكلمة المرور الخاصين بحسابك.';

  @override
  String get signInAction => 'تسجيل الدخول';

  @override
  String get switchToSignIn => 'لديك حساب بالفعل؟ سجّل الدخول';

  @override
  String get switchToSignUp => 'جديد هنا؟ أنشئ حسابًا';

  @override
  String get emailTakenSwitchToSignIn =>
      'هذا البريد الإلكتروني له حساب بالفعل — سجّل الدخول بدلًا من ذلك.';

  @override
  String get emailSignUpInvalid =>
      'تحقق من البريد الإلكتروني وكلمة المرور — 6 أحرف على الأقل.';

  @override
  String get tooManyCodes =>
      'تم إرسال رموز كثيرة — انتظر بضع دقائق وحاول مرة أخرى.';

  @override
  String get sendCodeAction => 'ابعت الكود';

  @override
  String get noAccountForEmail => 'معندناش حساب بالإيميل ده.';

  @override
  String get authEntryTagline => 'ادفع. نافس. اصعد السلم.';

  @override
  String get orDivider => 'أو';

  @override
  String get signUpWithEmail => 'سجّل بالبريد الإلكتروني';

  @override
  String get alreadyHaveAccountQuestion => 'عندك حساب بالفعل؟';

  @override
  String get logInAction => 'تسجيل الدخول';

  @override
  String get createYourAccountTitle => 'أنشئ حسابك';

  @override
  String get createAccountSubtitle => 'بياخد أقل من دقيقة.';

  @override
  String get usernameHint => 'اسم المستخدم';

  @override
  String get usernameLabel => 'اليوزر نيم';

  @override
  String get emailLabel => 'الإيميل';

  @override
  String get passwordLabel => 'كلمة السر';

  @override
  String get passwordMinLength => '8 أحرف على الأقل';

  @override
  String get logInSubtitle => 'سجّل دخولك عشان تحافظ على رتبتك.';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String resetPasswordSent(String email) {
    return 'لو فيه حساب مرتبط بـ$email، رابط إعادة التعيين في طريقه.';
  }

  @override
  String get checkYourEmailTitle => 'افحص بريدك الإلكتروني';

  @override
  String codeSentTo(String email) {
    return 'بعتنالك رمز من 6 أرقام على $email.';
  }

  @override
  String get didntGetIt => 'مستلمتش الرمز؟';

  @override
  String resendInSeconds(String time) {
    return 'إعادة الإرسال بعد $time';
  }

  @override
  String get wrongEmailGoBack => 'الإيميل غلط؟ ارجع';

  @override
  String get usernameTaken => 'اسم المستخدم ده متاخد.';

  @override
  String get socialLinkFailed => 'معرفناش نكمّل تسجيل الدخول. جرّب تاني.';

  @override
  String get showLabel => 'إظهار';

  @override
  String get hideLabel => 'إخفاء';

  @override
  String get resetPasswordTitle => 'اضبط كلمة مرور جديدة';

  @override
  String get resetPasswordBody => 'اختار كلمة مرور جديدة لحسابك.';

  @override
  String get setPasswordAction => 'ضبط كلمة المرور';

  @override
  String get wrongEmailOrPassword =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة.';

  @override
  String get enterCodeTitle => 'إدخال الرمز';

  @override
  String codeInstructions(String email) {
    return 'أدخل الرمز الذي أرسلناه إلى $email.';
  }

  @override
  String get verifyAction => 'تأكيد';

  @override
  String get wrongCode => 'هذا الرمز غير صحيح أو انتهت صلاحيته.';

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String get codeResent => 'تم إرسال رمز جديد.';

  @override
  String signedInAs(String email) {
    return 'تم تسجيل الدخول بالبريد $email';
  }

  @override
  String get addressNotKept =>
      'العنوان بيتستخدم مرة واحدة ومابيتخزنش — الحساب ده مفيهوش إيميل أصلًا.';

  @override
  String get requestMyData => 'ابعتلي بياناتي';

  @override
  String exportSent(String address) {
    return 'اتبعت على $address';
  }

  @override
  String get deleteIntro =>
      'ده بيمسح كل حاجة نهائيًا. مفيش رجوع ومش هنقدر نسترجعها.';

  @override
  String get rankLabel => 'الرتبة';

  @override
  String get wantCopyFirst => 'عايز نسخة الأول؟';

  @override
  String get wantCopyBody => 'نزّل بياناتك قبل ما تمسح. بعد كده هتروح.';

  @override
  String typeToConfirm(String word) {
    return 'اكتب $word للتأكيد';
  }

  @override
  String get deleteWord => 'امسح';

  @override
  String get deletePermanently => 'امسح نهائيًا';

  @override
  String get keepMyAccount => 'خليني محتفظ بحسابي';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get skip => 'تخطٍّ';

  @override
  String get height => 'الطول';

  @override
  String get yourPicture => 'صورتك';

  @override
  String get yourPictureHint => 'الإطار مستمد من رتبتك، ويتغير كلما ارتقيت.';

  @override
  String get couldNotUsePicture => 'معرفتش أستخدم الصورة دي';

  @override
  String get couldNotSyncAvatar => 'الصورة اتحفظت، بس لسه ما اتزامنتش';

  @override
  String get couldNotShareCard => 'مقدرش يشارك الكارت ده';

  @override
  String get couldNotOpenLink => 'مقدرش يفتح اللينك ده';

  @override
  String get couldNotCheckUsername => 'مقدرش يتأكد من الاسم ده — جرب تاني';

  @override
  String get changeUsername => 'تغيير اسم المستخدم';

  @override
  String get usernameInvalidLength =>
      'لازم يكون من 4 لـ 20 حرف، حروف وأرقام بس';

  @override
  String get usernameChanged => 'اتغير اسم المستخدم';

  @override
  String get usernameAlreadyChangedBody =>
      'استخدمت بالفعل فرصة تغيير الاسم الوحيدة — كل حساب ليه فرصة واحدة بس.';

  @override
  String get gallery => 'المعرض';

  @override
  String get camera => 'الكاميرا';

  @override
  String get orPickOurs => 'أو اختر صورة من صورنا';

  @override
  String get awards => 'الجوائز';

  @override
  String get yourTitles => 'ألقابك';

  @override
  String get stillToEarn => 'ألقاب لم تكتسبها بعد';

  @override
  String get noTitlesYet =>
      'لا ألقاب بعد. أول لقب لا يحتاج أكثر من مباراة واحدة.';

  @override
  String get wearHint =>
      'اضغط على أي لقب لترتديه، فيظهر بجوار اسمك في كل موضع يراك فيه الآخرون.';

  @override
  String get worn => 'مُرتدى';

  @override
  String get titleUnlocked => 'لقب جديد';

  @override
  String get wearIt => 'ارتدِه';

  @override
  String get wearItLater => 'لاحقًا';

  @override
  String get dayStreak => 'يومًا متتاليًا';

  @override
  String get bestEver => 'أفضل سلسلة';

  @override
  String get restDaysLeft => 'أيام الراحة المتبقية';

  @override
  String get restIsTraining =>
      'الراحة جزء من التدريب، ويوما راحة في الأسبوع لا يقطعان سلسلتك.';

  @override
  String get global => 'عالمي';

  @override
  String get topPlayers => 'أفضل اللاعبين';

  @override
  String get yourTier => 'مستواك';

  @override
  String get challenge => 'تحدٍّ';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get start => 'ابدأ';

  @override
  String get finish => 'إنهاء';

  @override
  String get reps => 'تكرار';

  @override
  String get recalibrate => 'إعادة المعايرة';

  @override
  String get resetCount => 'تصفير العدّاد';

  @override
  String get howManyReally => 'كم تكرارًا أديت فعليًا؟';

  @override
  String get howManyReallyHint =>
      'عددك أنت لا عدد التطبيق، فهو المرجع الذي تُقاس به دقة العدّاد لاحقًا.';

  @override
  String get appearance => 'المظهر';

  @override
  String get theme => 'السمة';

  @override
  String get language => 'اللغة';

  @override
  String get units => 'الوحدات';

  @override
  String get weight => 'الوزن';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get data => 'البيانات';

  @override
  String get about => 'حول التطبيق';

  @override
  String get themeSystem => 'حسب الجهاز';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get accept => 'قبول';

  @override
  String challengeSent(String name) {
    return 'أُرسل التحدي إلى $name';
  }

  @override
  String get weightUnitTitle => 'وحدة الوزن';

  @override
  String get heightUnitTitle => 'وحدة الطول';

  @override
  String get unitKg => 'كيلوغرام (kg)';

  @override
  String get unitLb => 'رطل (lb)';

  @override
  String get unitCm => 'سنتيمتر (cm)';

  @override
  String get unitFt => 'قدم وبوصة';

  @override
  String get visEveryone => 'الجميع';

  @override
  String get visFriends => 'الأصدقاء فقط';

  @override
  String get visNobody => 'لا أحد';

  @override
  String get friendRequestsLabel => 'طلبات الصداقة';

  @override
  String get showOnLeaderboards => 'إظهاري في لوحات الصدارة';

  @override
  String get exportData => 'تصدير بياناتي';

  @override
  String get version => 'الإصدار';

  @override
  String get rateApp => 'قيِّم OUTREPD';

  @override
  String get contactSupport => 'التواصل مع الدعم';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get openSourceLicences => 'تراخيص المصادر المفتوحة';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get needsServer => 'تتطلب هذه الميزة خادمًا، ولم تُربط بعد';

  @override
  String get achievements => 'الإنجازات';

  @override
  String get roadTitle => 'الطريق إلى المُعلِّم';

  @override
  String get allTiers => 'جميع الرتب';

  @override
  String get topTier => 'أعلى رتبة';

  @override
  String lpToGo(String lp) {
    return '$lp نقطة';
  }

  @override
  String get roomFriendly => 'مباريات الغرفة ودية، ولا تؤثر في رتبتك.';

  @override
  String get createRoom => 'أنشئ غرفة';

  @override
  String get enterCode => 'أدخل الرمز';

  @override
  String get joinRoom => 'انضم إلى الغرفة';

  @override
  String get shareThisCode => 'شارك هذا الرمز';

  @override
  String get codeCopied => 'تم نسخ الرمز';

  @override
  String get pickMuscleAndStart => 'اختر العضلة وابدأ';

  @override
  String xOfY(String a, String b) {
    return '$a/$b';
  }

  @override
  String get tierIron => 'الحديد';

  @override
  String get tierBronze => 'البرونز';

  @override
  String get tierSilver => 'الفضة';

  @override
  String get tierGold => 'الذهب';

  @override
  String get tierPlatinum => 'البلاتين';

  @override
  String get tierDiamond => 'الماس';

  @override
  String get tierMaster => 'المُعلِّم';

  @override
  String get shortKg => 'كجم';

  @override
  String get shortLb => 'رطل';

  @override
  String get shortCm => 'سم';

  @override
  String get shortFt => 'قدم';

  @override
  String winLoss(String w, String l) {
    return '$w فوز · $l هزيمة';
  }

  @override
  String get continueLabel => 'متابعة';

  @override
  String get ttl_first_blood => 'أول دم';

  @override
  String get tdesc_first_blood => 'أنهِ مباراتك الأولى';

  @override
  String get ttl_found_footing => 'ثبّت قدميك';

  @override
  String get tdesc_found_footing => 'أنهِ خمس مباريات';

  @override
  String get ttl_regular => 'منتظم';

  @override
  String get tdesc_regular => 'عشرون مباراة';

  @override
  String get ttl_fifty => 'الخمسون';

  @override
  String get tdesc_fifty => 'خمسون مباراة';

  @override
  String get ttl_century => 'المئوية';

  @override
  String get tdesc_century => 'مئة مباراة';

  @override
  String get ttl_veteran => 'مخضرم';

  @override
  String get tdesc_veteran => 'مئتان وخمسون مباراة';

  @override
  String get ttl_thousand_matches => 'الحرس القديم';

  @override
  String get tdesc_thousand_matches => 'ألف مباراة';

  @override
  String get ttl_first_win => 'فائز';

  @override
  String get tdesc_first_win => 'اربح مباراة';

  @override
  String get ttl_on_a_roll => 'في تصاعد';

  @override
  String get tdesc_on_a_roll => 'اربح ثلاثًا متتالية';

  @override
  String get ttl_five_straight => 'خمس متتالية';

  @override
  String get tdesc_five_straight => 'اربح خمسًا متتالية';

  @override
  String get ttl_unstoppable => 'لا يُوقَف';

  @override
  String get tdesc_unstoppable => 'اربح عشرًا متتالية';

  @override
  String get ttl_untouchable => 'لا يُمَس';

  @override
  String get tdesc_untouchable => 'اربح عشرين متتالية';

  @override
  String get ttl_giant_slayer => 'صائد العمالقة';

  @override
  String get tdesc_giant_slayer => 'اهزم من يعلوك برتبتين';

  @override
  String get ttl_comeback => 'عودة';

  @override
  String get tdesc_comeback => 'اربح مباشرة بعد ثلاث هزائم';

  @override
  String get ttl_nemesis => 'الخصم اللدود';

  @override
  String get tdesc_nemesis => 'اهزم اللاعب نفسه خمس مرات';

  @override
  String get ttl_hundred_reps => 'انطلاقة';

  @override
  String get tdesc_hundred_reps => 'مئة تكرار محتسَب';

  @override
  String get ttl_five_hundred => 'الإحماء';

  @override
  String get tdesc_five_hundred => 'خمسمئة تكرار محتسَب';

  @override
  String get ttl_the_machine => 'الآلة';

  @override
  String get tdesc_the_machine => 'ألف تكرار محتسَب';

  @override
  String get ttl_five_thousand => 'بلا هوادة';

  @override
  String get tdesc_five_thousand => 'خمسة آلاف تكرار محتسَب';

  @override
  String get ttl_ten_thousand => 'عشرة آلاف';

  @override
  String get tdesc_ten_thousand => 'عشرة آلاف تكرار محتسَب';

  @override
  String get ttl_fifty_thousand => 'ما بعد العدّ';

  @override
  String get tdesc_fifty_thousand => 'خمسون ألف تكرار محتسَب';

  @override
  String get ttl_first_tonne => 'طن واحد';

  @override
  String get tdesc_first_tonne => 'ارفع ألف كيلوغرام إجمالًا';

  @override
  String get ttl_ten_tonnes => 'عشرة أطنان';

  @override
  String get tdesc_ten_tonnes => 'ارفع عشرة آلاف كيلوغرام';

  @override
  String get ttl_six_figures => 'ستة أرقام';

  @override
  String get tdesc_six_figures => 'ارفع مئة ألف كيلوغرام';

  @override
  String get ttl_half_million => 'نصف مليون';

  @override
  String get tdesc_half_million => 'ارفع خمسمئة ألف كيلوغرام';

  @override
  String get ttl_million_kg => 'نادي المليون';

  @override
  String get tdesc_million_kg => 'ارفع مليون كيلوغرام';

  @override
  String get ttl_two_days => 'عدتَ ثانيةً';

  @override
  String get tdesc_two_days => 'تدرّب يومين متتاليين';

  @override
  String get ttl_no_days_off => 'بلا أيام راحة';

  @override
  String get tdesc_no_days_off => 'تدرّب سبعة أيام متتالية';

  @override
  String get ttl_fortnight => 'أسبوعان';

  @override
  String get tdesc_fortnight => 'سلسلة أربعة عشر يومًا';

  @override
  String get ttl_unbroken => 'غير منقطع';

  @override
  String get tdesc_unbroken => 'سلسلة ثلاثين يومًا';

  @override
  String get ttl_sixty_days => 'عادة';

  @override
  String get tdesc_sixty_days => 'سلسلة ستين يومًا';

  @override
  String get ttl_hundred_days => 'مئة يوم';

  @override
  String get tdesc_hundred_days => 'سلسلة مئة يوم';

  @override
  String get ttl_year_round => 'على مدار العام';

  @override
  String get tdesc_year_round => 'سلسلة ثلاثمئة وخمسة وستين يومًا';

  @override
  String get ttl_perfect_week => 'أسبوع مثالي';

  @override
  String get tdesc_perfect_week => 'تدرّب كل يوم من أيام أسبوع';

  @override
  String get ttl_perfect_month => 'شهر مثالي';

  @override
  String get tdesc_perfect_month => 'أربعة أسابيع مثالية';

  @override
  String get ttl_bronze_tier => 'خروج من الحديد';

  @override
  String get tdesc_bronze_tier => 'ابلغ رتبة البرونز';

  @override
  String get ttl_silver_tier => 'فضّي';

  @override
  String get tdesc_silver_tier => 'ابلغ رتبة الفضة';

  @override
  String get ttl_golden_era => 'العصر الذهبي';

  @override
  String get tdesc_golden_era => 'ابلغ رتبة الذهب';

  @override
  String get ttl_platinum_tier => 'البلاتين';

  @override
  String get tdesc_platinum_tier => 'ابلغ رتبة البلاتين';

  @override
  String get ttl_diamond_tier => 'قبضة ماسية';

  @override
  String get tdesc_diamond_tier => 'ابلغ رتبة الماس';

  @override
  String get ttl_master_tier => 'المُعلِّم';

  @override
  String get tdesc_master_tier => 'ابلغ رتبة المُعلِّم';

  @override
  String get ttl_clean_hands => 'أداء نظيف';

  @override
  String get tdesc_clean_hands => 'مجموعة كاملة بكل تكراراتها محتسَبة';

  @override
  String get ttl_spotless => 'بلا شائبة';

  @override
  String get tdesc_spotless => 'عشر مجموعات نظيفة';

  @override
  String get ttl_textbook => 'وفق الكتاب';

  @override
  String get tdesc_textbook => 'خمسون مجموعة نظيفة';

  @override
  String get ttl_all_rounder => 'شامل';

  @override
  String get tdesc_all_rounder => 'احتسِب خمسة تمارين مختلفة';

  @override
  String get ttl_explorer => 'مستكشف';

  @override
  String get tdesc_explorer => 'احتسِب خمسة عشر تمرينًا مختلفًا';

  @override
  String get ttl_encyclopedia => 'موسوعة';

  @override
  String get tdesc_encyclopedia => 'احتسِب أربعين تمرينًا مختلفًا';

  @override
  String get ttl_early_bird => 'الوردية المبكرة';

  @override
  String get tdesc_early_bird => 'عشر جلسات قبل السابعة صباحًا';

  @override
  String get ttl_sunrise_club => 'نادي الشروق';

  @override
  String get tdesc_sunrise_club => 'خمسون جلسة قبل السابعة';

  @override
  String get ttl_night_owl => 'الوردية الليلية';

  @override
  String get tdesc_night_owl => 'عشر جلسات بعد العاشرة ليلًا';

  @override
  String get ttl_graveyard => 'وردية الفجر';

  @override
  String get tdesc_graveyard => 'خمسون جلسة بعد العاشرة';

  @override
  String get ttl_not_alone => 'لستَ وحدك';

  @override
  String get tdesc_not_alone => 'أضف صديقك الأول';

  @override
  String get ttl_well_connected => 'واسع الصلات';

  @override
  String get tdesc_well_connected => 'عشرة أصدقاء';

  @override
  String get ttl_the_gym_knows => 'الجيم يعرفك';

  @override
  String get tdesc_the_gym_knows => 'خمسون صديقًا';

  @override
  String get forfeitQ => 'الانسحاب من المباراة؟';

  @override
  String get forfeitBody => 'ستخسر نقاطًا إذا غادرت الآن.';

  @override
  String get stay => 'ابقَ';

  @override
  String get forfeit => 'انسحاب';

  @override
  String get getReady => 'استعد';

  @override
  String get you => 'أنت';

  @override
  String get vs => 'ضد';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String get mgChest => 'الصدر';

  @override
  String get mgBack => 'الظهر';

  @override
  String get mgLegs => 'الأرجل';

  @override
  String get mgShoulders => 'الأكتاف';

  @override
  String get mgArms => 'الذراعان';

  @override
  String get mgCore => 'الجذع';

  @override
  String get nWonTitle => 'لقد فزت!';

  @override
  String nWonBody(String name, String muscle) {
    return 'هزمت $name في يوم $muscle';
  }

  @override
  String get nFriendTitle => 'طلب صداقة جديد';

  @override
  String get nRacedTitle => 'حد سابق مجموعتك';

  @override
  String nRacedHeld(String name, String yours, String theirs) {
    return '$name سابق مجموعتك وما لحقش، $yours–$theirs';
  }

  @override
  String nRacedBeaten(String name, String theirs, String yours) {
    return '$name سابق مجموعتك وكسب، $theirs–$yours';
  }

  @override
  String get nFriendOkTitle => 'اتقبل طلب الصداقة';

  @override
  String nFriendOkBody(String name) {
    return '$name قبل طلبك';
  }

  @override
  String nFriendBody(String name) {
    return '$name يريد التواصل معك';
  }

  @override
  String get nChallengedTitle => 'مباراة ثأرية';

  @override
  String nChallengedBody(String name) {
    return '$name يريد مباراة ثأرية معك';
  }

  @override
  String get challengeSentTitle => 'تم إرسال التحدي';

  @override
  String challengeSentBody(String name) {
    return 'سنخبر $name. عد بعد أن يخوض التحدي.';
  }

  @override
  String get challengeNotSentTitle => 'تعذر الإرسال';

  @override
  String get challengeNotSentBody =>
      'تحقق من اتصالك وحاول مرة أخرى من تبويب المباريات.';

  @override
  String get challengeGoneTitle => 'التحدي لم يعد متاحًا';

  @override
  String get challengeGoneBody => 'خِيض بالفعل، أو تم سحبه.';

  @override
  String repsRecordedLine(String reps) {
    return 'تم تسجيل $reps عدة';
  }

  @override
  String get nAchTitle => 'أنجزت إنجازًا';

  @override
  String nAchBody(String title, String hint) {
    return '$title — $hint';
  }

  @override
  String get nRankTitle => 'ترقيت!';

  @override
  String nRankBody(String rank) {
    return 'وصلت إلى $rank';
  }

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String daysAgo(String n) {
    return 'من $n يوم';
  }

  @override
  String weeksAgo(String n) {
    return 'منذ $n أسابيع';
  }

  @override
  String lpAmount(String n) {
    return '$n نقطة';
  }

  @override
  String get lpUnit => 'نقطة';

  @override
  String get trueCountHint => 'مثلاً 12';

  @override
  String get couldNotSaveSession => 'معرفناش نحفظ الجلسة';

  @override
  String lpOutOf(String total) {
    return '/ $total نقطة';
  }

  @override
  String get noFriendsTitle => 'لا أصدقاء بعد';

  @override
  String get noFriendsBody => 'للمنازلة مع شخص تعرفه طعم آخر.';

  @override
  String get addFriend => 'إضافة';

  @override
  String get decline => 'رفض';

  @override
  String requestSent(String name) {
    return 'أُرسل الطلب إلى $name';
  }

  @override
  String nowFriends(String name) {
    return 'أصبحت أنت و$name صديقين';
  }

  @override
  String get noOneFound => 'لا أحد بهذا الاسم';

  @override
  String get noMatchesTitle => 'لا مباريات بعد';

  @override
  String get noMatchesBody => 'ستظهر أول مباراة هنا، فزتَ أم خسرت.';

  @override
  String get noNotificationsTitle => 'لا جديد';

  @override
  String get noNotificationsBody =>
      'تصلك هنا دعوات المباريات ونتائجها وطلبات الصداقة.';

  @override
  String get countedThat => 'احتُسبت هذه الجولة';

  @override
  String get thatIsRight => 'هذا صحيح';

  @override
  String get useMyCount => 'استخدم رقمي';

  @override
  String get confirmHint => 'غيّره إن أخطأت الكاميرا.';

  @override
  String get unsureMovement =>
      'لسنا واثقين أن هذه هي الحركة المطلوبة — راجع الرقم.';

  @override
  String get local => 'محلي';

  @override
  String get weekly => 'أسبوعي';

  @override
  String get seasonTab => 'الموسم';

  @override
  String get allTime => 'كل الأوقات';

  @override
  String get daily => 'يومي';

  @override
  String get noRanksYet => 'لا ترتيب بعد';

  @override
  String get noRanksYetBody => 'العب مباراة وسيمتلئ الجدول.';

  @override
  String get ranksTitle => 'الترتيب';

  @override
  String get totalReps => 'إجمالي التكرارات';

  @override
  String get recent => 'الأخيرة';

  @override
  String wonVs(String name) {
    return 'فزت على $name';
  }

  @override
  String lostVs(String name) {
    return 'خسرت أمام $name';
  }

  @override
  String hoursAgo(String n) {
    return 'قبل $n ساعة';
  }

  @override
  String toNextTier(String n, String tier) {
    return '$n لـ $tier';
  }

  @override
  String get noMatchesYet => 'لا مواجهات بعد';

  @override
  String get noMatchesYetBody => 'ستظهر أول مواجهة هنا، فزتَ أم خسرت.';

  @override
  String get searchByUsername => 'ابحث باسم المستخدم';

  @override
  String get incomingRequests => 'طلبات واردة';

  @override
  String get noRequestsWaiting => 'مفيش طلبات مستنية دلوقتي';

  @override
  String get addFriendAction => 'إضافة صديق';

  @override
  String get addFriendHint =>
      'اكتب اليوزر نيم بتاعهم، أو الكود اللي رقمه # من البروفايل بتاعهم.';

  @override
  String get usernameOrCode => 'اليوزر نيم أو #الكود';

  @override
  String get sendRequest => 'إرسال الطلب';

  @override
  String onlineNowCount(String count) {
    return 'متصل الآن · $count';
  }

  @override
  String offlineCount(String count) {
    return 'غير متصل · $count';
  }

  @override
  String get invite => 'ادعُه';

  @override
  String get headToHeadTitle => 'السجل بينكم';

  @override
  String get vsYouCaption => 'ضدك';

  @override
  String get h2hYou => 'أنت';

  @override
  String get h2hThem => 'هو';

  @override
  String headToHead(String wins, String losses) {
    return '$wins فوز $losses خسارة ضدك';
  }

  @override
  String get neverPlayedYou => 'لم يلعب ضدك من قبل';

  @override
  String noHistoryWithThem(String username) {
    return 'لسه ملعبتش ضد $username.';
  }

  @override
  String lastDuelScore(String yourReps, String theirReps, String when) {
    return 'آخر مرة: $yourReps–$theirReps، $when.';
  }

  @override
  String yourBestVsThemLine(String reps) {
    return 'أحسن نتيجة ليك ضده $reps.';
  }

  @override
  String get viewFullProfile => 'شوف البروفايل كامل';

  @override
  String get moreOptions => 'خيارات أكتر';

  @override
  String get block => 'حظر';

  @override
  String get blockRowBody => 'مش هيقدر يتحداك ولا يشوف بروفايلك';

  @override
  String get report => 'بلاغ';

  @override
  String get reportRowBody => 'بيتراجع خلال 24 ساعة';

  @override
  String muteChallenges(String username) {
    return 'كتم تحديات $username';
  }

  @override
  String blockedLifter(String username) {
    return 'اتحظر $username';
  }

  @override
  String mutedLifter(String username) {
    return 'اتكتم $username';
  }

  @override
  String get addFriendButton => 'إضافة صديق';

  @override
  String get alreadyFriends => 'أصدقاء';

  @override
  String get couldNotLoadProfile => 'معرفناش نحمّل البروفايل ده';

  @override
  String get noFriendsMatch => 'لا أحد بهذا الاسم';

  @override
  String get yourClimb => 'صعودك';

  @override
  String floorKept(String tier, String rank) {
    return '$tier أصبحت لك. لن تنزل عن $rank.';
  }

  @override
  String dayStreakCount(String count) {
    return '$count يوم متتالي';
  }

  @override
  String get findMatch => 'ابحث عن مباراة';

  @override
  String rankedTerms(String seconds) {
    return '$seconds ثانية · مصنفة';
  }

  @override
  String get practiceTerms => 'تدريب — بلا تصنيف وبلا خصم';

  @override
  String get practiceComplete => 'انتهى التدريب';

  @override
  String get findPeople => 'ابحث عن ناس';

  @override
  String get noRankYet => 'لا تصنيف بعد';

  @override
  String placementsForFirstTier(String count) {
    return 'أكمل $count مباريات تحديد لتحصل على تصنيفك الأول.';
  }

  @override
  String get startPlacements => 'ابدأ مباريات التحديد';

  @override
  String get unranked => 'بلا تصنيف';

  @override
  String placementsTerms(String done, String total, String seconds) {
    return '$done من $total · $seconds ثانية لكل واحدة';
  }

  @override
  String placementsLeft(String done, String total, String left) {
    return '$done من $total · يتبقى $left لتحصل على تصنيفك';
  }

  @override
  String placementsForTier(String count) {
    return 'أكمل $count مباريات تحديد لتعرف تصنيفك.';
  }

  @override
  String placementsDoneCount(String done, String total) {
    return '$done من $total مباريات تحديد';
  }

  @override
  String get practiceFirst => 'تدرّب أولًا';

  @override
  String get nextPlacement => 'التحديد التالي';

  @override
  String get noConnection => 'لا اتصال';

  @override
  String get practiceOffline => 'تدرّب دون اتصال';

  @override
  String get retry => 'أعد المحاولة';

  @override
  String get youWonPlain => 'فزت';

  @override
  String opponentDisconnected(String name) {
    return '$name انقطع اتصاله';
  }

  @override
  String get forfeitNoMargin => 'انسحاب · لا يُحتسب الفارق';

  @override
  String get findAnotherMatch => 'ابحث عن مباراة أخرى';

  @override
  String get cameraNeededTitle => 'نحتاج إلى الكاميرا';

  @override
  String get cameraNeededBody =>
      'يَعُدّ OUTREPD تكراراتك بمتابعة حركة جسمك. يجري التحليل على جهازك، ولا يُرفع منه شيء.';

  @override
  String get openSettings => 'افتح الإعدادات';

  @override
  String get allowCamera => 'اسمح بالكاميرا';

  @override
  String get notNow => 'ليس الآن';

  @override
  String get noCameraTitle => 'لا كاميرا';

  @override
  String get noCameraBody =>
      'يعتمد العدّ على الكاميرا، فلا يستطيع هذا الجهاز خوض مباراة. أما بقية التطبيق فتعمل كالمعتاد.';

  @override
  String get noConnectionBody =>
      'تحتاج إلى اتصال لتنافس. أما التدريب فيعمل دون اتصال، وتُزامَن تكراراتك لاحقًا.';

  @override
  String get getBackInFrame => 'عُد أمام الكاميرا';

  @override
  String get clockStillRunning => 'الوقت ما زال يمضي، والتكرارات لا تُحتسب.';

  @override
  String get giveUp => 'انسحاب';

  @override
  String lpSwing(String gain, String loss) {
    return '+$gain / −$loss نقطة';
  }

  @override
  String get lpMovesWithGap =>
      'النقط بتتحرك مع فرق العدات — كل ما تفوز بفرق أكبر تكسب أكتر';

  @override
  String get searchingForOpponent => 'جارٍ البحث عن منافس';

  @override
  String get getIntoPosition => 'خذ وضعيتك';

  @override
  String get framingHint => 'يجب أن يظهر الرسغان والكاحلان';

  @override
  String get goUp => 'اصعد';

  @override
  String get goDown => 'انزل';

  @override
  String get bestSet => 'أفضل مجموعة';

  @override
  String get record => 'السجل';

  @override
  String get last7Days => 'آخر ٧ أيام';

  @override
  String repsCount(String count) {
    return '$count تكرار';
  }

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get shareProfile => 'شارك الملف';

  @override
  String get share => 'مشاركة';

  @override
  String get duelMeOnOutrepd => 'تحداني على outrepd';

  @override
  String get yourRankCard => 'كارت الرانك بتاعك';

  @override
  String get shareStory => 'ستوري';

  @override
  String get sharePost => 'بوست';

  @override
  String get copyLink => 'نسخ';

  @override
  String get linkCopied => 'اتنسخ اللينك';

  @override
  String get currentRankLabel => 'الرانك الحالي';

  @override
  String get winInitial => 'ف';

  @override
  String get lossInitial => 'خ';

  @override
  String get dayInitial => 'ي';

  @override
  String rankPosition(String n) {
    return '#$n';
  }

  @override
  String get obTagline => 'منازلات ضغط. هاتفك يَعُدّ. وهناك من يَعُدّ أيضًا.';

  @override
  String get obGetStarted => 'لنبدأ';

  @override
  String get obHaveAccount => 'لديّ حساب بالفعل';

  @override
  String get obHowTitle => 'ثلاثة أمور، ثم تبدأ.';

  @override
  String get obHow1 => 'ضع هاتفك على الأرض';

  @override
  String get obHow1Body => 'أسنده إلى حائط على بُعد متر أمامك.';

  @override
  String get obHow2 => 'الكاميرا تَعُدّ تكراراتك';

  @override
  String get obHow2Body => 'يُقاس عمق كل تكرار، والتكرار الناقص لا يُحتسب.';

  @override
  String get obHow3 => 'ستون ثانية أمام منافس';

  @override
  String get obHow3Body => 'تفوز فترتقي، وتخسر فتهبط. القواعد نفسها للجميع.';

  @override
  String get obTwoThings => 'أمران سريعان.';

  @override
  String get obAgeQuestion => 'كم عمرك؟';

  @override
  String get obUnder16 => 'أقل من ١٦';

  @override
  String get obOver16 => '١٦ أو أكثر';

  @override
  String get obHealthConsent =>
      'أفهم أن OUTREPD يَعُدّ التكرارات ولا يقدّم نصائح طبية أو تدريبية، وسأتوقف إذا شعرت بألم.';

  @override
  String get obTermsIntro => 'بمتابعتك فإنك توافق على';

  @override
  String get obTerms => 'الشروط';

  @override
  String get obAnd => 'و';

  @override
  String get obPrivacy => 'سياسة الخصوصية';

  @override
  String get obUnder16Blocked =>
      'OUTREPD لمن بلغ السادسة عشرة فأكثر. عُد إلينا حين تبلغها، فتمارين الضغط لن تذهب إلى أي مكان.';

  @override
  String get obCameraTitle => 'يحتاج OUTREPD إلى الكاميرا';

  @override
  String get obCameraBody => 'يتابع حركة جسمك ليَعُدّ، ولا سبيل آخر إلى ذلك.';

  @override
  String get obCameraPrivateTitle => 'لا شيء يغادر هاتفك';

  @override
  String get obCameraPrivateBody =>
      'يجري تتبّع الجسم على هذا الجهاز، ولا يُرفع أي مقطع إلا إذا اخترت نشره بنفسك.';

  @override
  String get obWhyNeeded => 'لماذا نحتاج إليها؟';

  @override
  String get obPlacementTitle => 'ضع هاتفك على الأرض';

  @override
  String get obPlacementBody => 'أسنده إلى حائط على بُعد متر تقريبًا أمامك.';

  @override
  String get obOneMetre => '~١ م';

  @override
  String get obFullBody => 'الجسم كله داخل الإطار';

  @override
  String get obCheckHandsFeet => 'اليدان والقدمان ظاهرتان';

  @override
  String get obCheckFacing => 'مواجهًا الهاتف لا جانبيًا';

  @override
  String get obCheckLight => 'الغرفة مضاءة';

  @override
  String get obImSetUp => 'أنا جاهز';

  @override
  String get obFramingTitle => 'خذ وضعية الضغط';

  @override
  String get obFramingShoulders => 'الكتفان والوركان';

  @override
  String get obFramingWrists => 'الرسغان';

  @override
  String get obFramingAnkles => 'الكاحلان';

  @override
  String get obLooksGood => 'الوضع سليم';

  @override
  String get obCalibrating => 'جارٍ المعايرة';

  @override
  String get obOneMoreRep => 'تكرار آخر لمعرفة مداك';

  @override
  String get obCalibrationHint => 'أدِّ ثلاثة تكرارات بعمقك المعتاد';

  @override
  String get obCalibrated => 'تمت المعايرة.';

  @override
  String get obCalibratedBody =>
      'بات OUTREPD يعرف مداك، والعمق يُقاس عليك أنت لا على رقم ثابت.';

  @override
  String get obRepsCounted => 'التكرارات المحتسَبة';

  @override
  String get obAverageDepth => 'متوسط العمق';

  @override
  String get obForm => 'الأداء';

  @override
  String get obFormClean => 'نظيف';

  @override
  String get obCreateAccountBody =>
      'أنشئ حسابًا لتحتفظ بتكراراتك ورتبتك وسجلك.';

  @override
  String get obSaveProgress => 'احفظ تقدمي';

  @override
  String obSaveYourReps(String count) {
    return 'احفظ تكراراتك البالغة $count';
  }

  @override
  String get obOneTap => 'بريد إلكتروني وكلمة مرور، وخلاص.';

  @override
  String get obContinueApple => 'المتابعة عبر Apple';

  @override
  String get obContinueGoogle => 'المتابعة عبر Google';

  @override
  String get obContinueEmail => 'المتابعة عبر البريد الإلكتروني';

  @override
  String get obSignInFootnote =>
      'نستخدمه للحفاظ على حسابك فقط، ولا ننشر عنك شيئًا.';

  @override
  String get obPickName => 'اختر اسمًا';

  @override
  String get obPickNameBody => 'هذا ما يراه منافسوك، ويمكنك تغييره لاحقًا.';

  @override
  String get obAvailable => 'متاح';

  @override
  String get obTaken => 'محجوز';

  @override
  String get obYourAvatar => 'صورتك';

  @override
  String get obAddPhoto => 'أضف صورة';

  @override
  String get obPlacementsBody =>
      'خمس مباريات تحدّد رتبتك الأولى، ولا شيء يُحتسب عليك بعد.';

  @override
  String get obFindFirstOpponent => 'ابحث عن منافسي الأول';

  @override
  String get obGotIt => 'فهمت';

  @override
  String get obFormMixed => 'متفاوت';

  @override
  String get obWelcomeBack => 'أهلًا بعودتك';

  @override
  String get obWelcomeBackBody => 'سجّل الدخول ببريدك الإلكتروني وكلمة المرور.';

  @override
  String get justNow => 'الآن';

  @override
  String get counterAccuracy => 'دقة العدّاد';

  @override
  String get counterAccuracyCaption => 'إلى أي حد تصيب الكاميرا';

  @override
  String measuredOverSets(String count) {
    return 'مقيسة على $count مجموعة';
  }

  @override
  String get accExact => 'مطابق';

  @override
  String get accWithinOne => 'بفارق تكرار';

  @override
  String get accAverageMiss => 'متوسط الخطأ';

  @override
  String get accTendsTo => 'يميل إلى';

  @override
  String get accCountsHigh => 'العدّ بالزيادة';

  @override
  String get accCountsLow => 'العدّ بالنقصان';

  @override
  String get accCountsEven => 'لا زيادة ولا نقصان';

  @override
  String get accWorstMiss => 'أكبر خطأ';

  @override
  String get accNothingYet => 'لا قياس بعد';

  @override
  String get accNothingYetBody =>
      'في كل مرة تؤكّد العدد بعد مباراة، تُقاس تلك المجموعة على ما ذكرته أنت، ويظهر الرقم هنا.';

  @override
  String accNeedMore(String count) {
    return 'البداية مبكرة. نحتاج نحو $count مجموعة أخرى ليصبح لهذا الرقم معنى.';
  }

  @override
  String get accRecentSets => 'أحدث المجموعات';

  @override
  String get accCameraSaid => 'الكاميرا';

  @override
  String get accYouSaid => 'أنت';

  @override
  String get accHowItWorks =>
      'هذه بياناتك أنت، على هذا الهاتف، ولا يُرسل منها شيء إلى أي جهة.';

  @override
  String levelNumber(String n) {
    return 'المستوى $n';
  }

  @override
  String get youLostPlain => 'خسرت';

  @override
  String get rematch => 'مباراة ثأرية';

  @override
  String get shareAction => 'مشاركة';

  @override
  String get doneAction => 'تم';

  @override
  String get continueAction => 'متابعة';

  @override
  String get lpRowWin => 'فوز';

  @override
  String get lpRowLoss => 'خسارة';

  @override
  String get lpRowOpponent => 'رتبة المنافس';

  @override
  String get lpRowMargin => 'الفارق';

  @override
  String get lpRowDepth => 'العمق';

  @override
  String get promotedLabel => 'ترقية';

  @override
  String get highestReached => 'أعلى ما بلغته';

  @override
  String repsOff(String n) {
    return 'بفارق $n تكرارًا.';
  }

  @override
  String get closestYet => 'أقرب مباراة حتى الآن.';

  @override
  String repsAhead(String n) {
    return 'بفارق $n تكرارًا.';
  }

  @override
  String get winnerLabel => 'الفائز';

  @override
  String get newPersonalBest => 'رقمك القياسي الجديد';

  @override
  String get cantReachServer =>
      'تعذّر الوصول إلى الخادم. تأكد من اتصالك وحاول مرة أخرى.';

  @override
  String pushUpsInSeconds(String seconds) {
    return 'ضغطة في $seconds ثانية';
  }

  @override
  String beatOpponent(String name, String score) {
    return 'فزت على $name $score';
  }

  @override
  String lostToOpponent(String name, String score) {
    return 'خسرت أمام $name $score';
  }

  @override
  String get thinkYouCanBeatMe => 'هل تظن أنك تستطيع هزيمتي؟';

  @override
  String get usernameNotAllowed => 'الاسم ده مش مسموح. جرّب اسم تاني.';

  @override
  String get yourBest => 'أحسن رقم ليك';

  @override
  String get theClock => 'الساعة';

  @override
  String get nobodyFreeRaceBest =>
      'مفيش حد قريب من رتبتك فاضي دلوقتي. العب ضد أحسن رقم ليك. الماتش ده مش هيغيّر رتبتك.';

  @override
  String get nobodyFreeFirstScore =>
      'مفيش حد قريب من رتبتك فاضي دلوقتي. سجّل أول رقم ليك. الماتش ده مش هيغيّر رتبتك.';

  @override
  String bestStillIs(String count) {
    return 'أحسن رقم ليك لسه $count';
  }

  @override
  String get setInPoolTitle => 'السِت بتاعك اتحفظ';

  @override
  String get setInPoolBody =>
      'أول لاعب قريب من رتبتك هيلعب ضده. هتشوف مين كسب في الإشعارات، ورتبتك هتتحرك ساعتها.';

  @override
  String get paywallTitle => 'اصعد من الحديد إلى المُعلِّم';

  @override
  String get paywallPerkDuels => 'نزالات تحكمها الكاميرا';

  @override
  String get paywallPerkLadder => 'تصنيف مباشر';

  @override
  String get paywallPerkFriends => 'الأصدقاء والتحديات';

  @override
  String get paywallPerkHistory => 'كل تكرار في كل مباراة';

  @override
  String get paywallYearly => 'سنوي';

  @override
  String get paywallWeekly => 'أسبوعي';

  @override
  String paywallPerWeek(String price) {
    return '${price} في الأسبوع';
  }

  @override
  String get paywallEveryWeek => 'في الأسبوع';

  @override
  String paywallSave(String percent) {
    return 'وفّر ${percent}٪';
  }

  @override
  String get paywallStart => 'ابدأ الصعود';

  @override
  String get paywallRenewsPlay => 'يتجدد تلقائيًا حتى تلغيه. يمكنك الإلغاء في أي وقت من Google Play.';

  @override
  String get paywallRenewsApple => 'يتجدد تلقائيًا حتى تلغيه. يمكنك الإلغاء في أي وقت من إعدادات حساب Apple.';

  @override
  String get paywallRestore => 'استعادة';

  @override
  String get paywallTerms => 'الشروط';

  @override
  String get paywallPrivacy => 'الخصوصية';

  @override
  String get paywallLoadFailed => 'تعذّر تحميل الخطط. تأكد من اتصالك وحاول مرة أخرى.';

  @override
  String get paywallBuyFailed => 'لم تكتمل عملية الشراء. حاول مرة أخرى.';

  @override
  String get paywallPending => 'دفعتك قيد المعالجة. سيُفتح كل شيء فور تأكيد المتجر.';

  @override
  String get paywallNothingToRestore => 'لم يُعثر على اشتراك لاستعادته.';

  @override
  String get paywallRestored => 'تمت استعادة الاشتراك';

  @override
  String paywallSignedInAs(String email) {
    return 'مسجّل الدخول باسم ${email}';
  }
}
