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
  String lpProgress(String lp, String left) {
    return '$lp / 100 LP · $left lagi untuk naik';
  }

  @override
  String winStreak(String count) {
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
  String changeNameLeft(String total, String left) {
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
  String titlesAndStreak(String owned, String total, String streak) {
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
  String goalRemaining(String reps, String days) {
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
  String seasonResets(String days) {
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
  String yourFriends(String count) {
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
  String lpToGo(String lp) {
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
  String xOfY(String a, String b) {
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
  String winLoss(String w, String l) {
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

  @override
  String get ttl_first_blood => 'Darah Pertama';

  @override
  String get tdesc_first_blood => 'Selesaikan duel pertama Anda';

  @override
  String get ttl_found_footing => 'Pijakan Mantap';

  @override
  String get tdesc_found_footing => 'Selesaikan lima duel';

  @override
  String get ttl_regular => 'Langganan';

  @override
  String get tdesc_regular => 'Dua puluh duel';

  @override
  String get ttl_fifty => 'Lima Puluh';

  @override
  String get tdesc_fifty => 'Lima puluh duel';

  @override
  String get ttl_century => 'Seratus';

  @override
  String get tdesc_century => 'Seratus duel';

  @override
  String get ttl_veteran => 'Veteran';

  @override
  String get tdesc_veteran => 'Dua ratus lima puluh duel';

  @override
  String get ttl_thousand_matches => 'Pengawal Lama';

  @override
  String get tdesc_thousand_matches => 'Seribu duel';

  @override
  String get ttl_first_win => 'Pemenang';

  @override
  String get tdesc_first_win => 'Menangkan satu duel';

  @override
  String get ttl_on_a_roll => 'Sedang Panas';

  @override
  String get tdesc_on_a_roll => 'Menang tiga kali beruntun';

  @override
  String get ttl_five_straight => 'Lima Beruntun';

  @override
  String get tdesc_five_straight => 'Menang lima kali beruntun';

  @override
  String get ttl_unstoppable => 'Tak Terhentikan';

  @override
  String get tdesc_unstoppable => 'Menang sepuluh kali beruntun';

  @override
  String get ttl_untouchable => 'Tak Tersentuh';

  @override
  String get tdesc_untouchable => 'Menang dua puluh kali beruntun';

  @override
  String get ttl_giant_slayer => 'Penakluk Raksasa';

  @override
  String get tdesc_giant_slayer => 'Kalahkan orang dua peringkat di atas Anda';

  @override
  String get ttl_comeback => 'Bangkit Kembali';

  @override
  String get tdesc_comeback => 'Menang tepat setelah tiga kekalahan';

  @override
  String get ttl_nemesis => 'Nemesis';

  @override
  String get tdesc_nemesis => 'Kalahkan atlet yang sama lima kali';

  @override
  String get ttl_hundred_reps => 'Sudah Jalan';

  @override
  String get tdesc_hundred_reps => 'Seratus rep terhitung';

  @override
  String get ttl_five_hundred => 'Sudah Panas';

  @override
  String get tdesc_five_hundred => 'Lima ratus rep terhitung';

  @override
  String get ttl_the_machine => 'Sang Mesin';

  @override
  String get tdesc_the_machine => 'Seribu rep terhitung';

  @override
  String get ttl_five_thousand => 'Tanpa Ampun';

  @override
  String get tdesc_five_thousand => 'Lima ribu rep terhitung';

  @override
  String get ttl_ten_thousand => 'Sepuluh Ribu';

  @override
  String get tdesc_ten_thousand => 'Sepuluh ribu rep terhitung';

  @override
  String get ttl_fifty_thousand => 'Di Luar Hitungan';

  @override
  String get tdesc_fifty_thousand => 'Lima puluh ribu rep terhitung';

  @override
  String get ttl_first_tonne => 'Satu Ton';

  @override
  String get tdesc_first_tonne => 'Angkat total seribu kilogram';

  @override
  String get ttl_ten_tonnes => 'Sepuluh Ton';

  @override
  String get tdesc_ten_tonnes => 'Angkat sepuluh ribu kilogram';

  @override
  String get ttl_six_figures => 'Enam Digit';

  @override
  String get tdesc_six_figures => 'Angkat seratus ribu kilogram';

  @override
  String get ttl_half_million => 'Setengah Juta';

  @override
  String get tdesc_half_million => 'Angkat lima ratus ribu kilogram';

  @override
  String get ttl_million_kg => 'Klub Sejuta Kilo';

  @override
  String get tdesc_million_kg => 'Angkat satu juta kilogram';

  @override
  String get ttl_two_days => 'Kembali Lagi';

  @override
  String get tdesc_two_days => 'Berlatih dua hari berturut-turut';

  @override
  String get ttl_no_days_off => 'Tanpa Libur';

  @override
  String get tdesc_no_days_off => 'Berlatih tujuh hari berturut-turut';

  @override
  String get ttl_fortnight => 'Dua Pekan';

  @override
  String get tdesc_fortnight => 'Rentetan empat belas hari';

  @override
  String get ttl_unbroken => 'Tak Terputus';

  @override
  String get tdesc_unbroken => 'Rentetan tiga puluh hari';

  @override
  String get ttl_sixty_days => 'Kebiasaan';

  @override
  String get tdesc_sixty_days => 'Rentetan enam puluh hari';

  @override
  String get ttl_hundred_days => 'Seratus Hari';

  @override
  String get tdesc_hundred_days => 'Rentetan seratus hari';

  @override
  String get ttl_year_round => 'Sepanjang Tahun';

  @override
  String get tdesc_year_round => 'Rentetan tiga ratus enam puluh lima hari';

  @override
  String get ttl_perfect_week => 'Pekan Sempurna';

  @override
  String get tdesc_perfect_week => 'Berlatih setiap hari selama sepekan';

  @override
  String get ttl_perfect_month => 'Bulan Sempurna';

  @override
  String get tdesc_perfect_month => 'Empat pekan sempurna';

  @override
  String get ttl_bronze_tier => 'Lepas dari Batu';

  @override
  String get tdesc_bronze_tier => 'Capai Perunggu';

  @override
  String get ttl_silver_tier => 'Keperakan';

  @override
  String get tdesc_silver_tier => 'Capai Perak';

  @override
  String get ttl_golden_era => 'Era Keemasan';

  @override
  String get tdesc_golden_era => 'Capai Emas';

  @override
  String get ttl_platinum_tier => 'Platinum';

  @override
  String get tdesc_platinum_tier => 'Capai Platinum';

  @override
  String get ttl_diamond_tier => 'Tangan Berlian';

  @override
  String get tdesc_diamond_tier => 'Capai Berlian';

  @override
  String get ttl_master_tier => 'Master';

  @override
  String get tdesc_master_tier => 'Capai Master';

  @override
  String get ttl_mythic_tier => 'Mitos';

  @override
  String get tdesc_mythic_tier => 'Capai peringkat Mitos';

  @override
  String get ttl_legend_tier => 'Legenda';

  @override
  String get tdesc_legend_tier => 'Capai Legenda';

  @override
  String get ttl_clean_hands => 'Tangan Bersih';

  @override
  String get tdesc_clean_hands => 'Satu set penuh dengan setiap rep terhitung';

  @override
  String get ttl_spotless => 'Tanpa Cela';

  @override
  String get tdesc_spotless => 'Sepuluh set bersih';

  @override
  String get ttl_textbook => 'Sesuai Buku';

  @override
  String get tdesc_textbook => 'Lima puluh set bersih';

  @override
  String get ttl_iron_hold => 'Genggaman Besi';

  @override
  String get tdesc_iron_hold => 'Tahan plank selama dua menit';

  @override
  String get ttl_statue => 'Patung';

  @override
  String get tdesc_statue => 'Tahan plank selama lima menit';

  @override
  String get ttl_all_rounder => 'Serba Bisa';

  @override
  String get tdesc_all_rounder => 'Hitung lima gerakan berbeda';

  @override
  String get ttl_explorer => 'Penjelajah';

  @override
  String get tdesc_explorer => 'Hitung lima belas gerakan berbeda';

  @override
  String get ttl_encyclopedia => 'Ensiklopedia';

  @override
  String get tdesc_encyclopedia => 'Hitung empat puluh gerakan berbeda';

  @override
  String get ttl_early_bird => 'Sif Pagi';

  @override
  String get tdesc_early_bird => 'Sepuluh sesi sebelum pukul tujuh pagi';

  @override
  String get ttl_sunrise_club => 'Klub Fajar';

  @override
  String get tdesc_sunrise_club => 'Lima puluh sesi sebelum pukul tujuh';

  @override
  String get ttl_night_owl => 'Sif Malam';

  @override
  String get tdesc_night_owl => 'Sepuluh sesi setelah pukul sepuluh malam';

  @override
  String get ttl_graveyard => 'Sif Dini Hari';

  @override
  String get tdesc_graveyard => 'Lima puluh sesi setelah pukul sepuluh';

  @override
  String get ttl_joined_up => 'Sudah Bergabung';

  @override
  String get tdesc_joined_up => 'Menjadi anggota kru';

  @override
  String get ttl_backbone => 'Tulang Punggung';

  @override
  String get tdesc_backbone => 'Pimpin kru Anda empat pekan berturut-turut';

  @override
  String get ttl_cornerstone => 'Batu Penjuru';

  @override
  String get tdesc_cornerstone =>
      'Pimpin kru Anda dua belas pekan berturut-turut';

  @override
  String get ttl_not_alone => 'Tidak Sendiri';

  @override
  String get tdesc_not_alone => 'Tambahkan teman pertama Anda';

  @override
  String get ttl_well_connected => 'Luas Kenalan';

  @override
  String get tdesc_well_connected => 'Sepuluh teman';

  @override
  String get ttl_the_gym_knows => 'Seisi Gym Mengenal Anda';

  @override
  String get tdesc_the_gym_knows => 'Lima puluh teman';

  @override
  String get finish2 => 'Selesai';

  @override
  String get qExperience => 'Seberapa berpengalaman Anda\ndalam berlatih?';

  @override
  String get expBeginner => 'Pemula – Pernah mencoba';

  @override
  String get expIntermediate => 'Menengah – Berlatih rutin';

  @override
  String get expAdvanced => 'Mahir – Bertahun-tahun pengalaman';

  @override
  String get qGoal => 'Apa tujuan utama\nkebugaran Anda?';

  @override
  String get goalStronger => 'Menjadi lebih kuat';

  @override
  String get goalConsistent => 'Menjadi lebih konsisten';

  @override
  String get goalLean => 'Menurunkan berat dan mengencangkan';

  @override
  String get goalMass => 'Menambah massa otot';

  @override
  String get aboutYou => 'Perjalanan ini sepenuhnya tentang Anda...';

  @override
  String get qThinkAbout =>
      'Seberapa sering Anda memikirkan\nuntuk kembali bugar?';

  @override
  String get freqNever => 'Tidak pernah';

  @override
  String get freqSometimes => 'Kadang-kadang';

  @override
  String get freqOften => 'Sering';

  @override
  String get freqAllTime => 'Sepanjang waktu';

  @override
  String get qEnergy => 'Bagaimana energi Anda\nsaat berlatih?';

  @override
  String get energyLow => 'Rendah, saya lelah sepanjang hari';

  @override
  String get energyDrops => 'Performa turun di tengah sesi';

  @override
  String get energyHard => 'Sulit menuntaskan set terakhir';

  @override
  String get energyHigh => 'Tinggi dan stabil dari awal sampai akhir';

  @override
  String get stProgress => 'Kadang sulit melihat kemajuan saat saya berlatih';

  @override
  String get stEffortTitle =>
      'Usaha yang tak dilihat siapa pun\nmudah ditinggalkan';

  @override
  String get stEffortBody =>
      'Ketika tidak ada yang perlu dibuktikan kepada siapa pun, kemajuan terasa lambat dan usaha terasa sia-sia';

  @override
  String get stAloneTitle => 'Berlatih sendirian\nitu membosankan';

  @override
  String get stAloneBody =>
      'Tidak ada yang melihat. Tidak ada yang menghitung. Mudah melewatkan satu rep, atau seluruh set';

  @override
  String get qName => 'Kami memanggil Anda\nsiapa?';

  @override
  String get nameHint => 'Minimal 3 karakter. Inilah yang dilihat para lawan.';

  @override
  String get basicInfo => 'Baik! Sekarang beberapa\ndata dasar';

  @override
  String get qAge => 'Berapa usia Anda?';

  @override
  String get qWeight => 'Berapa berat\nbadan Anda sekarang?';

  @override
  String get weightWhy =>
      'Berat badan diperlukan untuk menghitung peringkat Anda.';

  @override
  String get privateNote =>
      'Data Anda bersifat pribadi dan tidak akan dibagikan kepada siapa pun.';

  @override
  String get qHeight => 'Berapa tinggi Anda?';

  @override
  String get qRelate =>
      'Apakah Anda merasakan hal\nyang sama dengan kalimat berikut?';

  @override
  String get yes => 'Ya';

  @override
  String get no => 'Tidak';

  @override
  String get grindTitle => 'Kerja keras terasa berbeda\nsaat ada lawan';

  @override
  String get grindBody =>
      'Setiap duel mempertemukan Anda dengan lawan sungguhan: kerjakan bagian Anda dan buktikan siapa yang berlatih lebih keras.';

  @override
  String get allSet => 'Semua siap!';

  @override
  String welcomeLifter(String name) {
    return 'Selamat datang, $name. Saatnya mencari lawan pertama Anda.';
  }

  @override
  String get lifter => 'atlet';

  @override
  String get enterApp => 'Masuk ke OUTREPD';

  @override
  String get commitTitle => 'Sekarang mari berkomitmen\npada perjalanan Anda';

  @override
  String get holdLogo => 'Tekan dan tahan logo untuk memastikan Anda siap';

  @override
  String get expNone => 'Saya belum pernah berlatih';

  @override
  String get iAm => 'Saya...';

  @override
  String get finishMatchQ => 'Akhiri duel?';

  @override
  String get finishMatchBody =>
      'Volume Anda akan dikunci dan dibandingkan dengan lawan.';

  @override
  String get keepGoing => 'Lanjutkan';

  @override
  String get forfeitQ => 'Mundur dari duel?';

  @override
  String get forfeitBody => 'Anda akan kehilangan LP jika keluar sekarang.';

  @override
  String get stay => 'Tetap';

  @override
  String get forfeit => 'Mundur';

  @override
  String get pickExercises => 'Pilih gerakan yang akan Anda latih';

  @override
  String matchingWith(String muscle) {
    return 'Mencarikan lawan setingkat Anda · $muscle';
  }

  @override
  String get getReady => 'BERSIAP';

  @override
  String get timeLeft => 'SISA WAKTU';

  @override
  String vsName(String name) {
    return 'vs $name';
  }

  @override
  String kgTotalVolume(String unit) {
    return '$unit total volume';
  }

  @override
  String get finishMatch => 'AKHIRI DUEL';

  @override
  String get kgHint => 'KG';

  @override
  String get repsHint => 'REP';

  @override
  String get addSet => 'TAMBAH SET';

  @override
  String get matchComplete => 'DUEL SELESAI';

  @override
  String get you => 'ANDA';

  @override
  String get vs => 'VS';

  @override
  String get backToHome => 'KEMBALI KE BERANDA';

  @override
  String get mgChest => 'Dada';

  @override
  String get mgBack => 'Punggung';

  @override
  String get mgLegs => 'Kaki';

  @override
  String get mgShoulders => 'Bahu';

  @override
  String get mgArms => 'Lengan';

  @override
  String get mgCore => 'Inti tubuh';

  @override
  String get achRivalry => 'Persaingan';

  @override
  String get achRivalryHint => 'Kalahkan lawan yang sama 3 kali';

  @override
  String get nWonTitle => 'Anda menang!';

  @override
  String nWonBody(String name, String muscle) {
    return 'Anda mengalahkan $name di hari $muscle';
  }

  @override
  String get nFriendTitle => 'Permintaan pertemanan baru';

  @override
  String nFriendBody(String name) {
    return '$name ingin terhubung';
  }

  @override
  String get nAchTitle => 'Pencapaian terbuka';

  @override
  String nAchBody(String title, String hint) {
    return '$title — $hint';
  }

  @override
  String get nRankTitle => 'Peringkat naik!';

  @override
  String nRankBody(String rank) {
    return 'Anda mencapai $rank';
  }

  @override
  String get nameTooShortInline => 'Pilih nama minimal 3 karakter';

  @override
  String get whyName => 'Lawan akan melihatnya di samping setiap hasil';

  @override
  String get whyExperience => 'Kami memasangkan Anda dengan orang setingkat';

  @override
  String get whyGoal => 'Gerakan pertama yang kami sarankan berasal dari sini';

  @override
  String get whyAge =>
      'Usia memengaruhi standar kekuatan yang jadi tolok ukur Anda';

  @override
  String get whyWeight =>
      'Peringkat membandingkan beban relatif terhadap berat badan, bukan kilogram mentah';

  @override
  String get whyHeight =>
      'Dipakai bersama berat badan untuk menetapkan standar yang adil';

  @override
  String get whyHabits =>
      'Ini menentukan pengingat dan target mingguan yang kami sarankan';

  @override
  String get transitionPartOfIt =>
      '...jadi mari pastikan Anda benar-benar bagian darinya.';

  @override
  String get male => 'Pria';

  @override
  String get female => 'Wanita';

  @override
  String get usernamePlaceholder => 'nama';

  @override
  String get stRoutine =>
      'Saya tidak tahu bagian tubuh mana yang benar-benar perlu dilatih, jadi biasanya saya mengulang rutinitas yang sama';

  @override
  String get shortIn => 'inci';

  @override
  String get today => 'Hari ini';

  @override
  String get yesterday => 'Kemarin';

  @override
  String daysAgo(String n) {
    return '$n hari lalu';
  }

  @override
  String weeksAgo(String n) {
    return '$n minggu lalu';
  }

  @override
  String membersCount(String n) {
    return '$n anggota';
  }

  @override
  String eachCount(String n) {
    return '$n per orang';
  }

  @override
  String lpAmount(String n) {
    return '$n LP';
  }

  @override
  String get countWithCamera => 'Hitung pakai kamera';

  @override
  String get youWin => 'ANDA MENANG!';

  @override
  String get defeated => 'KALAH';

  @override
  String get fillWholeNumbers => 'Isi ketiganya dengan bilangan bulat';

  @override
  String heightRange(String min, String max, String unit) {
    return 'Tinggi harus antara $min dan $max $unit';
  }

  @override
  String weightRange(String min, String max, String unit) {
    return 'Berat harus antara $min dan $max $unit';
  }

  @override
  String ageRange(String min, String max) {
    return 'Usia harus antara $min dan $max';
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
    return '$n lagi untuk naik';
  }

  @override
  String get noFriendsTitle => 'Belum ada teman';

  @override
  String get noFriendsBody =>
      'Tambahkan seseorang dan kamu bisa menantangnya duel privat kapan saja.';

  @override
  String get noMatchesTitle => 'Belum ada duel';

  @override
  String get noMatchesBody =>
      'Yang pertama akan muncul di sini, menang atau kalah.';

  @override
  String get noNotificationsTitle => 'Belum ada yang baru';

  @override
  String get noNotificationsBody =>
      'Undangan duel, hasil, dan permintaan pertemanan masuk ke sini.';

  @override
  String roundDone(String n) {
    return 'Ronde $n selesai';
  }

  @override
  String get bestRoundYet => 'Ronde terbaik sejauh ini';

  @override
  String get countedThat => 'Terhitung di ronde ini';

  @override
  String get thatIsRight => 'Betul';

  @override
  String get useMyCount => 'Pakai hitungan saya';

  @override
  String get confirmHint => 'Ubah kalau kameranya salah.';

  @override
  String pickNMore(String n) {
    return 'Pilih $n lagi';
  }

  @override
  String get findOpponent => 'Cari lawan';

  @override
  String get unsureMovement =>
      'Belum yakin ini gerakan yang benar — cek angkanya.';
}
