// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class LIt extends L {
  LIt([String locale = 'it']) : super(locale);

  @override
  String get tabFriends => 'Amici';

  @override
  String get tabRanks => 'Ranghi';

  @override
  String get tabMatch => 'Sfida';

  @override
  String get tabProfile => 'Profilo';

  @override
  String get challengeFriend => 'Sfida un amico';

  @override
  String get matchHistory => 'Storico sfide';

  @override
  String get allMatches => 'Tutte le sfide';

  @override
  String get wins => 'Vittorie';

  @override
  String get losses => 'Sconfitte';

  @override
  String get winRate => 'Percentuale vittorie';

  @override
  String get streak => 'Serie';

  @override
  String get settings => 'Impostazioni';

  @override
  String get accountSection => 'Account';

  @override
  String get duelSection => 'Sfida';

  @override
  String get hapticsEachRep => 'Vibrazione a ogni ripetizione';

  @override
  String get showSkeleton => 'Mostra lo scheletro';

  @override
  String get showSkeletonHint => 'Così vedi che la fotocamera ti segue';

  @override
  String get manageNotifications => 'Gestisci le notifiche';

  @override
  String switchesOn(String on, String all) {
    return '$on di $all attive';
  }

  @override
  String get whoCanChallenge => 'Chi può sfidarmi';

  @override
  String get blockedAccounts => 'Account bloccati';

  @override
  String get reportProblem => 'Segnala un problema';

  @override
  String get onDeviceNote =>
      'Il rilevamento della posa avviene su questo telefono. Nessun video o dato di posa viene caricato.';

  @override
  String get visibilitySection => 'Visibilità';

  @override
  String get showMyCountry => 'Mostra il mio paese';

  @override
  String get showMyCountryHint =>
      'Se disattivato esci dalla classifica del tuo paese';

  @override
  String get safetySection => 'Sicurezza';

  @override
  String get socialSection => 'Sociale';

  @override
  String get noticeRaced => 'Qualcuno ha sfidato la mia serie';

  @override
  String get noticeRacedHint => 'L\'unico modo per sapere di una sfida';

  @override
  String get noticeFriendOk => 'La mia richiesta è stata accettata';

  @override
  String get noticesStoredNote =>
      'Disattivare significa che non viene mai salvata, non nascosta.';

  @override
  String get notSaved => 'Non salvato';

  @override
  String get blockedIntro =>
      'Un account bloccato non può sfidarti, trovarti o inviarti richieste. Non viene avvisato.';

  @override
  String blockedWhen(String when) {
    return 'Bloccato $when';
  }

  @override
  String get unblock => 'Sblocca';

  @override
  String get noBlockedTitle => 'Nessuno bloccato';

  @override
  String get noBlockedBody =>
      'Puoi bloccare qualcuno dal suo profilo o da una segnalazione.';

  @override
  String get whatHappened => 'Cos\'è successo';

  @override
  String get reasonCheating => 'Imbrogli o ripetizioni false';

  @override
  String get reasonHarassment => 'Molestie o abusi';

  @override
  String get reasonContent => 'Contenuti inappropriati';

  @override
  String get reasonImpersonation => 'Furto d\'identità';

  @override
  String get reasonOther => 'Qualcos\'altro';

  @override
  String get addDetails => 'Aggiungi dettagli (facoltativo)';

  @override
  String get alsoBlock => 'Blocca anche questo account';

  @override
  String get sendReport => 'Invia segnalazione';

  @override
  String get reportSent => 'Segnalazione inviata';

  @override
  String get reportingThisAccount => 'Stai segnalando questo account';

  @override
  String get exportIntro =>
      'Ti inviamo per email un file con tutto ciò che il server ha su di te. Di solito ci vuole un minuto.';

  @override
  String get whatsIncluded => 'Cosa contiene';

  @override
  String get incProfile => 'Il tuo profilo e il grado';

  @override
  String get incSets => 'Ogni serie e conteggio';

  @override
  String get incDuels => 'Cronologia delle sfide e variazioni di LP';

  @override
  String get incFriends => 'Amici e account bloccati';

  @override
  String get incNotices => 'Le notifiche che hai ricevuto';

  @override
  String get noLandmarksNote =>
      'I punti della posa non ci sono, e non ci sono mai stati. La fotocamera li legge sul telefono e non vengono inviati da nessuna parte.';

  @override
  String get sendItTo => 'Invia a';

  @override
  String get emailHint => 'tu@esempio.com';

  @override
  String get createAccountTitle => 'Crea account';

  @override
  String get createAccountBody => 'Accedi perché questo account non dipenda da un solo telefono.';

  @override
  String get createAccountAction => 'Crea account';

  @override
  String get emailTakenSwitchToSignIn =>
      'Questa email ha già un account — accedi invece.';

  @override
  String get emailSignUpInvalid =>
      'Controlla email e password — minimo sei caratteri.';

  @override
  String get tooManyCodes =>
      'Troppi codici inviati — aspetta qualche minuto e riprova.';

  @override
  String get sendCodeAction => 'Invia codice';

  @override
  String get noAccountForEmail =>
      'Non abbiamo trovato nessun account con questa email.';

  @override
  String get authEntryTagline => 'Spingi. Sfida. Sali di livello.';

  @override
  String get signUpWithEmail => 'Registrati con email';

  @override
  String get alreadyHaveAccountQuestion => 'Hai già un account?';

  @override
  String get logInAction => 'Accedi';

  @override
  String get createYourAccountTitle => 'Crea il tuo account';

  @override
  String get createAccountSubtitle => 'Richiede meno di un minuto.';

  @override
  String get usernameLabel => 'Nome utente';

  @override
  String get emailLabel => 'Email';

  @override
  String get logInSubtitle => 'Accedi per mantenere il tuo grado.';

  @override
  String get checkYourEmailTitle => 'Controlla la tua email';

  @override
  String codeSentTo(String email) {
    return 'Abbiamo inviato un codice a 6 cifre a $email.';
  }

  @override
  String get didntGetIt => 'Non l\'hai ricevuto?';

  @override
  String resendInSeconds(String time) {
    return 'Reinvia tra $time';
  }

  @override
  String get wrongEmailGoBack => 'Email sbagliata? Torna indietro';

  @override
  String get usernameTaken => 'Quel nome utente è già in uso.';

  @override
  String get wrongCode => 'Codice errato o scaduto.';

  @override
  String get resendCode => 'Invia di nuovo il codice';

  @override
  String get codeResent => 'Nuovo codice inviato.';

  @override
  String signedInAs(String email) {
    return 'Accesso eseguito come $email';
  }

  @override
  String get addressNotKept =>
      'L\'indirizzo viene usato una volta e non salvato: questo account non ha un\'email.';

  @override
  String get requestMyData => 'Inviami i miei dati';

  @override
  String exportSent(String address) {
    return 'Inviato a $address';
  }

  @override
  String get deleteIntro =>
      'Questo cancella tutto in modo permanente. Non è reversibile e non può essere ripristinato.';

  @override
  String get rankLabel => 'Grado';

  @override
  String get wantCopyFirst => 'Vuoi prima una copia?';

  @override
  String get wantCopyBody =>
      'Scarica i tuoi dati prima di cancellare. Dopo non ci saranno più.';

  @override
  String typeToConfirm(String word) {
    return 'Scrivi $word per confermare';
  }

  @override
  String get deleteWord => 'ELIMINA';

  @override
  String get deletePermanently => 'Elimina per sempre';

  @override
  String get keepMyAccount => 'Tieni il mio account';

  @override
  String get save => 'Salva';

  @override
  String get cancel => 'Annulla';

  @override
  String get skip => 'Salta';

  @override
  String get yourPicture => 'La tua foto';

  @override
  String get yourPictureHint =>
      'La cornice dipende dal tuo rango e cambia man mano che sali.';

  @override
  String get couldNotUsePicture => 'Impossibile usare quella foto';

  @override
  String get couldNotSyncAvatar =>
      'La tua foto è salvata, ma non ancora sincronizzata';

  @override
  String get couldNotShareCard => 'Impossibile condividere questa card';

  @override
  String get couldNotOpenLink => 'Impossibile aprire quel link';

  @override
  String get couldNotCheckUsername =>
      'Impossibile verificare quel nome: riprova';

  @override
  String get changeUsername => 'Cambia nome utente';

  @override
  String get usernameInvalidLength =>
      'Deve avere da 4 a 20 caratteri, solo lettere, numeri e _';

  @override
  String get usernameChanged => 'Nome utente cambiato';

  @override
  String get usernameAlreadyChangedBody => 'Il nome utente si può cambiare una volta ogni 14 giorni.';

  @override
  String get gallery => 'Galleria';

  @override
  String get camera => 'Fotocamera';

  @override
  String get awards => 'Riconoscimenti';

  @override
  String get yourTitles => 'I tuoi titoli';

  @override
  String get stillToEarn => 'Ancora da conquistare';

  @override
  String get noTitlesYet => 'Nessuno per ora. Per il primo basta una sfida.';

  @override
  String get wearHint =>
      'Toccane uno per indossarlo. Comparirà accanto al tuo nome ovunque ti vedano.';

  @override
  String get worn => 'indossato';

  @override
  String get titleUnlocked => 'Titolo sbloccato';

  @override
  String get wearIt => 'Indossalo';

  @override
  String get wearItLater => 'Più tardi';

  @override
  String get dayStreak => 'giorni di fila';

  @override
  String get bestEver => 'Record';

  @override
  String get restDaysLeft => 'Giorni di riposo';

  @override
  String get restIsTraining =>
      'Il riposo fa parte dell\'allenamento. Due giorni liberi a settimana non spezzano la serie.';

  @override
  String get global => 'Globale';

  @override
  String get topPlayers => 'Migliori giocatori';

  @override
  String get yourTier => 'Il tuo livello';

  @override
  String get challenge => 'Sfida';

  @override
  String get notifications => 'Notifiche';

  @override
  String get start => 'Inizia';

  @override
  String get finish => 'Finito';

  @override
  String get reps => 'rip.';

  @override
  String get howManyReally => 'Quante ne hai fatte davvero?';

  @override
  String get howManyReallyHint =>
      'Il tuo conteggio, non quello dell\'app. È il riferimento con cui misureremo il contatore.';

  @override
  String get appearance => 'Aspetto';

  @override
  String get theme => 'Tema';

  @override
  String get language => 'Lingua';

  @override
  String get privacy => 'Privacy';

  @override
  String get data => 'Dati';

  @override
  String get about => 'Informazioni';

  @override
  String get themeSystem => 'Come il dispositivo';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get accept => 'Accetta';

  @override
  String get visEveryone => 'Tutti';

  @override
  String get visFriends => 'Solo amici';

  @override
  String get visNobody => 'Nessuno';

  @override
  String get friendRequestsLabel => 'Richieste di amicizia';

  @override
  String get showOnLeaderboards => 'Mostrami nelle classifiche';

  @override
  String get exportData => 'Esporta i miei dati';

  @override
  String get version => 'Versione';

  @override
  String get rateApp => 'Valuta OUTREPD';

  @override
  String get contactSupport => 'Contatta l\'assistenza';

  @override
  String get termsOfService => 'Termini di servizio';

  @override
  String get privacyPolicy => 'Informativa sulla privacy';

  @override
  String get openSourceLicences => 'Licenze open source';

  @override
  String get deleteAccount => 'Elimina account';

  @override
  String get needsServer =>
      'Impossibile connettersi. Controlla la connessione e riprova.';

  @override
  String get roomFriendly =>
      'Le sfide in stanza sono amichevoli: non toccano il tuo rango.';

  @override
  String get shareThisCode => 'Condividi questo codice';

  @override
  String get codeCopied => 'Codice copiato';

  @override
  String xOfY(String a, String b) {
    return '$a / $b';
  }

  @override
  String get tierIron => 'Ferro';

  @override
  String get tierBronze => 'Bronzo';

  @override
  String get tierSilver => 'Argento';

  @override
  String get tierGold => 'Oro';

  @override
  String get tierPlatinum => 'Platino';

  @override
  String get tierDiamond => 'Diamante';

  @override
  String get tierMaster => 'Maestro';

  @override
  String winLoss(String w, String l) {
    return '${w}V ${l}S';
  }

  @override
  String get continueLabel => 'Continua';

  @override
  String get ttl_first_blood => 'Primo Sangue';

  @override
  String get tdesc_first_blood => 'Completa la tua prima sfida';

  @override
  String get ttl_found_footing => 'Piede Fermo';

  @override
  String get tdesc_found_footing => 'Completa cinque sfide';

  @override
  String get ttl_regular => 'Assiduo';

  @override
  String get tdesc_regular => 'Venti sfide';

  @override
  String get ttl_fifty => 'I Cinquanta';

  @override
  String get tdesc_fifty => 'Cinquanta sfide';

  @override
  String get ttl_century => 'Centenario';

  @override
  String get tdesc_century => 'Cento sfide';

  @override
  String get ttl_veteran => 'Veterano';

  @override
  String get tdesc_veteran => 'Duecentocinquanta sfide';

  @override
  String get ttl_thousand_matches => 'Vecchia Guardia';

  @override
  String get tdesc_thousand_matches => 'Mille sfide';

  @override
  String get ttl_first_win => 'Vincitore';

  @override
  String get tdesc_first_win => 'Vinci una sfida';

  @override
  String get ttl_on_a_roll => 'In Serie';

  @override
  String get tdesc_on_a_roll => 'Vinci tre di fila';

  @override
  String get ttl_five_straight => 'Cinque di Fila';

  @override
  String get tdesc_five_straight => 'Vinci cinque di fila';

  @override
  String get ttl_unstoppable => 'Inarrestabile';

  @override
  String get tdesc_unstoppable => 'Vinci dieci di fila';

  @override
  String get ttl_untouchable => 'Intoccabile';

  @override
  String get tdesc_untouchable => 'Vinci venti di fila';

  @override
  String get ttl_giant_slayer => 'Ammazzagiganti';

  @override
  String get tdesc_giant_slayer => 'Batti qualcuno due ranghi sopra di te';

  @override
  String get ttl_comeback => 'Rimonta';

  @override
  String get tdesc_comeback => 'Vinci subito dopo tre sconfitte';

  @override
  String get ttl_nemesis => 'Nemesi';

  @override
  String get tdesc_nemesis => 'Batti lo stesso atleta cinque volte';

  @override
  String get ttl_hundred_reps => 'Partito';

  @override
  String get tdesc_hundred_reps => 'Cento ripetizioni contate';

  @override
  String get ttl_five_hundred => 'Riscaldato';

  @override
  String get tdesc_five_hundred => 'Cinquecento ripetizioni contate';

  @override
  String get ttl_the_machine => 'La Macchina';

  @override
  String get tdesc_the_machine => 'Mille ripetizioni contate';

  @override
  String get ttl_five_thousand => 'Implacabile';

  @override
  String get tdesc_five_thousand => 'Cinquemila ripetizioni contate';

  @override
  String get ttl_ten_thousand => 'Diecimila';

  @override
  String get tdesc_ten_thousand => 'Diecimila ripetizioni contate';

  @override
  String get ttl_fifty_thousand => 'Oltre il Conto';

  @override
  String get tdesc_fifty_thousand => 'Cinquantamila ripetizioni contate';

  @override
  String get ttl_first_tonne => 'Una Tonnellata';

  @override
  String get tdesc_first_tonne => 'Sposta mille chili in totale';

  @override
  String get ttl_ten_tonnes => 'Dieci Tonnellate';

  @override
  String get tdesc_ten_tonnes => 'Sposta diecimila chili';

  @override
  String get ttl_six_figures => 'Sei Cifre';

  @override
  String get tdesc_six_figures => 'Sposta centomila chili';

  @override
  String get ttl_half_million => 'Mezzo Milione';

  @override
  String get tdesc_half_million => 'Sposta cinquecentomila chili';

  @override
  String get ttl_million_kg => 'Club del Milione';

  @override
  String get tdesc_million_kg => 'Sposta un milione di chili';

  @override
  String get ttl_two_days => 'Di Nuovo Qui';

  @override
  String get tdesc_two_days => 'Allenati due giorni di fila';

  @override
  String get ttl_no_days_off => 'Nessun Giorno Libero';

  @override
  String get tdesc_no_days_off => 'Allenati sette giorni di fila';

  @override
  String get ttl_fortnight => 'Quindicina';

  @override
  String get tdesc_fortnight => 'Una serie di quattordici giorni';

  @override
  String get ttl_unbroken => 'Ininterrotto';

  @override
  String get tdesc_unbroken => 'Una serie di trenta giorni';

  @override
  String get ttl_sixty_days => 'Abitudine';

  @override
  String get tdesc_sixty_days => 'Una serie di sessanta giorni';

  @override
  String get ttl_hundred_days => 'Cento Giorni';

  @override
  String get tdesc_hundred_days => 'Una serie di cento giorni';

  @override
  String get ttl_year_round => 'Tutto l\'Anno';

  @override
  String get tdesc_year_round => 'Una serie di trecentosessantacinque giorni';

  @override
  String get ttl_perfect_week => 'Settimana Perfetta';

  @override
  String get tdesc_perfect_week => 'Allenati ogni giorno di una settimana';

  @override
  String get ttl_perfect_month => 'Mese Perfetto';

  @override
  String get tdesc_perfect_month => 'Quattro settimane perfette';

  @override
  String get ttl_bronze_tier => 'Fuori dal Ferro';

  @override
  String get tdesc_bronze_tier => 'Raggiungi Bronzo';

  @override
  String get ttl_silver_tier => 'Argentato';

  @override
  String get tdesc_silver_tier => 'Raggiungi Argento';

  @override
  String get ttl_golden_era => 'Età dell\'Oro';

  @override
  String get tdesc_golden_era => 'Raggiungi Oro';

  @override
  String get ttl_platinum_tier => 'Platino';

  @override
  String get tdesc_platinum_tier => 'Raggiungi Platino';

  @override
  String get ttl_diamond_tier => 'Mani di Diamante';

  @override
  String get tdesc_diamond_tier => 'Raggiungi Diamante';

  @override
  String get ttl_master_tier => 'Maestro';

  @override
  String get tdesc_master_tier => 'Raggiungi Maestro';

  @override
  String get ttl_clean_hands => 'Mani Pulite';

  @override
  String get tdesc_clean_hands =>
      'Una serie intera con ogni ripetizione contata';

  @override
  String get ttl_spotless => 'Impeccabile';

  @override
  String get tdesc_spotless => 'Dieci serie pulite';

  @override
  String get ttl_textbook => 'Da Manuale';

  @override
  String get tdesc_textbook => 'Cinquanta serie pulite';

  @override
  String get ttl_all_rounder => 'Completo';

  @override
  String get tdesc_all_rounder => 'Conta cinque esercizi diversi';

  @override
  String get ttl_explorer => 'Esploratore';

  @override
  String get tdesc_explorer => 'Conta quindici esercizi diversi';

  @override
  String get ttl_encyclopedia => 'Enciclopedia';

  @override
  String get tdesc_encyclopedia => 'Conta quaranta esercizi diversi';

  @override
  String get ttl_early_bird => 'Turno del Mattino';

  @override
  String get tdesc_early_bird => 'Dieci sessioni prima delle sette';

  @override
  String get ttl_sunrise_club => 'Club dell\'Alba';

  @override
  String get tdesc_sunrise_club => 'Cinquanta sessioni prima delle sette';

  @override
  String get ttl_night_owl => 'Turno di Notte';

  @override
  String get tdesc_night_owl => 'Dieci sessioni dopo le ventidue';

  @override
  String get ttl_graveyard => 'Turno di Mezzanotte';

  @override
  String get tdesc_graveyard => 'Cinquanta sessioni dopo le ventidue';

  @override
  String get ttl_not_alone => 'Non Sei Solo';

  @override
  String get tdesc_not_alone => 'Aggiungi il tuo primo amico';

  @override
  String get ttl_well_connected => 'Ben Collegato';

  @override
  String get tdesc_well_connected => 'Dieci amici';

  @override
  String get ttl_the_gym_knows => 'La Palestra Ti Conosce';

  @override
  String get tdesc_the_gym_knows => 'Cinquanta amici';

  @override
  String get forfeitQ => 'Ritirarsi dalla sfida?';

  @override
  String get forfeitBody => 'Perderai PL se esci adesso.';

  @override
  String get forfeit => 'Ritirati';

  @override
  String get getReady => 'PRONTI';

  @override
  String get you => 'TU';

  @override
  String get vs => 'VS';

  @override
  String get backToHome => 'TORNA ALLA HOME';

  @override
  String get mgChest => 'Petto';

  @override
  String get nWonTitle => 'Hai vinto!';

  @override
  String nWonBody(String name, String muscle) {
    return 'Hai battuto $name nel giorno di $muscle';
  }

  @override
  String get nFriendTitle => 'Nuova richiesta di amicizia';

  @override
  String get nRacedTitle => 'La tua serie è stata sfidata';

  @override
  String nRacedHeld(String name, String yours, String theirs) {
    return '$name ha sfidato la tua serie e non ce l\'ha fatta, $yours–$theirs';
  }

  @override
  String nRacedBeaten(String name, String theirs, String yours) {
    return '$name ha sfidato la tua serie e ha vinto, $theirs–$yours';
  }

  @override
  String get nFriendOkTitle => 'Richiesta di amicizia accettata';

  @override
  String nFriendOkBody(String name) {
    return '$name ha accettato la tua richiesta';
  }

  @override
  String nFriendBody(String name) {
    return '$name vuole entrare in contatto';
  }

  @override
  String get nChallengedTitle => 'Rivincita';

  @override
  String nChallengedBody(String name) {
    return '$name vuole la rivincita';
  }

  @override
  String get challengeSentTitle => 'Sfida inviata';

  @override
  String challengeSentBody(String name) {
    return 'Avviseremo $name. Torna quando l\'avrà affrontata.';
  }

  @override
  String get challengeNotSentTitle => 'Invio non riuscito';

  @override
  String get challengeNotSentBody =>
      'Controlla la connessione e riprova dalla scheda Match.';

  @override
  String get challengeGoneTitle => 'La sfida non c\'è più';

  @override
  String get challengeGoneBody =>
      'È già stata affrontata, oppure è stata ritirata.';

  @override
  String repsRecordedLine(String reps) {
    return '$reps ripetizioni registrate';
  }

  @override
  String get nAchTitle => 'Obiettivo sbloccato';

  @override
  String nAchBody(String title, String hint) {
    return '$title — $hint';
  }

  @override
  String get nRankTitle => 'Sei salito di rango!';

  @override
  String nRankBody(String rank) {
    return 'Hai raggiunto $rank';
  }

  @override
  String get today => 'Oggi';

  @override
  String get yesterday => 'Ieri';

  @override
  String daysAgo(String n) {
    return '$n giorni fa';
  }

  @override
  String weeksAgo(String n) {
    return '${n} settimane fa';
  }

  @override
  String lpAmount(String n) {
    return '$n PL';
  }

  @override
  String get lpUnit => 'PL';

  @override
  String get trueCountHint => 'es. 12';

  @override
  String get couldNotSaveSession => 'Impossibile salvare la sessione';

  @override
  String lpOutOf(String total) {
    return '/ $total PL';
  }

  @override
  String get noFriendsTitle => 'Ancora nessun amico';

  @override
  String get noFriendsBody =>
      'Una sfida contro qualcuno che conosci è un’altra cosa.';

  @override
  String get decline => 'Rifiuta';

  @override
  String requestSent(String name) {
    return 'Richiesta inviata a $name';
  }

  @override
  String nowFriends(String name) {
    return 'Ora tu e $name siete amici';
  }

  @override
  String get noOneFound => 'Nessuno si chiama così';

  @override
  String get noMatchesTitle => 'Ancora nessuna sfida';

  @override
  String get noMatchesBody => 'La prima comparirà qui, vinta o persa.';

  @override
  String get noNotificationsTitle => 'Niente di nuovo';

  @override
  String get noNotificationsBody =>
      'Inviti, risultati e richieste di amicizia arrivano qui.';

  @override
  String get countedThat => 'Contate in questo round';

  @override
  String get thatIsRight => 'Esatto';

  @override
  String get useMyCount => 'Usa il mio conteggio';

  @override
  String get confirmHint => 'Correggi se la fotocamera ha sbagliato.';

  @override
  String get unsureMovement =>
      'Non sono sicuro fosse il movimento giusto — controlla il numero.';

  @override
  String get noRanksYet => 'Ancora nessuna classifica';

  @override
  String get noRanksYetBody => 'Gioca un duello e la classifica si riempie.';

  @override
  String get ranksTitle => 'Ranghi';

  @override
  String get totalReps => 'Ripetizioni totali';

  @override
  String get recent => 'Recenti';

  @override
  String wonVs(String name) {
    return 'Vittoria contro ${name}';
  }

  @override
  String lostVs(String name) {
    return 'Sconfitta contro ${name}';
  }

  @override
  String hoursAgo(String n) {
    return '${n} h fa';
  }

  @override
  String toNextTier(String n, String tier) {
    return '${n} a ${tier}';
  }

  @override
  String get noMatchesYet => 'Ancora nessun duello';

  @override
  String get noMatchesYetBody => 'Il primo apparirà qui, che tu vinca o perda.';

  @override
  String get searchByUsername => 'Cerca per nome utente';

  @override
  String get incomingRequests => 'Richieste ricevute';

  @override
  String get noRequestsWaiting => 'Nessuna richiesta in attesa al momento';

  @override
  String get addFriendAction => 'Aggiungi amico';

  @override
  String get addFriendHint =>
      'Inserisci il loro nome utente, oppure il codice # dal loro profilo.';

  @override
  String get usernameOrCode => 'Nome utente o codice #';

  @override
  String get sendRequest => 'Invia richiesta';

  @override
  String onlineNowCount(String count) {
    return 'Online ora · $count';
  }

  @override
  String offlineCount(String count) {
    return 'Offline · $count';
  }

  @override
  String get invite => 'Invita';

  @override
  String get headToHeadTitle => 'Testa a testa';

  @override
  String get vsYouCaption => 'contro di te';

  @override
  String get h2hYou => 'tu';

  @override
  String get h2hThem => 'lui';

  @override
  String headToHead(String wins, String losses) {
    return '${wins}V ${losses}S contro di te';
  }

  @override
  String get neverPlayedYou => 'Mai giocato contro di te';

  @override
  String noHistoryWithThem(String username) {
    return 'Non hai ancora sfidato $username.';
  }

  @override
  String lastDuelScore(String yourReps, String theirReps, String when) {
    return 'Ultima volta: $yourReps–$theirReps, $when.';
  }

  @override
  String yourBestVsThemLine(String reps) {
    return 'Il tuo miglior punteggio contro di lui è $reps.';
  }

  @override
  String get viewFullProfile => 'Vedi profilo completo';

  @override
  String get moreOptions => 'Altre opzioni';

  @override
  String get block => 'Blocca';

  @override
  String get blockRowBody => 'Non potrà sfidarti né vedere il tuo profilo';

  @override
  String get report => 'Segnala';

  @override
  String get reportRowBody => 'Verrà esaminata entro 24 ore';

  @override
  String muteChallenges(String username) {
    return 'Silenzia le sfide di $username';
  }

  @override
  String blockedLifter(String username) {
    return '$username bloccato';
  }

  @override
  String mutedLifter(String username) {
    return '$username silenziato';
  }

  @override
  String get addFriendButton => 'Aggiungi amico';

  @override
  String get alreadyFriends => 'Amici';

  @override
  String get couldNotLoadProfile => 'Impossibile caricare questo profilo';

  @override
  String get noFriendsMatch => 'Nessuno con questo nome';

  @override
  String get yourClimb => 'La tua scalata';

  @override
  String floorKept(String tier, String rank) {
    return '$tier è tuo. Non scenderai sotto $rank.';
  }

  @override
  String dayStreakCount(String count) {
    return '$count giorni di fila';
  }

  @override
  String get findMatch => 'Trova una sfida';

  @override
  String rankedTerms(String seconds) {
    return '$seconds secondi · classificata';
  }

  @override
  String get practiceTerms => 'Allenati — senza rango, senza avversario';

  @override
  String get practiceComplete => 'ALLENAMENTO COMPLETATO';

  @override
  String get noRankYet => 'Ancora senza rango';

  @override
  String get unranked => 'Senza rango';

  @override
  String get practiceFirst => 'Prima allenati';

  @override
  String get noConnection => 'Nessuna connessione';

  @override
  String get practiceOffline => 'Allenati offline';

  @override
  String get retry => 'Riprova';

  @override
  String get youWonPlain => 'Hai vinto';

  @override
  String get cameraNeededTitle => 'Serve l’accesso alla fotocamera';

  @override
  String get cameraNeededBody =>
      'outrepd conta le ripetizioni guardando il tuo corpo muoversi. Il rilevamento gira sul tuo dispositivo e non viene caricato nulla.';

  @override
  String get openSettings => 'Apri impostazioni';

  @override
  String get allowCamera => 'Consenti fotocamera';

  @override
  String get notNow => 'Non ora';

  @override
  String get noCameraTitle => 'Nessuna fotocamera';

  @override
  String get noCameraBody =>
      'Le ripetizioni si contano con la fotocamera, quindi questo dispositivo non può valutare una sfida. Il resto funziona.';

  @override
  String get noConnectionBody => 'Per sfidare qualcuno serve una connessione. Avventura funziona offline e le ripetizioni si sincronizzeranno dopo.';

  @override
  String get getBackInFrame => 'Torna nell’inquadratura';

  @override
  String get clockStillRunning =>
      'Il tempo scorre ancora. Non si sta contando.';

  @override
  String get giveUp => 'Arrenditi';

  @override
  String get lpMovesWithGap =>
      'I PL si muovono in base al distacco nelle ripetizioni: vinci con più margine, guadagni di più';

  @override
  String get searchingForOpponent => 'Ricerca avversario';

  @override
  String get getIntoPosition => 'Mettiti in posizione';

  @override
  String get framingHint => 'Polsi e caviglie devono essere inquadrati';

  @override
  String get goUp => 'Sali';

  @override
  String get goDown => 'Scendi';

  @override
  String get bestSet => 'Serie migliore';

  @override
  String get record => 'Record';

  @override
  String get last7Days => 'Ultimi 7 giorni';

  @override
  String repsCount(String count) {
    return '$count rip.';
  }

  @override
  String get viewAll => 'Vedi tutto';

  @override
  String get shareProfile => 'Condividi profilo';

  @override
  String get share => 'Condividi';

  @override
  String get duelMeOnOutrepd => 'Sfidami su outrepd';

  @override
  String get shareStory => 'Storia';

  @override
  String get sharePost => 'Post';

  @override
  String get copyLink => 'Copia';

  @override
  String get linkCopied => 'Link copiato';

  @override
  String get currentRankLabel => 'Rango attuale';

  @override
  String get winInitial => 'V';

  @override
  String get lossInitial => 'S';

  @override
  String get dayInitial => 'g';

  @override
  String rankPosition(String n) {
    return '#$n';
  }

  @override
  String get obTagline =>
      'Sfide di flessioni. Il tuo telefono conta. Anche qualcun altro sta contando.';

  @override
  String get obGetStarted => 'Iniziamo';

  @override
  String get obHaveAccount => 'Ho già un account';

  @override
  String get obTwoThings => 'Due cose veloci.';

  @override
  String get obAgeQuestion => 'Quanti anni hai?';

  @override
  String get obHealthConsent =>
      'Ho capito che outrepd conta le ripetizioni e non dà consigli medici o di allenamento. Mi fermo se qualcosa fa male.';

  @override
  String get obTermsIntro => 'Continuando accetti i';

  @override
  String get obTerms => 'Termini';

  @override
  String get obAnd => 'e';

  @override
  String get obPrivacy => 'l’Informativa sulla privacy';

  @override
  String get obCameraTitle => 'outrepd ha bisogno della fotocamera';

  @override
  String get obCameraBody =>
      'Guarda il tuo corpo muoversi per contare. Non c’è altro modo.';

  @override
  String get obCameraPrivateTitle => 'Niente esce dal tuo telefono';

  @override
  String get obCameraPrivateBody =>
      'Il rilevamento del corpo avviene su questo dispositivo. Nessun video viene mai salvato o caricato.';

  @override
  String get obWhyNeeded => 'Perché serve?';

  @override
  String get obPlacementTitle => 'Metti il telefono a terra';

  @override
  String get obPlacementBody =>
      'Appoggialo a un muro a circa un metro davanti a te.';

  @override
  String get obCheckHandsFeet => 'Testa, spalle e mani nell’inquadratura';

  @override
  String get obCheckFacing => 'Rivolto al telefono, non di lato';

  @override
  String get obCheckLight => 'Luce accesa';

  @override
  String get obImSetUp => 'Sono pronto';

  @override
  String get obFramingTitle => 'Mettiti in posizione di flessione';

  @override
  String get obFramingShoulders => 'Spalle e bacino';

  @override
  String get obFramingWrists => 'Polsi';

  @override
  String get obLooksGood => 'Va bene così';

  @override
  String get obCalibrating => 'Calibrazione';

  @override
  String get obOneMoreRep => 'Un’altra per capire la tua escursione';

  @override
  String get obCalibrationHint =>
      'Fai tre flessioni alla tua profondità normale';

  @override
  String get obCalibrated => 'Calibrato.';

  @override
  String get obCalibratedBody =>
      'Ora outrepd conosce la tua escursione. La profondità si misura su di te, non su un numero fisso.';

  @override
  String get obRepsCounted => 'Ripetizioni contate';

  @override
  String get obAverageDepth => 'Profondità media';

  @override
  String get obForm => 'Esecuzione';

  @override
  String get obFormClean => 'Pulita';

  @override
  String get obAvailable => 'Disponibile';

  @override
  String get obTaken => 'Già preso';

  @override
  String get obGotIt => 'Capito';

  @override
  String get obFormMixed => 'Irregolare';

  @override
  String get justNow => 'Adesso';

  @override
  String get counterAccuracy => 'Precisione del contatore';

  @override
  String get counterAccuracyCaption => 'Quanto ci va vicino la fotocamera';

  @override
  String measuredOverSets(String count) {
    return 'Misurato su $count serie';
  }

  @override
  String get accExact => 'Esatto';

  @override
  String get accWithinOne => '±1 ripetizione';

  @override
  String get accAverageMiss => 'Errore medio';

  @override
  String get accTendsTo => 'Tende a';

  @override
  String get accCountsHigh => 'contare in più';

  @override
  String get accCountsLow => 'contare in meno';

  @override
  String get accCountsEven => 'né in più né in meno';

  @override
  String get accWorstMiss => 'Errore peggiore';

  @override
  String get accNothingYet => 'Ancora niente di misurato';

  @override
  String get accNothingYetBody =>
      'Ogni volta che confermi il conteggio dopo una serie di allenamento, quella serie viene confrontata con quello che hai indicato. Il risultato compare qui.';

  @override
  String accNeedMore(String count) {
    return 'È presto. Servono circa $count serie in più perché questo numero dica qualcosa.';
  }

  @override
  String get accRecentSets => 'Ultime serie';

  @override
  String get accCameraSaid => 'Fotocamera';

  @override
  String get accYouSaid => 'Tu';

  @override
  String get accHowItWorks =>
      'Vengono da te, su questo telefono. Niente viene inviato da nessuna parte.';

  @override
  String levelNumber(String n) {
    return 'Livello $n';
  }

  @override
  String get youLostPlain => 'Hai perso';

  @override
  String get rematch => 'Rivincita';

  @override
  String get shareAction => 'Condividi';

  @override
  String get doneAction => 'Fatto';

  @override
  String get continueAction => 'Continua';

  @override
  String get promotedLabel => 'Promosso';

  @override
  String get highestReached => 'Il punto più alto che hai raggiunto';

  @override
  String repsOff(String n) {
    return 'A $n ripetizioni.';
  }

  @override
  String get closestYet => 'La sfida più combattuta finora.';

  @override
  String repsAhead(String n) {
    return '$n ripetizioni di vantaggio.';
  }

  @override
  String get winnerLabel => 'Vincitore';

  @override
  String get newPersonalBest => 'Nuovo record personale';

  @override
  String get cantReachServer =>
      'Impossibile raggiungere il server. Controlla la connessione e riprova.';

  @override
  String pushUpsInSeconds(String seconds) {
    return 'Piegamenti in $seconds secondi';
  }

  @override
  String beatOpponent(String name, String score) {
    return 'Battuto $name $score';
  }

  @override
  String lostToOpponent(String name, String score) {
    return 'Perso contro $name $score';
  }

  @override
  String get thinkYouCanBeatMe => 'Pensi di potermi battere?';

  @override
  String get usernameNotAllowed =>
      'Questo nome non è consentito. Provane un altro.';

  @override
  String get yourBest => 'Il tuo record';

  @override
  String get theClock => 'Il cronometro';

  @override
  String get nobodyFreeRaceBest =>
      'Al momento nessuno vicino al tuo grado è libero. Sfida il tuo record. Questo round non cambia il tuo grado.';

  @override
  String get nobodyFreeFirstScore =>
      'Al momento nessuno vicino al tuo grado è libero. Fai il tuo primo punteggio. Questo round non cambia il tuo grado.';

  @override
  String bestStillIs(String count) {
    return 'Il tuo record resta $count';
  }

  @override
  String get setInPoolTitle => 'La tua serie è in coda';

  @override
  String get setInPoolBody =>
      'Il prossimo atleta vicino al tuo grado la sfiderà. Vedrai chi ha vinto nelle notifiche, e allora il tuo grado cambierà.';

  @override
  String get obWhyNeededBody =>
      'Ogni ripetizione è giudicata da quanto scendi e da quanto risali, e solo la fotocamera può vederlo. Senza di lei non c\'è conteggio, e senza conteggio non c\'è duello. La fotocamera è accesa solo durante una serie.';

  @override
  String get obWelcomeBack => 'Bentornato';

  @override
  String obTitlesHeading(String count) {
    return '$count titoli da conquistare';
  }

  @override
  String get obTitlesBody =>
      'Per vittorie, serie, serie pulite, mattine presto e altro. Indossane uno sotto il tuo nome.';

  @override
  String get obFriendsHeading => 'Regolate i conti tra amici';

  @override
  String get obFriendsBody =>
      'Gli amici ti aggiungono con questo codice. Sfidali quando vuoi: il punteggio tra voi viene salvato.';

  @override
  String get obLetsGo => 'Andiamo';

  @override
  String get paywallTitle => 'Sali dal Ferro al Maestro';

  @override
  String get paywallPerkDuels => 'Duelli giudicati dalla fotocamera';

  @override
  String get paywallPerkLadder => 'Classifica in tempo reale';

  @override
  String get paywallPerkFriends => 'Amici e sfide';

  @override
  String get paywallPerkHistory => 'Ogni ripetizione di ogni match';

  @override
  String get paywallYearly => 'Annuale';

  @override
  String get paywallWeekly => 'Settimanale';

  @override
  String paywallPerWeek(String price) {
    return '${price}/settimana';
  }

  @override
  String get paywallEveryWeek => 'a settimana';

  @override
  String paywallSave(String percent) {
    return 'Risparmia il ${percent}%';
  }

  @override
  String get paywallStart => 'Rimuovi pubblicità';

  @override
  String get paywallRenewsPlay => 'Si rinnova automaticamente fino alla disdetta. Disdici quando vuoi da Google Play.';

  @override
  String get paywallRenewsApple => 'Si rinnova automaticamente fino alla disdetta. Disdici quando vuoi dalle impostazioni del tuo account Apple.';

  @override
  String get paywallRestore => 'Ripristina';

  @override
  String get paywallTerms => 'Termini';

  @override
  String get paywallPrivacy => 'Privacy';

  @override
  String get paywallLoadFailed => 'Impossibile caricare i piani. Controlla la connessione e riprova.';

  @override
  String get paywallBuyFailed => 'L’acquisto non è andato a buon fine. Riprova.';

  @override
  String get paywallPending => 'Il tuo pagamento è in sospeso. Tutto si sblocca non appena lo store lo conferma.';

  @override
  String get paywallNothingToRestore => 'Nessun abbonamento da ripristinare.';

  @override
  String get paywallRestored => 'Abbonamento ripristinato';

  @override
  String paywallSignedInAs(String email) {
    return 'Accesso effettuato come ${email}';
  }

  @override
  String get deleteKeepsSubscription => 'Eliminare l’account non annulla l’abbonamento: lo addebita lo store, non outrepd. Disdicilo prima da Google Play o dalle impostazioni del tuo account Apple.';

  @override
  String get signOut => 'Esci';

  @override
  String get signOutQuestion => 'Uscire?';

  @override
  String get signOutBody => 'Il tuo account resta com’è, con rango, cronologia e abbonamento. Rientra quando vuoi nello stesso modo.';

  @override
  String get shareVictory => 'VITTORIA';

  @override
  String get shareRematch => 'RIVINCITA?';

  @override
  String friendCodeInvite(String code) {
    return 'Sfidami su outrepd. Aggiungimi con il mio codice amico ${code}\nhttps://outrepd.com';
  }

  @override
  String get soundsLabel => 'Suoni';

  @override
  String get soundsHint => 'Un bip per 3, 2, 1, un tic a ogni ripetizione e la fine del round. Sopra la tua musica.';

  @override
  String get phoneSection => 'Su questo telefono';

  @override
  String get allowNotifications => 'Consenti notifiche';

  @override
  String get allowNotificationsHint => 'Sono disattivate per OUTREPD nelle impostazioni del telefono, quindi niente di quanto sotto ti arriverà.';

  @override
  String get remindersSection => 'Promemoria';

  @override
  String get dailyReminder => 'Promemoria giornaliero';

  @override
  String get dailyReminderHint => 'Solo nei giorni in cui non hai ancora raggiunto l\'obiettivo.';

  @override
  String get reminderTime => 'Ora';

  @override
  String get reminderTitle => 'È ora dei piegamenti di oggi';

  @override
  String reminderStreakBody(String count) {
    return 'Tieni viva la tua striscia di ${count} giorni. Basta una serie.';
  }

  @override
  String get channelMatches => 'Sfide e amici';

  @override
  String get channelReminders => 'Promemoria giornaliero';

  @override
  String get liveTag => 'Live';

  @override
  String get reconnecting => 'Riconnessione';

  @override
  String get rankedLive => 'Classificata · live';

  @override
  String get lookingForLive => 'Cerco un avversario live';

  @override
  String ofTime(String time) {
    return 'di ${time}';
  }

  @override
  String liveFallbackAt(String time) {
    return 'A ${time} sfiderai invece una serie salvata';
  }

  @override
  String liveFoundBody(String name) {
    return '${name} è davanti alla fotocamera ora. Stesso cronometro, stessa partenza.';
  }

  @override
  String get nobodyLiveTitle => 'Nessuno è live ora';

  @override
  String get nobodyLiveBody => 'Sfiderai una serie salvata';

  @override
  String didRepsIn(String reps) {
    return 'Ne ha fatti ${reps} in 60 secondi';
  }

  @override
  String get sameRankPoints => 'Stessi punti classifica di una sfida live';

  @override
  String get raceIt => 'Sfidala';

  @override
  String get onlineNow => 'Online ora';

  @override
  String get friendlyNoRank => 'Amichevole · senza classifica';

  @override
  String waitingForName(String name) {
    return 'In attesa di ${name}';
  }

  @override
  String get weSentThemANotice => 'Gli abbiamo inviato una notifica';

  @override
  String get untilInviteRunsOut => 'alla scadenza dell\'invito';

  @override
  String get cancelInvite => 'Annulla invito';

  @override
  String inviteDeclined(String name) {
    return '${name} ha detto non ora';
  }

  @override
  String get inviteRanOut => 'L\'invito è scaduto';

  @override
  String get inviteAgain => 'Invita di nuovo';

  @override
  String liveInviteFrom(String name) {
    return '${name} è live';
  }

  @override
  String timeLeft(String time) {
    return 'Mancano ${time}';
  }

  @override
  String get joinLive => 'Partecipa';

  @override
  String get nLiveTitle => 'Invito live';

  @override
  String nLiveBody(String name) {
    return '${name} vuole sfidarti live';
  }

  @override
  String get inviteGone => 'Quell\'invito è scaduto';

  @override
  String opponentDropped(String name) {
    return 'La connessione di ${name} è caduta. Continua: il round finisce allo scadere del tempo.';
  }

  @override
  String opponentGaveUp(String name) {
    return '${name} si è arreso. Finisci il round per prenderti la vittoria.';
  }

  @override
  String get calledOffTitle => 'Sfida annullata';

  @override
  String calledOffBody(String name) {
    return '${name} non si è messo in posizione in tempo. Non è stato registrato nulla.';
  }

  @override
  String waitingForFinal(String name) {
    return 'In attesa del conteggio finale di ${name}…';
  }

  @override
  String get wantsToBeFriends => 'vuole essere tuo amico';

  @override
  String get giveUpQuestion => 'Arrenderti in questo round?';

  @override
  String get giveUpBody => 'Conta come sconfitta, qualunque sia il tuo conteggio ora.';

  @override
  String waitingToJoin(String name) {
    return 'In attesa che ${name} entri';
  }

  @override
  String get removeFriend => 'Rimuovi amico';

  @override
  String get removeFriendBody => 'Non viene avvisato, e potrete aggiungervi di nuovo';

  @override
  String removeFriendQuestion(String username) {
    return 'Rimuovere ${username} dai tuoi amici?';
  }

  @override
  String get removeAction => 'Rimuovi';

  @override
  String removedFriend(String username) {
    return 'Hai rimosso ${username} dai tuoi amici';
  }

  @override
  String get noticeChallenged => 'Qualcuno mi ha sfidato a una rivincita';

  @override
  String get noticeLiveInvite => 'Un amico mi ha invitato a un duello dal vivo';

  @override
  String get trialToday => 'Oggi';

  @override
  String get trialTodayBody => 'Tutti i duelli, dal vivo e classificati, sbloccati.';

  @override
  String trialDay(String day) {
    return 'Giorno ${day}';
  }

  @override
  String get trialReminderBody => 'Ti avvisiamo il giorno prima della fine della prova.';

  @override
  String get trialEndBody => 'Il tuo piano inizia. Annulla prima e non paghi nulla.';

  @override
  String trialTag(String days) {
    return '${days} giorni gratis';
  }

  @override
  String trialCta(String days) {
    return 'Inizia la mia prova gratuita di ${days} giorni';
  }

  @override
  String trialThenYearly(String price) {
    return 'Nessun pagamento ora · poi ${price}/anno';
  }

  @override
  String trialThenWeekly(String price) {
    return 'Nessun pagamento ora · poi ${price}/settimana';
  }

  @override
  String get trialEndsTitle => 'La tua prova gratuita finisce domani';

  @override
  String get trialEndsBody => 'Continua a salire, o annulla prima nelle impostazioni dell\'abbonamento.';

  @override
  String get obIdeaTitle => '60 secondi. Un avversario.';

  @override
  String get obIdeaRival => 'Una persona vera, dal vivo o la sua serie registrata';

  @override
  String get obIdeaCamera => 'La tua fotocamera conta ogni ripetizione, sul tuo telefono';

  @override
  String get thisMonth => 'Questo mese';

  @override
  String shortDays(String n) {
    return '${n} g';
  }

  @override
  String shortHours(String n) {
    return '${n} h';
  }

  @override
  String get awardChampion => 'Campione';

  @override
  String get awardPodium => 'Podio';

  @override
  String get awardTop10 => 'Top 10';

  @override
  String get awardRegular => 'Club 20';

  @override
  String monthToTop10(String lp) {
    return 'A ${lp} LP dalla top 10';
  }

  @override
  String monthIfEndedNow(String award) {
    return '${award} se il mese finisse ora';
  }

  @override
  String get monthJoinHint => 'Gioca un duello classificato per entrare nella classifica del mese';

  @override
  String monthRegularProgress(String progress) {
    return 'Badge Club 20 · ${progress} duelli classificati';
  }

  @override
  String get monthRegularEarned => 'Badge Club 20 ottenuto questo mese';

  @override
  String get monthEmptyTitle => 'Un mese nuovo';

  @override
  String get monthEmptyBody => 'Nessuno ha ancora vinto LP questo mese. Vinci il primo duello classificato e sei in testa.';

  @override
  String rankedDuelsCount(String n) {
    return '${n} duelli classificati';
  }

  @override
  String get monthlyAwards => 'Premi mensili';

  @override
  String get seasonOver => 'Stagione finita';

  @override
  String get seasonOverBody => 'Ora è sul tuo profilo. Il nuovo mese riparte da zero.';

  @override
  String get seasonPlayCta => 'Gioca il nuovo mese';

  @override
  String get rematchLive => 'Rivincita live';

  @override
  String rematchWaiting(String name) {
    return 'In attesa di ${name}';
  }

  @override
  String rematchAsked(String name) {
    return '${name} vuole la rivincita';
  }

  @override
  String get rematchGone => 'Niente rivincita stavolta';

  @override
  String get twoRankedADay => 'Amichevole · 2 classificate al giorno con lo stesso avversario';

  @override
  String monthMove(String move) {
    return 'Questo mese · ${move}';
  }

  @override
  String promotedFrom(String rank) {
    return 'da ${rank}';
  }

  @override
  String liveOnlineNow(String n) {
    return '${n} online ora';
  }

  @override
  String liveSearchingNow(String n) {
    return '${n} in cerca';
  }

  @override
  String get dailyGoalTitle => 'Obiettivo di oggi';

  @override
  String get dailyGoalDone => 'Fatto per oggi';

  @override
  String dailyGoalProgress(String progress) {
    return '${progress} flessioni';
  }

  @override
  String dailyGoalLeft(String n) {
    return 'ne mancano ${n}';
  }

  @override
  String get dailyGoalChange => 'Cambia';

  @override
  String get dailyGoalPick => 'Il tuo obiettivo giornaliero';

  @override
  String dailyGoalOption(String n) {
    return '${n} flessioni al giorno';
  }

  @override
  String widgetGoalOf(String goal) {
    return 'su ${goal} oggi';
  }

  @override
  String get saveToAppleHealth => 'Salva gli allenamenti in Salute di Apple';

  @override
  String get saveToHealthConnect => 'Salva gli allenamenti in Connessione Salute';

  @override
  String get saveToHealthHint => 'Ogni serie viene aggiunta come allenamento di forza. Non viene letto nulla.';

  @override
  String get healthNotAllowed => 'Non ancora consentito. Puoi consentirlo nelle impostazioni salute del telefono.';

  @override
  String reminderLeft(String count) {
    return 'Mancano ${count} piegamenti al tuo obiettivo di oggi.';
  }

  @override
  String get liveInviteHint => 'Gli amici online possono unirsi subito. Gli altri ricevono un avviso e hanno un minuto per unirsi.';

  @override
  String get requestSentShort => 'Richiesta inviata';

  @override
  String healthWorksWith(String health) {
    return 'OUTREPD funziona con ${health}';
  }

  @override
  String healthCardBody(String health) {
    return 'Ogni serie che completi viene salvata in ${health} come allenamento di forza. OUTREPD non legge mai i tuoi dati sulla salute.';
  }

  @override
  String savedToHealth(String health) {
    return 'Salvato in ${health}';
  }

  @override
  String get usernameTooShort => 'Troppo corto: almeno 4 caratteri';

  @override
  String get usernameBadCharacters => 'Solo lettere, numeri e _';

  @override
  String get usernameNeedsLetter => 'Aggiungi almeno una lettera o un numero';

  @override
  String usernameChangeAgainOn(String date) {
    return 'Potrai cambiarlo di nuovo il ${date}';
  }

  @override
  String get continueWithApple => 'Continua con Apple';

  @override
  String get continueWithGoogle => 'Continua con Google';

  @override
  String get socialSignInFailed => 'Accesso non riuscito. Riprova.';

  @override
  String get chooseUsernameTitle => 'Scegli il tuo nome utente';

  @override
  String get chooseUsernameSubtitle => 'È così che gli altri ti trovano e ti vedono nelle classifiche.';

  @override
  String get authHeroTitle => 'BATTI CHIUNQUE.';

  @override
  String get authHeroSubtitle => 'Sfide di flessioni dal vivo, contate dalla tua fotocamera.';

  @override
  String get createAccountPitch => 'Il tuo grado e le tue sfide, su ogni telefono.';

  @override
  String get usernameSpacesHint => 'Gli spazi diventano _';

  @override
  String get emailCodeNote => 'Ti invieremo via email un codice di 6 cifre. Nessuna password.';

  @override
  String get continueWithEmail => 'Continua con l\'email';

  @override
  String get thisSeason => 'Questa stagione';

  @override
  String get thisWeek => 'Questa settimana';

  @override
  String get weekStartsAgain => 'Ricomincia ogni lunedì';

  @override
  String get lengthWeek => 'Settimana';

  @override
  String get lengthMonth => 'Mese';

  @override
  String get weekJoinHint => 'Vinci una sfida classificata questa settimana per entrare in classifica';

  @override
  String get weekInTop3 => 'Nella top 3 questa settimana';

  @override
  String weekToTop3(String n) {
    return '${n} LP alla top 3';
  }

  @override
  String get boardActiveNote => 'Giocatori attivi negli ultimi 30 giorni';

  @override
  String get boardTieNote => 'a pari merito: prima chi ha più vittorie';

  @override
  String lpBreakdown(String reps, String adjust, String rank) {
    return '${reps} per le ripetizioni · ${adjust} per un avversario ${rank}';
  }

  @override
  String levelShort(String n) {
    return 'Liv. ${n}';
  }

  @override
  String xpOf(String into, String span) {
    return '${into} / ${span} XP';
  }

  @override
  String xpToLevel(String n, String level) {
    return '${n} XP al livello ${level}';
  }

  @override
  String xpHow(String rep, String match) {
    return '${rep} XP a ripetizione, ${match} a sfida';
  }

  @override
  String xpGained(String n) {
    return '+${n} XP';
  }

  @override
  String xpForReps(String n) {
    return '${n} per le ripetizioni';
  }

  @override
  String xpForMatch(String n) {
    return '${n} per la sfida';
  }

  @override
  String get levelUp => 'Livello superiore';

  @override
  String get levelUpBody => 'Ogni ripetizione conta. Continua così.';

  @override
  String giveUpAhead(String n) {
    return 'Sei avanti di ${n}';
  }

  @override
  String giveUpBehind(String n) {
    return 'Sei indietro di ${n}';
  }

  @override
  String get giveUpTied => 'Pari';

  @override
  String get keepGoing => 'Continua';

  @override
  String get stay => 'Resta';

  @override
  String lastN(String n) {
    return 'Ultimi ${n}';
  }

  @override
  String get firstMatchForTier => 'Gioca la tua prima sfida per entrare in classifica. Tutti partono da Iron V.';

  @override
  String get firstMatchForBoard => 'Gioca la tua prima sfida per comparire in classifica. Tutti partono da Iron V.';

  @override
  String get playFirstMatch => 'Gioca la prima sfida';

  @override
  String firstMatchTerms(String seconds) {
    return 'Una sfida · ${seconds} secondi';
  }

  @override
  String get placedLabel => 'Sei in classifica';

  @override
  String get placedBody => 'Tutti partono da qui. Solo le vittorie ti fanno salire.';

  @override
  String get placedHow => 'Vinci sfide per guadagnare LP. Batti chi ha un grado più alto per averne di più.';

  @override
  String get levelBesideName => 'Accanto al tuo nome, ovunque';

  @override
  String get weekRaceTitle => 'La gara della settimana';

  @override
  String get streakDoneToday => 'fatto oggi';

  @override
  String get streakTrainToday => 'allenati oggi per aggiungere un giorno';

  @override
  String get raceChartTitle => 'Com\'è andato il minuto';

  @override
  String raceYouLead(String time) {
    return '${time} · sei passato in testa';
  }

  @override
  String raceTheyLead(String time, String name) {
    return '${time} · ${name} è passato in testa';
  }

  @override
  String get bringFriendTitle => 'Porta un amico';

  @override
  String get bringFriendBody => 'Manda il tuo link. Apre il tuo profilo, dove possono aggiungerti.';

  @override
  String get bringFriendShare => 'Condividi il mio link';

  @override
  String get bringFriendShareText => 'Sfidami alle flessioni su OUTREPD. 60 secondi, dal vivo, e conta la fotocamera.';

  @override
  String orFriendCode(String code) {
    return 'o codice amico ${code}';
  }

  @override
  String get countryPickerTitle => 'Il tuo paese';

  @override
  String get countrySearch => 'Cerca';

  @override
  String get countryFromPhone => 'Dal tuo telefono';

  @override
  String get countryAll => 'Tutti i paesi';

  @override
  String get countryChoose => 'Scegli il tuo paese';

  @override
  String get countryChange => 'Cambia';

  @override
  String get countryForBoard => 'Per la classifica del tuo paese';

  @override
  String get countryLabel => 'Paese';

  @override
  String get countryChanged => 'Paese cambiato';

  @override
  String get countryEvery14 => 'Una volta ogni 14 giorni, come il nome';

  @override
  String get countryNotSaved => 'Impossibile salvare il paese. Riprova.';

  @override
  String get adventure => 'Avventura';

  @override
  String stageNumber(String n) {
    return 'Livello ${n}';
  }

  @override
  String adventureLevelIn(String level, String world) {
    return 'Livello ${level} · ${world}';
  }

  @override
  String adventureClearedOf(String cleared, String total) {
    return '${cleared} su ${total} superati · senza rango';
  }

  @override
  String get worldIron => 'Miniere di Ferro';

  @override
  String get worldBronze => 'Dune di Bronzo';

  @override
  String get worldSilver => 'Vette d’Argento';

  @override
  String get worldGold => 'Cittadella d’Oro';

  @override
  String get worldPlatinum => 'Ghiacciaio di Platino';

  @override
  String get worldDiamond => 'Caverne di Diamante';

  @override
  String get worldMaster => 'Trono del Maestro';

  @override
  String worldNumber(String n) {
    return 'Mondo ${n}';
  }

  @override
  String fightLevel(String level) {
    return 'Combatti il livello ${level}';
  }

  @override
  String levelHpLine(String hp, String reps) {
    return 'HP ${hp} · circa ${reps} piegamenti';
  }

  @override
  String get hpShort => 'HP';

  @override
  String comboTag(String n) {
    return 'COMBO ×${n}';
  }

  @override
  String get levelCleared => 'SUPERATO';

  @override
  String get outOfTime => 'TEMPO SCADUTO';

  @override
  String get statPushUps => 'piegamenti';

  @override
  String get statTimeLeft => 'rimasto';

  @override
  String get statHpLeft => 'HP rimasti';

  @override
  String get statXp => 'XP';

  @override
  String secondStarHint(String seconds) {
    return 'Finisci con ${seconds} secondi di margine per la seconda stella';
  }

  @override
  String thirdStarHint(String seconds) {
    return 'Finisci con ${seconds} secondi di margine per la terza stella';
  }

  @override
  String get fightLostHint => 'Rigioca i livelli precedenti per più stelle: sbloccano armi più forti.';

  @override
  String get nextLevel => 'Livello successivo';

  @override
  String get tryAgain => 'Riprova';

  @override
  String get adventureMap => 'Mappa';

  @override
  String get nextKicker => 'PROSSIMO';

  @override
  String nextLevelLine(String level, String hp) {
    return 'Livello ${level} · HP ${hp}';
  }

  @override
  String get armory => 'Armeria';

  @override
  String get armoryBody => 'Le stelle sbloccano armi. I mostri di ogni mondo sentono solo la sua arma o una migliore.';

  @override
  String get equipped => 'EQUIPAGGIATA';

  @override
  String perPushUp(String damage) {
    return '${damage} per piegamento';
  }

  @override
  String damagePerPushUp(String damage) {
    return '${damage} danni per piegamento';
  }

  @override
  String wasWith(String damage, String weapon) {
    return 'prima ${damage} con ${weapon}';
  }

  @override
  String moreStars(String count) {
    return 'ancora ${count} stelle';
  }

  @override
  String get newWeapon => 'Nuova arma';

  @override
  String starsKicker(String count) {
    return '${count} STELLE';
  }

  @override
  String get weaponGauntlets => 'Guanti di Ferro';

  @override
  String get weaponKnuckles => 'Tirapugni di Bronzo';

  @override
  String get weaponFang => 'Zanna d’Argento';

  @override
  String get weaponHammer => 'Martello d’Oro';

  @override
  String get weaponAxe => 'Ascia di Platino';

  @override
  String get weaponSpear => 'Lancia di Diamante';

  @override
  String get weaponSword => 'Spada del Maestro';

  @override
  String get weaponCrownbreaker => 'Spezzacorone';

  @override
  String clearFirst(String level) {
    return 'Prima vinci il livello ${level}';
  }

  @override
  String needsWeapon(String weapon) {
    return 'Serve ${weapon}';
  }

  @override
  String hurtOnlyBy(String weapon) {
    return 'Solo ${weapon} o meglio può ferirlo';
  }

  @override
  String worldNeedsWeapon(String world, String weapon, String count) {
    return '${world} richiede ${weapon} · ancora ${count} stelle';
  }

  @override
  String rematchOpponentLeft(String name) {
    return '${name} è uscito · niente rivincita stavolta';
  }

  @override
  String get obNext => 'Avanti';

  @override
  String get obRaceTitle => 'Sfida una persona vera.';

  @override
  String get obRaceBody => 'Vince chi fa più ripetizioni in 60 secondi. In diretta, ognuno sul proprio telefono, o contro una serie registrata quando non c’è nessuno online.';

  @override
  String get obRepsTitle => 'Contano solo le ripetizioni complete.';

  @override
  String get obRepsBody => 'La fotocamera vede quanto scendi e quanto torni su.';

  @override
  String get obRepsDown => 'Scendi oltre la linea dorata';

  @override
  String get obRepsUp => 'Torna su oltre la linea in alto';

  @override
  String get obRepsBoth => 'Entrambe, con le mani a terra. Mezza ripetizione non conta, né sul tuo telefono né sul suo.';

  @override
  String get obClimbTitle => 'Sali fino a Master.';

  @override
  String get obClimbBody => 'Vinci per salire la scala: sette gradi, cinque livelli ciascuno.';

  @override
  String get obAdventureTitle => 'Ti alleni da solo?';

  @override
  String get obAdventureBody => 'Avventura ha 140 livelli di sfide a flessioni, ognuno più difficile del precedente.';

  @override
  String get obGoldLine => 'linea dorata';

  @override
  String obCalibrationRule(String gold) {
    return 'Scendi oltre la ${gold}, torna su oltre quella in alto';
  }

  @override
  String get proTitleTop => 'Niente pubblicità.';

  @override
  String get proTitleBottom => 'Solo flessioni.';

  @override
  String get proBody => 'Ogni partita resta gratis. Pro toglie la pubblicità da tutte.';

  @override
  String get proThanks => 'Pubblicità disattivata. Grazie per essere passato a Pro.';

  @override
  String get removeAds => 'Rimuovi pubblicità';

  @override
  String get adNotice => 'Uscendo parte una pubblicità';

  @override
  String get adAskTitle => 'La pubblicità tiene outrepd gratis';

  @override
  String get adAskBody => 'Ora il tuo iPhone ti chiederà se le app possono usare la tua attività per scegliere le pubblicità. Se dici sì le pubblicità ti somiglieranno di più; se dici no le vedrai comunque, solo meno pertinenti.';

  @override
  String get adAskCamera => 'La fotocamera non c’entra mai: il tracciamento del corpo resta su questo telefono, qualunque cosa scegli.';

  @override
  String get adAskRemove => 'Piuttosto rimuovi la pubblicità';

  @override
  String get monsterIronColossus => 'Colosso di ferro';

  @override
  String get monsterScarab => 'Scarabeo';

  @override
  String get monsterScarabPharaoh => 'Faraone scarabeo';

  @override
  String get monsterYeti => 'Yeti';

  @override
  String get monsterFrostYeti => 'Yeti del gelo';

  @override
  String get monsterYetiChieftain => 'Capo yeti';

  @override
  String get monsterGoldSoldier => 'Soldato d’oro';

  @override
  String get monsterGoldKnight => 'Cavaliere d’oro';

  @override
  String get monsterGoldKing => 'Re d’oro';

  @override
  String get monsterWisp => 'Fuoco fatuo';

  @override
  String get monsterWraith => 'Spettro';

  @override
  String get monsterFrostLich => 'Lich del gelo';

  @override
  String get monsterCrystalDrake => 'Drake di cristallo';

  @override
  String get monsterCrystalDragon => 'Drago di cristallo';

  @override
  String get monsterDiamondWyrm => 'Viverna di diamante';

  @override
  String get monsterShadowGuard => 'Guardia d’ombra';

  @override
  String get monsterShadowKnight => 'Cavaliere d’ombra';

  @override
  String get monsterTheMaster => 'Il Maestro';

  @override
  String get monsterPebbleGolem => 'Golem di ciottoli';

  @override
  String get monsterStoneGolem => 'Golem di pietra';

  @override
  String get monsterOreGolem => 'Golem di minerale';

  @override
  String get monsterMinerGolem => 'Golem minatore';

  @override
  String get monsterScarabGrub => 'Larva di scarabeo';

  @override
  String get monsterHornedScarab => 'Scarabeo cornuto';

  @override
  String get monsterScarabWarrior => 'Guerriero scarabeo';

  @override
  String get monsterYetiCub => 'Cucciolo di yeti';

  @override
  String get monsterHornedYeti => 'Yeti cornuto';

  @override
  String get monsterGoldRecruit => 'Recluta d’oro';

  @override
  String get monsterGoldGuard => 'Guardia d’oro';

  @override
  String get monsterShade => 'Ombra';

  @override
  String get monsterIceSpecter => 'Spettro di ghiaccio';

  @override
  String get monsterCrystalHatchling => 'Cucciolo di cristallo';

  @override
  String get monsterCrystalWhelp => 'Draghetto di cristallo';

  @override
  String get monsterShadowSquire => 'Scudiero d’ombra';

  @override
  String get monsterShadowLord => 'Signore d’ombra';

  @override
  String monsterWarden(String name) {
    return '${name} guardiano';
  }

  @override
  String get obPhoneSees => 'Cosa deve vedere il telefono';

  @override
  String get obPhoneSeesBody => 'Dalla cima della testa alle mani, a circa un metro, in posizione da flessione.';

  @override
  String get obUnder13 => 'Meno di 13';

  @override
  String get obOver13 => '13 o più';

  @override
  String get obFor13 => 'outrepd è per chi ha 13 anni o più.';

  @override
  String get obUnder13Blocked => 'outrepd è per chi ha 13 anni o più. Torna quando ci arrivi: le flessioni saranno ancora qui.';

  @override
  String get obBeforeYouLift => 'Prima di iniziare';
}
