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
  String get incDuels => 'Düello geçmişi ve reyting değişimleri';

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
  String get createAccountTitle => 'Hesap oluştur';

  @override
  String get createAccountBody => 'Bu hesap tek bir telefona bağlı kalmasın diye giriş yap.';

  @override
  String get createAccountAction => 'Hesap oluştur';

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
  String get usernameLabel => 'Kullanıcı adı';

  @override
  String get emailLabel => 'E-posta';

  @override
  String get logInSubtitle => 'Rütbeni korumak için giriş yap.';

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
  String get removePhoto => 'Fotoğrafı kaldır';

  @override
  String get removePhotoTitle => 'Fotoğrafın kaldırılsın mı?';

  @override
  String get removePhotoBody =>
      'Bunun yerine her yerde lifter’ın görünecek. İstediğin zaman yeni bir fotoğraf ekleyebilirsin.';

  @override
  String get removePhotoConfirm => 'Kaldır';

  @override
  String get couldNotRemovePhoto => 'Fotoğrafın kaldırılamadı. Tekrar dene.';

  @override
  String get cropPhoto => 'Kırp';

  @override
  String get proGoTitle => 'Pro\'ya geç.';

  @override
  String get proOnboardTitle => 'Lifter’ın, Pro.';

  @override
  String get proSubtitle => 'Reklamsız ve ücretsiz uygulamada olmayan bir görünüm.';

  @override
  String get proFree => 'ÜCRETSİZ';

  @override
  String get proYoursNow => 'ARTIK SENİN';

  @override
  String get proPerkNoAds => 'Reklam yok. Asla.';

  @override
  String get proPerkNoAdsBody => 'Her maç, her seviye, kesintisiz.';

  @override
  String get proPerkBoard => 'Her sıralamada parla';

  @override
  String get proPerkBoardBody => 'Lifter’ının dışına taştığı bir holo satır.';

  @override
  String get proPerkEntrance => 'Şimşekli giriş';

  @override
  String get proPerkEntranceBody => 'Her canlı maçtan önce VS ekranında.';

  @override
  String get proPerkCovers => '13 hareketli kapak';

  @override
  String get proPerkCoversBody => 'Ya da kendi fotoğrafın, profilinin en üstünde.';

  @override
  String get proPerkItems => 'Yalnızca Pro’ya özel 20 eşya';

  @override
  String get proPerkItemsBody => 'Görünümler, üstler, ekipman ve göz kırpan bir lifter.';

  @override
  String get proGo => 'Pro\'ya geç';

  @override
  String proBuyYearly(String price) {
    return 'Pro\'ya geç · ${price}/yıl';
  }

  @override
  String proBuyWeekly(String price) {
    return 'Pro\'ya geç · ${price}/hafta';
  }

  @override
  String get proSettingsBody => 'Reklamsız, üstelik Pro görünümü.';

  @override
  String get proSettingsActive => 'Pro’sun. Desteğin için teşekkürler.';

  @override
  String get lifterMakerTitle => 'Avatarını özelleştir';

  @override
  String get lifterMakerFirst => 'Avatarını özelleştir';

  @override
  String get lifterMakerFirstBody => 'Her sıralamada ve her maçta bu sensin.';

  @override
  String get lifterTabSkin => 'Ten';

  @override
  String get lifterTabHair => 'Saç';

  @override
  String get lifterTabFace => 'Yüz';

  @override
  String get lifterTabBeard => 'Sakal';

  @override
  String get lifterTabTop => 'Üst';

  @override
  String get lifterTabGear => 'Ekipman';

  @override
  String get lifterTabBackground => 'Arka plan';

  @override
  String get lifterTabCharacters => 'Karakterler';

  @override
  String get lifterEyes => 'Gözler';

  @override
  String get lifterBrows => 'Kaşlar';

  @override
  String get lifterMouth => 'Ağız';

  @override
  String get lifterMarks => 'İzler';

  @override
  String get lifterRandom => 'Rastgele';

  @override
  String get lifterTryingPro => 'Bir Pro görünümü.';

  @override
  String get lifterUnlockPro => 'Pro ile aç';

  @override
  String get editLifter => 'Lifter’ını düzenle';

  @override
  String lifterNeedsWorld(String world) {
    return '${world} bölümünü bitir';
  }

  @override
  String lifterNeedsTier(String tier) {
    return '${tier} seviyesine ulaş';
  }

  @override
  String lifterNeedsLevel(String level) {
    return '${level}. seviyeye ulaş';
  }

  @override
  String lifterNeedsWins(String count) {
    return '${count} maç kazan';
  }

  @override
  String lifterNeedsWinStreak(String count) {
    return 'Üst üste ${count} galibiyet';
  }

  @override
  String lifterNeedsDayStreak(String count) {
    return '${count} gün üst üste antrenman yap';
  }

  @override
  String get lifterNeedsMonthTop10 => 'Bir ayı ilk 10’da bitir';

  @override
  String get lifterNeedsMonthPodium => 'Bir ayı ilk 3’te bitir';

  @override
  String get lifterNeedsMonthChampion => 'Bir ayı birinci bitir';

  @override
  String lifterNeedsStars(String count) {
    return '${count} Macera seviyesinde 3 yıldız';
  }

  @override
  String get lifterNeedsAllStars => 'Maceradaki tüm yıldızlar';

  @override
  String get coverTitle => 'Kapak';

  @override
  String get coverPhoto => 'Fotoğrafın';

  @override
  String get coverNone => 'Kapak yok';

  @override
  String get coverUse => 'Bu kapağı kullan';

  @override
  String get coverProLine => 'Kapaklar Pro’ya özel. Hareket ederler ve profilini açan herkes onları görür.';

  @override
  String get coverCouldNotUpload => 'Fotoğrafın yüklenemedi. Tekrar dene.';

  @override
  String get coverNeonCity => 'Neon şehir';

  @override
  String get coverIronGym => 'Demir salon';

  @override
  String get coverRooftopSunset => 'Çatıda gün batımı';

  @override
  String get coverStadiumLights => 'Stadyum ışıkları';

  @override
  String get coverSilverPeaks => 'Gümüş zirveler';

  @override
  String get coverBronzeDunes => 'Bronz kum tepeleri';

  @override
  String get coverVolcano => 'Yanardağ';

  @override
  String get coverPalmBeach => 'Palmiye plajı';

  @override
  String get coverWinterCity => 'Kış şehri';

  @override
  String get coverFireworks => 'Havai fişek';

  @override
  String get coverFightNight => 'Dövüş gecesi';

  @override
  String get coverOrbit => 'Yörünge';

  @override
  String get coverChampionPodium => 'Şampiyon kürsüsü';

  @override
  String get vsLiveRanked => 'CANLI · DERECELİ';

  @override
  String get vsLiveFriendly => 'CANLI · DOSTLUK';

  @override
  String get vsSavedRanked => 'KAYITLI SET · DERECELİ';

  @override
  String get vsRematchFriendly => 'RÖVANŞ · DOSTLUK';

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
      '4 ile 20 karakter arasında olmalı, yalnızca harf, rakam ve _';

  @override
  String get usernameChanged => 'Kullanıcı adı değiştirildi';

  @override
  String get usernameAlreadyChangedBody => 'Kullanıcı adı 14 günde bir değiştirilebilir.';

  @override
  String get gallery => 'Galeri';

  @override
  String get camera => 'Kamera';

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
  String get roomFriendly => 'Oda maçları dostane — rütbeni etkilemiyor.';

  @override
  String get shareThisCode => 'Bu kodu paylaş';

  @override
  String get codeCopied => 'Kod kopyalandı';

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
  String get forfeitRematchBody => 'Bu bir yenilgi sayılır.';

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
    return '${n} hafta önce';
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
  String get noRanksYet => 'Henüz sıralama yok';

  @override
  String get noRanksYetBody => 'Bir düello oyna, liste dolsun.';

  @override
  String get ranksTitle => 'Rütbeler';

  @override
  String get totalReps => 'Toplam tekrar';

  @override
  String get recent => 'Son maçlar';

  @override
  String wonVs(String name) {
    return '${name} karşısında galibiyet';
  }

  @override
  String lostVs(String name) {
    return '${name} karşısında mağlubiyet';
  }

  @override
  String hoursAgo(String n) {
    return '${n} sa önce';
  }

  @override
  String toNextTier(String n, String tier) {
    return '${tier} için ${n}';
  }

  @override
  String get noMatchesYet => 'Henüz düello yok';

  @override
  String get noMatchesYetBody => 'İlki burada görünecek, kazan ya da kaybet.';

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
  String get yourRank => 'Rütben';

  @override
  String get whoIsNext => 'Sıradaki kim?';

  @override
  String get opponentFound => 'Rakip bulundu';

  @override
  String get obSevenTiers => 'Yedi kademe';

  @override
  String get obRatingPerMatch => 'Maç başına puan';

  @override
  String get obWinLabel => 'Galibiyet';

  @override
  String get obLossLabel => 'Mağlubiyet';

  @override
  String get obFloorLabel => 'Alt sınır';

  @override
  String obWinRating(String n) {
    return '+${n} + tekrar farkı';
  }

  @override
  String obLossRating(String n) {
    return '−${n} − tekrar farkı';
  }

  @override
  String obNeverBelow(String n) {
    return 'asla ${n} altına düşmez';
  }

  @override
  String obDivisionLine(String division, String tier) {
    return 'Her ${division} puan bir basamak, ${tier} bir kademe.';
  }

  @override
  String ratingFloor(String n) {
    return 'Reytingin asla ${n} altına düşmez.';
  }

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
  String get noRankYet => 'Henüz derece yok';

  @override
  String get unranked => 'Derecesiz';

  @override
  String get practiceFirst => 'Önce alıştırma';

  @override
  String get noConnection => 'Bağlantı yok';

  @override
  String get practiceOffline => 'Çevrimdışı alıştırma';

  @override
  String get retry => 'Tekrar dene';

  @override
  String get youWonPlain => 'Kazandın';

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
  String get noConnectionBody => 'Düello için bağlantı gerekir. Macera çevrimdışı da çalışır, tekrarların sonra eşitlenir.';

  @override
  String get getBackInFrame => 'Kareye geri gir';

  @override
  String get clockStillRunning => 'Süre işliyor. Tekrarlar sayılmıyor.';

  @override
  String get giveUp => 'Pes et';

  @override
  String get lpMovesWithGap => 'Galibiyet: +25 ve tekrar farkı. Mağlubiyet: −20 ve tekrar farkı.';

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
  String friendsRankLine(String place, String count) {
    return '$count kişiden #$place. sıradasın';
  }

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
  String get obTwoThings => 'İki kısa şey.';

  @override
  String get obAgeQuestion => 'Kaç yaşındasın?';

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
  String get obCheckHandsFeet => 'Baş, omuzlar ve eller karede';

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
      'Bir antrenman setinden sonra sayıyı her onayladığında, o set senin söylediğinle karşılaştırılır. Sonuç burada görünür.';

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
      'Her tekrar, ne kadar aşağı indiğine ve ne kadar yukarı geri çıktığına göre değerlendirilir; bunu yalnızca kamera görebilir. Kamera olmadan sayım olmaz, sayım olmadan da düello olmaz. Kamera yalnızca set sırasında açıktır.';

  @override
  String get obWelcomeBack => 'Tekrar hoş geldin';

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
  String get signOutBody => 'Hesabın derecesi, geçmişi ve aboneliğiyle olduğu gibi kalır. İstediğin zaman aynı yolla tekrar giriş yap.';

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
  String get dailyReminderHint => 'Yalnızca hedefini henüz tamamlamadığın günlerde.';

  @override
  String get reminderTime => 'Saat';

  @override
  String get reminderTitle => 'Bugünün şınavları zamanı';

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
  String get onlineNow => 'Şu an çevrimiçi';

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
  String get nPassedTitle => 'Geçildin';

  @override
  String nPassedBody(String name) {
    return '${name} bu haftanın sıralamasında seni az önce geçti. Yerini geri al.';
  }

  @override
  String get reminderWeekCloses => 'Bu haftanın sıralaması 6 saat içinde kapanıyor. Bir galibiyet daha seni yukarı taşıyabilir.';

  @override
  String get nLiveTitle => 'Canlı davet';

  @override
  String nLiveBody(String name) {
    return '${name} canlı yarışmak istiyor';
  }

  @override
  String get inviteGone => 'Bu davetin süresi doldu';

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
    return '${name} başlangıca yetişemedi. Hiçbir şey kaydedilmedi.';
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

  @override
  String get removeFriend => 'Arkadaşlıktan çıkar';

  @override
  String get removeFriendBody => 'Ona bildirilmez, birbirinizi yeniden ekleyebilirsiniz';

  @override
  String removeFriendQuestion(String username) {
    return '${username} arkadaşlarından çıkarılsın mı?';
  }

  @override
  String get removeAction => 'Çıkar';

  @override
  String removedFriend(String username) {
    return '${username} arkadaşlarından çıkarıldı';
  }

  @override
  String get noticeChallenged => 'Biri bana rövanş teklif etti';

  @override
  String get noticeLiveInvite => 'Bir arkadaşım beni canlı maça davet etti';

  @override
  String get obIdeaTitle => '60 saniye. Tek rakip.';

  @override
  String get obIdeaRival => 'Gerçek bir kişi; canlı ya da kaydettiği set';

  @override
  String get obIdeaCamera => 'Kameran her tekrarı telefonunda sayar';

  @override
  String get thisMonth => 'Bu Ay';

  @override
  String shortDays(String n) {
    return '${n} g';
  }

  @override
  String shortHours(String n) {
    return '${n} sa';
  }

  @override
  String get awardChampion => 'Şampiyon';

  @override
  String get awardPodium => 'Kürsü';

  @override
  String get awardTop10 => 'İlk 10';

  @override
  String get awardRegular => '20 Kulübü';

  @override
  String monthToTop10(String lp) {
    return 'İlk 10\'a ${lp} puan';
  }

  @override
  String monthIfEndedNow(String award) {
    return 'Ay şimdi bitse: ${award}';
  }

  @override
  String get monthJoinHint => 'Bu ayın listesine girmek için dereceli bir düello oyna';

  @override
  String monthRegularProgress(String progress) {
    return '20 Kulübü rozeti · ${progress} dereceli düello';
  }

  @override
  String get monthRegularEarned => 'Bu ay 20 Kulübü rozetini kazandın';

  @override
  String get monthEmptyTitle => 'Yepyeni bir ay';

  @override
  String get monthEmptyBody => 'Bu ay henüz kimse puan almadı. İlk dereceli düelloyu kazan, zirve senin.';

  @override
  String get weekEmptyTitle => 'Yepyeni bir hafta';

  @override
  String get weekEmptyBody => 'Bu hafta henüz kimse puan almadı. İlk dereceli düelloyu kazan, zirve senin.';

  @override
  String get ratingUnit => 'reyting';

  @override
  String get ptsUnit => 'puan';

  @override
  String ptsAmount(String n) {
    return '${n} puan';
  }

  @override
  String ratingAmount(String n) {
    return '${n} reyting';
  }

  @override
  String ratingForWin(String n) {
    return 'galibiyet için ${n}';
  }

  @override
  String ratingForLoss(String n) {
    return 'mağlubiyet için ${n}';
  }

  @override
  String ratingForReps(String n) {
    return 'tekrar farkı için ${n}';
  }

  @override
  String get boardThisWeek => 'Bu hafta';

  @override
  String get boardOverall => 'Genel';

  @override
  String get howPointsWork => 'Puanlar nasıl işler';

  @override
  String streakNextTen(String n) {
    return 'Üst üste ${n} galibiyet: sonraki galibiyet +10';
  }

  @override
  String get boardRuleWin => 'Galibiyet +5';

  @override
  String get boardRuleLoss => 'Mağlubiyet −2';

  @override
  String get boardRuleStreak => 'Üst üste 3 galibiyet: +10';

  @override
  String rankNext(String rank) {
    return 'Sıradaki: ${rank}';
  }

  @override
  String rankAt(String n) {
    return 'hedef: ${n}';
  }

  @override
  String toGo(String n) {
    return '${n} kaldı';
  }

  @override
  String tierStartsAt(String tier, String n) {
    return '${tier} başlangıcı: ${n}';
  }

  @override
  String rankedDuelsCount(String n) {
    return '${n} dereceli düello';
  }

  @override
  String get monthlyAwards => 'Aylık ödüller';

  @override
  String get seasonOver => 'Sezon bitti';

  @override
  String get seasonOverBody => 'Artık profilinde. Yeni ay sıfırdan başlıyor.';

  @override
  String get seasonPlayCta => 'Yeni ayı oyna';

  @override
  String monthWinners(String month) {
    return '${month} kazananları';
  }

  @override
  String get playShort => 'Oyna';

  @override
  String get rematchLive => 'Canlı rövanş';

  @override
  String rematchWaiting(String name) {
    return '${name} bekleniyor';
  }

  @override
  String rematchAsked(String name) {
    return '${name} rövanş istiyor';
  }

  @override
  String get rematchGone => 'Bu sefer rövanş yok';

  @override
  String get twoRankedADay => 'Dostça · aynı rakiple günde 2 dereceli';

  @override
  String monthMove(String move) {
    return 'Bu ay · ${move}';
  }

  @override
  String promotedFrom(String rank) {
    return '${rank} seviyesinden';
  }

  @override
  String liveOnlineNow(String n) {
    return 'Şu an ${n} çevrimiçi';
  }

  @override
  String liveSearchingNow(String n) {
    return '${n} arıyor';
  }

  @override
  String get dailyGoalTitle => 'Bugünün hedefi';

  @override
  String get dailyGoalDone => 'Bugünlük tamam';

  @override
  String dailyGoalProgress(String progress) {
    return '${progress} şınav';
  }

  @override
  String dailyGoalLeft(String n) {
    return '${n} kaldı';
  }

  @override
  String get dailyGoalChange => 'Değiştir';

  @override
  String get dailyGoalPick => 'Günlük hedefin';

  @override
  String dailyGoalOption(String n) {
    return 'Günde ${n} şınav';
  }

  @override
  String widgetGoalOf(String goal) {
    return 'bugün ${goal} hedefin';
  }

  @override
  String get saveToAppleHealth => 'Antrenmanları Apple Sağlık\'a kaydet';

  @override
  String get saveToHealthConnect => 'Antrenmanları Health Connect\'e kaydet';

  @override
  String get saveToHealthHint => 'Her set kuvvet antrenmanı olarak eklenir. Hiçbir şey okunmaz.';

  @override
  String get healthNotAllowed => 'Henüz izin verilmedi. Telefonunun sağlık ayarlarından izin verebilirsin.';

  @override
  String reminderLeft(String count) {
    return 'Bugünkü hedefine ${count} şınav kaldı.';
  }

  @override
  String get liveInviteHint => 'Çevrimiçi arkadaşlar hemen katılabilir. Diğerleri bir bildirim alır ve katılmak için bir dakikaları olur.';

  @override
  String get requestSentShort => 'İstek gönderildi';

  @override
  String healthWorksWith(String health) {
    return 'OUTREPD, ${health} ile çalışır';
  }

  @override
  String healthCardBody(String health) {
    return 'Bitirdiğin her set ${health} uygulamasına kuvvet antrenmanı olarak kaydedilir. OUTREPD sağlık verilerini asla okumaz.';
  }

  @override
  String savedToHealth(String health) {
    return '${health} uygulamasına kaydedildi';
  }

  @override
  String get usernameTooShort => 'Çok kısa: en az 4 karakter';

  @override
  String get usernameBadCharacters => 'Yalnızca harf, rakam ve _';

  @override
  String get usernameNeedsLetter => 'En az bir harf veya rakam ekle';

  @override
  String usernameChangeAgainOn(String date) {
    return '${date} tarihinde tekrar değiştirebilirsin';
  }

  @override
  String get continueWithApple => 'Apple ile devam et';

  @override
  String get continueWithGoogle => 'Google ile devam et';

  @override
  String get socialSignInFailed => 'Giriş yapılamadı. Tekrar dene.';

  @override
  String get chooseUsernameTitle => 'Kullanıcı adını seç';

  @override
  String get chooseUsernameSubtitle => 'Diğerleri seni bu adla bulur ve sıralamalarda görür.';

  @override
  String get authHeroTitle => 'HERKESİ GEÇ.';

  @override
  String get authHeroSubtitle => 'Canlı şınav düelloları, kameran sayar.';

  @override
  String get createAccountPitch => 'Rütben ve düelloların, her telefonda.';

  @override
  String get usernameSpacesHint => 'Boşluklar _ olur';

  @override
  String get emailCodeNote => 'Sana e-postayla 6 haneli bir kod göndereceğiz. Şifre yok.';

  @override
  String get continueWithEmail => 'E-posta ile devam et';

  @override
  String get thisSeason => 'Bu sezon';

  @override
  String get thisWeek => 'Bu hafta';

  @override
  String get weekStartsAgain => 'Her pazartesi yeniden başlar';

  @override
  String get lengthWeek => 'Hafta';

  @override
  String get lengthMonth => 'Ay';

  @override
  String get weekJoinHint => 'Tabloya girmek için bu hafta bir dereceli düello kazan';

  @override
  String get weekInTop3 => 'Bu hafta ilk 3\'te';

  @override
  String weekToTop3(String n) {
    return 'İlk 3\'e ${n} puan';
  }

  @override
  String get boardActiveNote => 'Son 30 günde aktif oyuncular';

  @override
  String get boardTieNote => 'eşitlikte: daha çok galibiyet önde';

  @override
  String lpBreakdown(String reps, String adjust, String rank) {
    return 'Tekrarlar için ${reps} · ${rank} rakip için ${adjust}';
  }

  @override
  String levelShort(String n) {
    return 'Sv. ${n}';
  }

  @override
  String xpOf(String into, String span) {
    return '${into} / ${span} XP';
  }

  @override
  String xpToLevel(String n, String level) {
    return 'Seviye ${level} için ${n} XP';
  }

  @override
  String xpHow(String rep, String match) {
    return 'Tekrar başına ${rep} XP, galibiyet başına ${match}, yenilgiye hiçbir şey';
  }

  @override
  String xpGained(String n) {
    return '+${n} XP';
  }

  @override
  String xpForReps(String n) {
    return 'Tekrarlar için ${n}';
  }

  @override
  String xpForMatch(String n) {
    return 'Düello için ${n}';
  }

  @override
  String get levelUp => 'Seviye atladın';

  @override
  String get levelUpBody => 'Her tekrar sayılır. Devam et.';

  @override
  String giveUpAhead(String n) {
    return '${n} öndesin';
  }

  @override
  String giveUpBehind(String n) {
    return '${n} geridesin';
  }

  @override
  String get giveUpTied => 'Berabere';

  @override
  String get keepGoing => 'Devam et';

  @override
  String get stay => 'Kal';

  @override
  String lastN(String n) {
    return 'Son ${n}';
  }

  @override
  String get firstMatchForTier => 'Sıralamaya girmek için ilk maçını oyna. Herkes Iron V\'den başlar.';

  @override
  String get firstMatchForBoard => 'Tabloya girmek için ilk maçını oyna. Herkes Iron V\'den başlar.';

  @override
  String get playFirstMatch => 'İlk maçı oyna';

  @override
  String firstMatchTerms(String seconds) {
    return 'Tek maç · ${seconds} saniye';
  }

  @override
  String get placedLabel => 'Sıralamadasın';

  @override
  String get placedBody => 'Herkes buradan başlar. Seni sadece galibiyetler yükseltir.';

  @override
  String get placedHow => 'Galibiyet: +25 ve tekrar farkı. Mağlubiyet: −20 ve tekrar farkı.';

  @override
  String get levelBesideName => 'Adının yanında, her yerde';

  @override
  String get weekRaceTitle => 'Bu haftanın yarışı';

  @override
  String get streakDoneToday => 'bugün tamam';

  @override
  String get streakTrainToday => 'bir gün eklemek için bugün antrenman yap';

  @override
  String get raceChartTitle => 'Dakika nasıl geçti';

  @override
  String raceYouLead(String time) {
    return '${time} · öne geçtin';
  }

  @override
  String raceTheyLead(String time, String name) {
    return '${time} · ${name} öne geçti';
  }

  @override
  String get bringFriendTitle => 'Bir arkadaşını getir';

  @override
  String get bringFriendBody => 'Bağlantını gönder. Profilini açar, oradan seni ekleyebilirler.';

  @override
  String get bringFriendShare => 'Bağlantımı paylaş';

  @override
  String get bringFriendShareText => 'OUTREPD\'de şınavda benimle yarış. 60 saniye, canlı, kamera sayar.';

  @override
  String orFriendCode(String code) {
    return 'veya arkadaş kodu ${code}';
  }

  @override
  String get countryPickerTitle => 'Ülken';

  @override
  String get countrySearch => 'Ara';

  @override
  String get countryFromPhone => 'Telefonundan';

  @override
  String get countryAll => 'Tüm ülkeler';

  @override
  String get countryChoose => 'Ülkeni seç';

  @override
  String get countryChange => 'Değiştir';

  @override
  String get countryForBoard => 'Ülkenin sıralaması için';

  @override
  String get countryLabel => 'Ülke';

  @override
  String get countryChanged => 'Ülke değiştirildi';

  @override
  String get countryEvery14 => 'Adın gibi 14 günde bir';

  @override
  String get countryNotSaved => 'Ülken kaydedilemedi. Tekrar dene.';

  @override
  String get adventure => 'Macera';

  @override
  String stageNumber(String n) {
    return 'Seviye ${n}';
  }

  @override
  String adventureLevelIn(String level, String world) {
    return 'Seviye ${level} · ${world}';
  }

  @override
  String adventureClearedOf(String cleared, String total) {
    return '${total} seviyeden ${cleared} tanesi geçildi · derece yok';
  }

  @override
  String get worldIron => 'Demir Madenleri';

  @override
  String get worldBronze => 'Bronz Kumulları';

  @override
  String get worldSilver => 'Gümüş Zirveler';

  @override
  String get worldGold => 'Altın Kale';

  @override
  String get worldPlatinum => 'Platin Buzul';

  @override
  String get worldDiamond => 'Elmas Mağaralar';

  @override
  String get worldMaster => 'Usta’nın Tahtı';

  @override
  String worldNumber(String n) {
    return 'Dünya ${n}';
  }

  @override
  String fightLevel(String level) {
    return 'Savaş: Seviye ${level}';
  }

  @override
  String levelHpLine(String hp, String reps) {
    return 'HP ${hp} · yaklaşık ${reps} şınav';
  }

  @override
  String get hpShort => 'HP';

  @override
  String comboTag(String n) {
    return 'KOMBO ×${n}';
  }

  @override
  String get levelCleared => 'GEÇİLDİ';

  @override
  String get outOfTime => 'SÜRE BİTTİ';

  @override
  String get statPushUps => 'şınav';

  @override
  String get statTimeLeft => 'kalan';

  @override
  String get statHpLeft => 'kalan HP';

  @override
  String get statXp => 'XP';

  @override
  String secondStarHint(String seconds) {
    return 'İkinci yıldız için ${seconds} saniye kala bitir';
  }

  @override
  String thirdStarHint(String seconds) {
    return 'Üçüncü yıldız için ${seconds} saniye kala bitir';
  }

  @override
  String get fightLostHint => 'Daha fazla yıldız için önceki seviyeleri yeniden kazan: yıldızlar daha güçlü silahlar açar.';

  @override
  String get nextLevel => 'Sonraki seviye';

  @override
  String get tryAgain => 'Tekrar dene';

  @override
  String get adventureMap => 'Harita';

  @override
  String get nextKicker => 'SIRADAKİ';

  @override
  String nextLevelLine(String level, String hp) {
    return 'Seviye ${level} · HP ${hp}';
  }

  @override
  String get armory => 'Cephanelik';

  @override
  String get armoryBody => 'Yıldızlar silah açar. Her dünyanın canavarları yalnızca o dünyanın silahından veya daha iyisinden hasar alır.';

  @override
  String get equipped => 'KUŞANILDI';

  @override
  String perPushUp(String damage) {
    return 'Şınav başına ${damage}';
  }

  @override
  String damagePerPushUp(String damage) {
    return 'Şınav başına ${damage} hasar';
  }

  @override
  String wasWith(String damage, String weapon) {
    return 'önceden ${weapon} ile ${damage}';
  }

  @override
  String moreStars(String count) {
    return '${count} yıldız daha';
  }

  @override
  String get newWeapon => 'Yeni silah';

  @override
  String starsKicker(String count) {
    return '${count} YILDIZ';
  }

  @override
  String get weaponGauntlets => 'Demir Eldivenler';

  @override
  String get weaponKnuckles => 'Bronz Muşta';

  @override
  String get weaponFang => 'Gümüş Diş';

  @override
  String get weaponHammer => 'Altın Çekiç';

  @override
  String get weaponAxe => 'Platin Balta';

  @override
  String get weaponSpear => 'Elmas Mızrak';

  @override
  String get weaponSword => 'Usta Kılıcı';

  @override
  String get weaponCrownbreaker => 'Taç Kıran';

  @override
  String clearFirst(String level) {
    return 'Önce şu seviyeyi kazan: ${level}';
  }

  @override
  String needsWeapon(String weapon) {
    return 'Gerekli: ${weapon}';
  }

  @override
  String hurtOnlyBy(String weapon) {
    return 'Ona sadece ${weapon} veya daha iyisi zarar verebilir';
  }

  @override
  String worldNeedsWeapon(String world, String weapon, String count) {
    return '${world} için ${weapon} gerekli · ${count} yıldız daha';
  }

  @override
  String rematchOpponentLeft(String name) {
    return '${name} ayrıldı · bu sefer rövanş yok';
  }

  @override
  String get obNext => 'İleri';

  @override
  String get obRaceTitle => 'Gerçek biriyle yarış.';

  @override
  String get obRaceBody => '60 saniyede en çok tekrarı yapan kazanır. Canlı, herkes kendi telefonunda — ya da kimse çevrimiçi değilse kayıtlı bir sete karşı.';

  @override
  String get obRepsTitle => 'Yalnızca tam tekrarlar sayılır.';

  @override
  String get obRepsBody => 'Kamera ne kadar aşağı indiğini ve ne kadar geri çıktığını görür.';

  @override
  String get obRepsDown => 'Çubuk boşalana kadar in';

  @override
  String get obRepsUp => 'Dolana kadar çık';

  @override
  String get obBarGoingDown => 'İnerken';

  @override
  String get obBarComingUp => 'Çıkarken';

  @override
  String get obBarHandOff => 'El yerden kalktı';

  @override
  String get obRepsBoth => 'İkisi de, eller yerdeyken. Yarım tekrar sayılmaz — ne senin telefonunda ne de rakibininkinde.';

  @override
  String get obClimbTitle => 'Master’a tırman.';

  @override
  String get obClimbBody => 'Yedi kademe, her birinde beş basamak. Kazanarak yüksel; mağlubiyet bir kademe düşürebilir, ama 1.000 puanın altına inmez.';

  @override
  String get obGoldLine => 'altın çizgi';

  @override
  String obCalibrationRule(String gold) {
    return '${gold}nin altına in, üstteki çizginin üstüne çık';
  }

  @override
  String get proThanks => 'Reklamlar kapandı. Pro’ya geçtiğin için teşekkürler.';

  @override
  String get adAskTitle => 'Reklamlar outrepd’yi ücretsiz tutar';

  @override
  String get adAskBody => 'Şimdi iPhone’un, uygulamaların reklam seçmek için etkinliğini kullanıp kullanamayacağını soracak. Evet dersen reklamlar sana daha uygun olur; hayır dersen yine reklam görürsün, sadece daha az ilgili olanları.';

  @override
  String get adAskCamera => 'Kameranın bununla hiçbir ilgisi yok: ne seçersen seç, vücut takibi bu telefonda kalır.';

  @override
  String get monsterIronColossus => 'Demir Dev';

  @override
  String get monsterScarab => 'Skarabe';

  @override
  String get monsterScarabPharaoh => 'Skarabe Firavun';

  @override
  String get monsterYeti => 'Yeti';

  @override
  String get monsterFrostYeti => 'Ayaz Yetisi';

  @override
  String get monsterYetiChieftain => 'Yeti Reisi';

  @override
  String get monsterGoldSoldier => 'Altın Asker';

  @override
  String get monsterGoldKnight => 'Altın Şövalye';

  @override
  String get monsterGoldKing => 'Altın Kral';

  @override
  String get monsterWisp => 'Hayalet Işık';

  @override
  String get monsterWraith => 'Hortlak';

  @override
  String get monsterFrostLich => 'Ayaz Lich';

  @override
  String get monsterCrystalDrake => 'Genç Kristal Ejder';

  @override
  String get monsterCrystalDragon => 'Kristal Ejderha';

  @override
  String get monsterDiamondWyrm => 'Elmas Ejder';

  @override
  String get monsterShadowGuard => 'Gölge Muhafız';

  @override
  String get monsterShadowKnight => 'Gölge Şövalye';

  @override
  String get monsterTheMaster => 'Efendi';

  @override
  String get monsterPebbleGolem => 'Çakıl Golemi';

  @override
  String get monsterStoneGolem => 'Taş Golem';

  @override
  String get monsterOreGolem => 'Cevher Golemi';

  @override
  String get monsterMinerGolem => 'Madenci Golem';

  @override
  String get monsterScarabGrub => 'Skarabe Larvası';

  @override
  String get monsterHornedScarab => 'Boynuzlu Skarabe';

  @override
  String get monsterScarabWarrior => 'Skarabe Savaşçı';

  @override
  String get monsterYetiCub => 'Yavru Yeti';

  @override
  String get monsterHornedYeti => 'Boynuzlu Yeti';

  @override
  String get monsterGoldRecruit => 'Altın Acemi';

  @override
  String get monsterGoldGuard => 'Altın Muhafız';

  @override
  String get monsterShade => 'Gölge';

  @override
  String get monsterIceSpecter => 'Buz Hortlağı';

  @override
  String get monsterCrystalHatchling => 'Kristal Yavru';

  @override
  String get monsterCrystalWhelp => 'Kristal Ejdercik';

  @override
  String get monsterShadowSquire => 'Gölge Silahtar';

  @override
  String get monsterShadowLord => 'Gölge Lordu';

  @override
  String monsterWarden(String name) {
    return '${name} Muhafızı';
  }

  @override
  String get obPhoneSees => 'Telefonunun görmesi gereken';

  @override
  String get obPhoneSeesBody => 'Başının üstünden ellerine kadar, yaklaşık bir metre uzakta, şınav pozisyonunda.';

  @override
  String get obUnder13 => '13 yaş altı';

  @override
  String get obOver13 => '13 ve üzeri';

  @override
  String get obFor13 => 'outrepd 13 yaş ve üzeri içindir.';

  @override
  String get obUnder13Blocked => 'outrepd 13 yaş ve üzeri içindir. O yaşa gelince tekrar gel — şınavlar burada olacak.';

  @override
  String get obBeforeYouLift => 'Başlamadan önce';

  @override
  String get obFightTitle => 'Canavarlarla savaş.';

  @override
  String get obFightBody => 'Yedi dünyada 140 şınav dövüşü. Her tekrar canavara vurur.';

  @override
  String obSevenWorlds(String from, String to) {
    return 'Yedi dünya: ${from} – ${to}';
  }

  @override
  String get obWeaponsTitle => 'Yıldızlar silah açar';

  @override
  String get obWeaponsBody => 'Her dünya kendi silahını ister. Rütben tehlikede değil.';

  @override
  String get fightDefeated => 'Yenildi!';

  @override
  String get nextWeapon => 'Sonraki silah';

  @override
  String opensWorld(String world) {
    return '${world} açılır';
  }

  @override
  String weaponAtStars(String count) {
    return '${count} yıldızda';
  }

  @override
  String topTenIn(String country) {
    return '${country} içinde ilk 10';
  }

  @override
  String get challengeAction => 'Meydan oku';

  @override
  String get challengeAFriend => 'Bir arkadaşına meydan oku';

  @override
  String challengeYourBest(String reps, String seconds) {
    return 'Rekorun: ${seconds} saniyede ${reps} · gönder';
  }

  @override
  String challengesYou(String name) {
    return '${name} sana meydan okuyor';
  }

  @override
  String get canYouBeatIt => 'Geçebilir misin?';

  @override
  String challengeInvite(String reps, String seconds) {
    return '${seconds} saniyede ${reps} şınav çektim. Beni yenebileceğini mi sanıyorsun?';
  }

  @override
  String get vsChallengeFriendly => 'MEYDAN OKUMA · DOSTLUK';

  @override
  String get challengesYouToBeat => 'seni bunu geçmeye çağırıyor';

  @override
  String get onThisChallenge => 'Bu meydan okumada';

  @override
  String challengeTookIt(String count) {
    return '${count} kişi denedi';
  }

  @override
  String get challengeBeatTag => 'Geçti';

  @override
  String get challengeSetIt => 'kuran';

  @override
  String get challengeFriendlyNote => 'Dostça: puanın değişmez. Şınavların bugünkü hedefe sayılır.';

  @override
  String get takeTheChallenge => 'Meydan okumayı kabul et';

  @override
  String get challengeClosed => 'Bu meydan okuma kapandı.';

  @override
  String challengeYouTookIt(String reps) {
    return 'Denedin: ${reps}.';
  }

  @override
  String challengeOpenUntil(String date) {
    return '${date} tarihine kadar açık';
  }

  @override
  String get youBeatIt => 'Geçtin';

  @override
  String get notThisTime => 'Bu sefer olmadı';

  @override
  String challengeMoreThan(String gap, String name) {
    return '${name} adlı oyuncudan ${gap} fazla.';
  }

  @override
  String challengeShortOf(String gap, String name) {
    return '${name} adlı oyuncudan ${gap} eksik.';
  }

  @override
  String challengeLevelWith(String name) {
    return '${name} ile berabere. Bir tane daha yetecekti.';
  }

  @override
  String challengePlace(String place, String count) {
    return '${count} kişi içinde #${place}';
  }

  @override
  String challengeResultNote(String reps) {
    return 'Dostça · puan değişmedi · bugünkü hedefe +${reps}';
  }

  @override
  String challengeBack(String name) {
    return '${name} adlı oyuncuya meydan oku';
  }

  @override
  String get challengeSentBack => 'Gönderildi';

  @override
  String get yourChallenge => 'Meydan okuman';

  @override
  String challengeBeatYou(String count) {
    return '${count} kişi seni geçti';
  }

  @override
  String get challengeRowBeat => 'seni geçti';

  @override
  String get challengeRowHeld => 'sen önde kaldın';

  @override
  String get takeItBack => 'Geri al';

  @override
  String get takeItBackNote => 'Geri al: setleriyle yarış. Geçersen haberleri olur.';

  @override
  String get sendToMoreFriends => 'Daha fazla arkadaşa gönder';

  @override
  String get challengesTitle => 'Meydan okumalar';

  @override
  String get noChallengesYet => 'Henüz meydan okuma yok. Bir maçtan sonra ya da ana ekrandan gönder.';

  @override
  String get challengeNobodyYet => 'Henüz kimse denemedi.';

  @override
  String get challengeNoSet => 'Önce tam bir dakika yap, sonra gönder.';

  @override
  String get nChallengeTakenTitle => 'Meydan okuman kabul edildi';

  @override
  String nChallengeBeaten(String name, String yours, String theirs) {
    return '${name}, ${theirs} ile senin ${yours} rekorunu geçti. Geri alır mısın?';
  }

  @override
  String nChallengeHeld(String name, String yours, String theirs) {
    return '${name} meydan okumanı kabul etti, ${theirs} tekrarda kaldı. Senin ${yours} rekorun duruyor.';
  }

  @override
  String get nChallengeBackTitle => 'Karşı meydan okuma';

  @override
  String nChallengeBackBody(String name, String theirs) {
    return '${name} ${theirs} tekrar yaptı ve sana karşılık meydan okuyor.';
  }

  @override
  String get xpDoubleIt => 'İkiye katla';

  @override
  String get xpDoubleNote => 'Kısa bir video, ve bu maçtan sonra reklam yok.';

  @override
  String get xpDoubled => '×2 katlandı';

  @override
  String streakEnded(String days) {
    return '${days} günlük serin bitti';
  }

  @override
  String get streakBringBack => 'Kısa bir videoyla geri getir. Haftada bir kez.';

  @override
  String get streakBringBackPro => 'Geri getir. Haftada bir kez.';

  @override
  String streakKeep(String days) {
    return '${days} günümü koru';
  }

  @override
  String get getPro => 'Pro\'ya geç';

  @override
  String get proTrialBody => 'Pro parçalar Pro ile gelir. Bunu bir gün ücretsiz dene: yarına kadar herkes sende görür.';

  @override
  String get proTrialWear => 'Bir gün ücretsiz giy';

  @override
  String get proTrialOn => 'Bir günlüğüne senin. Herkes görür.';

  @override
  String get rewardNotEarned => 'Video bitmedi, bu yüzden hiçbir şey değişmedi.';
}
