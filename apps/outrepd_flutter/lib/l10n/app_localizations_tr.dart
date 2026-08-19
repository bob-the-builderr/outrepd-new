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
  String lpProgress(int lp, int left) {
    return '$lp / 100 LP · yükselmeye $left kaldı';
  }

  @override
  String winStreak(int count) {
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
  String changeNameLeft(int total, int left) {
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
  String titlesAndStreak(int owned, int total, int streak) {
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
  String goalRemaining(int reps, int days) {
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
  String seasonResets(int days) {
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
  String yourFriends(int count) {
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
  String lpToGo(int lp) {
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
  String xOfY(int a, int b) {
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
  String winLoss(int w, int l) {
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
}
