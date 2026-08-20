// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class LHi extends L {
  LHi([String locale = 'hi']) : super(locale);

  @override
  String get tabFriends => 'दोस्त';

  @override
  String get tabRanks => 'रैंक';

  @override
  String get tabMatch => 'मैच';

  @override
  String get tabCrew => 'क्रू';

  @override
  String get tabProfile => 'प्रोफ़ाइल';

  @override
  String get searchOpponent => 'प्रतिद्वंद्वी ढूँढें';

  @override
  String get searchOpponentHint =>
      'आपकी रैंक के किसी खिलाड़ी से मुक़ाबला कराते हैं';

  @override
  String get challengeFriend => 'दोस्त को चुनौती दें';

  @override
  String get trainWithCamera => 'कैमरे के साथ ट्रेनिंग';

  @override
  String get viewRoadmap => 'रास्ता देखें';

  @override
  String lpProgress(String lp, String left) {
    return '$lp / 100 LP · प्रमोशन में $left बाकी';
  }

  @override
  String winStreak(String count) {
    return 'लगातार $count जीत';
  }

  @override
  String get matchHistory => 'मैच इतिहास';

  @override
  String get allMatches => 'सभी मैच';

  @override
  String get wins => 'जीत';

  @override
  String get losses => 'हार';

  @override
  String get winRate => 'जीत दर';

  @override
  String get streak => 'सिलसिला';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get stats => 'आँकड़े';

  @override
  String get edit => 'बदलें';

  @override
  String get save => 'सेव करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get skip => 'छोड़ें';

  @override
  String get totalMatches => 'कुल मैच';

  @override
  String get bestWinStreak => 'सबसे लंबी जीत';

  @override
  String get totalVolume => 'कुल उठाया वज़न';

  @override
  String get height => 'कद';

  @override
  String get bodyweight => 'शरीर का वज़न';

  @override
  String get age => 'उम्र';

  @override
  String get editYourStats => 'अपने आँकड़े बदलें';

  @override
  String get editStatsHint =>
      'जीत, वॉल्यूम और रैंक कमाए जाते हैं — लिखे नहीं जाते।';

  @override
  String get changeName => 'नाम बदलें';

  @override
  String get changeNameLast =>
      'यह आपका आख़िरी बदलाव है। इसे वापस नहीं लिया जा सकता।';

  @override
  String changeNameLeft(String total, String left) {
    return 'आपको कुल $total बार बदलने का मौक़ा है। इसके बाद $left बचेगा।';
  }

  @override
  String get changeNameUsedUp => 'आप दोनों बार नाम बदल चुके हैं';

  @override
  String get yourPicture => 'आपकी तस्वीर';

  @override
  String get yourPictureHint =>
      'फ़्रेम आपकी रैंक से आता है और ऊपर चढ़ने पर बदलता है।';

  @override
  String get gallery => 'गैलरी';

  @override
  String get camera => 'कैमरा';

  @override
  String get orPickOurs => 'या हमारे में से चुनें';

  @override
  String get awards => 'पुरस्कार';

  @override
  String get yourTitles => 'आपके ख़िताब';

  @override
  String get stillToEarn => 'अभी कमाने बाकी';

  @override
  String get noTitlesYet => 'अभी कोई नहीं। पहले के लिए एक मैच काफ़ी है।';

  @override
  String get wearHint =>
      'पहनने के लिए किसी पर टैप करें। जहाँ भी लोग आपको देखेंगे, यह आपके नाम के साथ दिखेगा।';

  @override
  String get worn => 'पहना हुआ';

  @override
  String get titleUnlocked => 'ख़िताब खुला';

  @override
  String get wearIt => 'पहनें';

  @override
  String get wearItLater => 'बाद में';

  @override
  String get dayStreak => 'दिन लगातार';

  @override
  String get bestEver => 'सर्वश्रेष्ठ';

  @override
  String get restDaysLeft => 'बचे आराम के दिन';

  @override
  String get restIsTraining =>
      'आराम भी ट्रेनिंग का हिस्सा है। हफ़्ते में दो छुट्टियाँ आपका सिलसिला नहीं तोड़तीं।';

  @override
  String titlesAndStreak(String owned, String total, String streak) {
    return '$total में से $owned ख़िताब · $streak दिन का सिलसिला';
  }

  @override
  String get crew => 'क्रू';

  @override
  String get myCrew => 'मेरा क्रू';

  @override
  String get rankings => 'रैंकिंग';

  @override
  String get trainWithCrew => 'क्रू के साथ ट्रेनिंग करें';

  @override
  String get trainWithCrewHint =>
      'एक नाम के नीचे 20 तक खिलाड़ी, साथ में एक साप्ताहिक लक्ष्य और क्रू टेबल में चढ़ने की जगह।';

  @override
  String get createCrew => 'क्रू बनाएँ';

  @override
  String get createCrewHint => 'नाम दें, निशान चुनें, अपने लोगों को बुलाएँ';

  @override
  String get joinOpenCrew => 'खुले क्रू में शामिल हों';

  @override
  String get joinOpenCrewHint => 'ऐसे क्रू जिनमें कोई भी शामिल हो सकता है';

  @override
  String get yourInvites => 'आपके निमंत्रण';

  @override
  String get yourInvitesHint => 'जिन क्रू ने आपको बुलाया';

  @override
  String get joinWithCode => 'कोड से शामिल हों';

  @override
  String get joinWithCodeHint => 'किसी सदस्य से मिले छह अक्षर';

  @override
  String get topCrewsThisWeek => 'इस हफ़्ते के टॉप क्रू';

  @override
  String get members => 'सदस्य';

  @override
  String get repsEach => 'प्रति व्यक्ति रेप';

  @override
  String get rank => 'स्थान';

  @override
  String get weeklyGoal => 'साप्ताहिक लक्ष्य';

  @override
  String get weeklyGoalDone => 'साप्ताहिक लक्ष्य पूरा';

  @override
  String goalRemaining(String reps, String days) {
    return '$reps रेप बाकी · $days दिन बचे';
  }

  @override
  String get goalDoneHint => 'हफ़्ता ख़त्म होते ही बैज सबको मिलेगा।';

  @override
  String get startCrewWar => 'क्रू वॉर शुरू करें';

  @override
  String get startCrewWarHint =>
      'सात दिन, दोनों क्रू गिनती में। प्रति व्यक्ति सबसे ज़्यादा रेप वाला जीतेगा।';

  @override
  String get whoIsPulling => 'क्रू को कौन खींच रहा है';

  @override
  String get thisWeek => 'इस हफ़्ते';

  @override
  String get inviteLifters => 'खिलाड़ियों को बुलाएँ';

  @override
  String get referralCode => 'रेफ़रल कोड';

  @override
  String get inviteLink => 'निमंत्रण लिंक';

  @override
  String get leaveCrew => 'क्रू छोड़ें';

  @override
  String get owner => 'मालिक';

  @override
  String get crewTable => 'क्रू तालिका';

  @override
  String get repsPerMember => 'प्रति सदस्य रेप';

  @override
  String seasonResets(String days) {
    return '$days दिन में रीसेट — सब बराबरी से शुरू करेंगे';
  }

  @override
  String get rankingExplained =>
      'क्रू की रैंकिंग कुल रेप से नहीं, प्रति सदस्य रेप से होती है — वरना सबसे बड़ा क्रू सिर्फ़ आकार से जीत जाता।';

  @override
  String get leaderboard => 'लीडरबोर्ड';

  @override
  String get global => 'वैश्विक';

  @override
  String get myCountry => 'मेरा देश';

  @override
  String yourFriends(String count) {
    return 'आपके दोस्त ($count)';
  }

  @override
  String get challenge => 'चुनौती';

  @override
  String get notifications => 'सूचनाएँ';

  @override
  String get pickMovement => 'एक मूवमेंट चुनें';

  @override
  String get anyExercise => 'कोई भी एक्सरसाइज़';

  @override
  String get anyExerciseHint =>
      'अपना सेट शुरू करें — गतिविधि के दौरान ही मूवमेंट पहचान लिया जाता है';

  @override
  String get start => 'शुरू करें';

  @override
  String get finish => 'ख़त्म';

  @override
  String get reps => 'रेप';

  @override
  String get secondsHeld => 'सेकंड रोका';

  @override
  String get learningMovement =>
      'आपका मूवमेंट समझा जा रहा है — गिनती अभी दिखेगी';

  @override
  String get recalibrate => 'फिर से सेट करें';

  @override
  String get resetCount => 'गिनती शून्य करें';

  @override
  String get checksForm => 'फ़ॉर्म जाँचता है';

  @override
  String get counts => 'गिनता है';

  @override
  String get time => 'समय';

  @override
  String get howManyReally => 'असल में कितने किए?';

  @override
  String get howManyReallyHint =>
      'आपकी अपनी गिनती, ऐप की नहीं। बाद में काउंटर इसी से नापा जाएगा।';

  @override
  String get appearance => 'दिखावट';

  @override
  String get theme => 'थीम';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get language => 'भाषा';

  @override
  String get units => 'इकाइयाँ';

  @override
  String get weight => 'वज़न';

  @override
  String get notificationsSection => 'सूचनाएँ';

  @override
  String get privacy => 'प्राइवेसी';

  @override
  String get matches => 'मैच';

  @override
  String get data => 'डेटा';

  @override
  String get about => 'ऐप के बारे में';

  @override
  String get dangerZone => 'ख़तरे का क्षेत्र';

  @override
  String get themeSystem => 'डिवाइस जैसा';

  @override
  String get themeLight => 'हल्का';

  @override
  String get themeDark => 'गहरा';

  @override
  String get openCrews => 'खुले क्रू';

  @override
  String get openCrewsHint => 'इनमें कोई भी आ सकता है। एक चुनिए और आप अंदर।';

  @override
  String get yourInvitesSubtitle => 'जिन क्रू ने नाम लेकर आपको बुलाया।';

  @override
  String get pickOpponent => 'अपना प्रतिद्वंद्वी चुनें';

  @override
  String get accept => 'स्वीकारें';

  @override
  String get join => 'शामिल हों';

  @override
  String get copy => 'कॉपी';

  @override
  String get copied => 'निमंत्रण लिंक कॉपी हो गया';

  @override
  String season(String name) {
    return 'सीज़न $name';
  }

  @override
  String challengeSent(String name) {
    return '$name को चुनौती भेजी गई';
  }

  @override
  String get inviteFriendPrivate => 'किसी दोस्त को निजी मैच में बुलाएँ';

  @override
  String get joinWithCodePaste =>
      'किसी सदस्य ने जो छह अक्षर भेजे, वे पेस्ट करें।';

  @override
  String get enterTheCode => '6 अक्षरों का कोड डालें';

  @override
  String get followingDevice => 'अभी आपके डिवाइस के हिसाब से';

  @override
  String get weightUnitTitle => 'वज़न की इकाई';

  @override
  String get heightUnitTitle => 'कद की इकाई';

  @override
  String get unitKg => 'किलोग्राम (kg)';

  @override
  String get unitLb => 'पाउंड (lb)';

  @override
  String get unitCm => 'सेंटीमीटर (cm)';

  @override
  String get unitFt => 'फ़ीट और इंच';

  @override
  String get visEveryone => 'सब लोग';

  @override
  String get visFriends => 'सिर्फ़ दोस्त';

  @override
  String get visNobody => 'कोई नहीं';

  @override
  String get visEveryoneHint => 'कोई भी आपकी प्रोफ़ाइल खोल सकता है';

  @override
  String get visFriendsHint => 'सिर्फ़ वे जिन्हें आपने जोड़ा है';

  @override
  String get visNobodyHint => 'आपकी प्रोफ़ाइल निजी रहती है';

  @override
  String get matchInvites => 'मैच के निमंत्रण';

  @override
  String get matchResults => 'मैच के नतीजे';

  @override
  String get friendRequestsLabel => 'दोस्ती के अनुरोध';

  @override
  String get crewActivity => 'क्रू की गतिविधि';

  @override
  String get rankChanges => 'रैंक में बदलाव';

  @override
  String get weeklySummary => 'साप्ताहिक सारांश';

  @override
  String get soundLabel => 'आवाज़';

  @override
  String get vibration => 'कंपन';

  @override
  String get whoCanSeeProfile => 'मेरी प्रोफ़ाइल कौन देख सकता है';

  @override
  String get profileVisibility => 'प्रोफ़ाइल दृश्यता';

  @override
  String get showOnLeaderboards => 'लीडरबोर्ड पर मुझे दिखाएँ';

  @override
  String get allowMatchInvites => 'मैच के निमंत्रण की अनुमति';

  @override
  String get allowFriendRequests => 'दोस्ती के अनुरोध की अनुमति';

  @override
  String get showHeightWeight => 'कद और वज़न दिखाएँ';

  @override
  String get showHeightWeightHint =>
      'बंद रखने पर शरीर के आँकड़े सिर्फ़ आपके रहते हैं';

  @override
  String get autoAcceptFriends => 'दोस्तों से अपने आप स्वीकारें';

  @override
  String get restTimerBetweenSets => 'सेट के बीच आराम टाइमर';

  @override
  String get exportData => 'मेरा डेटा निर्यात करें';

  @override
  String get clearCache => 'कैश साफ़ करें';

  @override
  String get cacheCleared => 'कैश साफ़ हो गया';

  @override
  String get version => 'वर्ज़न';

  @override
  String get rateApp => 'OUTREPD को रेट करें';

  @override
  String get contactSupport => 'सहायता से संपर्क करें';

  @override
  String get termsOfService => 'सेवा की शर्तें';

  @override
  String get privacyPolicy => 'प्राइवेसी नीति';

  @override
  String get openSourceLicences => 'ओपन सोर्स लाइसेंस';

  @override
  String get resetProgress => 'मेरी प्रगति रीसेट करें';

  @override
  String get resetProgressTitle => 'अपनी प्रगति रीसेट करें?';

  @override
  String get resetProgressBody =>
      'रैंक, LP और मैच इतिहास सब शून्य हो जाएँगे। इसे वापस नहीं लिया जा सकता।';

  @override
  String get actionReset => 'रीसेट';

  @override
  String get deleteAccount => 'खाता मिटाएँ';

  @override
  String get deleteAccountTitle => 'अपना खाता मिटाएँ?';

  @override
  String get deleteAccountBody =>
      'आपकी प्रोफ़ाइल, क्रू और उठाया हुआ हर मैच हमेशा के लिए हट जाएगा।';

  @override
  String get actionDelete => 'मिटाएँ';

  @override
  String get needsServer =>
      'इस सुविधा के लिए सर्वर आवश्यक है, जो अभी जुड़ा नहीं है';

  @override
  String get getStarted => 'चलिए शुरू करें';

  @override
  String get skipToApp => 'सीधे ऐप में जाएँ';

  @override
  String get achievements => 'उपलब्धियाँ';

  @override
  String get unlocked => 'खुल गया';

  @override
  String get roadTitle => 'लेजेंड तक का रास्ता';

  @override
  String get allTiers => 'सभी रैंक';

  @override
  String get topTier => 'सर्वोच्च रैंक';

  @override
  String lpToGo(String lp) {
    return '$lp LP';
  }

  @override
  String get unlockedEverything => 'आपने सब कुछ खोल लिया है';

  @override
  String unlocksAt(String tier) {
    return '$tier पर खुलेगा';
  }

  @override
  String get matchedSameGroup =>
      'आपको उसी मसल ग्रुप पर काम कर रहे किसी खिलाड़ी से मिलाया जाएगा।';

  @override
  String get roomFriendly =>
      'रूम मैच दोस्ताना होते हैं — इनसे आपकी रैंक पर असर नहीं पड़ता।';

  @override
  String get createRoom => 'रूम बनाएँ';

  @override
  String get enterCode => 'कोड डालें';

  @override
  String get joinRoom => 'रूम में जुड़ें';

  @override
  String get shareThisCode => 'यह कोड साझा करें';

  @override
  String get codeCopied => 'कोड कॉपी हो गया';

  @override
  String get pickMuscleAndStart => 'मसल चुनें और शुरू करें';

  @override
  String get dontGetOutrepd => 'Don\'t get OUTREPD!';

  @override
  String xOfY(String a, String b) {
    return '$a / $b';
  }

  @override
  String get tierStone => 'पाषाण';

  @override
  String get tierBronze => 'कांस्य';

  @override
  String get tierSilver => 'रजत';

  @override
  String get tierGold => 'स्वर्ण';

  @override
  String get tierPlatinum => 'प्लैटिनम';

  @override
  String get tierDiamond => 'हीरा';

  @override
  String get tierMaster => 'मास्टर';

  @override
  String get tierMythic => 'पौराणिक';

  @override
  String get tierLegend => 'लेजेंड';

  @override
  String get rewardStone => 'पाषाण फ़्रेम';

  @override
  String get rewardBronze => 'कांस्य बैज';

  @override
  String get rewardSilver => 'रजत बैज';

  @override
  String get rewardGold => 'स्वर्ण बैज';

  @override
  String get rewardPlatinum => 'प्लैटिनम बैज';

  @override
  String get rewardDiamond => 'हीरा बैज';

  @override
  String get rewardMaster => 'मास्टर बैज';

  @override
  String get rewardMythic => 'पौराणिक बैज';

  @override
  String get rewardLegend => 'लेजेंड बैज';

  @override
  String get shortKg => 'किग्रा';

  @override
  String get shortLb => 'पाउंड';

  @override
  String get shortCm => 'सेमी';

  @override
  String get shortFt => 'फ़ीट';

  @override
  String winLoss(String w, String l) {
    return '$w जीत $l हार';
  }

  @override
  String get yearsSuffix => 'वर्ष';

  @override
  String get yourCrew => 'आपका क्रू';

  @override
  String get crewName => 'क्रू का नाम';

  @override
  String get motto => 'आदर्श वाक्य';

  @override
  String get mottoHint => 'यह क्रू किसका प्रतिनिधित्व करता है?';

  @override
  String get country => 'देश';

  @override
  String get whoCanJoin => 'कौन शामिल हो सकता है';

  @override
  String get minimumRank => 'न्यूनतम रैंक';

  @override
  String get anyone => 'कोई भी';

  @override
  String get emblem => 'प्रतीक';

  @override
  String get colour => 'रंग';

  @override
  String get createCrewButton => 'क्रू बनाएँ';

  @override
  String get ownerNote =>
      'आप इसके स्वामी होंगे। एक क्रू में अधिकतम 20 खिलाड़ी आते हैं।';

  @override
  String get searchCountries => 'देश खोजें';

  @override
  String get noCountryMatch => 'कोई देश मेल नहीं खाता';

  @override
  String get nameTooShort => 'क्रू को कम से कम 3 अक्षरों का नाम दें';

  @override
  String get privOpen => 'खुला';

  @override
  String get privRequest => 'शामिल होने का अनुरोध';

  @override
  String get privInviteOnly => 'केवल निमंत्रण पर';

  @override
  String get privOpenHint => 'जिसके पास कोड है वह सीधे शामिल हो जाता है';

  @override
  String get privRequestHint =>
      'व्यक्ति अनुरोध करता है, अधिकारी स्वीकृति देता है';

  @override
  String get privInviteOnlyHint => 'सदस्य केवल सीधे निमंत्रण से जुड़ते हैं';

  @override
  String get embStrength => 'शक्ति';

  @override
  String get embCombat => 'युद्ध';

  @override
  String get embBeasts => 'जीव';

  @override
  String get embElements => 'तत्व';

  @override
  String get embHonours => 'सम्मान';

  @override
  String get embSymbols => 'प्रतीक';

  @override
  String get ob1Title => 'हर सेशन को\nमुक़ाबले में बदलें';

  @override
  String get ob1Body =>
      'अपनी वर्कआउट दर्ज करें और उसी मसल ग्रुप पर काम कर रहे किसी से आमने-सामने हों।';

  @override
  String get ob2Title => 'अपने दोस्तों को\nचुनौती दें';

  @override
  String get ob2Body =>
      'निजी निमंत्रण भेजें और तय करें कि वाकई कौन ज़्यादा मेहनत करता है।';

  @override
  String get ob3Title => 'रैंक में ऊपर चढ़ें';

  @override
  String get ob3Body =>
      'हर जीत LP देती है। पाषाण से लेजेंड तक का सफ़र तय करें।';

  @override
  String get ob4Title => 'अकेले की मेहनत\nमुश्किल है';

  @override
  String get ob4Body =>
      'जब कोई देख नहीं रहा हो तो आख़िरी सेट छोड़ देना आसान हो जाता है।';

  @override
  String get ob5Title => 'एक लेजेंड\nबनें';

  @override
  String get ob5Body => 'निरंतरता जुड़ती जाती है। आइए, आगे निकलिए, ऊपर चढ़िए।';

  @override
  String get letsGo => 'चलिए शुरू करें';

  @override
  String get continueLabel => 'आगे बढ़ें';

  @override
  String get ttl_first_blood => 'पहला वार';

  @override
  String get tdesc_first_blood => 'अपना पहला मैच पूरा करें';

  @override
  String get ttl_found_footing => 'पैर जम गए';

  @override
  String get tdesc_found_footing => 'पाँच मैच पूरे करें';

  @override
  String get ttl_regular => 'नियमित';

  @override
  String get tdesc_regular => 'बीस मैच';

  @override
  String get ttl_fifty => 'पचास पार';

  @override
  String get tdesc_fifty => 'पचास मैच';

  @override
  String get ttl_century => 'शतक';

  @override
  String get tdesc_century => 'सौ मैच';

  @override
  String get ttl_veteran => 'अनुभवी';

  @override
  String get tdesc_veteran => 'दो सौ पचास मैच';

  @override
  String get ttl_thousand_matches => 'पुराना पहरेदार';

  @override
  String get tdesc_thousand_matches => 'एक हज़ार मैच';

  @override
  String get ttl_first_win => 'विजेता';

  @override
  String get tdesc_first_win => 'एक मैच जीतें';

  @override
  String get ttl_on_a_roll => 'लय में';

  @override
  String get tdesc_on_a_roll => 'लगातार तीन जीतें';

  @override
  String get ttl_five_straight => 'लगातार पाँच';

  @override
  String get tdesc_five_straight => 'लगातार पाँच जीतें';

  @override
  String get ttl_unstoppable => 'अजेय';

  @override
  String get tdesc_unstoppable => 'लगातार दस जीतें';

  @override
  String get ttl_untouchable => 'अछूता';

  @override
  String get tdesc_untouchable => 'लगातार बीस जीतें';

  @override
  String get ttl_giant_slayer => 'दानव-विजेता';

  @override
  String get tdesc_giant_slayer => 'अपने से दो रैंक ऊपर वाले को हराएँ';

  @override
  String get ttl_comeback => 'वापसी';

  @override
  String get tdesc_comeback => 'तीन हार के तुरंत बाद जीतें';

  @override
  String get ttl_nemesis => 'चिर-प्रतिद्वंद्वी';

  @override
  String get tdesc_nemesis => 'एक ही खिलाड़ी को पाँच बार हराएँ';

  @override
  String get ttl_hundred_reps => 'शुरुआत';

  @override
  String get tdesc_hundred_reps => 'सौ गिने गए रेप';

  @override
  String get ttl_five_hundred => 'वॉर्म-अप पूरा';

  @override
  String get tdesc_five_hundred => 'पाँच सौ गिने गए रेप';

  @override
  String get ttl_the_machine => 'मशीन';

  @override
  String get tdesc_the_machine => 'एक हज़ार गिने गए रेप';

  @override
  String get ttl_five_thousand => 'अनवरत';

  @override
  String get tdesc_five_thousand => 'पाँच हज़ार गिने गए रेप';

  @override
  String get ttl_ten_thousand => 'दस हज़ार';

  @override
  String get tdesc_ten_thousand => 'दस हज़ार गिने गए रेप';

  @override
  String get ttl_fifty_thousand => 'गिनती से परे';

  @override
  String get tdesc_fifty_thousand => 'पचास हज़ार गिने गए रेप';

  @override
  String get ttl_first_tonne => 'एक टन';

  @override
  String get tdesc_first_tonne => 'कुल एक हज़ार किलो उठाएँ';

  @override
  String get ttl_ten_tonnes => 'दस टन';

  @override
  String get tdesc_ten_tonnes => 'दस हज़ार किलो उठाएँ';

  @override
  String get ttl_six_figures => 'छह अंक';

  @override
  String get tdesc_six_figures => 'एक लाख किलो उठाएँ';

  @override
  String get ttl_half_million => 'आधा मिलियन';

  @override
  String get tdesc_half_million => 'पाँच लाख किलो उठाएँ';

  @override
  String get ttl_million_kg => 'मिलियन किलो क्लब';

  @override
  String get tdesc_million_kg => 'दस लाख किलो उठाएँ';

  @override
  String get ttl_two_days => 'फिर हाज़िर';

  @override
  String get tdesc_two_days => 'लगातार दो दिन ट्रेनिंग करें';

  @override
  String get ttl_no_days_off => 'कोई छुट्टी नहीं';

  @override
  String get tdesc_no_days_off => 'लगातार सात दिन ट्रेनिंग करें';

  @override
  String get ttl_fortnight => 'चौदह दिन';

  @override
  String get tdesc_fortnight => 'चौदह दिन का सिलसिला';

  @override
  String get ttl_unbroken => 'अटूट';

  @override
  String get tdesc_unbroken => 'तीस दिन का सिलसिला';

  @override
  String get ttl_sixty_days => 'आदत';

  @override
  String get tdesc_sixty_days => 'साठ दिन का सिलसिला';

  @override
  String get ttl_hundred_days => 'सौ दिन';

  @override
  String get tdesc_hundred_days => 'सौ दिन का सिलसिला';

  @override
  String get ttl_year_round => 'साल भर';

  @override
  String get tdesc_year_round => 'तीन सौ पैंसठ दिन का सिलसिला';

  @override
  String get ttl_perfect_week => 'परफ़ेक्ट हफ़्ता';

  @override
  String get tdesc_perfect_week => 'एक हफ़्ते के हर दिन ट्रेनिंग करें';

  @override
  String get ttl_perfect_month => 'परफ़ेक्ट महीना';

  @override
  String get tdesc_perfect_month => 'चार परफ़ेक्ट हफ़्ते';

  @override
  String get ttl_bronze_tier => 'पाषाण से बाहर';

  @override
  String get tdesc_bronze_tier => 'कांस्य तक पहुँचें';

  @override
  String get ttl_silver_tier => 'रजतिम';

  @override
  String get tdesc_silver_tier => 'रजत तक पहुँचें';

  @override
  String get ttl_golden_era => 'स्वर्ण युग';

  @override
  String get tdesc_golden_era => 'स्वर्ण तक पहुँचें';

  @override
  String get ttl_platinum_tier => 'प्लैटिनम';

  @override
  String get tdesc_platinum_tier => 'प्लैटिनम तक पहुँचें';

  @override
  String get ttl_diamond_tier => 'हीरे की पकड़';

  @override
  String get tdesc_diamond_tier => 'हीरा तक पहुँचें';

  @override
  String get ttl_master_tier => 'मास्टर';

  @override
  String get tdesc_master_tier => 'मास्टर तक पहुँचें';

  @override
  String get ttl_mythic_tier => 'पौराणिक';

  @override
  String get tdesc_mythic_tier => 'पौराणिक रैंक तक पहुँचें';

  @override
  String get ttl_legend_tier => 'लेजेंड';

  @override
  String get tdesc_legend_tier => 'लेजेंड तक पहुँचें';

  @override
  String get ttl_clean_hands => 'साफ़ हाथ';

  @override
  String get tdesc_clean_hands => 'पूरा सेट, हर रेप गिना हुआ';

  @override
  String get ttl_spotless => 'बेदाग़';

  @override
  String get tdesc_spotless => 'दस साफ़ सेट';

  @override
  String get ttl_textbook => 'किताबी';

  @override
  String get tdesc_textbook => 'पचास साफ़ सेट';

  @override
  String get ttl_iron_hold => 'लोहे की पकड़';

  @override
  String get tdesc_iron_hold => 'दो मिनट प्लैंक रोकें';

  @override
  String get ttl_statue => 'प्रतिमा';

  @override
  String get tdesc_statue => 'पाँच मिनट प्लैंक रोकें';

  @override
  String get ttl_all_rounder => 'हरफ़नमौला';

  @override
  String get tdesc_all_rounder => 'पाँच अलग-अलग एक्सरसाइज़ गिनें';

  @override
  String get ttl_explorer => 'खोजी';

  @override
  String get tdesc_explorer => 'पंद्रह अलग-अलग एक्सरसाइज़ गिनें';

  @override
  String get ttl_encyclopedia => 'विश्वकोश';

  @override
  String get tdesc_encyclopedia => 'चालीस अलग-अलग एक्सरसाइज़ गिनें';

  @override
  String get ttl_early_bird => 'सुबह की पाली';

  @override
  String get tdesc_early_bird => 'सुबह सात से पहले दस सेशन';

  @override
  String get ttl_sunrise_club => 'सूर्योदय क्लब';

  @override
  String get tdesc_sunrise_club => 'सुबह सात से पहले पचास सेशन';

  @override
  String get ttl_night_owl => 'रात की पाली';

  @override
  String get tdesc_night_owl => 'रात दस के बाद दस सेशन';

  @override
  String get ttl_graveyard => 'पिछली रात की पाली';

  @override
  String get tdesc_graveyard => 'रात दस के बाद पचास सेशन';

  @override
  String get ttl_joined_up => 'जुड़ गए';

  @override
  String get tdesc_joined_up => 'किसी क्रू में रहें';

  @override
  String get ttl_backbone => 'रीढ़';

  @override
  String get tdesc_backbone => 'लगातार चार हफ़्ते अपने क्रू में शीर्ष पर रहें';

  @override
  String get ttl_cornerstone => 'आधारशिला';

  @override
  String get tdesc_cornerstone =>
      'लगातार बारह हफ़्ते अपने क्रू में शीर्ष पर रहें';

  @override
  String get ttl_not_alone => 'अकेले नहीं';

  @override
  String get tdesc_not_alone => 'अपना पहला दोस्त जोड़ें';

  @override
  String get ttl_well_connected => 'अच्छी पहचान';

  @override
  String get tdesc_well_connected => 'दस दोस्त';

  @override
  String get ttl_the_gym_knows => 'जिम आपको जानता है';

  @override
  String get tdesc_the_gym_knows => 'पचास दोस्त';

  @override
  String get finish2 => 'समाप्त';

  @override
  String get qExperience => 'वर्कआउट में आपका\nअनुभव कितना है?';

  @override
  String get expBeginner => 'शुरुआती – पहले आज़माया है';

  @override
  String get expIntermediate => 'मध्यम – नियमित ट्रेनिंग करता हूँ';

  @override
  String get expAdvanced => 'उन्नत – वर्षों का अनुभव';

  @override
  String get qGoal => 'आपका मुख्य फ़िटनेस\nलक्ष्य क्या है?';

  @override
  String get goalStronger => 'और मज़बूत बनना';

  @override
  String get goalConsistent => 'और नियमित बनना';

  @override
  String get goalLean => 'वज़न घटाकर छरहरा होना';

  @override
  String get goalMass => 'मसल मास बढ़ाना';

  @override
  String get aboutYou => 'यह सफ़र पूरी तरह आपके बारे में है...';

  @override
  String get qThinkAbout => 'फ़िट होने के बारे में आप\nकितनी बार सोचते हैं?';

  @override
  String get freqNever => 'कभी नहीं';

  @override
  String get freqSometimes => 'कभी-कभी';

  @override
  String get freqOften => 'अक्सर';

  @override
  String get freqAllTime => 'हर समय';

  @override
  String get qEnergy => 'वर्कआउट के दौरान आपकी\nऊर्जा कैसी रहती है?';

  @override
  String get energyLow => 'कम, पूरे दिन थकान महसूस होती है';

  @override
  String get energyDrops => 'सेशन के बीच में प्रदर्शन गिर जाता है';

  @override
  String get energyHard => 'आख़िरी सेट पूरा करना मुश्किल लगता है';

  @override
  String get energyHigh => 'शुरू से आख़िर तक ऊँची और स्थिर';

  @override
  String get stProgress => 'कभी-कभी वर्कआउट करते हुए प्रगति दिखाई ही नहीं देती';

  @override
  String get stEffortTitle => 'जो मेहनत कोई नहीं देखता\nउसे छोड़ना आसान है';

  @override
  String get stEffortBody =>
      'जब ख़ुद को साबित करने के लिए कोई सामने न हो, तो प्रगति धीमी और मेहनत बेकार लगती है';

  @override
  String get stAloneTitle => 'अकेले ट्रेनिंग करना\nउबाऊ है';

  @override
  String get stAloneBody =>
      'कोई देख नहीं रहा। कोई गिन नहीं रहा। एक रेप, या पूरा सेट छोड़ देना आसान हो जाता है';

  @override
  String get qName => 'हम आपको क्या\nकहकर बुलाएँ?';

  @override
  String get nameHint => 'कम से कम 3 अक्षर। यही आपके प्रतिद्वंद्वी देखेंगे।';

  @override
  String get basicInfo => 'बढ़िया! अब कुछ\nबुनियादी जानकारी';

  @override
  String get qAge => 'आपकी उम्र क्या है?';

  @override
  String get qWeight => 'आपका मौजूदा\nवज़न कितना है?';

  @override
  String get weightWhy => 'आपकी रैंक निकालने के लिए शरीर का वज़न ज़रूरी है।';

  @override
  String get privateNote =>
      'आपकी जानकारी निजी है और किसी के साथ साझा नहीं की जाएगी।';

  @override
  String get qHeight => 'आपका कद कितना है?';

  @override
  String get qRelate => 'क्या नीचे दिया कथन\nआप पर लागू होता है?';

  @override
  String get yes => 'हाँ';

  @override
  String get no => 'नहीं';

  @override
  String get grindTitle => 'प्रतिद्वंद्वी हो तो\nमेहनत का मज़ा ही अलग है';

  @override
  String get grindBody =>
      'हर मैच आपको एक असली प्रतिद्वंद्वी के सामने खड़ा करता है: मेहनत कीजिए और साबित कीजिए कि किसने ज़्यादा ट्रेनिंग की।';

  @override
  String get allSet => 'सब तैयार है!';

  @override
  String welcomeLifter(String name) {
    return 'स्वागत है, $name। अब अपना पहला प्रतिद्वंद्वी ढूँढिए।';
  }

  @override
  String get lifter => 'खिलाड़ी';

  @override
  String get enterApp => 'OUTREPD में जाएँ';

  @override
  String get commitTitle => 'अब अपने फ़िटनेस सफ़र से\nएक वादा कीजिए';

  @override
  String get holdLogo => 'तैयार होने की पुष्टि के लिए लोगो को दबाए रखें';

  @override
  String get expNone => 'मैंने कभी वर्कआउट नहीं किया';

  @override
  String get iAm => 'मैं...';

  @override
  String get finishMatchQ => 'मैच समाप्त करें?';

  @override
  String get finishMatchBody =>
      'आपका कुल वज़न लॉक होकर प्रतिद्वंद्वी से तुलना किया जाएगा।';

  @override
  String get keepGoing => 'जारी रखें';

  @override
  String get forfeitQ => 'मैच छोड़ें?';

  @override
  String get forfeitBody => 'अभी निकले तो आप LP गँवा देंगे।';

  @override
  String get stay => 'रुकें';

  @override
  String get forfeit => 'हार मानें';

  @override
  String get pickExercises => 'वे एक्सरसाइज़ चुनें जो आप करेंगे';

  @override
  String matchingWith(String muscle) {
    return 'आपकी रैंक का खिलाड़ी ढूँढा जा रहा है · $muscle';
  }

  @override
  String get getReady => 'तैयार हो जाइए';

  @override
  String get timeLeft => 'शेष समय';

  @override
  String vsName(String name) {
    return 'बनाम $name';
  }

  @override
  String kgTotalVolume(String unit) {
    return '$unit कुल वज़न';
  }

  @override
  String get finishMatch => 'मैच समाप्त करें';

  @override
  String get kgHint => 'किग्रा';

  @override
  String get repsHint => 'रेप';

  @override
  String get addSet => 'सेट जोड़ें';

  @override
  String get matchComplete => 'मैच पूरा हुआ';

  @override
  String get you => 'आप';

  @override
  String get vs => 'बनाम';

  @override
  String get backToHome => 'होम पर लौटें';

  @override
  String get mgChest => 'छाती';

  @override
  String get mgBack => 'पीठ';

  @override
  String get mgLegs => 'पैर';

  @override
  String get mgShoulders => 'कंधे';

  @override
  String get mgArms => 'बाँहें';

  @override
  String get mgCore => 'कोर';

  @override
  String get achRivalry => 'प्रतिद्वंद्विता';

  @override
  String get achRivalryHint => 'एक ही प्रतिद्वंद्वी को 3 बार हराएँ';

  @override
  String get nWonTitle => 'आप जीत गए!';

  @override
  String nWonBody(String name, String muscle) {
    return '$muscle डे पर आपने $name को हराया';
  }

  @override
  String get nFriendTitle => 'नया दोस्ती अनुरोध';

  @override
  String nFriendBody(String name) {
    return '$name आपसे जुड़ना चाहता है';
  }

  @override
  String get nAchTitle => 'उपलब्धि खुली';

  @override
  String nAchBody(String title, String hint) {
    return '$title — $hint';
  }

  @override
  String get nRankTitle => 'रैंक बढ़ी!';

  @override
  String nRankBody(String rank) {
    return 'आप $rank तक पहुँचे';
  }

  @override
  String get nameTooShortInline => 'कम से कम 3 अक्षरों का नाम चुनें';

  @override
  String get whyName => 'हर नतीजे के साथ प्रतिद्वंद्वी यही देखेंगे';

  @override
  String get whyExperience => 'हम आपको आपके स्तर के लोगों से मिलाते हैं';

  @override
  String get whyGoal => 'आपकी पहली सुझाई गई एक्सरसाइज़ इसी से तय होती हैं';

  @override
  String get whyAge =>
      'उम्र उन ताक़त के मानकों को प्रभावित करती है जिनसे आपको मापा जाता है';

  @override
  String get whyWeight =>
      'रैंक वज़न को शरीर के भार के अनुपात में देखती है, सिर्फ़ किलो में नहीं';

  @override
  String get whyHeight =>
      'निष्पक्ष मानक तय करने के लिए आपके वज़न के साथ इस्तेमाल होता है';

  @override
  String get whyHabits =>
      'इससे रिमाइंडर और सुझाया गया साप्ताहिक लक्ष्य तय होता है';

  @override
  String get transitionPartOfIt =>
      '...तो चलिए पक्का करें कि आप वाक़ई इसका हिस्सा हैं।';

  @override
  String get male => 'पुरुष';

  @override
  String get female => 'महिला';

  @override
  String get usernamePlaceholder => 'नाम';

  @override
  String get stRoutine =>
      'मुझे नहीं पता कि किस हिस्से पर सच में काम चाहिए, इसलिए मैं अक्सर वही रूटीन दोहराता हूँ';

  @override
  String get shortIn => 'इंच';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String daysAgo(String n) {
    return '$n दिन पहले';
  }

  @override
  String weeksAgo(String n) {
    return '$n हफ़्ते पहले';
  }

  @override
  String membersCount(String n) {
    return '$n सदस्य';
  }

  @override
  String eachCount(String n) {
    return 'प्रति व्यक्ति $n';
  }

  @override
  String lpAmount(String n) {
    return '$n LP';
  }

  @override
  String get countWithCamera => 'कैमरे से गिनें';

  @override
  String get youWin => 'आप जीते!';

  @override
  String get defeated => 'हार';

  @override
  String get fillWholeNumbers => 'तीनों में पूर्ण संख्याएँ भरें';

  @override
  String heightRange(String min, String max, String unit) {
    return 'कद $min और $max $unit के बीच होना चाहिए';
  }

  @override
  String weightRange(String min, String max, String unit) {
    return 'वज़न $min और $max $unit के बीच होना चाहिए';
  }

  @override
  String ageRange(String min, String max) {
    return 'उम्र $min और $max के बीच होनी चाहिए';
  }

  @override
  String get discPush => 'Push';

  @override
  String get discPull => 'Pull';

  @override
  String get discLegs => 'Legs';

  @override
  String get discPushHint => 'Chest, shoulders and triceps';

  @override
  String get discPullHint => 'Back and biceps';

  @override
  String get discLegsHint => 'Quads, hamstrings and core';

  @override
  String get pickYourThree => 'Pick your three';

  @override
  String get pickThreeHint =>
      'Both of you lift all six — your three and theirs';

  @override
  String roundOf(String n, String total) {
    return 'Round $n of $total';
  }

  @override
  String get rest => 'Rest';

  @override
  String get work => 'Work';

  @override
  String get nextUp => 'Next up';

  @override
  String picksLeft(String n) {
    return '$n left to pick';
  }

  @override
  String get yourPick => 'Your pick';

  @override
  String get theirPick => 'Their pick';

  @override
  String secondsOfWork(String n) {
    return '$n seconds of work';
  }

  @override
  String lpOutOf(String total) {
    return '/ $total LP';
  }

  @override
  String toPromotion(String n) {
    return 'प्रमोशन में $n बाकी';
  }

  @override
  String get noFriendsTitle => 'अभी कोई दोस्त नहीं';

  @override
  String get noFriendsBody =>
      'किसी को जोड़ें और जब चाहें उसे निजी मैच के लिए चुनौती दें।';

  @override
  String get noMatchesTitle => 'अभी कोई मैच नहीं';

  @override
  String get noMatchesBody => 'पहला यहीं दिखेगा — जीत हो या हार।';

  @override
  String get noNotificationsTitle => 'कुछ नया नहीं';

  @override
  String get noNotificationsBody =>
      'मैच के न्योते, नतीजे और दोस्ती की रिक्वेस्ट यहाँ आती हैं।';

  @override
  String roundDone(String n) {
    return 'राउंड $n पूरा';
  }

  @override
  String get bestRoundYet => 'अब तक का सबसे अच्छा राउंड';
}
