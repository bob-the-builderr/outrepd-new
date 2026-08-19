// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class LFr extends L {
  LFr([String locale = 'fr']) : super(locale);

  @override
  String get tabFriends => 'Amis';

  @override
  String get tabRanks => 'Rangs';

  @override
  String get tabMatch => 'Duel';

  @override
  String get tabCrew => 'Équipe';

  @override
  String get tabProfile => 'Profil';

  @override
  String get searchOpponent => 'Chercher un adversaire';

  @override
  String get searchOpponentHint => 'On vous trouve quelqu\'un de votre rang';

  @override
  String get challengeFriend => 'Défier un ami';

  @override
  String get trainWithCamera => 'S\'entraîner avec la caméra';

  @override
  String get viewRoadmap => 'Voir la progression';

  @override
  String lpProgress(int lp, int left) {
    return '$lp / 100 PL · $left avant la promotion';
  }

  @override
  String winStreak(int count) {
    return '$count victoires d\'affilée';
  }

  @override
  String get matchHistory => 'Historique des duels';

  @override
  String get allMatches => 'Tous les duels';

  @override
  String get wins => 'Victoires';

  @override
  String get losses => 'Défaites';

  @override
  String get winRate => 'Taux de victoire';

  @override
  String get streak => 'Série';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Réglages';

  @override
  String get stats => 'Statistiques';

  @override
  String get edit => 'Modifier';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get skip => 'Passer';

  @override
  String get totalMatches => 'Duels au total';

  @override
  String get bestWinStreak => 'Meilleure série';

  @override
  String get totalVolume => 'Volume total soulevé';

  @override
  String get height => 'Taille';

  @override
  String get bodyweight => 'Poids de corps';

  @override
  String get age => 'Âge';

  @override
  String get editYourStats => 'Modifier vos données';

  @override
  String get editStatsHint =>
      'Les victoires, le volume et le rang se gagnent — ils ne se modifient pas.';

  @override
  String get changeName => 'Changer de nom';

  @override
  String get changeNameLast =>
      'C\'est votre dernier changement. Il est définitif.';

  @override
  String changeNameLeft(int total, int left) {
    return 'Vous avez $total changements en tout. Il en restera $left après celui-ci.';
  }

  @override
  String get changeNameUsedUp =>
      'Vous avez déjà utilisé vos deux changements de nom';

  @override
  String get yourPicture => 'Votre photo';

  @override
  String get yourPictureHint =>
      'Le cadre vient de votre rang et change quand vous montez.';

  @override
  String get gallery => 'Galerie';

  @override
  String get camera => 'Caméra';

  @override
  String get orPickOurs => 'Ou choisissez l\'un des nôtres';

  @override
  String get awards => 'Récompenses';

  @override
  String get yourTitles => 'Vos titres';

  @override
  String get stillToEarn => 'Encore à gagner';

  @override
  String get noTitlesYet =>
      'Aucun pour l\'instant. Le premier ne demande qu\'un duel.';

  @override
  String get wearHint =>
      'Touchez-en un pour le porter. Il s\'affiche à côté de votre nom partout où l\'on vous voit.';

  @override
  String get worn => 'porté';

  @override
  String get titleUnlocked => 'Titre débloqué';

  @override
  String get wearIt => 'Le porter';

  @override
  String get wearItLater => 'Plus tard';

  @override
  String get dayStreak => 'jours d\'affilée';

  @override
  String get bestEver => 'Record';

  @override
  String get restDaysLeft => 'Jours de repos restants';

  @override
  String get restIsTraining =>
      'Le repos fait partie de l\'entraînement. Deux jours de pause par semaine ne cassent pas votre série.';

  @override
  String titlesAndStreak(int owned, int total, int streak) {
    return '$owned titres sur $total · série de $streak jours';
  }

  @override
  String get crew => 'Équipe';

  @override
  String get myCrew => 'Mon équipe';

  @override
  String get rankings => 'Classement';

  @override
  String get trainWithCrew => 'Entraînez-vous en équipe';

  @override
  String get trainWithCrewHint =>
      'Jusqu\'à 20 athlètes sous un même nom, un objectif hebdomadaire commun et une place à prendre au classement.';

  @override
  String get createCrew => 'Créer une équipe';

  @override
  String get createCrewHint =>
      'Nommez-la, choisissez un blason, invitez vos proches';

  @override
  String get joinOpenCrew => 'Rejoindre une équipe ouverte';

  @override
  String get joinOpenCrewHint => 'Des équipes ouvertes à tous';

  @override
  String get yourInvites => 'Vos invitations';

  @override
  String get yourInvitesHint => 'Les équipes qui vous ont demandé';

  @override
  String get joinWithCode => 'Rejoindre avec un code';

  @override
  String get joinWithCodeHint => 'Six caractères donnés par un membre';

  @override
  String get topCrewsThisWeek => 'Meilleures équipes de la semaine';

  @override
  String get members => 'Membres';

  @override
  String get repsEach => 'Reps par personne';

  @override
  String get rank => 'Place';

  @override
  String get weeklyGoal => 'Objectif de la semaine';

  @override
  String get weeklyGoalDone => 'Objectif de la semaine atteint';

  @override
  String goalRemaining(int reps, int days) {
    return 'Encore $reps reps · $days jours restants';
  }

  @override
  String get goalDoneHint =>
      'Tout le monde reçoit le badge à la fin de la semaine.';

  @override
  String get startCrewWar => 'Lancer une guerre d\'équipes';

  @override
  String get startCrewWarHint =>
      'Sept jours, les deux équipes comptent. Le plus de reps par personne l\'emporte.';

  @override
  String get whoIsPulling => 'Qui porte l\'équipe';

  @override
  String get thisWeek => 'cette semaine';

  @override
  String get inviteLifters => 'Inviter des athlètes';

  @override
  String get referralCode => 'Code de parrainage';

  @override
  String get inviteLink => 'Lien d\'invitation';

  @override
  String get leaveCrew => 'Quitter l\'équipe';

  @override
  String get owner => 'Propriétaire';

  @override
  String get crewTable => 'Tableau des équipes';

  @override
  String get repsPerMember => 'reps par membre';

  @override
  String seasonResets(int days) {
    return 'Remise à zéro dans $days jours — tout le monde repart à égalité';
  }

  @override
  String get rankingExplained =>
      'Les équipes sont classées aux reps par membre, pas au total — sinon la plus grande gagne juste par sa taille.';

  @override
  String get leaderboard => 'Classement';

  @override
  String get global => 'Mondial';

  @override
  String get myCountry => 'Mon pays';

  @override
  String yourFriends(int count) {
    return 'Vos amis ($count)';
  }

  @override
  String get challenge => 'Défier';

  @override
  String get notifications => 'Notifications';

  @override
  String get pickMovement => 'Choisissez un mouvement';

  @override
  String get anyExercise => 'N\'importe quel exercice';

  @override
  String get anyExerciseHint =>
      'Commencez votre série : le mouvement est reconnu pendant l\'exécution';

  @override
  String get start => 'Commencer';

  @override
  String get finish => 'Terminer';

  @override
  String get reps => 'reps';

  @override
  String get secondsHeld => 'secondes tenues';

  @override
  String get learningMovement =>
      'Apprentissage de votre mouvement — vos reps arrivent dans un instant';

  @override
  String get recalibrate => 'Recalibrer';

  @override
  String get resetCount => 'Remettre à zéro';

  @override
  String get checksForm => 'vérifie la technique';

  @override
  String get counts => 'compte';

  @override
  String get time => 'temps';

  @override
  String get howManyReally => 'Combien en avez-vous vraiment fait ?';

  @override
  String get howManyReallyHint =>
      'Votre compte à vous, pas celui de l\'appli. C\'est la référence qui servira à mesurer le compteur.';

  @override
  String get appearance => 'Apparence';

  @override
  String get theme => 'Thème';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get language => 'Langue';

  @override
  String get units => 'Unités';

  @override
  String get weight => 'Poids';

  @override
  String get notificationsSection => 'Notifications';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get matches => 'Duels';

  @override
  String get data => 'Données';

  @override
  String get about => 'À propos';

  @override
  String get dangerZone => 'Zone sensible';

  @override
  String get themeSystem => 'Comme l\'appareil';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get openCrews => 'Équipes ouvertes';

  @override
  String get openCrewsHint =>
      'Elles acceptent tout le monde. Choisissez-en une et vous y êtes.';

  @override
  String get yourInvitesSubtitle =>
      'Les équipes qui vous ont demandé nommément.';

  @override
  String get pickOpponent => 'Choisissez votre adversaire';

  @override
  String get accept => 'Accepter';

  @override
  String get join => 'Rejoindre';

  @override
  String get copy => 'Copier';

  @override
  String get copied => 'Lien d\'invitation copié';

  @override
  String season(String name) {
    return 'Saison $name';
  }

  @override
  String challengeSent(String name) {
    return 'Défi envoyé à $name';
  }

  @override
  String get inviteFriendPrivate => 'Invitez un ami à un duel privé';

  @override
  String get joinWithCodePaste =>
      'Collez les six caractères qu\'un membre vous a envoyés.';

  @override
  String get enterTheCode => 'Saisissez le code à 6 caractères';

  @override
  String get followingDevice => 'Suit votre appareil pour le moment';

  @override
  String get weightUnitTitle => 'Unité de poids';

  @override
  String get heightUnitTitle => 'Unité de taille';

  @override
  String get unitKg => 'Kilogrammes (kg)';

  @override
  String get unitLb => 'Livres (lb)';

  @override
  String get unitCm => 'Centimètres (cm)';

  @override
  String get unitFt => 'Pieds et pouces';

  @override
  String get visEveryone => 'Tout le monde';

  @override
  String get visFriends => 'Amis seulement';

  @override
  String get visNobody => 'Personne';

  @override
  String get visEveryoneHint => 'N\'importe qui peut ouvrir votre profil';

  @override
  String get visFriendsHint => 'Seulement ceux que vous avez ajoutés';

  @override
  String get visNobodyHint => 'Votre profil reste privé';

  @override
  String get matchInvites => 'Invitations aux duels';

  @override
  String get matchResults => 'Résultats des duels';

  @override
  String get friendRequestsLabel => 'Demandes d\'amis';

  @override
  String get crewActivity => 'Activité de l\'équipe';

  @override
  String get rankChanges => 'Changements de rang';

  @override
  String get weeklySummary => 'Résumé hebdomadaire';

  @override
  String get soundLabel => 'Son';

  @override
  String get vibration => 'Vibration';

  @override
  String get whoCanSeeProfile => 'Qui peut voir mon profil';

  @override
  String get profileVisibility => 'Visibilité du profil';

  @override
  String get showOnLeaderboards => 'M\'afficher dans les classements';

  @override
  String get allowMatchInvites => 'Autoriser les invitations aux duels';

  @override
  String get allowFriendRequests => 'Autoriser les demandes d\'amis';

  @override
  String get showHeightWeight => 'Afficher taille et poids';

  @override
  String get showHeightWeightHint =>
      'Désactivé, vos mensurations restent pour vous';

  @override
  String get autoAcceptFriends => 'Accepter automatiquement les amis';

  @override
  String get restTimerBetweenSets => 'Minuteur de repos entre les séries';

  @override
  String get exportData => 'Exporter mes données';

  @override
  String get clearCache => 'Vider le cache';

  @override
  String get cacheCleared => 'Cache vidé';

  @override
  String get version => 'Version';

  @override
  String get rateApp => 'Noter OUTREPD';

  @override
  String get contactSupport => 'Contacter le support';

  @override
  String get termsOfService => 'Conditions d\'utilisation';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get openSourceLicences => 'Licences open source';

  @override
  String get resetProgress => 'Réinitialiser ma progression';

  @override
  String get resetProgressTitle => 'Réinitialiser votre progression ?';

  @override
  String get resetProgressBody =>
      'Le rang, les PL et l\'historique repartent de zéro. C\'est irréversible.';

  @override
  String get actionReset => 'Réinitialiser';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountTitle => 'Supprimer votre compte ?';

  @override
  String get deleteAccountBody =>
      'Votre profil, vos équipes et tous vos duels sont supprimés définitivement.';

  @override
  String get actionDelete => 'Supprimer';

  @override
  String get needsServer =>
      'Cette fonction nécessite un serveur et n\'est pas encore connectée';

  @override
  String get getStarted => 'Commencer';

  @override
  String get skipToApp => 'Aller directement à l\'appli';

  @override
  String get achievements => 'Succès';

  @override
  String get unlocked => 'Débloqué';

  @override
  String get roadTitle => 'La route vers la Légende';

  @override
  String get allTiers => 'Tous les rangs';

  @override
  String get topTier => 'Rang maximal';

  @override
  String lpToGo(int lp) {
    return '$lp PL';
  }

  @override
  String get unlockedEverything => 'Vous avez tout débloqué';

  @override
  String unlocksAt(String tier) {
    return 'Se débloque à $tier';
  }

  @override
  String get matchedSameGroup =>
      'Vous serez associé à quelqu\'un qui travaille le même groupe.';

  @override
  String get roomFriendly =>
      'Les duels en salon sont amicaux : ils n\'affectent pas votre rang.';

  @override
  String get createRoom => 'Créer un salon';

  @override
  String get enterCode => 'SAISIR LE CODE';

  @override
  String get joinRoom => 'Rejoindre le salon';

  @override
  String get shareThisCode => 'Partagez ce code';

  @override
  String get codeCopied => 'Code copié';

  @override
  String get pickMuscleAndStart => 'Choisir un muscle et commencer';

  @override
  String get dontGetOutrepd => 'Don\'t get OUTREPD!';

  @override
  String xOfY(int a, int b) {
    return '$a / $b';
  }

  @override
  String get tierStone => 'Pierre';

  @override
  String get tierBronze => 'Bronze';

  @override
  String get tierSilver => 'Argent';

  @override
  String get tierGold => 'Or';

  @override
  String get tierPlatinum => 'Platine';

  @override
  String get tierDiamond => 'Diamant';

  @override
  String get tierMaster => 'Maître';

  @override
  String get tierMythic => 'Mythique';

  @override
  String get tierLegend => 'Légende';

  @override
  String get rewardStone => 'Cadre de pierre';

  @override
  String get rewardBronze => 'Badge de bronze';

  @override
  String get rewardSilver => 'Badge d\'argent';

  @override
  String get rewardGold => 'Badge d\'or';

  @override
  String get rewardPlatinum => 'Badge de platine';

  @override
  String get rewardDiamond => 'Badge de diamant';

  @override
  String get rewardMaster => 'Badge de maître';

  @override
  String get rewardMythic => 'Badge mythique';

  @override
  String get rewardLegend => 'Badge de légende';

  @override
  String get shortKg => 'kg';

  @override
  String get shortLb => 'lb';

  @override
  String get shortCm => 'cm';

  @override
  String get shortFt => 'pi';

  @override
  String winLoss(int w, int l) {
    return '${w}V ${l}D';
  }

  @override
  String get yearsSuffix => 'ans';

  @override
  String get yourCrew => 'Votre équipe';

  @override
  String get crewName => 'Nom de l\'équipe';

  @override
  String get motto => 'Devise';

  @override
  String get mottoHint => 'Que représente cette équipe ?';

  @override
  String get country => 'Pays';

  @override
  String get whoCanJoin => 'Qui peut rejoindre';

  @override
  String get minimumRank => 'Rang minimal';

  @override
  String get anyone => 'Tout le monde';

  @override
  String get emblem => 'Emblème';

  @override
  String get colour => 'Couleur';

  @override
  String get createCrewButton => 'Créer l\'équipe';

  @override
  String get ownerNote =>
      'Vous en serez le propriétaire. Une équipe compte jusqu\'à 20 athlètes.';

  @override
  String get searchCountries => 'Rechercher un pays';

  @override
  String get noCountryMatch => 'Aucun pays ne correspond';

  @override
  String get nameTooShort =>
      'Donnez à l\'équipe un nom d\'au moins 3 caractères';

  @override
  String get privOpen => 'Ouverte';

  @override
  String get privRequest => 'Demande d\'adhésion';

  @override
  String get privInviteOnly => 'Sur invitation';

  @override
  String get privOpenHint => 'Toute personne ayant le code entre directement';

  @override
  String get privRequestHint => 'On postule, un responsable valide';

  @override
  String get privInviteOnlyHint => 'On n\'entre que sur invitation directe';

  @override
  String get embStrength => 'Force';

  @override
  String get embCombat => 'Combat';

  @override
  String get embBeasts => 'Bêtes';

  @override
  String get embElements => 'Éléments';

  @override
  String get embHonours => 'Honneurs';

  @override
  String get embSymbols => 'Symboles';

  @override
  String get ob1Title => 'Faites de chaque séance\nun duel';

  @override
  String get ob1Body =>
      'Enregistrez votre séance et affrontez quelqu\'un qui travaille le même groupe musculaire.';

  @override
  String get ob2Title => 'Défiez vos\namis';

  @override
  String get ob2Body =>
      'Envoyez une invitation privée et tranchez qui s\'entraîne le plus dur.';

  @override
  String get ob3Title => 'Grimpez les rangs';

  @override
  String get ob3Body =>
      'Chaque victoire rapporte des PL. Montez de Pierre jusqu\'à Légende.';

  @override
  String get ob4Title => 'L\'effort seul\nest difficile';

  @override
  String get ob4Body =>
      'S\'entraîner sans témoin rend facile d\'écourter la dernière série.';

  @override
  String get ob5Title => 'Devenez une\nLégende';

  @override
  String get ob5Body =>
      'La régularité s\'accumule. Présentez-vous, dépassez, progressez.';

  @override
  String get letsGo => 'C\'est parti';

  @override
  String get continueLabel => 'Continuer';
}
