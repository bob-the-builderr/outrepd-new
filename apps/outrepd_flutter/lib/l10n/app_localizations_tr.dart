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
  String get tabCrew => 'Ekip';

  @override
  String get tabProfile => 'Profil';

  @override
  String get searchOpponent => 'Rakip ara';

  @override
  String get searchOpponentHint =>
      'Seni kendi rütbendeki biriyle eşleştiriyoruz';

  @override
  String get challengeFriend => 'Bir arkadaşına meydan oku';

  @override
  String get trainWithCamera => 'Kamerayla çalış';

  @override
  String get viewRoadmap => 'Yol haritasını gör';

  @override
  String lpProgress(String lp, String left) {
    return '$lp / 100 LP · yükselmeye $left kaldı';
  }

  @override
  String winStreak(String count) {
    return 'üst üste $count galibiyet';
  }

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
  String get profile => 'Profil';

  @override
  String get settings => 'Ayarlar';

  @override
  String get stats => 'İstatistikler';

  @override
  String get edit => 'Düzenle';

  @override
  String get save => 'Kaydet';

  @override
  String get cancel => 'Vazgeç';

  @override
  String get skip => 'Atla';

  @override
  String get totalMatches => 'Toplam maç';

  @override
  String get bestWinStreak => 'En iyi galibiyet serisi';

  @override
  String get totalVolume => 'Toplam kaldırılan hacim';

  @override
  String get height => 'Boy';

  @override
  String get bodyweight => 'Vücut ağırlığı';

  @override
  String get age => 'Yaş';

  @override
  String get editYourStats => 'Bilgilerini düzenle';

  @override
  String get editStatsHint => 'Galibiyet, hacim ve rütbe kazanılır — yazılmaz.';

  @override
  String get changeName => 'Adını değiştir';

  @override
  String get changeNameLast => 'Bu son değişikliğin. Geri alınamaz.';

  @override
  String changeNameLeft(String total, String left) {
    return 'Toplam $total değişiklik hakkın var. Bundan sonra $left kalıyor.';
  }

  @override
  String get changeNameUsedUp => 'İki isim değiştirme hakkını da kullandın';

  @override
  String get yourPicture => 'Fotoğrafın';

  @override
  String get yourPictureHint =>
      'Çerçeve rütbenden gelir ve yükseldikçe değişir.';

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
  String titlesAndStreak(String owned, String total, String streak) {
    return '$total unvandan $owned tanesi · $streak günlük seri';
  }

  @override
  String get crew => 'Ekip';

  @override
  String get myCrew => 'Ekibim';

  @override
  String get rankings => 'Sıralama';

  @override
  String get trainWithCrew => 'Bir ekiple çalış';

  @override
  String get trainWithCrewHint =>
      'Tek isim altında 20 kişiye kadar: ortak bir haftalık hedef ve ekip tablosunda tırmanacak bir sıra.';

  @override
  String get createCrew => 'Ekip kur';

  @override
  String get createCrewHint => 'Adını koy, armanı seç, kendi insanlarını çağır';

  @override
  String get joinOpenCrew => 'Açık bir ekibe katıl';

  @override
  String get joinOpenCrewHint => 'Herkese açık ekipler';

  @override
  String get yourInvites => 'Davetlerin';

  @override
  String get yourInvitesHint => 'Seni isteyen ekipler';

  @override
  String get joinWithCode => 'Kodla katıl';

  @override
  String get joinWithCodeHint => 'Bir üyeden alacağın altı karakter';

  @override
  String get topCrewsThisWeek => 'Bu haftanın en iyi ekipleri';

  @override
  String get members => 'Üyeler';

  @override
  String get repsEach => 'Kişi başı tekrar';

  @override
  String get rank => 'Sıra';

  @override
  String get weeklyGoal => 'Haftalık hedef';

  @override
  String get weeklyGoalDone => 'Haftalık hedef tamam';

  @override
  String goalRemaining(String reps, String days) {
    return '$reps tekrar kaldı · $days gün var';
  }

  @override
  String get goalDoneHint => 'Hafta kapanınca rozeti herkes alıyor.';

  @override
  String get startCrewWar => 'Ekip savaşı başlat';

  @override
  String get startCrewWarHint =>
      'Yedi gün, iki ekip de sayıyor. Kişi başı en çok tekrarı yapan kazanır.';

  @override
  String get whoIsPulling => 'Ekibi kim taşıyor';

  @override
  String get thisWeek => 'bu hafta';

  @override
  String get inviteLifters => 'Sporcu davet et';

  @override
  String get referralCode => 'Davet kodu';

  @override
  String get inviteLink => 'Davet bağlantısı';

  @override
  String get leaveCrew => 'Ekipten ayrıl';

  @override
  String get owner => 'Kurucu';

  @override
  String get crewTable => 'Ekip tablosu';

  @override
  String get repsPerMember => 'üye başına tekrar';

  @override
  String seasonResets(String days) {
    return '$days gün sonra sıfırlanır — herkes eşit başlar';
  }

  @override
  String get rankingExplained =>
      'Ekipler toplam tekrara değil, üye başına tekrara göre sıralanır — yoksa en kalabalık ekip sırf kalabalık olduğu için kazanırdı.';

  @override
  String get leaderboard => 'Sıralama';

  @override
  String get global => 'Dünya';

  @override
  String get myCountry => 'Ülkem';

  @override
  String yourFriends(String count) {
    return 'Arkadaşların ($count)';
  }

  @override
  String get challenge => 'Meydan oku';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get pickMovement => 'Bir hareket seç';

  @override
  String get anyExercise => 'Herhangi bir hareket';

  @override
  String get anyExerciseHint =>
      'Setinize başlayın — hareket siz yaparken tanınır';

  @override
  String get start => 'Başla';

  @override
  String get finish => 'Bitir';

  @override
  String get reps => 'tekrar';

  @override
  String get secondsHeld => 'saniye tutuldu';

  @override
  String get learningMovement =>
      'Hareketini öğreniyor — tekrarların birazdan görünecek';

  @override
  String get recalibrate => 'Yeniden ayarla';

  @override
  String get resetCount => 'Sayacı sıfırla';

  @override
  String get checksForm => 'formu kontrol ediyor';

  @override
  String get counts => 'sayıyor';

  @override
  String get time => 'süre';

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
  String get darkMode => 'Koyu mod';

  @override
  String get language => 'Dil';

  @override
  String get units => 'Birimler';

  @override
  String get weight => 'Ağırlık';

  @override
  String get notificationsSection => 'Bildirimler';

  @override
  String get privacy => 'Gizlilik';

  @override
  String get matches => 'Maçlar';

  @override
  String get data => 'Veriler';

  @override
  String get about => 'Hakkında';

  @override
  String get dangerZone => 'Tehlikeli bölge';

  @override
  String get themeSystem => 'Cihazla aynı';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get openCrews => 'Açık ekipler';

  @override
  String get openCrewsHint =>
      'Bu ekipler herkesi kabul eder. Birini seçtiğinizde doğrudan katılırsınız.';

  @override
  String get yourInvitesSubtitle => 'Seni ismen isteyen ekipler.';

  @override
  String get pickOpponent => 'Rakibini seç';

  @override
  String get accept => 'Kabul et';

  @override
  String get join => 'Katıl';

  @override
  String get copy => 'Kopyala';

  @override
  String get copied => 'Davet bağlantısı kopyalandı';

  @override
  String season(String name) {
    return '$name sezonu';
  }

  @override
  String challengeSent(String name) {
    return '$name kişisine meydan okuma gönderildi';
  }

  @override
  String get inviteFriendPrivate => 'Bir arkadaşını özel maça çağır';

  @override
  String get joinWithCodePaste =>
      'Bir üyenin gönderdiği altı karakteri yapıştır.';

  @override
  String get enterTheCode => '6 karakterlik kodu gir';

  @override
  String get followingDevice => 'Şu anda cihazını takip ediyor';

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
  String get visEveryoneHint => 'Profilini herkes açabilir';

  @override
  String get visFriendsHint => 'Sadece eklediğin kişiler';

  @override
  String get visNobodyHint => 'Profilin gizli kalır';

  @override
  String get matchInvites => 'Maç davetleri';

  @override
  String get matchResults => 'Maç sonuçları';

  @override
  String get friendRequestsLabel => 'Arkadaşlık istekleri';

  @override
  String get crewActivity => 'Ekip hareketleri';

  @override
  String get rankChanges => 'Rütbe değişimleri';

  @override
  String get weeklySummary => 'Haftalık özet';

  @override
  String get soundLabel => 'Ses';

  @override
  String get vibration => 'Titreşim';

  @override
  String get whoCanSeeProfile => 'Profilimi kim görebilir';

  @override
  String get profileVisibility => 'Profil görünürlüğü';

  @override
  String get showOnLeaderboards => 'Sıralamalarda görün';

  @override
  String get allowMatchInvites => 'Maç davetlerine izin ver';

  @override
  String get allowFriendRequests => 'Arkadaşlık isteklerine izin ver';

  @override
  String get showHeightWeight => 'Boy ve kiloyu göster';

  @override
  String get showHeightWeightHint => 'Kapalıyken vücut bilgilerin sende kalır';

  @override
  String get autoAcceptFriends => 'Arkadaşlardan otomatik kabul';

  @override
  String get restTimerBetweenSets => 'Setler arası dinlenme sayacı';

  @override
  String get exportData => 'Verilerimi dışa aktar';

  @override
  String get clearCache => 'Önbelleği temizle';

  @override
  String get cacheCleared => 'Önbellek temizlendi';

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
  String get resetProgress => 'İlerlememi sıfırla';

  @override
  String get resetProgressTitle => 'İlerlemen sıfırlansın mı?';

  @override
  String get resetProgressBody =>
      'Rütbe, LP ve maç geçmişi sıfıra döner. Geri alınamaz.';

  @override
  String get actionReset => 'Sıfırla';

  @override
  String get deleteAccount => 'Hesabı sil';

  @override
  String get deleteAccountTitle => 'Hesabın silinsin mi?';

  @override
  String get deleteAccountBody =>
      'Profilin, ekiplerin ve kaldırdığın her maç kalıcı olarak siliniyor.';

  @override
  String get actionDelete => 'Sil';

  @override
  String get needsServer =>
      'Bu özellik bir sunucu gerektiriyor ve henüz bağlanmadı';

  @override
  String get getStarted => 'Hadi başlayalım';

  @override
  String get skipToApp => 'Doğrudan uygulamaya geç';

  @override
  String get achievements => 'Başarımlar';

  @override
  String get unlocked => 'Açıldı';

  @override
  String get roadTitle => 'Efsaneye giden yol';

  @override
  String get allTiers => 'Tüm rütbeler';

  @override
  String get topTier => 'En üst rütbe';

  @override
  String lpToGo(String lp) {
    return '$lp LP';
  }

  @override
  String get unlockedEverything => 'Her şeyi açtın';

  @override
  String unlocksAt(String tier) {
    return '$tier rütbesinde açılıyor';
  }

  @override
  String get matchedSameGroup =>
      'Aynı kas grubunu çalışan biriyle eşleştirileceksin.';

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
  String get dontGetOutrepd => 'Don\'t get OUTREPD!';

  @override
  String xOfY(String a, String b) {
    return '$a / $b';
  }

  @override
  String get tierStone => 'Taş';

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
  String get tierMythic => 'Efsanevi';

  @override
  String get tierLegend => 'Efsane';

  @override
  String get rewardStone => 'Taş çerçeve';

  @override
  String get rewardBronze => 'Bronz rozet';

  @override
  String get rewardSilver => 'Gümüş rozet';

  @override
  String get rewardGold => 'Altın rozet';

  @override
  String get rewardPlatinum => 'Platin rozet';

  @override
  String get rewardDiamond => 'Elmas rozet';

  @override
  String get rewardMaster => 'Usta rozeti';

  @override
  String get rewardMythic => 'Efsanevi rozet';

  @override
  String get rewardLegend => 'Efsane rozeti';

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
  String get yearsSuffix => 'yaş';

  @override
  String get yourCrew => 'Ekibiniz';

  @override
  String get crewName => 'Ekip adı';

  @override
  String get motto => 'Slogan';

  @override
  String get mottoHint => 'Bu ekip neyi temsil ediyor?';

  @override
  String get country => 'Ülke';

  @override
  String get whoCanJoin => 'Kimler katılabilir';

  @override
  String get minimumRank => 'Asgari rütbe';

  @override
  String get anyone => 'Herkes';

  @override
  String get emblem => 'Arma';

  @override
  String get colour => 'Renk';

  @override
  String get createCrewButton => 'Ekibi kur';

  @override
  String get ownerNote =>
      'Kurucusu siz olacaksınız. Bir ekip en fazla 20 sporcu alır.';

  @override
  String get searchCountries => 'Ülke ara';

  @override
  String get noCountryMatch => 'Eşleşen ülke yok';

  @override
  String get nameTooShort => 'Ekibe en az 3 karakterlik bir ad verin';

  @override
  String get privOpen => 'Açık';

  @override
  String get privRequest => 'Katılma isteği';

  @override
  String get privInviteOnly => 'Yalnızca davetle';

  @override
  String get privOpenHint => 'Kodu olan doğrudan katılır';

  @override
  String get privRequestHint => 'İstek gönderilir, bir yetkili onaylar';

  @override
  String get privInviteOnlyHint => 'Yalnızca doğrudan davetle katılınır';

  @override
  String get embStrength => 'Güç';

  @override
  String get embCombat => 'Dövüş';

  @override
  String get embBeasts => 'Canavarlar';

  @override
  String get embElements => 'Elementler';

  @override
  String get embHonours => 'Nişanlar';

  @override
  String get embSymbols => 'Semboller';

  @override
  String get ob1Title => 'Her antrenmanı\nbir mücadeleye çevir';

  @override
  String get ob1Body =>
      'Antrenmanınızı kaydedin ve aynı kas grubunu çalışan biriyle karşı karşıya gelin.';

  @override
  String get ob2Title => 'Arkadaşlarına\nmeydan oku';

  @override
  String get ob2Body =>
      'Özel bir davet gönderin ve kimin daha sıkı çalıştığını belirleyin.';

  @override
  String get ob3Title => 'Rütbelerde yüksel';

  @override
  String get ob3Body =>
      'Her galibiyet LP kazandırır. Taş\'tan Efsane\'ye kadar tırmanın.';

  @override
  String get ob4Title => 'Tek başına çaba\nzordur';

  @override
  String get ob4Body => 'Kimse bakmazken son seti kısa kesmek kolaylaşır.';

  @override
  String get ob5Title => 'Bir Efsane\nol';

  @override
  String get ob5Body => 'Süreklilik birikir. Gelin, geçin, yükselin.';

  @override
  String get letsGo => 'Başlayalım';

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
  String get ttl_bronze_tier => 'Taştan Çıkış';

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
  String get ttl_mythic_tier => 'Efsanevi';

  @override
  String get tdesc_mythic_tier => 'Efsanevi rütbeye ulaş';

  @override
  String get ttl_legend_tier => 'Efsane';

  @override
  String get tdesc_legend_tier => 'Efsane\'ye ulaş';

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
  String get ttl_iron_hold => 'Demir Tutuş';

  @override
  String get tdesc_iron_hold => 'Plank\'ı iki dakika tut';

  @override
  String get ttl_statue => 'Heykel';

  @override
  String get tdesc_statue => 'Plank\'ı beş dakika tut';

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
  String get ttl_joined_up => 'Katıldı';

  @override
  String get tdesc_joined_up => 'Bir ekibe ait ol';

  @override
  String get ttl_backbone => 'Omurga';

  @override
  String get tdesc_backbone => 'Ekibinin başında dört hafta üst üste kal';

  @override
  String get ttl_cornerstone => 'Temel Taş';

  @override
  String get tdesc_cornerstone => 'Ekibinin başında on iki hafta üst üste kal';

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
  String get finish2 => 'Bitir';

  @override
  String get qExperience => 'Antrenman konusunda\nne kadar deneyimlisiniz?';

  @override
  String get expBeginner => 'Başlangıç – Daha önce denedim';

  @override
  String get expIntermediate => 'Orta – Düzenli çalışıyorum';

  @override
  String get expAdvanced => 'İleri – Yıllardır içindeyim';

  @override
  String get qGoal => 'En önemli hedefiniz\nnedir?';

  @override
  String get goalStronger => 'Daha güçlü olmak';

  @override
  String get goalConsistent => 'Daha istikrarlı olmak';

  @override
  String get goalLean => 'Kilo verip incelmek';

  @override
  String get goalMass => 'Kas kütlesi kazanmak';

  @override
  String get aboutYou => 'Bu yolculuk tamamen sizinle ilgili...';

  @override
  String get qThinkAbout => 'Forma girmeyi\nne sıklıkta düşünüyorsunuz?';

  @override
  String get freqNever => 'Hiç';

  @override
  String get freqSometimes => 'Bazen';

  @override
  String get freqOften => 'Sık sık';

  @override
  String get freqAllTime => 'Sürekli';

  @override
  String get qEnergy => 'Antrenman sırasında\nenerjiniz nasıl?';

  @override
  String get energyLow => 'Düşük, gün boyu bitkin hissediyorum';

  @override
  String get energyDrops => 'Performansım seans ortasında düşüyor';

  @override
  String get energyHard => 'Son seti tamamlamak zor geliyor';

  @override
  String get energyHigh => 'Baştan sona yüksek ve istikrarlı';

  @override
  String get stProgress =>
      'Bazen antrenman yaparken ilerlemeyi fark etmek zor oluyor';

  @override
  String get stEffortTitle => 'Kimsenin görmediği çaba\nkolay bırakılır';

  @override
  String get stEffortBody =>
      'Kendinizi kanıtlayacak kimse yokken ilerleme yavaş, çaba anlamsız görünür';

  @override
  String get stAloneTitle => 'Tek başına çalışmak\nsıkıcıdır';

  @override
  String get stAloneBody =>
      'Kimse bakmıyor. Kimse saymıyor. Bir tekrarı, hatta tüm seti atlamak kolaylaşıyor';

  @override
  String get qName => 'Size nasıl\nhitap edelim?';

  @override
  String get nameHint => 'En az 3 karakter. Rakipleriniz bunu görecek.';

  @override
  String get basicInfo => 'Güzel! Şimdi birkaç\ntemel bilgi';

  @override
  String get qAge => 'Kaç yaşındasınız?';

  @override
  String get qWeight => 'Şu anki\nkilonuz nedir?';

  @override
  String get weightWhy => 'Rütbenizi hesaplamak için vücut ağırlığı gerekli.';

  @override
  String get privateNote => 'Bilgileriniz gizlidir ve kimseyle paylaşılmaz.';

  @override
  String get qHeight => 'Boyunuz kaç?';

  @override
  String get qRelate => 'Aşağıdaki ifadeye\nkatılıyor musunuz?';

  @override
  String get yes => 'Evet';

  @override
  String get no => 'Hayır';

  @override
  String get grindTitle => 'Bir rakip varken\nemek başka türlü ilerler';

  @override
  String get grindBody =>
      'Her maç sizi gerçek bir rakibin karşısına çıkarır: işi yapın ve kimin daha sıkı çalıştığını gösterin.';

  @override
  String get allSet => 'Her şey hazır!';

  @override
  String welcomeLifter(String name) {
    return 'Hoş geldiniz $name. İlk rakibinizi bulma vakti.';
  }

  @override
  String get lifter => 'sporcu';

  @override
  String get enterApp => 'OUTREPD\'ye gir';

  @override
  String get commitTitle => 'Şimdi kendi yolculuğunuza\nbir söz verelim';

  @override
  String get holdLogo => 'Hazır olduğunuzu onaylamak için logoyu basılı tutun';

  @override
  String get expNone => 'Hiç antrenman yapmadım';

  @override
  String get iAm => 'Ben...';

  @override
  String get finishMatchQ => 'Maç bitirilsin mi?';

  @override
  String get finishMatchBody =>
      'Toplam hacminiz sabitlenip rakibinizinkiyle karşılaştırılacak.';

  @override
  String get keepGoing => 'Devam et';

  @override
  String get forfeitQ => 'Maçtan çekilinsin mi?';

  @override
  String get forfeitBody => 'Şimdi çıkarsanız LP kaybedersiniz.';

  @override
  String get stay => 'Kal';

  @override
  String get forfeit => 'Çekil';

  @override
  String get pickExercises => 'Çalışacağınız hareketleri seçin';

  @override
  String matchingWith(String muscle) {
    return 'Rütbenizde bir sporcu aranıyor · $muscle';
  }

  @override
  String get getReady => 'HAZIR OL';

  @override
  String get timeLeft => 'KALAN SÜRE';

  @override
  String vsName(String name) {
    return '$name karşısında';
  }

  @override
  String kgTotalVolume(String unit) {
    return '$unit toplam hacim';
  }

  @override
  String get finishMatch => 'MAÇI BİTİR';

  @override
  String get kgHint => 'KG';

  @override
  String get repsHint => 'TEKRAR';

  @override
  String get addSet => 'SET EKLE';

  @override
  String get matchComplete => 'MAÇ TAMAMLANDI';

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
  String get achRivalry => 'Rekabet';

  @override
  String get achRivalryHint => 'Aynı rakibi 3 kez yen';

  @override
  String get nWonTitle => 'Kazandınız!';

  @override
  String nWonBody(String name, String muscle) {
    return '$muscle gününde $name kişisini yendiniz';
  }

  @override
  String get nFriendTitle => 'Yeni arkadaşlık isteği';

  @override
  String nFriendBody(String name) {
    return '$name sizinle bağlantı kurmak istiyor';
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
  String get nameTooShortInline => 'En az 3 karakterlik bir ad seçin';

  @override
  String get whyName => 'Rakipleriniz bunu her sonucun yanında görecek';

  @override
  String get whyExperience =>
      'Sizi kendi seviyenizdeki kişilerle eşleştiriyoruz';

  @override
  String get whyGoal => 'İlk önerilen hareketleriniz buradan çıkıyor';

  @override
  String get whyAge => 'Yaş, ölçüldüğünüz kuvvet standartlarını etkiler';

  @override
  String get whyWeight =>
      'Rütbe, kaldırdığınızı vücut ağırlığınıza oranlar; ham kiloya değil';

  @override
  String get whyHeight => 'Adil standartlar için kilonuzla birlikte kullanılır';

  @override
  String get whyHabits =>
      'Önerdiğimiz hatırlatmaları ve haftalık hedefi belirler';

  @override
  String get transitionPartOfIt =>
      '...o hâlde bunun gerçekten parçası olduğunuzdan emin olalım.';

  @override
  String get male => 'Erkek';

  @override
  String get female => 'Kadın';

  @override
  String get usernamePlaceholder => 'ad';

  @override
  String get stRoutine =>
      'Hangi bölgenin gerçekten çalışmaya ihtiyacı olduğunu bilmiyorum, o yüzden genelde aynı programı tekrarlıyorum';

  @override
  String get shortIn => 'inç';

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
  String membersCount(String n) {
    return '$n üye';
  }

  @override
  String eachCount(String n) {
    return 'kişi başı $n';
  }

  @override
  String lpAmount(String n) {
    return '$n LP';
  }

  @override
  String get countWithCamera => 'Kamerayla say';

  @override
  String get youWin => 'KAZANDINIZ!';

  @override
  String get defeated => 'YENİLDİNİZ';
}
