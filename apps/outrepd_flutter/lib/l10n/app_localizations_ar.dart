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
  String lpProgress(int lp, int left) {
    return '$lp / 100 نقطة · يتبقى $left للترقية';
  }

  @override
  String winStreak(int count) {
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
  String changeNameLeft(int total, int left) {
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
  String titlesAndStreak(int owned, int total, int streak) {
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
  String goalRemaining(int reps, int days) {
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
  String seasonResets(int days) {
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
  String yourFriends(int count) {
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
  String lpToGo(int lp) {
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
  String xOfY(int a, int b) {
    return '$a / $b';
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
  String winLoss(int w, int l) {
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
}
