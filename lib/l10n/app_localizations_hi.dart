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
  String get incDuels => 'मुक़ाबलों का इतिहास और LP बदलाव';

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
  String get createAccountBody =>
      'एक ईमेल और पासवर्ड जोड़ें ताकि यह खाता सिर्फ़ एक फ़ोन की दूरी पर न रहे।';

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
  String get usernameAlreadyChangedBody =>
      'आप अपना एकमात्र यूज़रनेम बदलाव पहले ही इस्तेमाल कर चुके हैं — हर खाते को बिल्कुल एक बार मिलता है।';

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
  String get stay => 'रुकें';

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
    return '$n हफ़्ते पहले';
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
  String placementsForFirstTier(String count) {
    return 'पहला रैंक पाने के लिए $count प्लेसमेंट मुक़ाबले पूरे करें।';
  }

  @override
  String get startPlacements => 'प्लेसमेंट शुरू करें';

  @override
  String get unranked => 'अनरैंक्ड';

  @override
  String placementsTerms(String done, String total, String seconds) {
    return '$total में से $done · हर एक $seconds सेकंड';
  }

  @override
  String placementsLeft(String done, String total, String left) {
    return '$total में से $done · रैंक के लिए $left और';
  }

  @override
  String placementsForTier(String count) {
    return 'अपनी रैंक जानने के लिए $count प्लेसमेंट मुक़ाबले पूरे करें।';
  }

  @override
  String placementsDoneCount(String done, String total) {
    return '$total में से $done प्लेसमेंट पूरे';
  }

  @override
  String get practiceFirst => 'पहले अभ्यास';

  @override
  String get nextPlacement => 'अगला प्लेसमेंट';

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
  String get noConnectionBody =>
      'मुक़ाबले के लिए कनेक्शन चाहिए। अभ्यास ऑफ़लाइन चलता है और रेप्स बाद में सिंक हो जाएंगे।';

  @override
  String get getBackInFrame => 'फ़्रेम में वापस आएँ';

  @override
  String get clockStillRunning => 'घड़ी चल रही है। रेप्स नहीं गिने जा रहे।';

  @override
  String get giveUp => 'हार मानें';

  @override
  String get lpMovesWithGap =>
      'LP रेप्स के अंतर के साथ बदलते हैं — जितने ज़्यादा अंतर से जीतें, उतना ज़्यादा मिलता है';

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
  String get obUnder16 => '16 से कम';

  @override
  String get obOver16 => '16 या उससे ज़्यादा';

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
  String get obUnder16Blocked =>
      'outrepd 16 साल और उससे ऊपर के लिए है। जब पहुँच जाओ तब आना — पुश-अप्स यहीं रहेंगे।';

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
  String get obOneMetre => '~1 मी';

  @override
  String get obFullBody => 'पूरा शरीर फ़्रेम में';

  @override
  String get obCheckHandsFeet => 'हाथ और पैर दोनों दिखें';

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
  String get paywallStart => 'चढ़ाई शुरू करें';

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
  String get signOutBody => 'आपका खाता अपनी रैंक, इतिहास और सदस्यता के साथ वैसा ही रहेगा। अपने ईमेल से कभी भी फिर से साइन इन करें।';

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
    return '${name} समय पर पोज़िशन में नहीं आए। कुछ भी दर्ज नहीं हुआ।';
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
  String trialHeadline(String days) {
    return 'आपके पहले ${days} दिन *मुफ़्त* हैं';
  }

  @override
  String get trialToday => 'आज';

  @override
  String get trialTodayBody => 'हर मुकाबला, लाइव और रैंक्ड, अनलॉक।';

  @override
  String trialDay(String day) {
    return 'दिन ${day}';
  }

  @override
  String get trialReminderBody => 'ट्रायल खत्म होने से एक दिन पहले हम याद दिलाएँगे।';

  @override
  String get trialEndBody => 'आपका प्लान शुरू होता है। पहले रद्द करें और कुछ नहीं देना।';

  @override
  String trialTag(String days) {
    return '${days} दिन मुफ़्त';
  }

  @override
  String trialCta(String days) {
    return 'मेरा ${days} दिन का फ़्री ट्रायल शुरू करें';
  }

  @override
  String trialThenYearly(String price) {
    return 'अभी कोई भुगतान नहीं · फिर ${price}/साल';
  }

  @override
  String trialThenWeekly(String price) {
    return 'अभी कोई भुगतान नहीं · फिर ${price}/हफ़्ता';
  }

  @override
  String get trialEndsTitle => 'आपका फ़्री ट्रायल कल खत्म हो रहा है';

  @override
  String get trialEndsBody => 'चढ़ते रहें, या उससे पहले सब्सक्रिप्शन सेटिंग्स में रद्द करें।';

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
    return 'टॉप 10 से ${lp} LP दूर';
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
  String get monthEmptyBody => 'इस महीने अभी तक किसी ने LP नहीं जीते। पहला रैंक्ड ड्यूल जीतें और आप सबसे आगे।';

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
  String get inviteCodeLabel => 'दोस्त का कोड (वैकल्पिक)';

  @override
  String get inviteClaimed => 'कोड जुड़ गया · 7 दिन मुफ़्त आपके';

  @override
  String get inviteUnknownCode => 'यह कोड किसी का नहीं है';

  @override
  String get inviteNotYearly => 'यह कोड अभी मुफ़्त दिन नहीं दे सकता';

  @override
  String get inviteOwnCode => 'यह आपका अपना कोड है';

  @override
  String get inviteTooLate => 'कोड खाते के पहले हफ़्ते में ही चलते हैं';

  @override
  String get inviteFull => 'इस महीने यह कोड बहुत इस्तेमाल हुआ। दूसरा आज़माएँ';

  @override
  String get inviteTitle => 'किसी दोस्त को 7 दिन मुफ़्त दें';

  @override
  String get inviteBody => 'आपका कोड सालाना प्लान के साथ आता है। आपका दोस्त साइन अप करते समय इसे डालता है।';

  @override
  String get inviteYourCode => 'आपका कोड';

  @override
  String inviteJoined(String n) {
    return '${n} जुड़े';
  }

  @override
  String get inviteSend => 'न्योता भेजें';

  @override
  String inviteShareText(String code) {
    return 'OUTREPD पर मुझसे मुकाबला करो: 60 सेकंड पुश-अप, लाइव। साइन अप करते समय मेरा कोड ${code} डालो और 7 दिन मुफ़्त पाओ।';
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
    return 'हर रेप पर ${rep} XP, हर मुक़ाबले पर ${match}';
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
  String lpBreakdown(String reps, String adjust, String rank) {
    return 'रेप्स के लिए ${reps} · ${rank} विरोधी के लिए ${adjust}';
  }
}
