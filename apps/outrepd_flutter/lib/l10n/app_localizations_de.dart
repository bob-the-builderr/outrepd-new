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
  String get incDuels => 'Duell-Verlauf und LP-Änderungen';

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
  String get passwordHint => 'Passwort';

  @override
  String get codeHint => 'Bestätigungscode';

  @override
  String get createAccountTitle => 'Konto erstellen';

  @override
  String get createAccountBody =>
      'Füge eine E-Mail-Adresse und ein Passwort hinzu, damit dieses Konto nicht nur an ein Telefon gebunden ist.';

  @override
  String get createAccountAction => 'Konto erstellen';

  @override
  String get signInTitle => 'Anmelden';

  @override
  String get signInBody =>
      'Melde dich mit der E-Mail-Adresse und dem Passwort deines Kontos an.';

  @override
  String get signInAction => 'Anmelden';

  @override
  String get switchToSignIn => 'Schon ein Konto? Anmelden';

  @override
  String get switchToSignUp => 'Neu hier? Konto erstellen';

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
  String get orDivider => 'oder';

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
  String get usernameHint => 'Benutzername';

  @override
  String get usernameLabel => 'Benutzername';

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get passwordMinLength => 'Mindestens 8 Zeichen';

  @override
  String get logInSubtitle => 'Melde dich an, um deinen Rang zu behalten.';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String resetPasswordSent(String email) {
    return 'Falls es ein Konto für $email gibt, ist ein Reset-Link unterwegs.';
  }

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
  String get socialLinkFailed =>
      'Anmeldung konnte nicht abgeschlossen werden. Versuch es erneut.';

  @override
  String get showLabel => 'Zeigen';

  @override
  String get hideLabel => 'Verbergen';

  @override
  String get resetPasswordTitle => 'Neues Passwort festlegen';

  @override
  String get resetPasswordBody => 'Wähle ein neues Passwort für dein Konto.';

  @override
  String get setPasswordAction => 'Passwort festlegen';

  @override
  String get wrongEmailOrPassword =>
      'Falsche E-Mail-Adresse oder falsches Passwort.';

  @override
  String get enterCodeTitle => 'Code eingeben';

  @override
  String codeInstructions(String email) {
    return 'Gib den Code ein, den wir an $email gesendet haben.';
  }

  @override
  String get verifyAction => 'Bestätigen';

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
  String get height => 'Größe';

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
      'Muss 4 bis 20 Zeichen lang sein, nur Buchstaben und Zahlen';

  @override
  String get usernameChanged => 'Benutzername geändert';

  @override
  String get usernameAlreadyChangedBody =>
      'Du hast deine einzige Namensänderung bereits genutzt — jedes Konto bekommt genau eine.';

  @override
  String get gallery => 'Galerie';

  @override
  String get camera => 'Kamera';

  @override
  String get orPickOurs => 'Oder nimm eins von uns';

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
  String get recalibrate => 'Neu kalibrieren';

  @override
  String get resetCount => 'Zähler zurücksetzen';

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
  String get units => 'Einheiten';

  @override
  String get weight => 'Gewicht';

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
  String challengeSent(String name) {
    return 'Herausforderung an $name geschickt';
  }

  @override
  String get weightUnitTitle => 'Gewichtseinheit';

  @override
  String get heightUnitTitle => 'Größeneinheit';

  @override
  String get unitKg => 'Kilogramm (kg)';

  @override
  String get unitLb => 'Pfund (lb)';

  @override
  String get unitCm => 'Zentimeter (cm)';

  @override
  String get unitFt => 'Fuß & Zoll';

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
  String get achievements => 'Erfolge';

  @override
  String get roadTitle => 'Der Weg zum Meister';

  @override
  String get allTiers => 'Alle Ränge';

  @override
  String get topTier => 'Höchster Rang';

  @override
  String lpToGo(String lp) {
    return '$lp LP';
  }

  @override
  String get roomFriendly =>
      'Raum-Duelle sind freundschaftlich — sie zählen nicht für deinen Rang.';

  @override
  String get createRoom => 'Raum erstellen';

  @override
  String get enterCode => 'CODE EINGEBEN';

  @override
  String get joinRoom => 'Raum betreten';

  @override
  String get shareThisCode => 'Teile diesen Code';

  @override
  String get codeCopied => 'Code kopiert';

  @override
  String get pickMuscleAndStart => 'Muskel wählen und loslegen';

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
  String get shortKg => 'kg';

  @override
  String get shortLb => 'lb';

  @override
  String get shortCm => 'cm';

  @override
  String get shortFt => 'ft';

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
  String get stay => 'Bleiben';

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
  String get mgBack => 'Rücken';

  @override
  String get mgLegs => 'Beine';

  @override
  String get mgShoulders => 'Schultern';

  @override
  String get mgArms => 'Arme';

  @override
  String get mgCore => 'Rumpf';

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
    return 'vor $n Wochen';
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
  String get addFriend => 'Hinzufügen';

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
  String get findPeople => 'Leute finden';

  @override
  String get noRankYet => 'Noch kein Rang';

  @override
  String placementsForFirstTier(String count) {
    return 'Schließe $count Platzierungsduelle ab, um deinen ersten Rang zu erhalten.';
  }

  @override
  String get startPlacements => 'Platzierungen starten';

  @override
  String get unranked => 'Ohne Rang';

  @override
  String placementsTerms(String done, String total, String seconds) {
    return '$done von $total · je $seconds Sekunden';
  }

  @override
  String placementsLeft(String done, String total, String left) {
    return '$done von $total · noch $left bis zu deinem Rang';
  }

  @override
  String placementsForTier(String count) {
    return 'Schließe $count Platzierungsduelle ab, um zu sehen, wo du landest.';
  }

  @override
  String placementsDoneCount(String done, String total) {
    return '$done von $total Platzierungen abgeschlossen';
  }

  @override
  String get practiceFirst => 'Erst üben';

  @override
  String get nextPlacement => 'Nächste Platzierung';

  @override
  String get noConnection => 'Keine Verbindung';

  @override
  String get practiceOffline => 'Offline üben';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get youWonPlain => 'Du hast gewonnen';

  @override
  String opponentDisconnected(String name) {
    return '$name hat die Verbindung verloren';
  }

  @override
  String get forfeitNoMargin => 'Aufgabe · Abstand zählt nicht';

  @override
  String get findAnotherMatch => 'Neues Match suchen';

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
  String get noConnectionBody =>
      'Für ein Duell brauchst du eine Verbindung. Üben geht offline, deine Wiederholungen werden später synchronisiert.';

  @override
  String get getBackInFrame => 'Zurück ins Bild';

  @override
  String get clockStillRunning =>
      'Die Uhr läuft weiter. Es wird nicht gezählt.';

  @override
  String get giveUp => 'Aufgeben';

  @override
  String lpSwing(String gain, String loss) {
    return '+$gain / −$loss LP';
  }

  @override
  String get lpMovesWithGap =>
      'LP bewegt sich mit dem Wiederholungsunterschied — je größer dein Vorsprung, desto mehr gewinnst du';

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
  String get yourRankCard => 'Deine Rang-Karte';

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
  String get obHowTitle => 'Drei Dinge, dann bist du drin.';

  @override
  String get obHow1 => 'Stell dein Handy auf den Boden';

  @override
  String get obHow1Body => 'Lehn es an eine Wand, einen Meter vor dir.';

  @override
  String get obHow2 => 'Die Kamera zählt deine Wiederholungen';

  @override
  String get obHow2Body =>
      'Jede Wiederholung wird auf Tiefe geprüft. Halbe zählen nicht.';

  @override
  String get obHow3 => 'Sechzig Sekunden gegen jemanden';

  @override
  String get obHow3Body =>
      'Gewinn und du steigst. Verlier und du fällst. Für alle dieselben Regeln.';

  @override
  String get obTwoThings => 'Zwei kurze Sachen.';

  @override
  String get obAgeQuestion => 'Wie alt bist du?';

  @override
  String get obUnder16 => 'Unter 16';

  @override
  String get obOver16 => '16 oder älter';

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
  String get obUnder16Blocked =>
      'outrepd ist ab 16. Komm wieder, wenn du so weit bist — die Liegestütze laufen dir nicht weg.';

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
  String get obOneMetre => '~1 m';

  @override
  String get obFullBody => 'ganzer Körper im Bild';

  @override
  String get obCheckHandsFeet => 'Hände und Füße sichtbar';

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
  String get obFramingAnkles => 'Knöchel';

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
  String get obPlacementsBody =>
      'Fünf Duelle bestimmen deine Startliga. Noch zählt nichts gegen dich.';

  @override
  String get obFindFirstOpponent => 'Ersten Gegner finden';

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
      'Jedes Mal, wenn du nach einem Duell die Zahl bestätigst, wird dieser Satz an deiner Angabe gemessen. Das Ergebnis steht dann hier.';

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
  String get lpRowWin => 'Sieg';

  @override
  String get lpRowLoss => 'Niederlage';

  @override
  String get lpRowOpponent => 'Rang des Gegners';

  @override
  String get lpRowMargin => 'Abstand';

  @override
  String get lpRowDepth => 'Tiefe';

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
      'Jede Wiederholung wird danach bewertet, wie weit deine Schultern sinken und steigen, und das sieht nur die Kamera. Ohne sie gibt es keine Zählung und ohne Zählung kein Duell. Die Kamera ist nur während eines Satzes an.';

  @override
  String get obWelcomeBack => 'Willkommen zurück';

  @override
  String get obDuelTitle =>
      'Du trittst gegen die Minute eines echten Menschen an';

  @override
  String get obDuelBody =>
      'Sein Satz wurde Wiederholung für Wiederholung aufgezeichnet. Du siehst ihn live, während du deinen machst.';

  @override
  String obDuelWinBy(String count) {
    return 'Mit $count Wiederholungen Vorsprung gewinnen';
  }

  @override
  String get obDuelLpRule =>
      'Ranglistenpunkte sind der Abstand in Wiederholungen. Hoch gewinnen heißt schnell aufsteigen.';

  @override
  String get obLadderTitle => 'Sieben Stufen zum Aufsteigen';

  @override
  String get obLadderBody =>
      'Fünf Einstufungsduelle legen fest, wo du startest. Gewinne, um aufzusteigen – eine erreichte Stufe behältst du.';

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
  String get paywallStart => 'Aufstieg starten';

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
  String get signOutBody => 'Dein Konto bleibt, wie es ist – mit Rang, Verlauf und Abo. Melde dich jederzeit mit deiner E-Mail wieder an.';

  @override
  String get shareVictory => 'SIEG';

  @override
  String get shareRematch => 'REVANCHE?';

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
  String get dailyReminderHint => 'Nur an Tagen, an denen du noch nicht trainiert hast.';

  @override
  String get reminderTime => 'Uhrzeit';

  @override
  String get reminderTitle => 'Zeit für die Liegestütze von heute';

  @override
  String get reminderBody => 'Ein kurzer Satz zählt für deine Serie.';

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
  String get sendASet => 'Satz senden';

  @override
  String get onlineNow => 'Gerade online';

  @override
  String get liveOrSetHint => 'Live müssen sie online sein. Ein Satz wartet, bis sie antreten.';

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
  String get nLiveTitle => 'Live-Einladung';

  @override
  String nLiveBody(String name) {
    return '${name} will live gegen dich antreten';
  }

  @override
  String get inviteGone => 'Diese Einladung ist abgelaufen';

  @override
  String waitingForPosition(String name) {
    return 'Warte, bis ${name} in Position ist';
  }

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
    return '${name} war nicht rechtzeitig in Position. Es wurde nichts gewertet.';
  }

  @override
  String waitingForFinal(String name) {
    return 'Warte auf das Endergebnis von ${name} …';
  }
}
