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
  String get tabProfile => 'प्रोफ़ाइल';

  @override
  String get challengeFriend => 'दोस्त को चुनौती दें';

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
  String get settings => 'सेटिंग्स';

  @override
  String get accountSection => 'खाता';

  @override
  String get duelSection => 'मुक़ाबला';

  @override
  String get hapticsEachRep => 'हर रेप पर कंपन';

  @override
  String get showSkeleton => 'स्केलेटन दिखाएँ';

  @override
  String get showSkeletonHint => 'इससे पता चलता है कि कैमरा आपको देख रहा है';

  @override
  String get manageNotifications => 'सूचनाएँ प्रबंधित करें';

  @override
  String switchesOn(String on, String all) {
    return '$all में से $on चालू';
  }

  @override
  String get whoCanChallenge => 'मुझे कौन चुनौती दे सकता है';

  @override
  String get blockedAccounts => 'ब्लॉक किए गए खाते';

  @override
  String get reportProblem => 'समस्या की रिपोर्ट करें';

  @override
  String get onDeviceNote =>
      'पोज़ डिटेक्शन इसी फ़ोन पर चलता है। कोई वीडियो या पोज़ डेटा अपलोड नहीं होता।';

  @override
  String get visibilitySection => 'दिखावट';

  @override
  String get showMyCountry => 'मेरा देश दिखाएँ';

  @override
  String get showMyCountryHint => 'बंद करने पर आप देश बोर्ड से हट जाते हैं';

  @override
  String get safetySection => 'सुरक्षा';

  @override
  String get socialSection => 'सामाजिक';

  @override
  String get noticeRaced => 'किसी ने मेरे सेट को चुनौती दी';

  @override
  String get noticeRacedHint => 'यह जानने का एकमात्र तरीका कि मुक़ाबला हुआ';

  @override
  String get noticeFriendOk => 'मेरा भेजा अनुरोध स्वीकार हुआ';

  @override
  String get noticesStoredNote =>
      'बंद करने का मतलब है वह कभी सहेजा ही नहीं जाता, छिपाया नहीं जाता।';

  @override
  String get notSaved => 'सेव नहीं हुआ';

  @override
  String get blockedIntro =>
      'ब्लॉक किया खाता न आपको चुनौती दे सकता है, न ढूँढ सकता है, न अनुरोध भेज सकता है। उन्हें बताया नहीं जाता।';

  @override
  String blockedWhen(String when) {
    return '$when ब्लॉक किया';
  }

  @override
  String get unblock => 'अनब्लॉक';

  @override
  String get noBlockedTitle => 'कोई ब्लॉक नहीं';

  @override
  String get noBlockedBody =>
      'आप किसी को उसकी प्रोफ़ाइल या रिपोर्ट से ब्लॉक कर सकते हैं।';

  @override
  String get whatHappened => 'क्या हुआ';

  @override
  String get reasonCheating => 'धोखाधड़ी या नक़ली रेप्स';

  @override
  String get reasonHarassment => 'उत्पीड़न या दुर्व्यवहार';

  @override
  String get reasonContent => 'अनुचित सामग्री';

  @override
  String get reasonImpersonation => 'किसी और का रूप धरना';

  @override
  String get reasonOther => 'कुछ और';

  @override
  String get addDetails => 'विवरण जोड़ें (वैकल्पिक)';

  @override
  String get alsoBlock => 'इस खाते को ब्लॉक भी करें';

  @override
  String get sendReport => 'रिपोर्ट भेजें';

  @override
  String get reportSent => 'रिपोर्ट भेज दी गई';

  @override
  String get reportingThisAccount => 'इस खाते की रिपोर्ट';

  @override
  String get exportIntro =>
      'हम आपको ईमेल से वह फ़ाइल भेजेंगे जिसमें सर्वर के पास आपका सब कुछ है। आमतौर पर एक मिनट लगता है।';

  @override
  String get whatsIncluded => 'इसमें क्या है';

  @override
  String get incProfile => 'आपकी प्रोफ़ाइल और रैंक';

  @override
  String get incSets => 'हर सेट और रेप काउंट';

  @override
  String get incDuels => 'मुक़ाबलों का इतिहास और रेटिंग बदलाव';

  @override
  String get incFriends => 'दोस्त और ब्लॉक किए खाते';

  @override
  String get incNotices => 'आपको भेजी गई सूचनाएँ';

  @override
  String get noLandmarksNote =>
      'पोज़ लैंडमार्क इसमें नहीं हैं, कभी थे भी नहीं। कैमरा उन्हें आपके फ़ोन पर पढ़ता है और वे कहीं नहीं भेजे जाते।';

  @override
  String get sendItTo => 'इसे भेजें';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get createAccountTitle => 'खाता बनाएं';

  @override
  String get createAccountBody => 'साइन इन करें, ताकि यह अकाउंट सिर्फ़ एक फ़ोन पर निर्भर न रहे।';

  @override
  String get createAccountAction => 'खाता बनाएं';

  @override
  String get emailTakenSwitchToSignIn =>
      'इस ईमेल का खाता पहले से मौजूद है — इसके बजाय साइन इन करें।';

  @override
  String get emailSignUpInvalid =>
      'ईमेल और पासवर्ड जांचें — कम से कम छह अक्षर।';

  @override
  String get tooManyCodes =>
      'बहुत सारे कोड भेजे जा चुके हैं — कुछ मिनट रुककर फिर से कोशिश करें।';

  @override
  String get sendCodeAction => 'कोड भेजें';

  @override
  String get noAccountForEmail => 'हमें उस ईमेल से कोई खाता नहीं मिला।';

  @override
  String get authEntryTagline => 'पुश करो। मुक़ाबला करो। सीढ़ी चढ़ो।';

  @override
  String get signUpWithEmail => 'ईमेल से साइन अप करें';

  @override
  String get alreadyHaveAccountQuestion => 'पहले से खाता है?';

  @override
  String get logInAction => 'लॉग इन करें';

  @override
  String get createYourAccountTitle => 'अपना खाता बनाएं';

  @override
  String get createAccountSubtitle => 'एक मिनट से भी कम समय लगता है।';

  @override
  String get usernameLabel => 'यूज़रनेम';

  @override
  String get emailLabel => 'ईमेल';

  @override
  String get logInSubtitle => 'अपनी रैंक बनाए रखने के लिए लॉग इन करें।';

  @override
  String get checkYourEmailTitle => 'अपना ईमेल जांचें';

  @override
  String codeSentTo(String email) {
    return 'हमने $email पर 6 अंकों का कोड भेजा है।';
  }

  @override
  String get didntGetIt => 'नहीं मिला?';

  @override
  String resendInSeconds(String time) {
    return '$time में फिर से भेजें';
  }

  @override
  String get wrongEmailGoBack => 'गलत ईमेल? वापस जाएं';

  @override
  String get usernameTaken => 'यह यूज़रनेम पहले से लिया जा चुका है।';

  @override
  String get wrongCode => 'यह कोड गलत है या समय समाप्त हो गया।';

  @override
  String get resendCode => 'कोड फिर भेजें';

  @override
  String get codeResent => 'नया कोड भेज दिया गया।';

  @override
  String signedInAs(String email) {
    return '$email के रूप में साइन इन किया गया';
  }

  @override
  String get addressNotKept =>
      'पता एक बार इस्तेमाल होता है, सहेजा नहीं जाता — इस खाते पर कोई ईमेल नहीं है।';

  @override
  String get requestMyData => 'मेरा डेटा ईमेल करें';

  @override
  String exportSent(String address) {
    return '$address पर भेजा गया';
  }

  @override
  String get deleteIntro =>
      'यह सब कुछ स्थायी रूप से मिटा देता है। न पलटा जा सकता है, न वापस लाया जा सकता है।';

  @override
  String get rankLabel => 'रैंक';

  @override
  String get wantCopyFirst => 'पहले एक प्रति चाहिए?';

  @override
  String get wantCopyBody =>
      'मिटाने से पहले अपना डेटा डाउनलोड कर लें। इसके बाद वह चला जाएगा।';

  @override
  String typeToConfirm(String word) {
    return 'पुष्टि के लिए $word लिखें';
  }

  @override
  String get deleteWord => 'मिटाओ';

  @override
  String get deletePermanently => 'स्थायी रूप से मिटाएँ';

  @override
  String get keepMyAccount => 'मेरा खाता रहने दें';

  @override
  String get save => 'सेव करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get skip => 'छोड़ें';

  @override
  String get yourPicture => 'आपकी तस्वीर';

  @override
  String get yourPictureHint =>
      'फ़्रेम आपकी रैंक से आता है और ऊपर चढ़ने पर बदलता है।';

  @override
  String get couldNotUsePicture => 'वह तस्वीर इस्तेमाल नहीं हो सकी';

  @override
  String get couldNotSyncAvatar =>
      'आपकी फ़ोटो सेव हो गई है, पर अभी सिंक नहीं हुई';

  @override
  String get removePhoto => 'फ़ोटो हटाएँ';

  @override
  String get removePhotoTitle => 'अपनी फ़ोटो हटाएँ?';

  @override
  String get removePhotoBody =>
      'इसकी जगह हर जगह आपका लिफ्टर दिखेगा। आप कभी भी नई फ़ोटो जोड़ सकते हैं।';

  @override
  String get removePhotoConfirm => 'हटाएँ';

  @override
  String get couldNotRemovePhoto => 'आपकी फ़ोटो नहीं हटाई जा सकी। फिर से कोशिश करें।';

  @override
  String get cropPhoto => 'क्रॉप करें';

  @override
  String get proGoTitle => 'Pro लें।';

  @override
  String get proOnboardTitle => 'आपका लिफ्टर, Pro।';

  @override
  String get proSubtitle => 'कोई विज्ञापन नहीं, और ऐसा लुक जो फ़्री ऐप में नहीं।';

  @override
  String get proFree => 'फ़्री';

  @override
  String get proYoursNow => 'अब आपका';

  @override
  String get proPerkNoAds => 'कोई विज्ञापन नहीं। कभी नहीं।';

  @override
  String get proPerkNoAdsBody => 'हर मैच, हर लेवल, बिना रुकावट।';

  @override
  String get proPerkBoard => 'हर बोर्ड पर चमक';

  @override
  String get proPerkBoardBody => 'एक होलो पंक्ति, जिससे आपका लिफ्टर बाहर निकलता है।';

  @override
  String get proPerkEntrance => 'बिजली के साथ एंट्री';

  @override
  String get proPerkEntranceBody => 'हर लाइव मैच से पहले VS स्क्रीन पर।';

  @override
  String get proPerkCovers => '9 चलते कवर';

  @override
  String get proPerkCoversBody => 'या आपकी अपनी फ़ोटो, आपकी प्रोफ़ाइल के ऊपर।';

  @override
  String get proPerkItems => '20 सिर्फ़-Pro आइटम';

  @override
  String get proPerkItemsBody => 'स्किन, कपड़े, गियर, और पलक झपकाने वाला लिफ्टर।';

  @override
  String get proGo => 'Pro लें';

  @override
  String proBuyYearly(String price) {
    return 'Pro लें · ${price}/साल';
  }

  @override
  String proBuyWeekly(String price) {
    return 'Pro लें · ${price}/सप्ताह';
  }

  @override
  String get proSettingsBody => 'कोई विज्ञापन नहीं, और Pro लुक।';

  @override
  String get proSettingsActive => 'आप Pro हैं। साथ देने के लिए धन्यवाद।';

  @override
  String get lifterMakerTitle => 'अवतार कस्टमाइज़ करें';

  @override
  String get lifterMakerFirst => 'अवतार कस्टमाइज़ करें';

  @override
  String get lifterMakerFirstBody => 'हर बोर्ड और हर मैच में यही आप हैं।';

  @override
  String get lifterTabSkin => 'स्किन';

  @override
  String get lifterTabHair => 'बाल';

  @override
  String get lifterTabFace => 'चेहरा';

  @override
  String get lifterTabBeard => 'दाढ़ी';

  @override
  String get lifterTabTop => 'कपड़े';

  @override
  String get lifterTabGear => 'गियर';

  @override
  String get lifterTabBackground => 'बैकग्राउंड';

  @override
  String get lifterEyes => 'आँखें';

  @override
  String get lifterBrows => 'भौंहें';

  @override
  String get lifterMouth => 'मुँह';

  @override
  String get lifterMarks => 'निशान';

  @override
  String get lifterRandom => 'रैंडम';

  @override
  String get lifterTryingPro => 'एक Pro लुक।';

  @override
  String get lifterUnlockPro => 'Pro से अनलॉक करें';

  @override
  String get editLifter => 'अपना लिफ्टर बदलें';

  @override
  String lifterNeedsWorld(String world) {
    return '${world} पूरा करें';
  }

  @override
  String lifterNeedsTier(String tier) {
    return '${tier} तक पहुँचें';
  }

  @override
  String lifterNeedsLevel(String level) {
    return 'लेवल ${level} तक पहुँचें';
  }

  @override
  String lifterNeedsWins(String count) {
    return '${count} मैच जीतें';
  }

  @override
  String lifterNeedsWinStreak(String count) {
    return 'लगातार ${count} जीतें';
  }

  @override
  String lifterNeedsDayStreak(String count) {
    return 'लगातार ${count} दिन ट्रेन करें';
  }

  @override
  String get lifterNeedsMonthTop10 => 'किसी महीने को टॉप 10 में खत्म करें';

  @override
  String get lifterNeedsMonthPodium => 'किसी महीने को टॉप 3 में खत्म करें';

  @override
  String get lifterNeedsMonthChampion => 'एक महीना जीतें';

  @override
  String lifterNeedsStars(String count) {
    return '${count} एडवेंचर लेवल पर 3 स्टार';
  }

  @override
  String get lifterNeedsAllStars => 'एडवेंचर का हर स्टार';

  @override
  String get coverTitle => 'कवर';

  @override
  String get coverPhoto => 'आपकी फ़ोटो';

  @override
  String get coverNone => 'कोई कवर नहीं';

  @override
  String get coverUse => 'यह कवर लगाएँ';

  @override
  String get coverProLine => 'कवर Pro के लिए हैं। ये चलते हैं, और आपकी प्रोफ़ाइल खोलने वाला हर कोई इन्हें देखता है।';

  @override
  String get coverCouldNotUpload => 'आपकी फ़ोटो अपलोड नहीं हो सकी। फिर से कोशिश करें।';

  @override
  String get coverNeonCity => 'नियॉन शहर';

  @override
  String get coverIronGym => 'आयरन जिम';

  @override
  String get coverRooftopSunset => 'छत पर सूर्यास्त';

  @override
  String get coverStadiumLights => 'स्टेडियम की रोशनी';

  @override
  String get coverSilverPeaks => 'चाँदी की चोटियाँ';

  @override
  String get coverBronzeDunes => 'काँसे के टीले';

  @override
  String get coverVolcano => 'ज्वालामुखी';

  @override
  String get coverPalmBeach => 'पाम बीच';

  @override
  String get coverWinterCity => 'सर्दियों का शहर';

  @override
  String get vsLiveRanked => 'लाइव · रैंक्ड';

  @override
  String get vsLiveFriendly => 'लाइव · दोस्ताना';

  @override
  String get vsSavedRanked => 'सेव्ड सेट · रैंक्ड';

  @override
  String get vsRematchFriendly => 'दोबारा मुक़ाबला · दोस्ताना';

  @override
  String get couldNotShareCard => 'यह कार्ड शेयर नहीं हो सका';

  @override
  String get couldNotOpenLink => 'यह लिंक नहीं खुल सका';

  @override
  String get couldNotCheckUsername =>
      'यह नाम जाँचा नहीं जा सका — फिर कोशिश करें';

  @override
  String get changeUsername => 'यूज़रनेम बदलें';

  @override
  String get usernameInvalidLength =>
      '4 से 20 अक्षर होने चाहिए, सिर्फ अक्षर, अंक और _';

  @override
  String get usernameChanged => 'यूज़रनेम बदल दिया गया';

  @override
  String get usernameAlreadyChangedBody => 'यूज़रनेम हर 14 दिन में एक बार बदला जा सकता है।';

  @override
  String get gallery => 'गैलरी';

  @override
  String get camera => 'कैमरा';

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
  String get global => 'वैश्विक';

  @override
  String get topPlayers => 'टॉप खिलाड़ी';

  @override
  String get yourTier => 'आपका टियर';

  @override
  String get challenge => 'चुनौती';

  @override
  String get notifications => 'सूचनाएँ';

  @override
  String get start => 'शुरू करें';

  @override
  String get finish => 'ख़त्म';

  @override
  String get reps => 'रेप';

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
  String get language => 'भाषा';

  @override
  String get privacy => 'प्राइवेसी';

  @override
  String get data => 'डेटा';

  @override
  String get about => 'ऐप के बारे में';

  @override
  String get themeSystem => 'डिवाइस जैसा';

  @override
  String get themeLight => 'हल्का';

  @override
  String get themeDark => 'गहरा';

  @override
  String get accept => 'स्वीकारें';

  @override
  String get visEveryone => 'सब लोग';

  @override
  String get visFriends => 'सिर्फ़ दोस्त';

  @override
  String get visNobody => 'कोई नहीं';

  @override
  String get friendRequestsLabel => 'दोस्ती के अनुरोध';

  @override
  String get showOnLeaderboards => 'लीडरबोर्ड पर मुझे दिखाएँ';

  @override
  String get exportData => 'मेरा डेटा निर्यात करें';

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
  String get deleteAccount => 'खाता मिटाएँ';

  @override
  String get needsServer =>
      'कनेक्ट नहीं हो सका। अपना इंटरनेट जांचें और फिर से कोशिश करें।';

  @override
  String get roomFriendly =>
      'रूम मैच दोस्ताना होते हैं — इनसे आपकी रैंक पर असर नहीं पड़ता।';

  @override
  String get shareThisCode => 'यह कोड साझा करें';

  @override
  String get codeCopied => 'कोड कॉपी हो गया';

  @override
  String xOfY(String a, String b) {
    return '$a / $b';
  }

  @override
  String get tierIron => 'लोहा';

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
  String winLoss(String w, String l) {
    return '$w जीत $l हार';
  }

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
  String get ttl_bronze_tier => 'लोहे से बाहर';

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
  String get forfeitQ => 'मैच छोड़ें?';

  @override
  String get forfeitBody => 'अभी निकले तो आप LP गँवा देंगे।';

  @override
  String get forfeitRematchBody => 'इसे हार माना जाएगा।';

  @override
  String get forfeit => 'हार मानें';

  @override
  String get getReady => 'तैयार हो जाइए';

  @override
  String get you => 'आप';

  @override
  String get vs => 'बनाम';

  @override
  String get backToHome => 'होम पर लौटें';

  @override
  String get mgChest => 'छाती';

  @override
  String get nWonTitle => 'आप जीत गए!';

  @override
  String nWonBody(String name, String muscle) {
    return '$muscle डे पर आपने $name को हराया';
  }

  @override
  String get nFriendTitle => 'नया दोस्ती अनुरोध';

  @override
  String get nRacedTitle => 'आपके सेट को चुनौती मिली';

  @override
  String nRacedHeld(String name, String yours, String theirs) {
    return '$name ने आपके सेट को चुनौती दी और पीछे रह गए, $yours–$theirs';
  }

  @override
  String nRacedBeaten(String name, String theirs, String yours) {
    return '$name ने आपके सेट को चुनौती दी और जीत गए, $theirs–$yours';
  }

  @override
  String get nFriendOkTitle => 'दोस्ती का अनुरोध स्वीकार हुआ';

  @override
  String nFriendOkBody(String name) {
    return '$name ने आपका अनुरोध स्वीकार किया';
  }

  @override
  String nFriendBody(String name) {
    return '$name आपसे जुड़ना चाहता है';
  }

  @override
  String get nChallengedTitle => 'दोबारा मुक़ाबला';

  @override
  String nChallengedBody(String name) {
    return '$name दोबारा मुक़ाबला चाहता है';
  }

  @override
  String get challengeSentTitle => 'चुनौती भेज दी गई';

  @override
  String challengeSentBody(String name) {
    return 'हम $name को बता देंगे। उनके मुक़ाबला करने के बाद वापस आएं।';
  }

  @override
  String get challengeNotSentTitle => 'भेजी नहीं जा सकी';

  @override
  String get challengeNotSentBody =>
      'अपना कनेक्शन जांचें और मैच टैब से फिर कोशिश करें।';

  @override
  String get challengeGoneTitle => 'चुनौती अब मौजूद नहीं है';

  @override
  String get challengeGoneBody =>
      'यह पहले ही खेली जा चुकी है, या वापस ले ली गई थी।';

  @override
  String repsRecordedLine(String reps) {
    return '$reps रेप्स दर्ज किए गए';
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
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String daysAgo(String n) {
    return '$n दिन पहले';
  }

  @override
  String weeksAgo(String n) {
    return '${n} हफ़्ते पहले';
  }

  @override
  String lpAmount(String n) {
    return '$n LP';
  }

  @override
  String get lpUnit => 'LP';

  @override
  String get trueCountHint => 'उदा. 12';

  @override
  String get couldNotSaveSession => 'सेशन सेव नहीं हो सका';

  @override
  String lpOutOf(String total) {
    return '/ $total LP';
  }

  @override
  String get noFriendsTitle => 'अभी कोई दोस्त नहीं';

  @override
  String get noFriendsBody =>
      'जानने वाले के ख़िलाफ़ मुक़ाबला कुछ और ही होता है।';

  @override
  String get decline => 'अस्वीकार';

  @override
  String requestSent(String name) {
    return '$name को अनुरोध भेजा गया';
  }

  @override
  String nowFriends(String name) {
    return 'अब आप और $name दोस्त हैं';
  }

  @override
  String get noOneFound => 'इस नाम का कोई नहीं है';

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
  String get countedThat => 'इस राउंड में गिने गए';

  @override
  String get thatIsRight => 'सही है';

  @override
  String get useMyCount => 'मेरी गिनती लें';

  @override
  String get confirmHint => 'कैमरा गलत हो तो बदल दें।';

  @override
  String get unsureMovement =>
      'यकीन नहीं कि यह सही मूवमेंट था — संख्या जाँच लें।';

  @override
  String get noRanksYet => 'अभी कोई रैंकिंग नहीं';

  @override
  String get noRanksYetBody => 'एक ड्यूल खेलें और बोर्ड भर जाएगा।';

  @override
  String get ranksTitle => 'रैंक';

  @override
  String get totalReps => 'कुल रेप्स';

  @override
  String get recent => 'हाल के';

  @override
  String wonVs(String name) {
    return '${name} से जीते';
  }

  @override
  String lostVs(String name) {
    return '${name} से हारे';
  }

  @override
  String hoursAgo(String n) {
    return '${n} घंटे पहले';
  }

  @override
  String toNextTier(String n, String tier) {
    return '${tier} तक ${n}';
  }

  @override
  String get noMatchesYet => 'अभी कोई ड्यूल नहीं';

  @override
  String get noMatchesYetBody => 'आपका पहला ड्यूल यहाँ दिखेगा, जीतें या हारें।';

  @override
  String get searchByUsername => 'यूज़रनेम से खोजें';

  @override
  String get incomingRequests => 'आई हुई रिक्वेस्ट';

  @override
  String get noRequestsWaiting => 'अभी कोई अनुरोध बाकी नहीं है';

  @override
  String get addFriendAction => 'दोस्त जोड़ें';

  @override
  String get addFriendHint =>
      'उनका यूज़रनेम डालें, या उनकी प्रोफ़ाइल वाला #कोड।';

  @override
  String get usernameOrCode => 'यूज़रनेम या #कोड';

  @override
  String get sendRequest => 'अनुरोध भेजें';

  @override
  String onlineNowCount(String count) {
    return 'अभी ऑनलाइन · $count';
  }

  @override
  String offlineCount(String count) {
    return 'ऑफ़लाइन · $count';
  }

  @override
  String get invite => 'बुलाएँ';

  @override
  String get headToHeadTitle => 'आमने-सामने';

  @override
  String get vsYouCaption => 'आपके विरुद्ध';

  @override
  String get h2hYou => 'आप';

  @override
  String get h2hThem => 'वह';

  @override
  String headToHead(String wins, String losses) {
    return 'आपके ख़िलाफ़ $wins जीत $losses हार';
  }

  @override
  String get neverPlayedYou => 'आपसे कभी नहीं खेला';

  @override
  String noHistoryWithThem(String username) {
    return 'आपने अभी तक $username से मुक़ाबला नहीं किया।';
  }

  @override
  String lastDuelScore(String yourReps, String theirReps, String when) {
    return 'पिछली बार: $yourReps–$theirReps, $when।';
  }

  @override
  String yourBestVsThemLine(String reps) {
    return 'उनके ख़िलाफ़ आपका सबसे अच्छा स्कोर $reps है।';
  }

  @override
  String get viewFullProfile => 'पूरी प्रोफ़ाइल देखें';

  @override
  String get moreOptions => 'और विकल्प';

  @override
  String get block => 'ब्लॉक करें';

  @override
  String get blockRowBody =>
      'वे आपको चुनौती नहीं दे सकेंगे या आपकी प्रोफ़ाइल नहीं देख सकेंगे';

  @override
  String get report => 'रिपोर्ट करें';

  @override
  String get reportRowBody => '24 घंटे में समीक्षा होगी';

  @override
  String muteChallenges(String username) {
    return '$username की चुनौतियाँ म्यूट करें';
  }

  @override
  String blockedLifter(String username) {
    return '$username को ब्लॉक किया';
  }

  @override
  String mutedLifter(String username) {
    return '$username को म्यूट किया';
  }

  @override
  String get addFriendButton => 'दोस्त जोड़ें';

  @override
  String get alreadyFriends => 'दोस्त';

  @override
  String get couldNotLoadProfile => 'यह प्रोफ़ाइल लोड नहीं हो सकी';

  @override
  String get noFriendsMatch => 'इस नाम का कोई नहीं';

  @override
  String get yourClimb => 'आपकी चढ़ाई';

  @override
  String get yourRank => 'आपकी रैंक';

  @override
  String get whoIsNext => 'अगला कौन?';

  @override
  String get opponentFound => 'प्रतिद्वंद्वी मिल गया';

  @override
  String get obSevenTiers => 'सात टियर';

  @override
  String get obRatingPerMatch => 'हर मैच की रेटिंग';

  @override
  String get obWinLabel => 'जीत';

  @override
  String get obLossLabel => 'हार';

  @override
  String get obFloorLabel => 'न्यूनतम';

  @override
  String obWinRating(String n) {
    return '+${n} + रेप्स का अंतर';
  }

  @override
  String obLossRating(String n) {
    return '−${n} − रेप्स का अंतर';
  }

  @override
  String obNeverBelow(String n) {
    return '${n} से नीचे कभी नहीं';
  }

  @override
  String obDivisionLine(String division, String tier) {
    return 'हर ${division} रेटिंग पर एक स्टेप, ${tier} पर एक टियर।';
  }

  @override
  String ratingFloor(String n) {
    return 'आपकी रेटिंग कभी ${n} से नीचे नहीं जाती।';
  }

  @override
  String floorKept(String tier, String rank) {
    return '$tier अब आपका है। आप $rank से नीचे नहीं जाएँगे।';
  }

  @override
  String dayStreakCount(String count) {
    return '$count दिन लगातार';
  }

  @override
  String get findMatch => 'मुक़ाबला ढूँढें';

  @override
  String rankedTerms(String seconds) {
    return '$seconds सेकंड · रैंक्ड';
  }

  @override
  String get practiceTerms => 'अभ्यास — न रैंक, न विरोधी';

  @override
  String get practiceComplete => 'अभ्यास पूरा';

  @override
  String get noRankYet => 'अभी कोई रैंक नहीं';

  @override
  String get unranked => 'अनरैंक्ड';

  @override
  String get practiceFirst => 'पहले अभ्यास';

  @override
  String get noConnection => 'कोई कनेक्शन नहीं';

  @override
  String get practiceOffline => 'ऑफ़लाइन अभ्यास';

  @override
  String get retry => 'फिर कोशिश करें';

  @override
  String get youWonPlain => 'आप जीते';

  @override
  String get cameraNeededTitle => 'कैमरा की अनुमति चाहिए';

  @override
  String get cameraNeededBody =>
      'outrepd आपके शरीर की हरकत देखकर रेप्स गिनता है। यह सब आपके डिवाइस पर होता है, कुछ अपलोड नहीं होता।';

  @override
  String get openSettings => 'सेटिंग्स खोलें';

  @override
  String get allowCamera => 'कैमरा की अनुमति दें';

  @override
  String get notNow => 'अभी नहीं';

  @override
  String get noCameraTitle => 'कोई कैमरा नहीं';

  @override
  String get noCameraBody =>
      'रेप्स कैमरे से गिने जाते हैं, इसलिए यह डिवाइस मुक़ाबला नहीं गिन सकता। बाकी सब चलता रहेगा।';

  @override
  String get noConnectionBody => 'मुक़ाबले के लिए कनेक्शन चाहिए। एडवेंचर ऑफ़लाइन भी चलता है और रेप्स बाद में सिंक हो जाएंगे।';

  @override
  String get getBackInFrame => 'फ़्रेम में वापस आएँ';

  @override
  String get clockStillRunning => 'घड़ी चल रही है। रेप्स नहीं गिने जा रहे।';

  @override
  String get giveUp => 'हार मानें';

  @override
  String get lpMovesWithGap => 'जीत: +25 और रेप्स का अंतर। हार: −20 और रेप्स का अंतर।';

  @override
  String get searchingForOpponent => 'विरोधी ढूँढ रहे हैं';

  @override
  String get getIntoPosition => 'पोज़ीशन लें';

  @override
  String get framingHint => 'कलाई और टखने फ़्रेम में होने चाहिए';

  @override
  String get goUp => 'ऊपर उठें';

  @override
  String get goDown => 'नीचे जाएँ';

  @override
  String get bestSet => 'सबसे अच्छा सेट';

  @override
  String get record => 'रिकॉर्ड';

  @override
  String get last7Days => 'पिछले 7 दिन';

  @override
  String repsCount(String count) {
    return '$count रेप्स';
  }

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get shareProfile => 'प्रोफ़ाइल शेयर करें';

  @override
  String get share => 'शेयर करें';

  @override
  String get duelMeOnOutrepd => 'outrepd पर मुझे चुनौती दें';

  @override
  String get shareStory => 'स्टोरी';

  @override
  String get sharePost => 'पोस्ट';

  @override
  String get copyLink => 'कॉपी करें';

  @override
  String get linkCopied => 'लिंक कॉपी हो गया';

  @override
  String get currentRankLabel => 'मौजूदा रैंक';

  @override
  String get winInitial => 'ज';

  @override
  String get lossInitial => 'ह';

  @override
  String get dayInitial => 'द';

  @override
  String rankPosition(String n) {
    return '#$n';
  }

  @override
  String get obTagline =>
      'पुश-अप की भिड़ंत। तुम्हारा फ़ोन गिनता है। कोई और भी गिन रहा है।';

  @override
  String get obGetStarted => 'शुरू करें';

  @override
  String get obHaveAccount => 'मेरा अकाउंट पहले से है';

  @override
  String get obTwoThings => 'दो छोटी बातें।';

  @override
  String get obAgeQuestion => 'तुम्हारी उम्र क्या है?';

  @override
  String get obHealthConsent =>
      'मैं समझता हूँ कि outrepd सिर्फ़ रेप्स गिनता है, कोई मेडिकल या ट्रेनिंग सलाह नहीं देता। दर्द हो तो मैं रुक जाऊँगा।';

  @override
  String get obTermsIntro => 'जारी रखने का मतलब है कि तुम सहमत हो';

  @override
  String get obTerms => 'शर्तों';

  @override
  String get obAnd => 'और';

  @override
  String get obPrivacy => 'प्राइवेसी नीति से';

  @override
  String get obCameraTitle => 'outrepd को तुम्हारा कैमरा चाहिए';

  @override
  String get obCameraBody =>
      'गिनने के लिए वह तुम्हारे शरीर की हरकत देखता है। इसका कोई और तरीका नहीं।';

  @override
  String get obCameraPrivateTitle => 'कुछ भी फ़ोन से बाहर नहीं जाता';

  @override
  String get obCameraPrivateBody =>
      'शरीर की ट्रैकिंग इसी डिवाइस पर होती है। कोई वीडियो कभी सेव या अपलोड नहीं होता।';

  @override
  String get obWhyNeeded => 'यह क्यों ज़रूरी है?';

  @override
  String get obPlacementTitle => 'फ़ोन को ज़मीन पर रखो';

  @override
  String get obPlacementBody => 'दीवार से टिका दो, अपने से क़रीब एक मीटर आगे।';

  @override
  String get obCheckHandsFeet => 'सिर, कंधे और हाथ फ़्रेम में';

  @override
  String get obCheckFacing => 'फ़ोन की तरफ़ मुँह, बग़ल में नहीं';

  @override
  String get obCheckLight => 'कमरे की रोशनी चालू';

  @override
  String get obImSetUp => 'सब तैयार है';

  @override
  String get obFramingTitle => 'पुश-अप पोज़िशन में आ जाओ';

  @override
  String get obFramingShoulders => 'कंधे और कूल्हे';

  @override
  String get obFramingWrists => 'कलाइयाँ';

  @override
  String get obLooksGood => 'सब ठीक लग रहा है';

  @override
  String get obCalibrating => 'कैलिब्रेट हो रहा है';

  @override
  String get obOneMoreRep => 'तुम्हारी रेंज जानने के लिए एक और';

  @override
  String get obCalibrationHint => 'अपनी सामान्य गहराई से तीन पुश-अप करो';

  @override
  String get obCalibrated => 'कैलिब्रेट हो गया।';

  @override
  String get obCalibratedBody =>
      'अब outrepd तुम्हारी रेंज जानता है। गहराई तुम्हारे हिसाब से नापी जाती है, किसी तय आँकड़े से नहीं।';

  @override
  String get obRepsCounted => 'गिनी गई रेप्स';

  @override
  String get obAverageDepth => 'औसत गहराई';

  @override
  String get obForm => 'फ़ॉर्म';

  @override
  String get obFormClean => 'साफ़';

  @override
  String get obAvailable => 'उपलब्ध';

  @override
  String get obTaken => 'पहले से लिया हुआ';

  @override
  String get obGotIt => 'समझ गया';

  @override
  String get obFormMixed => 'मिला-जुला';

  @override
  String get justNow => 'अभी-अभी';

  @override
  String get counterAccuracy => 'काउंटर की सटीकता';

  @override
  String get counterAccuracyCaption => 'कैमरा कितना क़रीब पहुँचता है';

  @override
  String measuredOverSets(String count) {
    return '$count सेट पर नापा गया';
  }

  @override
  String get accExact => 'बिलकुल सही';

  @override
  String get accWithinOne => '±1 रेप';

  @override
  String get accAverageMiss => 'औसत चूक';

  @override
  String get accTendsTo => 'झुकाव';

  @override
  String get accCountsHigh => 'ज़्यादा गिनना';

  @override
  String get accCountsLow => 'कम गिनना';

  @override
  String get accCountsEven => 'न ज़्यादा न कम';

  @override
  String get accWorstMiss => 'सबसे बड़ी चूक';

  @override
  String get accNothingYet => 'अभी कुछ नापा नहीं गया';

  @override
  String get accNothingYetBody =>
      'हर बार जब आप अभ्यास सेट के बाद गिनती की पुष्टि करते हैं, उस सेट की तुलना आपकी बताई संख्या से की जाती है। नतीजा यहाँ दिखता है।';

  @override
  String accNeedMore(String count) {
    return 'अभी शुरुआत है। यह आँकड़ा मायने रखने से पहले क़रीब $count सेट और चाहिए।';
  }

  @override
  String get accRecentSets => 'हाल के सेट';

  @override
  String get accCameraSaid => 'कैमरा';

  @override
  String get accYouSaid => 'तुम';

  @override
  String get accHowItWorks =>
      'यह तुमसे ही आया है, इसी फ़ोन पर। कुछ भी कहीं नहीं भेजा जाता।';

  @override
  String levelNumber(String n) {
    return 'लेवल $n';
  }

  @override
  String get youLostPlain => 'तुम हारे';

  @override
  String get rematch => 'दोबारा मुक़ाबला';

  @override
  String get shareAction => 'शेयर';

  @override
  String get doneAction => 'हो गया';

  @override
  String get continueAction => 'आगे बढ़ो';

  @override
  String get promotedLabel => 'पदोन्नति';

  @override
  String get highestReached => 'तुम्हारी अब तक की सबसे ऊँचाई';

  @override
  String repsOff(String n) {
    return '$n रेप्स पीछे।';
  }

  @override
  String get closestYet => 'अब तक का सबसे क़रीबी मुक़ाबला।';

  @override
  String repsAhead(String n) {
    return '$n रेप्स से आगे।';
  }

  @override
  String get winnerLabel => 'विजेता';

  @override
  String get newPersonalBest => 'नया व्यक्तिगत रिकॉर्ड';

  @override
  String get cantReachServer =>
      'सर्वर से कनेक्ट नहीं हो सका। अपना कनेक्शन जांचें और फिर से कोशिश करें।';

  @override
  String pushUpsInSeconds(String seconds) {
    return '$seconds सेकंड में पुश-अप';
  }

  @override
  String beatOpponent(String name, String score) {
    return '$name को हराया $score';
  }

  @override
  String lostToOpponent(String name, String score) {
    return '$name से हारा $score';
  }

  @override
  String get thinkYouCanBeatMe => 'क्या तुम मुझे हरा सकते हो?';

  @override
  String get usernameNotAllowed =>
      'यह नाम इस्तेमाल नहीं किया जा सकता। कोई दूसरा आज़माएँ।';

  @override
  String get yourBest => 'आपका बेस्ट';

  @override
  String get theClock => 'घड़ी';

  @override
  String get nobodyFreeRaceBest =>
      'अभी आपकी रैंक के पास कोई खाली नहीं है। अपने बेस्ट से मुकाबला करें। इससे आपकी रैंक नहीं बदलेगी।';

  @override
  String get nobodyFreeFirstScore =>
      'अभी आपकी रैंक के पास कोई खाली नहीं है। अपना पहला स्कोर बनाएँ। इससे आपकी रैंक नहीं बदलेगी।';

  @override
  String bestStillIs(String count) {
    return 'आपका बेस्ट अब भी $count है';
  }

  @override
  String get setInPoolTitle => 'आपका सेट पूल में है';

  @override
  String get setInPoolBody =>
      'आपकी रैंक के पास वाला अगला खिलाड़ी इससे मुकाबला करेगा। कौन जीता, यह सूचनाओं में दिखेगा, और तभी आपकी रैंक बदलेगी।';

  @override
  String get obWhyNeededBody =>
      'हर रेप इस बात से आँका जाता है कि आप कितना नीचे जाते हैं और कितना ऊपर वापस आते हैं, और यह सिर्फ़ कैमरा देख सकता है। इसके बिना गिनती नहीं, और गिनती के बिना ड्युएल नहीं। कैमरा सिर्फ़ सेट के दौरान चालू रहता है।';

  @override
  String get obWelcomeBack => 'वापसी पर स्वागत है';

  @override
  String obTitlesHeading(String count) {
    return 'कमाने के लिए $count टाइटल';
  }

  @override
  String get obTitlesBody =>
      'जीत, लगातार दिनों, साफ़ सेट, सुबह जल्दी और बहुत कुछ के लिए। एक को अपने नाम के नीचे पहनें।';

  @override
  String get obFriendsHeading => 'दोस्तों के साथ फ़ैसला करें';

  @override
  String get obFriendsBody =>
      'दोस्त इस कोड से आपको जोड़ते हैं। जब चाहें उन्हें चुनौती दें, और आपके बीच का स्कोर सहेजा रहता है।';

  @override
  String get obLetsGo => 'चलिए शुरू करें';

  @override
  String get paywallTitle => 'लोहा से मास्टर तक चढ़ें';

  @override
  String get paywallPerkDuels => 'कैमरे से जज किए गए मुकाबले';

  @override
  String get paywallPerkLadder => 'लाइव रैंकिंग';

  @override
  String get paywallPerkFriends => 'दोस्त और चुनौतियाँ';

  @override
  String get paywallPerkHistory => 'हर मैच का हर रेप';

  @override
  String get paywallYearly => 'सालाना';

  @override
  String get paywallWeekly => 'साप्ताहिक';

  @override
  String paywallPerWeek(String price) {
    return '${price}/सप्ताह';
  }

  @override
  String get paywallEveryWeek => 'प्रति सप्ताह';

  @override
  String paywallSave(String percent) {
    return '${percent}% बचाएँ';
  }

  @override
  String get paywallRenewsPlay => 'रद्द करने तक अपने-आप रिन्यू होता है। Google Play में कभी भी रद्द करें।';

  @override
  String get paywallRenewsApple => 'रद्द करने तक अपने-आप रिन्यू होता है। अपनी Apple खाता सेटिंग में कभी भी रद्द करें।';

  @override
  String get paywallRestore => 'रीस्टोर करें';

  @override
  String get paywallTerms => 'शर्तें';

  @override
  String get paywallPrivacy => 'गोपनीयता';

  @override
  String get paywallLoadFailed => 'प्लान लोड नहीं हो सके। अपना कनेक्शन जाँचें और फिर कोशिश करें।';

  @override
  String get paywallBuyFailed => 'खरीदारी पूरी नहीं हुई। फिर कोशिश करें।';

  @override
  String get paywallPending => 'आपका भुगतान लंबित है। स्टोर की पुष्टि होते ही सब कुछ खुल जाएगा।';

  @override
  String get paywallNothingToRestore => 'रीस्टोर करने के लिए कोई सदस्यता नहीं मिली।';

  @override
  String get paywallRestored => 'सदस्यता रीस्टोर हो गई';

  @override
  String paywallSignedInAs(String email) {
    return '${email} के रूप में साइन इन';
  }

  @override
  String get deleteKeepsSubscription => 'खाता मिटाने से आपकी सदस्यता रद्द नहीं होती — बिल स्टोर करता है, outrepd नहीं। पहले Google Play या अपनी Apple खाता सेटिंग में इसे रद्द करें।';

  @override
  String get signOut => 'साइन आउट करें';

  @override
  String get signOutQuestion => 'साइन आउट करें?';

  @override
  String get signOutBody => 'आपका अकाउंट वैसा ही रहेगा, अपनी रैंक, हिस्ट्री और सब्सक्रिप्शन के साथ। कभी भी उसी तरीके से फिर साइन इन करें जैसे पहले किया था।';

  @override
  String get shareVictory => 'जीत';

  @override
  String get shareRematch => 'फिर से मुकाबला?';

  @override
  String friendCodeInvite(String code) {
    return 'outrepd पर मुझसे मुकाबला करो। मेरे फ्रेंड कोड ${code} से मुझे जोड़ो\nhttps://outrepd.com';
  }

  @override
  String get soundsLabel => 'आवाज़ें';

  @override
  String get soundsHint => '3, 2, 1 पर बीप, हर रेप पर टिक और राउंड का अंत। आपके संगीत के ऊपर बजता है।';

  @override
  String get phoneSection => 'इस फ़ोन पर';

  @override
  String get allowNotifications => 'सूचनाओं की अनुमति दें';

  @override
  String get allowNotificationsHint => 'फ़ोन की सेटिंग में OUTREPD के लिए ये बंद हैं, इसलिए नीचे की कोई सूचना आप तक नहीं पहुँचेगी।';

  @override
  String get remindersSection => 'रिमाइंडर';

  @override
  String get dailyReminder => 'रोज़ का रिमाइंडर';

  @override
  String get dailyReminderHint => 'सिर्फ़ उन दिनों जब आपका लक्ष्य अभी पूरा नहीं हुआ है।';

  @override
  String get reminderTime => 'समय';

  @override
  String get reminderTitle => 'आज के पुश-अप्स का समय';

  @override
  String reminderStreakBody(String count) {
    return 'अपनी ${count} दिन की स्ट्रीक जारी रखें। एक सेट काफ़ी है।';
  }

  @override
  String get channelMatches => 'मैच और दोस्त';

  @override
  String get channelReminders => 'रोज़ का रिमाइंडर';

  @override
  String get liveTag => 'लाइव';

  @override
  String get reconnecting => 'फिर से जुड़ रहा है';

  @override
  String get rankedLive => 'रैंक्ड · लाइव';

  @override
  String get lookingForLive => 'लाइव प्रतिद्वंद्वी खोज रहे हैं';

  @override
  String ofTime(String time) {
    return '${time} में से';
  }

  @override
  String liveFallbackAt(String time) {
    return '${time} पर आप एक सेव्ड सेट से मुकाबला करेंगे';
  }

  @override
  String liveFoundBody(String name) {
    return '${name} अभी कैमरे पर हैं। एक ही घड़ी, एक ही शुरुआत।';
  }

  @override
  String get nobodyLiveTitle => 'अभी कोई लाइव नहीं है';

  @override
  String get nobodyLiveBody => 'आप एक सेव्ड सेट से मुकाबला करेंगे';

  @override
  String didRepsIn(String reps) {
    return '60 सेकंड में ${reps} किए';
  }

  @override
  String get sameRankPoints => 'लाइव मैच जितने ही रैंक पॉइंट';

  @override
  String get raceIt => 'मुकाबला करें';

  @override
  String get onlineNow => 'अभी ऑनलाइन';

  @override
  String get friendlyNoRank => 'दोस्ताना · बिना रैंक';

  @override
  String waitingForName(String name) {
    return '${name} का इंतज़ार';
  }

  @override
  String get weSentThemANotice => 'हमने उन्हें सूचना भेज दी है';

  @override
  String get untilInviteRunsOut => 'न्योता खत्म होने तक';

  @override
  String get cancelInvite => 'न्योता रद्द करें';

  @override
  String inviteDeclined(String name) {
    return '${name} ने कहा अभी नहीं';
  }

  @override
  String get inviteRanOut => 'न्योते का समय खत्म हो गया';

  @override
  String get inviteAgain => 'फिर से न्योता दें';

  @override
  String liveInviteFrom(String name) {
    return '${name} लाइव हैं';
  }

  @override
  String timeLeft(String time) {
    return '${time} बाकी';
  }

  @override
  String get joinLive => 'जुड़ें';

  @override
  String get nLiveTitle => 'लाइव न्योता';

  @override
  String nLiveBody(String name) {
    return '${name} लाइव मुकाबला करना चाहते हैं';
  }

  @override
  String get inviteGone => 'उस न्योते का समय खत्म हो गया';

  @override
  String opponentDropped(String name) {
    return '${name} का कनेक्शन टूट गया। जारी रखें: राउंड समय पूरा होने पर खत्म होगा।';
  }

  @override
  String opponentGaveUp(String name) {
    return '${name} ने हार मान ली। जीत के लिए राउंड पूरा करें।';
  }

  @override
  String get calledOffTitle => 'मैच रद्द हो गया';

  @override
  String calledOffBody(String name) {
    return '${name} शुरुआत तक नहीं पहुँचे। कुछ भी दर्ज नहीं हुआ।';
  }

  @override
  String waitingForFinal(String name) {
    return '${name} की अंतिम गिनती का इंतज़ार…';
  }

  @override
  String get wantsToBeFriends => 'दोस्त बनना चाहते हैं';

  @override
  String get giveUpQuestion => 'यह राउंड छोड़ दें?';

  @override
  String get giveUpBody => 'इसे हार माना जाएगा, आपकी अभी की गिनती चाहे जो हो।';

  @override
  String waitingToJoin(String name) {
    return '${name} के जुड़ने का इंतज़ार';
  }

  @override
  String get removeFriend => 'दोस्त हटाएँ';

  @override
  String get removeFriendBody => 'उन्हें बताया नहीं जाएगा, और आप फिर से एक-दूसरे को जोड़ सकते हैं';

  @override
  String removeFriendQuestion(String username) {
    return '${username} को अपने दोस्तों से हटाएँ?';
  }

  @override
  String get removeAction => 'हटाएँ';

  @override
  String removedFriend(String username) {
    return '${username} को दोस्तों से हटा दिया';
  }

  @override
  String get noticeChallenged => 'किसी ने मुझे रीमैच की चुनौती दी';

  @override
  String get noticeLiveInvite => 'किसी दोस्त ने मुझे लाइव मैच में बुलाया';

  @override
  String get obIdeaTitle => '60 सेकंड। एक प्रतिद्वंद्वी।';

  @override
  String get obIdeaRival => 'असली इंसान, लाइव या उसका रिकॉर्ड किया हुआ सेट';

  @override
  String get obIdeaCamera => 'आपका कैमरा हर रेप गिनता है, आपके फ़ोन पर ही';

  @override
  String get thisMonth => 'इस महीने';

  @override
  String shortDays(String n) {
    return '${n} दिन';
  }

  @override
  String shortHours(String n) {
    return '${n} घंटे';
  }

  @override
  String get awardChampion => 'चैंपियन';

  @override
  String get awardPodium => 'पोडियम';

  @override
  String get awardTop10 => 'टॉप 10';

  @override
  String get awardRegular => '20 क्लब';

  @override
  String monthToTop10(String lp) {
    return 'टॉप 10 से ${lp} अंक दूर';
  }

  @override
  String monthIfEndedNow(String award) {
    return 'महीना अभी खत्म हो तो: ${award}';
  }

  @override
  String get monthJoinHint => 'इस महीने के बोर्ड पर आने के लिए एक रैंक्ड ड्यूल खेलें';

  @override
  String monthRegularProgress(String progress) {
    return '20 क्लब बैज · ${progress} रैंक्ड ड्यूल';
  }

  @override
  String get monthRegularEarned => 'इस महीने का 20 क्लब बैज मिल गया';

  @override
  String get monthEmptyTitle => 'नया महीना';

  @override
  String get monthEmptyBody => 'इस महीने अभी तक किसी ने अंक नहीं बनाए। पहला रैंक्ड ड्यूल जीतें और आप सबसे आगे।';

  @override
  String get weekEmptyTitle => 'नया हफ़्ता';

  @override
  String get weekEmptyBody => 'इस हफ़्ते अभी तक किसी ने अंक नहीं बनाए। पहला रैंक्ड ड्यूल जीतें और आप सबसे आगे।';

  @override
  String get ratingUnit => 'रेटिंग';

  @override
  String get ptsUnit => 'अंक';

  @override
  String ptsAmount(String n) {
    return '${n} अंक';
  }

  @override
  String ratingAmount(String n) {
    return '${n} रेटिंग';
  }

  @override
  String ratingForWin(String n) {
    return 'जीत के ${n}';
  }

  @override
  String ratingForLoss(String n) {
    return 'हार के ${n}';
  }

  @override
  String ratingForReps(String n) {
    return 'रेप्स के ${n}';
  }

  @override
  String get boardThisWeek => 'इस हफ़्ते';

  @override
  String get boardOverall => 'कुल';

  @override
  String get howPointsWork => 'पॉइंट्स कैसे मिलते हैं';

  @override
  String streakNextTen(String n) {
    return 'लगातार ${n} जीत: अगली जीत +10';
  }

  @override
  String get boardRuleWin => 'जीत +5';

  @override
  String get boardRuleLoss => 'हार −2';

  @override
  String get boardRuleStreak => 'लगातार 3 जीत: +10';

  @override
  String rankNext(String rank) {
    return 'अगला: ${rank}';
  }

  @override
  String rankAt(String n) {
    return '${n} पर';
  }

  @override
  String toGo(String n) {
    return '${n} बाकी';
  }

  @override
  String tierStartsAt(String tier, String n) {
    return '${tier} ${n} से शुरू';
  }

  @override
  String rankedDuelsCount(String n) {
    return '${n} रैंक्ड ड्यूल';
  }

  @override
  String get monthlyAwards => 'मासिक पुरस्कार';

  @override
  String get seasonOver => 'सीज़न खत्म';

  @override
  String get seasonOverBody => 'अब यह आपकी प्रोफ़ाइल पर है। नया महीना शून्य से शुरू होता है।';

  @override
  String get seasonPlayCta => 'नया महीना खेलें';

  @override
  String monthWinners(String month) {
    return '${month} के विजेता';
  }

  @override
  String get playShort => 'खेलें';

  @override
  String get rematchLive => 'लाइव रीमैच';

  @override
  String rematchWaiting(String name) {
    return '${name} का इंतज़ार';
  }

  @override
  String rematchAsked(String name) {
    return '${name} रीमैच चाहता है';
  }

  @override
  String get rematchGone => 'इस बार रीमैच नहीं';

  @override
  String get twoRankedADay => 'दोस्ताना · एक ही खिलाड़ी के साथ दिन में 2 रैंक्ड';

  @override
  String monthMove(String move) {
    return 'इस महीने · ${move}';
  }

  @override
  String promotedFrom(String rank) {
    return '${rank} से';
  }

  @override
  String liveOnlineNow(String n) {
    return 'अभी ${n} ऑनलाइन';
  }

  @override
  String liveSearchingNow(String n) {
    return '${n} खोज रहे हैं';
  }

  @override
  String get dailyGoalTitle => 'आज का लक्ष्य';

  @override
  String get dailyGoalDone => 'आज का पूरा';

  @override
  String dailyGoalProgress(String progress) {
    return '${progress} पुश-अप';
  }

  @override
  String dailyGoalLeft(String n) {
    return '${n} बाकी';
  }

  @override
  String get dailyGoalChange => 'बदलें';

  @override
  String get dailyGoalPick => 'आपका रोज़ का लक्ष्य';

  @override
  String dailyGoalOption(String n) {
    return 'रोज़ ${n} पुश-अप';
  }

  @override
  String widgetGoalOf(String goal) {
    return 'आज ${goal} में से';
  }

  @override
  String get saveToAppleHealth => 'वर्कआउट Apple Health में सेव करें';

  @override
  String get saveToHealthConnect => 'वर्कआउट Health Connect में सेव करें';

  @override
  String get saveToHealthHint => 'हर सेट स्ट्रेंथ वर्कआउट के रूप में जुड़ता है। कुछ भी पढ़ा नहीं जाता।';

  @override
  String get healthNotAllowed => 'अभी अनुमति नहीं है। आप फ़ोन की हेल्थ सेटिंग में अनुमति दे सकते हैं।';

  @override
  String reminderLeft(String count) {
    return 'आज के लक्ष्य के लिए ${count} पुश-अप बाकी हैं।';
  }

  @override
  String get liveInviteHint => 'ऑनलाइन दोस्त तुरंत जुड़ सकते हैं। बाकियों को सूचना मिलती है और जुड़ने के लिए एक मिनट।';

  @override
  String get requestSentShort => 'अनुरोध भेजा गया';

  @override
  String healthWorksWith(String health) {
    return 'OUTREPD ${health} के साथ काम करता है';
  }

  @override
  String healthCardBody(String health) {
    return 'आपका हर पूरा किया गया सेट ${health} में स्ट्रेंथ वर्कआउट के रूप में सेव होता है। OUTREPD आपका हेल्थ डेटा कभी नहीं पढ़ता।';
  }

  @override
  String savedToHealth(String health) {
    return '${health} में सेव किया गया';
  }

  @override
  String get usernameTooShort => 'बहुत छोटा: कम से कम 4 अक्षर';

  @override
  String get usernameBadCharacters => 'सिर्फ अक्षर, अंक और _';

  @override
  String get usernameNeedsLetter => 'कम से कम एक अक्षर या अंक जोड़ें';

  @override
  String usernameChangeAgainOn(String date) {
    return 'आप इसे ${date} को फिर से बदल सकते हैं';
  }

  @override
  String get continueWithApple => 'Apple के साथ जारी रखें';

  @override
  String get continueWithGoogle => 'Google के साथ जारी रखें';

  @override
  String get socialSignInFailed => 'साइन इन नहीं हो सका। फिर से कोशिश करें।';

  @override
  String get chooseUsernameTitle => 'अपना यूज़रनेम चुनें';

  @override
  String get chooseUsernameSubtitle => 'इसी से दूसरे लोग आपको ढूंढते हैं और रैंकिंग में देखते हैं।';

  @override
  String get authHeroTitle => 'किसी को भी हराओ।';

  @override
  String get authHeroSubtitle => 'लाइव पुश-अप मुकाबले, आपका कैमरा गिनता है।';

  @override
  String get createAccountPitch => 'आपकी रैंक और मुकाबले, हर फ़ोन पर।';

  @override
  String get usernameSpacesHint => 'स्पेस _ बन जाते हैं';

  @override
  String get emailCodeNote => 'हम आपको ईमेल पर 6 अंकों का कोड भेजेंगे। कोई पासवर्ड नहीं।';

  @override
  String get continueWithEmail => 'ईमेल के साथ जारी रखें';

  @override
  String get thisSeason => 'यह सीज़न';

  @override
  String get thisWeek => 'यह हफ़्ता';

  @override
  String get weekStartsAgain => 'हर सोमवार फिर से शुरू होता है';

  @override
  String get lengthWeek => 'हफ़्ता';

  @override
  String get lengthMonth => 'महीना';

  @override
  String get weekJoinHint => 'बोर्ड पर आने के लिए इस हफ़्ते एक रैंक्ड मुकाबला जीतें';

  @override
  String get weekInTop3 => 'इस हफ़्ते टॉप 3 में';

  @override
  String weekToTop3(String n) {
    return 'टॉप 3 तक ${n} अंक';
  }

  @override
  String get boardActiveNote => 'पिछले 30 दिनों में सक्रिय खिलाड़ी';

  @override
  String get boardTieNote => 'बराबरी पर: ज़्यादा जीत वाले पहले';

  @override
  String lpBreakdown(String reps, String adjust, String rank) {
    return 'रेप्स के लिए ${reps} · ${rank} विरोधी के लिए ${adjust}';
  }

  @override
  String levelShort(String n) {
    return 'Lv ${n}';
  }

  @override
  String xpOf(String into, String span) {
    return '${into} / ${span} XP';
  }

  @override
  String xpToLevel(String n, String level) {
    return 'लेवल ${level} तक ${n} XP';
  }

  @override
  String xpHow(String rep, String match) {
    return 'हर रेप पर ${rep} XP, हर जीत पर ${match}, हार पर कुछ नहीं';
  }

  @override
  String xpGained(String n) {
    return '+${n} XP';
  }

  @override
  String xpForReps(String n) {
    return 'रेप्स के लिए ${n}';
  }

  @override
  String xpForMatch(String n) {
    return 'मुक़ाबले के लिए ${n}';
  }

  @override
  String get levelUp => 'लेवल अप';

  @override
  String get levelUpBody => 'हर रेप मायने रखता है। लगे रहो।';

  @override
  String giveUpAhead(String n) {
    return 'आप ${n} आगे हैं';
  }

  @override
  String giveUpBehind(String n) {
    return 'आप ${n} पीछे हैं';
  }

  @override
  String get giveUpTied => 'बराबरी';

  @override
  String get keepGoing => 'जारी रखें';

  @override
  String get stay => 'रुकें';

  @override
  String lastN(String n) {
    return 'पिछले ${n}';
  }

  @override
  String get firstMatchForTier => 'रैंकिंग में आने के लिए अपना पहला मुक़ाबला खेलें। सब Iron V से शुरू करते हैं।';

  @override
  String get firstMatchForBoard => 'बोर्ड पर आने के लिए अपना पहला मुक़ाबला खेलें। सब Iron V से शुरू करते हैं।';

  @override
  String get playFirstMatch => 'पहला मुक़ाबला खेलें';

  @override
  String firstMatchTerms(String seconds) {
    return 'एक मुक़ाबला · ${seconds} सेकंड';
  }

  @override
  String get placedLabel => 'आप रैंकिंग में आ गए';

  @override
  String get placedBody => 'सब यहीं से शुरू करते हैं। सिर्फ़ जीत आपको ऊपर ले जाती है।';

  @override
  String get placedHow => 'जीत: +25 और रेप्स का अंतर। हार: −20 और रेप्स का अंतर।';

  @override
  String get levelBesideName => 'आपके नाम के साथ, हर जगह';

  @override
  String get weekRaceTitle => 'इस हफ़्ते की रेस';

  @override
  String get streakDoneToday => 'आज हो गया';

  @override
  String get streakTrainToday => 'आज ट्रेन करें, एक दिन और जुड़ेगा';

  @override
  String get raceChartTitle => 'मिनट कैसे बीता';

  @override
  String raceYouLead(String time) {
    return '${time} · आप आगे निकल गए';
  }

  @override
  String raceTheyLead(String time, String name) {
    return '${time} · ${name} आगे निकल गए';
  }

  @override
  String get bringFriendTitle => 'किसी दोस्त को लाएँ';

  @override
  String get bringFriendBody => 'अपना लिंक भेजें। यह आपकी प्रोफ़ाइल खोलता है, जहाँ वे आपको जोड़ सकते हैं।';

  @override
  String get bringFriendShare => 'मेरा लिंक शेयर करें';

  @override
  String get bringFriendShareText => 'OUTREPD पर पुश-अप में मुझसे मुक़ाबला करो। 60 सेकंड, लाइव, और कैमरा गिनता है।';

  @override
  String orFriendCode(String code) {
    return 'या फ़्रेंड कोड ${code}';
  }

  @override
  String get countryPickerTitle => 'आपका देश';

  @override
  String get countrySearch => 'खोजें';

  @override
  String get countryFromPhone => 'आपके फ़ोन से';

  @override
  String get countryAll => 'सभी देश';

  @override
  String get countryChoose => 'अपना देश चुनें';

  @override
  String get countryChange => 'बदलें';

  @override
  String get countryForBoard => 'आपके देश के लीडरबोर्ड के लिए';

  @override
  String get countryLabel => 'देश';

  @override
  String get countryChanged => 'देश बदल गया';

  @override
  String get countryEvery14 => 'हर 14 दिन में एक बार, आपके नाम की तरह';

  @override
  String get countryNotSaved => 'आपका देश सेव नहीं हो सका। फिर से कोशिश करें।';

  @override
  String get adventure => 'एडवेंचर';

  @override
  String stageNumber(String n) {
    return 'लेवल ${n}';
  }

  @override
  String adventureLevelIn(String level, String world) {
    return 'लेवल ${level} · ${world}';
  }

  @override
  String adventureClearedOf(String cleared, String total) {
    return '${total} में से ${cleared} पार · कोई रैंक नहीं';
  }

  @override
  String get worldIron => 'लोहे की खदानें';

  @override
  String get worldBronze => 'कांस्य के टीले';

  @override
  String get worldSilver => 'चाँदी की चोटियाँ';

  @override
  String get worldGold => 'स्वर्ण दुर्ग';

  @override
  String get worldPlatinum => 'प्लैटिनम हिमनद';

  @override
  String get worldDiamond => 'हीरे की गुफाएँ';

  @override
  String get worldMaster => 'मास्टर का सिंहासन';

  @override
  String worldNumber(String n) {
    return 'दुनिया ${n}';
  }

  @override
  String fightLevel(String level) {
    return 'लेवल ${level} लड़ें';
  }

  @override
  String levelHpLine(String hp, String reps) {
    return 'HP ${hp} · लगभग ${reps} पुश-अप';
  }

  @override
  String get hpShort => 'HP';

  @override
  String comboTag(String n) {
    return 'कॉम्बो ×${n}';
  }

  @override
  String get levelCleared => 'पार किया';

  @override
  String get outOfTime => 'समय खत्म';

  @override
  String get statPushUps => 'पुश-अप';

  @override
  String get statTimeLeft => 'बाकी';

  @override
  String get statHpLeft => 'HP बाकी';

  @override
  String get statXp => 'XP';

  @override
  String secondStarHint(String seconds) {
    return 'दूसरे सितारे के लिए ${seconds} सेकंड बचाकर खत्म करें';
  }

  @override
  String thirdStarHint(String seconds) {
    return 'तीसरे सितारे के लिए ${seconds} सेकंड बचाकर खत्म करें';
  }

  @override
  String get fightLostHint => 'ज़्यादा सितारों के लिए पिछले लेवल फिर से जीतें: इनसे ताकतवर हथियार खुलते हैं।';

  @override
  String get nextLevel => 'अगला लेवल';

  @override
  String get tryAgain => 'फिर कोशिश करें';

  @override
  String get adventureMap => 'मैप';

  @override
  String get nextKicker => 'अगला';

  @override
  String nextLevelLine(String level, String hp) {
    return 'लेवल ${level} · HP ${hp}';
  }

  @override
  String get armory => 'शस्त्रागार';

  @override
  String get armoryBody => 'सितारों से हथियार खुलते हैं। हर दुनिया के राक्षसों पर सिर्फ़ उसी दुनिया का हथियार या उससे बेहतर असर करता है।';

  @override
  String get equipped => 'चालू';

  @override
  String perPushUp(String damage) {
    return 'हर पुश-अप पर ${damage}';
  }

  @override
  String damagePerPushUp(String damage) {
    return 'हर पुश-अप पर ${damage} नुकसान';
  }

  @override
  String wasWith(String damage, String weapon) {
    return 'पहले ${weapon} से ${damage}';
  }

  @override
  String moreStars(String count) {
    return '${count} और सितारे';
  }

  @override
  String get newWeapon => 'नया हथियार';

  @override
  String starsKicker(String count) {
    return '${count} सितारे';
  }

  @override
  String get weaponGauntlets => 'लोहे के दस्ताने';

  @override
  String get weaponKnuckles => 'कांस्य मुक्के';

  @override
  String get weaponFang => 'चाँदी का दाँत';

  @override
  String get weaponHammer => 'स्वर्ण हथौड़ा';

  @override
  String get weaponAxe => 'प्लैटिनम कुल्हाड़ी';

  @override
  String get weaponSpear => 'हीरे का भाला';

  @override
  String get weaponSword => 'मास्टर तलवार';

  @override
  String get weaponCrownbreaker => 'ताजभंजक';

  @override
  String clearFirst(String level) {
    return 'पहले लेवल ${level} जीतें';
  }

  @override
  String needsWeapon(String weapon) {
    return '${weapon} चाहिए';
  }

  @override
  String hurtOnlyBy(String weapon) {
    return 'इसे सिर्फ़ ${weapon} या उससे बेहतर हथियार ही चोट पहुँचा सकता है';
  }

  @override
  String worldNeedsWeapon(String world, String weapon, String count) {
    return '${world} के लिए ${weapon} चाहिए · ${count} और सितारे';
  }

  @override
  String rematchOpponentLeft(String name) {
    return '${name} चले गए · इस बार रीमैच नहीं';
  }

  @override
  String get obNext => 'अगला';

  @override
  String get obRaceTitle => 'असली इंसान से मुकाबला करें।';

  @override
  String get obRaceBody => '60 सेकंड में ज़्यादा रेप्स करने वाला जीतता है। लाइव, सामने वाले के अपने फ़ोन पर — या कोई ऑनलाइन न हो तो उसका रिकॉर्ड किया हुआ सेट।';

  @override
  String get obRepsTitle => 'सिर्फ़ पूरे रेप्स गिने जाते हैं।';

  @override
  String get obRepsBody => 'कैमरा देखता है कि आप कितना नीचे जाते हैं और कितना ऊपर वापस आते हैं।';

  @override
  String get obRepsDown => 'सुनहरी लाइन से नीचे जाएँ';

  @override
  String get obRepsUp => 'ऊपर वाली लाइन से ऊपर वापस आएँ';

  @override
  String get obRepsBoth => 'दोनों, हाथ ज़मीन पर रखकर। आधा रेप, रेप नहीं है — न आपके फ़ोन पर, न उनके।';

  @override
  String get obClimbTitle => 'Master तक पहुँचें।';

  @override
  String get obClimbBody => 'सात टियर, हर एक में पाँच स्टेप। जीतकर ऊपर चढ़ें; हार पर एक टियर नीचे जा सकते हैं, पर 1,000 से नीचे नहीं।';

  @override
  String get obGoldLine => 'सुनहरी लाइन';

  @override
  String obCalibrationRule(String gold) {
    return '${gold} से नीचे जाएँ, फिर ऊपर वाली से ऊपर आएँ';
  }

  @override
  String get proThanks => 'विज्ञापन बंद। Pro लेने के लिए धन्यवाद।';

  @override
  String get adAskTitle => 'विज्ञापन outrepd को मुफ़्त रखते हैं';

  @override
  String get adAskBody => 'अब आपका iPhone पूछेगा कि क्या ऐप्स विज्ञापन चुनने के लिए आपकी गतिविधि इस्तेमाल कर सकते हैं। हाँ कहें तो विज्ञापन आपके हिसाब के होंगे; ना कहें तो भी विज्ञापन दिखेंगे, बस कम काम के।';

  @override
  String get adAskCamera => 'आपका कैमरा इसका हिस्सा कभी नहीं होता: आप जो भी चुनें, बॉडी ट्रैकिंग इसी फ़ोन पर रहती है।';

  @override
  String get monsterIronColossus => 'लौह महाकाय';

  @override
  String get monsterScarab => 'स्कारब';

  @override
  String get monsterScarabPharaoh => 'स्कारब फ़राओ';

  @override
  String get monsterYeti => 'येती';

  @override
  String get monsterFrostYeti => 'पाला येती';

  @override
  String get monsterYetiChieftain => 'येती सरदार';

  @override
  String get monsterGoldSoldier => 'स्वर्ण सैनिक';

  @override
  String get monsterGoldKnight => 'स्वर्ण शूरवीर';

  @override
  String get monsterGoldKing => 'स्वर्ण राजा';

  @override
  String get monsterWisp => 'छलावा';

  @override
  String get monsterWraith => 'प्रेत';

  @override
  String get monsterFrostLich => 'हिम लिच';

  @override
  String get monsterCrystalDrake => 'क्रिस्टल ड्रेक';

  @override
  String get monsterCrystalDragon => 'क्रिस्टल ड्रैगन';

  @override
  String get monsterDiamondWyrm => 'हीरक नाग';

  @override
  String get monsterShadowGuard => 'छाया रक्षक';

  @override
  String get monsterShadowKnight => 'छाया शूरवीर';

  @override
  String get monsterTheMaster => 'द मास्टर';

  @override
  String get monsterPebbleGolem => 'कंकड़ गोलेम';

  @override
  String get monsterStoneGolem => 'पत्थर गोलेम';

  @override
  String get monsterOreGolem => 'अयस्क गोलेम';

  @override
  String get monsterMinerGolem => 'खनिक गोलेम';

  @override
  String get monsterScarabGrub => 'स्कारब लार्वा';

  @override
  String get monsterHornedScarab => 'सींग वाला स्कारब';

  @override
  String get monsterScarabWarrior => 'स्कारब योद्धा';

  @override
  String get monsterYetiCub => 'नन्हा येती';

  @override
  String get monsterHornedYeti => 'सींग वाला येती';

  @override
  String get monsterGoldRecruit => 'स्वर्ण रंगरूट';

  @override
  String get monsterGoldGuard => 'स्वर्ण रक्षक';

  @override
  String get monsterShade => 'छाया';

  @override
  String get monsterIceSpecter => 'हिम प्रेत';

  @override
  String get monsterCrystalHatchling => 'नन्हा क्रिस्टल ड्रैगन';

  @override
  String get monsterCrystalWhelp => 'युवा क्रिस्टल ड्रैगन';

  @override
  String get monsterShadowSquire => 'छाया अनुचर';

  @override
  String get monsterShadowLord => 'छाया स्वामी';

  @override
  String monsterWarden(String name) {
    return '${name} रक्षक';
  }

  @override
  String get obPhoneSees => 'आपके फ़ोन को यह दिखना चाहिए';

  @override
  String get obPhoneSeesBody => 'सिर के ऊपर से हाथों तक, लगभग एक मीटर दूर, पुश-अप की पोज़िशन में।';

  @override
  String get obUnder13 => '13 से कम';

  @override
  String get obOver13 => '13 या उससे ज़्यादा';

  @override
  String get obFor13 => 'outrepd 13 साल और उससे ऊपर के लिए है।';

  @override
  String get obUnder13Blocked => 'outrepd 13 साल और उससे ऊपर के लिए है। जब आप 13 के हो जाएँ तब आइए — पुश-अप्स यहीं मिलेंगे।';

  @override
  String get obBeforeYouLift => 'शुरू करने से पहले';

  @override
  String get obFightTitle => 'मॉन्स्टर से लड़िए।';

  @override
  String get obFightBody => 'सात दुनियाओं में 140 पुश-अप लड़ाइयाँ। हर रेप मॉन्स्टर पर वार करता है।';

  @override
  String obSevenWorlds(String from, String to) {
    return 'सात दुनियाएँ, ${from} से ${to} तक';
  }

  @override
  String get obWeaponsTitle => 'स्टार से हथियार अनलॉक होते हैं';

  @override
  String get obWeaponsBody => 'हर दुनिया को अपना हथियार चाहिए। रैंक दाँव पर नहीं।';

  @override
  String get fightDefeated => 'हरा दिया!';

  @override
  String get nextWeapon => 'अगला हथियार';

  @override
  String opensWorld(String world) {
    return '${world} खोलता है';
  }

  @override
  String weaponAtStars(String count) {
    return '${count} स्टार पर';
  }

  @override
  String topTenIn(String country) {
    return '${country} में टॉप 10';
  }
}
