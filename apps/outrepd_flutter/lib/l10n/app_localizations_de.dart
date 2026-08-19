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
  String get tabCrew => 'Crew';

  @override
  String get tabProfile => 'Profil';

  @override
  String get searchOpponent => 'Gegner suchen';

  @override
  String get searchOpponentHint => 'Wir finden jemanden auf deinem Rang';

  @override
  String get challengeFriend => 'Freund herausfordern';

  @override
  String get trainWithCamera => 'Mit der Kamera trainieren';

  @override
  String get viewRoadmap => 'Aufstiegsweg ansehen';

  @override
  String lpProgress(int lp, int left) {
    return '$lp / 100 LP · $left bis zum Aufstieg';
  }

  @override
  String winStreak(int count) {
    return '$count Siege in Folge';
  }

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
  String get profile => 'Profil';

  @override
  String get settings => 'Einstellungen';

  @override
  String get stats => 'Statistiken';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get skip => 'Überspringen';

  @override
  String get totalMatches => 'Duelle insgesamt';

  @override
  String get bestWinStreak => 'Beste Siegesserie';

  @override
  String get totalVolume => 'Gesamtvolumen';

  @override
  String get height => 'Größe';

  @override
  String get bodyweight => 'Körpergewicht';

  @override
  String get age => 'Alter';

  @override
  String get editYourStats => 'Deine Werte bearbeiten';

  @override
  String get editStatsHint =>
      'Siege, Volumen und Rang werden verdient — nicht eingetragen.';

  @override
  String get changeName => 'Namen ändern';

  @override
  String get changeNameLast =>
      'Das ist deine letzte Änderung. Sie lässt sich nicht rückgängig machen.';

  @override
  String changeNameLeft(int total, int left) {
    return 'Du hast insgesamt $total Änderungen. Danach bleiben $left.';
  }

  @override
  String get changeNameUsedUp => 'Du hast beide Namensänderungen aufgebraucht';

  @override
  String get yourPicture => 'Dein Bild';

  @override
  String get yourPictureHint =>
      'Der Rahmen kommt von deinem Rang und ändert sich beim Aufstieg.';

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
  String titlesAndStreak(int owned, int total, int streak) {
    return '$owned von $total Titeln · $streak Tage Serie';
  }

  @override
  String get crew => 'Crew';

  @override
  String get myCrew => 'Meine Crew';

  @override
  String get rankings => 'Rangliste';

  @override
  String get trainWithCrew => 'Trainiere in einer Crew';

  @override
  String get trainWithCrewHint =>
      'Bis zu 20 Sportler unter einem Namen, ein gemeinsames Wochenziel und ein Platz in der Crew-Tabelle.';

  @override
  String get createCrew => 'Crew gründen';

  @override
  String get createCrewHint =>
      'Benenne sie, wähle ein Wappen und lade deine Leute ein';

  @override
  String get joinOpenCrew => 'Offener Crew beitreten';

  @override
  String get joinOpenCrewHint => 'Crews, die jeden aufnehmen';

  @override
  String get yourInvites => 'Deine Einladungen';

  @override
  String get yourInvitesHint => 'Crews, die nach dir gefragt haben';

  @override
  String get joinWithCode => 'Mit Code beitreten';

  @override
  String get joinWithCodeHint => 'Sechs Zeichen von einem Mitglied';

  @override
  String get topCrewsThisWeek => 'Top-Crews diese Woche';

  @override
  String get members => 'Mitglieder';

  @override
  String get repsEach => 'Wdh. pro Kopf';

  @override
  String get rank => 'Platz';

  @override
  String get weeklyGoal => 'Wochenziel';

  @override
  String get weeklyGoalDone => 'Wochenziel geknackt';

  @override
  String goalRemaining(int reps, int days) {
    return 'Noch $reps Wdh. · $days Tage übrig';
  }

  @override
  String get goalDoneHint => 'Am Ende der Woche bekommt jeder das Abzeichen.';

  @override
  String get startCrewWar => 'Crew-Krieg starten';

  @override
  String get startCrewWarHint =>
      'Sieben Tage, beide Crews zählen. Die meisten Wdh. pro Kopf gewinnen.';

  @override
  String get whoIsPulling => 'Wer die Crew trägt';

  @override
  String get thisWeek => 'diese Woche';

  @override
  String get inviteLifters => 'Sportler einladen';

  @override
  String get referralCode => 'Einladungscode';

  @override
  String get inviteLink => 'Einladungslink';

  @override
  String get leaveCrew => 'Crew verlassen';

  @override
  String get owner => 'Gründer';

  @override
  String get crewTable => 'Crew-Tabelle';

  @override
  String get repsPerMember => 'Wdh. pro Mitglied';

  @override
  String seasonResets(int days) {
    return 'Zurücksetzung in $days Tagen — alle starten gleich';
  }

  @override
  String get rankingExplained =>
      'Crews werden nach Wiederholungen pro Mitglied gewertet, nicht nach der Summe — sonst gewinnt die größte Crew allein durch ihre Größe.';

  @override
  String get leaderboard => 'Rangliste';

  @override
  String get global => 'Weltweit';

  @override
  String get myCountry => 'Mein Land';

  @override
  String yourFriends(int count) {
    return 'Deine Freunde ($count)';
  }

  @override
  String get challenge => 'Fordern';

  @override
  String get notifications => 'Mitteilungen';

  @override
  String get pickMovement => 'Übung wählen';

  @override
  String get anyExercise => 'Beliebige Übung';

  @override
  String get anyExerciseHint =>
      'Beginne deinen Satz – die Bewegung wird währenddessen erkannt';

  @override
  String get start => 'Start';

  @override
  String get finish => 'Fertig';

  @override
  String get reps => 'Wdh.';

  @override
  String get secondsHeld => 'Sekunden gehalten';

  @override
  String get learningMovement =>
      'Bewegung wird gelernt — deine Wiederholungen erscheinen gleich';

  @override
  String get recalibrate => 'Neu kalibrieren';

  @override
  String get resetCount => 'Zähler zurücksetzen';

  @override
  String get checksForm => 'prüft die Ausführung';

  @override
  String get counts => 'zählt';

  @override
  String get time => 'Zeit';

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
  String get darkMode => 'Dunkles Design';

  @override
  String get language => 'Sprache';

  @override
  String get units => 'Einheiten';

  @override
  String get weight => 'Gewicht';

  @override
  String get notificationsSection => 'Mitteilungen';

  @override
  String get privacy => 'Privatsphäre';

  @override
  String get matches => 'Duelle';

  @override
  String get data => 'Daten';

  @override
  String get about => 'Über die App';

  @override
  String get dangerZone => 'Kritischer Bereich';

  @override
  String get themeSystem => 'Wie das Gerät';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get openCrews => 'Offene Crews';

  @override
  String get openCrewsHint =>
      'Hier darf jeder rein. Eine auswählen und du bist dabei.';

  @override
  String get yourInvitesSubtitle =>
      'Crews, die dich namentlich angefragt haben.';

  @override
  String get pickOpponent => 'Wähle deinen Gegner';

  @override
  String get accept => 'Annehmen';

  @override
  String get join => 'Beitreten';

  @override
  String get copy => 'Kopieren';

  @override
  String get copied => 'Einladungslink kopiert';

  @override
  String season(String name) {
    return 'Saison $name';
  }

  @override
  String challengeSent(String name) {
    return 'Herausforderung an $name geschickt';
  }

  @override
  String get inviteFriendPrivate =>
      'Lade einen Freund zu einem privaten Duell ein';

  @override
  String get joinWithCodePaste =>
      'Füge die sechs Zeichen ein, die dir ein Mitglied geschickt hat.';

  @override
  String get enterTheCode => 'Gib den 6-stelligen Code ein';

  @override
  String get followingDevice => 'Folgt gerade deinem Gerät';

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
  String get visEveryoneHint => 'Jeder kann dein Profil öffnen';

  @override
  String get visFriendsHint => 'Nur wen du hinzugefügt hast';

  @override
  String get visNobodyHint => 'Dein Profil bleibt privat';

  @override
  String get matchInvites => 'Duell-Einladungen';

  @override
  String get matchResults => 'Duell-Ergebnisse';

  @override
  String get friendRequestsLabel => 'Freundschaftsanfragen';

  @override
  String get crewActivity => 'Crew-Aktivität';

  @override
  String get rankChanges => 'Rangänderungen';

  @override
  String get weeklySummary => 'Wochenrückblick';

  @override
  String get soundLabel => 'Ton';

  @override
  String get vibration => 'Vibration';

  @override
  String get whoCanSeeProfile => 'Wer mein Profil sehen darf';

  @override
  String get profileVisibility => 'Profil-Sichtbarkeit';

  @override
  String get showOnLeaderboards => 'In Ranglisten anzeigen';

  @override
  String get allowMatchInvites => 'Duell-Einladungen zulassen';

  @override
  String get allowFriendRequests => 'Freundschaftsanfragen zulassen';

  @override
  String get showHeightWeight => 'Größe und Gewicht zeigen';

  @override
  String get showHeightWeightHint => 'Aus bleiben deine Körperdaten bei dir';

  @override
  String get autoAcceptFriends => 'Von Freunden automatisch annehmen';

  @override
  String get restTimerBetweenSets => 'Pausentimer zwischen Sätzen';

  @override
  String get exportData => 'Meine Daten exportieren';

  @override
  String get clearCache => 'Cache leeren';

  @override
  String get cacheCleared => 'Cache geleert';

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
  String get resetProgress => 'Fortschritt zurücksetzen';

  @override
  String get resetProgressTitle => 'Fortschritt zurücksetzen?';

  @override
  String get resetProgressBody =>
      'Rang, LP und Duellverlauf gehen auf null zurück. Das lässt sich nicht rückgängig machen.';

  @override
  String get actionReset => 'Zurücksetzen';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get deleteAccountTitle => 'Konto löschen?';

  @override
  String get deleteAccountBody =>
      'Dein Profil, deine Crews und jedes Duell werden endgültig entfernt.';

  @override
  String get actionDelete => 'Löschen';

  @override
  String get needsServer =>
      'Diese Funktion benötigt einen Server und ist noch nicht angebunden';

  @override
  String get getStarted => 'Los geht\'s';

  @override
  String get skipToApp => 'Direkt zur App';

  @override
  String get achievements => 'Erfolge';

  @override
  String get unlocked => 'Freigeschaltet';

  @override
  String get roadTitle => 'Der Weg zur Legende';

  @override
  String get allTiers => 'Alle Ränge';

  @override
  String get topTier => 'Höchster Rang';

  @override
  String lpToGo(int lp) {
    return '$lp LP';
  }

  @override
  String get unlockedEverything => 'Du hast alles freigeschaltet';

  @override
  String unlocksAt(String tier) {
    return 'Freigeschaltet bei $tier';
  }

  @override
  String get matchedSameGroup =>
      'Du wirst mit jemandem zusammengebracht, der dieselbe Gruppe trainiert.';

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
  String get dontGetOutrepd => 'Don\'t get OUTREPD!';

  @override
  String xOfY(int a, int b) {
    return '$a / $b';
  }

  @override
  String get tierStone => 'Stein';

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
  String get tierMythic => 'Mythisch';

  @override
  String get tierLegend => 'Legende';

  @override
  String get rewardStone => 'Steinrahmen';

  @override
  String get rewardBronze => 'Bronzeabzeichen';

  @override
  String get rewardSilver => 'Silberabzeichen';

  @override
  String get rewardGold => 'Goldabzeichen';

  @override
  String get rewardPlatinum => 'Platinabzeichen';

  @override
  String get rewardDiamond => 'Diamantabzeichen';

  @override
  String get rewardMaster => 'Meisterabzeichen';

  @override
  String get rewardMythic => 'Mythisches Abzeichen';

  @override
  String get rewardLegend => 'Legendenabzeichen';

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
    return '${w}S ${l}N';
  }

  @override
  String get yearsSuffix => 'Jahre';

  @override
  String get yourCrew => 'Deine Crew';

  @override
  String get crewName => 'Crew-Name';

  @override
  String get motto => 'Motto';

  @override
  String get mottoHint => 'Wofür steht diese Crew?';

  @override
  String get country => 'Land';

  @override
  String get whoCanJoin => 'Wer beitreten darf';

  @override
  String get minimumRank => 'Mindestrang';

  @override
  String get anyone => 'Alle';

  @override
  String get emblem => 'Wappen';

  @override
  String get colour => 'Farbe';

  @override
  String get createCrewButton => 'Crew gründen';

  @override
  String get ownerNote =>
      'Du wirst Gründer. Eine Crew fasst bis zu 20 Sportler.';

  @override
  String get searchCountries => 'Länder durchsuchen';

  @override
  String get noCountryMatch => 'Kein Land passt dazu';

  @override
  String get nameTooShort =>
      'Gib der Crew einen Namen mit mindestens 3 Zeichen';

  @override
  String get privOpen => 'Offen';

  @override
  String get privRequest => 'Auf Anfrage';

  @override
  String get privInviteOnly => 'Nur mit Einladung';

  @override
  String get privOpenHint => 'Wer den Code hat, ist sofort dabei';

  @override
  String get privRequestHint => 'Man fragt an, ein Verantwortlicher bestätigt';

  @override
  String get privInviteOnlyHint => 'Aufnahme nur per direkter Einladung';

  @override
  String get embStrength => 'Kraft';

  @override
  String get embCombat => 'Kampf';

  @override
  String get embBeasts => 'Bestien';

  @override
  String get embElements => 'Elemente';

  @override
  String get embHonours => 'Auszeichnungen';

  @override
  String get embSymbols => 'Symbole';

  @override
  String get ob1Title => 'Mach aus jeder Einheit\neinen Zweikampf';

  @override
  String get ob1Body =>
      'Trag dein Training ein und miss dich mit jemandem, der dieselbe Muskelgruppe trainiert.';

  @override
  String get ob2Title => 'Fordere deine\nFreunde';

  @override
  String get ob2Body =>
      'Schick eine private Einladung und klär, wer wirklich härter trainiert.';

  @override
  String get ob3Title => 'Steig im Rang auf';

  @override
  String get ob3Body =>
      'Jeder Sieg bringt LP. Arbeite dich von Stein bis zur Legende hoch.';

  @override
  String get ob4Title => 'Allein ist der\nAufwand schwer';

  @override
  String get ob4Body =>
      'Ohne Zuschauer fällt es leicht, den letzten Satz abzukürzen.';

  @override
  String get ob5Title => 'Werde zur\nLegende';

  @override
  String get ob5Body =>
      'Beständigkeit summiert sich. Erscheinen, überbieten, aufsteigen.';

  @override
  String get letsGo => 'Los geht\'s';

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
  String get ttl_bronze_tier => 'Raus aus dem Stein';

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
  String get ttl_mythic_tier => 'Mythisch';

  @override
  String get tdesc_mythic_tier => 'Erreiche Mythisch';

  @override
  String get ttl_legend_tier => 'Legende';

  @override
  String get tdesc_legend_tier => 'Erreiche Legende';

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
  String get ttl_iron_hold => 'Eisengriff';

  @override
  String get tdesc_iron_hold => 'Halte einen Plank zwei Minuten';

  @override
  String get ttl_statue => 'Statue';

  @override
  String get tdesc_statue => 'Halte einen Plank fünf Minuten';

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
  String get ttl_joined_up => 'Dabei';

  @override
  String get tdesc_joined_up => 'Sei in einer Crew';

  @override
  String get ttl_backbone => 'Rückgrat';

  @override
  String get tdesc_backbone => 'Führe deine Crew vier Wochen in Folge an';

  @override
  String get ttl_cornerstone => 'Eckpfeiler';

  @override
  String get tdesc_cornerstone => 'Führe deine Crew zwölf Wochen in Folge an';

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
  String get finish2 => 'Fertig';

  @override
  String get qExperience => 'Wie viel Erfahrung hast du\nmit dem Training?';

  @override
  String get expBeginner => 'Anfänger – Schon mal probiert';

  @override
  String get expIntermediate => 'Fortgeschritten – Ich trainiere regelmäßig';

  @override
  String get expAdvanced => 'Erfahren – Seit Jahren dabei';

  @override
  String get qGoal => 'Was ist dein wichtigstes\nZiel?';

  @override
  String get goalStronger => 'Stärker werden';

  @override
  String get goalConsistent => 'Beständiger werden';

  @override
  String get goalLean => 'Abnehmen und definierter werden';

  @override
  String get goalMass => 'Muskelmasse aufbauen';

  @override
  String get aboutYou => 'Auf diesem Weg geht es nur um dich ...';

  @override
  String get qThinkAbout => 'Wie oft denkst du daran,\nfit zu werden?';

  @override
  String get freqNever => 'Nie';

  @override
  String get freqSometimes => 'Manchmal';

  @override
  String get freqOften => 'Oft';

  @override
  String get freqAllTime => 'Ständig';

  @override
  String get qEnergy => 'Wie ist deine Energie\nbeim Training?';

  @override
  String get energyLow => 'Niedrig, ich fühle mich den ganzen Tag ausgelaugt';

  @override
  String get energyDrops => 'Meine Leistung fällt mitten in der Einheit ab';

  @override
  String get energyHard => 'Der letzte Satz fällt mir schwer';

  @override
  String get energyHigh => 'Hoch und gleichmäßig von Anfang bis Ende';

  @override
  String get stProgress => 'Manchmal merke ich beim Training kaum Fortschritt';

  @override
  String get stEffortTitle => 'Aufwand, den keiner sieht,\ngibt man leicht auf';

  @override
  String get stEffortBody =>
      'Wenn es niemanden gibt, dem du etwas beweisen musst, wirkt Fortschritt langsam und Mühe sinnlos';

  @override
  String get stAloneTitle => 'Allein trainieren\nist langweilig';

  @override
  String get stAloneBody =>
      'Keiner schaut zu. Keiner zählt mit. Da lässt man leicht eine Wiederholung aus – oder den ganzen Satz';

  @override
  String get qName => 'Wie sollen wir\ndich nennen?';

  @override
  String get nameHint => 'Mindestens 3 Zeichen. Das sehen deine Gegner.';

  @override
  String get basicInfo => 'Gut! Jetzt ein paar\nEckdaten';

  @override
  String get qAge => 'Wie alt bist du?';

  @override
  String get qWeight => 'Was ist dein\naktuelles Gewicht?';

  @override
  String get weightWhy =>
      'Das Körpergewicht ist nötig, um deinen Rang zu berechnen.';

  @override
  String get privateNote =>
      'Deine Angaben bleiben privat und werden mit niemandem geteilt.';

  @override
  String get qHeight => 'Wie groß bist du?';

  @override
  String get qRelate => 'Findest du dich in dem\nSatz unten wieder?';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get grindTitle => 'Mit einem Gegner\nfühlt sich die Arbeit anders an';

  @override
  String get grindBody =>
      'Jedes Duell stellt dich einem echten Gegner gegenüber: leg los und zeig, wer härter trainiert hat.';

  @override
  String get allSet => 'Alles bereit!';

  @override
  String welcomeLifter(String name) {
    return 'Willkommen, $name. Zeit, deinen ersten Gegner zu finden.';
  }

  @override
  String get lifter => 'Sportler';

  @override
  String get enterApp => 'OUTREPD betreten';

  @override
  String get commitTitle => 'Und jetzt ein Versprechen\nan deinen eigenen Weg';

  @override
  String get holdLogo =>
      'Halte das Logo gedrückt, um zu bestätigen, dass du bereit bist';

  @override
  String get expNone => 'Ich habe noch nie trainiert';

  @override
  String get iAm => 'Ich bin ...';

  @override
  String get finishMatchQ => 'Duell beenden?';

  @override
  String get finishMatchBody =>
      'Dein Volumen wird festgeschrieben und mit dem deines Gegners verglichen.';

  @override
  String get keepGoing => 'Weitermachen';

  @override
  String get forfeitQ => 'Duell aufgeben?';

  @override
  String get forfeitBody => 'Du verlierst LP, wenn du jetzt gehst.';

  @override
  String get stay => 'Bleiben';

  @override
  String get forfeit => 'Aufgeben';

  @override
  String get pickExercises => 'Wähle die Übungen, die du trainierst';

  @override
  String matchingWith(String muscle) {
    return 'Suche nach jemandem auf deinem Rang · $muscle';
  }

  @override
  String get getReady => 'BEREIT MACHEN';

  @override
  String get timeLeft => 'RESTZEIT';

  @override
  String vsName(String name) {
    return 'vs $name';
  }

  @override
  String kgTotalVolume(String unit) {
    return '$unit Gesamtvolumen';
  }

  @override
  String get finishMatch => 'DUELL BEENDEN';

  @override
  String get kgHint => 'KG';

  @override
  String get repsHint => 'WDH.';

  @override
  String get addSet => 'SATZ HINZUFÜGEN';

  @override
  String get matchComplete => 'DUELL ABGESCHLOSSEN';

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
  String get achRivalry => 'Rivalität';

  @override
  String get achRivalryHint => 'Schlage denselben Gegner 3-mal';

  @override
  String get nWonTitle => 'Du hast gewonnen!';

  @override
  String nWonBody(String name, String muscle) {
    return 'Du hast $name am $muscle-Tag geschlagen';
  }

  @override
  String get nFriendTitle => 'Neue Freundschaftsanfrage';

  @override
  String nFriendBody(String name) {
    return '$name möchte sich vernetzen';
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
}
