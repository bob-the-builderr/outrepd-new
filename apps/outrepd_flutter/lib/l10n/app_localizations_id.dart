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
  String get tabProfile => 'Profil';

  @override
  String get challengeFriend => 'Tantang teman';

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
  String get settings => 'Pengaturan';

  @override
  String get accountSection => 'Akun';

  @override
  String get duelSection => 'Duel';

  @override
  String get hapticsEachRep => 'Getar tiap repetisi';

  @override
  String get showSkeleton => 'Tampilkan kerangka';

  @override
  String get showSkeletonHint => 'Cara tahu kamera mengenalimu';

  @override
  String get manageNotifications => 'Kelola notifikasi';

  @override
  String switchesOn(String on, String all) {
    return '$on dari $all aktif';
  }

  @override
  String get whoCanChallenge => 'Siapa yang boleh menantangku';

  @override
  String get blockedAccounts => 'Akun yang diblokir';

  @override
  String get reportProblem => 'Laporkan masalah';

  @override
  String get onDeviceNote =>
      'Deteksi pose berjalan di ponsel ini. Tidak ada video atau data pose yang diunggah.';

  @override
  String get visibilitySection => 'Visibilitas';

  @override
  String get showMyCountry => 'Tampilkan negaraku';

  @override
  String get showMyCountryHint => 'Jika mati, kamu keluar dari papan negara';

  @override
  String get safetySection => 'Keamanan';

  @override
  String get socialSection => 'Sosial';

  @override
  String get noticeRaced => 'Seseorang menantang set-ku';

  @override
  String get noticeRacedHint => 'Satu-satunya cara tahu ada duel';

  @override
  String get noticeFriendOk => 'Permintaanku diterima';

  @override
  String get noticesStoredNote =>
      'Mematikan berarti tidak pernah disimpan, bukan disembunyikan.';

  @override
  String get notSaved => 'Tidak tersimpan';

  @override
  String get blockedIntro =>
      'Akun yang diblokir tidak bisa menantang, menemukan, atau mengirimimu permintaan. Mereka tidak diberi tahu.';

  @override
  String blockedWhen(String when) {
    return 'Diblokir $when';
  }

  @override
  String get unblock => 'Buka blokir';

  @override
  String get noBlockedTitle => 'Tidak ada yang diblokir';

  @override
  String get noBlockedBody =>
      'Kamu bisa memblokir dari profil atau dari laporan.';

  @override
  String get whatHappened => 'Apa yang terjadi';

  @override
  String get reasonCheating => 'Curang atau repetisi palsu';

  @override
  String get reasonHarassment => 'Pelecehan atau kekerasan';

  @override
  String get reasonContent => 'Konten tidak pantas';

  @override
  String get reasonImpersonation => 'Peniruan identitas';

  @override
  String get reasonOther => 'Hal lain';

  @override
  String get addDetails => 'Tambah detail (opsional)';

  @override
  String get alsoBlock => 'Blokir juga akun ini';

  @override
  String get sendReport => 'Kirim laporan';

  @override
  String get reportSent => 'Laporan terkirim';

  @override
  String get reportingThisAccount => 'Melaporkan akun ini';

  @override
  String get exportIntro =>
      'Kami kirim file berisi semua yang server simpan tentangmu lewat email. Biasanya satu menit.';

  @override
  String get whatsIncluded => 'Apa saja isinya';

  @override
  String get incProfile => 'Profil dan peringkatmu';

  @override
  String get incSets => 'Setiap set dan hitungan rep';

  @override
  String get incDuels => 'Riwayat duel dan perubahan LP';

  @override
  String get incFriends => 'Teman dan akun yang diblokir';

  @override
  String get incNotices => 'Notifikasi yang kamu terima';

  @override
  String get noLandmarksNote =>
      'Titik pose tidak ada di dalamnya, dan tidak pernah ada. Kamera membacanya di ponselmu dan tidak dikirim ke mana pun.';

  @override
  String get sendItTo => 'Kirim ke';

  @override
  String get emailHint => 'kamu@contoh.com';

  @override
  String get createAccountTitle => 'Buat akun';

  @override
  String get createAccountBody =>
      'Tambahkan email dan kata sandi agar akun ini tidak hanya bergantung pada satu ponsel.';

  @override
  String get createAccountAction => 'Buat akun';

  @override
  String get emailTakenSwitchToSignIn =>
      'Email ini sudah memiliki akun — masuk saja.';

  @override
  String get emailSignUpInvalid =>
      'Periksa email dan kata sandi — minimal enam karakter.';

  @override
  String get tooManyCodes =>
      'Terlalu banyak kode terkirim — tunggu beberapa menit lalu coba lagi.';

  @override
  String get sendCodeAction => 'Kirim kode';

  @override
  String get noAccountForEmail => 'Kami tidak menemukan akun dengan email itu.';

  @override
  String get authEntryTagline => 'Push-up. Bertanding. Naik peringkat.';

  @override
  String get signUpWithEmail => 'Daftar dengan email';

  @override
  String get alreadyHaveAccountQuestion => 'Sudah punya akun?';

  @override
  String get logInAction => 'Masuk';

  @override
  String get createYourAccountTitle => 'Buat akunmu';

  @override
  String get createAccountSubtitle => 'Kurang dari semenit.';

  @override
  String get usernameLabel => 'Nama pengguna';

  @override
  String get emailLabel => 'Email';

  @override
  String get logInSubtitle => 'Masuk untuk menjaga peringkatmu.';

  @override
  String get checkYourEmailTitle => 'Periksa emailmu';

  @override
  String codeSentTo(String email) {
    return 'Kami mengirim kode 6 digit ke $email.';
  }

  @override
  String get didntGetIt => 'Tidak menerimanya?';

  @override
  String resendInSeconds(String time) {
    return 'Kirim ulang dalam $time';
  }

  @override
  String get wrongEmailGoBack => 'Email salah? Kembali';

  @override
  String get usernameTaken => 'Nama pengguna itu sudah dipakai.';

  @override
  String get wrongCode => 'Kode itu salah atau sudah kedaluwarsa.';

  @override
  String get resendCode => 'Kirim ulang kode';

  @override
  String get codeResent => 'Kode baru terkirim.';

  @override
  String signedInAs(String email) {
    return 'Masuk sebagai $email';
  }

  @override
  String get addressNotKept =>
      'Alamat dipakai sekali dan tidak disimpan — akun ini tidak punya email.';

  @override
  String get requestMyData => 'Email-kan dataku';

  @override
  String exportSent(String address) {
    return 'Dikirim ke $address';
  }

  @override
  String get deleteIntro =>
      'Ini menghapus semuanya secara permanen. Tidak bisa dibatalkan atau dipulihkan.';

  @override
  String get rankLabel => 'Peringkat';

  @override
  String get wantCopyFirst => 'Mau salinannya dulu?';

  @override
  String get wantCopyBody =>
      'Unduh datamu sebelum menghapus. Setelah ini, hilang.';

  @override
  String typeToConfirm(String word) {
    return 'Ketik $word untuk konfirmasi';
  }

  @override
  String get deleteWord => 'HAPUS';

  @override
  String get deletePermanently => 'Hapus permanen';

  @override
  String get keepMyAccount => 'Simpan akunku';

  @override
  String get save => 'Simpan';

  @override
  String get cancel => 'Batal';

  @override
  String get skip => 'Lewati';

  @override
  String get yourPicture => 'Foto kamu';

  @override
  String get yourPictureHint =>
      'Bingkainya mengikuti peringkat dan berubah saat kamu naik.';

  @override
  String get couldNotUsePicture => 'Tidak bisa memakai foto itu';

  @override
  String get couldNotSyncAvatar => 'Fotomu tersimpan, tapi belum tersinkron';

  @override
  String get couldNotShareCard => 'Kartu ini tidak bisa dibagikan';

  @override
  String get couldNotOpenLink => 'Tautan itu tidak bisa dibuka';

  @override
  String get couldNotCheckUsername =>
      'Nama itu tidak bisa diperiksa — coba lagi';

  @override
  String get changeUsername => 'Ubah nama pengguna';

  @override
  String get usernameInvalidLength =>
      'Harus 4 sampai 20 karakter, hanya huruf, angka, dan _';

  @override
  String get usernameChanged => 'Nama pengguna diubah';

  @override
  String get usernameAlreadyChangedBody =>
      'Anda sudah menggunakan satu-satunya kesempatan mengubah nama pengguna — setiap akun hanya mendapat satu kali.';

  @override
  String get gallery => 'Galeri';

  @override
  String get camera => 'Kamera';

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
  String get global => 'Global';

  @override
  String get topPlayers => 'Pemain Teratas';

  @override
  String get yourTier => 'Tingkatanmu';

  @override
  String get challenge => 'Tantang';

  @override
  String get notifications => 'Notifikasi';

  @override
  String get start => 'Mulai';

  @override
  String get finish => 'Selesai';

  @override
  String get reps => 'rep';

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
  String get language => 'Bahasa';

  @override
  String get privacy => 'Privasi';

  @override
  String get data => 'Data';

  @override
  String get about => 'Tentang';

  @override
  String get themeSystem => 'Ikut perangkat';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get accept => 'Terima';

  @override
  String get visEveryone => 'Semua orang';

  @override
  String get visFriends => 'Teman saja';

  @override
  String get visNobody => 'Tidak seorang pun';

  @override
  String get friendRequestsLabel => 'Permintaan pertemanan';

  @override
  String get showOnLeaderboards => 'Tampilkan saya di klasemen';

  @override
  String get exportData => 'Ekspor data saya';

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
  String get deleteAccount => 'Hapus akun';

  @override
  String get needsServer => 'Tidak bisa terhubung. Periksa internetmu lalu coba lagi.';

  @override
  String get roomFriendly =>
      'Duel di ruangan sifatnya santai — tidak memengaruhi peringkatmu.';

  @override
  String get shareThisCode => 'Bagikan kode ini';

  @override
  String get codeCopied => 'Kode disalin';

  @override
  String xOfY(String a, String b) {
    return '$a / $b';
  }

  @override
  String get tierIron => 'Besi';

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
  String winLoss(String w, String l) {
    return '${w}M ${l}K';
  }

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
  String get ttl_bronze_tier => 'Lepas dari Besi';

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
  String get forfeitQ => 'Mundur dari duel?';

  @override
  String get forfeitBody => 'Anda akan kehilangan LP jika keluar sekarang.';

  @override
  String get stay => 'Tetap';

  @override
  String get forfeit => 'Mundur';

  @override
  String get getReady => 'BERSIAP';

  @override
  String get you => 'ANDA';

  @override
  String get vs => 'VS';

  @override
  String get backToHome => 'KEMBALI KE BERANDA';

  @override
  String get mgChest => 'Dada';

  @override
  String get nWonTitle => 'Anda menang!';

  @override
  String nWonBody(String name, String muscle) {
    return 'Anda mengalahkan $name di hari $muscle';
  }

  @override
  String get nFriendTitle => 'Permintaan pertemanan baru';

  @override
  String get nRacedTitle => 'Set-mu ditantang';

  @override
  String nRacedHeld(String name, String yours, String theirs) {
    return '$name menantang set-mu dan kalah, $yours–$theirs';
  }

  @override
  String nRacedBeaten(String name, String theirs, String yours) {
    return '$name menantang set-mu dan menang, $theirs–$yours';
  }

  @override
  String get nFriendOkTitle => 'Permintaan pertemanan diterima';

  @override
  String nFriendOkBody(String name) {
    return '$name menerima permintaanmu';
  }

  @override
  String nFriendBody(String name) {
    return '$name ingin terhubung';
  }

  @override
  String get nChallengedTitle => 'Tanding ulang';

  @override
  String nChallengedBody(String name) {
    return '$name ingin tanding ulang';
  }

  @override
  String get challengeSentTitle => 'Tantangan terkirim';

  @override
  String challengeSentBody(String name) {
    return 'Kami akan memberi tahu $name. Kembali lagi setelah mereka menjalankannya.';
  }

  @override
  String get challengeNotSentTitle => 'Gagal mengirim';

  @override
  String get challengeNotSentBody =>
      'Periksa koneksi Anda dan coba lagi dari tab Match.';

  @override
  String get challengeGoneTitle => 'Tantangan sudah tidak ada';

  @override
  String get challengeGoneBody => 'Sudah ditanding, atau sudah dibatalkan.';

  @override
  String repsRecordedLine(String reps) {
    return '$reps repetisi tercatat';
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
  String lpAmount(String n) {
    return '$n LP';
  }

  @override
  String get lpUnit => 'LP';

  @override
  String get trueCountHint => 'cth. 12';

  @override
  String get couldNotSaveSession => 'Sesi tidak dapat disimpan';

  @override
  String lpOutOf(String total) {
    return '/ $total LP';
  }

  @override
  String get noFriendsTitle => 'Belum ada teman';

  @override
  String get noFriendsBody => 'Duel lawan orang yang kamu kenal rasanya beda.';

  @override
  String get decline => 'Tolak';

  @override
  String requestSent(String name) {
    return 'Permintaan dikirim ke $name';
  }

  @override
  String nowFriends(String name) {
    return 'Kamu dan $name sekarang berteman';
  }

  @override
  String get noOneFound => 'Tidak ada yang memakai nama itu';

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
  String get countedThat => 'Terhitung di ronde ini';

  @override
  String get thatIsRight => 'Betul';

  @override
  String get useMyCount => 'Pakai hitungan saya';

  @override
  String get confirmHint => 'Ubah kalau kameranya salah.';

  @override
  String get unsureMovement =>
      'Belum yakin ini gerakan yang benar — cek angkanya.';

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
  String get searchByUsername => 'Cari berdasarkan nama pengguna';

  @override
  String get incomingRequests => 'Permintaan masuk';

  @override
  String get noRequestsWaiting => 'Tidak ada permintaan yang menunggu saat ini';

  @override
  String get addFriendAction => 'Tambah Teman';

  @override
  String get addFriendHint =>
      'Masukkan nama pengguna mereka, atau kode # dari profil mereka.';

  @override
  String get usernameOrCode => 'Nama pengguna atau kode #';

  @override
  String get sendRequest => 'Kirim permintaan';

  @override
  String onlineNowCount(String count) {
    return 'Online sekarang · $count';
  }

  @override
  String offlineCount(String count) {
    return 'Offline · $count';
  }

  @override
  String get invite => 'Undang';

  @override
  String get headToHeadTitle => 'Rekor pertemuan';

  @override
  String get vsYouCaption => 'lawan kamu';

  @override
  String get h2hYou => 'kamu';

  @override
  String get h2hThem => 'dia';

  @override
  String headToHead(String wins, String losses) {
    return '${wins}M ${losses}K lawan kamu';
  }

  @override
  String get neverPlayedYou => 'Belum pernah lawan kamu';

  @override
  String noHistoryWithThem(String username) {
    return 'Kamu belum pernah lawan $username.';
  }

  @override
  String lastDuelScore(String yourReps, String theirReps, String when) {
    return 'Terakhir kali: $yourReps–$theirReps, $when.';
  }

  @override
  String yourBestVsThemLine(String reps) {
    return 'Rekor terbaikmu melawan mereka adalah $reps.';
  }

  @override
  String get viewFullProfile => 'Lihat profil lengkap';

  @override
  String get moreOptions => 'Opsi lainnya';

  @override
  String get block => 'Blokir';

  @override
  String get blockRowBody =>
      'Mereka tidak bisa menantangmu atau melihat profilmu';

  @override
  String get report => 'Laporkan';

  @override
  String get reportRowBody => 'Ditinjau dalam 24 jam';

  @override
  String muteChallenges(String username) {
    return 'Bisukan tantangan dari $username';
  }

  @override
  String blockedLifter(String username) {
    return '$username diblokir';
  }

  @override
  String mutedLifter(String username) {
    return '$username dibisukan';
  }

  @override
  String get addFriendButton => 'Tambah teman';

  @override
  String get alreadyFriends => 'Teman';

  @override
  String get couldNotLoadProfile => 'Profil ini tidak bisa dimuat';

  @override
  String get noFriendsMatch => 'Tidak ada yang bernama itu';

  @override
  String get yourClimb => 'Pendakianmu';

  @override
  String floorKept(String tier, String rank) {
    return '$tier sudah jadi milikmu. Kamu tidak akan turun di bawah $rank.';
  }

  @override
  String dayStreakCount(String count) {
    return '$count hari berturut-turut';
  }

  @override
  String get findMatch => 'Cari pertandingan';

  @override
  String rankedTerms(String seconds) {
    return '$seconds detik · berperingkat';
  }

  @override
  String get practiceTerms => 'Latihan — tanpa peringkat, tanpa lawan';

  @override
  String get practiceComplete => 'LATIHAN SELESAI';

  @override
  String get noRankYet => 'Belum ada peringkat';

  @override
  String placementsForFirstTier(String count) {
    return 'Selesaikan $count duel penempatan untuk meraih peringkat pertamamu.';
  }

  @override
  String get startPlacements => 'Mulai penempatan';

  @override
  String get unranked => 'Tanpa peringkat';

  @override
  String placementsTerms(String done, String total, String seconds) {
    return '$done dari $total · $seconds detik tiap duel';
  }

  @override
  String placementsLeft(String done, String total, String left) {
    return '$done dari $total · $left lagi untuk peringkatmu';
  }

  @override
  String placementsForTier(String count) {
    return 'Selesaikan $count duel penempatan untuk melihat peringkatmu.';
  }

  @override
  String placementsDoneCount(String done, String total) {
    return '$done dari $total penempatan selesai';
  }

  @override
  String get practiceFirst => 'Latihan dulu';

  @override
  String get nextPlacement => 'Penempatan berikutnya';

  @override
  String get noConnection => 'Tidak ada koneksi';

  @override
  String get practiceOffline => 'Latihan offline';

  @override
  String get retry => 'Coba lagi';

  @override
  String get youWonPlain => 'Kamu menang';

  @override
  String get cameraNeededTitle => 'Butuh akses kamera';

  @override
  String get cameraNeededBody =>
      'outrepd menghitung repetisi dengan melihat gerak tubuhmu. Deteksi berjalan di perangkatmu dan tidak ada yang diunggah.';

  @override
  String get openSettings => 'Buka pengaturan';

  @override
  String get allowCamera => 'Izinkan kamera';

  @override
  String get notNow => 'Nanti saja';

  @override
  String get noCameraTitle => 'Kamera tidak ditemukan';

  @override
  String get noCameraBody =>
      'Repetisi dihitung lewat kamera, jadi perangkat ini tidak bisa menilai duel. Sisanya tetap berjalan.';

  @override
  String get noConnectionBody =>
      'Kamu butuh koneksi untuk berduel. Latihan tetap jalan offline dan repetisimu akan tersinkron nanti.';

  @override
  String get getBackInFrame => 'Kembali ke dalam bingkai';

  @override
  String get clockStillRunning =>
      'Waktu terus berjalan. Repetisi tidak dihitung.';

  @override
  String get giveUp => 'Menyerah';

  @override
  String get lpMovesWithGap =>
      'LP bergerak sesuai selisih repetisi — menang lebih banyak, dapat lebih banyak';

  @override
  String get searchingForOpponent => 'Mencari lawan';

  @override
  String get getIntoPosition => 'Ambil posisi';

  @override
  String get framingHint => 'Pergelangan tangan dan kaki harus terlihat';

  @override
  String get goUp => 'Naik';

  @override
  String get goDown => 'Turun';

  @override
  String get bestSet => 'Set terbaik';

  @override
  String get record => 'Rekor';

  @override
  String get last7Days => '7 hari terakhir';

  @override
  String repsCount(String count) {
    return '$count repetisi';
  }

  @override
  String get viewAll => 'Lihat semua';

  @override
  String get shareProfile => 'Bagikan profil';

  @override
  String get share => 'Bagikan';

  @override
  String get duelMeOnOutrepd => 'Tantang aku di outrepd';

  @override
  String get shareStory => 'Story';

  @override
  String get sharePost => 'Postingan';

  @override
  String get copyLink => 'Salin';

  @override
  String get linkCopied => 'Tautan disalin';

  @override
  String get currentRankLabel => 'Peringkat saat ini';

  @override
  String get winInitial => 'M';

  @override
  String get lossInitial => 'K';

  @override
  String get dayInitial => 'h';

  @override
  String rankPosition(String n) {
    return '#$n';
  }

  @override
  String get obTagline =>
      'Duel push-up. Ponselmu yang menghitung. Ada orang lain yang juga menghitung.';

  @override
  String get obGetStarted => 'Mulai';

  @override
  String get obHaveAccount => 'Saya sudah punya akun';

  @override
  String get obTwoThings => 'Dua hal singkat.';

  @override
  String get obAgeQuestion => 'Berapa umurmu?';

  @override
  String get obUnder16 => 'Di bawah 16';

  @override
  String get obOver16 => '16 atau lebih';

  @override
  String get obHealthConsent =>
      'Saya paham outrepd menghitung repetisi dan tidak memberi saran medis atau latihan. Saya akan berhenti kalau ada yang sakit.';

  @override
  String get obTermsIntro => 'Dengan melanjutkan kamu menyetujui';

  @override
  String get obTerms => 'Ketentuan';

  @override
  String get obAnd => 'dan';

  @override
  String get obPrivacy => 'Kebijakan Privasi';

  @override
  String get obUnder16Blocked =>
      'outrepd untuk usia 16 ke atas. Datang lagi kalau sudah sampai — push-up-nya tidak ke mana-mana.';

  @override
  String get obCameraTitle => 'outrepd butuh kameramu';

  @override
  String get obCameraBody =>
      'Kamera membaca gerak tubuhmu untuk menghitung. Tidak ada cara lain.';

  @override
  String get obCameraPrivateTitle => 'Tidak ada yang keluar dari ponselmu';

  @override
  String get obCameraPrivateBody =>
      'Pelacakan tubuh berjalan di perangkat ini. Tidak ada video yang disimpan atau diunggah.';

  @override
  String get obWhyNeeded => 'Kenapa ini diperlukan?';

  @override
  String get obPlacementTitle => 'Taruh ponsel di lantai';

  @override
  String get obPlacementBody =>
      'Sandarkan ke dinding sekitar satu meter di depanmu.';

  @override
  String get obOneMetre => '~1 m';

  @override
  String get obFullBody => 'seluruh badan masuk frame';

  @override
  String get obCheckHandsFeet => 'Tangan dan kaki terlihat';

  @override
  String get obCheckFacing => 'Menghadap ponsel, bukan menyamping';

  @override
  String get obCheckLight => 'Lampu ruangan menyala';

  @override
  String get obImSetUp => 'Sudah siap';

  @override
  String get obFramingTitle => 'Ambil posisi push-up';

  @override
  String get obFramingShoulders => 'Bahu dan pinggul';

  @override
  String get obFramingWrists => 'Pergelangan tangan';

  @override
  String get obFramingAnkles => 'Pergelangan kaki';

  @override
  String get obLooksGood => 'Sudah bagus';

  @override
  String get obCalibrating => 'Mengkalibrasi';

  @override
  String get obOneMoreRep => 'Satu lagi untuk mengenali jangkauanmu';

  @override
  String get obCalibrationHint =>
      'Lakukan tiga push-up dengan kedalaman normalmu';

  @override
  String get obCalibrated => 'Terkalibrasi.';

  @override
  String get obCalibratedBody =>
      'Sekarang outrepd tahu jangkauanmu. Kedalaman diukur terhadap dirimu, bukan angka tetap.';

  @override
  String get obRepsCounted => 'Repetisi terhitung';

  @override
  String get obAverageDepth => 'Kedalaman rata-rata';

  @override
  String get obForm => 'Bentuk gerakan';

  @override
  String get obFormClean => 'Bersih';

  @override
  String get obAvailable => 'Tersedia';

  @override
  String get obTaken => 'Sudah dipakai';

  @override
  String get obGotIt => 'Mengerti';

  @override
  String get obFormMixed => 'Campur';

  @override
  String get justNow => 'Baru saja';

  @override
  String get counterAccuracy => 'Akurasi penghitung';

  @override
  String get counterAccuracyCaption => 'Seberapa tepat kamera';

  @override
  String measuredOverSets(String count) {
    return 'Diukur dari $count set';
  }

  @override
  String get accExact => 'Tepat';

  @override
  String get accWithinOne => '±1 repetisi';

  @override
  String get accAverageMiss => 'Selisih rata-rata';

  @override
  String get accTendsTo => 'Cenderung';

  @override
  String get accCountsHigh => 'menghitung lebih';

  @override
  String get accCountsLow => 'menghitung kurang';

  @override
  String get accCountsEven => 'tidak lebih, tidak kurang';

  @override
  String get accWorstMiss => 'Selisih terbesar';

  @override
  String get accNothingYet => 'Belum ada yang diukur';

  @override
  String get accNothingYetBody =>
      'Setiap kali kamu mengonfirmasi hitungan setelah duel, set itu dibandingkan dengan angka yang kamu sebut. Hasilnya muncul di sini.';

  @override
  String accNeedMore(String count) {
    return 'Masih awal. Sekitar $count set lagi sebelum angka ini berarti.';
  }

  @override
  String get accRecentSets => 'Set terbaru';

  @override
  String get accCameraSaid => 'Kamera';

  @override
  String get accYouSaid => 'Kamu';

  @override
  String get accHowItWorks =>
      'Ini datang dari kamu, di ponsel ini. Tidak ada yang dikirim ke mana pun.';

  @override
  String levelNumber(String n) {
    return 'Level $n';
  }

  @override
  String get youLostPlain => 'Kamu kalah';

  @override
  String get rematch => 'Tanding ulang';

  @override
  String get shareAction => 'Bagikan';

  @override
  String get doneAction => 'Selesai';

  @override
  String get continueAction => 'Lanjut';

  @override
  String get promotedLabel => 'Naik tingkat';

  @override
  String get highestReached => 'Tertinggi yang pernah kamu capai';

  @override
  String repsOff(String n) {
    return 'Selisih $n repetisi.';
  }

  @override
  String get closestYet => 'Duel terketat sejauh ini.';

  @override
  String repsAhead(String n) {
    return 'Unggul $n repetisi.';
  }

  @override
  String get winnerLabel => 'Pemenang';

  @override
  String get newPersonalBest => 'Rekor pribadi baru';

  @override
  String get cantReachServer =>
      'Tidak dapat terhubung ke server. Periksa koneksimu dan coba lagi.';

  @override
  String pushUpsInSeconds(String seconds) {
    return 'Push-up dalam $seconds detik';
  }

  @override
  String beatOpponent(String name, String score) {
    return 'Mengalahkan $name $score';
  }

  @override
  String lostToOpponent(String name, String score) {
    return 'Kalah dari $name $score';
  }

  @override
  String get thinkYouCanBeatMe => 'Yakin bisa mengalahkanku?';

  @override
  String get usernameNotAllowed => 'Nama itu tidak diizinkan. Coba yang lain.';

  @override
  String get yourBest => 'Rekormu';

  @override
  String get theClock => 'Waktu';

  @override
  String get nobodyFreeRaceBest =>
      'Belum ada yang tersedia di dekat peringkatmu. Lawan rekormu sendiri. Ronde ini tidak mengubah peringkatmu.';

  @override
  String get nobodyFreeFirstScore =>
      'Belum ada yang tersedia di dekat peringkatmu. Cetak skor pertamamu. Ronde ini tidak mengubah peringkatmu.';

  @override
  String bestStillIs(String count) {
    return 'Rekormu masih $count';
  }

  @override
  String get setInPoolTitle => 'Set-mu sudah masuk antrean';

  @override
  String get setInPoolBody =>
      'Atlet berikutnya di dekat peringkatmu akan melawannya. Kamu akan melihat siapa yang menang di Notifikasi, dan peringkatmu berubah saat itu.';

  @override
  String get obWhyNeededBody =>
      'Setiap repetisi dinilai dari seberapa jauh bahumu turun dan naik, dan hanya kamera yang bisa melihatnya. Tanpa kamera tidak ada hitungan, dan tanpa hitungan tidak ada duel. Kamera hanya menyala saat satu set berlangsung.';

  @override
  String get obWelcomeBack => 'Selamat datang kembali';

  @override
  String obTitlesHeading(String count) {
    return '$count gelar untuk diraih';
  }

  @override
  String get obTitlesBody =>
      'Untuk kemenangan, beruntun, set bersih, pagi buta, dan lainnya. Pakai satu di bawah namamu.';

  @override
  String get obFriendsHeading => 'Selesaikan dengan teman';

  @override
  String get obFriendsBody =>
      'Teman menambahkanmu dengan kode ini. Tantang mereka kapan saja, dan skor di antara kalian tersimpan.';

  @override
  String get obLetsGo => 'Ayo mulai';

  @override
  String get paywallTitle => 'Naik dari Besi ke Master';

  @override
  String get paywallPerkDuels => 'Duel yang dinilai kamera';

  @override
  String get paywallPerkLadder => 'Peringkat langsung';

  @override
  String get paywallPerkFriends => 'Teman dan tantangan';

  @override
  String get paywallPerkHistory => 'Setiap repetisi di setiap pertandingan';

  @override
  String get paywallYearly => 'Tahunan';

  @override
  String get paywallWeekly => 'Mingguan';

  @override
  String paywallPerWeek(String price) {
    return '${price}/minggu';
  }

  @override
  String get paywallEveryWeek => 'per minggu';

  @override
  String paywallSave(String percent) {
    return 'Hemat ${percent}%';
  }

  @override
  String get paywallStart => 'Mulai mendaki';

  @override
  String get paywallRenewsPlay => 'Diperpanjang otomatis sampai kamu membatalkan. Batalkan kapan saja di Google Play.';

  @override
  String get paywallRenewsApple => 'Diperpanjang otomatis sampai kamu membatalkan. Batalkan kapan saja di pengaturan akun Apple-mu.';

  @override
  String get paywallRestore => 'Pulihkan';

  @override
  String get paywallTerms => 'Ketentuan';

  @override
  String get paywallPrivacy => 'Privasi';

  @override
  String get paywallLoadFailed => 'Paket tidak dapat dimuat. Periksa koneksimu dan coba lagi.';

  @override
  String get paywallBuyFailed => 'Pembelian tidak berhasil. Coba lagi.';

  @override
  String get paywallPending => 'Pembayaranmu masih diproses. Semuanya terbuka begitu toko mengonfirmasinya.';

  @override
  String get paywallNothingToRestore => 'Tidak ada langganan yang bisa dipulihkan.';

  @override
  String get paywallRestored => 'Langganan dipulihkan';

  @override
  String paywallSignedInAs(String email) {
    return 'Masuk sebagai ${email}';
  }

  @override
  String get deleteKeepsSubscription => 'Menghapus akun tidak membatalkan langgananmu — yang menagih adalah toko, bukan outrepd. Batalkan dulu di Google Play atau di pengaturan akun Apple-mu.';

  @override
  String get signOut => 'Keluar';

  @override
  String get signOutQuestion => 'Keluar dari akun?';

  @override
  String get signOutBody => 'Akunmu tetap seperti sekarang, dengan peringkat, riwayat, dan langganannya. Masuk lagi kapan saja dengan emailmu.';

  @override
  String get shareVictory => 'MENANG';

  @override
  String get shareRematch => 'TANDING ULANG?';

  @override
  String friendCodeInvite(String code) {
    return 'Tantang aku di outrepd. Tambahkan aku dengan kode temanku ${code}\nhttps://outrepd.com';
  }

  @override
  String get soundsLabel => 'Suara';

  @override
  String get soundsHint => 'Bunyi bip untuk 3, 2, 1, tik untuk tiap repetisi, dan akhir ronde. Diputar di atas musikmu.';

  @override
  String get phoneSection => 'Di ponsel ini';

  @override
  String get allowNotifications => 'Izinkan notifikasi';

  @override
  String get allowNotificationsHint => 'Notifikasi OUTREPD mati di pengaturan ponselmu, jadi tidak ada yang di bawah ini bisa sampai.';

  @override
  String get remindersSection => 'Pengingat';

  @override
  String get dailyReminder => 'Pengingat harian';

  @override
  String get dailyReminderHint => 'Hanya di hari kamu belum latihan.';

  @override
  String get reminderTime => 'Waktu';

  @override
  String get reminderTitle => 'Waktunya push-up hari ini';

  @override
  String get reminderBody => 'Satu set singkat dihitung untuk streak-mu.';

  @override
  String reminderStreakBody(String count) {
    return 'Pertahankan streak ${count} harimu. Satu set sudah cukup.';
  }

  @override
  String get channelMatches => 'Pertandingan dan teman';

  @override
  String get channelReminders => 'Pengingat harian';

  @override
  String get liveTag => 'Langsung';

  @override
  String get reconnecting => 'Menyambung ulang';

  @override
  String get rankedLive => 'Peringkat · langsung';

  @override
  String get lookingForLive => 'Mencari lawan langsung';

  @override
  String ofTime(String time) {
    return 'dari ${time}';
  }

  @override
  String liveFallbackAt(String time) {
    return 'Di ${time} kamu akan melawan set yang tersimpan';
  }

  @override
  String liveFoundBody(String name) {
    return '${name} sedang di depan kamera. Waktu sama, mulai bersamaan.';
  }

  @override
  String get nobodyLiveTitle => 'Belum ada yang langsung sekarang';

  @override
  String get nobodyLiveBody => 'Kamu akan melawan set yang tersimpan';

  @override
  String didRepsIn(String reps) {
    return 'Melakukan ${reps} dalam 60 detik';
  }

  @override
  String get sameRankPoints => 'Poin peringkat sama dengan pertandingan langsung';

  @override
  String get raceIt => 'Lawan';

  @override
  String get sendASet => 'Kirim set';

  @override
  String get onlineNow => 'Sedang online';

  @override
  String get liveOrSetHint => 'Langsung butuh mereka online. Set akan menunggu sampai mereka melawannya.';

  @override
  String get friendlyNoRank => 'Persahabatan · tanpa peringkat';

  @override
  String waitingForName(String name) {
    return 'Menunggu ${name}';
  }

  @override
  String get weSentThemANotice => 'Kami sudah mengirim notifikasi';

  @override
  String get untilInviteRunsOut => 'sampai undangan habis';

  @override
  String get cancelInvite => 'Batalkan undangan';

  @override
  String inviteDeclined(String name) {
    return '${name} bilang tidak sekarang';
  }

  @override
  String get inviteRanOut => 'Undangan sudah habis';

  @override
  String get inviteAgain => 'Undang lagi';

  @override
  String liveInviteFrom(String name) {
    return '${name} sedang langsung';
  }

  @override
  String timeLeft(String time) {
    return 'Sisa ${time}';
  }

  @override
  String get joinLive => 'Gabung';

  @override
  String get nLiveTitle => 'Undangan langsung';

  @override
  String nLiveBody(String name) {
    return '${name} ingin bertanding langsung';
  }

  @override
  String get inviteGone => 'Undangan itu sudah habis';

  @override
  String opponentDropped(String name) {
    return 'Koneksi ${name} terputus. Terus lanjut: ronde selesai saat waktu habis.';
  }

  @override
  String opponentGaveUp(String name) {
    return '${name} menyerah. Selesaikan ronde untuk menang.';
  }

  @override
  String get calledOffTitle => 'Pertandingan dibatalkan';

  @override
  String calledOffBody(String name) {
    return '${name} tidak bersiap di posisi tepat waktu. Tidak ada yang dicatat.';
  }

  @override
  String waitingForFinal(String name) {
    return 'Menunggu hitungan akhir ${name}…';
  }

  @override
  String get wantsToBeFriends => 'ingin berteman';

  @override
  String get giveUpQuestion => 'Menyerah di ronde ini?';

  @override
  String get giveUpBody => 'Ini dihitung kalah, berapa pun hitunganmu sekarang.';

  @override
  String waitingToJoin(String name) {
    return 'Menunggu ${name} bergabung';
  }

  @override
  String get removeFriend => 'Hapus teman';

  @override
  String get removeFriendBody => 'Dia tidak diberi tahu, dan kalian bisa saling menambahkan lagi';

  @override
  String removeFriendQuestion(String username) {
    return 'Hapus ${username} dari temanmu?';
  }

  @override
  String get removeAction => 'Hapus';

  @override
  String removedFriend(String username) {
    return '${username} dihapus dari temanmu';
  }

  @override
  String get noticeChallenged => 'Seseorang menantangku tanding ulang';

  @override
  String get noticeLiveInvite => 'Teman mengajakku bertanding langsung';

  @override
  String trialHeadline(String days) {
    return '${days} hari pertamamu *gratis*';
  }

  @override
  String get trialToday => 'Hari ini';

  @override
  String get trialTodayBody => 'Semua duel, langsung dan peringkat, terbuka.';

  @override
  String trialDay(String day) {
    return 'Hari ${day}';
  }

  @override
  String get trialReminderBody => 'Kami ingatkan sehari sebelum masa cobamu berakhir.';

  @override
  String get trialEndBody => 'Paketmu dimulai. Batalkan sebelumnya dan kamu tidak membayar apa pun.';

  @override
  String trialTag(String days) {
    return 'Gratis ${days} hari';
  }

  @override
  String trialCta(String days) {
    return 'Mulai uji coba gratis ${days} hari';
  }

  @override
  String trialThenYearly(String price) {
    return 'Tanpa bayar sekarang · lalu ${price}/tahun';
  }

  @override
  String trialThenWeekly(String price) {
    return 'Tanpa bayar sekarang · lalu ${price}/minggu';
  }

  @override
  String get trialEndsTitle => 'Uji coba gratismu berakhir besok';

  @override
  String get trialEndsBody => 'Terus naik, atau batalkan sebelumnya di pengaturan langganan.';

  @override
  String get obIdeaTitle => '60 detik. Satu lawan.';

  @override
  String get obIdeaRival => 'Orang sungguhan, secara langsung atau set rekamannya';

  @override
  String get obIdeaCamera => 'Kameramu menghitung setiap repetisi, di ponselmu';
}
