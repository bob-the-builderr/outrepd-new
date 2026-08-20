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
  String get tabCrew => 'الفريق';

  @override
  String get tabProfile => 'حسابي';

  @override
  String get searchOpponent => 'ابحث عن خصم';

  @override
  String get searchOpponentHint => 'سنجد لك منافسًا في رتبتك';

  @override
  String get challengeFriend => 'تحدَّ صديقًا';

  @override
  String get trainWithCamera => 'تدرَّب بالكاميرا';

  @override
  String get viewRoadmap => 'اعرض خارطة الطريق';

  @override
  String lpProgress(String lp, String left) {
    return '$lp / ١٠٠ نقطة · يتبقى $left للترقية';
  }

  @override
  String winStreak(String count) {
    return '$count انتصارات متتالية';
  }

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
  String get profile => 'الملف الشخصي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get stats => 'الإحصائيات';

  @override
  String get edit => 'تعديل';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get skip => 'تخطٍّ';

  @override
  String get totalMatches => 'إجمالي المباريات';

  @override
  String get bestWinStreak => 'أطول سلسلة انتصارات';

  @override
  String get totalVolume => 'إجمالي الأوزان المرفوعة';

  @override
  String get height => 'الطول';

  @override
  String get bodyweight => 'وزن الجسم';

  @override
  String get age => 'العمر';

  @override
  String get editYourStats => 'تعديل بياناتك';

  @override
  String get editStatsHint =>
      'الانتصارات والأوزان المرفوعة والرتبة تُكتسب بالأداء، ولا تُدخَل يدويًا.';

  @override
  String get changeName => 'تغيير الاسم';

  @override
  String get changeNameLast =>
      'هذه آخر مرة يمكنك التغيير فيها، ولا رجعة بعدها.';

  @override
  String changeNameLeft(String total, String left) {
    return 'لديك $total تغييرات إجمالًا، ويتبقى $left بعد هذا التغيير.';
  }

  @override
  String get changeNameUsedUp => 'لقد استنفدت تغييري الاسم المتاحين لك';

  @override
  String get yourPicture => 'صورتك';

  @override
  String get yourPictureHint => 'الإطار مستمد من رتبتك، ويتغير كلما ارتقيت.';

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
  String titlesAndStreak(String owned, String total, String streak) {
    return '$owned من $total لقبًا · سلسلة $streak يومًا';
  }

  @override
  String get crew => 'الفريق';

  @override
  String get myCrew => 'فريقي';

  @override
  String get rankings => 'الترتيب';

  @override
  String get trainWithCrew => 'تدرَّب ضمن فريق';

  @override
  String get trainWithCrewHint =>
      'حتى عشرين لاعبًا تحت اسم واحد، يسعون إلى هدف أسبوعي مشترك ويرتقون في جدول الفرق.';

  @override
  String get createCrew => 'أنشئ فريقًا';

  @override
  String get createCrewHint => 'سمِّه، واختر شعاره، وادعُ من تشاء';

  @override
  String get joinOpenCrew => 'انضم إلى فريق مفتوح';

  @override
  String get joinOpenCrewHint => 'فرق تقبل انضمام الجميع';

  @override
  String get yourInvites => 'دعواتك';

  @override
  String get yourInvitesHint => 'فرق طلبت انضمامك';

  @override
  String get joinWithCode => 'انضم برمز';

  @override
  String get joinWithCodeHint => 'ستة أحرف من أحد الأعضاء';

  @override
  String get topCrewsThisWeek => 'أفضل الفرق هذا الأسبوع';

  @override
  String get members => 'الأعضاء';

  @override
  String get repsEach => 'تكرارات لكل فرد';

  @override
  String get rank => 'المركز';

  @override
  String get weeklyGoal => 'الهدف الأسبوعي';

  @override
  String get weeklyGoalDone => 'تحقق الهدف الأسبوعي';

  @override
  String goalRemaining(String reps, String days) {
    return 'يتبقى $reps تكرارًا · و$days أيام';
  }

  @override
  String get goalDoneHint => 'يحصل الجميع على الشارة عند انتهاء الأسبوع.';

  @override
  String get startCrewWar => 'ابدأ مواجهة بين فريقين';

  @override
  String get startCrewWarHint =>
      'سبعة أيام، والفريقان يَعُدَّان. يفوز الأعلى في متوسط التكرارات لكل فرد.';

  @override
  String get whoIsPulling => 'من يقود الفريق';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get inviteLifters => 'ادعُ لاعبين';

  @override
  String get referralCode => 'رمز الدعوة';

  @override
  String get inviteLink => 'رابط الدعوة';

  @override
  String get leaveCrew => 'مغادرة الفريق';

  @override
  String get owner => 'المالك';

  @override
  String get crewTable => 'جدول الفرق';

  @override
  String get repsPerMember => 'تكرارات لكل عضو';

  @override
  String seasonResets(String days) {
    return 'يُعاد الضبط بعد $days يومًا، ويبدأ الجميع من النقطة ذاتها';
  }

  @override
  String get rankingExplained =>
      'تُرتَّب الفرق بمتوسط التكرارات لكل عضو لا بمجموعها، حتى لا يفوز الفريق الأكبر بعدد أفراده وحده.';

  @override
  String get leaderboard => 'لوحة الصدارة';

  @override
  String get global => 'عالميًا';

  @override
  String get myCountry => 'بلدي';

  @override
  String yourFriends(String count) {
    return 'أصدقاؤك ($count)';
  }

  @override
  String get challenge => 'تحدٍّ';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get pickMovement => 'اختر تمرينًا';

  @override
  String get anyExercise => 'أي تمرين';

  @override
  String get anyExerciseHint => 'ابدأ مجموعتك، وسيتعرف على الحركة أثناء أدائك';

  @override
  String get start => 'ابدأ';

  @override
  String get finish => 'إنهاء';

  @override
  String get reps => 'تكرار';

  @override
  String get secondsHeld => 'ثانية ثبات';

  @override
  String get learningMovement => 'جارٍ تعلُّم حركتك، وستظهر تكراراتك بعد لحظات';

  @override
  String get recalibrate => 'إعادة المعايرة';

  @override
  String get resetCount => 'تصفير العدّاد';

  @override
  String get checksForm => 'يتحقق من الأداء';

  @override
  String get counts => 'يَعُدّ';

  @override
  String get time => 'توقيت';

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
  String get darkMode => 'الوضع الداكن';

  @override
  String get language => 'اللغة';

  @override
  String get units => 'الوحدات';

  @override
  String get weight => 'الوزن';

  @override
  String get notificationsSection => 'الإشعارات';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get matches => 'المباريات';

  @override
  String get data => 'البيانات';

  @override
  String get about => 'حول التطبيق';

  @override
  String get dangerZone => 'منطقة الإجراءات الحساسة';

  @override
  String get themeSystem => 'حسب الجهاز';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get openCrews => 'الفرق المفتوحة';

  @override
  String get openCrewsHint =>
      'هذه الفرق تقبل الجميع. اختر واحدًا لتنضم إليه مباشرة.';

  @override
  String get yourInvitesSubtitle => 'فرق طلبت انضمامك بالاسم.';

  @override
  String get pickOpponent => 'اختر خصمك';

  @override
  String get accept => 'قبول';

  @override
  String get join => 'انضمام';

  @override
  String get copy => 'نسخ';

  @override
  String get copied => 'تم نسخ رابط الدعوة';

  @override
  String season(String name) {
    return 'موسم $name';
  }

  @override
  String challengeSent(String name) {
    return 'أُرسل التحدي إلى $name';
  }

  @override
  String get inviteFriendPrivate => 'ادعُ صديقًا إلى مباراة خاصة';

  @override
  String get joinWithCodePaste =>
      'الصق الأحرف الستة التي أرسلها إليك أحد الأعضاء.';

  @override
  String get enterTheCode => 'أدخل الرمز المكوَّن من ستة أحرف';

  @override
  String get followingDevice => 'يتبع إعداد جهازك حاليًا';

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
  String get visEveryoneHint => 'يستطيع أي شخص فتح ملفك الشخصي';

  @override
  String get visFriendsHint => 'اللاعبون الذين أضفتهم فقط';

  @override
  String get visNobodyHint => 'يبقى ملفك الشخصي خاصًا';

  @override
  String get matchInvites => 'دعوات المباريات';

  @override
  String get matchResults => 'نتائج المباريات';

  @override
  String get friendRequestsLabel => 'طلبات الصداقة';

  @override
  String get crewActivity => 'نشاط الفريق';

  @override
  String get rankChanges => 'تغيّر الرتبة';

  @override
  String get weeklySummary => 'الملخص الأسبوعي';

  @override
  String get soundLabel => 'الصوت';

  @override
  String get vibration => 'الاهتزاز';

  @override
  String get whoCanSeeProfile => 'من يمكنه رؤية ملفي الشخصي';

  @override
  String get profileVisibility => 'ظهور الملف الشخصي';

  @override
  String get showOnLeaderboards => 'إظهاري في لوحات الصدارة';

  @override
  String get allowMatchInvites => 'السماح بدعوات المباريات';

  @override
  String get allowFriendRequests => 'السماح بطلبات الصداقة';

  @override
  String get showHeightWeight => 'إظهار الطول والوزن';

  @override
  String get showHeightWeightHint =>
      'عند الإيقاف تبقى قياسات جسمك خاصة بك وحدك';

  @override
  String get autoAcceptFriends => 'القبول التلقائي من الأصدقاء';

  @override
  String get restTimerBetweenSets => 'مؤقت الراحة بين المجموعات';

  @override
  String get exportData => 'تصدير بياناتي';

  @override
  String get clearCache => 'مسح الذاكرة المؤقتة';

  @override
  String get cacheCleared => 'تم مسح الذاكرة المؤقتة';

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
  String get resetProgress => 'إعادة ضبط تقدمي';

  @override
  String get resetProgressTitle => 'إعادة ضبط تقدمك؟';

  @override
  String get resetProgressBody =>
      'ستعود الرتبة والنقاط وسجل المباريات إلى الصفر، ولا يمكن التراجع عن ذلك.';

  @override
  String get actionReset => 'إعادة ضبط';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get deleteAccountTitle => 'حذف حسابك؟';

  @override
  String get deleteAccountBody =>
      'سيُحذف ملفك الشخصي وفرقك وكل مباراة خضتها حذفًا نهائيًا.';

  @override
  String get actionDelete => 'حذف';

  @override
  String get needsServer => 'تتطلب هذه الميزة خادمًا، ولم تُربط بعد';

  @override
  String get getStarted => 'لنبدأ';

  @override
  String get skipToApp => 'الانتقال إلى التطبيق مباشرة';

  @override
  String get achievements => 'الإنجازات';

  @override
  String get unlocked => 'مفتوحة';

  @override
  String get roadTitle => 'الطريق إلى الأسطورة';

  @override
  String get allTiers => 'جميع الرتب';

  @override
  String get topTier => 'أعلى رتبة';

  @override
  String lpToGo(String lp) {
    return '$lp نقطة';
  }

  @override
  String get unlockedEverything => 'لقد فتحت كل شيء';

  @override
  String unlocksAt(String tier) {
    return 'يُفتح عند رتبة $tier';
  }

  @override
  String get matchedSameGroup =>
      'ستُقابَل بمن يتدرب على المجموعة العضلية نفسها.';

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
  String get dontGetOutrepd => 'Don\'t get OUTREPD!';

  @override
  String xOfY(String a, String b) {
    return '$a/$b';
  }

  @override
  String get tierStone => 'الحجر';

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
  String get tierMythic => 'الأسطوري';

  @override
  String get tierLegend => 'الأسطورة';

  @override
  String get rewardStone => 'إطار حجري';

  @override
  String get rewardBronze => 'شارة برونزية';

  @override
  String get rewardSilver => 'شارة فضية';

  @override
  String get rewardGold => 'شارة ذهبية';

  @override
  String get rewardPlatinum => 'شارة بلاتينية';

  @override
  String get rewardDiamond => 'شارة ماسية';

  @override
  String get rewardMaster => 'شارة المُعلِّم';

  @override
  String get rewardMythic => 'شارة أسطورية';

  @override
  String get rewardLegend => 'شارة الأسطورة';

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
  String get yearsSuffix => 'سنة';

  @override
  String get yourCrew => 'فريقك';

  @override
  String get crewName => 'اسم الفريق';

  @override
  String get motto => 'الشعار';

  @override
  String get mottoHint => 'ما الذي يمثله هذا الفريق؟';

  @override
  String get country => 'الدولة';

  @override
  String get whoCanJoin => 'من يمكنه الانضمام';

  @override
  String get minimumRank => 'أدنى رتبة';

  @override
  String get anyone => 'الجميع';

  @override
  String get emblem => 'الرمز';

  @override
  String get colour => 'اللون';

  @override
  String get createCrewButton => 'إنشاء الفريق';

  @override
  String get ownerNote => 'ستكون أنت المالك، ويتسع الفريق لعشرين لاعبًا.';

  @override
  String get searchCountries => 'ابحث عن دولة';

  @override
  String get noCountryMatch => 'لا توجد دولة مطابقة';

  @override
  String get nameTooShort => 'اختر للفريق اسمًا من ثلاثة أحرف على الأقل';

  @override
  String get privOpen => 'مفتوح';

  @override
  String get privRequest => 'طلب انضمام';

  @override
  String get privInviteOnly => 'بالدعوة فقط';

  @override
  String get privOpenHint => 'كل من يملك الرمز ينضم مباشرة';

  @override
  String get privRequestHint => 'يتقدم الراغب بطلب ويوافق عليه مسؤول';

  @override
  String get privInviteOnlyHint => 'لا ينضم أحد إلا بدعوة مباشرة';

  @override
  String get embStrength => 'القوة';

  @override
  String get embCombat => 'القتال';

  @override
  String get embBeasts => 'الوحوش';

  @override
  String get embElements => 'العناصر';

  @override
  String get embHonours => 'الأوسمة';

  @override
  String get embSymbols => 'الرموز';

  @override
  String get ob1Title => 'اجعل كل تمرين\nمواجهة';

  @override
  String get ob1Body =>
      'سجّل تمرينك وواجه من يتدرب على المجموعة العضلية نفسها.';

  @override
  String get ob2Title => 'تحدَّ\nأصدقاءك';

  @override
  String get ob2Body => 'أرسل دعوة خاصة، واحسم من يتدرب بجدية أكبر.';

  @override
  String get ob3Title => 'ارتقِ في الرتب';

  @override
  String get ob3Body => 'كل انتصار يمنحك نقاطًا. تدرّج من الحجر حتى الأسطورة.';

  @override
  String get ob4Title => 'المجهود وحده\nصعب';

  @override
  String get ob4Body =>
      'التدريب بلا رقيب يجعل التخلي عن المجموعة الأخيرة أمرًا سهلًا.';

  @override
  String get ob5Title => 'كن\nأسطورة';

  @override
  String get ob5Body => 'الاستمرار يتراكم. احضر، وتفوّق، وارتقِ.';

  @override
  String get letsGo => 'لنبدأ';

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
  String get ttl_bronze_tier => 'خروج من الحجر';

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
  String get ttl_mythic_tier => 'الأسطوري';

  @override
  String get tdesc_mythic_tier => 'ابلغ الرتبة الأسطورية';

  @override
  String get ttl_legend_tier => 'الأسطورة';

  @override
  String get tdesc_legend_tier => 'ابلغ رتبة الأسطورة';

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
  String get ttl_iron_hold => 'قبضة حديدية';

  @override
  String get tdesc_iron_hold => 'اثبت على البلانك دقيقتين';

  @override
  String get ttl_statue => 'تمثال';

  @override
  String get tdesc_statue => 'اثبت على البلانك خمس دقائق';

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
  String get ttl_joined_up => 'انضممتَ';

  @override
  String get tdesc_joined_up => 'كن ضمن فريق';

  @override
  String get ttl_backbone => 'العمود الفقري';

  @override
  String get tdesc_backbone => 'تصدّر فريقك أربعة أسابيع متتالية';

  @override
  String get ttl_cornerstone => 'حجر الأساس';

  @override
  String get tdesc_cornerstone => 'تصدّر فريقك اثني عشر أسبوعًا متتاليًا';

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
  String get finish2 => 'إنهاء';

  @override
  String get qExperience => 'ما مدى خبرتك\nفي التمارين؟';

  @override
  String get expBeginner => 'مبتدئ – جرّبتها من قبل';

  @override
  String get expIntermediate => 'متوسط – أتدرب بانتظام';

  @override
  String get expAdvanced => 'متقدم – سنوات من الخبرة';

  @override
  String get qGoal => 'ما هدفك الأول\nفي اللياقة؟';

  @override
  String get goalStronger => 'أن أصبح أقوى';

  @override
  String get goalConsistent => 'أن أصبح أكثر انتظامًا';

  @override
  String get goalLean => 'إنقاص الوزن والحصول على قوام رشيق';

  @override
  String get goalMass => 'بناء كتلة عضلية';

  @override
  String get aboutYou => 'هذه الرحلة عنك أنت...';

  @override
  String get qThinkAbout => 'كم مرة تفكر\nفي أن تصبح لائقًا؟';

  @override
  String get freqNever => 'أبدًا';

  @override
  String get freqSometimes => 'أحيانًا';

  @override
  String get freqOften => 'كثيرًا';

  @override
  String get freqAllTime => 'طوال الوقت';

  @override
  String get qEnergy => 'كيف تجد طاقتك\nأثناء التمرين؟';

  @override
  String get energyLow => 'طاقة منخفضة، أشعر بالإرهاق طوال اليوم';

  @override
  String get energyDrops => 'أدائي يتراجع في منتصف الجلسة';

  @override
  String get energyHard => 'يصعب عليّ إتمام المجموعة الأخيرة';

  @override
  String get energyHigh => 'عالية وثابتة من البداية إلى النهاية';

  @override
  String get stProgress => 'أحيانًا يصعب أن ألاحظ تقدمي وأنا أتمرن';

  @override
  String get stEffortTitle => 'المجهود الذي لا يراه أحد\nيسهل التخلي عنه';

  @override
  String get stEffortBody =>
      'حين لا يكون أمامك من تثبت له شيئًا، يبدو التقدم بطيئًا ويبدو المجهود بلا معنى';

  @override
  String get stAloneTitle => 'التدريب وحدك\nممل';

  @override
  String get stAloneBody =>
      'لا أحد يراقب، ولا أحد يعدّ. من السهل أن تسقط تكرارًا، أو المجموعة كلها';

  @override
  String get qName => 'بماذا\nنناديك؟';

  @override
  String get nameHint => 'ثلاثة أحرف على الأقل. هذا ما سيراه منافسوك.';

  @override
  String get basicInfo => 'حسنًا! لنأخذ\nبعض البيانات الأساسية';

  @override
  String get qAge => 'كم عمرك؟';

  @override
  String get qWeight => 'ما وزنك\nالحالي؟';

  @override
  String get weightWhy => 'وزن الجسم ضروري لحساب رتبتك.';

  @override
  String get privateNote => 'بياناتك خاصة ولن تُشارك مع أي أحد.';

  @override
  String get qHeight => 'كم طولك؟';

  @override
  String get qRelate => 'هل تجد نفسك\nفي العبارة التالية؟';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get grindTitle => 'المجهود له طعم آخر\nحين يكون هناك منافس';

  @override
  String get grindBody =>
      'كل مباراة تضعك أمام خصم حقيقي: ابذل ما لديك، وأثبت من تدرّب بجدية أكبر.';

  @override
  String get allSet => 'كل شيء جاهز!';

  @override
  String welcomeLifter(String name) {
    return 'أهلًا $name. حان وقت إيجاد منافسك الأول.';
  }

  @override
  String get lifter => 'بطل';

  @override
  String get enterApp => 'ادخل OUTREPD';

  @override
  String get commitTitle => 'والآن لنقطع عهدًا\nعلى رحلتك الرياضية';

  @override
  String get holdLogo => 'اضغط مطوّلًا على الشعار لتؤكد استعدادك';

  @override
  String get expNone => 'لم أتمرن من قبل';

  @override
  String get iAm => 'أنا...';

  @override
  String get finishMatchQ => 'إنهاء المباراة؟';

  @override
  String get finishMatchBody => 'سيُثبَّت مجموع أوزانك ويُقارن بخصمك.';

  @override
  String get keepGoing => 'أكمل';

  @override
  String get forfeitQ => 'الانسحاب من المباراة؟';

  @override
  String get forfeitBody => 'ستخسر نقاطًا إذا غادرت الآن.';

  @override
  String get stay => 'ابقَ';

  @override
  String get forfeit => 'انسحاب';

  @override
  String get pickExercises => 'اختر التمارين التي ستؤديها';

  @override
  String matchingWith(String muscle) {
    return 'نبحث لك عن لاعب في رتبتك · $muscle';
  }

  @override
  String get getReady => 'استعد';

  @override
  String get timeLeft => 'الوقت المتبقي';

  @override
  String vsName(String name) {
    return 'ضد $name';
  }

  @override
  String kgTotalVolume(String unit) {
    return '$unit إجمالي الوزن';
  }

  @override
  String get finishMatch => 'إنهاء المباراة';

  @override
  String get kgHint => 'الوزن';

  @override
  String get repsHint => 'التكرارات';

  @override
  String get addSet => 'أضف مجموعة';

  @override
  String get matchComplete => 'انتهت المباراة';

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
  String get achRivalry => 'منافسة';

  @override
  String get achRivalryHint => 'اهزم الخصم نفسه ثلاث مرات';

  @override
  String get nWonTitle => 'لقد فزت!';

  @override
  String nWonBody(String name, String muscle) {
    return 'هزمت $name في يوم $muscle';
  }

  @override
  String get nFriendTitle => 'طلب صداقة جديد';

  @override
  String nFriendBody(String name) {
    return '$name يريد التواصل معك';
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
  String get nameTooShortInline => 'اختر اسمًا من ثلاثة أحرف على الأقل';

  @override
  String get whyName => 'سيراه منافسوك بجوار كل نتيجة';

  @override
  String get whyExperience => 'نقابلك بمن هم في مستواك';

  @override
  String get whyGoal => 'التمارين المقترحة الأولى تُبنى على هذا';

  @override
  String get whyAge => 'العمر يؤثر في معايير القوة التي تُقاس بها';

  @override
  String get whyWeight =>
      'الرتبة تقارن الرفع نسبةً إلى وزن الجسم لا بالكيلوغرامات وحدها';

  @override
  String get whyHeight => 'يُستخدم مع وزنك لضبط معايير عادلة';

  @override
  String get whyHabits => 'يحدد التذكيرات والهدف الأسبوعي الذي نقترحه';

  @override
  String get transitionPartOfIt => '...فلنتأكد أنك جزء منها حقًّا!';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get usernamePlaceholder => 'اسم اللاعب';

  @override
  String get stRoutine =>
      'لا أعرف أي عضلة تحتاج العمل فعلًا، فأكرر البرنامج نفسه غالبًا';

  @override
  String get shortIn => 'بوصة';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String daysAgo(String n) {
    return 'منذ $n أيام';
  }

  @override
  String weeksAgo(String n) {
    return 'منذ $n أسابيع';
  }

  @override
  String membersCount(String n) {
    return '$n أعضاء';
  }

  @override
  String eachCount(String n) {
    return '$n للفرد';
  }

  @override
  String lpAmount(String n) {
    return '$n نقطة';
  }

  @override
  String get countWithCamera => 'عُدّ بالكاميرا';

  @override
  String get youWin => 'فزت!';

  @override
  String get defeated => 'خسرت';

  @override
  String get fillWholeNumbers => 'املأ الثلاثة بأرقام صحيحة';

  @override
  String heightRange(String min, String max, String unit) {
    return 'الطول يجب أن يكون بين $min و$max $unit';
  }

  @override
  String weightRange(String min, String max, String unit) {
    return 'الوزن يجب أن يكون بين $min و$max $unit';
  }

  @override
  String ageRange(String min, String max) {
    return 'العمر يجب أن يكون بين $min و$max';
  }

  @override
  String get discPush => 'دفع';

  @override
  String get discPull => 'سحب';

  @override
  String get discLegs => 'أرجل';

  @override
  String get discPushHint => 'صدر وأكتاف وترايسبس';

  @override
  String get discPullHint => 'ظهر وبايسبس';

  @override
  String get discLegsHint => 'أرجل وبطن';

  @override
  String get pickYourThree => 'اختار تلاتة';

  @override
  String get pickThreeHint => 'الاتنين هيرفعوا الستة — تلاتتك وتلاتته';

  @override
  String roundOf(String n, String total) {
    return 'الجولة $n من $total';
  }

  @override
  String get rest => 'راحة';

  @override
  String get work => 'شغل';

  @override
  String get nextUp => 'الجاية';

  @override
  String picksLeft(String n) {
    return 'فاضل $n تختارهم';
  }

  @override
  String get yourPick => 'اختيارك';

  @override
  String get theirPick => 'اختياره';

  @override
  String secondsOfWork(String n) {
    return '$n ثانية شغل';
  }

  @override
  String lpOutOf(String total) {
    return '/ $total نقطة';
  }

  @override
  String toPromotion(String n) {
    return 'يتبقى $n للترقية';
  }

  @override
  String get noFriendsTitle => 'لسه مفيش أصدقاء';

  @override
  String get noFriendsBody => 'ضيف حد وتقدر تتحداه في ماتش خاص أي وقت.';

  @override
  String get noMatchesTitle => 'لسه مفيش ماتشات';

  @override
  String get noMatchesBody => 'أول واحد هيظهر هنا، كسبت أو خسرت.';

  @override
  String get noNotificationsTitle => 'مفيش جديد';

  @override
  String get noNotificationsBody =>
      'دعوات الماتشات ونتايجها وطلبات الصداقة بتيجي هنا.';

  @override
  String roundDone(String n) {
    return 'الجولة $n خلصت';
  }

  @override
  String get bestRoundYet => 'أحسن جولة لحد دلوقتي';
}
