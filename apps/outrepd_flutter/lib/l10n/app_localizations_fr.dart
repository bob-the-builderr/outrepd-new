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
  String yourFriends(String count) {
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
  String xOfY(String a, String b) {
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

  @override
  String get ttl_first_blood => 'Premier Sang';

  @override
  String get tdesc_first_blood => 'Terminez votre premier duel';

  @override
  String get ttl_found_footing => 'Pied Ferme';

  @override
  String get tdesc_found_footing => 'Terminez cinq duels';

  @override
  String get ttl_regular => 'Habitué';

  @override
  String get tdesc_regular => 'Vingt duels';

  @override
  String get ttl_fifty => 'Les Cinquante';

  @override
  String get tdesc_fifty => 'Cinquante duels';

  @override
  String get ttl_century => 'Centenaire';

  @override
  String get tdesc_century => 'Cent duels';

  @override
  String get ttl_veteran => 'Vétéran';

  @override
  String get tdesc_veteran => 'Deux cent cinquante duels';

  @override
  String get ttl_thousand_matches => 'Vieille Garde';

  @override
  String get tdesc_thousand_matches => 'Mille duels';

  @override
  String get ttl_first_win => 'Vainqueur';

  @override
  String get tdesc_first_win => 'Gagnez un duel';

  @override
  String get ttl_on_a_roll => 'En Série';

  @override
  String get tdesc_on_a_roll => 'Gagnez trois fois d\'affilée';

  @override
  String get ttl_five_straight => 'Cinq d\'Affilée';

  @override
  String get tdesc_five_straight => 'Gagnez cinq fois d\'affilée';

  @override
  String get ttl_unstoppable => 'Inarrêtable';

  @override
  String get tdesc_unstoppable => 'Gagnez dix fois d\'affilée';

  @override
  String get ttl_untouchable => 'Intouchable';

  @override
  String get tdesc_untouchable => 'Gagnez vingt fois d\'affilée';

  @override
  String get ttl_giant_slayer => 'Tueur de Géants';

  @override
  String get tdesc_giant_slayer => 'Battez quelqu\'un deux rangs au-dessus';

  @override
  String get ttl_comeback => 'Retour';

  @override
  String get tdesc_comeback => 'Gagnez juste après trois défaites';

  @override
  String get ttl_nemesis => 'Némésis';

  @override
  String get tdesc_nemesis => 'Battez le même athlète cinq fois';

  @override
  String get ttl_hundred_reps => 'Lancé';

  @override
  String get tdesc_hundred_reps => 'Cent répétitions comptées';

  @override
  String get ttl_five_hundred => 'Échauffé';

  @override
  String get tdesc_five_hundred => 'Cinq cents répétitions comptées';

  @override
  String get ttl_the_machine => 'La Machine';

  @override
  String get tdesc_the_machine => 'Mille répétitions comptées';

  @override
  String get ttl_five_thousand => 'Implacable';

  @override
  String get tdesc_five_thousand => 'Cinq mille répétitions comptées';

  @override
  String get ttl_ten_thousand => 'Dix Mille';

  @override
  String get tdesc_ten_thousand => 'Dix mille répétitions comptées';

  @override
  String get ttl_fifty_thousand => 'Au-delà du Compte';

  @override
  String get tdesc_fifty_thousand => 'Cinquante mille répétitions comptées';

  @override
  String get ttl_first_tonne => 'Une Tonne';

  @override
  String get tdesc_first_tonne => 'Déplacez mille kilos au total';

  @override
  String get ttl_ten_tonnes => 'Dix Tonnes';

  @override
  String get tdesc_ten_tonnes => 'Déplacez dix mille kilos';

  @override
  String get ttl_six_figures => 'Six Chiffres';

  @override
  String get tdesc_six_figures => 'Déplacez cent mille kilos';

  @override
  String get ttl_half_million => 'Demi-Million';

  @override
  String get tdesc_half_million => 'Déplacez cinq cent mille kilos';

  @override
  String get ttl_million_kg => 'Club du Million';

  @override
  String get tdesc_million_kg => 'Déplacez un million de kilos';

  @override
  String get ttl_two_days => 'De Retour';

  @override
  String get tdesc_two_days => 'Entraînez-vous deux jours de suite';

  @override
  String get ttl_no_days_off => 'Sans Repos';

  @override
  String get tdesc_no_days_off => 'Entraînez-vous sept jours de suite';

  @override
  String get ttl_fortnight => 'Quinzaine';

  @override
  String get tdesc_fortnight => 'Une série de quatorze jours';

  @override
  String get ttl_unbroken => 'Ininterrompu';

  @override
  String get tdesc_unbroken => 'Une série de trente jours';

  @override
  String get ttl_sixty_days => 'Habitude';

  @override
  String get tdesc_sixty_days => 'Une série de soixante jours';

  @override
  String get ttl_hundred_days => 'Cent Jours';

  @override
  String get tdesc_hundred_days => 'Une série de cent jours';

  @override
  String get ttl_year_round => 'Toute l\'Année';

  @override
  String get tdesc_year_round => 'Une série de trois cent soixante-cinq jours';

  @override
  String get ttl_perfect_week => 'Semaine Parfaite';

  @override
  String get tdesc_perfect_week => 'Entraînez-vous chaque jour d\'une semaine';

  @override
  String get ttl_perfect_month => 'Mois Parfait';

  @override
  String get tdesc_perfect_month => 'Quatre semaines parfaites';

  @override
  String get ttl_bronze_tier => 'Sorti de la Pierre';

  @override
  String get tdesc_bronze_tier => 'Atteignez Bronze';

  @override
  String get ttl_silver_tier => 'Argenté';

  @override
  String get tdesc_silver_tier => 'Atteignez Argent';

  @override
  String get ttl_golden_era => 'Âge d\'Or';

  @override
  String get tdesc_golden_era => 'Atteignez Or';

  @override
  String get ttl_platinum_tier => 'Platine';

  @override
  String get tdesc_platinum_tier => 'Atteignez Platine';

  @override
  String get ttl_diamond_tier => 'Mains de Diamant';

  @override
  String get tdesc_diamond_tier => 'Atteignez Diamant';

  @override
  String get ttl_master_tier => 'Maître';

  @override
  String get tdesc_master_tier => 'Atteignez Maître';

  @override
  String get ttl_mythic_tier => 'Mythique';

  @override
  String get tdesc_mythic_tier => 'Atteignez Mythique';

  @override
  String get ttl_legend_tier => 'Légende';

  @override
  String get tdesc_legend_tier => 'Atteignez Légende';

  @override
  String get ttl_clean_hands => 'Mains Propres';

  @override
  String get tdesc_clean_hands =>
      'Une série entière avec chaque répétition comptée';

  @override
  String get ttl_spotless => 'Impeccable';

  @override
  String get tdesc_spotless => 'Dix séries propres';

  @override
  String get ttl_textbook => 'Manuel';

  @override
  String get tdesc_textbook => 'Cinquante séries propres';

  @override
  String get ttl_iron_hold => 'Prise de Fer';

  @override
  String get tdesc_iron_hold => 'Tenez une planche deux minutes';

  @override
  String get ttl_statue => 'Statue';

  @override
  String get tdesc_statue => 'Tenez une planche cinq minutes';

  @override
  String get ttl_all_rounder => 'Polyvalent';

  @override
  String get tdesc_all_rounder => 'Comptez cinq exercices différents';

  @override
  String get ttl_explorer => 'Explorateur';

  @override
  String get tdesc_explorer => 'Comptez quinze exercices différents';

  @override
  String get ttl_encyclopedia => 'Encyclopédie';

  @override
  String get tdesc_encyclopedia => 'Comptez quarante exercices différents';

  @override
  String get ttl_early_bird => 'Poste du Matin';

  @override
  String get tdesc_early_bird => 'Dix séances avant sept heures';

  @override
  String get ttl_sunrise_club => 'Club de l\'Aube';

  @override
  String get tdesc_sunrise_club => 'Cinquante séances avant sept heures';

  @override
  String get ttl_night_owl => 'Poste de Nuit';

  @override
  String get tdesc_night_owl => 'Dix séances après vingt-deux heures';

  @override
  String get ttl_graveyard => 'Poste de Minuit';

  @override
  String get tdesc_graveyard => 'Cinquante séances après vingt-deux heures';

  @override
  String get ttl_joined_up => 'Enrôlé';

  @override
  String get tdesc_joined_up => 'Faites partie d\'une équipe';

  @override
  String get ttl_backbone => 'Colonne Vertébrale';

  @override
  String get tdesc_backbone => 'Menez votre équipe quatre semaines de suite';

  @override
  String get ttl_cornerstone => 'Pierre Angulaire';

  @override
  String get tdesc_cornerstone => 'Menez votre équipe douze semaines de suite';

  @override
  String get ttl_not_alone => 'Pas Seul';

  @override
  String get tdesc_not_alone => 'Ajoutez votre premier ami';

  @override
  String get ttl_well_connected => 'Bien Entouré';

  @override
  String get tdesc_well_connected => 'Dix amis';

  @override
  String get ttl_the_gym_knows => 'La Salle Vous Connaît';

  @override
  String get tdesc_the_gym_knows => 'Cinquante amis';

  @override
  String get finish2 => 'Terminer';

  @override
  String get qExperience => 'Quelle est votre expérience\nde l\'entraînement ?';

  @override
  String get expBeginner => 'Débutant – J\'ai déjà essayé';

  @override
  String get expIntermediate => 'Intermédiaire – Je m\'entraîne régulièrement';

  @override
  String get expAdvanced => 'Avancé – Des années de pratique';

  @override
  String get qGoal => 'Quel est votre objectif\nprincipal ?';

  @override
  String get goalStronger => 'Devenir plus fort';

  @override
  String get goalConsistent => 'Devenir plus régulier';

  @override
  String get goalLean => 'Perdre du poids et m\'affiner';

  @override
  String get goalMass => 'Prendre de la masse musculaire';

  @override
  String get aboutYou => 'Ce parcours ne parle que de vous...';

  @override
  String get qThinkAbout =>
      'À quelle fréquence pensez-vous\nà vous remettre en forme ?';

  @override
  String get freqNever => 'Jamais';

  @override
  String get freqSometimes => 'Parfois';

  @override
  String get freqOften => 'Souvent';

  @override
  String get freqAllTime => 'Tout le temps';

  @override
  String get qEnergy => 'Comment est votre énergie\npendant les séances ?';

  @override
  String get energyLow => 'Basse, je me sens vidé toute la journée';

  @override
  String get energyDrops => 'Mes performances chutent en milieu de séance';

  @override
  String get energyHard => 'Difficile de tenir la dernière série';

  @override
  String get energyHigh => 'Haute et stable du début à la fin';

  @override
  String get stProgress =>
      'Parfois, j\'ai du mal à voir mes progrès quand je m\'entraîne';

  @override
  String get stEffortTitle =>
      'L\'effort que personne ne voit\nest facile à abandonner';

  @override
  String get stEffortBody =>
      'Sans personne à qui se mesurer, les progrès paraissent lents et l\'effort inutile';

  @override
  String get stAloneTitle => 'S\'entraîner seul,\nc\'est ennuyeux';

  @override
  String get stAloneBody =>
      'Personne ne regarde. Personne ne compte. Il est facile de sauter une répétition, ou la série entière';

  @override
  String get qName => 'Comment doit-on\nvous appeler ?';

  @override
  String get nameHint =>
      'Au moins 3 caractères. C\'est ce que verront vos rivaux.';

  @override
  String get basicInfo => 'Bien ! Passons aux\ninformations de base';

  @override
  String get qAge => 'Quel âge avez-vous ?';

  @override
  String get qWeight => 'Quel est votre\npoids actuel ?';

  @override
  String get weightWhy =>
      'Le poids de corps est indispensable pour calculer votre rang.';

  @override
  String get privateNote =>
      'Vos informations restent privées et ne seront partagées avec personne.';

  @override
  String get qHeight => 'Combien mesurez-vous ?';

  @override
  String get qRelate => 'Vous reconnaissez-vous dans\nla phrase ci-dessous ?';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get grindTitle => 'L\'effort a une autre saveur\nface à un rival';

  @override
  String get grindBody =>
      'Chaque duel vous oppose à un adversaire réel : faites le travail et prouvez qui s\'est entraîné le plus dur.';

  @override
  String get allSet => 'Tout est prêt !';

  @override
  String welcomeLifter(String name) {
    return 'Bienvenue, $name. Il est temps de trouver votre premier rival.';
  }

  @override
  String get lifter => 'athlète';

  @override
  String get enterApp => 'Entrer dans OUTREPD';

  @override
  String get commitTitle =>
      'Prenons maintenant un engagement\nenvers votre parcours';

  @override
  String get holdLogo => 'Maintenez le logo pour confirmer que vous êtes prêt';

  @override
  String get expNone => 'Je ne me suis jamais entraîné';

  @override
  String get iAm => 'Je suis...';

  @override
  String get finishMatchQ => 'Terminer le duel ?';

  @override
  String get finishMatchBody =>
      'Votre volume sera figé et comparé à celui de votre adversaire.';

  @override
  String get keepGoing => 'Continuer';

  @override
  String get forfeitQ => 'Abandonner le duel ?';

  @override
  String get forfeitBody => 'Vous perdrez des PL si vous partez maintenant.';

  @override
  String get stay => 'Rester';

  @override
  String get forfeit => 'Abandonner';

  @override
  String get pickExercises => 'Choisissez les exercices que vous allez faire';

  @override
  String matchingWith(String muscle) {
    return 'Recherche d\'un athlète de votre rang · $muscle';
  }

  @override
  String get getReady => 'PRÊT';

  @override
  String get timeLeft => 'TEMPS RESTANT';

  @override
  String vsName(String name) {
    return 'vs $name';
  }

  @override
  String kgTotalVolume(String unit) {
    return '$unit de volume total';
  }

  @override
  String get finishMatch => 'TERMINER LE DUEL';

  @override
  String get kgHint => 'KG';

  @override
  String get repsHint => 'RÉPS';

  @override
  String get addSet => 'AJOUTER UNE SÉRIE';

  @override
  String get matchComplete => 'DUEL TERMINÉ';

  @override
  String get you => 'VOUS';

  @override
  String get vs => 'VS';

  @override
  String get backToHome => 'RETOUR À L\'ACCUEIL';

  @override
  String get mgChest => 'Pectoraux';

  @override
  String get mgBack => 'Dos';

  @override
  String get mgLegs => 'Jambes';

  @override
  String get mgShoulders => 'Épaules';

  @override
  String get mgArms => 'Bras';

  @override
  String get mgCore => 'Gainage';

  @override
  String get achRivalry => 'Rivalité';

  @override
  String get achRivalryHint => 'Battez le même adversaire 3 fois';

  @override
  String get nWonTitle => 'Vous avez gagné !';

  @override
  String nWonBody(String name, String muscle) {
    return 'Vous avez battu $name au jour $muscle';
  }

  @override
  String get nFriendTitle => 'Nouvelle demande d\'ami';

  @override
  String nFriendBody(String name) {
    return '$name souhaite vous ajouter';
  }

  @override
  String get nAchTitle => 'Succès débloqué';

  @override
  String nAchBody(String title, String hint) {
    return '$title — $hint';
  }

  @override
  String get nRankTitle => 'Montée de rang !';

  @override
  String nRankBody(String rank) {
    return 'Vous avez atteint $rank';
  }

  @override
  String get nameTooShortInline => 'Choisissez un nom d\'au moins 3 caractères';

  @override
  String get whyName => 'Vos rivaux le verront à côté de chaque résultat';

  @override
  String get whyExperience => 'Nous vous opposons à des gens de votre niveau';

  @override
  String get whyGoal => 'Vos premiers exercices suggérés en découlent';

  @override
  String get whyAge =>
      'L\'âge influe sur les standards de force auxquels vous êtes comparé';

  @override
  String get whyWeight =>
      'Le rang compare les charges rapportées au poids de corps, pas les kilos bruts';

  @override
  String get whyHeight =>
      'Utilisée avec votre poids pour fixer des standards équitables';

  @override
  String get whyHabits =>
      'Cela détermine les rappels et l\'objectif hebdomadaire proposés';

  @override
  String get transitionPartOfIt =>
      '...alors assurons-nous que vous en faites vraiment partie.';

  @override
  String get male => 'Homme';

  @override
  String get female => 'Femme';

  @override
  String get usernamePlaceholder => 'pseudo';

  @override
  String get stRoutine =>
      'Je ne sais pas quelle partie du corps a vraiment besoin de travail, alors je répète souvent la même routine';

  @override
  String get shortIn => 'po';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String daysAgo(String n) {
    return 'il y a $n jours';
  }

  @override
  String weeksAgo(String n) {
    return 'il y a $n semaines';
  }

  @override
  String membersCount(String n) {
    return '$n membres';
  }

  @override
  String eachCount(String n) {
    return '$n par personne';
  }

  @override
  String lpAmount(String n) {
    return '$n PL';
  }

  @override
  String get countWithCamera => 'Compter à la caméra';

  @override
  String get youWin => 'VOUS GAGNEZ !';

  @override
  String get defeated => 'DÉFAITE';
}
