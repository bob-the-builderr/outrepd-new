// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class LId extends L {
  LId([String locale = 'id']) : super(locale);

  @override
  String get tabFriends => 'Teman';

  @override
  String get tabRanks => 'Peringkat';

  @override
  String get tabMatch => 'Duel';

  @override
  String get tabCrew => 'Kru';

  @override
  String get tabProfile => 'Profil';

  @override
  String get searchOpponent => 'Cari lawan';

  @override
  String get searchOpponentHint => 'Kami carikan lawan setingkat kamu';

  @override
  String get challengeFriend => 'Tantang teman';

  @override
  String get trainWithCamera => 'Latihan pakai kamera';

  @override
  String get viewRoadmap => 'Lihat jalur naik';

  @override
  String lpProgress(int lp, int left) {
    return '$lp / 100 LP · $left lagi untuk naik';
  }

  @override
  String winStreak(int count) {
    return '$count kemenangan beruntun';
  }

  @override
  String get matchHistory => 'Riwayat duel';

  @override
  String get allMatches => 'Semua duel';

  @override
  String get wins => 'Menang';

  @override
  String get losses => 'Kalah';

  @override
  String get winRate => 'Rasio menang';

  @override
  String get streak => 'Rentetan';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Pengaturan';

  @override
  String get stats => 'Statistik';

  @override
  String get edit => 'Ubah';

  @override
  String get save => 'Simpan';

  @override
  String get cancel => 'Batal';

  @override
  String get skip => 'Lewati';

  @override
  String get totalMatches => 'Total duel';

  @override
  String get bestWinStreak => 'Rentetan menang terbaik';

  @override
  String get totalVolume => 'Total beban terangkat';

  @override
  String get height => 'Tinggi';

  @override
  String get bodyweight => 'Berat badan';

  @override
  String get age => 'Usia';

  @override
  String get editYourStats => 'Ubah data kamu';

  @override
  String get editStatsHint =>
      'Kemenangan, volume, dan peringkat itu diraih — bukan diisi.';

  @override
  String get changeName => 'Ganti nama';

  @override
  String get changeNameLast =>
      'Ini kesempatan terakhirmu. Tidak bisa dibatalkan.';

  @override
  String changeNameLeft(int total, int left) {
    return 'Kamu punya $total kali ganti. Sisa $left setelah ini.';
  }

  @override
  String get changeNameUsedUp => 'Dua kesempatan ganti nama sudah habis';

  @override
  String get yourPicture => 'Foto kamu';

  @override
  String get yourPictureHint =>
      'Bingkainya mengikuti peringkat dan berubah saat kamu naik.';

  @override
  String get gallery => 'Galeri';

  @override
  String get camera => 'Kamera';

  @override
  String get orPickOurs => 'Atau pilih punya kami';

  @override
  String get awards => 'Penghargaan';

  @override
  String get yourTitles => 'Gelar kamu';

  @override
  String get stillToEarn => 'Belum diraih';

  @override
  String get noTitlesYet => 'Belum ada. Yang pertama cuma butuh satu duel.';

  @override
  String get wearHint =>
      'Ketuk satu untuk dipakai. Gelarnya muncul di samping namamu di mana pun orang melihatmu.';

  @override
  String get worn => 'dipakai';

  @override
  String get titleUnlocked => 'Gelar terbuka';

  @override
  String get wearIt => 'Pakai';

  @override
  String get wearItLater => 'Nanti saja';

  @override
  String get dayStreak => 'hari beruntun';

  @override
  String get bestEver => 'Rekor';

  @override
  String get restDaysLeft => 'Sisa hari istirahat';

  @override
  String get restIsTraining =>
      'Istirahat bagian dari latihan. Libur dua hari seminggu tidak memutus rentetanmu.';

  @override
  String titlesAndStreak(int owned, int total, int streak) {
    return '$owned dari $total gelar · rentetan $streak hari';
  }

  @override
  String get crew => 'Kru';

  @override
  String get myCrew => 'Kru saya';

  @override
  String get rankings => 'Klasemen';

  @override
  String get trainWithCrew => 'Latihan bareng kru';

  @override
  String get trainWithCrewHint =>
      'Sampai 20 orang di bawah satu nama, mengejar target mingguan bareng dan naik di tabel kru.';

  @override
  String get createCrew => 'Buat kru';

  @override
  String get createCrewHint => 'Beri nama, pilih lambang, ajak orang-orangmu';

  @override
  String get joinOpenCrew => 'Gabung kru terbuka';

  @override
  String get joinOpenCrewHint => 'Kru yang terbuka untuk siapa saja';

  @override
  String get yourInvites => 'Undangan kamu';

  @override
  String get yourInvitesHint => 'Kru yang meminta kamu';

  @override
  String get joinWithCode => 'Gabung pakai kode';

  @override
  String get joinWithCodeHint => 'Enam karakter dari anggota';

  @override
  String get topCrewsThisWeek => 'Kru teratas minggu ini';

  @override
  String get members => 'Anggota';

  @override
  String get repsEach => 'Rep per orang';

  @override
  String get rank => 'Posisi';

  @override
  String get weeklyGoal => 'Target mingguan';

  @override
  String get weeklyGoalDone => 'Target mingguan tercapai';

  @override
  String goalRemaining(int reps, int days) {
    return 'Kurang $reps rep · sisa $days hari';
  }

  @override
  String get goalDoneHint => 'Semua dapat lencana begitu minggunya tutup.';

  @override
  String get startCrewWar => 'Mulai perang kru';

  @override
  String get startCrewWarHint =>
      'Tujuh hari, dua kru sama-sama menghitung. Rep per orang terbanyak menang.';

  @override
  String get whoIsPulling => 'Siapa yang menopang kru';

  @override
  String get thisWeek => 'minggu ini';

  @override
  String get inviteLifters => 'Undang atlet';

  @override
  String get referralCode => 'Kode undangan';

  @override
  String get inviteLink => 'Tautan undangan';

  @override
  String get leaveCrew => 'Keluar dari kru';

  @override
  String get owner => 'Pemilik';

  @override
  String get crewTable => 'Tabel kru';

  @override
  String get repsPerMember => 'rep per anggota';

  @override
  String seasonResets(int days) {
    return 'Direset dalam $days hari — semua mulai dari titik sama';
  }

  @override
  String get rankingExplained =>
      'Kru diurutkan dari rep per anggota, bukan totalnya — kalau tidak, kru paling ramai menang cuma karena jumlah.';

  @override
  String get leaderboard => 'Klasemen';

  @override
  String get global => 'Global';

  @override
  String get myCountry => 'Negara saya';

  @override
  String yourFriends(int count) {
    return 'Teman kamu ($count)';
  }

  @override
  String get challenge => 'Tantang';

  @override
  String get notifications => 'Notifikasi';

  @override
  String get pickMovement => 'Pilih gerakan';

  @override
  String get anyExercise => 'Gerakan apa saja';

  @override
  String get anyExerciseHint =>
      'Mulai set Anda — gerakan dikenali selama pelaksanaan';

  @override
  String get start => 'Mulai';

  @override
  String get finish => 'Selesai';

  @override
  String get reps => 'rep';

  @override
  String get secondsHeld => 'detik ditahan';

  @override
  String get learningMovement =>
      'Sedang mempelajari gerakanmu — hitunganmu muncul sebentar lagi';

  @override
  String get recalibrate => 'Kalibrasi ulang';

  @override
  String get resetCount => 'Nolkan hitungan';

  @override
  String get checksForm => 'memeriksa bentuk';

  @override
  String get counts => 'menghitung';

  @override
  String get time => 'waktu';

  @override
  String get howManyReally => 'Sebenarnya berapa yang kamu lakukan?';

  @override
  String get howManyReallyHint =>
      'Masukkan hitungan Anda sendiri, bukan hitungan aplikasi. Itulah acuan pengukuran akurasi penghitung.';

  @override
  String get appearance => 'Tampilan';

  @override
  String get theme => 'Tema';

  @override
  String get darkMode => 'Mode gelap';

  @override
  String get language => 'Bahasa';

  @override
  String get units => 'Satuan';

  @override
  String get weight => 'Berat';

  @override
  String get notificationsSection => 'Notifikasi';

  @override
  String get privacy => 'Privasi';

  @override
  String get matches => 'Duel';

  @override
  String get data => 'Data';

  @override
  String get about => 'Tentang';

  @override
  String get dangerZone => 'Zona berbahaya';

  @override
  String get themeSystem => 'Ikut perangkat';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get openCrews => 'Kru terbuka';

  @override
  String get openCrewsHint =>
      'Yang ini menerima siapa saja. Pilih satu, langsung masuk.';

  @override
  String get yourInvitesSubtitle => 'Kru yang menyebut namamu langsung.';

  @override
  String get pickOpponent => 'Pilih lawanmu';

  @override
  String get accept => 'Terima';

  @override
  String get join => 'Gabung';

  @override
  String get copy => 'Salin';

  @override
  String get copied => 'Tautan undangan disalin';

  @override
  String season(String name) {
    return 'Musim $name';
  }

  @override
  String challengeSent(String name) {
    return 'Tantangan dikirim ke $name';
  }

  @override
  String get inviteFriendPrivate => 'Ajak teman ke duel privat';

  @override
  String get joinWithCodePaste =>
      'Tempel enam karakter yang dikirim anggota kru.';

  @override
  String get enterTheCode => 'Masukkan kode 6 karakter';

  @override
  String get followingDevice => 'Sekarang mengikuti perangkatmu';

  @override
  String get weightUnitTitle => 'Satuan berat';

  @override
  String get heightUnitTitle => 'Satuan tinggi';

  @override
  String get unitKg => 'Kilogram (kg)';

  @override
  String get unitLb => 'Pon (lb)';

  @override
  String get unitCm => 'Sentimeter (cm)';

  @override
  String get unitFt => 'Kaki & inci';

  @override
  String get visEveryone => 'Semua orang';

  @override
  String get visFriends => 'Teman saja';

  @override
  String get visNobody => 'Tidak seorang pun';

  @override
  String get visEveryoneHint => 'Siapa pun bisa membuka profilmu';

  @override
  String get visFriendsHint => 'Hanya yang sudah kamu tambahkan';

  @override
  String get visNobodyHint => 'Profilmu tetap privat';

  @override
  String get matchInvites => 'Undangan duel';

  @override
  String get matchResults => 'Hasil duel';

  @override
  String get friendRequestsLabel => 'Permintaan pertemanan';

  @override
  String get crewActivity => 'Aktivitas kru';

  @override
  String get rankChanges => 'Perubahan peringkat';

  @override
  String get weeklySummary => 'Ringkasan mingguan';

  @override
  String get soundLabel => 'Suara';

  @override
  String get vibration => 'Getaran';

  @override
  String get whoCanSeeProfile => 'Siapa yang bisa lihat profilku';

  @override
  String get profileVisibility => 'Visibilitas profil';

  @override
  String get showOnLeaderboards => 'Tampilkan saya di klasemen';

  @override
  String get allowMatchInvites => 'Izinkan undangan duel';

  @override
  String get allowFriendRequests => 'Izinkan permintaan pertemanan';

  @override
  String get showHeightWeight => 'Tampilkan tinggi dan berat';

  @override
  String get showHeightWeightHint =>
      'Kalau mati, data tubuhmu jadi milikmu sendiri';

  @override
  String get autoAcceptFriends => 'Terima otomatis dari teman';

  @override
  String get restTimerBetweenSets => 'Timer istirahat antar set';

  @override
  String get exportData => 'Ekspor data saya';

  @override
  String get clearCache => 'Bersihkan cache';

  @override
  String get cacheCleared => 'Cache dibersihkan';

  @override
  String get version => 'Versi';

  @override
  String get rateApp => 'Beri nilai OUTREPD';

  @override
  String get contactSupport => 'Hubungi dukungan';

  @override
  String get termsOfService => 'Ketentuan layanan';

  @override
  String get privacyPolicy => 'Kebijakan privasi';

  @override
  String get openSourceLicences => 'Lisensi sumber terbuka';

  @override
  String get resetProgress => 'Reset kemajuan saya';

  @override
  String get resetProgressTitle => 'Reset kemajuanmu?';

  @override
  String get resetProgressBody =>
      'Peringkat, LP, dan riwayat duel kembali nol. Ini tidak bisa dibatalkan.';

  @override
  String get actionReset => 'Reset';

  @override
  String get deleteAccount => 'Hapus akun';

  @override
  String get deleteAccountTitle => 'Hapus akunmu?';

  @override
  String get deleteAccountBody =>
      'Profil, kru, dan semua duel yang pernah kamu jalani dihapus permanen.';

  @override
  String get actionDelete => 'Hapus';

  @override
  String get needsServer => 'Fitur ini memerlukan server dan belum tersambung';

  @override
  String get getStarted => 'Ayo mulai';

  @override
  String get skipToApp => 'Langsung ke aplikasi';

  @override
  String get achievements => 'Pencapaian';

  @override
  String get unlocked => 'Terbuka';

  @override
  String get roadTitle => 'Jalan menuju Legenda';

  @override
  String get allTiers => 'Semua peringkat';

  @override
  String get topTier => 'Peringkat tertinggi';

  @override
  String lpToGo(int lp) {
    return '$lp LP';
  }

  @override
  String get unlockedEverything => 'Kamu sudah membuka semuanya';

  @override
  String unlocksAt(String tier) {
    return 'Terbuka di $tier';
  }

  @override
  String get matchedSameGroup =>
      'Kamu akan dipasangkan dengan orang yang melatih grup otot yang sama.';

  @override
  String get roomFriendly =>
      'Duel di ruangan sifatnya santai — tidak memengaruhi peringkatmu.';

  @override
  String get createRoom => 'Buat ruangan';

  @override
  String get enterCode => 'MASUKKAN KODE';

  @override
  String get joinRoom => 'Masuk ruangan';

  @override
  String get shareThisCode => 'Bagikan kode ini';

  @override
  String get codeCopied => 'Kode disalin';

  @override
  String get pickMuscleAndStart => 'Pilih otot lalu mulai';

  @override
  String get dontGetOutrepd => 'Don\'t get OUTREPD!';

  @override
  String xOfY(int a, int b) {
    return '$a / $b';
  }

  @override
  String get tierStone => 'Batu';

  @override
  String get tierBronze => 'Perunggu';

  @override
  String get tierSilver => 'Perak';

  @override
  String get tierGold => 'Emas';

  @override
  String get tierPlatinum => 'Platinum';

  @override
  String get tierDiamond => 'Berlian';

  @override
  String get tierMaster => 'Master';

  @override
  String get tierMythic => 'Mitos';

  @override
  String get tierLegend => 'Legenda';

  @override
  String get rewardStone => 'Bingkai batu';

  @override
  String get rewardBronze => 'Lencana perunggu';

  @override
  String get rewardSilver => 'Lencana perak';

  @override
  String get rewardGold => 'Lencana emas';

  @override
  String get rewardPlatinum => 'Lencana platinum';

  @override
  String get rewardDiamond => 'Lencana berlian';

  @override
  String get rewardMaster => 'Lencana master';

  @override
  String get rewardMythic => 'Lencana mitos';

  @override
  String get rewardLegend => 'Lencana legenda';

  @override
  String get shortKg => 'kg';

  @override
  String get shortLb => 'lb';

  @override
  String get shortCm => 'cm';

  @override
  String get shortFt => 'kaki';

  @override
  String winLoss(int w, int l) {
    return '${w}M ${l}K';
  }

  @override
  String get yearsSuffix => 'tahun';

  @override
  String get yourCrew => 'Kru Anda';

  @override
  String get crewName => 'Nama kru';

  @override
  String get motto => 'Moto';

  @override
  String get mottoHint => 'Kru ini mewakili apa?';

  @override
  String get country => 'Negara';

  @override
  String get whoCanJoin => 'Siapa yang boleh bergabung';

  @override
  String get minimumRank => 'Peringkat minimum';

  @override
  String get anyone => 'Siapa saja';

  @override
  String get emblem => 'Lambang';

  @override
  String get colour => 'Warna';

  @override
  String get createCrewButton => 'Buat kru';

  @override
  String get ownerNote =>
      'Anda akan menjadi pemiliknya. Satu kru menampung hingga 20 atlet.';

  @override
  String get searchCountries => 'Cari negara';

  @override
  String get noCountryMatch => 'Tidak ada negara yang cocok';

  @override
  String get nameTooShort => 'Beri kru nama minimal 3 karakter';

  @override
  String get privOpen => 'Terbuka';

  @override
  String get privRequest => 'Ajukan permintaan';

  @override
  String get privInviteOnly => 'Hanya dengan undangan';

  @override
  String get privOpenHint => 'Siapa pun yang punya kode langsung masuk';

  @override
  String get privRequestHint => 'Orang mengajukan, pengurus menyetujui';

  @override
  String get privInviteOnlyHint => 'Anggota harus diundang langsung';

  @override
  String get embStrength => 'Kekuatan';

  @override
  String get embCombat => 'Tarung';

  @override
  String get embBeasts => 'Buas';

  @override
  String get embElements => 'Elemen';

  @override
  String get embHonours => 'Kehormatan';

  @override
  String get embSymbols => 'Simbol';

  @override
  String get ob1Title => 'Ubah setiap sesi\nmenjadi duel';

  @override
  String get ob1Body =>
      'Catat latihan Anda dan hadapi orang yang melatih grup otot yang sama.';

  @override
  String get ob2Title => 'Tantang\nteman Anda';

  @override
  String get ob2Body =>
      'Kirim undangan pribadi dan tentukan siapa yang benar-benar berlatih lebih keras.';

  @override
  String get ob3Title => 'Naikkan peringkat';

  @override
  String get ob3Body =>
      'Setiap kemenangan memberi LP. Naik dari Batu sampai Legenda.';

  @override
  String get ob4Title => 'Usaha sendirian\nitu berat';

  @override
  String get ob4Body =>
      'Berlatih tanpa ada yang melihat membuat set terakhir mudah dipotong.';

  @override
  String get ob5Title => 'Jadilah sebuah\nLegenda';

  @override
  String get ob5Body =>
      'Konsistensi menumpuk. Datang, ungguli, naik peringkat.';

  @override
  String get letsGo => 'Ayo mulai';

  @override
  String get continueLabel => 'Lanjut';
}
