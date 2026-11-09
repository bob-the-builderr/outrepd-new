// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class LDe extends L {
  LDe([String locale = 'de']) : super(locale);

  @override
  String get tabFriends => 'Freunde';

  @override
  String get tabRanks => 'Ränge';

  @override
  String get tabMatch => 'Duell';

  @override
  String get tabProfile => 'Profil';

  @override
  String get challengeFriend => 'Freund herausfordern';

  @override
  String get matchHistory => 'Duellverlauf';

  @override
  String get allMatches => 'Alle Duelle';

  @override
  String get wins => 'Siege';

  @override
  String get losses => 'Niederlagen';

  @override
  String get winRate => 'Siegquote';

  @override
  String get streak => 'Serie';

  @override
  String get settings => 'Einstellungen';

  @override
  String get accountSection => 'Konto';

  @override
  String get duelSection => 'Duell';

  @override
  String get hapticsEachRep => 'Vibration bei jeder Wiederholung';

  @override
  String get showSkeleton => 'Skelett einblenden';

  @override
  String get showSkeletonHint => 'So siehst du, dass die Kamera dich erkennt';

  @override
  String get manageNotifications => 'Benachrichtigungen verwalten';

  @override
  String switchesOn(String on, String all) {
    return '$on von $all an';
  }

  @override
  String get whoCanChallenge => 'Wer mich herausfordern darf';

  @override
  String get blockedAccounts => 'Blockierte Konten';

  @override
  String get reportProblem => 'Problem melden';

  @override
  String get onDeviceNote =>
      'Die Posenerkennung läuft auf diesem Handy. Es werden weder Video noch Posendaten hochgeladen.';

  @override
  String get visibilitySection => 'Sichtbarkeit';

  @override
  String get showMyCountry => 'Mein Land zeigen';

  @override
  String get showMyCountryHint => 'Aus heißt: nicht mehr auf dem Länder-Board';

  @override
  String get safetySection => 'Sicherheit';

  @override
  String get socialSection => 'Soziales';

  @override
  String get noticeRaced => 'Jemand ist gegen meinen Satz angetreten';

  @override
  String get noticeRacedHint =>
      'Der einzige Weg zu erfahren, dass ein Duell stattfand';

  @override
  String get noticeFriendOk => 'Meine Anfrage wurde angenommen';

  @override
  String get noticesStoredNote =>
      'Ausschalten heißt: wird gar nicht erst gespeichert, nicht nur versteckt.';

  @override
  String get notSaved => 'Nicht gespeichert';

  @override
  String get blockedIntro =>
      'Ein blockiertes Konto kann dich nicht herausfordern, finden oder anfragen. Es erfährt nichts davon.';

  @override
  String blockedWhen(String when) {
    return 'Blockiert $when';
  }

  @override
  String get unblock => 'Freigeben';

  @override
  String get noBlockedTitle => 'Niemand blockiert';

  @override
  String get noBlockedBody =>
      'Du kannst jemanden über sein Profil oder eine Meldung blockieren.';

  @override
  String get whatHappened => 'Was ist passiert';

  @override
  String get reasonCheating => 'Betrug oder gefälschte Wiederholungen';

  @override
  String get reasonHarassment => 'Belästigung oder Missbrauch';

  @override
  String get reasonContent => 'Unangemessene Inhalte';

  @override
  String get reasonImpersonation => 'Identitätsdiebstahl';

  @override
  String get reasonOther => 'Etwas anderes';

  @override
  String get addDetails => 'Details hinzufügen (optional)';

  @override
  String get alsoBlock => 'Dieses Konto auch blockieren';

  @override
  String get sendReport => 'Meldung senden';

  @override
  String get reportSent => 'Meldung gesendet';

  @override
  String get reportingThisAccount => 'Dieses Konto wird gemeldet';

  @override
  String get exportIntro =>
      'Wir mailen dir eine Datei mit allem, was der Server über dich hat. Dauert meist eine Minute.';

  @override
  String get whatsIncluded => 'Was enthalten ist';

  @override
  String get incProfile => 'Profil und Rang';

  @override
  String get incSets => 'Alle Sätze und Wiederholungen';

  @override
  String get incDuels => 'Duell-Verlauf und Wertungsänderungen';

  @override
  String get incFriends => 'Freunde und blockierte Konten';

  @override
  String get incNotices => 'Gesendete Benachrichtigungen';

  @override
  String get noLandmarksNote =>
      'Posendaten sind nicht dabei und waren es nie. Die Kamera liest sie auf deinem Handy, gesendet wird nichts.';

  @override
  String get sendItTo => 'Senden an';

  @override
  String get emailHint => 'du@beispiel.de';

  @override
  String get createAccountTitle => 'Konto erstellen';

  @override
  String get createAccountBody => 'Melde dich an, damit dieses Konto nicht an einem einzigen Handy hängt.';

  @override
  String get createAccountAction => 'Konto erstellen';

  @override
  String get emailTakenSwitchToSignIn =>
      'Diese E-Mail-Adresse hat bereits ein Konto — melde dich stattdessen an.';

  @override
  String get emailSignUpInvalid =>
      'Prüfe E-Mail und Passwort — mindestens sechs Zeichen.';

  @override
  String get tooManyCodes =>
      'Zu viele Codes gesendet — warte ein paar Minuten und versuche es erneut.';

  @override
  String get sendCodeAction => 'Code senden';

  @override
  String get noAccountForEmail =>
      'Wir konnten kein Konto mit dieser E-Mail finden.';

  @override
  String get authEntryTagline => 'Drücken. Antreten. Aufsteigen.';

  @override
  String get signUpWithEmail => 'Mit E-Mail registrieren';

  @override
  String get alreadyHaveAccountQuestion => 'Schon ein Konto?';

  @override
  String get logInAction => 'Anmelden';

  @override
  String get createYourAccountTitle => 'Erstelle dein Konto';

  @override
  String get createAccountSubtitle => 'Dauert weniger als eine Minute.';

  @override
  String get usernameLabel => 'Benutzername';

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get logInSubtitle => 'Melde dich an, um deinen Rang zu behalten.';

  @override
  String get checkYourEmailTitle => 'Prüfe deine E-Mails';

  @override
  String codeSentTo(String email) {
    return 'Wir haben einen 6-stelligen Code an $email gesendet.';
  }

  @override
  String get didntGetIt => 'Nichts bekommen?';

  @override
  String resendInSeconds(String time) {
    return 'Erneut senden in $time';
  }

  @override
  String get wrongEmailGoBack => 'Falsche E-Mail? Zurück';

  @override
  String get usernameTaken => 'Dieser Benutzername ist vergeben.';

  @override
  String get wrongCode => 'Der Code ist falsch oder abgelaufen.';

  @override
  String get resendCode => 'Code erneut senden';

  @override
  String get codeResent => 'Neuer Code gesendet.';

  @override
  String signedInAs(String email) {
    return 'Angemeldet als $email';
  }

  @override
  String get addressNotKept =>
      'Die Adresse wird einmal benutzt und nicht gespeichert — dieses Konto hat keine E-Mail.';

  @override
  String get requestMyData => 'Daten mailen';

  @override
  String exportSent(String address) {
    return 'Gesendet an $address';
  }

  @override
  String get deleteIntro =>
      'Das löscht alles endgültig. Es lässt sich nicht rückgängig machen und nicht wiederherstellen.';

  @override
  String get rankLabel => 'Rang';

  @override
  String get wantCopyFirst => 'Erst eine Kopie?';

  @override
  String get wantCopyBody =>
      'Lade deine Daten herunter, bevor du löschst. Danach sind sie weg.';

  @override
  String typeToConfirm(String word) {
    return 'Tippe $word zur Bestätigung';
  }

  @override
  String get deleteWord => 'LÖSCHEN';

  @override
  String get deletePermanently => 'Endgültig löschen';

  @override
  String get keepMyAccount => 'Konto behalten';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get skip => 'Überspringen';

  @override
  String get yourPicture => 'Dein Bild';

  @override
  String get yourPictureHint =>
      'Der Rahmen kommt von deinem Rang und ändert sich beim Aufstieg.';

  @override
  String get couldNotUsePicture => 'Dieses Bild konnte nicht verwendet werden';

  @override
  String get couldNotSyncAvatar =>
      'Dein Bild ist gespeichert, aber noch nicht synchronisiert';

  @override
  String get removePhoto => 'Foto entfernen';

  @override
  String get removePhotoTitle => 'Foto entfernen?';

  @override
  String get removePhotoBody =>
      'Stattdessen wird überall dein Lifter gezeigt. Du kannst jederzeit ein neues Foto hinzufügen.';

  @override
  String get removePhotoConfirm => 'Entfernen';

  @override
  String get couldNotRemovePhoto => 'Dein Foto konnte nicht entfernt werden. Versuch es noch einmal.';

  @override
  String get cropPhoto => 'Zuschneiden';

  @override
  String get proGoTitle => 'Hol dir Pro.';

  @override
  String get proOnboardTitle => 'Dein Lifter, Pro.';

  @override
  String get proSubtitle => 'Keine Werbung und ein Look, den die Gratis-App nicht hat.';

  @override
  String get proFree => 'GRATIS';

  @override
  String get proYoursNow => 'JETZT DEINER';

  @override
  String get proPerkNoAds => 'Keine Werbung. Nie.';

  @override
  String get proPerkNoAdsBody => 'Jedes Match, jedes Level, ohne Pause.';

  @override
  String get proPerkBoard => 'Glanz auf jeder Rangliste';

  @override
  String get proPerkBoardBody => 'Eine Holo-Zeile, aus der dein Lifter herausbricht.';

  @override
  String get proPerkEntrance => 'Ein Auftritt mit Blitzen';

  @override
  String get proPerkEntranceBody => 'Auf dem VS-Bildschirm vor jedem Live-Match.';

  @override
  String get proPerkCovers => '13 bewegte Titelbilder';

  @override
  String get proPerkCoversBody => 'Oder dein eigenes Foto, oben auf deinem Profil.';

  @override
  String get proPerkItems => '20 Pro-Items';

  @override
  String get proPerkItemsBody => 'Skins, Oberteile, Ausrüstung und ein Lifter, der blinzelt.';

  @override
  String get proGo => 'Hol dir Pro';

  @override
  String proBuyYearly(String price) {
    return 'Pro holen · ${price}/Jahr';
  }

  @override
  String proBuyWeekly(String price) {
    return 'Pro holen · ${price}/Woche';
  }

  @override
  String get proSettingsBody => 'Keine Werbung, dazu der Pro-Look.';

  @override
  String get proSettingsActive => 'Du bist Pro. Danke für deine Unterstützung.';

  @override
  String get lifterMakerTitle => 'Avatar anpassen';

  @override
  String get lifterMakerFirst => 'Avatar anpassen';

  @override
  String get lifterMakerFirstBody => 'Das bist du auf jeder Rangliste und in jedem Match.';

  @override
  String get lifterTabSkin => 'Haut';

  @override
  String get lifterTabHair => 'Haare';

  @override
  String get lifterTabFace => 'Gesicht';

  @override
  String get lifterTabBeard => 'Bart';

  @override
  String get lifterTabTop => 'Oberteil';

  @override
  String get lifterTabGear => 'Ausrüstung';

  @override
  String get lifterTabBackground => 'Hintergrund';

  @override
  String get lifterTabCharacters => 'Charaktere';

  @override
  String get lifterEyes => 'Augen';

  @override
  String get lifterBrows => 'Brauen';

  @override
  String get lifterMouth => 'Mund';

  @override
  String get lifterMarks => 'Zeichen';

  @override
  String get lifterRandom => 'Zufall';

  @override
  String get lifterTryingPro => 'Ein Pro-Look.';

  @override
  String get lifterUnlockPro => 'Mit Pro freischalten';

  @override
  String get editLifter => 'Lifter bearbeiten';

  @override
  String lifterNeedsWorld(String world) {
    return 'Schließe ${world} ab';
  }

  @override
  String lifterNeedsTier(String tier) {
    return 'Erreiche ${tier}';
  }

  @override
  String lifterNeedsLevel(String level) {
    return 'Erreiche Level ${level}';
  }

  @override
  String lifterNeedsWins(String count) {
    return 'Gewinne ${count} Matches';
  }

  @override
  String lifterNeedsWinStreak(String count) {
    return 'Gewinne ${count} in Folge';
  }

  @override
  String lifterNeedsDayStreak(String count) {
    return 'Trainiere ${count} Tage in Folge';
  }

  @override
  String get lifterNeedsMonthTop10 => 'Beende einen Monat in den Top 10';

  @override
  String get lifterNeedsMonthPodium => 'Beende einen Monat in den Top 3';

  @override
  String get lifterNeedsMonthChampion => 'Gewinne einen Monat';

  @override
  String lifterNeedsStars(String count) {
    return '3 Sterne in ${count} Abenteuer-Levels';
  }

  @override
  String get lifterNeedsAllStars => 'Jeder Stern im Abenteuer';

  @override
  String get coverTitle => 'Titelbild';

  @override
  String get coverPhoto => 'Dein Foto';

  @override
  String get coverNone => 'Kein Titelbild';

  @override
  String get coverUse => 'Dieses Titelbild nehmen';

  @override
  String get coverProLine => 'Titelbilder sind Pro. Sie bewegen sich, und jeder, der dein Profil öffnet, sieht sie.';

  @override
  String get coverCouldNotUpload => 'Dein Foto konnte nicht hochgeladen werden. Versuch es noch einmal.';

  @override
  String get coverNeonCity => 'Neon-Stadt';

  @override
  String get coverIronGym => 'Eisen-Gym';

  @override
  String get coverRooftopSunset => 'Sonnenuntergang auf dem Dach';

  @override
  String get coverStadiumLights => 'Flutlicht';

  @override
  String get coverSilverPeaks => 'Silbergipfel';

  @override
  String get coverBronzeDunes => 'Bronzedünen';

  @override
  String get coverVolcano => 'Vulkan';

  @override
  String get coverPalmBeach => 'Palmenstrand';

  @override
  String get coverWinterCity => 'Winterstadt';

  @override
  String get coverFireworks => 'Feuerwerk';

  @override
  String get coverFightNight => 'Kampfnacht';

  @override
  String get coverOrbit => 'Umlaufbahn';

  @override
  String get coverChampionPodium => 'Siegerpodest';

  @override
  String get vsLiveRanked => 'LIVE · GEWERTET';

  @override
  String get vsLiveFriendly => 'LIVE · FREUNDSCHAFT';

  @override
  String get vsSavedRanked => 'GESPEICHERTER SATZ · GEWERTET';

  @override
  String get vsRematchFriendly => 'REVANCHE · FREUNDSCHAFT';

  @override
  String get couldNotShareCard => 'Diese Karte konnte nicht geteilt werden';

  @override
  String get couldNotOpenLink => 'Der Link konnte nicht geöffnet werden';

  @override
  String get couldNotCheckUsername =>
      'Der Name konnte nicht geprüft werden — versuch es noch mal';

  @override
  String get changeUsername => 'Benutzernamen ändern';

  @override
  String get usernameInvalidLength =>
      'Muss 4 bis 20 Zeichen lang sein, nur Buchstaben, Zahlen und _';

  @override
  String get usernameChanged => 'Benutzername geändert';

  @override
  String get usernameAlreadyChangedBody => 'Der Benutzername kann alle 14 Tage einmal geändert werden.';

  @override
  String get gallery => 'Galerie';

  @override
  String get camera => 'Kamera';

  @override
  String get awards => 'Auszeichnungen';

  @override
  String get yourTitles => 'Deine Titel';

  @override
  String get stillToEarn => 'Noch zu verdienen';

  @override
  String get noTitlesYet => 'Noch keiner. Für den ersten reicht ein Duell.';

  @override
  String get wearHint =>
      'Tippe einen an, um ihn zu tragen. Er steht neben deinem Namen, überall wo man dich sieht.';

  @override
  String get worn => 'getragen';

  @override
  String get titleUnlocked => 'Titel freigeschaltet';

  @override
  String get wearIt => 'Tragen';

  @override
  String get wearItLater => 'Später';

  @override
  String get dayStreak => 'Tage in Folge';

  @override
  String get bestEver => 'Bestwert';

  @override
  String get restDaysLeft => 'Ruhetage übrig';

  @override
  String get restIsTraining =>
      'Erholung gehört zum Training. Zwei freie Tage pro Woche brechen deine Serie nicht.';

  @override
  String get global => 'Global';

  @override
  String get topPlayers => 'Top-Spieler';

  @override
  String get yourTier => 'Deine Stufe';

  @override
  String get challenge => 'Fordern';

  @override
  String get notifications => 'Mitteilungen';

  @override
  String get start => 'Start';

  @override
  String get finish => 'Fertig';

  @override
  String get reps => 'Wdh.';

  @override
  String get howManyReally => 'Wie viele waren es wirklich?';

  @override
  String get howManyReallyHint =>
      'Deine eigene Zählung, nicht die der App. Daran wird der Zähler später gemessen.';

  @override
  String get appearance => 'Darstellung';

  @override
  String get theme => 'Design';

  @override
  String get language => 'Sprache';

  @override
  String get privacy => 'Privatsphäre';

  @override
  String get data => 'Daten';

  @override
  String get about => 'Über die App';

  @override
  String get themeSystem => 'Wie das Gerät';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get accept => 'Annehmen';

  @override
  String get visEveryone => 'Alle';

  @override
  String get visFriends => 'Nur Freunde';

  @override
  String get visNobody => 'Niemand';

  @override
  String get friendRequestsLabel => 'Freundschaftsanfragen';

  @override
  String get showOnLeaderboards => 'In Ranglisten anzeigen';

  @override
  String get exportData => 'Meine Daten exportieren';

  @override
  String get version => 'Version';

  @override
  String get rateApp => 'OUTREPD bewerten';

  @override
  String get contactSupport => 'Support kontaktieren';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get openSourceLicences => 'Open-Source-Lizenzen';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get needsServer =>
      'Keine Verbindung. Prüfe dein Internet und versuche es erneut.';

  @override
  String get roomFriendly =>
      'Raum-Duelle sind freundschaftlich — sie zählen nicht für deinen Rang.';

  @override
  String get shareThisCode => 'Teile diesen Code';

  @override
  String get codeCopied => 'Code kopiert';

  @override
  String xOfY(String a, String b) {
    return '$a / $b';
  }

  @override
  String get tierIron => 'Eisen';

  @override
  String get tierBronze => 'Bronze';

  @override
  String get tierSilver => 'Silber';

  @override
  String get tierGold => 'Gold';

  @override
  String get tierPlatinum => 'Platin';

  @override
  String get tierDiamond => 'Diamant';

  @override
  String get tierMaster => 'Meister';

  @override
  String winLoss(String w, String l) {
    return '${w}S ${l}N';
  }

  @override
  String get continueLabel => 'Weiter';

  @override
  String get ttl_first_blood => 'Erstes Blut';

  @override
  String get tdesc_first_blood => 'Beende dein erstes Duell';

  @override
  String get ttl_found_footing => 'Fuß Gefasst';

  @override
  String get tdesc_found_footing => 'Beende fünf Duelle';

  @override
  String get ttl_regular => 'Stammgast';

  @override
  String get tdesc_regular => 'Zwanzig Duelle';

  @override
  String get ttl_fifty => 'Die Fünfzig';

  @override
  String get tdesc_fifty => 'Fünfzig Duelle';

  @override
  String get ttl_century => 'Jahrhundert';

  @override
  String get tdesc_century => 'Hundert Duelle';

  @override
  String get ttl_veteran => 'Veteran';

  @override
  String get tdesc_veteran => 'Zweihundertfünfzig Duelle';

  @override
  String get ttl_thousand_matches => 'Alte Garde';

  @override
  String get tdesc_thousand_matches => 'Tausend Duelle';

  @override
  String get ttl_first_win => 'Sieger';

  @override
  String get tdesc_first_win => 'Gewinne ein Duell';

  @override
  String get ttl_on_a_roll => 'Im Lauf';

  @override
  String get tdesc_on_a_roll => 'Gewinne drei in Folge';

  @override
  String get ttl_five_straight => 'Fünf am Stück';

  @override
  String get tdesc_five_straight => 'Gewinne fünf in Folge';

  @override
  String get ttl_unstoppable => 'Unaufhaltsam';

  @override
  String get tdesc_unstoppable => 'Gewinne zehn in Folge';

  @override
  String get ttl_untouchable => 'Unantastbar';

  @override
  String get tdesc_untouchable => 'Gewinne zwanzig in Folge';

  @override
  String get ttl_giant_slayer => 'Riesentöter';

  @override
  String get tdesc_giant_slayer => 'Schlage jemanden zwei Ränge über dir';

  @override
  String get ttl_comeback => 'Comeback';

  @override
  String get tdesc_comeback => 'Gewinne direkt nach drei Niederlagen';

  @override
  String get ttl_nemesis => 'Nemesis';

  @override
  String get tdesc_nemesis => 'Schlage denselben Sportler fünfmal';

  @override
  String get ttl_hundred_reps => 'Angelaufen';

  @override
  String get tdesc_hundred_reps => 'Hundert gezählte Wiederholungen';

  @override
  String get ttl_five_hundred => 'Aufgewärmt';

  @override
  String get tdesc_five_hundred => 'Fünfhundert gezählte Wiederholungen';

  @override
  String get ttl_the_machine => 'Die Maschine';

  @override
  String get tdesc_the_machine => 'Tausend gezählte Wiederholungen';

  @override
  String get ttl_five_thousand => 'Unerbittlich';

  @override
  String get tdesc_five_thousand => 'Fünftausend gezählte Wiederholungen';

  @override
  String get ttl_ten_thousand => 'Zehntausend';

  @override
  String get tdesc_ten_thousand => 'Zehntausend gezählte Wiederholungen';

  @override
  String get ttl_fifty_thousand => 'Jenseits des Zählens';

  @override
  String get tdesc_fifty_thousand => 'Fünfzigtausend gezählte Wiederholungen';

  @override
  String get ttl_first_tonne => 'Eine Tonne';

  @override
  String get tdesc_first_tonne => 'Bewege insgesamt tausend Kilo';

  @override
  String get ttl_ten_tonnes => 'Zehn Tonnen';

  @override
  String get tdesc_ten_tonnes => 'Bewege zehntausend Kilo';

  @override
  String get ttl_six_figures => 'Sechsstellig';

  @override
  String get tdesc_six_figures => 'Bewege hunderttausend Kilo';

  @override
  String get ttl_half_million => 'Halbe Million';

  @override
  String get tdesc_half_million => 'Bewege fünfhunderttausend Kilo';

  @override
  String get ttl_million_kg => 'Millionen-Klub';

  @override
  String get tdesc_million_kg => 'Bewege eine Million Kilo';

  @override
  String get ttl_two_days => 'Wieder Da';

  @override
  String get tdesc_two_days => 'Trainiere zwei Tage hintereinander';

  @override
  String get ttl_no_days_off => 'Keine Freien Tage';

  @override
  String get tdesc_no_days_off => 'Trainiere sieben Tage hintereinander';

  @override
  String get ttl_fortnight => 'Vierzehn Tage';

  @override
  String get tdesc_fortnight => 'Eine Serie über vierzehn Tage';

  @override
  String get ttl_unbroken => 'Ungebrochen';

  @override
  String get tdesc_unbroken => 'Eine Serie über dreißig Tage';

  @override
  String get ttl_sixty_days => 'Gewohnheit';

  @override
  String get tdesc_sixty_days => 'Eine Serie über sechzig Tage';

  @override
  String get ttl_hundred_days => 'Hundert Tage';

  @override
  String get tdesc_hundred_days => 'Eine Serie über hundert Tage';

  @override
  String get ttl_year_round => 'Das Ganze Jahr';

  @override
  String get tdesc_year_round =>
      'Eine Serie über dreihundertfünfundsechzig Tage';

  @override
  String get ttl_perfect_week => 'Perfekte Woche';

  @override
  String get tdesc_perfect_week => 'Trainiere jeden Tag einer Woche';

  @override
  String get ttl_perfect_month => 'Perfekter Monat';

  @override
  String get tdesc_perfect_month => 'Vier perfekte Wochen';

  @override
  String get ttl_bronze_tier => 'Raus aus dem Eisen';

  @override
  String get tdesc_bronze_tier => 'Erreiche Bronze';

  @override
  String get ttl_silver_tier => 'Silbrig';

  @override
  String get tdesc_silver_tier => 'Erreiche Silber';

  @override
  String get ttl_golden_era => 'Goldene Ära';

  @override
  String get tdesc_golden_era => 'Erreiche Gold';

  @override
  String get ttl_platinum_tier => 'Platin';

  @override
  String get tdesc_platinum_tier => 'Erreiche Platin';

  @override
  String get ttl_diamond_tier => 'Diamanthände';

  @override
  String get tdesc_diamond_tier => 'Erreiche Diamant';

  @override
  String get ttl_master_tier => 'Meister';

  @override
  String get tdesc_master_tier => 'Erreiche Meister';

  @override
  String get ttl_clean_hands => 'Saubere Hände';

  @override
  String get tdesc_clean_hands => 'Ein ganzer Satz, jede Wiederholung gezählt';

  @override
  String get ttl_spotless => 'Makellos';

  @override
  String get tdesc_spotless => 'Zehn saubere Sätze';

  @override
  String get ttl_textbook => 'Lehrbuch';

  @override
  String get tdesc_textbook => 'Fünfzig saubere Sätze';

  @override
  String get ttl_all_rounder => 'Allrounder';

  @override
  String get tdesc_all_rounder => 'Zähle fünf verschiedene Übungen';

  @override
  String get ttl_explorer => 'Entdecker';

  @override
  String get tdesc_explorer => 'Zähle fünfzehn verschiedene Übungen';

  @override
  String get ttl_encyclopedia => 'Enzyklopädie';

  @override
  String get tdesc_encyclopedia => 'Zähle vierzig verschiedene Übungen';

  @override
  String get ttl_early_bird => 'Frühschicht';

  @override
  String get tdesc_early_bird => 'Zehn Einheiten vor sieben Uhr';

  @override
  String get ttl_sunrise_club => 'Sonnenaufgangsklub';

  @override
  String get tdesc_sunrise_club => 'Fünfzig Einheiten vor sieben Uhr';

  @override
  String get ttl_night_owl => 'Nachtschicht';

  @override
  String get tdesc_night_owl => 'Zehn Einheiten nach zweiundzwanzig Uhr';

  @override
  String get ttl_graveyard => 'Geisterschicht';

  @override
  String get tdesc_graveyard => 'Fünfzig Einheiten nach zweiundzwanzig Uhr';

  @override
  String get ttl_not_alone => 'Nicht Allein';

  @override
  String get tdesc_not_alone => 'Füge deinen ersten Freund hinzu';

  @override
  String get ttl_well_connected => 'Gut Vernetzt';

  @override
  String get tdesc_well_connected => 'Zehn Freunde';

  @override
  String get ttl_the_gym_knows => 'Das Studio Kennt Dich';

  @override
  String get tdesc_the_gym_knows => 'Fünfzig Freunde';

  @override
  String get forfeitQ => 'Duell aufgeben?';

  @override
  String get forfeitBody => 'Du verlierst LP, wenn du jetzt gehst.';

  @override
  String get forfeitRematchBody => 'Das zählt als Niederlage.';

  @override
  String get forfeit => 'Aufgeben';

  @override
  String get getReady => 'BEREIT MACHEN';

  @override
  String get you => 'DU';

  @override
  String get vs => 'VS';

  @override
  String get backToHome => 'ZURÜCK ZUM START';

  @override
  String get mgChest => 'Brust';

  @override
  String get nWonTitle => 'Du hast gewonnen!';

  @override
  String nWonBody(String name, String muscle) {
    return 'Du hast $name am $muscle-Tag geschlagen';
  }

  @override
  String get nFriendTitle => 'Neue Freundschaftsanfrage';

  @override
  String get nRacedTitle => 'Dein Satz wurde gefordert';

  @override
  String nRacedHeld(String name, String yours, String theirs) {
    return '$name ist gegen deinen Satz angetreten und kam nicht ran, $yours–$theirs';
  }

  @override
  String nRacedBeaten(String name, String theirs, String yours) {
    return '$name ist gegen deinen Satz angetreten und hat gewonnen, $theirs–$yours';
  }

  @override
  String get nFriendOkTitle => 'Freundschaftsanfrage angenommen';

  @override
  String nFriendOkBody(String name) {
    return '$name hat deine Anfrage angenommen';
  }

  @override
  String nFriendBody(String name) {
    return '$name möchte sich vernetzen';
  }

  @override
  String get nChallengedTitle => 'Revanche';

  @override
  String nChallengedBody(String name) {
    return '$name möchte eine Revanche';
  }

  @override
  String get challengeSentTitle => 'Herausforderung gesendet';

  @override
  String challengeSentBody(String name) {
    return 'Wir sagen $name Bescheid. Komm zurück, sobald sie es geschafft haben.';
  }

  @override
  String get challengeNotSentTitle => 'Senden fehlgeschlagen';

  @override
  String get challengeNotSentBody =>
      'Prüfe deine Verbindung und versuche es im Kampf-Tab erneut.';

  @override
  String get challengeGoneTitle => 'Herausforderung ist weg';

  @override
  String get challengeGoneBody =>
      'Sie wurde bereits bestritten oder zurückgezogen.';

  @override
  String repsRecordedLine(String reps) {
    return '$reps Wiederholungen erfasst';
  }

  @override
  String get nAchTitle => 'Erfolg freigeschaltet';

  @override
  String nAchBody(String title, String hint) {
    return '$title — $hint';
  }

  @override
  String get nRankTitle => 'Rangaufstieg!';

  @override
  String nRankBody(String rank) {
    return 'Du hast $rank erreicht';
  }

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String daysAgo(String n) {
    return 'vor $n Tagen';
  }

  @override
  String weeksAgo(String n) {
    return 'vor ${n} Wochen';
  }

  @override
  String lpAmount(String n) {
    return '$n LP';
  }

  @override
  String get lpUnit => 'LP';

  @override
  String get trueCountHint => 'z. B. 12';

  @override
  String get couldNotSaveSession => 'Sitzung konnte nicht gespeichert werden';

  @override
  String lpOutOf(String total) {
    return '/ $total LP';
  }

  @override
  String get noFriendsTitle => 'Noch keine Freunde';

  @override
  String get noFriendsBody =>
      'Gegen jemanden, den du kennst, fühlt sich ein Duell anders an.';

  @override
  String get decline => 'Ablehnen';

  @override
  String requestSent(String name) {
    return 'Anfrage an $name gesendet';
  }

  @override
  String nowFriends(String name) {
    return 'Du und $name seid jetzt Freunde';
  }

  @override
  String get noOneFound => 'Niemand heißt so';

  @override
  String get noMatchesTitle => 'Noch keine Duelle';

  @override
  String get noMatchesBody =>
      'Das erste erscheint hier — gewonnen oder verloren.';

  @override
  String get noNotificationsTitle => 'Nichts Neues';

  @override
  String get noNotificationsBody =>
      'Duelleinladungen, Ergebnisse und Freundschaftsanfragen landen hier.';

  @override
  String get countedThat => 'In dieser Runde gezählt';

  @override
  String get thatIsRight => 'Stimmt';

  @override
  String get useMyCount => 'Meine Zahl nehmen';

  @override
  String get confirmHint => 'Ändere es, wenn die Kamera danebenlag.';

  @override
  String get unsureMovement =>
      'Nicht sicher, ob das die richtige Übung war — prüfe die Zahl.';

  @override
  String get noRanksYet => 'Noch keine Rangliste';

  @override
  String get noRanksYetBody => 'Spiel ein Duell, dann füllt sich die Liste.';

  @override
  String get ranksTitle => 'Ränge';

  @override
  String get totalReps => 'Wiederholungen gesamt';

  @override
  String get recent => 'Zuletzt';

  @override
  String wonVs(String name) {
    return 'Sieg gegen ${name}';
  }

  @override
  String lostVs(String name) {
    return 'Niederlage gegen ${name}';
  }

  @override
  String hoursAgo(String n) {
    return 'vor ${n} Std.';
  }

  @override
  String toNextTier(String n, String tier) {
    return '${n} bis ${tier}';
  }

  @override
  String get noMatchesYet => 'Noch keine Duelle';

  @override
  String get noMatchesYetBody => 'Dein erstes erscheint hier, Sieg oder Niederlage.';

  @override
  String get searchByUsername => 'Nach Benutzernamen suchen';

  @override
  String get incomingRequests => 'Offene Anfragen';

  @override
  String get noRequestsWaiting => 'Gerade keine Anfragen offen';

  @override
  String get addFriendAction => 'Freund hinzufügen';

  @override
  String get addFriendHint =>
      'Gib ihren Benutzernamen ein oder den #Code aus ihrem Profil.';

  @override
  String get usernameOrCode => 'Benutzername oder #Code';

  @override
  String get sendRequest => 'Anfrage senden';

  @override
  String onlineNowCount(String count) {
    return 'Jetzt online · $count';
  }

  @override
  String offlineCount(String count) {
    return 'Offline · $count';
  }

  @override
  String get invite => 'Einladen';

  @override
  String get headToHeadTitle => 'Direktvergleich';

  @override
  String get vsYouCaption => 'gegen dich';

  @override
  String get h2hYou => 'du';

  @override
  String get h2hThem => 'er';

  @override
  String headToHead(String wins, String losses) {
    return '${wins}S ${losses}N gegen dich';
  }

  @override
  String get neverPlayedYou => 'Noch nie gegen dich';

  @override
  String noHistoryWithThem(String username) {
    return 'Du hast noch nicht gegen $username gespielt.';
  }

  @override
  String lastDuelScore(String yourReps, String theirReps, String when) {
    return 'Letztes Mal: $yourReps–$theirReps, $when.';
  }

  @override
  String yourBestVsThemLine(String reps) {
    return 'Deine beste Leistung gegen sie ist $reps.';
  }

  @override
  String get viewFullProfile => 'Vollständiges Profil ansehen';

  @override
  String get moreOptions => 'Weitere Optionen';

  @override
  String get block => 'Blockieren';

  @override
  String get blockRowBody =>
      'Kann dich nicht herausfordern oder dein Profil sehen';

  @override
  String get report => 'Melden';

  @override
  String get reportRowBody => 'Wird innerhalb von 24 Stunden geprüft';

  @override
  String muteChallenges(String username) {
    return 'Herausforderungen von $username stummschalten';
  }

  @override
  String blockedLifter(String username) {
    return '$username blockiert';
  }

  @override
  String mutedLifter(String username) {
    return '$username stummgeschaltet';
  }

  @override
  String get addFriendButton => 'Freund hinzufügen';

  @override
  String get alreadyFriends => 'Freunde';

  @override
  String get couldNotLoadProfile => 'Profil konnte nicht geladen werden';

  @override
  String get noFriendsMatch => 'Niemand mit diesem Namen';

  @override
  String get yourClimb => 'Dein Aufstieg';

  @override
  String get yourRank => 'Dein Rang';

  @override
  String get whoIsNext => 'Wer ist der Nächste?';

  @override
  String get opponentFound => 'Gegner gefunden';

  @override
  String get obSevenTiers => 'Die sieben Ränge';

  @override
  String get obRatingPerMatch => 'Wertung pro Match';

  @override
  String get obWinLabel => 'Sieg';

  @override
  String get obLossLabel => 'Niederlage';

  @override
  String get obFloorLabel => 'Untergrenze';

  @override
  String obWinRating(String n) {
    return '+${n} + Unterschied';
  }

  @override
  String obLossRating(String n) {
    return '−${n} − Unterschied';
  }

  @override
  String obNeverBelow(String n) {
    return 'nie unter ${n}';
  }

  @override
  String obDivisionLine(String division, String tier) {
    return 'Alle ${division} Punkte eine Stufe, ${tier} ein Rang.';
  }

  @override
  String ratingFloor(String n) {
    return 'Deine Wertung fällt nie unter ${n}.';
  }

  @override
  String floorKept(String tier, String rank) {
    return '$tier gehört dir. Unter $rank fällst du nicht mehr.';
  }

  @override
  String dayStreakCount(String count) {
    return '$count Tage in Folge';
  }

  @override
  String get findMatch => 'Match finden';

  @override
  String rankedTerms(String seconds) {
    return '$seconds Sekunden · gewertet';
  }

  @override
  String get practiceTerms => 'Üben — ohne Wertung, ohne Gegner';

  @override
  String get practiceComplete => 'ÜBUNG BEENDET';

  @override
  String get noRankYet => 'Noch kein Rang';

  @override
  String get unranked => 'Ohne Rang';

  @override
  String get practiceFirst => 'Erst üben';

  @override
  String get noConnection => 'Keine Verbindung';

  @override
  String get practiceOffline => 'Offline üben';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get youWonPlain => 'Du hast gewonnen';

  @override
  String get cameraNeededTitle => 'Kamerazugriff nötig';

  @override
  String get cameraNeededBody =>
      'outrepd zählt deine Wiederholungen, indem es deine Bewegung beobachtet. Die Erkennung läuft auf deinem Gerät, nichts wird hochgeladen.';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get allowCamera => 'Kamera erlauben';

  @override
  String get notNow => 'Jetzt nicht';

  @override
  String get noCameraTitle => 'Keine Kamera gefunden';

  @override
  String get noCameraBody =>
      'Wiederholungen werden über die Kamera gezählt, dieses Gerät kann also kein Duell werten. Alles andere funktioniert weiter.';

  @override
  String get noConnectionBody => 'Für ein Duell brauchst du eine Verbindung. Abenteuer geht auch offline, deine Wiederholungen werden später synchronisiert.';

  @override
  String get getBackInFrame => 'Zurück ins Bild';

  @override
  String get clockStillRunning =>
      'Die Uhr läuft weiter. Es wird nicht gezählt.';

  @override
  String get giveUp => 'Aufgeben';

  @override
  String get lpMovesWithGap => 'Sieg: +25 plus der Wiederholungsunterschied. Niederlage: −20 plus der Unterschied.';

  @override
  String get searchingForOpponent => 'Gegner wird gesucht';

  @override
  String get getIntoPosition => 'Geh in Position';

  @override
  String get framingHint => 'Handgelenke und Knöchel müssen im Bild sein';

  @override
  String get goUp => 'Hoch';

  @override
  String get goDown => 'Runter';

  @override
  String get bestSet => 'Bester Satz';

  @override
  String get record => 'Bilanz';

  @override
  String get last7Days => 'Letzte 7 Tage';

  @override
  String repsCount(String count) {
    return '$count Wdh.';
  }

  @override
  String get viewAll => 'Alle ansehen';

  @override
  String get shareProfile => 'Profil teilen';

  @override
  String get share => 'Teilen';

  @override
  String get duelMeOnOutrepd => 'Fordere mich auf outrepd heraus';

  @override
  String get shareStory => 'Story';

  @override
  String get sharePost => 'Beitrag';

  @override
  String get copyLink => 'Kopieren';

  @override
  String get linkCopied => 'Link kopiert';

  @override
  String get currentRankLabel => 'Aktueller Rang';

  @override
  String get winInitial => 'S';

  @override
  String get lossInitial => 'N';

  @override
  String get dayInitial => 'T';

  @override
  String friendsRankLine(String place, String count) {
    return 'Du bist #$place von $count';
  }

  @override
  String rankPosition(String n) {
    return '#$n';
  }

  @override
  String get obTagline =>
      'Liegestütz-Duelle. Dein Handy zählt. Jemand anderes zählt auch.';

  @override
  String get obGetStarted => 'Los geht’s';

  @override
  String get obHaveAccount => 'Ich habe schon ein Konto';

  @override
  String get obTwoThings => 'Zwei kurze Sachen.';

  @override
  String get obAgeQuestion => 'Wie alt bist du?';

  @override
  String get obHealthConsent =>
      'Mir ist klar, dass outrepd Wiederholungen zählt und keine medizinischen oder Trainingsratschläge gibt. Ich höre auf, wenn etwas wehtut.';

  @override
  String get obTermsIntro => 'Mit dem Fortfahren akzeptierst du die';

  @override
  String get obTerms => 'Nutzungsbedingungen';

  @override
  String get obAnd => 'und die';

  @override
  String get obPrivacy => 'Datenschutzerklärung';

  @override
  String get obCameraTitle => 'outrepd braucht deine Kamera';

  @override
  String get obCameraBody =>
      'Sie verfolgt deine Bewegung, um zu zählen. Anders geht es nicht.';

  @override
  String get obCameraPrivateTitle => 'Nichts verlässt dein Handy';

  @override
  String get obCameraPrivateBody =>
      'Die Körpererkennung läuft auf diesem Gerät. Es wird nie ein Video gespeichert oder hochgeladen.';

  @override
  String get obWhyNeeded => 'Warum wird das gebraucht?';

  @override
  String get obPlacementTitle => 'Leg dein Handy auf den Boden';

  @override
  String get obPlacementBody =>
      'Lehn es an eine Wand, etwa einen Meter vor dir.';

  @override
  String get obCheckHandsFeet => 'Kopf, Schultern und Hände im Bild';

  @override
  String get obCheckFacing => 'Zum Handy gedreht, nicht seitlich';

  @override
  String get obCheckLight => 'Licht an';

  @override
  String get obImSetUp => 'Ich bin bereit';

  @override
  String get obFramingTitle => 'Geh in die Liegestützposition';

  @override
  String get obFramingShoulders => 'Schultern und Hüfte';

  @override
  String get obFramingWrists => 'Handgelenke';

  @override
  String get obLooksGood => 'Sieht gut aus';

  @override
  String get obCalibrating => 'Kalibrierung';

  @override
  String get obOneMoreRep => 'Noch eine für deinen Bewegungsumfang';

  @override
  String get obCalibrationHint =>
      'Mach drei Liegestütze in deiner normalen Tiefe';

  @override
  String get obCalibrated => 'Kalibriert.';

  @override
  String get obCalibratedBody =>
      'outrepd kennt jetzt deinen Bewegungsumfang. Tiefe wird an dir gemessen, nicht an einer festen Zahl.';

  @override
  String get obRepsCounted => 'Gezählte Wiederholungen';

  @override
  String get obAverageDepth => 'Durchschnittliche Tiefe';

  @override
  String get obForm => 'Ausführung';

  @override
  String get obFormClean => 'Sauber';

  @override
  String get obAvailable => 'Frei';

  @override
  String get obTaken => 'Vergeben';

  @override
  String get obGotIt => 'Alles klar';

  @override
  String get obFormMixed => 'Gemischt';

  @override
  String get justNow => 'Gerade eben';

  @override
  String get counterAccuracy => 'Genauigkeit des Zählers';

  @override
  String get counterAccuracyCaption => 'Wie nah die Kamera drankommt';

  @override
  String measuredOverSets(String count) {
    return 'Gemessen über $count Sätze';
  }

  @override
  String get accExact => 'Exakt';

  @override
  String get accWithinOne => '±1 Wiederholung';

  @override
  String get accAverageMiss => 'Mittlere Abweichung';

  @override
  String get accTendsTo => 'Neigt dazu';

  @override
  String get accCountsHigh => 'zu hoch zu zählen';

  @override
  String get accCountsLow => 'zu niedrig zu zählen';

  @override
  String get accCountsEven => 'weder zu hoch noch zu niedrig';

  @override
  String get accWorstMiss => 'Größte Abweichung';

  @override
  String get accNothingYet => 'Noch nichts gemessen';

  @override
  String get accNothingYetBody =>
      'Jedes Mal, wenn du nach einem Trainingssatz die Zahl bestätigst, wird dieser Satz an deiner Angabe gemessen. Das Ergebnis steht dann hier.';

  @override
  String accNeedMore(String count) {
    return 'Noch früh. Etwa $count Sätze mehr, bis diese Zahl viel aussagt.';
  }

  @override
  String get accRecentSets => 'Letzte Sätze';

  @override
  String get accCameraSaid => 'Kamera';

  @override
  String get accYouSaid => 'Du';

  @override
  String get accHowItWorks =>
      'Das kommt von dir, auf diesem Handy. Nichts wird irgendwohin gesendet.';

  @override
  String levelNumber(String n) {
    return 'Level $n';
  }

  @override
  String get youLostPlain => 'Verloren';

  @override
  String get rematch => 'Revanche';

  @override
  String get shareAction => 'Teilen';

  @override
  String get doneAction => 'Fertig';

  @override
  String get continueAction => 'Weiter';

  @override
  String get promotedLabel => 'Aufgestiegen';

  @override
  String get highestReached => 'Dein höchster Stand';

  @override
  String repsOff(String n) {
    return '$n Wiederholungen dahinter.';
  }

  @override
  String get closestYet => 'Bisher das knappste Duell.';

  @override
  String repsAhead(String n) {
    return '$n Wiederholungen vorn.';
  }

  @override
  String get winnerLabel => 'Sieger';

  @override
  String get newPersonalBest => 'Neue Bestleistung';

  @override
  String get cantReachServer =>
      'Server nicht erreichbar. Prüf deine Verbindung und versuch es noch mal.';

  @override
  String pushUpsInSeconds(String seconds) {
    return 'Liegestütze in $seconds Sekunden';
  }

  @override
  String beatOpponent(String name, String score) {
    return '$name geschlagen, $score';
  }

  @override
  String lostToOpponent(String name, String score) {
    return 'Gegen $name verloren, $score';
  }

  @override
  String get thinkYouCanBeatMe => 'Glaubst du, du schlägst mich?';

  @override
  String get usernameNotAllowed =>
      'Dieser Name ist nicht erlaubt. Versuch einen anderen.';

  @override
  String get yourBest => 'Deine Bestmarke';

  @override
  String get theClock => 'Die Uhr';

  @override
  String get nobodyFreeRaceBest =>
      'Gerade ist niemand in deiner Nähe im Ranking frei. Tritt gegen deine Bestmarke an. Diese Runde ändert deinen Rang nicht.';

  @override
  String get nobodyFreeFirstScore =>
      'Gerade ist niemand in deiner Nähe im Ranking frei. Stell deine erste Bestmarke auf. Diese Runde ändert deinen Rang nicht.';

  @override
  String bestStillIs(String count) {
    return 'Deine Bestmarke bleibt $count';
  }

  @override
  String get setInPoolTitle => 'Dein Satz ist im Pool';

  @override
  String get setInPoolBody =>
      'Der nächste Sportler in deiner Nähe im Ranking tritt dagegen an. Wer gewonnen hat, siehst du in den Mitteilungen, und dann bewegt sich dein Rang.';

  @override
  String get obWhyNeededBody =>
      'Jede Wiederholung wird danach bewertet, wie tief du runtergehst und wie hoch du wieder hochkommst, und das sieht nur die Kamera. Ohne sie gibt es keine Zählung und ohne Zählung kein Duell. Die Kamera ist nur während eines Satzes an.';

  @override
  String get obWelcomeBack => 'Willkommen zurück';

  @override
  String obTitlesHeading(String count) {
    return '$count Titel zu verdienen';
  }

  @override
  String get obTitlesBody =>
      'Für Siege, Serien, saubere Sätze, frühe Morgen und mehr. Trag einen unter deinem Namen.';

  @override
  String get obFriendsHeading => 'Macht es unter Freunden aus';

  @override
  String get obFriendsBody =>
      'Freunde fügen dich mit diesem Code hinzu. Fordere sie heraus, wann du willst – der Stand zwischen euch wird gespeichert.';

  @override
  String get obLetsGo => 'Auf geht’s';

  @override
  String get paywallTitle => 'Steig von Eisen bis Meister auf';

  @override
  String get paywallPerkDuels => 'Duelle, von der Kamera gewertet';

  @override
  String get paywallPerkLadder => 'Live-Rangliste';

  @override
  String get paywallPerkFriends => 'Freunde und Herausforderungen';

  @override
  String get paywallPerkHistory => 'Jede Wiederholung jedes Matches';

  @override
  String get paywallYearly => 'Jährlich';

  @override
  String get paywallWeekly => 'Wöchentlich';

  @override
  String paywallPerWeek(String price) {
    return '${price}/Woche';
  }

  @override
  String get paywallEveryWeek => 'pro Woche';

  @override
  String paywallSave(String percent) {
    return '${percent} % sparen';
  }

  @override
  String get paywallRenewsPlay => 'Verlängert sich automatisch bis zur Kündigung. Jederzeit in Google Play kündbar.';

  @override
  String get paywallRenewsApple => 'Verlängert sich automatisch bis zur Kündigung. Jederzeit in den Einstellungen deines Apple-Accounts kündbar.';

  @override
  String get paywallRestore => 'Wiederherstellen';

  @override
  String get paywallTerms => 'AGB';

  @override
  String get paywallPrivacy => 'Datenschutz';

  @override
  String get paywallLoadFailed => 'Die Abos konnten nicht geladen werden. Prüfe deine Verbindung und versuch es erneut.';

  @override
  String get paywallBuyFailed => 'Der Kauf wurde nicht abgeschlossen. Versuch es erneut.';

  @override
  String get paywallPending => 'Deine Zahlung ist ausstehend. Alles wird freigeschaltet, sobald der Store sie bestätigt.';

  @override
  String get paywallNothingToRestore => 'Kein Abo zum Wiederherstellen gefunden.';

  @override
  String get paywallRestored => 'Abo wiederhergestellt';

  @override
  String paywallSignedInAs(String email) {
    return 'Angemeldet als ${email}';
  }

  @override
  String get deleteKeepsSubscription => 'Das Löschen deines Kontos kündigt dein Abo nicht – der Store rechnet es ab, nicht outrepd. Kündige es vorher in Google Play oder in den Einstellungen deines Apple-Accounts.';

  @override
  String get signOut => 'Abmelden';

  @override
  String get signOutQuestion => 'Abmelden?';

  @override
  String get signOutBody => 'Dein Konto bleibt, wie es ist – mit Rang, Verlauf und Abo. Melde dich jederzeit wieder so an wie zuvor.';

  @override
  String friendCodeInvite(String code) {
    return 'Fordere mich auf outrepd heraus. Füg mich mit meinem Freundescode ${code} hinzu\nhttps://outrepd.com';
  }

  @override
  String get soundsLabel => 'Töne';

  @override
  String get soundsHint => 'Ein Piep bei 3, 2, 1, ein Tick pro Wiederholung und das Rundenende. Über deiner Musik.';

  @override
  String get phoneSection => 'Auf diesem Handy';

  @override
  String get allowNotifications => 'Mitteilungen erlauben';

  @override
  String get allowNotificationsHint => 'Sie sind für OUTREPD in den Handy-Einstellungen aus, also kommt nichts von unten bei dir an.';

  @override
  String get remindersSection => 'Erinnerung';

  @override
  String get dailyReminder => 'Tägliche Erinnerung';

  @override
  String get dailyReminderHint => 'Nur an Tagen, an denen dein Ziel noch offen ist.';

  @override
  String get reminderTime => 'Uhrzeit';

  @override
  String get reminderTitle => 'Zeit für die Liegestütze von heute';

  @override
  String reminderStreakBody(String count) {
    return 'Halte deine Serie von ${count} Tagen. Ein Satz reicht.';
  }

  @override
  String get channelMatches => 'Matches und Freunde';

  @override
  String get channelReminders => 'Tägliche Erinnerung';

  @override
  String get liveTag => 'Live';

  @override
  String get reconnecting => 'Verbinde neu';

  @override
  String get rankedLive => 'Gewertet · live';

  @override
  String get lookingForLive => 'Suche einen Live-Gegner';

  @override
  String ofTime(String time) {
    return 'von ${time}';
  }

  @override
  String liveFallbackAt(String time) {
    return 'Bei ${time} trittst du stattdessen gegen einen gespeicherten Satz an';
  }

  @override
  String liveFoundBody(String name) {
    return '${name} ist jetzt vor der Kamera. Gleiche Uhr, gleicher Start.';
  }

  @override
  String get nobodyLiveTitle => 'Gerade ist niemand live';

  @override
  String get nobodyLiveBody => 'Du trittst gegen einen gespeicherten Satz an';

  @override
  String didRepsIn(String reps) {
    return 'Hat ${reps} in 60 Sekunden geschafft';
  }

  @override
  String get sameRankPoints => 'Gleiche Rangpunkte wie ein Live-Match';

  @override
  String get raceIt => 'Antreten';

  @override
  String get onlineNow => 'Gerade online';

  @override
  String get friendlyNoRank => 'Freundschaftlich · ohne Wertung';

  @override
  String waitingForName(String name) {
    return 'Warte auf ${name}';
  }

  @override
  String get weSentThemANotice => 'Wir haben eine Mitteilung geschickt';

  @override
  String get untilInviteRunsOut => 'bis die Einladung abläuft';

  @override
  String get cancelInvite => 'Einladung zurückziehen';

  @override
  String inviteDeclined(String name) {
    return '${name} hat gerade keine Zeit';
  }

  @override
  String get inviteRanOut => 'Die Einladung ist abgelaufen';

  @override
  String get inviteAgain => 'Erneut einladen';

  @override
  String liveInviteFrom(String name) {
    return '${name} ist live';
  }

  @override
  String timeLeft(String time) {
    return 'Noch ${time}';
  }

  @override
  String get joinLive => 'Beitreten';

  @override
  String get nPassedTitle => 'Du wurdest überholt';

  @override
  String nPassedBody(String name) {
    return '${name} hat dich gerade in der Wochenwertung überholt. Hol dir deinen Platz zurück.';
  }

  @override
  String get reminderWeekCloses => 'Die Wochenwertung endet in 6 Stunden. Ein Sieg mehr kann dich nach oben bringen.';

  @override
  String get nLiveTitle => 'Live-Einladung';

  @override
  String nLiveBody(String name) {
    return '${name} will live gegen dich antreten';
  }

  @override
  String get inviteGone => 'Diese Einladung ist abgelaufen';

  @override
  String opponentDropped(String name) {
    return 'Die Verbindung von ${name} ist weg. Mach weiter: Die Runde endet mit der Uhr.';
  }

  @override
  String opponentGaveUp(String name) {
    return '${name} hat aufgegeben. Beende die Runde und hol dir den Sieg.';
  }

  @override
  String get calledOffTitle => 'Match abgesagt';

  @override
  String calledOffBody(String name) {
    return '${name} ist nicht rechtzeitig zum Start gekommen. Es wurde nichts gewertet.';
  }

  @override
  String waitingForFinal(String name) {
    return 'Warte auf das Endergebnis von ${name} …';
  }

  @override
  String get wantsToBeFriends => 'möchte befreundet sein';

  @override
  String get giveUpQuestion => 'Diese Runde aufgeben?';

  @override
  String get giveUpBody => 'Es zählt als Niederlage, egal wie viele du gerade hast.';

  @override
  String waitingToJoin(String name) {
    return 'Warte, bis ${name} beitritt';
  }

  @override
  String get removeFriend => 'Freund entfernen';

  @override
  String get removeFriendBody => 'Die Person wird nicht benachrichtigt, und ihr könnt euch wieder hinzufügen';

  @override
  String removeFriendQuestion(String username) {
    return '${username} aus deinen Freunden entfernen?';
  }

  @override
  String get removeAction => 'Entfernen';

  @override
  String removedFriend(String username) {
    return '${username} ist nicht mehr in deinen Freunden';
  }

  @override
  String get noticeChallenged => 'Jemand hat mich zur Revanche herausgefordert';

  @override
  String get noticeLiveInvite => 'Ein Freund hat mich zu einem Live-Duell eingeladen';

  @override
  String get obIdeaTitle => '60 Sekunden. Ein Gegner.';

  @override
  String get obIdeaRival => 'Ein echter Mensch – live oder sein aufgezeichneter Satz';

  @override
  String get obIdeaCamera => 'Deine Kamera zählt jede Wiederholung – auf deinem Handy';

  @override
  String get thisMonth => 'Dieser Monat';

  @override
  String shortDays(String n) {
    return '${n} T.';
  }

  @override
  String shortHours(String n) {
    return '${n} Std.';
  }

  @override
  String get awardChampion => 'Champion';

  @override
  String get awardPodium => 'Podium';

  @override
  String get awardTop10 => 'Top 10';

  @override
  String get awardRegular => '20er-Club';

  @override
  String monthToTop10(String lp) {
    return 'Noch ${lp} Pkt. bis zur Top 10';
  }

  @override
  String monthIfEndedNow(String award) {
    return '${award}, wenn der Monat jetzt enden würde';
  }

  @override
  String get monthJoinHint => 'Spiel ein gewertetes Duell, um auf die Monatsliste zu kommen';

  @override
  String monthRegularProgress(String progress) {
    return 'Abzeichen 20er-Club · ${progress} gewertete Duelle';
  }

  @override
  String get monthRegularEarned => 'Abzeichen 20er-Club diesen Monat verdient';

  @override
  String get monthEmptyTitle => 'Ein neuer Monat';

  @override
  String get monthEmptyBody => 'Diesen Monat hat noch niemand gepunktet. Gewinn das erste gewertete Duell und du führst.';

  @override
  String get weekEmptyTitle => 'Eine neue Woche';

  @override
  String get weekEmptyBody => 'Diese Woche hat noch niemand gepunktet. Gewinn das erste gewertete Duell und du führst.';

  @override
  String get ratingUnit => 'Wertung';

  @override
  String get ptsUnit => 'Pkt.';

  @override
  String ptsAmount(String n) {
    return '${n} Pkt.';
  }

  @override
  String ratingAmount(String n) {
    return '${n} Wertung';
  }

  @override
  String ratingForWin(String n) {
    return '${n} für den Sieg';
  }

  @override
  String ratingForLoss(String n) {
    return '${n} für die Niederlage';
  }

  @override
  String ratingForReps(String n) {
    return '${n} für die Wiederholungen';
  }

  @override
  String get boardThisWeek => 'Diese Woche';

  @override
  String get boardOverall => 'Gesamt';

  @override
  String get howPointsWork => 'So zählen Punkte';

  @override
  String streakNextTen(String n) {
    return '${n} Siege in Folge: Der nächste Sieg bringt +10';
  }

  @override
  String get boardRuleWin => 'Sieg +5';

  @override
  String get boardRuleLoss => 'Niederlage −2';

  @override
  String get boardRuleStreak => '3 Siege in Folge: +10';

  @override
  String rankNext(String rank) {
    return 'Nächster: ${rank}';
  }

  @override
  String rankAt(String n) {
    return 'ab ${n}';
  }

  @override
  String toGo(String n) {
    return 'noch ${n}';
  }

  @override
  String tierStartsAt(String tier, String n) {
    return '${tier} beginnt bei ${n}';
  }

  @override
  String rankedDuelsCount(String n) {
    return '${n} gewertete Duelle';
  }

  @override
  String get monthlyAwards => 'Monatsauszeichnungen';

  @override
  String get seasonOver => 'Saison vorbei';

  @override
  String get seasonOverBody => 'Es steht jetzt in deinem Profil. Der neue Monat beginnt bei null.';

  @override
  String get seasonPlayCta => 'Den neuen Monat spielen';

  @override
  String monthWinners(String month) {
    return 'Gewinner im ${month}';
  }

  @override
  String get playShort => 'Spielen';

  @override
  String get rematchLive => 'Live-Revanche';

  @override
  String rematchWaiting(String name) {
    return 'Warte auf ${name}';
  }

  @override
  String rematchAsked(String name) {
    return '${name} will eine Revanche';
  }

  @override
  String get rematchGone => 'Diesmal keine Revanche';

  @override
  String get twoRankedADay => 'Freundschaftlich · 2 gewertete pro Tag mit derselben Person';

  @override
  String monthMove(String move) {
    return 'Dieser Monat · ${move}';
  }

  @override
  String promotedFrom(String rank) {
    return 'von ${rank}';
  }

  @override
  String liveOnlineNow(String n) {
    return '${n} gerade online';
  }

  @override
  String liveSearchingNow(String n) {
    return '${n} suchen';
  }

  @override
  String get dailyGoalTitle => 'Tagesziel';

  @override
  String get dailyGoalDone => 'Für heute geschafft';

  @override
  String dailyGoalProgress(String progress) {
    return '${progress} Liegestütze';
  }

  @override
  String dailyGoalLeft(String n) {
    return 'noch ${n}';
  }

  @override
  String get dailyGoalChange => 'Ändern';

  @override
  String get dailyGoalPick => 'Dein Tagesziel';

  @override
  String dailyGoalOption(String n) {
    return '${n} Liegestütze am Tag';
  }

  @override
  String widgetGoalOf(String goal) {
    return 'von ${goal} heute';
  }

  @override
  String get saveToAppleHealth => 'Trainings in Apple Health sichern';

  @override
  String get saveToHealthConnect => 'Trainings in Health Connect sichern';

  @override
  String get saveToHealthHint => 'Jeder Satz wird als Krafttraining eingetragen. Gelesen wird nichts.';

  @override
  String get healthNotAllowed => 'Noch nicht erlaubt. Du kannst es in den Gesundheitseinstellungen deines Handys erlauben.';

  @override
  String reminderLeft(String count) {
    return 'Noch ${count} Liegestütze bis zu deinem Tagesziel.';
  }

  @override
  String get liveInviteHint => 'Freunde, die online sind, können sofort mitmachen. Die anderen bekommen eine Nachricht und eine Minute Zeit.';

  @override
  String get requestSentShort => 'Anfrage gesendet';

  @override
  String healthWorksWith(String health) {
    return 'OUTREPD funktioniert mit ${health}';
  }

  @override
  String healthCardBody(String health) {
    return 'Jeder Satz, den du beendest, wird in ${health} als Krafttraining gespeichert. OUTREPD liest nie deine Gesundheitsdaten.';
  }

  @override
  String savedToHealth(String health) {
    return 'In ${health} gespeichert';
  }

  @override
  String get usernameTooShort => 'Zu kurz: mindestens 4 Zeichen';

  @override
  String get usernameBadCharacters => 'Nur Buchstaben, Zahlen und _';

  @override
  String get usernameNeedsLetter => 'Mindestens ein Buchstabe oder eine Zahl';

  @override
  String usernameChangeAgainOn(String date) {
    return 'Du kannst ihn am ${date} wieder ändern';
  }

  @override
  String get continueWithApple => 'Weiter mit Apple';

  @override
  String get continueWithGoogle => 'Weiter mit Google';

  @override
  String get socialSignInFailed => 'Anmeldung fehlgeschlagen. Versuch es noch mal.';

  @override
  String get chooseUsernameTitle => 'Wähle deinen Benutzernamen';

  @override
  String get chooseUsernameSubtitle => 'So finden dich andere und sehen dich in den Ranglisten.';

  @override
  String get authHeroTitle => 'SCHLAG JEDEN.';

  @override
  String get authHeroSubtitle => 'Live-Liegestütz-Duelle, gezählt von deiner Kamera.';

  @override
  String get createAccountPitch => 'Dein Rang und deine Duelle, auf jedem Handy.';

  @override
  String get usernameSpacesHint => 'Leerzeichen werden zu _';

  @override
  String get emailCodeNote => 'Wir schicken dir einen 6-stelligen Code per E-Mail. Kein Passwort.';

  @override
  String get continueWithEmail => 'Weiter mit E-Mail';

  @override
  String get thisSeason => 'Diese Saison';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String get weekStartsAgain => 'Beginnt jeden Montag neu';

  @override
  String get lengthWeek => 'Woche';

  @override
  String get lengthMonth => 'Monat';

  @override
  String get weekJoinHint => 'Gewinn diese Woche ein Ranglisten-Duell, um auf die Liste zu kommen';

  @override
  String get weekInTop3 => 'Diese Woche in den Top 3';

  @override
  String weekToTop3(String n) {
    return '${n} Pkt. bis zu den Top 3';
  }

  @override
  String get boardActiveNote => 'Spieler, die in den letzten 30 Tagen aktiv waren';

  @override
  String get boardTieNote => 'bei Gleichstand: mehr Siege zuerst';

  @override
  String lpBreakdown(String reps, String adjust, String rank) {
    return '${reps} für die Wiederholungen · ${adjust} für einen Gegner auf ${rank}';
  }

  @override
  String levelShort(String n) {
    return 'Lv. ${n}';
  }

  @override
  String xpOf(String into, String span) {
    return '${into} / ${span} XP';
  }

  @override
  String xpToLevel(String n, String level) {
    return 'Noch ${n} XP bis Level ${level}';
  }

  @override
  String xpHow(String rep, String match) {
    return '${rep} XP pro Wiederholung, ${match} pro Sieg, nichts für eine Niederlage';
  }

  @override
  String xpGained(String n) {
    return '+${n} XP';
  }

  @override
  String xpForReps(String n) {
    return '${n} für die Wiederholungen';
  }

  @override
  String xpForMatch(String n) {
    return '${n} für das Match';
  }

  @override
  String get levelUp => 'Level-Up';

  @override
  String get levelUpBody => 'Jede Wiederholung zählt. Weiter so.';

  @override
  String giveUpAhead(String n) {
    return 'Du liegst ${n} vorn';
  }

  @override
  String giveUpBehind(String n) {
    return 'Du liegst ${n} zurück';
  }

  @override
  String get giveUpTied => 'Gleichstand';

  @override
  String get keepGoing => 'Weitermachen';

  @override
  String get stay => 'Bleiben';

  @override
  String lastN(String n) {
    return 'Letzte ${n}';
  }

  @override
  String get firstMatchForTier => 'Spiel dein erstes Match, um auf die Rangliste zu kommen. Alle starten bei Iron V.';

  @override
  String get firstMatchForBoard => 'Spiel dein erstes Match, dann stehst du auf der Liste. Alle starten bei Iron V.';

  @override
  String get playFirstMatch => 'Erstes Match spielen';

  @override
  String firstMatchTerms(String seconds) {
    return 'Ein Match · ${seconds} Sekunden';
  }

  @override
  String get placedLabel => 'Du bist auf der Rangliste';

  @override
  String get placedBody => 'Hier fangen alle an. Nur Siege bringen dich nach oben.';

  @override
  String get placedHow => 'Sieg: +25 plus der Wiederholungsunterschied. Niederlage: −20 plus der Unterschied.';

  @override
  String get levelBesideName => 'Neben deinem Namen, überall';

  @override
  String get weekRaceTitle => 'Rennen dieser Woche';

  @override
  String get streakDoneToday => 'heute erledigt';

  @override
  String get streakTrainToday => 'trainier heute für einen Tag mehr';

  @override
  String get raceChartTitle => 'So lief die Minute';

  @override
  String raceYouLead(String time) {
    return '${time} · du gehst in Führung';
  }

  @override
  String raceTheyLead(String time, String name) {
    return '${time} · ${name} geht in Führung';
  }

  @override
  String get bringFriendTitle => 'Hol einen Freund dazu';

  @override
  String get bringFriendBody => 'Schick deinen Link. Er öffnet dein Profil, wo man dich hinzufügen kann.';

  @override
  String get bringFriendShare => 'Meinen Link teilen';

  @override
  String get bringFriendShareText => 'Tritt bei OUTREPD im Liegestütz gegen mich an. 60 Sekunden, live, die Kamera zählt.';

  @override
  String orFriendCode(String code) {
    return 'oder Freundescode ${code}';
  }

  @override
  String get countryPickerTitle => 'Dein Land';

  @override
  String get countrySearch => 'Suchen';

  @override
  String get countryFromPhone => 'Von deinem Handy';

  @override
  String get countryAll => 'Alle Länder';

  @override
  String get countryChoose => 'Wähle dein Land';

  @override
  String get countryChange => 'Ändern';

  @override
  String get countryForBoard => 'Für die Rangliste deines Landes';

  @override
  String get countryLabel => 'Land';

  @override
  String get countryChanged => 'Land geändert';

  @override
  String get countryEvery14 => 'Einmal alle 14 Tage, wie dein Name';

  @override
  String get countryNotSaved => 'Dein Land konnte nicht gespeichert werden. Versuch es noch mal.';

  @override
  String get adventure => 'Abenteuer';

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
    return '${cleared} von ${total} geschafft · ohne Wertung';
  }

  @override
  String get worldIron => 'Eisenminen';

  @override
  String get worldBronze => 'Bronzedünen';

  @override
  String get worldSilver => 'Silbergipfel';

  @override
  String get worldGold => 'Goldzitadelle';

  @override
  String get worldPlatinum => 'Platingletscher';

  @override
  String get worldDiamond => 'Diamanthöhlen';

  @override
  String get worldMaster => 'Thron des Meisters';

  @override
  String worldNumber(String n) {
    return 'Welt ${n}';
  }

  @override
  String fightLevel(String level) {
    return 'Kampf: Level ${level}';
  }

  @override
  String levelHpLine(String hp, String reps) {
    return 'HP ${hp} · etwa ${reps} Liegestütze';
  }

  @override
  String get hpShort => 'HP';

  @override
  String comboTag(String n) {
    return 'KOMBO ×${n}';
  }

  @override
  String get levelCleared => 'GESCHAFFT';

  @override
  String get outOfTime => 'ZEIT UM';

  @override
  String get statPushUps => 'Liegestütze';

  @override
  String get statTimeLeft => 'übrig';

  @override
  String get statHpLeft => 'HP übrig';

  @override
  String get statXp => 'XP';

  @override
  String secondStarHint(String seconds) {
    return 'Mit ${seconds} Sekunden Rest gibt es den zweiten Stern';
  }

  @override
  String thirdStarHint(String seconds) {
    return 'Mit ${seconds} Sekunden Rest gibt es den dritten Stern';
  }

  @override
  String get fightLostHint => 'Hol dir in früheren Levels mehr Sterne: Sie schalten stärkere Waffen frei.';

  @override
  String get nextLevel => 'Nächstes Level';

  @override
  String get tryAgain => 'Nochmal';

  @override
  String get adventureMap => 'Karte';

  @override
  String get nextKicker => 'ALS NÄCHSTES';

  @override
  String nextLevelLine(String level, String hp) {
    return 'Level ${level} · HP ${hp}';
  }

  @override
  String get armory => 'Waffenkammer';

  @override
  String get armoryBody => 'Sterne schalten Waffen frei. Die Monster jeder Welt spüren nur deren eigene Waffe oder eine bessere.';

  @override
  String get equipped => 'AUSGERÜSTET';

  @override
  String perPushUp(String damage) {
    return '${damage} pro Liegestütz';
  }

  @override
  String damagePerPushUp(String damage) {
    return '${damage} Schaden pro Liegestütz';
  }

  @override
  String wasWith(String damage, String weapon) {
    return 'vorher ${damage} mit ${weapon}';
  }

  @override
  String moreStars(String count) {
    return 'noch ${count} Sterne';
  }

  @override
  String get newWeapon => 'Neue Waffe';

  @override
  String starsKicker(String count) {
    return '${count} STERNE';
  }

  @override
  String get weaponGauntlets => 'Eisenhandschuhe';

  @override
  String get weaponKnuckles => 'Bronze-Schlagring';

  @override
  String get weaponFang => 'Silberfang';

  @override
  String get weaponHammer => 'Goldhammer';

  @override
  String get weaponAxe => 'Platinaxt';

  @override
  String get weaponSpear => 'Diamantspeer';

  @override
  String get weaponSword => 'Meisterschwert';

  @override
  String get weaponCrownbreaker => 'Kronenbrecher';

  @override
  String clearFirst(String level) {
    return 'Gewinne zuerst Level ${level}';
  }

  @override
  String needsWeapon(String weapon) {
    return 'Braucht ${weapon}';
  }

  @override
  String hurtOnlyBy(String weapon) {
    return 'Nur ${weapon} oder besser kann ihm schaden';
  }

  @override
  String worldNeedsWeapon(String world, String weapon, String count) {
    return '${world} braucht ${weapon} · noch ${count} Sterne';
  }

  @override
  String rematchOpponentLeft(String name) {
    return '${name} ist gegangen · diesmal keine Revanche';
  }

  @override
  String get obNext => 'Weiter';

  @override
  String get obRaceTitle => 'Tritt gegen einen echten Menschen an.';

  @override
  String get obRaceBody => 'Wer in 60 Sekunden mehr Wiederholungen schafft, gewinnt. Live auf dem eigenen Handy – oder gegen einen aufgezeichneten Satz, wenn gerade niemand online ist.';

  @override
  String get obRepsTitle => 'Nur ganze Wiederholungen zählen.';

  @override
  String get obRepsBody => 'Die Kamera sieht, wie tief du runtergehst und wie weit du wieder hochkommst.';

  @override
  String get obRepsDown => 'Runter, bis der Balken leer ist';

  @override
  String get obRepsUp => 'Hoch, bis er voll ist';

  @override
  String get obBarGoingDown => 'Runter';

  @override
  String get obBarComingUp => 'Hoch';

  @override
  String get obBarHandOff => 'Hand vom Boden';

  @override
  String get obRepsBoth => 'Beides, mit den Händen am Boden. Eine halbe Wiederholung zählt nicht – weder bei dir noch beim Gegner.';

  @override
  String get obClimbTitle => 'Steig auf bis Master.';

  @override
  String get obClimbBody => 'Sieben Ränge, je fünf Stufen. Gewinnen bringt dich hoch; eine Niederlage kann dich einen Rang runterbringen, nie unter 1.000 Punkte.';

  @override
  String get obGoldLine => 'goldene Linie';

  @override
  String obCalibrationRule(String gold) {
    return 'Runter unter die ${gold}, wieder hoch über die obere';
  }

  @override
  String get proThanks => 'Werbung ist aus. Danke für Pro.';

  @override
  String get adAskTitle => 'Werbung hält outrepd kostenlos';

  @override
  String get adAskBody => 'Gleich fragt dein iPhone, ob Apps deine Aktivität für die Auswahl von Werbung nutzen dürfen. Mit Ja passt die Werbung besser zu dir; mit Nein siehst du trotzdem Werbung, nur weniger passende.';

  @override
  String get adAskCamera => 'Deine Kamera hat damit nichts zu tun: Das Körpertracking bleibt auf diesem Handy, egal wie du dich entscheidest.';

  @override
  String get monsterIronColossus => 'Eisenkoloss';

  @override
  String get monsterScarab => 'Skarabäus';

  @override
  String get monsterScarabPharaoh => 'Skarabäus-Pharao';

  @override
  String get monsterYeti => 'Yeti';

  @override
  String get monsterFrostYeti => 'Frostyeti';

  @override
  String get monsterYetiChieftain => 'Yeti-Häuptling';

  @override
  String get monsterGoldSoldier => 'Goldsoldat';

  @override
  String get monsterGoldKnight => 'Goldritter';

  @override
  String get monsterGoldKing => 'Goldkönig';

  @override
  String get monsterWisp => 'Irrlicht';

  @override
  String get monsterWraith => 'Gespenst';

  @override
  String get monsterFrostLich => 'Frost-Lich';

  @override
  String get monsterCrystalDrake => 'Kristallwyvern';

  @override
  String get monsterCrystalDragon => 'Kristalldrache';

  @override
  String get monsterDiamondWyrm => 'Diamantwurm';

  @override
  String get monsterShadowGuard => 'Schattenwache';

  @override
  String get monsterShadowKnight => 'Schattenritter';

  @override
  String get monsterTheMaster => 'Der Meister';

  @override
  String get monsterPebbleGolem => 'Kieselgolem';

  @override
  String get monsterStoneGolem => 'Steingolem';

  @override
  String get monsterOreGolem => 'Erzgolem';

  @override
  String get monsterMinerGolem => 'Grubengolem';

  @override
  String get monsterScarabGrub => 'Skarabäuslarve';

  @override
  String get monsterHornedScarab => 'Hornskarabäus';

  @override
  String get monsterScarabWarrior => 'Skarabäuskrieger';

  @override
  String get monsterYetiCub => 'Yeti-Junges';

  @override
  String get monsterHornedYeti => 'Hornyeti';

  @override
  String get monsterGoldRecruit => 'Goldrekrut';

  @override
  String get monsterGoldGuard => 'Goldwache';

  @override
  String get monsterShade => 'Schemen';

  @override
  String get monsterIceSpecter => 'Eisgeist';

  @override
  String get monsterCrystalHatchling => 'Kristallküken';

  @override
  String get monsterCrystalWhelp => 'Kristalljungdrache';

  @override
  String get monsterShadowSquire => 'Schattenknappe';

  @override
  String get monsterShadowLord => 'Schattenfürst';

  @override
  String monsterWarden(String name) {
    return '${name}-Wächter';
  }

  @override
  String get obPhoneSees => 'Das sollte dein Handy sehen';

  @override
  String get obPhoneSeesBody => 'Vom Scheitel bis zu den Händen, etwa einen Meter entfernt, in der Liegestützposition.';

  @override
  String get obUnder13 => 'Unter 13';

  @override
  String get obOver13 => '13 oder älter';

  @override
  String get obFor13 => 'outrepd ist ab 13.';

  @override
  String get obUnder13Blocked => 'outrepd ist ab 13. Komm wieder, wenn es so weit ist – die Liegestütze warten auf dich.';

  @override
  String get obBeforeYouLift => 'Bevor du loslegst';

  @override
  String get obFightTitle => 'Kämpf gegen Monster.';

  @override
  String get obFightBody => '140 Liegestütz-Kämpfe in sieben Welten. Jede Wiederholung trifft das Monster.';

  @override
  String obSevenWorlds(String from, String to) {
    return 'Sieben Welten, ${from} bis ${to}';
  }

  @override
  String get obWeaponsTitle => 'Sterne schalten Waffen frei';

  @override
  String get obWeaponsBody => 'Jede Welt braucht ihre eigene Waffe. Dein Rang steht nicht auf dem Spiel.';

  @override
  String get fightDefeated => 'Besiegt!';

  @override
  String get nextWeapon => 'Nächste Waffe';

  @override
  String opensWorld(String world) {
    return 'Öffnet ${world}';
  }

  @override
  String weaponAtStars(String count) {
    return 'ab ${count} Sternen';
  }

  @override
  String topTenIn(String country) {
    return 'Top 10 in ${country}';
  }

  @override
  String get challengeAction => 'Herausfordern';

  @override
  String get challengeAFriend => 'Fordere einen Freund heraus';

  @override
  String challengeYourBest(String reps, String seconds) {
    return 'Dein Bestwert: ${reps} in ${seconds} Sekunden · verschick ihn';
  }

  @override
  String challengesYou(String name) {
    return '${name} fordert dich heraus';
  }

  @override
  String get canYouBeatIt => 'Schaffst du mehr?';

  @override
  String challengeInvite(String reps, String seconds) {
    return 'Ich habe ${reps} Liegestütze in ${seconds} Sekunden geschafft. Glaubst du, du schlägst mich?';
  }

  @override
  String get vsChallengeFriendly => 'HERAUSFORDERUNG · FREUNDSCHAFT';

  @override
  String get challengesYouToBeat => 'fordert dich heraus, das zu schlagen';

  @override
  String get onThisChallenge => 'Bei dieser Herausforderung';

  @override
  String challengeTookIt(String count) {
    return '${count} haben mitgemacht';
  }

  @override
  String get challengeBeatTag => 'Geschlagen';

  @override
  String get challengeSetIt => 'hat sie gestellt';

  @override
  String get challengeFriendlyNote => 'Freundschaftlich: Deine Wertung bleibt, wie sie ist. Deine Liegestütze zählen fürs heutige Ziel.';

  @override
  String get takeTheChallenge => 'Herausforderung annehmen';

  @override
  String get challengeClosed => 'Diese Herausforderung ist beendet.';

  @override
  String challengeYouTookIt(String reps) {
    return 'Du hast mitgemacht: ${reps}.';
  }

  @override
  String challengeOpenUntil(String date) {
    return 'Offen bis ${date}';
  }

  @override
  String get youBeatIt => 'Geschafft';

  @override
  String get notThisTime => 'Diesmal nicht';

  @override
  String challengeMoreThan(String gap, String name) {
    return '${gap} mehr als ${name}.';
  }

  @override
  String challengeShortOf(String gap, String name) {
    return '${gap} weniger als ${name}.';
  }

  @override
  String challengeLevelWith(String name) {
    return 'Gleichstand mit ${name}. Einer mehr hätte gereicht.';
  }

  @override
  String challengePlace(String place, String count) {
    return 'Du bist #${place} von ${count}';
  }

  @override
  String challengeResultNote(String reps) {
    return 'Freundschaftlich · Wertung unverändert · +${reps} fürs heutige Ziel';
  }

  @override
  String challengeBack(String name) {
    return '${name} zurückfordern';
  }

  @override
  String get challengeSentBack => 'Zurückgeschickt';

  @override
  String get yourChallenge => 'Deine Herausforderung';

  @override
  String challengeBeatYou(String count) {
    return '${count} waren besser';
  }

  @override
  String get challengeRowBeat => 'war besser';

  @override
  String get challengeRowHeld => 'du hast gehalten';

  @override
  String get takeItBack => 'Zurückholen';

  @override
  String get takeItBackNote => 'Zurückholen: Tritt gegen ihren Satz an. Schlägst du ihn, erfahren sie es.';

  @override
  String get sendToMoreFriends => 'An mehr Freunde schicken';

  @override
  String get challengesTitle => 'Herausforderungen';

  @override
  String get noChallengesYet => 'Noch keine Herausforderungen. Schick eine nach einem Match oder vom Startbildschirm aus.';

  @override
  String get challengeNobodyYet => 'Noch hat niemand mitgemacht.';

  @override
  String get challengeNoSet => 'Mach zuerst eine ganze Minute, dann schick sie.';

  @override
  String get nChallengeTakenTitle => 'Deine Herausforderung wurde angenommen';

  @override
  String nChallengeBeaten(String name, String yours, String theirs) {
    return '${name} hat deine ${yours} mit ${theirs} geschlagen. Holst du sie dir zurück?';
  }

  @override
  String nChallengeHeld(String name, String yours, String theirs) {
    return '${name} hat deine Herausforderung angenommen und bei ${theirs} aufgehört. Deine ${yours} halten.';
  }

  @override
  String get nChallengeBackTitle => 'Gegenherausforderung';

  @override
  String nChallengeBackBody(String name, String theirs) {
    return '${name} hat ${theirs} geschafft und fordert dich zurück heraus.';
  }

  @override
  String get xpDoubleIt => 'Verdoppeln';

  @override
  String get xpDoubleNote => 'Ein kurzes Video, und nach diesem Match keine Werbung.';

  @override
  String get xpDoubled => '×2 verdoppelt';

  @override
  String streakEnded(String days) {
    return 'Deine Serie von ${days} Tagen ist gerissen';
  }

  @override
  String get streakBringBack => 'Hol sie mit einem kurzen Video zurück. Einmal pro Woche.';

  @override
  String get streakBringBackPro => 'Hol sie zurück. Einmal pro Woche.';

  @override
  String streakKeep(String days) {
    return 'Meine ${days} Tage behalten';
  }

  @override
  String get getPro => 'Pro holen';

  @override
  String get proTrialBody => 'Pro-Teile gibt es mit Pro. Probier dieses einen Tag gratis: Alle sehen es bis morgen an dir.';

  @override
  String get proTrialWear => 'Einen Tag gratis tragen';

  @override
  String get proTrialOn => 'Einen Tag lang deins. Alle sehen es.';

  @override
  String get rewardNotEarned => 'Das Video lief nicht bis zum Ende, also hat sich nichts geändert.';

  @override
  String get planSetupTitle => 'Werde stärker';

  @override
  String get planSetupSub => 'Ein Sechs-Wochen-Plan ab deiner besten Minute.';

  @override
  String get planYourBest => 'Deine Bestleistung';

  @override
  String get planInSixty => 'in 60 Sekunden';

  @override
  String get planNeedBest => 'Mach zuerst eine Minute, damit der Plan weiß, wo du anfängst.';

  @override
  String get planGoalCaption => 'Dein Ziel in 6 Wochen';

  @override
  String get planSteady => 'Gemütlich';

  @override
  String get planRecommended => 'Empfohlen';

  @override
  String get planHard => 'Hart';

  @override
  String get planDaysCaption => 'Tage pro Woche';

  @override
  String get planDaysUnit => 'Tage';

  @override
  String get planHowDays => 'Jeder Trainingstag: drei kurze Sätze, die die Kamera zählt.';

  @override
  String get planHowRace => 'Jeden Sonntag: ein Rennen gegen dich von letzter Woche, in deinem echten Tempo.';

  @override
  String get planDoASet => 'Einen Satz machen';

  @override
  String get planStart => 'Plan starten';

  @override
  String get planStopAsk => 'Diesen Plan beenden?';

  @override
  String get planStopBody => 'Deine Sätze und Rennen bleiben in deinem Verlauf. Du kannst sofort einen neuen Plan starten.';

  @override
  String get planStopYes => 'Beenden';

  @override
  String get planTitle => 'Dein Plan';

  @override
  String get planAnother => 'Neuen Plan starten';

  @override
  String get planChange => 'Plan ändern';

  @override
  String get planShare => 'Fortschritt teilen';

  @override
  String planStartSet(String n, String total) {
    return 'Satz ${n} von ${total} starten';
  }

  @override
  String get planExtraSet => 'Einen Extra-Satz machen';

  @override
  String planRoadTo(String goal) {
    return 'Auf dem Weg zu ${goal}';
  }

  @override
  String planDone(String start, String best) {
    return 'Plan geschafft: ${start} → ${best}';
  }

  @override
  String planWeekOf(String week, String weeks) {
    return 'Woche ${week} von ${weeks}';
  }

  @override
  String planStartedAt(String start) {
    return 'Start bei ${start}';
  }

  @override
  String get planThisWeek => 'Diese Woche';

  @override
  String planDaysDone(String done, String total) {
    return '${done} von ${total} Tagen';
  }

  @override
  String planRaced(String reps) {
    return 'Gelaufen: ${reps}';
  }

  @override
  String planToBeat(String reps) {
    return '${reps} zu schlagen';
  }

  @override
  String planToBeatSunday(String reps) {
    return '${reps} zu schlagen · ab Sonntag';
  }

  @override
  String get planRaceTitle => 'Gegen dich von letzter Woche';

  @override
  String get planRest => 'Pause';

  @override
  String get planRaceToday => 'Heute: gegen dich von letzter Woche';

  @override
  String planTodaySets(String sets, String reps) {
    return 'Heute: ${sets} Sätze à ${reps}';
  }

  @override
  String get planRestToday => 'Heute: Pause';

  @override
  String get planStartShort => 'Start';

  @override
  String planWeekShort(String week) {
    return 'W${week}';
  }

  @override
  String planShareText(String start, String best, String goal, String link) {
    return 'Von ${start} auf ${best} Liegestütze in einer Minute bei OUTREPD, auf dem Weg zu ${goal}. ${link}';
  }

  @override
  String get planToday => 'Plan für heute';

  @override
  String planCardDone(String week) {
    return 'Woche ${week} · Sätze für heute erledigt';
  }

  @override
  String planCardSets(String week, String sets, String reps, String done) {
    return 'Woche ${week} · ${sets} Sätze à ${reps} · ${done} erledigt';
  }

  @override
  String planCardRest(String week) {
    return 'Woche ${week} · Ruhetag';
  }

  @override
  String planCardRaced(String reps) {
    return 'Rennen dieser Woche: ${reps}';
  }

  @override
  String get planCardRaceSunday => 'Sonntag: gegen dich von letzter Woche';

  @override
  String get planReached => 'Ziel erreicht.';

  @override
  String planToGo(String left) {
    return 'Noch ${left} bis zu deinem Ziel.';
  }

  @override
  String get planOnTrack => 'Im Plan';

  @override
  String get planBehind => 'Etwas zurück';

  @override
  String get planBeatTitle => 'Du hast dich von letzter Woche geschlagen';

  @override
  String get planTieTitle => 'Gleichstand';

  @override
  String get planLostTitle => 'Du von letzter Woche hast gewonnen';

  @override
  String get planLevel => 'Genauso viele wie vor einer Woche.';

  @override
  String planMoreThan(String gap) {
    return '${gap} mehr als vor einer Woche.';
  }

  @override
  String planShortOf(String gap) {
    return '${gap} weniger als vor einer Woche.';
  }

  @override
  String get planYouNow => 'Du jetzt';

  @override
  String get planLastWeek => 'Letzte Woche';

  @override
  String get planLastWeeksYou => 'Du von letzter Woche';

  @override
  String vsYouVsYou(String week) {
    return 'DU GEGEN DICH · WOCHE ${week}';
  }

  @override
  String get planOffer => 'Stattdessen ein Sechs-Wochen-Plan';

  @override
  String get planOfferSub => 'Kurze Sätze an Trainingstagen und jeden Sonntag ein Rennen gegen dich von letzter Woche.';
}
