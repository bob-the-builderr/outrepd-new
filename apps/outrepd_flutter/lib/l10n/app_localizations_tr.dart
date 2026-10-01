// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class LTr extends L {
  LTr([String locale = 'tr']) : super(locale);

  @override
  String get tabFriends => 'Arkadaşlar';

  @override
  String get tabRanks => 'Rütbeler';

  @override
  String get tabMatch => 'Maç';

  @override
  String get tabProfile => 'Profil';

  @override
  String get challengeFriend => 'Bir arkadaşına meydan oku';

  @override
  String get matchHistory => 'Maç geçmişi';

  @override
  String get allMatches => 'Tüm maçlar';

  @override
  String get wins => 'Galibiyet';

  @override
  String get losses => 'Mağlubiyet';

  @override
  String get winRate => 'Kazanma oranı';

  @override
  String get streak => 'Seri';

  @override
  String get settings => 'Ayarlar';

  @override
  String get accountSection => 'Hesap';

  @override
  String get duelSection => 'Düello';

  @override
  String get hapticsEachRep => 'Her tekrarda titreşim';

  @override
  String get showSkeleton => 'İskeleti göster';

  @override
  String get showSkeletonHint => 'Kameranın seni gördüğünü böyle anlarsın';

  @override
  String get manageNotifications => 'Bildirimleri yönet';

  @override
  String switchesOn(String on, String all) {
    return '$all taneden $on tanesi açık';
  }

  @override
  String get whoCanChallenge => 'Bana kim meydan okuyabilir';

  @override
  String get blockedAccounts => 'Engellenen hesaplar';

  @override
  String get reportProblem => 'Sorun bildir';

  @override
  String get onDeviceNote =>
      'Poz algılama bu telefonda çalışır. Hiçbir video veya poz verisi yüklenmez.';

  @override
  String get visibilitySection => 'Görünürlük';

  @override
  String get showMyCountry => 'Ülkemi göster';

  @override
  String get showMyCountryHint => 'Kapalıyken ülke tablosunda yer almazsın';

  @override
  String get safetySection => 'Güvenlik';

  @override
  String get socialSection => 'Sosyal';

  @override
  String get noticeRaced => 'Biri setime meydan okudu';

  @override
  String get noticeRacedHint => 'Bir düello olduğunu öğrenmenin tek yolu';

  @override
  String get noticeFriendOk => 'Gönderdiğim istek kabul edildi';

  @override
  String get noticesStoredNote =>
      'Kapatmak hiç kaydedilmemesi demektir, gizlenmesi değil.';

  @override
  String get notSaved => 'Kaydedilmedi';

  @override
  String get blockedIntro =>
      'Engellenen hesap sana meydan okuyamaz, seni bulamaz, istek gönderemez. Kendisine bildirilmez.';

  @override
  String blockedWhen(String when) {
    return '$when engellendi';
  }

  @override
  String get unblock => 'Engeli kaldır';

  @override
  String get noBlockedTitle => 'Kimse engellenmedi';

  @override
  String get noBlockedBody =>
      'Birini profilinden veya bir bildirimden engelleyebilirsin.';

  @override
  String get whatHappened => 'Ne oldu';

  @override
  String get reasonCheating => 'Hile veya sahte tekrar';

  @override
  String get reasonHarassment => 'Taciz veya kötüye kullanım';

  @override
  String get reasonContent => 'Uygunsuz içerik';

  @override
  String get reasonImpersonation => 'Kimliğe bürünme';

  @override
  String get reasonOther => 'Başka bir şey';

  @override
  String get addDetails => 'Ayrıntı ekle (isteğe bağlı)';

  @override
  String get alsoBlock => 'Bu hesabı da engelle';

  @override
  String get sendReport => 'Bildirimi gönder';

  @override
  String get reportSent => 'Bildirim gönderildi';

  @override
  String get reportingThisAccount => 'Bu hesap bildiriliyor';

  @override
  String get exportIntro =>
      'Sunucunun senin hakkında tuttuğu her şeyi bir dosyada e-postayla gönderiyoruz. Genelde bir dakika sürer.';

  @override
  String get whatsIncluded => 'Neler var';

  @override
  String get incProfile => 'Profilin ve rütben';

  @override
  String get incSets => 'Her set ve tekrar sayısı';

  @override
  String get incDuels => 'Düello geçmişi ve LP değişimleri';

  @override
  String get incFriends => 'Arkadaşlar ve engellenenler';

  @override
  String get incNotices => 'Sana gönderilen bildirimler';

  @override
  String get noLandmarksNote =>
      'Poz noktaları içinde yok, hiç olmadı. Kamera onları telefonunda okur ve hiçbir yere gönderilmez.';

  @override
  String get sendItTo => 'Şuraya gönder';

  @override
  String get emailHint => 'sen@ornek.com';

  @override
  String get passwordHint => 'Şifre';

  @override
  String get codeHint => 'Doğrulama kodu';

  @override
  String get createAccountTitle => 'Hesap oluştur';

  @override
  String get createAccountBody =>
      'Bu hesabın tek bir telefona bağlı kalmaması için bir e-posta ve şifre ekle.';

  @override
  String get createAccountAction => 'Hesap oluştur';

  @override
  String get signInTitle => 'Giriş yap';

  @override
  String get signInBody => 'Hesabının e-postası ve şifresiyle giriş yap.';

  @override
  String get signInAction => 'Giriş yap';

  @override
  String get switchToSignIn => 'Zaten hesabın var mı? Giriş yap';

  @override
  String get switchToSignUp => 'Yeni misin? Hesap oluştur';

  @override
  String get emailTakenSwitchToSignIn =>
      'Bu e-postanın zaten bir hesabı var — bunun yerine giriş yap.';

  @override
  String get emailSignUpInvalid =>
      'E-postayı ve şifreyi kontrol et — en az altı karakter.';

  @override
  String get tooManyCodes =>
      'Çok fazla kod gönderildi — birkaç dakika bekleyip tekrar dene.';

  @override
  String get sendCodeAction => 'Kodu gönder';

  @override
  String get noAccountForEmail => 'Bu e-postaya sahip bir hesap bulamadık.';

  @override
  String get authEntryTagline => 'İt. Yarış. Merdiveni tırman.';

  @override
  String get orDivider => 'veya';

  @override
  String get signUpWithEmail => 'E-posta ile kaydol';

  @override
  String get alreadyHaveAccountQuestion => 'Zaten hesabın var mı?';

  @override
  String get logInAction => 'Giriş yap';

  @override
  String get createYourAccountTitle => 'Hesabını oluştur';

  @override
  String get createAccountSubtitle => 'Bir dakikadan az sürer.';

  @override
  String get usernameHint => 'Kullanıcı adı';

  @override
  String get usernameLabel => 'Kullanıcı adı';

  @override
  String get emailLabel => 'E-posta';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get passwordMinLength => 'En az 8 karakter';

  @override
  String get logInSubtitle => 'Rütbeni korumak için giriş yap.';

  @override
  String get forgotPassword => 'Parolanı mı unuttun?';

  @override
  String resetPasswordSent(String email) {
    return '$email için bir hesap varsa, sıfırlama bağlantısı yolda.';
  }

  @override
  String get checkYourEmailTitle => 'E-postanı kontrol et';

  @override
  String codeSentTo(String email) {
    return '$email adresine 6 haneli bir kod gönderdik.';
  }

  @override
  String get didntGetIt => 'Almadın mı?';

  @override
  String resendInSeconds(String time) {
    return '$time içinde tekrar gönder';
  }

  @override
  String get wrongEmailGoBack => 'Yanlış e-posta mı? Geri dön';

  @override
  String get usernameTaken => 'Bu kullanıcı adı alınmış.';

  @override
  String get socialLinkFailed => 'Giriş tamamlanamadı. Tekrar dene.';

  @override
  String get showLabel => 'Göster';

  @override
  String get hideLabel => 'Gizle';

  @override
  String get resetPasswordTitle => 'Yeni parola belirle';

  @override
  String get resetPasswordBody => 'Hesabın için yeni bir parola seç.';

  @override
  String get setPasswordAction => 'Parolayı belirle';

  @override
  String get wrongEmailOrPassword => 'E-posta veya şifre yanlış.';

  @override
  String get enterCodeTitle => 'Kodu gir';

  @override
  String codeInstructions(String email) {
    return '$email adresine gönderdiğimiz kodu gir.';
  }

  @override
  String get verifyAction => 'Doğrula';

  @override
  String get wrongCode => 'Bu kod yanlış veya süresi doldu.';

  @override
  String get resendCode => 'Kodu tekrar gönder';

  @override
  String get codeResent => 'Yeni kod gönderildi.';

  @override
  String signedInAs(String email) {
    return '$email olarak giriş yapıldı';
  }

  @override
  String get addressNotKept =>
      'Adres bir kez kullanılır ve saklanmaz — bu hesapta e-posta yok.';

  @override
  String get requestMyData => 'Verilerimi e-postala';

  @override
  String exportSent(String address) {
    return '$address adresine gönderildi';
  }

  @override
  String get deleteIntro =>
      'Bu her şeyi kalıcı olarak siler. Geri alınamaz ve kurtarılamaz.';

  @override
  String get rankLabel => 'Rütbe';

  @override
  String get wantCopyFirst => 'Önce bir kopya ister misin?';

  @override
  String get wantCopyBody =>
      'Silmeden önce verilerini indir. Sonrasında yok olurlar.';

  @override
  String typeToConfirm(String word) {
    return 'Onaylamak için $word yaz';
  }

  @override
  String get deleteWord => 'SİL';

  @override
  String get deletePermanently => 'Kalıcı olarak sil';

  @override
  String get keepMyAccount => 'Hesabımı tut';

  @override
  String get save => 'Kaydet';

  @override
  String get cancel => 'Vazgeç';

  @override
  String get skip => 'Atla';

  @override
  String get height => 'Boy';

  @override
  String get yourPicture => 'Fotoğrafın';

  @override
  String get yourPictureHint =>
      'Çerçeve rütbenden gelir ve yükseldikçe değişir.';

  @override
  String get couldNotUsePicture => 'O fotoğraf kullanılamadı';

  @override
  String get couldNotSyncAvatar =>
      'Fotoğrafın kaydedildi ama henüz senkronize olmadı';

  @override
  String get couldNotShareCard => 'Bu kart paylaşılamadı';

  @override
  String get couldNotOpenLink => 'O bağlantı açılamadı';

  @override
  String get couldNotCheckUsername => 'O ad kontrol edilemedi — tekrar deneyin';

  @override
  String get changeUsername => 'Kullanıcı adını değiştir';

  @override
  String get usernameInvalidLength =>
      '4 ile 20 karakter arasında olmalı, yalnızca harf ve rakam';

  @override
  String get usernameChanged => 'Kullanıcı adı değiştirildi';

  @override
  String get usernameAlreadyChangedBody =>
      'Tek kullanıcı adı değişikliğinizi zaten kullandınız — her hesap tam olarak bir hak alır.';

  @override
  String get gallery => 'Galeri';

  @override
  String get camera => 'Kamera';

  @override
  String get orPickOurs => 'Ya da bizimkilerden birini seç';

  @override
  String get awards => 'Ödüller';

  @override
  String get yourTitles => 'Unvanların';

  @override
  String get stillToEarn => 'Henüz kazanılmamış';

  @override
  String get noTitlesYet => 'Henüz yok. İlki için tek bir maç yeter.';

  @override
  String get wearHint =>
      'Takmak için birine dokun. Seni gören her yerde adının yanında görünür.';

  @override
  String get worn => 'takılı';

  @override
  String get titleUnlocked => 'Unvan açıldı';

  @override
  String get wearIt => 'Tak';

  @override
  String get wearItLater => 'Sonra';

  @override
  String get dayStreak => 'gün üst üste';

  @override
  String get bestEver => 'En iyisi';

  @override
  String get restDaysLeft => 'Kalan dinlenme günü';

  @override
  String get restIsTraining =>
      'Dinlenmek antrenmanın parçası. Haftada iki gün ara serini bozmaz.';

  @override
  String get global => 'Küresel';

  @override
  String get topPlayers => 'En İyi Oyuncular';

  @override
  String get yourTier => 'Seviyen';

  @override
  String get challenge => 'Meydan oku';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get start => 'Başla';

  @override
  String get finish => 'Bitir';

  @override
  String get reps => 'tekrar';

  @override
  String get recalibrate => 'Yeniden ayarla';

  @override
  String get resetCount => 'Sayacı sıfırla';

  @override
  String get howManyReally => 'Gerçekte kaç tekrar yaptınız?';

  @override
  String get howManyReallyHint =>
      'Uygulamanın değil, kendi sayınızı girin. Sayaç sonradan buna göre ölçülür.';

  @override
  String get appearance => 'Görünüm';

  @override
  String get theme => 'Tema';

  @override
  String get language => 'Dil';

  @override
  String get units => 'Birimler';

  @override
  String get weight => 'Ağırlık';

  @override
  String get privacy => 'Gizlilik';

  @override
  String get data => 'Veriler';

  @override
  String get about => 'Hakkında';

  @override
  String get themeSystem => 'Cihazla aynı';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get accept => 'Kabul et';

  @override
  String challengeSent(String name) {
    return '$name kişisine meydan okuma gönderildi';
  }

  @override
  String get weightUnitTitle => 'Ağırlık birimi';

  @override
  String get heightUnitTitle => 'Boy birimi';

  @override
  String get unitKg => 'Kilogram (kg)';

  @override
  String get unitLb => 'Pound (lb)';

  @override
  String get unitCm => 'Santimetre (cm)';

  @override
  String get unitFt => 'Fit ve inç';

  @override
  String get visEveryone => 'Herkes';

  @override
  String get visFriends => 'Sadece arkadaşlar';

  @override
  String get visNobody => 'Hiç kimse';

  @override
  String get friendRequestsLabel => 'Arkadaşlık istekleri';

  @override
  String get showOnLeaderboards => 'Sıralamalarda görün';

  @override
  String get exportData => 'Verilerimi dışa aktar';

  @override
  String get version => 'Sürüm';

  @override
  String get rateApp => 'OUTREPD\'yi puanla';

  @override
  String get contactSupport => 'Desteğe yaz';

  @override
  String get termsOfService => 'Kullanım koşulları';

  @override
  String get privacyPolicy => 'Gizlilik politikası';

  @override
  String get openSourceLicences => 'Açık kaynak lisansları';

  @override
  String get deleteAccount => 'Hesabı sil';

  @override
  String get needsServer =>
      'Bağlanılamadı. İnternetini kontrol edip tekrar dene.';

  @override
  String get achievements => 'Başarımlar';

  @override
  String get roadTitle => 'Ustalığa giden yol';

  @override
  String get allTiers => 'Tüm rütbeler';

  @override
  String get topTier => 'En üst rütbe';

  @override
  String lpToGo(String lp) {
    return '$lp LP';
  }

  @override
  String get roomFriendly => 'Oda maçları dostane — rütbeni etkilemiyor.';

  @override
  String get createRoom => 'Oda kur';

  @override
  String get enterCode => 'KODU GİR';

  @override
  String get joinRoom => 'Odaya katıl';

  @override
  String get shareThisCode => 'Bu kodu paylaş';

  @override
  String get codeCopied => 'Kod kopyalandı';

  @override
  String get pickMuscleAndStart => 'Kası seç ve başla';

  @override
  String xOfY(String a, String b) {
    return '$a / $b';
  }

  @override
  String get tierIron => 'Demir';

  @override
  String get tierBronze => 'Bronz';

  @override
  String get tierSilver => 'Gümüş';

  @override
  String get tierGold => 'Altın';

  @override
  String get tierPlatinum => 'Platin';

  @override
  String get tierDiamond => 'Elmas';

  @override
  String get tierMaster => 'Usta';

  @override
  String get shortKg => 'kg';

  @override
  String get shortLb => 'lb';

  @override
  String get shortCm => 'cm';

  @override
  String get shortFt => 'ft';

  @override
  String winLoss(String w, String l) {
    return '${w}G ${l}M';
  }

  @override
  String get continueLabel => 'Devam';

  @override
  String get ttl_first_blood => 'İlk Kan';

  @override
  String get tdesc_first_blood => 'İlk maçını tamamla';

  @override
  String get ttl_found_footing => 'Sağlam Duruş';

  @override
  String get tdesc_found_footing => 'Beş maç tamamla';

  @override
  String get ttl_regular => 'Müdavim';

  @override
  String get tdesc_regular => 'Yirmi maç';

  @override
  String get ttl_fifty => 'Ellilik';

  @override
  String get tdesc_fifty => 'Elli maç';

  @override
  String get ttl_century => 'Yüzlük';

  @override
  String get tdesc_century => 'Yüz maç';

  @override
  String get ttl_veteran => 'Kıdemli';

  @override
  String get tdesc_veteran => 'İki yüz elli maç';

  @override
  String get ttl_thousand_matches => 'Eski Muhafız';

  @override
  String get tdesc_thousand_matches => 'Bin maç';

  @override
  String get ttl_first_win => 'Galip';

  @override
  String get tdesc_first_win => 'Bir maç kazan';

  @override
  String get ttl_on_a_roll => 'Seri Başladı';

  @override
  String get tdesc_on_a_roll => 'Üst üste üç kazan';

  @override
  String get ttl_five_straight => 'Beş Üst Üste';

  @override
  String get tdesc_five_straight => 'Üst üste beş kazan';

  @override
  String get ttl_unstoppable => 'Durdurulamaz';

  @override
  String get tdesc_unstoppable => 'Üst üste on kazan';

  @override
  String get ttl_untouchable => 'Dokunulmaz';

  @override
  String get tdesc_untouchable => 'Üst üste yirmi kazan';

  @override
  String get ttl_giant_slayer => 'Dev Avcısı';

  @override
  String get tdesc_giant_slayer => 'İki rütbe üstündeki birini yen';

  @override
  String get ttl_comeback => 'Geri Dönüş';

  @override
  String get tdesc_comeback => 'Üç yenilgiden hemen sonra kazan';

  @override
  String get ttl_nemesis => 'Ezeli Rakip';

  @override
  String get tdesc_nemesis => 'Aynı sporcuyu beş kez yen';

  @override
  String get ttl_hundred_reps => 'Hareket Başladı';

  @override
  String get tdesc_hundred_reps => 'Yüz sayılan tekrar';

  @override
  String get ttl_five_hundred => 'Isındı';

  @override
  String get tdesc_five_hundred => 'Beş yüz sayılan tekrar';

  @override
  String get ttl_the_machine => 'Makine';

  @override
  String get tdesc_the_machine => 'Bin sayılan tekrar';

  @override
  String get ttl_five_thousand => 'Amansız';

  @override
  String get tdesc_five_thousand => 'Beş bin sayılan tekrar';

  @override
  String get ttl_ten_thousand => 'On Bin';

  @override
  String get tdesc_ten_thousand => 'On bin sayılan tekrar';

  @override
  String get ttl_fifty_thousand => 'Sayının Ötesinde';

  @override
  String get tdesc_fifty_thousand => 'Elli bin sayılan tekrar';

  @override
  String get ttl_first_tonne => 'Bir Ton';

  @override
  String get tdesc_first_tonne => 'Toplamda bin kilo kaldır';

  @override
  String get ttl_ten_tonnes => 'On Ton';

  @override
  String get tdesc_ten_tonnes => 'On bin kilo kaldır';

  @override
  String get ttl_six_figures => 'Altı Hane';

  @override
  String get tdesc_six_figures => 'Yüz bin kilo kaldır';

  @override
  String get ttl_half_million => 'Yarım Milyon';

  @override
  String get tdesc_half_million => 'Beş yüz bin kilo kaldır';

  @override
  String get ttl_million_kg => 'Milyon Kilo Kulübü';

  @override
  String get tdesc_million_kg => 'Bir milyon kilo kaldır';

  @override
  String get ttl_two_days => 'Yine Buradayım';

  @override
  String get tdesc_two_days => 'Üst üste iki gün çalış';

  @override
  String get ttl_no_days_off => 'Tatil Yok';

  @override
  String get tdesc_no_days_off => 'Üst üste yedi gün çalış';

  @override
  String get ttl_fortnight => 'İki Hafta';

  @override
  String get tdesc_fortnight => 'On dört günlük seri';

  @override
  String get ttl_unbroken => 'Kesintisiz';

  @override
  String get tdesc_unbroken => 'Otuz günlük seri';

  @override
  String get ttl_sixty_days => 'Alışkanlık';

  @override
  String get tdesc_sixty_days => 'Altmış günlük seri';

  @override
  String get ttl_hundred_days => 'Yüz Gün';

  @override
  String get tdesc_hundred_days => 'Yüz günlük seri';

  @override
  String get ttl_year_round => 'Yıl Boyu';

  @override
  String get tdesc_year_round => 'Üç yüz altmış beş günlük seri';

  @override
  String get ttl_perfect_week => 'Kusursuz Hafta';

  @override
  String get tdesc_perfect_week => 'Bir haftanın her günü çalış';

  @override
  String get ttl_perfect_month => 'Kusursuz Ay';

  @override
  String get tdesc_perfect_month => 'Dört kusursuz hafta';

  @override
  String get ttl_bronze_tier => 'Demirden Çıkış';

  @override
  String get tdesc_bronze_tier => 'Bronz\'a ulaş';

  @override
  String get ttl_silver_tier => 'Gümüşi';

  @override
  String get tdesc_silver_tier => 'Gümüş\'e ulaş';

  @override
  String get ttl_golden_era => 'Altın Çağ';

  @override
  String get tdesc_golden_era => 'Altın\'a ulaş';

  @override
  String get ttl_platinum_tier => 'Platin';

  @override
  String get tdesc_platinum_tier => 'Platin\'e ulaş';

  @override
  String get ttl_diamond_tier => 'Elmas Eller';

  @override
  String get tdesc_diamond_tier => 'Elmas\'a ulaş';

  @override
  String get ttl_master_tier => 'Usta';

  @override
  String get tdesc_master_tier => 'Usta\'ya ulaş';

  @override
  String get ttl_clean_hands => 'Temiz Eller';

  @override
  String get tdesc_clean_hands => 'Her tekrarı sayılan tam bir set';

  @override
  String get ttl_spotless => 'Kusursuz';

  @override
  String get tdesc_spotless => 'On temiz set';

  @override
  String get ttl_textbook => 'Kitaba Uygun';

  @override
  String get tdesc_textbook => 'Elli temiz set';

  @override
  String get ttl_all_rounder => 'Her İşe Uygun';

  @override
  String get tdesc_all_rounder => 'Beş farklı hareket say';

  @override
  String get ttl_explorer => 'Kâşif';

  @override
  String get tdesc_explorer => 'On beş farklı hareket say';

  @override
  String get ttl_encyclopedia => 'Ansiklopedi';

  @override
  String get tdesc_encyclopedia => 'Kırk farklı hareket say';

  @override
  String get ttl_early_bird => 'Sabah Vardiyası';

  @override
  String get tdesc_early_bird => 'Sabah yediden önce on antrenman';

  @override
  String get ttl_sunrise_club => 'Şafak Kulübü';

  @override
  String get tdesc_sunrise_club => 'Sabah yediden önce elli antrenman';

  @override
  String get ttl_night_owl => 'Gece Vardiyası';

  @override
  String get tdesc_night_owl => 'Gece ondan sonra on antrenman';

  @override
  String get ttl_graveyard => 'Sabaha Karşı';

  @override
  String get tdesc_graveyard => 'Gece ondan sonra elli antrenman';

  @override
  String get ttl_not_alone => 'Yalnız Değilsin';

  @override
  String get tdesc_not_alone => 'İlk arkadaşını ekle';

  @override
  String get ttl_well_connected => 'Çevresi Geniş';

  @override
  String get tdesc_well_connected => 'On arkadaş';

  @override
  String get ttl_the_gym_knows => 'Salon Seni Tanıyor';

  @override
  String get tdesc_the_gym_knows => 'Elli arkadaş';

  @override
  String get forfeitQ => 'Maçtan çekilinsin mi?';

  @override
  String get forfeitBody => 'Şimdi çıkarsanız LP kaybedersiniz.';

  @override
  String get stay => 'Kal';

  @override
  String get forfeit => 'Çekil';

  @override
  String get getReady => 'HAZIR OL';

  @override
  String get you => 'SİZ';

  @override
  String get vs => 'VS';

  @override
  String get backToHome => 'ANA SAYFAYA DÖN';

  @override
  String get mgChest => 'Göğüs';

  @override
  String get mgBack => 'Sırt';

  @override
  String get mgLegs => 'Bacak';

  @override
  String get mgShoulders => 'Omuz';

  @override
  String get mgArms => 'Kol';

  @override
  String get mgCore => 'Karın';

  @override
  String get nWonTitle => 'Kazandınız!';

  @override
  String nWonBody(String name, String muscle) {
    return '$muscle gününde $name kişisini yendiniz';
  }

  @override
  String get nFriendTitle => 'Yeni arkadaşlık isteği';

  @override
  String get nRacedTitle => 'Setine meydan okundu';

  @override
  String nRacedHeld(String name, String yours, String theirs) {
    return '$name setine meydan okudu ve yetişemedi, $yours–$theirs';
  }

  @override
  String nRacedBeaten(String name, String theirs, String yours) {
    return '$name setine meydan okudu ve kazandı, $theirs–$yours';
  }

  @override
  String get nFriendOkTitle => 'Arkadaşlık isteği kabul edildi';

  @override
  String nFriendOkBody(String name) {
    return '$name isteğini kabul etti';
  }

  @override
  String nFriendBody(String name) {
    return '$name sizinle bağlantı kurmak istiyor';
  }

  @override
  String get nChallengedTitle => 'Rövanş';

  @override
  String nChallengedBody(String name) {
    return '$name rövanş istiyor';
  }

  @override
  String get challengeSentTitle => 'Meydan okuma gönderildi';

  @override
  String challengeSentBody(String name) {
    return '$name kişisine haber vereceğiz. O yarıştıktan sonra geri dön.';
  }

  @override
  String get challengeNotSentTitle => 'Gönderilemedi';

  @override
  String get challengeNotSentBody =>
      'Bağlantını kontrol et ve Maç sekmesinden tekrar dene.';

  @override
  String get challengeGoneTitle => 'Meydan okuma artık yok';

  @override
  String get challengeGoneBody => 'Zaten yarışıldı ya da geri çekildi.';

  @override
  String repsRecordedLine(String reps) {
    return '$reps tekrar kaydedildi';
  }

  @override
  String get nAchTitle => 'Başarım açıldı';

  @override
  String nAchBody(String title, String hint) {
    return '$title — $hint';
  }

  @override
  String get nRankTitle => 'Rütbe atladınız!';

  @override
  String nRankBody(String rank) {
    return '$rank rütbesine ulaştınız';
  }

  @override
  String get today => 'Bugün';

  @override
  String get yesterday => 'Dün';

  @override
  String daysAgo(String n) {
    return '$n gün önce';
  }

  @override
  String weeksAgo(String n) {
    return '$n hafta önce';
  }

  @override
  String lpAmount(String n) {
    return '$n LP';
  }

  @override
  String get lpUnit => 'LP';

  @override
  String get trueCountHint => 'örn. 12';

  @override
  String get couldNotSaveSession => 'Oturum kaydedilemedi';

  @override
  String lpOutOf(String total) {
    return '/ $total LP';
  }

  @override
  String get noFriendsTitle => 'Henüz arkadaş yok';

  @override
  String get noFriendsBody => 'Tanıdığın biriyle düello bambaşka bir şey.';

  @override
  String get addFriend => 'Ekle';

  @override
  String get decline => 'Reddet';

  @override
  String requestSent(String name) {
    return '$name kişisine istek gönderildi';
  }

  @override
  String nowFriends(String name) {
    return 'Artık $name ile arkadaşsınız';
  }

  @override
  String get noOneFound => 'Bu adı kullanan kimse yok';

  @override
  String get noMatchesTitle => 'Henüz maç yok';

  @override
  String get noMatchesBody => 'İlki burada görünecek — kazan ya da kaybet.';

  @override
  String get noNotificationsTitle => 'Yeni bir şey yok';

  @override
  String get noNotificationsBody =>
      'Maç davetleri, sonuçlar ve arkadaşlık istekleri buraya gelir.';

  @override
  String get countedThat => 'Bu turda sayılan';

  @override
  String get thatIsRight => 'Doğru';

  @override
  String get useMyCount => 'Benim sayımı kullan';

  @override
  String get confirmHint => 'Kamera yanıldıysa değiştirin.';

  @override
  String get unsureMovement =>
      'Doğru hareket miydi emin değilim — sayıyı kontrol edin.';

  @override
  String get local => 'Local';

  @override
  String get weekly => 'Weekly';

  @override
  String get seasonTab => 'Season';

  @override
  String get allTime => 'All-time';

  @override
  String get daily => 'Daily';

  @override
  String get noRanksYet => 'No ranks yet';

  @override
  String get noRanksYetBody => 'Play a duel and the board fills in.';

  @override
  String get ranksTitle => 'Ranks';

  @override
  String get totalReps => 'Total reps';

  @override
  String get recent => 'Recent';

  @override
  String wonVs(String name) {
    return 'Won vs $name';
  }

  @override
  String lostVs(String name) {
    return 'Lost vs $name';
  }

  @override
  String hoursAgo(String n) {
    return '${n}h ago';
  }

  @override
  String toNextTier(String n, String tier) {
    return '$n to $tier';
  }

  @override
  String get noMatchesYet => 'No duels yet';

  @override
  String get noMatchesYetBody => 'Your first one shows up here, win or lose.';

  @override
  String get searchByUsername => 'Kullanıcı adıyla ara';

  @override
  String get incomingRequests => 'Gelen istekler';

  @override
  String get noRequestsWaiting => 'Şu anda bekleyen istek yok';

  @override
  String get addFriendAction => 'Arkadaş ekle';

  @override
  String get addFriendHint =>
      'Kullanıcı adlarını veya profillerindeki #kodu girin.';

  @override
  String get usernameOrCode => 'Kullanıcı adı veya #kod';

  @override
  String get sendRequest => 'İstek gönder';

  @override
  String onlineNowCount(String count) {
    return 'Şu an çevrimiçi · $count';
  }

  @override
  String offlineCount(String count) {
    return 'Çevrimdışı · $count';
  }

  @override
  String get invite => 'Davet et';

  @override
  String get headToHeadTitle => 'Karşılıklı skor';

  @override
  String get vsYouCaption => 'sana karşı';

  @override
  String get h2hYou => 'sen';

  @override
  String get h2hThem => 'o';

  @override
  String headToHead(String wins, String losses) {
    return 'Sana karşı ${wins}G ${losses}M';
  }

  @override
  String get neverPlayedYou => 'Seninle hiç oynamadı';

  @override
  String noHistoryWithThem(String username) {
    return '$username ile henüz yarışmadın.';
  }

  @override
  String lastDuelScore(String yourReps, String theirReps, String when) {
    return 'Son sefer: $yourReps–$theirReps, $when.';
  }

  @override
  String yourBestVsThemLine(String reps) {
    return 'Ona karşı en iyi skorun $reps.';
  }

  @override
  String get viewFullProfile => 'Tüm profili gör';

  @override
  String get moreOptions => 'Diğer seçenekler';

  @override
  String get block => 'Engelle';

  @override
  String get blockRowBody => 'Sana meydan okuyamaz veya profilini göremez';

  @override
  String get report => 'Bildir';

  @override
  String get reportRowBody => '24 saat içinde incelenir';

  @override
  String muteChallenges(String username) {
    return '$username kişisinden gelen meydan okumaları sessize al';
  }

  @override
  String blockedLifter(String username) {
    return '$username engellendi';
  }

  @override
  String mutedLifter(String username) {
    return '$username sessize alındı';
  }

  @override
  String get addFriendButton => 'Arkadaş ekle';

  @override
  String get alreadyFriends => 'Arkadaşlar';

  @override
  String get couldNotLoadProfile => 'Bu profil yüklenemedi';

  @override
  String get noFriendsMatch => 'Bu isimde kimse yok';

  @override
  String get yourClimb => 'Tırmanışın';

  @override
  String floorKept(String tier, String rank) {
    return '$tier artık senin. $rank altına düşmezsin.';
  }

  @override
  String dayStreakCount(String count) {
    return '$count gün üst üste';
  }

  @override
  String get findMatch => 'Maç bul';

  @override
  String rankedTerms(String seconds) {
    return '$seconds saniye · dereceli';
  }

  @override
  String get practiceTerms => 'Alıştırma — derece yok, rakip yok';

  @override
  String get practiceComplete => 'ALIŞTIRMA BİTTİ';

  @override
  String get findPeople => 'Kişi bul';

  @override
  String get noRankYet => 'Henüz derece yok';

  @override
  String placementsForFirstTier(String count) {
    return 'İlk dereceni kazanmak için $count yerleştirme düellosu bitir.';
  }

  @override
  String get startPlacements => 'Yerleştirmeye başla';

  @override
  String get unranked => 'Derecesiz';

  @override
  String placementsTerms(String done, String total, String seconds) {
    return '$total maçtan $done · her biri $seconds saniye';
  }

  @override
  String placementsLeft(String done, String total, String left) {
    return '$total maçtan $done · derece için $left tane daha';
  }

  @override
  String placementsForTier(String count) {
    return 'Derecenizi görmek için $count yerleştirme düellosu bitirin.';
  }

  @override
  String placementsDoneCount(String done, String total) {
    return '$total yerleştirmeden $done tanesi tamamlandı';
  }

  @override
  String get practiceFirst => 'Önce alıştırma';

  @override
  String get nextPlacement => 'Sonraki yerleştirme';

  @override
  String get noConnection => 'Bağlantı yok';

  @override
  String get practiceOffline => 'Çevrimdışı alıştırma';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get youWonPlain => 'Kazandın';

  @override
  String opponentDisconnected(String name) {
    return '$name bağlantıyı kaybetti';
  }

  @override
  String get forfeitNoMargin => 'Çekilme · fark sayılmaz';

  @override
  String get findAnotherMatch => 'Başka maç bul';

  @override
  String get cameraNeededTitle => 'Kamera izni gerekiyor';

  @override
  String get cameraNeededBody =>
      'outrepd tekrarlarını vücudunun hareketini izleyerek sayar. İşlem cihazında yapılır ve hiçbir şey yüklenmez.';

  @override
  String get openSettings => 'Ayarları aç';

  @override
  String get allowCamera => 'Kameraya izin ver';

  @override
  String get notNow => 'Şimdi değil';

  @override
  String get noCameraTitle => 'Kamera bulunamadı';

  @override
  String get noCameraBody =>
      'Tekrarlar kameradan sayılır, bu yüzden bu cihaz düello puanlayamaz. Geri kalan her şey çalışır.';

  @override
  String get noConnectionBody =>
      'Düello için bağlantı gerekir. Alıştırma çevrimdışı çalışır, tekrarların sonra eşitlenir.';

  @override
  String get getBackInFrame => 'Kareye geri gir';

  @override
  String get clockStillRunning => 'Süre işliyor. Tekrarlar sayılmıyor.';

  @override
  String get giveUp => 'Pes et';

  @override
  String lpSwing(String gain, String loss) {
    return '+$gain / −$loss LP';
  }

  @override
  String get lpMovesWithGap =>
      'LP, tekrar farkına göre değişir — ne kadar farklı kazanırsan o kadar çok kazanırsın';

  @override
  String get searchingForOpponent => 'Rakip aranıyor';

  @override
  String get getIntoPosition => 'Pozisyon al';

  @override
  String get framingHint => 'Bilekler ve ayak bilekleri karede olmalı';

  @override
  String get goUp => 'Yukarı';

  @override
  String get goDown => 'Aşağı';

  @override
  String get bestSet => 'En iyi set';

  @override
  String get record => 'Karşilaşmalar';

  @override
  String get last7Days => 'Son 7 gün';

  @override
  String repsCount(String count) {
    return '$count tekrar';
  }

  @override
  String get viewAll => 'Tümünü gör';

  @override
  String get shareProfile => 'Profili paylaş';

  @override
  String get share => 'Paylaş';

  @override
  String get duelMeOnOutrepd => 'outrepd\'de bana meydan oku';

  @override
  String get yourRankCard => 'Derece kartın';

  @override
  String get shareStory => 'Hikaye';

  @override
  String get sharePost => 'Gönderi';

  @override
  String get copyLink => 'Kopyala';

  @override
  String get linkCopied => 'Bağlantı kopyalandı';

  @override
  String get currentRankLabel => 'Güncel derece';

  @override
  String get winInitial => 'G';

  @override
  String get lossInitial => 'M';

  @override
  String get dayInitial => 'g';

  @override
  String rankPosition(String n) {
    return '#$n';
  }

  @override
  String get obTagline =>
      'Şınav düelloları. Telefonun sayıyor. Karşıda biri de sayıyor.';

  @override
  String get obGetStarted => 'Başla';

  @override
  String get obHaveAccount => 'Zaten hesabım var';

  @override
  String get obHowTitle => 'Üç şey, sonra içeridesin.';

  @override
  String get obHow1 => 'Telefonu yere yasla';

  @override
  String get obHow1Body => 'Bir metre önünde, duvara dayat.';

  @override
  String get obHow2 => 'Kamera tekrarlarını sayar';

  @override
  String get obHow2Body =>
      'Her tekrarın derinliği kontrol edilir. Yarım tekrar sayılmaz.';

  @override
  String get obHow3 => 'Birine karşı altmış saniye';

  @override
  String get obHow3Body =>
      'Kazanırsan çıkarsın, kaybedersen düşersin. Kurallar herkes için aynı.';

  @override
  String get obTwoThings => 'İki kısa şey.';

  @override
  String get obAgeQuestion => 'Kaç yaşındasın?';

  @override
  String get obUnder16 => '16’dan küçük';

  @override
  String get obOver16 => '16 ya da üstü';

  @override
  String get obHealthConsent =>
      'outrepd’in tekrar saydığını, tıbbi ya da antrenman tavsiyesi vermediğini anlıyorum. Bir yerim ağrırsa dururum.';

  @override
  String get obTermsIntro => 'Devam edersen şunları kabul etmiş olursun:';

  @override
  String get obTerms => 'Koşullar';

  @override
  String get obAnd => 've';

  @override
  String get obPrivacy => 'Gizlilik Politikası';

  @override
  String get obUnder16Blocked =>
      'outrepd 16 yaş ve üstü için. Oraya gelince uğra — şınavlar burada duruyor.';

  @override
  String get obCameraTitle => 'outrepd’in kameran gerekiyor';

  @override
  String get obCameraBody =>
      'Saymak için vücudunun hareketini izler. Başka yolu yok.';

  @override
  String get obCameraPrivateTitle => 'Hiçbir şey telefonundan çıkmıyor';

  @override
  String get obCameraPrivateBody =>
      'Vücut takibi bu cihazda çalışır. Hiçbir video kaydedilmez veya yüklenmez.';

  @override
  String get obWhyNeeded => 'Bu neden gerekli?';

  @override
  String get obPlacementTitle => 'Telefonu yere koy';

  @override
  String get obPlacementBody => 'Yaklaşık bir metre önünde duvara dayat.';

  @override
  String get obOneMetre => '~1 m';

  @override
  String get obFullBody => 'tüm vücut karede';

  @override
  String get obCheckHandsFeet => 'Eller ve ayaklar görünsün';

  @override
  String get obCheckFacing => 'Yandan değil, telefona dönük';

  @override
  String get obCheckLight => 'Oda ışığı açık';

  @override
  String get obImSetUp => 'Hazırım';

  @override
  String get obFramingTitle => 'Şınav pozisyonuna geç';

  @override
  String get obFramingShoulders => 'Omuzlar ve kalça';

  @override
  String get obFramingWrists => 'Bilekler';

  @override
  String get obFramingAnkles => 'Ayak bilekleri';

  @override
  String get obLooksGood => 'İyi görünüyor';

  @override
  String get obCalibrating => 'Ayarlanıyor';

  @override
  String get obOneMoreRep => 'Menzilini öğrenmek için bir tane daha';

  @override
  String get obCalibrationHint => 'Normal derinliğinde üç şınav çek';

  @override
  String get obCalibrated => 'Ayarlandı.';

  @override
  String get obCalibratedBody =>
      'outrepd artık menzilini biliyor. Derinlik sabit bir sayıyla değil, seninle ölçülür.';

  @override
  String get obRepsCounted => 'Sayılan tekrar';

  @override
  String get obAverageDepth => 'Ortalama derinlik';

  @override
  String get obForm => 'Form';

  @override
  String get obFormClean => 'Temiz';

  @override
  String get obAvailable => 'Uygun';

  @override
  String get obTaken => 'Alınmış';

  @override
  String get obPlacementsBody =>
      'Beş düello başlangıç seviyeni belirler. Henüz hiçbir şey aleyhine sayılmıyor.';

  @override
  String get obFindFirstOpponent => 'İlk rakibimi bul';

  @override
  String get obGotIt => 'Anladım';

  @override
  String get obFormMixed => 'Değişken';

  @override
  String get justNow => 'Az önce';

  @override
  String get counterAccuracy => 'Sayacın doğruluğu';

  @override
  String get counterAccuracyCaption => 'Kamera ne kadar tutturuyor';

  @override
  String measuredOverSets(String count) {
    return '$count set üzerinden ölçüldü';
  }

  @override
  String get accExact => 'Tam isabet';

  @override
  String get accWithinOne => '±1 tekrar';

  @override
  String get accAverageMiss => 'Ortalama sapma';

  @override
  String get accTendsTo => 'Eğilimi';

  @override
  String get accCountsHigh => 'fazla saymak';

  @override
  String get accCountsLow => 'eksik saymak';

  @override
  String get accCountsEven => 'ne fazla ne eksik';

  @override
  String get accWorstMiss => 'En büyük sapma';

  @override
  String get accNothingYet => 'Henüz ölçülmüş bir şey yok';

  @override
  String get accNothingYetBody =>
      'Düellodan sonra sayıyı her onayladığında, o set senin söylediğinle karşılaştırılır. Sonuç burada görünür.';

  @override
  String accNeedMore(String count) {
    return 'Daha çok erken. Bu sayının bir anlamı olması için yaklaşık $count set daha gerek.';
  }

  @override
  String get accRecentSets => 'Son setler';

  @override
  String get accCameraSaid => 'Kamera';

  @override
  String get accYouSaid => 'Sen';

  @override
  String get accHowItWorks =>
      'Bunlar senden, bu telefonda. Hiçbir yere gönderilmiyor.';

  @override
  String levelNumber(String n) {
    return 'Seviye $n';
  }

  @override
  String get youLostPlain => 'Kaybettin';

  @override
  String get rematch => 'Rövanş';

  @override
  String get shareAction => 'Paylaş';

  @override
  String get doneAction => 'Bitti';

  @override
  String get continueAction => 'Devam';

  @override
  String get lpRowWin => 'Galibiyet';

  @override
  String get lpRowLoss => 'Mağlubiyet';

  @override
  String get lpRowOpponent => 'Rakibin rütbesi';

  @override
  String get lpRowMargin => 'Fark';

  @override
  String get lpRowDepth => 'Derinlik';

  @override
  String get promotedLabel => 'Yükseldin';

  @override
  String get highestReached => 'Şimdiye kadarki en yükseğin';

  @override
  String repsOff(String n) {
    return '$n tekrar geride.';
  }

  @override
  String get closestYet => 'Şimdiye kadarki en yakın düello.';

  @override
  String repsAhead(String n) {
    return '$n tekrar önde.';
  }

  @override
  String get winnerLabel => 'Kazanan';

  @override
  String get newPersonalBest => 'Yeni kişisel rekor';

  @override
  String get cantReachServer =>
      'Sunucuya ulaşılamadı. Bağlantını kontrol edip tekrar dene.';

  @override
  String pushUpsInSeconds(String seconds) {
    return '$seconds saniyede şınav';
  }

  @override
  String beatOpponent(String name, String score) {
    return '$name yenildi $score';
  }

  @override
  String lostToOpponent(String name, String score) {
    return '$name karşısında kaybettim $score';
  }

  @override
  String get thinkYouCanBeatMe => 'Beni yenebileceğini mi sanıyorsun?';

  @override
  String get usernameNotAllowed =>
      'Bu isme izin verilmiyor. Başka bir tane dene.';

  @override
  String get yourBest => 'Rekorun';

  @override
  String get theClock => 'Saat';

  @override
  String get nobodyFreeRaceBest =>
      'Şu an rütbene yakın kimse müsait değil. Kendi rekoruna karşı yarış. Bu tur rütbeni değiştirmez.';

  @override
  String get nobodyFreeFirstScore =>
      'Şu an rütbene yakın kimse müsait değil. İlk skorunu belirle. Bu tur rütbeni değiştirmez.';

  @override
  String bestStillIs(String count) {
    return 'Rekorun hâlâ $count';
  }

  @override
  String get setInPoolTitle => 'Setin havuzda';

  @override
  String get setInPoolBody =>
      'Rütbene yakın bir sonraki sporcu buna karşı yarışacak. Kimin kazandığını Bildirimler’de göreceksin, rütben de o zaman değişecek.';

  @override
  String get obWhyNeededBody =>
      'Her tekrar, omuzlarının ne kadar inip kalktığına göre değerlendirilir ve bunu yalnızca kamera görebilir. Kamera olmadan sayım olmaz, sayım olmadan düello olmaz. Kamera yalnızca set sırasında açıktır.';

  @override
  String get obWelcomeBack => 'Tekrar hoş geldin';

  @override
  String get obDuelTitle => 'Gerçek birinin dakikasıyla yarışırsın';

  @override
  String get obDuelBody =>
      'Onun seti tekrar tekrar kaydedildi. Sen kendi setini yaparken onu canlı görürsün.';

  @override
  String obDuelWinBy(String count) {
    return '$count tekrar farkla kazan';
  }

  @override
  String get obDuelLpRule =>
      'Rütbe puanı tekrar farkı kadardır. Farklı kazan, hızlı yüksel.';

  @override
  String get obLadderTitle => 'Tırmanılacak yedi kademe';

  @override
  String get obLadderBody =>
      'Beş yerleştirme düellosu nereden başlayacağını belirler. Kazanarak yüksel; ulaştığın kademe senin kalır.';

  @override
  String obTitlesHeading(String count) {
    return 'Kazanılacak $count unvan';
  }

  @override
  String get obTitlesBody =>
      'Galibiyetler, seriler, temiz setler, sabah erken antrenmanlar ve daha fazlası için. Birini adının altında taşı.';

  @override
  String get obFriendsHeading => 'Arkadaşlarınla hesaplaş';

  @override
  String get obFriendsBody =>
      'Arkadaşların seni bu kodla ekler. İstediğin zaman meydan oku, aranızdaki skor saklanır.';

  @override
  String get obLetsGo => 'Hadi başlayalım';

  @override
  String get paywallTitle => 'Demir\'den Usta\'ya tırman';

  @override
  String get paywallPerkDuels => 'Kameranın hakemlik ettiği düellolar';

  @override
  String get paywallPerkLadder => 'Canlı sıralama';

  @override
  String get paywallPerkFriends => 'Arkadaşlar ve meydan okumalar';

  @override
  String get paywallPerkHistory => 'Her maçın her tekrarı';

  @override
  String get paywallYearly => 'Yıllık';

  @override
  String get paywallWeekly => 'Haftalık';

  @override
  String paywallPerWeek(String price) {
    return '${price}/hafta';
  }

  @override
  String get paywallEveryWeek => 'haftada';

  @override
  String paywallSave(String percent) {
    return '%${percent} tasarruf';
  }

  @override
  String get paywallStart => 'Tırmanmaya başla';

  @override
  String get paywallRenewsPlay => 'İptal edene kadar otomatik olarak yenilenir. Google Play\'den istediğin zaman iptal et.';

  @override
  String get paywallRenewsApple => 'İptal edene kadar otomatik olarak yenilenir. Apple hesap ayarlarından istediğin zaman iptal et.';

  @override
  String get paywallRestore => 'Geri yükle';

  @override
  String get paywallTerms => 'Şartlar';

  @override
  String get paywallPrivacy => 'Gizlilik';

  @override
  String get paywallLoadFailed => 'Planlar yüklenemedi. Bağlantını kontrol edip tekrar dene.';

  @override
  String get paywallBuyFailed => 'Satın alma tamamlanmadı. Tekrar dene.';

  @override
  String get paywallPending => 'Ödemen beklemede. Mağaza onaylar onaylamaz her şeyin kilidi açılır.';

  @override
  String get paywallNothingToRestore => 'Geri yüklenecek abonelik bulunamadı.';

  @override
  String get paywallRestored => 'Abonelik geri yüklendi';

  @override
  String paywallSignedInAs(String email) {
    return '${email} olarak giriş yapıldı';
  }

  @override
  String get deleteKeepsSubscription => 'Hesabını silmek aboneliğini iptal etmez; ücreti outrepd değil mağaza alır. Önce Google Play\'den veya Apple hesap ayarlarından iptal et.';

  @override
  String get signOut => 'Çıkış yap';

  @override
  String get signOutQuestion => 'Çıkış yapılsın mı?';

  @override
  String get signOutBody => 'Hesabın rütbesi, geçmişi ve aboneliğiyle olduğu gibi kalır. İstediğin zaman e-postanla tekrar giriş yap.';

  @override
  String get shareVictory => 'ZAFER';

  @override
  String get shareRematch => 'RÖVANŞ?';

  @override
  String friendCodeInvite(String code) {
    return 'outrepd\'de benimle düello yap. Arkadaş kodumla beni ekle: ${code}\nhttps://outrepd.com';
  }

  @override
  String get soundsLabel => 'Sesler';

  @override
  String get soundsHint => '3, 2, 1 için bip, her tekrar için tık ve tur sonu. Müziğinin üstünde çalar.';

  @override
  String get phoneSection => 'Bu telefonda';

  @override
  String get allowNotifications => 'Bildirimlere izin ver';

  @override
  String get allowNotificationsHint => 'Telefon ayarlarında OUTREPD için kapalı, bu yüzden aşağıdakilerin hiçbiri sana ulaşamaz.';

  @override
  String get remindersSection => 'Hatırlatıcı';

  @override
  String get dailyReminder => 'Günlük hatırlatıcı';

  @override
  String get dailyReminderHint => 'Sadece henüz antrenman yapmadığın günlerde.';

  @override
  String get reminderTime => 'Saat';

  @override
  String get reminderTitle => 'Bugünün şınavları zamanı';

  @override
  String get reminderBody => 'Kısa bir set serine sayılır.';

  @override
  String reminderStreakBody(String count) {
    return '${count} günlük serini sürdür. Bir set yeter.';
  }

  @override
  String get channelMatches => 'Maçlar ve arkadaşlar';

  @override
  String get channelReminders => 'Günlük hatırlatıcı';

  @override
  String get liveTag => 'Canlı';

  @override
  String get reconnecting => 'Yeniden bağlanıyor';

  @override
  String get rankedLive => 'Dereceli · canlı';

  @override
  String get lookingForLive => 'Canlı bir rakip aranıyor';

  @override
  String ofTime(String time) {
    return '${time} içinde';
  }

  @override
  String liveFallbackAt(String time) {
    return '${time} olunca kayıtlı bir sete karşı yarışacaksın';
  }

  @override
  String liveFoundBody(String name) {
    return '${name} şu an kamerada. Aynı süre, aynı başlangıç.';
  }

  @override
  String get nobodyLiveTitle => 'Şu an kimse canlı değil';

  @override
  String get nobodyLiveBody => 'Bunun yerine kayıtlı bir sete karşı yarışacaksın';

  @override
  String didRepsIn(String reps) {
    return '60 saniyede ${reps} yaptı';
  }

  @override
  String get sameRankPoints => 'Canlı maçla aynı sıralama puanı';

  @override
  String get raceIt => 'Yarış';

  @override
  String get sendASet => 'Set gönder';

  @override
  String get onlineNow => 'Şu an çevrimiçi';

  @override
  String get liveOrSetHint => 'Canlı maç için çevrimiçi olmaları gerekir. Set, yarışana kadar bekler.';

  @override
  String get friendlyNoRank => 'Dostça · sıralamasız';

  @override
  String waitingForName(String name) {
    return '${name} bekleniyor';
  }

  @override
  String get weSentThemANotice => 'Ona bildirim gönderdik';

  @override
  String get untilInviteRunsOut => 'davetin süresi dolana kadar';

  @override
  String get cancelInvite => 'Daveti iptal et';

  @override
  String inviteDeclined(String name) {
    return '${name} şimdi olmaz dedi';
  }

  @override
  String get inviteRanOut => 'Davetin süresi doldu';

  @override
  String get inviteAgain => 'Tekrar davet et';

  @override
  String liveInviteFrom(String name) {
    return '${name} canlı';
  }

  @override
  String timeLeft(String time) {
    return '${time} kaldı';
  }

  @override
  String get joinLive => 'Katıl';

  @override
  String get nLiveTitle => 'Canlı davet';

  @override
  String nLiveBody(String name) {
    return '${name} canlı yarışmak istiyor';
  }

  @override
  String get inviteGone => 'Bu davetin süresi doldu';

  @override
  String waitingForPosition(String name) {
    return '${name} pozisyon alması bekleniyor';
  }

  @override
  String opponentDropped(String name) {
    return '${name} bağlantısını kaybetti. Devam et: tur süre bitince biter.';
  }

  @override
  String opponentGaveUp(String name) {
    return '${name} pes etti. Galibiyeti almak için turu bitir.';
  }

  @override
  String get calledOffTitle => 'Maç iptal edildi';

  @override
  String calledOffBody(String name) {
    return '${name} zamanında pozisyon almadı. Hiçbir şey kaydedilmedi.';
  }

  @override
  String waitingForFinal(String name) {
    return '${name} için son sayı bekleniyor…';
  }

  @override
  String get wantsToBeFriends => 'arkadaş olmak istiyor';

  @override
  String get giveUpQuestion => 'Bu turdan çekilmek mi?';

  @override
  String get giveUpBody => 'Şu anki sayın ne olursa olsun yenilgi sayılır.';

  @override
  String waitingToJoin(String name) {
    return '${name} bekleniyor';
  }
}
