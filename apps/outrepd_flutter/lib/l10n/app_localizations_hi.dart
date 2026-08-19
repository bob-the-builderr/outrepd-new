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
  String lpProgress(int lp, int left) {
    return '$lp / 100 LP · प्रमोशन में $left बाकी';
  }

  @override
  String winStreak(int count) {
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
  String changeNameLeft(int total, int left) {
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
  String titlesAndStreak(int owned, int total, int streak) {
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
  String goalRemaining(int reps, int days) {
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
  String seasonResets(int days) {
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
  String yourFriends(int count) {
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
  String lpToGo(int lp) {
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
  String xOfY(int a, int b) {
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
  String winLoss(int w, int l) {
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
}
