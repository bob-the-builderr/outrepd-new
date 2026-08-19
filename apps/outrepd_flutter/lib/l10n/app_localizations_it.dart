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
  String get tabCrew => 'Crew';

  @override
  String get tabProfile => 'Profilo';

  @override
  String get searchOpponent => 'Cerca un avversario';

  @override
  String get searchOpponentHint => 'Ti troviamo qualcuno del tuo rango';

  @override
  String get challengeFriend => 'Sfida un amico';

  @override
  String get trainWithCamera => 'Allenati con la fotocamera';

  @override
  String get viewRoadmap => 'Vedi il percorso';

  @override
  String lpProgress(int lp, int left) {
    return '$lp / 100 PL · $left alla promozione';
  }

  @override
  String winStreak(int count) {
    return '$count vittorie di fila';
  }

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
  String get profile => 'Profilo';

  @override
  String get settings => 'Impostazioni';

  @override
  String get stats => 'Statistiche';

  @override
  String get edit => 'Modifica';

  @override
  String get save => 'Salva';

  @override
  String get cancel => 'Annulla';

  @override
  String get skip => 'Salta';

  @override
  String get totalMatches => 'Sfide totali';

  @override
  String get bestWinStreak => 'Miglior serie';

  @override
  String get totalVolume => 'Volume totale sollevato';

  @override
  String get height => 'Altezza';

  @override
  String get bodyweight => 'Peso corporeo';

  @override
  String get age => 'Età';

  @override
  String get editYourStats => 'Modifica i tuoi dati';

  @override
  String get editStatsHint =>
      'Vittorie, volume e rango si guadagnano — non si scrivono.';

  @override
  String get changeName => 'Cambia nome';

  @override
  String get changeNameLast => 'È il tuo ultimo cambio. Non si torna indietro.';

  @override
  String changeNameLeft(int total, int left) {
    return 'Hai $total cambi in tutto. Dopo questo ne resta $left.';
  }

  @override
  String get changeNameUsedUp => 'Hai già usato entrambi i cambi di nome';

  @override
  String get yourPicture => 'La tua foto';

  @override
  String get yourPictureHint =>
      'La cornice dipende dal tuo rango e cambia man mano che sali.';

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
  String titlesAndStreak(int owned, int total, int streak) {
    return '$owned titoli su $total · serie di $streak giorni';
  }

  @override
  String get crew => 'Crew';

  @override
  String get myCrew => 'La mia crew';

  @override
  String get rankings => 'Classifica';

  @override
  String get trainWithCrew => 'Allenati con una crew';

  @override
  String get trainWithCrewHint =>
      'Fino a 20 atleti sotto un solo nome, un obiettivo settimanale comune e una posizione da scalare.';

  @override
  String get createCrew => 'Crea una crew';

  @override
  String get createCrewHint => 'Dalle un nome, scegli lo stemma, invita i tuoi';

  @override
  String get joinOpenCrew => 'Entra in una crew aperta';

  @override
  String get joinOpenCrewHint => 'Crew aperte a chiunque';

  @override
  String get yourInvites => 'I tuoi inviti';

  @override
  String get yourInvitesHint => 'Crew che ti hanno cercato';

  @override
  String get joinWithCode => 'Entra con un codice';

  @override
  String get joinWithCodeHint => 'Sei caratteri da un membro';

  @override
  String get topCrewsThisWeek => 'Migliori crew della settimana';

  @override
  String get members => 'Membri';

  @override
  String get repsEach => 'Rip. a testa';

  @override
  String get rank => 'Posizione';

  @override
  String get weeklyGoal => 'Obiettivo settimanale';

  @override
  String get weeklyGoalDone => 'Obiettivo settimanale centrato';

  @override
  String goalRemaining(int reps, int days) {
    return 'Mancano $reps rip. · $days giorni';
  }

  @override
  String get goalDoneHint =>
      'Alla chiusura della settimana il distintivo va a tutti.';

  @override
  String get startCrewWar => 'Avvia una guerra tra crew';

  @override
  String get startCrewWarHint =>
      'Sette giorni, entrambe le crew contano. Vince chi fa più ripetizioni a testa.';

  @override
  String get whoIsPulling => 'Chi sostiene la crew';

  @override
  String get thisWeek => 'questa settimana';

  @override
  String get inviteLifters => 'Invita atleti';

  @override
  String get referralCode => 'Codice invito';

  @override
  String get inviteLink => 'Link d\'invito';

  @override
  String get leaveCrew => 'Lascia la crew';

  @override
  String get owner => 'Fondatore';

  @override
  String get crewTable => 'Tabella crew';

  @override
  String get repsPerMember => 'rip. per membro';

  @override
  String seasonResets(int days) {
    return 'Si azzera tra $days giorni — si riparte tutti alla pari';
  }

  @override
  String get rankingExplained =>
      'Le crew si classificano sulle ripetizioni per membro, non sul totale — altrimenti vince la più numerosa solo perché è grande.';

  @override
  String get leaderboard => 'Classifica';

  @override
  String get global => 'Mondiale';

  @override
  String get myCountry => 'Il mio paese';

  @override
  String yourFriends(int count) {
    return 'I tuoi amici ($count)';
  }

  @override
  String get challenge => 'Sfida';

  @override
  String get notifications => 'Notifiche';

  @override
  String get pickMovement => 'Scegli un movimento';

  @override
  String get anyExercise => 'Qualsiasi esercizio';

  @override
  String get anyExerciseHint =>
      'Inizia la serie: il movimento viene riconosciuto durante l\'esecuzione';

  @override
  String get start => 'Inizia';

  @override
  String get finish => 'Finito';

  @override
  String get reps => 'rip.';

  @override
  String get secondsHeld => 'secondi tenuti';

  @override
  String get learningMovement =>
      'Sto imparando il tuo movimento — le ripetizioni arrivano tra un attimo';

  @override
  String get recalibrate => 'Ricalibra';

  @override
  String get resetCount => 'Azzera il conteggio';

  @override
  String get checksForm => 'controlla la tecnica';

  @override
  String get counts => 'conta';

  @override
  String get time => 'tempo';

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
  String get darkMode => 'Modalità scura';

  @override
  String get language => 'Lingua';

  @override
  String get units => 'Unità';

  @override
  String get weight => 'Peso';

  @override
  String get notificationsSection => 'Notifiche';

  @override
  String get privacy => 'Privacy';

  @override
  String get matches => 'Sfide';

  @override
  String get data => 'Dati';

  @override
  String get about => 'Informazioni';

  @override
  String get dangerZone => 'Zona critica';

  @override
  String get themeSystem => 'Come il dispositivo';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get openCrews => 'Crew aperte';

  @override
  String get openCrewsHint =>
      'Queste accettano chiunque. Scegline una e sei dentro.';

  @override
  String get yourInvitesSubtitle => 'Crew che ti hanno chiesto per nome.';

  @override
  String get pickOpponent => 'Scegli il tuo avversario';

  @override
  String get accept => 'Accetta';

  @override
  String get join => 'Entra';

  @override
  String get copy => 'Copia';

  @override
  String get copied => 'Link d\'invito copiato';

  @override
  String season(String name) {
    return 'Stagione $name';
  }

  @override
  String challengeSent(String name) {
    return 'Sfida inviata a $name';
  }

  @override
  String get inviteFriendPrivate => 'Invita un amico a una sfida privata';

  @override
  String get joinWithCodePaste =>
      'Incolla i sei caratteri che ti ha mandato un membro.';

  @override
  String get enterTheCode => 'Inserisci il codice di 6 caratteri';

  @override
  String get followingDevice => 'Al momento segue il dispositivo';

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
  String get visEveryoneHint => 'Chiunque può aprire il tuo profilo';

  @override
  String get visFriendsHint => 'Solo chi hai aggiunto';

  @override
  String get visNobodyHint => 'Il tuo profilo resta privato';

  @override
  String get matchInvites => 'Inviti alle sfide';

  @override
  String get matchResults => 'Risultati delle sfide';

  @override
  String get friendRequestsLabel => 'Richieste di amicizia';

  @override
  String get crewActivity => 'Attività della crew';

  @override
  String get rankChanges => 'Cambi di rango';

  @override
  String get weeklySummary => 'Riepilogo settimanale';

  @override
  String get soundLabel => 'Suono';

  @override
  String get vibration => 'Vibrazione';

  @override
  String get whoCanSeeProfile => 'Chi può vedere il mio profilo';

  @override
  String get profileVisibility => 'Visibilità del profilo';

  @override
  String get showOnLeaderboards => 'Mostrami nelle classifiche';

  @override
  String get allowMatchInvites => 'Consenti inviti alle sfide';

  @override
  String get allowFriendRequests => 'Consenti richieste di amicizia';

  @override
  String get showHeightWeight => 'Mostra altezza e peso';

  @override
  String get showHeightWeightHint => 'Spento, le tue misure restano tue';

  @override
  String get autoAcceptFriends => 'Accetta in automatico dagli amici';

  @override
  String get restTimerBetweenSets => 'Timer di recupero fra le serie';

  @override
  String get exportData => 'Esporta i miei dati';

  @override
  String get clearCache => 'Svuota la cache';

  @override
  String get cacheCleared => 'Cache svuotata';

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
  String get resetProgress => 'Azzera i miei progressi';

  @override
  String get resetProgressTitle => 'Azzerare i tuoi progressi?';

  @override
  String get resetProgressBody =>
      'Rango, PL e storico tornano a zero. Non si può annullare.';

  @override
  String get actionReset => 'Azzera';

  @override
  String get deleteAccount => 'Elimina account';

  @override
  String get deleteAccountTitle => 'Eliminare il tuo account?';

  @override
  String get deleteAccountBody =>
      'Il tuo profilo, le crew e ogni sfida sollevata spariscono per sempre.';

  @override
  String get actionDelete => 'Elimina';

  @override
  String get needsServer =>
      'Questa funzione richiede un server e non è ancora collegata';

  @override
  String get getStarted => 'Iniziamo';

  @override
  String get skipToApp => 'Vai subito all\'app';

  @override
  String get achievements => 'Obiettivi';

  @override
  String get unlocked => 'Sbloccato';

  @override
  String get roadTitle => 'La strada per la Leggenda';

  @override
  String get allTiers => 'Tutti i ranghi';

  @override
  String get topTier => 'Rango massimo';

  @override
  String lpToGo(int lp) {
    return '$lp PL';
  }

  @override
  String get unlockedEverything => 'Hai sbloccato tutto';

  @override
  String unlocksAt(String tier) {
    return 'Si sblocca a $tier';
  }

  @override
  String get matchedSameGroup =>
      'Verrai abbinato a qualcuno che allena lo stesso gruppo.';

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
  String get dontGetOutrepd => 'Don\'t get OUTREPD!';

  @override
  String xOfY(int a, int b) {
    return '$a / $b';
  }

  @override
  String get tierStone => 'Pietra';

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
  String get tierMythic => 'Mitico';

  @override
  String get tierLegend => 'Leggenda';

  @override
  String get rewardStone => 'Cornice di pietra';

  @override
  String get rewardBronze => 'Distintivo di bronzo';

  @override
  String get rewardSilver => 'Distintivo d\'argento';

  @override
  String get rewardGold => 'Distintivo d\'oro';

  @override
  String get rewardPlatinum => 'Distintivo di platino';

  @override
  String get rewardDiamond => 'Distintivo di diamante';

  @override
  String get rewardMaster => 'Distintivo di maestro';

  @override
  String get rewardMythic => 'Distintivo mitico';

  @override
  String get rewardLegend => 'Distintivo di leggenda';

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
    return '${w}V ${l}S';
  }

  @override
  String get yearsSuffix => 'anni';

  @override
  String get yourCrew => 'La tua crew';

  @override
  String get crewName => 'Nome della crew';

  @override
  String get motto => 'Motto';

  @override
  String get mottoHint => 'Che cosa rappresenta questa crew?';

  @override
  String get country => 'Paese';

  @override
  String get whoCanJoin => 'Chi può entrare';

  @override
  String get minimumRank => 'Rango minimo';

  @override
  String get anyone => 'Chiunque';

  @override
  String get emblem => 'Stemma';

  @override
  String get colour => 'Colore';

  @override
  String get createCrewButton => 'Crea la crew';

  @override
  String get ownerNote =>
      'Ne sarai il fondatore. Una crew ospita fino a 20 atleti.';

  @override
  String get searchCountries => 'Cerca un paese';

  @override
  String get noCountryMatch => 'Nessun paese corrisponde';

  @override
  String get nameTooShort => 'Dai alla crew un nome di almeno 3 caratteri';

  @override
  String get privOpen => 'Aperta';

  @override
  String get privRequest => 'Richiesta di ingresso';

  @override
  String get privInviteOnly => 'Solo su invito';

  @override
  String get privOpenHint => 'Chi ha il codice entra subito';

  @override
  String get privRequestHint => 'Si fa richiesta e un responsabile approva';

  @override
  String get privInviteOnlyHint => 'Si entra solo per invito diretto';

  @override
  String get embStrength => 'Forza';

  @override
  String get embCombat => 'Combattimento';

  @override
  String get embBeasts => 'Bestie';

  @override
  String get embElements => 'Elementi';

  @override
  String get embHonours => 'Onori';

  @override
  String get embSymbols => 'Simboli';

  @override
  String get ob1Title => 'Trasforma ogni sessione\nin una sfida';

  @override
  String get ob1Body =>
      'Registra il tuo allenamento e affronta chi lavora lo stesso gruppo muscolare.';

  @override
  String get ob2Title => 'Sfida i tuoi\namici';

  @override
  String get ob2Body =>
      'Manda un invito privato e stabilisci chi si allena davvero di più.';

  @override
  String get ob3Title => 'Scala i ranghi';

  @override
  String get ob3Body =>
      'Ogni vittoria dà PL. Sali dalla Pietra fino alla Leggenda.';

  @override
  String get ob4Title => 'Lo sforzo da soli\nè duro';

  @override
  String get ob4Body =>
      'Allenarsi senza nessuno che guardi rende facile accorciare l\'ultima serie.';

  @override
  String get ob5Title => 'Diventa una\nLeggenda';

  @override
  String get ob5Body => 'La costanza si somma. Presentati, supera, sali.';

  @override
  String get letsGo => 'Iniziamo';

  @override
  String get continueLabel => 'Continua';
}
