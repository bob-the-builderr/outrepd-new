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
  String get passwordHint => 'Password';

  @override
  String get codeHint => 'Codice di verifica';

  @override
  String get createAccountTitle => 'Crea account';

  @override
  String get createAccountBody =>
      'Aggiungi un\'email e una password così questo account non dipende solo da questo telefono.';

  @override
  String get createAccountAction => 'Crea account';

  @override
  String get signInTitle => 'Accedi';

  @override
  String get signInBody => 'Accedi con l\'email e la password del tuo account.';

  @override
  String get signInAction => 'Accedi';

  @override
  String get switchToSignIn => 'Hai già un account? Accedi';

  @override
  String get switchToSignUp => 'Nuovo qui? Crea un account';

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
  String get authEntryTagline => 'Spingi. Sfida. Sali di livello.';

  @override
  String get orDivider => 'oppure';

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
  String get usernameHint => 'Nome utente';

  @override
  String get passwordMinLength => 'Almeno 8 caratteri';

  @override
  String get logInSubtitle => 'Accedi per mantenere il tuo grado.';

  @override
  String get forgotPassword => 'Password dimenticata?';

  @override
  String resetPasswordSent(String email) {
    return 'Se esiste un account per $email, un link di reset è in arrivo.';
  }

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
  String get socialLinkFailed => 'Impossibile completare l\'accesso. Riprova.';

  @override
  String get showLabel => 'Mostra';

  @override
  String get hideLabel => 'Nascondi';

  @override
  String get resetPasswordTitle => 'Imposta una nuova password';

  @override
  String get resetPasswordBody =>
      'Scegli una nuova password per il tuo account.';

  @override
  String get setPasswordAction => 'Imposta password';

  @override
  String get wrongEmailOrPassword => 'Email o password errati.';

  @override
  String get enterCodeTitle => 'Inserisci codice';

  @override
  String codeInstructions(String email) {
    return 'Inserisci il codice che abbiamo inviato a $email.';
  }

  @override
  String get verifyAction => 'Verifica';

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
  String get height => 'Altezza';

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
  String get simulatedOpponent =>
      'Nessun altro era pronto: questo è un ritmo di allenamento';

  @override
  String get changeUsername => 'Cambia nome utente';

  @override
  String get usernameInvalidLength =>
      'Deve avere da 4 a 20 caratteri, solo lettere e numeri';

  @override
  String get usernameChanged => 'Nome utente cambiato';

  @override
  String get usernameAlreadyChangedBody =>
      'Hai già usato il tuo unico cambio di nome utente — ogni account ne riceve esattamente uno.';

  @override
  String get gallery => 'Galleria';

  @override
  String get camera => 'Fotocamera';

  @override
  String get orPickOurs => 'Oppure scegli uno dei nostri';

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
  String get recalibrate => 'Ricalibra';

  @override
  String get resetCount => 'Azzera il conteggio';

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
  String get units => 'Unità';

  @override
  String get weight => 'Peso';

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
  String challengeSent(String name) {
    return 'Sfida inviata a $name';
  }

  @override
  String get weightUnitTitle => 'Unità di peso';

  @override
  String get heightUnitTitle => 'Unità di altezza';

  @override
  String get unitKg => 'Chilogrammi (kg)';

  @override
  String get unitLb => 'Libbre (lb)';

  @override
  String get unitCm => 'Centimetri (cm)';

  @override
  String get unitFt => 'Piedi e pollici';

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
      'Questa funzione richiede un server e non è ancora collegata';

  @override
  String get achievements => 'Obiettivi';

  @override
  String get unlocked => 'Sbloccato';

  @override
  String get roadTitle => 'La strada per Maestro';

  @override
  String get allTiers => 'Tutti i ranghi';

  @override
  String get topTier => 'Rango massimo';

  @override
  String lpToGo(String lp) {
    return '$lp PL';
  }

  @override
  String get unlockedEverything => 'Hai sbloccato tutto';

  @override
  String unlocksAt(String tier) {
    return 'Si sblocca a $tier';
  }

  @override
  String get roomFriendly =>
      'Le sfide in stanza sono amichevoli: non toccano il tuo rango.';

  @override
  String get createRoom => 'Crea una stanza';

  @override
  String get enterCode => 'INSERISCI IL CODICE';

  @override
  String get joinRoom => 'Entra nella stanza';

  @override
  String get shareThisCode => 'Condividi questo codice';

  @override
  String get codeCopied => 'Codice copiato';

  @override
  String get pickMuscleAndStart => 'Scegli il muscolo e parti';

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
  String get rewardStone => 'Duelli da 60 s';

  @override
  String get rewardBronze => 'Pulsante rivincita';

  @override
  String get rewardSilver => 'Durata personalizzata';

  @override
  String get rewardGold => 'Al meglio di 3';

  @override
  String get rewardPlatinum => 'Tornei privati';

  @override
  String get rewardDiamond => 'Lobby aperte';

  @override
  String get rewardMaster => 'Nome sulla classifica globale';

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
  String get stay => 'Resta';

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
  String get mgBack => 'Schiena';

  @override
  String get mgLegs => 'Gambe';

  @override
  String get mgShoulders => 'Spalle';

  @override
  String get mgArms => 'Braccia';

  @override
  String get mgCore => 'Core';

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
    return '$n settimane fa';
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
  String get addFriend => 'Aggiungi';

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
  String get searchByUsername => 'Cerca per nome utente';

  @override
  String get incomingRequests => 'Richieste ricevute';

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
  String lpToUnlock(String lp, String rank, String unlock) {
    return '$lp LP a $rank · sblocca $unlock';
  }

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
  String get findPeople => 'Trova persone';

  @override
  String get noRankYet => 'Ancora senza rango';

  @override
  String placementsForFirstTier(String count) {
    return 'Completa $count sfide di piazzamento per ottenere il tuo primo rango.';
  }

  @override
  String get startPlacements => 'Inizia i piazzamenti';

  @override
  String get unranked => 'Senza rango';

  @override
  String placementsTerms(String done, String total, String seconds) {
    return '$done su $total · $seconds secondi ciascuna';
  }

  @override
  String placementsLeft(String done, String total, String left) {
    return '$done su $total · altre $left per il tuo rango';
  }

  @override
  String placementsForTier(String count) {
    return 'Completa $count sfide di piazzamento per scoprire il tuo rango.';
  }

  @override
  String placementsDoneCount(String done, String total) {
    return '$done su $total piazzamenti completati';
  }

  @override
  String get practiceFirst => 'Prima allenati';

  @override
  String get nextPlacement => 'Piazzamento successivo';

  @override
  String get noConnection => 'Nessuna connessione';

  @override
  String get practiceOffline => 'Allenati offline';

  @override
  String get retry => 'Riprova';

  @override
  String get youWonPlain => 'Hai vinto';

  @override
  String opponentDisconnected(String name) {
    return '$name si è disconnesso';
  }

  @override
  String get forfeitNoMargin => 'Ritiro · il margine non conta';

  @override
  String get findAnotherMatch => 'Cerca un’altra sfida';

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
  String get noConnectionBody =>
      'Per sfidare qualcuno serve una connessione. L’allenamento funziona offline e le ripetizioni si sincronizzeranno dopo.';

  @override
  String get getBackInFrame => 'Torna nell’inquadratura';

  @override
  String get clockStillRunning =>
      'Il tempo scorre ancora. Non si sta contando.';

  @override
  String get giveUp => 'Arrenditi';

  @override
  String lpSwing(String gain, String loss) {
    return '+$gain / −$loss LP';
  }

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
  String get yourRankCard => 'La tua carta rango';

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
  String get obHowTitle => 'Tre cose e sei dentro.';

  @override
  String get obHow1 => 'Appoggia il telefono a terra';

  @override
  String get obHow1Body => 'Mettilo contro un muro, a un metro davanti a te.';

  @override
  String get obHow2 => 'La fotocamera conta le tue ripetizioni';

  @override
  String get obHow2Body =>
      'Di ogni ripetizione si misura la profondità. Quelle a metà non contano.';

  @override
  String get obHow3 => 'Sessanta secondi contro qualcuno';

  @override
  String get obHow3Body =>
      'Vinci e sali. Perdi e scendi. Stesse regole per tutti.';

  @override
  String get obTwoThings => 'Due cose veloci.';

  @override
  String get obAgeQuestion => 'Quanti anni hai?';

  @override
  String get obUnder16 => 'Meno di 16';

  @override
  String get obOver16 => '16 o più';

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
  String get obUnder16Blocked =>
      'outrepd è per chi ha almeno 16 anni. Torna quando ci arrivi — le flessioni restano qui.';

  @override
  String get obCameraTitle => 'outrepd ha bisogno della fotocamera';

  @override
  String get obCameraBody =>
      'Guarda il tuo corpo muoversi per contare. Non c’è altro modo.';

  @override
  String get obCameraPrivateTitle => 'Niente esce dal tuo telefono';

  @override
  String get obCameraPrivateBody =>
      'Il tracciamento del corpo gira su questo dispositivo. Nessun video viene caricato, a meno che non lo pubblichi tu.';

  @override
  String get obWhyNeeded => 'Perché serve?';

  @override
  String get obPlacementTitle => 'Metti il telefono a terra';

  @override
  String get obPlacementBody =>
      'Appoggialo a un muro a circa un metro davanti a te.';

  @override
  String get obOneMetre => '~1 m';

  @override
  String get obFullBody => 'tutto il corpo nell’inquadratura';

  @override
  String get obCheckHandsFeet => 'Mani e piedi visibili';

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
  String get obFramingAnkles => 'Caviglie';

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
  String get obCreateAccountBody =>
      'Crea un account per tenere ripetizioni, grado e record.';

  @override
  String get obSaveProgress => 'Salva i miei progressi';

  @override
  String obSaveYourReps(String count) {
    return 'Salva le tue $count ripetizioni';
  }

  @override
  String get obOneTap => 'Un\'email e una password, tutto qui.';

  @override
  String get obContinueApple => 'Continua con Apple';

  @override
  String get obContinueGoogle => 'Continua con Google';

  @override
  String get obContinueEmail => 'Continua con l’email';

  @override
  String get obSignInFootnote =>
      'Lo usiamo solo per tenere il tuo account. Non pubblichiamo mai niente.';

  @override
  String get obPickName => 'Scegli un nome';

  @override
  String get obPickNameBody =>
      'È quello che vedono gli avversari. Puoi cambiarlo dopo.';

  @override
  String get obAvailable => 'Disponibile';

  @override
  String get obTaken => 'Già preso';

  @override
  String get obYourAvatar => 'La tua foto';

  @override
  String get obAddPhoto => 'Aggiungi una foto';

  @override
  String get obNotifyTitle => 'Scopri quando ti sfidano';

  @override
  String get obNotifyChallenged => 'Qualcuno ti ha sfidato';

  @override
  String get obNotifyStreak => 'La tua serie sta per interrompersi';

  @override
  String get obNotifyPassed => 'Un amico ti ha superato in classifica';

  @override
  String get obTurnOn => 'Attiva';

  @override
  String get obPlacementsBody =>
      'Cinque sfide decidono il tuo livello di partenza. Per ora niente conta contro di te.';

  @override
  String get obFindFirstOpponent => 'Trova il mio primo avversario';

  @override
  String get obGotIt => 'Capito';

  @override
  String get obFormMixed => 'Irregolare';

  @override
  String get obWelcomeBack => 'Bentornato';

  @override
  String get obWelcomeBackBody => 'Accedi con la tua email e password.';

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
      'Ogni volta che confermi il conteggio dopo una sfida, quella serie viene confrontata con quello che hai detto. Il numero compare qui.';

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
  String get lpRowWin => 'Vittoria';

  @override
  String get lpRowLoss => 'Sconfitta';

  @override
  String get lpRowOpponent => 'Grado dell\'avversario';

  @override
  String get lpRowMargin => 'Distacco';

  @override
  String get lpRowDepth => 'Profondità';

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
}
