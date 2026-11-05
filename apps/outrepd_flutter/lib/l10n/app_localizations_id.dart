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
  String get incDuels => 'Riwayat duel dan perubahan rating';

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
  String get createAccountBody => 'Masuk supaya akun ini tidak bergantung pada satu ponsel saja.';

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
  String get removePhoto => 'Hapus foto';

  @override
  String get removePhotoTitle => 'Hapus fotomu?';

  @override
  String get removePhotoBody =>
      'Lifter-mu akan tampil sebagai gantinya, di mana pun. Kamu bisa menambahkan foto baru kapan saja.';

  @override
  String get removePhotoConfirm => 'Hapus';

  @override
  String get couldNotRemovePhoto => 'Fotomu tidak bisa dihapus. Coba lagi.';

  @override
  String get cropPhoto => 'Pangkas';

  @override
  String get proGoTitle => 'Jadi Pro.';

  @override
  String get proOnboardTitle => 'Lifter-mu, Pro.';

  @override
  String get proSubtitle => 'Tanpa iklan, dan tampilan yang tidak ada di aplikasi gratis.';

  @override
  String get proFree => 'GRATIS';

  @override
  String get proYoursNow => 'MILIKMU KINI';

  @override
  String get proPerkNoAds => 'Tanpa iklan. Selamanya.';

  @override
  String get proPerkNoAdsBody => 'Setiap pertandingan, setiap level, tanpa jeda.';

  @override
  String get proPerkBoard => 'Bersinar di setiap papan';

  @override
  String get proPerkBoardBody => 'Baris holo, dengan lifter-mu keluar darinya.';

  @override
  String get proPerkEntrance => 'Masuk dengan petir';

  @override
  String get proPerkEntranceBody => 'Di layar VS sebelum setiap pertandingan live.';

  @override
  String get proPerkCovers => '13 sampul bergerak';

  @override
  String get proPerkCoversBody => 'Atau fotomu sendiri, di atas profilmu.';

  @override
  String get proPerkItems => '20 item khusus Pro';

  @override
  String get proPerkItemsBody => 'Kulit, atasan, perlengkapan, dan lifter yang berkedip.';

  @override
  String get proGo => 'Jadi Pro';

  @override
  String proBuyYearly(String price) {
    return 'Jadi Pro · ${price}/tahun';
  }

  @override
  String proBuyWeekly(String price) {
    return 'Jadi Pro · ${price}/minggu';
  }

  @override
  String get proSettingsBody => 'Tanpa iklan, dan tampilan Pro.';

  @override
  String get proSettingsActive => 'Kamu Pro. Terima kasih atas dukunganmu.';

  @override
  String get lifterMakerTitle => 'Sesuaikan avatarmu';

  @override
  String get lifterMakerFirst => 'Sesuaikan avatarmu';

  @override
  String get lifterMakerFirstBody => 'Inilah kamu di setiap papan dan setiap pertandingan.';

  @override
  String get lifterTabSkin => 'Kulit';

  @override
  String get lifterTabHair => 'Rambut';

  @override
  String get lifterTabFace => 'Wajah';

  @override
  String get lifterTabBeard => 'Jenggot';

  @override
  String get lifterTabTop => 'Atasan';

  @override
  String get lifterTabGear => 'Perlengkapan';

  @override
  String get lifterTabBackground => 'Latar';

  @override
  String get lifterTabCharacters => 'Karakter';

  @override
  String get lifterEyes => 'Mata';

  @override
  String get lifterBrows => 'Alis';

  @override
  String get lifterMouth => 'Mulut';

  @override
  String get lifterMarks => 'Tanda';

  @override
  String get lifterRandom => 'Acak';

  @override
  String get lifterTryingPro => 'Tampilan Pro.';

  @override
  String get lifterUnlockPro => 'Buka dengan Pro';

  @override
  String get editLifter => 'Ubah lifter-mu';

  @override
  String lifterNeedsWorld(String world) {
    return 'Selesaikan ${world}';
  }

  @override
  String lifterNeedsTier(String tier) {
    return 'Capai ${tier}';
  }

  @override
  String lifterNeedsLevel(String level) {
    return 'Capai level ${level}';
  }

  @override
  String lifterNeedsWins(String count) {
    return 'Menangkan ${count} pertandingan';
  }

  @override
  String lifterNeedsWinStreak(String count) {
    return 'Menang ${count} kali beruntun';
  }

  @override
  String lifterNeedsDayStreak(String count) {
    return 'Latihan ${count} hari beruntun';
  }

  @override
  String get lifterNeedsMonthTop10 => 'Akhiri sebulan di 10 besar';

  @override
  String get lifterNeedsMonthPodium => 'Akhiri sebulan di 3 besar';

  @override
  String get lifterNeedsMonthChampion => 'Juarai satu bulan';

  @override
  String lifterNeedsStars(String count) {
    return '3 bintang di ${count} level Petualangan';
  }

  @override
  String get lifterNeedsAllStars => 'Semua bintang di Petualangan';

  @override
  String get coverTitle => 'Sampul';

  @override
  String get coverPhoto => 'Fotomu';

  @override
  String get coverNone => 'Tanpa sampul';

  @override
  String get coverUse => 'Pakai sampul ini';

  @override
  String get coverProLine => 'Sampul khusus Pro. Sampulnya bergerak, dan semua orang yang membuka profilmu melihatnya.';

  @override
  String get coverCouldNotUpload => 'Fotomu tidak bisa diunggah. Coba lagi.';

  @override
  String get coverNeonCity => 'Kota neon';

  @override
  String get coverIronGym => 'Gym besi';

  @override
  String get coverRooftopSunset => 'Senja di atap';

  @override
  String get coverStadiumLights => 'Lampu stadion';

  @override
  String get coverSilverPeaks => 'Puncak perak';

  @override
  String get coverBronzeDunes => 'Bukit pasir perunggu';

  @override
  String get coverVolcano => 'Gunung berapi';

  @override
  String get coverPalmBeach => 'Pantai palem';

  @override
  String get coverWinterCity => 'Kota musim dingin';

  @override
  String get coverFireworks => 'Kembang api';

  @override
  String get coverFightNight => 'Malam pertarungan';

  @override
  String get coverOrbit => 'Orbit';

  @override
  String get coverChampionPodium => 'Podium juara';

  @override
  String get vsLiveRanked => 'LIVE · PERINGKAT';

  @override
  String get vsLiveFriendly => 'LIVE · PERSAHABATAN';

  @override
  String get vsSavedRanked => 'SET TERSIMPAN · PERINGKAT';

  @override
  String get vsRematchFriendly => 'TANDING ULANG · PERSAHABATAN';

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
  String get usernameAlreadyChangedBody => 'Nama pengguna bisa diubah sekali setiap 14 hari.';

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
  String get forfeitRematchBody => 'Ini dihitung sebagai kekalahan.';

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
    return '${n} minggu lalu';
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
  String get noRanksYet => 'Belum ada peringkat';

  @override
  String get noRanksYetBody => 'Main duel dan papan akan terisi.';

  @override
  String get ranksTitle => 'Peringkat';

  @override
  String get totalReps => 'Total repetisi';

  @override
  String get recent => 'Terbaru';

  @override
  String wonVs(String name) {
    return 'Menang lawan ${name}';
  }

  @override
  String lostVs(String name) {
    return 'Kalah dari ${name}';
  }

  @override
  String hoursAgo(String n) {
    return '${n} jam lalu';
  }

  @override
  String toNextTier(String n, String tier) {
    return '${n} lagi ke ${tier}';
  }

  @override
  String get noMatchesYet => 'Belum ada duel';

  @override
  String get noMatchesYetBody => 'Duel pertamamu muncul di sini, menang atau kalah.';

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
  String get yourRank => 'Peringkatmu';

  @override
  String get whoIsNext => 'Siapa berikutnya?';

  @override
  String get opponentFound => 'Lawan ditemukan';

  @override
  String get obSevenTiers => 'Tujuh tingkat';

  @override
  String get obRatingPerMatch => 'Poin per pertandingan';

  @override
  String get obWinLabel => 'Menang';

  @override
  String get obLossLabel => 'Kalah';

  @override
  String get obFloorLabel => 'Batas bawah';

  @override
  String obWinRating(String n) {
    return '+${n} + selisih';
  }

  @override
  String obLossRating(String n) {
    return '−${n} − selisih';
  }

  @override
  String obNeverBelow(String n) {
    return 'tak pernah di bawah ${n}';
  }

  @override
  String obDivisionLine(String division, String tier) {
    return 'Setiap ${division} poin satu anak tangga, ${tier} satu tingkat.';
  }

  @override
  String ratingFloor(String n) {
    return 'Rating-mu tidak pernah turun di bawah ${n}.';
  }

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
  String get unranked => 'Tanpa peringkat';

  @override
  String get practiceFirst => 'Latihan dulu';

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
  String get noConnectionBody => 'Kamu butuh koneksi untuk berduel. Petualangan tetap jalan offline dan repetisimu akan tersinkron nanti.';

  @override
  String get getBackInFrame => 'Kembali ke dalam bingkai';

  @override
  String get clockStillRunning =>
      'Waktu terus berjalan. Repetisi tidak dihitung.';

  @override
  String get giveUp => 'Menyerah';

  @override
  String get lpMovesWithGap => 'Menang: +25 ditambah selisih repetisi. Kalah: −20 ditambah selisihnya.';

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
  String get obCheckHandsFeet => 'Kepala, bahu, dan tangan masuk frame';

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
      'Setiap kali kamu mengonfirmasi hitungan setelah set latihan, set itu diukur dengan angka yang kamu sebutkan. Hasilnya muncul di sini.';

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
      'Setiap repetisi dinilai dari seberapa rendah kamu turun dan seberapa tinggi kamu naik lagi, dan hanya kamera yang bisa melihatnya. Tanpa kamera tidak ada hitungan, dan tanpa hitungan tidak ada duel. Kamera hanya menyala selama set.';

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
  String get signOutBody => 'Akunmu tetap seperti sekarang, dengan peringkat, riwayat, dan langganannya. Masuk lagi kapan saja dengan cara yang sama.';

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
  String get dailyReminderHint => 'Hanya di hari target kamu belum tercapai.';

  @override
  String get reminderTime => 'Waktu';

  @override
  String get reminderTitle => 'Waktunya push-up hari ini';

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
  String get onlineNow => 'Sedang online';

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
    return '${name} tidak sampai ke awal pertandingan. Tidak ada yang dicatat.';
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
  String get obIdeaTitle => '60 detik. Satu lawan.';

  @override
  String get obIdeaRival => 'Orang sungguhan, secara langsung atau set rekamannya';

  @override
  String get obIdeaCamera => 'Kameramu menghitung setiap repetisi, di ponselmu';

  @override
  String get thisMonth => 'Bulan Ini';

  @override
  String shortDays(String n) {
    return '${n} hr';
  }

  @override
  String shortHours(String n) {
    return '${n} j';
  }

  @override
  String get awardChampion => 'Juara';

  @override
  String get awardPodium => 'Podium';

  @override
  String get awardTop10 => '10 Besar';

  @override
  String get awardRegular => 'Klub 20';

  @override
  String monthToTop10(String lp) {
    return '${lp} poin lagi ke 10 besar';
  }

  @override
  String monthIfEndedNow(String award) {
    return '${award} jika bulan berakhir sekarang';
  }

  @override
  String get monthJoinHint => 'Main duel berperingkat untuk masuk papan bulan ini';

  @override
  String monthRegularProgress(String progress) {
    return 'Lencana Klub 20 · ${progress} duel berperingkat';
  }

  @override
  String get monthRegularEarned => 'Lencana Klub 20 bulan ini sudah didapat';

  @override
  String get monthEmptyTitle => 'Bulan yang baru';

  @override
  String get monthEmptyBody => 'Belum ada yang mencetak poin bulan ini. Menangkan duel berperingkat pertama dan kamu memimpin.';

  @override
  String get weekEmptyTitle => 'Minggu yang baru';

  @override
  String get weekEmptyBody => 'Belum ada yang mencetak poin minggu ini. Menangkan duel berperingkat pertama dan kamu memimpin.';

  @override
  String get ratingUnit => 'rating';

  @override
  String get ptsUnit => 'poin';

  @override
  String ptsAmount(String n) {
    return '${n} poin';
  }

  @override
  String ratingAmount(String n) {
    return '${n} rating';
  }

  @override
  String ratingForWin(String n) {
    return '${n} untuk kemenangan';
  }

  @override
  String ratingForLoss(String n) {
    return '${n} untuk kekalahan';
  }

  @override
  String ratingForReps(String n) {
    return '${n} untuk repetisi';
  }

  @override
  String get boardThisWeek => 'Minggu ini';

  @override
  String get boardOverall => 'Keseluruhan';

  @override
  String get howPointsWork => 'Cara poin dihitung';

  @override
  String streakNextTen(String n) {
    return '${n} kemenangan beruntun: kemenangan berikutnya +10';
  }

  @override
  String get boardRuleWin => 'Menang +5';

  @override
  String get boardRuleLoss => 'Kalah −2';

  @override
  String get boardRuleStreak => '3 menang beruntun: +10';

  @override
  String rankNext(String rank) {
    return 'Berikutnya: ${rank}';
  }

  @override
  String rankAt(String n) {
    return 'di ${n}';
  }

  @override
  String toGo(String n) {
    return '${n} lagi';
  }

  @override
  String tierStartsAt(String tier, String n) {
    return '${tier} mulai di ${n}';
  }

  @override
  String rankedDuelsCount(String n) {
    return '${n} duel berperingkat';
  }

  @override
  String get monthlyAwards => 'Penghargaan bulanan';

  @override
  String get seasonOver => 'Musim berakhir';

  @override
  String get seasonOverBody => 'Sekarang sudah ada di profilmu. Bulan baru mulai dari nol.';

  @override
  String get seasonPlayCta => 'Main bulan baru';

  @override
  String monthWinners(String month) {
    return 'Pemenang ${month}';
  }

  @override
  String get playShort => 'Main';

  @override
  String get rematchLive => 'Tanding ulang langsung';

  @override
  String rematchWaiting(String name) {
    return 'Menunggu ${name}';
  }

  @override
  String rematchAsked(String name) {
    return '${name} mau tanding ulang';
  }

  @override
  String get rematchGone => 'Tidak ada tanding ulang kali ini';

  @override
  String get twoRankedADay => 'Persahabatan · 2 berperingkat per hari dengan lawan yang sama';

  @override
  String monthMove(String move) {
    return 'Bulan ini · ${move}';
  }

  @override
  String promotedFrom(String rank) {
    return 'dari ${rank}';
  }

  @override
  String liveOnlineNow(String n) {
    return '${n} online sekarang';
  }

  @override
  String liveSearchingNow(String n) {
    return '${n} mencari';
  }

  @override
  String get dailyGoalTitle => 'Target hari ini';

  @override
  String get dailyGoalDone => 'Selesai untuk hari ini';

  @override
  String dailyGoalProgress(String progress) {
    return '${progress} push-up';
  }

  @override
  String dailyGoalLeft(String n) {
    return '${n} lagi';
  }

  @override
  String get dailyGoalChange => 'Ubah';

  @override
  String get dailyGoalPick => 'Target harianmu';

  @override
  String dailyGoalOption(String n) {
    return '${n} push-up sehari';
  }

  @override
  String widgetGoalOf(String goal) {
    return 'dari ${goal} hari ini';
  }

  @override
  String get saveToAppleHealth => 'Simpan latihan ke Apple Health';

  @override
  String get saveToHealthConnect => 'Simpan latihan ke Health Connect';

  @override
  String get saveToHealthHint => 'Setiap set ditambahkan sebagai latihan kekuatan. Tidak ada yang dibaca.';

  @override
  String get healthNotAllowed => 'Belum diizinkan. Kamu bisa mengizinkannya di pengaturan kesehatan ponsel.';

  @override
  String reminderLeft(String count) {
    return '${count} push-up lagi untuk target hari ini.';
  }

  @override
  String get liveInviteHint => 'Teman yang online bisa langsung bergabung. Yang lain mendapat notifikasi dan satu menit untuk bergabung.';

  @override
  String get requestSentShort => 'Permintaan terkirim';

  @override
  String healthWorksWith(String health) {
    return 'OUTREPD bekerja dengan ${health}';
  }

  @override
  String healthCardBody(String health) {
    return 'Setiap set yang kamu selesaikan disimpan ke ${health} sebagai latihan kekuatan. OUTREPD tidak pernah membaca data kesehatanmu.';
  }

  @override
  String savedToHealth(String health) {
    return 'Tersimpan di ${health}';
  }

  @override
  String get usernameTooShort => 'Terlalu pendek: minimal 4 karakter';

  @override
  String get usernameBadCharacters => 'Hanya huruf, angka, dan _';

  @override
  String get usernameNeedsLetter => 'Tambahkan setidaknya satu huruf atau angka';

  @override
  String usernameChangeAgainOn(String date) {
    return 'Kamu bisa mengubahnya lagi pada ${date}';
  }

  @override
  String get continueWithApple => 'Lanjutkan dengan Apple';

  @override
  String get continueWithGoogle => 'Lanjutkan dengan Google';

  @override
  String get socialSignInFailed => 'Gagal masuk. Coba lagi.';

  @override
  String get chooseUsernameTitle => 'Pilih nama penggunamu';

  @override
  String get chooseUsernameSubtitle => 'Dengan nama ini orang lain menemukanmu dan melihatmu di papan peringkat.';

  @override
  String get authHeroTitle => 'KALAHKAN SIAPA PUN.';

  @override
  String get authHeroSubtitle => 'Duel push-up langsung, dihitung oleh kameramu.';

  @override
  String get createAccountPitch => 'Peringkat dan duelmu, di ponsel mana pun.';

  @override
  String get usernameSpacesHint => 'Spasi menjadi _';

  @override
  String get emailCodeNote => 'Kami akan mengirim kode 6 digit ke emailmu. Tanpa kata sandi.';

  @override
  String get continueWithEmail => 'Lanjutkan dengan email';

  @override
  String get thisSeason => 'Musim ini';

  @override
  String get thisWeek => 'Minggu ini';

  @override
  String get weekStartsAgain => 'Mulai lagi setiap Senin';

  @override
  String get lengthWeek => 'Minggu';

  @override
  String get lengthMonth => 'Bulan';

  @override
  String get weekJoinHint => 'Menangkan satu duel peringkat minggu ini untuk masuk papan';

  @override
  String get weekInTop3 => 'Di 3 besar minggu ini';

  @override
  String weekToTop3(String n) {
    return '${n} poin lagi ke 3 besar';
  }

  @override
  String get boardActiveNote => 'Pemain yang aktif dalam 30 hari terakhir';

  @override
  String get boardTieNote => 'seri: kemenangan terbanyak di atas';

  @override
  String lpBreakdown(String reps, String adjust, String rank) {
    return '${reps} dari repetisi · ${adjust} untuk lawan ${rank}';
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
    return '${n} XP lagi ke Level ${level}';
  }

  @override
  String xpHow(String rep, String match) {
    return '${rep} XP per repetisi, ${match} per kemenangan, tidak ada untuk kekalahan';
  }

  @override
  String xpGained(String n) {
    return '+${n} XP';
  }

  @override
  String xpForReps(String n) {
    return '${n} dari repetisi';
  }

  @override
  String xpForMatch(String n) {
    return '${n} dari duel';
  }

  @override
  String get levelUp => 'Naik level';

  @override
  String get levelUpBody => 'Setiap repetisi berarti. Terus lanjut.';

  @override
  String giveUpAhead(String n) {
    return 'Kamu unggul ${n}';
  }

  @override
  String giveUpBehind(String n) {
    return 'Kamu tertinggal ${n}';
  }

  @override
  String get giveUpTied => 'Seri';

  @override
  String get keepGoing => 'Lanjut';

  @override
  String get stay => 'Tetap';

  @override
  String lastN(String n) {
    return '${n} terakhir';
  }

  @override
  String get firstMatchForTier => 'Mainkan pertandingan pertamamu untuk masuk peringkat. Semua mulai dari Iron V.';

  @override
  String get firstMatchForBoard => 'Mainkan pertandingan pertamamu untuk masuk papan peringkat. Semua mulai dari Iron V.';

  @override
  String get playFirstMatch => 'Main pertandingan pertama';

  @override
  String firstMatchTerms(String seconds) {
    return 'Satu pertandingan · ${seconds} detik';
  }

  @override
  String get placedLabel => 'Kamu sudah masuk peringkat';

  @override
  String get placedBody => 'Semua mulai dari sini. Hanya kemenangan yang membawamu naik.';

  @override
  String get placedHow => 'Menang: +25 ditambah selisih repetisi. Kalah: −20 ditambah selisihnya.';

  @override
  String get levelBesideName => 'Di samping namamu, di mana saja';

  @override
  String get weekRaceTitle => 'Balapan minggu ini';

  @override
  String get streakDoneToday => 'hari ini beres';

  @override
  String get streakTrainToday => 'latihan hari ini untuk menambah sehari';

  @override
  String get raceChartTitle => 'Jalannya satu menit';

  @override
  String raceYouLead(String time) {
    return '${time} · kamu memimpin';
  }

  @override
  String raceTheyLead(String time, String name) {
    return '${time} · ${name} memimpin';
  }

  @override
  String get bringFriendTitle => 'Ajak teman';

  @override
  String get bringFriendBody => 'Kirim tautanmu. Tautan itu membuka profilmu, tempat mereka bisa menambahkanmu.';

  @override
  String get bringFriendShare => 'Bagikan tautanku';

  @override
  String get bringFriendShareText => 'Tanding push-up denganku di OUTREPD. 60 detik, langsung, dan kamera yang menghitung.';

  @override
  String orFriendCode(String code) {
    return 'atau kode teman ${code}';
  }

  @override
  String get countryPickerTitle => 'Negaramu';

  @override
  String get countrySearch => 'Cari';

  @override
  String get countryFromPhone => 'Dari ponselmu';

  @override
  String get countryAll => 'Semua negara';

  @override
  String get countryChoose => 'Pilih negaramu';

  @override
  String get countryChange => 'Ubah';

  @override
  String get countryForBoard => 'Untuk papan peringkat negaramu';

  @override
  String get countryLabel => 'Negara';

  @override
  String get countryChanged => 'Negara diubah';

  @override
  String get countryEvery14 => 'Sekali setiap 14 hari, seperti namamu';

  @override
  String get countryNotSaved => 'Negaramu tidak bisa disimpan. Coba lagi.';

  @override
  String get adventure => 'Petualangan';

  @override
  String stageNumber(String n) {
    return 'Level ${n}';
  }

  @override
  String adventureLevelIn(String level, String world) {
    return 'Level ${level} · ${world}';
  }

  @override
  String adventureClearedOf(String cleared, String total) {
    return '${cleared} dari ${total} selesai · tanpa peringkat';
  }

  @override
  String get worldIron => 'Tambang Besi';

  @override
  String get worldBronze => 'Bukit Pasir Perunggu';

  @override
  String get worldSilver => 'Puncak Perak';

  @override
  String get worldGold => 'Benteng Emas';

  @override
  String get worldPlatinum => 'Gletser Platina';

  @override
  String get worldDiamond => 'Gua Berlian';

  @override
  String get worldMaster => 'Takhta Master';

  @override
  String worldNumber(String n) {
    return 'Dunia ${n}';
  }

  @override
  String fightLevel(String level) {
    return 'Lawan level ${level}';
  }

  @override
  String levelHpLine(String hp, String reps) {
    return 'HP ${hp} · sekitar ${reps} push-up';
  }

  @override
  String get hpShort => 'HP';

  @override
  String comboTag(String n) {
    return 'KOMBO ×${n}';
  }

  @override
  String get levelCleared => 'SELESAI';

  @override
  String get outOfTime => 'WAKTU HABIS';

  @override
  String get statPushUps => 'push-up';

  @override
  String get statTimeLeft => 'tersisa';

  @override
  String get statHpLeft => 'HP tersisa';

  @override
  String get statXp => 'XP';

  @override
  String secondStarHint(String seconds) {
    return 'Selesaikan dengan sisa ${seconds} detik untuk bintang kedua';
  }

  @override
  String thirdStarHint(String seconds) {
    return 'Selesaikan dengan sisa ${seconds} detik untuk bintang ketiga';
  }

  @override
  String get fightLostHint => 'Ulangi level sebelumnya untuk lebih banyak bintang: bintang membuka senjata yang lebih kuat.';

  @override
  String get nextLevel => 'Level berikutnya';

  @override
  String get tryAgain => 'Coba lagi';

  @override
  String get adventureMap => 'Peta';

  @override
  String get nextKicker => 'BERIKUTNYA';

  @override
  String nextLevelLine(String level, String hp) {
    return 'Level ${level} · HP ${hp}';
  }

  @override
  String get armory => 'Gudang Senjata';

  @override
  String get armoryBody => 'Bintang membuka senjata. Monster di tiap dunia hanya terluka oleh senjata dunia itu atau yang lebih kuat.';

  @override
  String get equipped => 'DIPAKAI';

  @override
  String perPushUp(String damage) {
    return '${damage} per push-up';
  }

  @override
  String damagePerPushUp(String damage) {
    return '${damage} damage per push-up';
  }

  @override
  String wasWith(String damage, String weapon) {
    return 'sebelumnya ${damage} dengan ${weapon}';
  }

  @override
  String moreStars(String count) {
    return '${count} bintang lagi';
  }

  @override
  String get newWeapon => 'Senjata baru';

  @override
  String starsKicker(String count) {
    return '${count} BINTANG';
  }

  @override
  String get weaponGauntlets => 'Sarung Tangan Besi';

  @override
  String get weaponKnuckles => 'Buku Jari Perunggu';

  @override
  String get weaponFang => 'Taring Perak';

  @override
  String get weaponHammer => 'Palu Emas';

  @override
  String get weaponAxe => 'Kapak Platina';

  @override
  String get weaponSpear => 'Tombak Berlian';

  @override
  String get weaponSword => 'Pedang Master';

  @override
  String get weaponCrownbreaker => 'Penghancur Mahkota';

  @override
  String clearFirst(String level) {
    return 'Menangkan level ${level} dulu';
  }

  @override
  String needsWeapon(String weapon) {
    return 'Butuh ${weapon}';
  }

  @override
  String hurtOnlyBy(String weapon) {
    return 'Hanya ${weapon} atau lebih kuat yang bisa melukainya';
  }

  @override
  String worldNeedsWeapon(String world, String weapon, String count) {
    return '${world} butuh ${weapon} · ${count} bintang lagi';
  }

  @override
  String rematchOpponentLeft(String name) {
    return '${name} keluar · tidak ada tanding ulang kali ini';
  }

  @override
  String get obNext => 'Berikutnya';

  @override
  String get obRaceTitle => 'Lawan orang sungguhan.';

  @override
  String get obRaceBody => 'Repetisi terbanyak dalam 60 detik yang menang. Live, di ponsel masing-masing — atau lawan set rekaman saat tidak ada yang online.';

  @override
  String get obRepsTitle => 'Hanya repetisi penuh yang dihitung.';

  @override
  String get obRepsBody => 'Kamera melihat seberapa rendah kamu turun dan seberapa tinggi kamu naik lagi.';

  @override
  String get obRepsDown => 'Turun sampai bar kosong';

  @override
  String get obRepsUp => 'Naik sampai penuh';

  @override
  String get obBarGoingDown => 'Turun';

  @override
  String get obBarComingUp => 'Naik';

  @override
  String get obBarHandOff => 'Tangan lepas dari lantai';

  @override
  String get obRepsBoth => 'Keduanya, dengan tangan di lantai. Setengah repetisi tidak dihitung — di ponselmu maupun ponsel lawan.';

  @override
  String get obClimbTitle => 'Naik sampai Master.';

  @override
  String get obClimbBody => 'Tujuh tingkat, masing-masing lima anak tangga. Menang untuk naik; kalah bisa turun satu tingkat, tapi tidak pernah di bawah 1.000 poin.';

  @override
  String get obGoldLine => 'garis emas';

  @override
  String obCalibrationRule(String gold) {
    return 'Turun melewati ${gold}, lalu naik lagi melewati garis atas';
  }

  @override
  String get proThanks => 'Iklan mati. Terima kasih sudah pakai Pro.';

  @override
  String get adAskTitle => 'Iklan membuat outrepd tetap gratis';

  @override
  String get adAskBody => 'Setelah ini iPhone-mu akan bertanya apakah aplikasi boleh memakai aktivitasmu untuk memilih iklan. Jawab ya, iklannya lebih cocok untukmu; jawab tidak, iklan tetap muncul, hanya kurang relevan.';

  @override
  String get adAskCamera => 'Kameramu tidak pernah terlibat: pelacakan tubuh tetap di ponsel ini, apa pun pilihanmu.';

  @override
  String get monsterIronColossus => 'Kolosus Besi';

  @override
  String get monsterScarab => 'Skarab';

  @override
  String get monsterScarabPharaoh => 'Firaun Skarab';

  @override
  String get monsterYeti => 'Yeti';

  @override
  String get monsterFrostYeti => 'Yeti Beku';

  @override
  String get monsterYetiChieftain => 'Kepala Yeti';

  @override
  String get monsterGoldSoldier => 'Prajurit Emas';

  @override
  String get monsterGoldKnight => 'Ksatria Emas';

  @override
  String get monsterGoldKing => 'Raja Emas';

  @override
  String get monsterWisp => 'Wisp';

  @override
  String get monsterWraith => 'Hantu';

  @override
  String get monsterFrostLich => 'Lich Beku';

  @override
  String get monsterCrystalDrake => 'Drake Kristal';

  @override
  String get monsterCrystalDragon => 'Naga Kristal';

  @override
  String get monsterDiamondWyrm => 'Wyrm Berlian';

  @override
  String get monsterShadowGuard => 'Penjaga Bayangan';

  @override
  String get monsterShadowKnight => 'Ksatria Bayangan';

  @override
  String get monsterTheMaster => 'Sang Master';

  @override
  String get monsterPebbleGolem => 'Golem Kerikil';

  @override
  String get monsterStoneGolem => 'Golem Batu';

  @override
  String get monsterOreGolem => 'Golem Bijih';

  @override
  String get monsterMinerGolem => 'Golem Penambang';

  @override
  String get monsterScarabGrub => 'Larva Skarab';

  @override
  String get monsterHornedScarab => 'Skarab Bertanduk';

  @override
  String get monsterScarabWarrior => 'Prajurit Skarab';

  @override
  String get monsterYetiCub => 'Anak Yeti';

  @override
  String get monsterHornedYeti => 'Yeti Bertanduk';

  @override
  String get monsterGoldRecruit => 'Rekrut Emas';

  @override
  String get monsterGoldGuard => 'Pengawal Emas';

  @override
  String get monsterShade => 'Bayang';

  @override
  String get monsterIceSpecter => 'Hantu Es';

  @override
  String get monsterCrystalHatchling => 'Bayi Naga Kristal';

  @override
  String get monsterCrystalWhelp => 'Naga Muda Kristal';

  @override
  String get monsterShadowSquire => 'Ajudan Bayangan';

  @override
  String get monsterShadowLord => 'Penguasa Bayangan';

  @override
  String monsterWarden(String name) {
    return '${name} Penjaga';
  }

  @override
  String get obPhoneSees => 'Yang harus dilihat ponselmu';

  @override
  String get obPhoneSeesBody => 'Dari ujung kepala sampai tangan, sekitar satu meter jauhnya, dalam posisi push-up.';

  @override
  String get obUnder13 => 'Di bawah 13';

  @override
  String get obOver13 => '13 atau lebih';

  @override
  String get obFor13 => 'outrepd untuk usia 13 tahun ke atas.';

  @override
  String get obUnder13Blocked => 'outrepd untuk usia 13 tahun ke atas. Kembali lagi saat kamu sudah 13 — push-up-nya akan tetap di sini.';

  @override
  String get obBeforeYouLift => 'Sebelum mulai';

  @override
  String get obFightTitle => 'Lawan monster.';

  @override
  String get obFightBody => '140 pertarungan push up di tujuh dunia. Setiap repetisi memukul monsternya.';

  @override
  String obSevenWorlds(String from, String to) {
    return 'Tujuh dunia, dari ${from} sampai ${to}';
  }

  @override
  String get obWeaponsTitle => 'Bintang membuka senjata';

  @override
  String get obWeaponsBody => 'Setiap dunia butuh senjatanya sendiri. Peringkat tidak dipertaruhkan.';

  @override
  String get fightDefeated => 'Kalah!';

  @override
  String get nextWeapon => 'Senjata berikutnya';

  @override
  String opensWorld(String world) {
    return 'Membuka ${world}';
  }

  @override
  String weaponAtStars(String count) {
    return 'di ${count} bintang';
  }

  @override
  String topTenIn(String country) {
    return '10 besar di ${country}';
  }
}
