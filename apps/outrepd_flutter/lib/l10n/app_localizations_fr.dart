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
  String get tabProfile => 'Profil';

  @override
  String get challengeFriend => 'Défier un ami';

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
  String get settings => 'Réglages';

  @override
  String get accountSection => 'Compte';

  @override
  String get duelSection => 'Duel';

  @override
  String get hapticsEachRep => 'Vibration à chaque répétition';

  @override
  String get showSkeleton => 'Afficher le squelette';

  @override
  String get showSkeletonHint =>
      'C\'est comme ça que tu vois que la caméra te suit';

  @override
  String get manageNotifications => 'Gérer les notifications';

  @override
  String switchesOn(String on, String all) {
    return '$on sur $all activées';
  }

  @override
  String get whoCanChallenge => 'Qui peut me défier';

  @override
  String get blockedAccounts => 'Comptes bloqués';

  @override
  String get reportProblem => 'Signaler un problème';

  @override
  String get onDeviceNote =>
      'La détection de posture tourne sur ce téléphone. Aucune vidéo ni donnée de posture n\'est envoyée.';

  @override
  String get visibilitySection => 'Visibilité';

  @override
  String get showMyCountry => 'Afficher mon pays';

  @override
  String get showMyCountryHint =>
      'Désactivé, tu quittes le classement de ton pays';

  @override
  String get safetySection => 'Sécurité';

  @override
  String get socialSection => 'Social';

  @override
  String get noticeRaced => 'Quelqu\'un a défié ma série';

  @override
  String get noticeRacedHint => 'Le seul moyen de savoir qu\'un duel a eu lieu';

  @override
  String get noticeFriendOk => 'Ma demande a été acceptée';

  @override
  String get noticesStoredNote =>
      'Désactiver veut dire jamais enregistré, pas simplement masqué.';

  @override
  String get notSaved => 'Non enregistré';

  @override
  String get blockedIntro =>
      'Un compte bloqué ne peut ni te défier, ni te trouver, ni t\'envoyer de demande. Il n\'en est pas informé.';

  @override
  String blockedWhen(String when) {
    return 'Bloqué $when';
  }

  @override
  String get unblock => 'Débloquer';

  @override
  String get noBlockedTitle => 'Personne de bloqué';

  @override
  String get noBlockedBody =>
      'Tu peux bloquer quelqu\'un depuis son profil ou un signalement.';

  @override
  String get whatHappened => 'Que s\'est-il passé';

  @override
  String get reasonCheating => 'Triche ou répétitions truquées';

  @override
  String get reasonHarassment => 'Harcèlement ou abus';

  @override
  String get reasonContent => 'Contenu inapproprié';

  @override
  String get reasonImpersonation => 'Usurpation d\'identité';

  @override
  String get reasonOther => 'Autre chose';

  @override
  String get addDetails => 'Ajouter des détails (facultatif)';

  @override
  String get alsoBlock => 'Bloquer aussi ce compte';

  @override
  String get sendReport => 'Envoyer le signalement';

  @override
  String get reportSent => 'Signalement envoyé';

  @override
  String get reportingThisAccount => 'Signalement de ce compte';

  @override
  String get exportIntro =>
      'On t\'envoie par mail un fichier avec tout ce que le serveur a sur toi. Ça prend en général une minute.';

  @override
  String get whatsIncluded => 'Ce qui est inclus';

  @override
  String get incProfile => 'Ton profil et ton rang';

  @override
  String get incSets => 'Chaque série et chaque compte';

  @override
  String get incDuels => 'Historique des duels et variations de LP';

  @override
  String get incFriends => 'Amis et comptes bloqués';

  @override
  String get incNotices => 'Les notifications reçues';

  @override
  String get noLandmarksNote =>
      'Les points de posture n\'y sont pas, et n\'y ont jamais été. La caméra les lit sur ton téléphone et rien n\'est envoyé.';

  @override
  String get sendItTo => 'Envoyer à';

  @override
  String get emailHint => 'toi@exemple.com';

  @override
  String get createAccountTitle => 'Créer un compte';

  @override
  String get createAccountBody => 'Connecte-toi pour que ce compte ne dépende pas d’un seul téléphone.';

  @override
  String get createAccountAction => 'Créer un compte';

  @override
  String get emailTakenSwitchToSignIn =>
      'Cet e-mail a déjà un compte — connecte-toi plutôt.';

  @override
  String get emailSignUpInvalid =>
      'Vérifie l\'e-mail et le mot de passe — six caractères minimum.';

  @override
  String get tooManyCodes =>
      'Trop de codes envoyés — attends quelques minutes puis réessaie.';

  @override
  String get sendCodeAction => 'Envoyer le code';

  @override
  String get noAccountForEmail =>
      'Nous n\'avons trouvé aucun compte avec cet e-mail.';

  @override
  String get authEntryTagline => 'Pousse. Affronte. Grimpe.';

  @override
  String get signUpWithEmail => 'S\'inscrire avec l\'e-mail';

  @override
  String get alreadyHaveAccountQuestion => 'Tu as déjà un compte ?';

  @override
  String get logInAction => 'Se connecter';

  @override
  String get createYourAccountTitle => 'Crée ton compte';

  @override
  String get createAccountSubtitle => 'Ça prend moins d\'une minute.';

  @override
  String get usernameLabel => 'Nom d\'utilisateur';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get logInSubtitle => 'Connecte-toi pour garder ton rang.';

  @override
  String get checkYourEmailTitle => 'Vérifie ton e-mail';

  @override
  String codeSentTo(String email) {
    return 'Nous avons envoyé un code à 6 chiffres à $email.';
  }

  @override
  String get didntGetIt => 'Tu ne l\'as pas reçu ?';

  @override
  String resendInSeconds(String time) {
    return 'Renvoyer dans $time';
  }

  @override
  String get wrongEmailGoBack => 'Mauvais e-mail ? Retour';

  @override
  String get usernameTaken => 'Ce nom d\'utilisateur est déjà pris.';

  @override
  String get wrongCode => 'Ce code est faux ou a expiré.';

  @override
  String get resendCode => 'Renvoyer le code';

  @override
  String get codeResent => 'Nouveau code envoyé.';

  @override
  String signedInAs(String email) {
    return 'Connecté avec $email';
  }

  @override
  String get addressNotKept =>
      'L\'adresse sert une fois et n\'est pas conservée — ce compte n\'a pas d\'email.';

  @override
  String get requestMyData => 'M\'envoyer mes données';

  @override
  String exportSent(String address) {
    return 'Envoyé à $address';
  }

  @override
  String get deleteIntro =>
      'Cela efface tout définitivement. C\'est irréversible et rien ne peut être restauré.';

  @override
  String get rankLabel => 'Rang';

  @override
  String get wantCopyFirst => 'Tu veux une copie d\'abord ?';

  @override
  String get wantCopyBody =>
      'Télécharge tes données avant de supprimer. Après, c\'est perdu.';

  @override
  String typeToConfirm(String word) {
    return 'Tape $word pour confirmer';
  }

  @override
  String get deleteWord => 'SUPPRIMER';

  @override
  String get deletePermanently => 'Supprimer définitivement';

  @override
  String get keepMyAccount => 'Garder mon compte';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get skip => 'Passer';

  @override
  String get yourPicture => 'Votre photo';

  @override
  String get yourPictureHint =>
      'Le cadre vient de votre rang et change quand vous montez.';

  @override
  String get couldNotUsePicture => 'Impossible d\'utiliser cette photo';

  @override
  String get couldNotSyncAvatar =>
      'Votre photo est enregistrée, mais pas encore synchronisée';

  @override
  String get couldNotShareCard => 'Impossible de partager cette carte';

  @override
  String get couldNotOpenLink => 'Impossible d\'ouvrir ce lien';

  @override
  String get couldNotCheckUsername =>
      'Impossible de vérifier ce nom — réessayez';

  @override
  String get changeUsername => 'Changer de nom d\'utilisateur';

  @override
  String get usernameInvalidLength =>
      'Doit comporter de 4 à 20 caractères : lettres, chiffres et _ uniquement';

  @override
  String get usernameChanged => 'Nom d\'utilisateur modifié';

  @override
  String get usernameAlreadyChangedBody => 'Le nom d\'utilisateur peut être changé une fois tous les 14 jours.';

  @override
  String get gallery => 'Galerie';

  @override
  String get camera => 'Caméra';

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
  String get global => 'Mondial';

  @override
  String get topPlayers => 'Meilleurs joueurs';

  @override
  String get yourTier => 'Votre palier';

  @override
  String get challenge => 'Défier';

  @override
  String get notifications => 'Notifications';

  @override
  String get start => 'Commencer';

  @override
  String get finish => 'Terminer';

  @override
  String get reps => 'reps';

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
  String get language => 'Langue';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get data => 'Données';

  @override
  String get about => 'À propos';

  @override
  String get themeSystem => 'Comme l\'appareil';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get accept => 'Accepter';

  @override
  String get visEveryone => 'Tout le monde';

  @override
  String get visFriends => 'Amis seulement';

  @override
  String get visNobody => 'Personne';

  @override
  String get friendRequestsLabel => 'Demandes d\'amis';

  @override
  String get showOnLeaderboards => 'M\'afficher dans les classements';

  @override
  String get exportData => 'Exporter mes données';

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
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get needsServer =>
      'Connexion impossible. Vérifie ta connexion internet et réessaie.';

  @override
  String get roomFriendly =>
      'Les duels en salon sont amicaux : ils n\'affectent pas votre rang.';

  @override
  String get shareThisCode => 'Partagez ce code';

  @override
  String get codeCopied => 'Code copié';

  @override
  String xOfY(String a, String b) {
    return '$a / $b';
  }

  @override
  String get tierIron => 'Fer';

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
  String winLoss(String w, String l) {
    return '${w}V ${l}D';
  }

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
  String get ttl_bronze_tier => 'Sorti du Fer';

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
  String get forfeitQ => 'Abandonner le duel ?';

  @override
  String get forfeitBody => 'Vous perdrez des PL si vous partez maintenant.';

  @override
  String get forfeit => 'Abandonner';

  @override
  String get getReady => 'PRÊT';

  @override
  String get you => 'VOUS';

  @override
  String get vs => 'VS';

  @override
  String get backToHome => 'RETOUR À L\'ACCUEIL';

  @override
  String get mgChest => 'Pectoraux';

  @override
  String get nWonTitle => 'Vous avez gagné !';

  @override
  String nWonBody(String name, String muscle) {
    return 'Vous avez battu $name au jour $muscle';
  }

  @override
  String get nFriendTitle => 'Nouvelle demande d\'ami';

  @override
  String get nRacedTitle => 'Ta série a été défiée';

  @override
  String nRacedHeld(String name, String yours, String theirs) {
    return '$name a défié ta série sans y arriver, $yours–$theirs';
  }

  @override
  String nRacedBeaten(String name, String theirs, String yours) {
    return '$name a défié ta série et l\'a emporté, $theirs–$yours';
  }

  @override
  String get nFriendOkTitle => 'Demande d\'ami acceptée';

  @override
  String nFriendOkBody(String name) {
    return '$name a accepté ta demande';
  }

  @override
  String nFriendBody(String name) {
    return '$name souhaite vous ajouter';
  }

  @override
  String get nChallengedTitle => 'Revanche';

  @override
  String nChallengedBody(String name) {
    return '$name veut une revanche';
  }

  @override
  String get challengeSentTitle => 'Défi envoyé';

  @override
  String challengeSentBody(String name) {
    return 'Nous préviendrons $name. Reviens une fois qu\'il l\'aura disputé.';
  }

  @override
  String get challengeNotSentTitle => 'Échec de l\'envoi';

  @override
  String get challengeNotSentBody =>
      'Vérifie ta connexion et réessaie depuis l\'onglet Match.';

  @override
  String get challengeGoneTitle => 'Le défi n\'existe plus';

  @override
  String get challengeGoneBody => 'Il a déjà été disputé, ou il a été retiré.';

  @override
  String repsRecordedLine(String reps) {
    return '$reps répétitions enregistrées';
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
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String daysAgo(String n) {
    return 'il y a $n jours';
  }

  @override
  String weeksAgo(String n) {
    return 'il y a ${n} semaines';
  }

  @override
  String lpAmount(String n) {
    return '$n PL';
  }

  @override
  String get lpUnit => 'PL';

  @override
  String get trueCountHint => 'p. ex. 12';

  @override
  String get couldNotSaveSession => 'Impossible d\'enregistrer la séance';

  @override
  String lpOutOf(String total) {
    return '/ $total PL';
  }

  @override
  String get noFriendsTitle => 'Pas encore d\'amis';

  @override
  String get noFriendsBody =>
      'Un duel contre quelqu’un que tu connais, ça n’a rien à voir.';

  @override
  String get decline => 'Refuser';

  @override
  String requestSent(String name) {
    return 'Demande envoyée à $name';
  }

  @override
  String nowFriends(String name) {
    return '$name et toi êtes maintenant amis';
  }

  @override
  String get noOneFound => 'Personne ne porte ce nom';

  @override
  String get noMatchesTitle => 'Pas encore de duels';

  @override
  String get noMatchesBody => 'Le premier apparaîtra ici, gagné ou perdu.';

  @override
  String get noNotificationsTitle => 'Rien de neuf';

  @override
  String get noNotificationsBody =>
      'Les invitations, les résultats et les demandes d’ami arrivent ici.';

  @override
  String get countedThat => 'Compté sur ce round';

  @override
  String get thatIsRight => 'C\'est bon';

  @override
  String get useMyCount => 'Utiliser mon compte';

  @override
  String get confirmHint => 'Corrigez si la caméra s\'est trompée.';

  @override
  String get unsureMovement =>
      'Pas sûr que ce soit le bon mouvement — vérifiez le nombre.';

  @override
  String get noRanksYet => 'Pas encore de classement';

  @override
  String get noRanksYetBody => 'Joue un duel et le classement se remplit.';

  @override
  String get ranksTitle => 'Rangs';

  @override
  String get totalReps => 'Répétitions au total';

  @override
  String get recent => 'Récents';

  @override
  String wonVs(String name) {
    return 'Victoire contre ${name}';
  }

  @override
  String lostVs(String name) {
    return 'Défaite contre ${name}';
  }

  @override
  String hoursAgo(String n) {
    return 'il y a ${n} h';
  }

  @override
  String toNextTier(String n, String tier) {
    return '${n} avant ${tier}';
  }

  @override
  String get noMatchesYet => 'Pas encore de duels';

  @override
  String get noMatchesYetBody => 'Le premier apparaîtra ici, victoire ou défaite.';

  @override
  String get searchByUsername => 'Rechercher par nom d\'utilisateur';

  @override
  String get incomingRequests => 'Demandes reçues';

  @override
  String get noRequestsWaiting => 'Aucune demande en attente pour l\'instant';

  @override
  String get addFriendAction => 'Ajouter un ami';

  @override
  String get addFriendHint =>
      'Saisissez leur nom d\'utilisateur ou le code # de leur profil.';

  @override
  String get usernameOrCode => 'Nom d\'utilisateur ou code #';

  @override
  String get sendRequest => 'Envoyer la demande';

  @override
  String onlineNowCount(String count) {
    return 'En ligne · $count';
  }

  @override
  String offlineCount(String count) {
    return 'Hors ligne · $count';
  }

  @override
  String get invite => 'Inviter';

  @override
  String get headToHeadTitle => 'Face à face';

  @override
  String get vsYouCaption => 'contre toi';

  @override
  String get h2hYou => 'toi';

  @override
  String get h2hThem => 'lui';

  @override
  String headToHead(String wins, String losses) {
    return '${wins}V ${losses}D contre toi';
  }

  @override
  String get neverPlayedYou => 'Jamais joué contre toi';

  @override
  String noHistoryWithThem(String username) {
    return 'Tu n\'as pas encore affronté $username.';
  }

  @override
  String lastDuelScore(String yourReps, String theirReps, String when) {
    return 'Dernière fois : $yourReps–$theirReps, $when.';
  }

  @override
  String yourBestVsThemLine(String reps) {
    return 'Ton meilleur score contre lui est $reps.';
  }

  @override
  String get viewFullProfile => 'Voir le profil complet';

  @override
  String get moreOptions => 'Plus d\'options';

  @override
  String get block => 'Bloquer';

  @override
  String get blockRowBody => 'Il ne pourra plus te défier ni voir ton profil';

  @override
  String get report => 'Signaler';

  @override
  String get reportRowBody => 'Examiné sous 24 heures';

  @override
  String muteChallenges(String username) {
    return 'Masquer les défis de $username';
  }

  @override
  String blockedLifter(String username) {
    return '$username bloqué';
  }

  @override
  String mutedLifter(String username) {
    return '$username masqué';
  }

  @override
  String get addFriendButton => 'Ajouter en ami';

  @override
  String get alreadyFriends => 'Amis';

  @override
  String get couldNotLoadProfile => 'Impossible de charger ce profil';

  @override
  String get noFriendsMatch => 'Personne à ce nom';

  @override
  String get yourClimb => 'Ton ascension';

  @override
  String floorKept(String tier, String rank) {
    return '$tier est à toi. Tu ne descendras plus sous $rank.';
  }

  @override
  String dayStreakCount(String count) {
    return '$count jours d’affilée';
  }

  @override
  String get findMatch => 'Trouver un match';

  @override
  String rankedTerms(String seconds) {
    return '$seconds secondes · classé';
  }

  @override
  String get practiceTerms => 'S’entraîner — sans classement, sans adversaire';

  @override
  String get practiceComplete => 'ENTRAÎNEMENT TERMINÉ';

  @override
  String get noRankYet => 'Pas encore classé';

  @override
  String get unranked => 'Non classé';

  @override
  String get practiceFirst => 'S’entraîner d’abord';

  @override
  String get noConnection => 'Pas de connexion';

  @override
  String get practiceOffline => 'S’entraîner hors ligne';

  @override
  String get retry => 'Réessayer';

  @override
  String get youWonPlain => 'Tu as gagné';

  @override
  String get cameraNeededTitle => 'Accès caméra nécessaire';

  @override
  String get cameraNeededBody =>
      'outrepd compte tes répétitions en observant ton corps. La détection tourne sur ton appareil et rien n’est envoyé.';

  @override
  String get openSettings => 'Ouvrir les réglages';

  @override
  String get allowCamera => 'Autoriser la caméra';

  @override
  String get notNow => 'Pas maintenant';

  @override
  String get noCameraTitle => 'Aucune caméra';

  @override
  String get noCameraBody =>
      'Les répétitions sont comptées par la caméra, cet appareil ne peut donc pas noter un duel. Le reste fonctionne.';

  @override
  String get noConnectionBody =>
      'Il te faut une connexion pour te mesurer à quelqu’un. L’entraînement marche hors ligne et tes répétitions se synchroniseront ensuite.';

  @override
  String get getBackInFrame => 'Reviens dans le cadre';

  @override
  String get clockStillRunning =>
      'Le chrono tourne toujours. Rien n’est compté.';

  @override
  String get giveUp => 'Abandonner';

  @override
  String get lpMovesWithGap =>
      'Les PL évoluent selon l\'écart de répétitions — gagnez avec plus d\'écart, gagnez plus de points';

  @override
  String get searchingForOpponent => 'Recherche d’un adversaire';

  @override
  String get getIntoPosition => 'Mets-toi en position';

  @override
  String get framingHint => 'Poignets et chevilles doivent être dans le cadre';

  @override
  String get goUp => 'Monte';

  @override
  String get goDown => 'Descends';

  @override
  String get bestSet => 'Meilleure série';

  @override
  String get record => 'Bilan';

  @override
  String get last7Days => '7 derniers jours';

  @override
  String repsCount(String count) {
    return '$count rép.';
  }

  @override
  String get viewAll => 'Tout voir';

  @override
  String get shareProfile => 'Partager le profil';

  @override
  String get share => 'Partager';

  @override
  String get duelMeOnOutrepd => 'Défie-moi sur outrepd';

  @override
  String get shareStory => 'Story';

  @override
  String get sharePost => 'Publication';

  @override
  String get copyLink => 'Copier';

  @override
  String get linkCopied => 'Lien copié';

  @override
  String get currentRankLabel => 'Rang actuel';

  @override
  String get winInitial => 'V';

  @override
  String get lossInitial => 'D';

  @override
  String get dayInitial => 'j';

  @override
  String rankPosition(String n) {
    return '#$n';
  }

  @override
  String get obTagline =>
      'Duels de pompes. Ton téléphone compte. Quelqu’un d’autre compte aussi.';

  @override
  String get obGetStarted => 'C’est parti';

  @override
  String get obHaveAccount => 'J’ai déjà un compte';

  @override
  String get obTwoThings => 'Deux petites choses.';

  @override
  String get obAgeQuestion => 'Quel âge as-tu ?';

  @override
  String get obUnder16 => 'Moins de 16 ans';

  @override
  String get obOver16 => '16 ans ou plus';

  @override
  String get obHealthConsent =>
      'Je comprends qu’outrepd compte les répétitions et ne donne aucun conseil médical ni sportif. J’arrête si quelque chose fait mal.';

  @override
  String get obTermsIntro => 'En continuant, tu acceptes les';

  @override
  String get obTerms => 'Conditions';

  @override
  String get obAnd => 'et la';

  @override
  String get obPrivacy => 'Politique de confidentialité';

  @override
  String get obUnder16Blocked =>
      'outrepd, c’est à partir de 16 ans. Reviens quand tu y seras — les pompes ne bougeront pas.';

  @override
  String get obCameraTitle => 'outrepd a besoin de ta caméra';

  @override
  String get obCameraBody =>
      'Elle suit les mouvements de ton corps pour compter. Il n’y a pas d’autre moyen.';

  @override
  String get obCameraPrivateTitle => 'Rien ne quitte ton téléphone';

  @override
  String get obCameraPrivateBody =>
      'Le suivi du corps se fait sur cet appareil. Aucune vidéo n\'est jamais enregistrée ni envoyée.';

  @override
  String get obWhyNeeded => 'Pourquoi c’est nécessaire ?';

  @override
  String get obPlacementTitle => 'Pose ton téléphone au sol';

  @override
  String get obPlacementBody =>
      'Adosse-le à un mur, à environ un mètre devant toi.';

  @override
  String get obCheckHandsFeet => 'Tête, épaules et mains dans le cadre';

  @override
  String get obCheckFacing => 'Face au téléphone, pas de profil';

  @override
  String get obCheckLight => 'Lumière allumée';

  @override
  String get obImSetUp => 'Je suis prêt';

  @override
  String get obFramingTitle => 'Mets-toi en position de pompe';

  @override
  String get obFramingShoulders => 'Épaules et hanches';

  @override
  String get obFramingWrists => 'Poignets';

  @override
  String get obLooksGood => 'C’est bon';

  @override
  String get obCalibrating => 'Calibrage';

  @override
  String get obOneMoreRep => 'Encore une pour connaître ton amplitude';

  @override
  String get obCalibrationHint =>
      'Fais trois pompes à ta profondeur habituelle';

  @override
  String get obCalibrated => 'Calibré.';

  @override
  String get obCalibratedBody =>
      'outrepd connaît ton amplitude. La profondeur se mesure par rapport à toi, pas à un chiffre fixe.';

  @override
  String get obRepsCounted => 'Répétitions comptées';

  @override
  String get obAverageDepth => 'Profondeur moyenne';

  @override
  String get obForm => 'Exécution';

  @override
  String get obFormClean => 'Propre';

  @override
  String get obAvailable => 'Disponible';

  @override
  String get obTaken => 'Pris';

  @override
  String get obGotIt => 'Compris';

  @override
  String get obFormMixed => 'Irrégulière';

  @override
  String get justNow => 'À l’instant';

  @override
  String get counterAccuracy => 'Précision du compteur';

  @override
  String get counterAccuracyCaption => 'À quel point la caméra tombe juste';

  @override
  String measuredOverSets(String count) {
    return 'Mesuré sur $count séries';
  }

  @override
  String get accExact => 'Exact';

  @override
  String get accWithinOne => '±1 répétition';

  @override
  String get accAverageMiss => 'Écart moyen';

  @override
  String get accTendsTo => 'A tendance à';

  @override
  String get accCountsHigh => 'compter en trop';

  @override
  String get accCountsLow => 'compter en moins';

  @override
  String get accCountsEven => 'ni trop ni trop peu';

  @override
  String get accWorstMiss => 'Pire écart';

  @override
  String get accNothingYet => 'Rien de mesuré pour l’instant';

  @override
  String get accNothingYetBody =>
      'Chaque fois que tu confirmes le compte après une série d\'entraînement, cette série est comparée à ce que tu as indiqué. Le chiffre apparaît ici.';

  @override
  String accNeedMore(String count) {
    return 'C’est encore tôt. Environ $count séries de plus pour que ce chiffre veuille dire quelque chose.';
  }

  @override
  String get accRecentSets => 'Dernières séries';

  @override
  String get accCameraSaid => 'Caméra';

  @override
  String get accYouSaid => 'Toi';

  @override
  String get accHowItWorks =>
      'Ça vient de toi, sur ce téléphone. Rien n’est envoyé nulle part.';

  @override
  String levelNumber(String n) {
    return 'Niveau $n';
  }

  @override
  String get youLostPlain => 'Tu as perdu';

  @override
  String get rematch => 'Revanche';

  @override
  String get shareAction => 'Partager';

  @override
  String get doneAction => 'Terminé';

  @override
  String get continueAction => 'Continuer';

  @override
  String get promotedLabel => 'Promu';

  @override
  String get highestReached => 'Ton plus haut niveau atteint';

  @override
  String repsOff(String n) {
    return 'À $n répétitions près.';
  }

  @override
  String get closestYet => 'Le duel le plus serré jusqu’ici.';

  @override
  String repsAhead(String n) {
    return '$n répétitions d\'avance.';
  }

  @override
  String get winnerLabel => 'Vainqueur';

  @override
  String get newPersonalBest => 'Nouveau record personnel';

  @override
  String get cantReachServer =>
      'Impossible de joindre le serveur. Vérifie ta connexion et réessaie.';

  @override
  String pushUpsInSeconds(String seconds) {
    return 'Pompes en $seconds secondes';
  }

  @override
  String beatOpponent(String name, String score) {
    return 'Victoire contre $name $score';
  }

  @override
  String lostToOpponent(String name, String score) {
    return 'Défaite contre $name $score';
  }

  @override
  String get thinkYouCanBeatMe => 'Tu crois pouvoir me battre ?';

  @override
  String get usernameNotAllowed =>
      'Ce nom n\'est pas autorisé. Essaie-en un autre.';

  @override
  String get yourBest => 'Ton record';

  @override
  String get theClock => 'Le chrono';

  @override
  String get nobodyFreeRaceBest =>
      'Personne de ton niveau n\'est libre pour l\'instant. Affronte ton record. Cette manche ne change pas ton rang.';

  @override
  String get nobodyFreeFirstScore =>
      'Personne de ton niveau n\'est libre pour l\'instant. Établis ton premier score. Cette manche ne change pas ton rang.';

  @override
  String bestStillIs(String count) {
    return 'Ton record reste $count';
  }

  @override
  String get setInPoolTitle => 'Ta série est en attente';

  @override
  String get setInPoolBody =>
      'Le prochain athlète de ton niveau l\'affrontera. Tu verras qui a gagné dans les notifications, et ton rang bougera à ce moment-là.';

  @override
  String get obWhyNeededBody =>
      'Chaque répétition est jugée sur la profondeur de ta descente et la hauteur à laquelle tu remontes, et seule la caméra peut le voir. Sans elle, pas de compte, et sans compte, pas de duel. La caméra n\'est allumée que pendant une série.';

  @override
  String get obWelcomeBack => 'Content de te revoir';

  @override
  String obTitlesHeading(String count) {
    return '$count titres à gagner';
  }

  @override
  String get obTitlesBody =>
      'Pour les victoires, les séries, les séries propres, les matins tôt et plus. Porte-en un sous ton nom.';

  @override
  String get obFriendsHeading => 'Réglez ça entre amis';

  @override
  String get obFriendsBody =>
      'Tes amis t\'ajoutent avec ce code. Défie-les quand tu veux, et le score entre vous est gardé.';

  @override
  String get obLetsGo => 'C\'est parti';

  @override
  String get paywallTitle => 'Grimpe du Fer au Maître';

  @override
  String get paywallPerkDuels => 'Duels arbitrés par la caméra';

  @override
  String get paywallPerkLadder => 'Classement en direct';

  @override
  String get paywallPerkFriends => 'Amis et défis';

  @override
  String get paywallPerkHistory => 'Chaque répétition de chaque match';

  @override
  String get paywallYearly => 'Annuel';

  @override
  String get paywallWeekly => 'Hebdomadaire';

  @override
  String paywallPerWeek(String price) {
    return '${price}/semaine';
  }

  @override
  String get paywallEveryWeek => 'par semaine';

  @override
  String paywallSave(String percent) {
    return 'Économise ${percent} %';
  }

  @override
  String get paywallStart => 'Retirer la pub';

  @override
  String get paywallRenewsPlay => 'Renouvellement automatique jusqu’à résiliation. Résilie à tout moment dans Google Play.';

  @override
  String get paywallRenewsApple => 'Renouvellement automatique jusqu’à résiliation. Résilie à tout moment dans les réglages de ton compte Apple.';

  @override
  String get paywallRestore => 'Restaurer';

  @override
  String get paywallTerms => 'Conditions';

  @override
  String get paywallPrivacy => 'Confidentialité';

  @override
  String get paywallLoadFailed => 'Impossible de charger les offres. Vérifie ta connexion et réessaie.';

  @override
  String get paywallBuyFailed => 'L’achat n’a pas abouti. Réessaie.';

  @override
  String get paywallPending => 'Ton paiement est en attente. Tout se débloque dès que le store le confirme.';

  @override
  String get paywallNothingToRestore => 'Aucun abonnement à restaurer.';

  @override
  String get paywallRestored => 'Abonnement restauré';

  @override
  String paywallSignedInAs(String email) {
    return 'Connecté en tant que ${email}';
  }

  @override
  String get deleteKeepsSubscription => 'Supprimer ton compte n’annule pas ton abonnement : c’est le store qui le facture, pas outrepd. Résilie-le d’abord dans Google Play ou dans les réglages de ton compte Apple.';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get signOutQuestion => 'Se déconnecter ?';

  @override
  String get signOutBody => 'Ton compte reste tel quel, avec son rang, son historique et son abonnement. Reconnecte-toi quand tu veux de la même façon.';

  @override
  String get shareVictory => 'VICTOIRE';

  @override
  String get shareRematch => 'REVANCHE ?';

  @override
  String friendCodeInvite(String code) {
    return 'Affronte-moi sur outrepd. Ajoute-moi avec mon code ami ${code}\nhttps://outrepd.com';
  }

  @override
  String get soundsLabel => 'Sons';

  @override
  String get soundsHint => 'Un bip pour 3, 2, 1, un tic à chaque répétition et la fin de la manche. Par-dessus ta musique.';

  @override
  String get phoneSection => 'Sur ce téléphone';

  @override
  String get allowNotifications => 'Autoriser les notifications';

  @override
  String get allowNotificationsHint => 'Elles sont désactivées pour OUTREPD dans les réglages du téléphone : rien de ce qui suit ne peut t\'arriver.';

  @override
  String get remindersSection => 'Rappel';

  @override
  String get dailyReminder => 'Rappel quotidien';

  @override
  String get dailyReminderHint => 'Seulement les jours où ton objectif n\'est pas encore atteint.';

  @override
  String get reminderTime => 'Heure';

  @override
  String get reminderTitle => 'C\'est l\'heure des pompes du jour';

  @override
  String reminderStreakBody(String count) {
    return 'Garde ta série de ${count} jours. Une série suffit.';
  }

  @override
  String get channelMatches => 'Matchs et amis';

  @override
  String get channelReminders => 'Rappel quotidien';

  @override
  String get liveTag => 'En direct';

  @override
  String get reconnecting => 'Reconnexion';

  @override
  String get rankedLive => 'Classé · en direct';

  @override
  String get lookingForLive => 'Recherche d\'un adversaire en direct';

  @override
  String ofTime(String time) {
    return 'sur ${time}';
  }

  @override
  String liveFallbackAt(String time) {
    return 'À ${time}, tu affronteras une série enregistrée';
  }

  @override
  String liveFoundBody(String name) {
    return '${name} est devant la caméra. Même chrono, même départ.';
  }

  @override
  String get nobodyLiveTitle => 'Personne n\'est en direct';

  @override
  String get nobodyLiveBody => 'Tu vas affronter une série enregistrée';

  @override
  String didRepsIn(String reps) {
    return 'A fait ${reps} en 60 secondes';
  }

  @override
  String get sameRankPoints => 'Autant de points de rang qu\'en direct';

  @override
  String get raceIt => 'L\'affronter';

  @override
  String get onlineNow => 'En ligne';

  @override
  String get friendlyNoRank => 'Amical · sans classement';

  @override
  String waitingForName(String name) {
    return 'En attente de ${name}';
  }

  @override
  String get weSentThemANotice => 'On lui a envoyé une notification';

  @override
  String get untilInviteRunsOut => 'avant la fin de l\'invitation';

  @override
  String get cancelInvite => 'Annuler l\'invitation';

  @override
  String inviteDeclined(String name) {
    return '${name} a dit pas maintenant';
  }

  @override
  String get inviteRanOut => 'L\'invitation a expiré';

  @override
  String get inviteAgain => 'Inviter à nouveau';

  @override
  String liveInviteFrom(String name) {
    return '${name} est en direct';
  }

  @override
  String timeLeft(String time) {
    return 'Encore ${time}';
  }

  @override
  String get joinLive => 'Rejoindre';

  @override
  String get nLiveTitle => 'Invitation en direct';

  @override
  String nLiveBody(String name) {
    return '${name} veut s\'affronter en direct';
  }

  @override
  String get inviteGone => 'Cette invitation a expiré';

  @override
  String opponentDropped(String name) {
    return 'La connexion de ${name} a coupé. Continue : la manche se termine au chrono.';
  }

  @override
  String opponentGaveUp(String name) {
    return '${name} a abandonné. Termine la manche pour gagner.';
  }

  @override
  String get calledOffTitle => 'Match annulé';

  @override
  String calledOffBody(String name) {
    return '${name} ne s\'est pas mis en position à temps. Rien n\'a été enregistré.';
  }

  @override
  String waitingForFinal(String name) {
    return 'En attente du total final de ${name}…';
  }

  @override
  String get wantsToBeFriends => 'veut être ton ami';

  @override
  String get giveUpQuestion => 'Abandonner cette manche ?';

  @override
  String get giveUpBody => 'C\'est une défaite, quel que soit ton total actuel.';

  @override
  String waitingToJoin(String name) {
    return 'En attente de ${name}';
  }

  @override
  String get removeFriend => 'Retirer des amis';

  @override
  String get removeFriendBody => 'La personne n\'est pas prévenue, et vous pourrez vous rajouter';

  @override
  String removeFriendQuestion(String username) {
    return 'Retirer ${username} de tes amis ?';
  }

  @override
  String get removeAction => 'Retirer';

  @override
  String removedFriend(String username) {
    return '${username} a été retiré de tes amis';
  }

  @override
  String get noticeChallenged => 'Quelqu\'un m\'a défié en revanche';

  @override
  String get noticeLiveInvite => 'Un ami m\'a invité à un duel en direct';

  @override
  String get trialToday => 'Aujourd\'hui';

  @override
  String get trialTodayBody => 'Tous les duels, en direct et classés, débloqués.';

  @override
  String trialDay(String day) {
    return 'Jour ${day}';
  }

  @override
  String get trialReminderBody => 'On te prévient la veille de la fin de ton essai.';

  @override
  String get trialEndBody => 'Ton abonnement démarre. Annule avant et tu ne paies rien.';

  @override
  String trialTag(String days) {
    return '${days} jours gratuits';
  }

  @override
  String trialCta(String days) {
    return 'Commencer mon essai gratuit de ${days} jours';
  }

  @override
  String trialThenYearly(String price) {
    return 'Rien à payer maintenant · puis ${price}/an';
  }

  @override
  String trialThenWeekly(String price) {
    return 'Rien à payer maintenant · puis ${price}/semaine';
  }

  @override
  String get trialEndsTitle => 'Ton essai gratuit se termine demain';

  @override
  String get trialEndsBody => 'Continue de grimper, ou annule avant dans les réglages de ton abonnement.';

  @override
  String get obIdeaTitle => '60 secondes. Un adversaire.';

  @override
  String get obIdeaRival => 'Une vraie personne, en direct ou sa série enregistrée';

  @override
  String get obIdeaCamera => 'Ta caméra compte chaque répétition, sur ton téléphone';

  @override
  String get thisMonth => 'Ce mois-ci';

  @override
  String shortDays(String n) {
    return '${n} j';
  }

  @override
  String shortHours(String n) {
    return '${n} h';
  }

  @override
  String get awardChampion => 'Champion';

  @override
  String get awardPodium => 'Podium';

  @override
  String get awardTop10 => 'Top 10';

  @override
  String get awardRegular => 'Club 20';

  @override
  String monthToTop10(String lp) {
    return 'À ${lp} LP du top 10';
  }

  @override
  String monthIfEndedNow(String award) {
    return '${award} si le mois finissait maintenant';
  }

  @override
  String get monthJoinHint => 'Joue un duel classé pour entrer dans le classement du mois';

  @override
  String monthRegularProgress(String progress) {
    return 'Badge Club 20 · ${progress} duels classés';
  }

  @override
  String get monthRegularEarned => 'Badge Club 20 gagné ce mois-ci';

  @override
  String get monthEmptyTitle => 'Un nouveau mois';

  @override
  String get monthEmptyBody => 'Personne n\'a encore gagné de LP ce mois-ci. Gagne le premier duel classé et tu prends la tête.';

  @override
  String rankedDuelsCount(String n) {
    return '${n} duels classés';
  }

  @override
  String get monthlyAwards => 'Récompenses du mois';

  @override
  String get seasonOver => 'Saison terminée';

  @override
  String get seasonOverBody => 'C\'est sur ton profil maintenant. Le nouveau mois repart de zéro.';

  @override
  String get seasonPlayCta => 'Jouer le nouveau mois';

  @override
  String get rematchLive => 'Revanche en direct';

  @override
  String rematchWaiting(String name) {
    return 'En attente de ${name}';
  }

  @override
  String rematchAsked(String name) {
    return '${name} veut une revanche';
  }

  @override
  String get rematchGone => 'Pas de revanche cette fois';

  @override
  String get twoRankedADay => 'Amical · 2 classés par jour avec le même adversaire';

  @override
  String monthMove(String move) {
    return 'Ce mois-ci · ${move}';
  }

  @override
  String promotedFrom(String rank) {
    return 'depuis ${rank}';
  }

  @override
  String liveOnlineNow(String n) {
    return '${n} en ligne';
  }

  @override
  String liveSearchingNow(String n) {
    return '${n} en recherche';
  }

  @override
  String get dailyGoalTitle => 'Objectif du jour';

  @override
  String get dailyGoalDone => 'C\'est fait pour aujourd\'hui';

  @override
  String dailyGoalProgress(String progress) {
    return '${progress} pompes';
  }

  @override
  String dailyGoalLeft(String n) {
    return 'encore ${n}';
  }

  @override
  String get dailyGoalChange => 'Modifier';

  @override
  String get dailyGoalPick => 'Ton objectif quotidien';

  @override
  String dailyGoalOption(String n) {
    return '${n} pompes par jour';
  }

  @override
  String widgetGoalOf(String goal) {
    return 'sur ${goal} aujourd\'hui';
  }

  @override
  String get saveToAppleHealth => 'Enregistrer les séances dans Santé d\'Apple';

  @override
  String get saveToHealthConnect => 'Enregistrer les séances dans Santé Connect';

  @override
  String get saveToHealthHint => 'Chaque série est ajoutée comme séance de musculation. Rien n\'est lu.';

  @override
  String get healthNotAllowed => 'Pas encore autorisé. Tu peux l\'autoriser dans les réglages santé de ton téléphone.';

  @override
  String reminderLeft(String count) {
    return 'Plus que ${count} pompes pour ton objectif du jour.';
  }

  @override
  String get liveInviteHint => 'Les amis en ligne peuvent rejoindre tout de suite. Les autres reçoivent une notification et ont une minute pour rejoindre.';

  @override
  String get requestSentShort => 'Demande envoyée';

  @override
  String healthWorksWith(String health) {
    return 'OUTREPD fonctionne avec ${health}';
  }

  @override
  String healthCardBody(String health) {
    return 'Chaque série que tu termines est enregistrée dans ${health} comme séance de renforcement. OUTREPD ne lit jamais tes données de santé.';
  }

  @override
  String savedToHealth(String health) {
    return 'Enregistré dans ${health}';
  }

  @override
  String get usernameTooShort => 'Trop court : au moins 4 caractères';

  @override
  String get usernameBadCharacters => 'Uniquement des lettres, des chiffres et _';

  @override
  String get usernameNeedsLetter => 'Ajoute au moins une lettre ou un chiffre';

  @override
  String usernameChangeAgainOn(String date) {
    return 'Tu pourras le changer à nouveau le ${date}';
  }

  @override
  String get continueWithApple => 'Continuer avec Apple';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get socialSignInFailed => 'Connexion impossible. Réessaie.';

  @override
  String get chooseUsernameTitle => 'Choisis ton nom d\'utilisateur';

  @override
  String get chooseUsernameSubtitle => 'C\'est ainsi que les autres te trouvent et te voient dans les classements.';

  @override
  String get authHeroTitle => 'BATS N\'IMPORTE QUI.';

  @override
  String get authHeroSubtitle => 'Des duels de pompes en direct, comptés par ta caméra.';

  @override
  String get createAccountPitch => 'Ton rang et tes duels, sur n\'importe quel téléphone.';

  @override
  String get usernameSpacesHint => 'Les espaces deviennent _';

  @override
  String get emailCodeNote => 'On t\'envoie un code à 6 chiffres par e-mail. Pas de mot de passe.';

  @override
  String get continueWithEmail => 'Continuer avec l\'e-mail';

  @override
  String get thisSeason => 'Cette saison';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get weekStartsAgain => 'Recommence chaque lundi';

  @override
  String get lengthWeek => 'Semaine';

  @override
  String get lengthMonth => 'Mois';

  @override
  String get weekJoinHint => 'Gagne un duel classé cette semaine pour entrer au classement';

  @override
  String get weekInTop3 => 'Dans le top 3 cette semaine';

  @override
  String weekToTop3(String n) {
    return '${n} LP jusqu\'au top 3';
  }

  @override
  String get boardActiveNote => 'Joueurs actifs ces 30 derniers jours';

  @override
  String get boardTieNote => 'égalité : plus de victoires d\'abord';

  @override
  String lpBreakdown(String reps, String adjust, String rank) {
    return '${reps} pour les répétitions · ${adjust} pour un adversaire ${rank}';
  }

  @override
  String levelShort(String n) {
    return 'Niv. ${n}';
  }

  @override
  String xpOf(String into, String span) {
    return '${into} / ${span} XP';
  }

  @override
  String xpToLevel(String n, String level) {
    return '${n} XP avant le niveau ${level}';
  }

  @override
  String xpHow(String rep, String match) {
    return '${rep} XP par répétition, ${match} par duel';
  }

  @override
  String xpGained(String n) {
    return '+${n} XP';
  }

  @override
  String xpForReps(String n) {
    return '${n} pour les répétitions';
  }

  @override
  String xpForMatch(String n) {
    return '${n} pour le duel';
  }

  @override
  String get levelUp => 'Niveau supérieur';

  @override
  String get levelUpBody => 'Chaque répétition compte. Continue.';

  @override
  String giveUpAhead(String n) {
    return 'Tu as ${n} d\'avance';
  }

  @override
  String giveUpBehind(String n) {
    return 'Tu as ${n} de retard';
  }

  @override
  String get giveUpTied => 'Égalité';

  @override
  String get keepGoing => 'Continuer';

  @override
  String get stay => 'Rester';

  @override
  String lastN(String n) {
    return '${n} derniers';
  }

  @override
  String get firstMatchForTier => 'Joue ton premier match pour entrer dans le classement. Tout le monde commence en Iron V.';

  @override
  String get firstMatchForBoard => 'Joue ton premier match pour apparaître au classement. Tout le monde commence en Iron V.';

  @override
  String get playFirstMatch => 'Jouer mon premier match';

  @override
  String firstMatchTerms(String seconds) {
    return 'Un match · ${seconds} secondes';
  }

  @override
  String get placedLabel => 'Tu es dans le classement';

  @override
  String get placedBody => 'Tout le monde commence ici. Seules les victoires te font monter.';

  @override
  String get placedHow => 'Gagne des matchs pour gagner des LP. Bats quelqu\'un mieux classé pour en gagner plus.';

  @override
  String get levelBesideName => 'À côté de ton nom, partout';

  @override
  String get weekRaceTitle => 'La course de la semaine';

  @override
  String get streakDoneToday => 'fait aujourd\'hui';

  @override
  String get streakTrainToday => 'entraîne-toi aujourd\'hui pour ajouter un jour';

  @override
  String get raceChartTitle => 'Comment s\'est passée la minute';

  @override
  String raceYouLead(String time) {
    return '${time} · tu prends la tête';
  }

  @override
  String raceTheyLead(String time, String name) {
    return '${time} · ${name} prend la tête';
  }

  @override
  String get bringFriendTitle => 'Invite un ami';

  @override
  String get bringFriendBody => 'Envoie ton lien. Il ouvre ton profil, où l\'on peut t\'ajouter.';

  @override
  String get bringFriendShare => 'Partager mon lien';

  @override
  String get bringFriendShareText => 'Affronte-moi aux pompes sur OUTREPD. 60 secondes, en direct, et la caméra compte.';

  @override
  String orFriendCode(String code) {
    return 'ou code ami ${code}';
  }

  @override
  String get countryPickerTitle => 'Ton pays';

  @override
  String get countrySearch => 'Rechercher';

  @override
  String get countryFromPhone => 'D\'après ton téléphone';

  @override
  String get countryAll => 'Tous les pays';

  @override
  String get countryChoose => 'Choisis ton pays';

  @override
  String get countryChange => 'Changer';

  @override
  String get countryForBoard => 'Pour le classement de ton pays';

  @override
  String get countryLabel => 'Pays';

  @override
  String get countryChanged => 'Pays modifié';

  @override
  String get countryEvery14 => 'Une fois tous les 14 jours, comme ton nom';

  @override
  String get countryNotSaved => 'Impossible d\'enregistrer ton pays. Réessaie.';

  @override
  String get adventure => 'Aventure';

  @override
  String stageNumber(String n) {
    return 'Niveau ${n}';
  }

  @override
  String adventureLevelIn(String level, String world) {
    return 'Niveau ${level} · ${world}';
  }

  @override
  String adventureClearedOf(String cleared, String total) {
    return '${cleared} sur ${total} réussis · sans classement';
  }

  @override
  String get worldIron => 'Mines de fer';

  @override
  String get worldBronze => 'Dunes de bronze';

  @override
  String get worldSilver => 'Pics d’argent';

  @override
  String get worldGold => 'Citadelle d’or';

  @override
  String get worldPlatinum => 'Glacier de platine';

  @override
  String get worldDiamond => 'Cavernes de diamant';

  @override
  String get worldMaster => 'Trône du Maître';

  @override
  String worldNumber(String n) {
    return 'Monde ${n}';
  }

  @override
  String fightLevel(String level) {
    return 'Combattre le niveau ${level}';
  }

  @override
  String levelHpLine(String hp, String reps) {
    return 'HP ${hp} · environ ${reps} pompes';
  }

  @override
  String get hpShort => 'HP';

  @override
  String comboTag(String n) {
    return 'COMBO ×${n}';
  }

  @override
  String get levelCleared => 'RÉUSSI';

  @override
  String get outOfTime => 'TEMPS ÉCOULÉ';

  @override
  String get statPushUps => 'pompes';

  @override
  String get statTimeLeft => 'restant';

  @override
  String get statHpLeft => 'HP restants';

  @override
  String get statXp => 'XP';

  @override
  String secondStarHint(String seconds) {
    return 'Finis avec ${seconds} secondes d’avance pour la deuxième étoile';
  }

  @override
  String thirdStarHint(String seconds) {
    return 'Finis avec ${seconds} secondes d’avance pour la troisième étoile';
  }

  @override
  String get fightLostHint => 'Rejoue des niveaux précédents pour plus d’étoiles : elles débloquent des armes plus fortes.';

  @override
  String get nextLevel => 'Niveau suivant';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get adventureMap => 'Carte';

  @override
  String get nextKicker => 'SUIVANT';

  @override
  String nextLevelLine(String level, String hp) {
    return 'Niveau ${level} · HP ${hp}';
  }

  @override
  String get armory => 'Armurerie';

  @override
  String get armoryBody => 'Les étoiles débloquent des armes. Les monstres de chaque monde ne craignent que son arme ou une meilleure.';

  @override
  String get equipped => 'ÉQUIPÉE';

  @override
  String perPushUp(String damage) {
    return '${damage} par pompe';
  }

  @override
  String damagePerPushUp(String damage) {
    return '${damage} dégâts par pompe';
  }

  @override
  String wasWith(String damage, String weapon) {
    return 'avant : ${damage} avec ${weapon}';
  }

  @override
  String moreStars(String count) {
    return 'encore ${count} étoiles';
  }

  @override
  String get newWeapon => 'Nouvelle arme';

  @override
  String starsKicker(String count) {
    return '${count} ÉTOILES';
  }

  @override
  String get weaponGauntlets => 'Gantelets de fer';

  @override
  String get weaponKnuckles => 'Poings de bronze';

  @override
  String get weaponFang => 'Croc d’argent';

  @override
  String get weaponHammer => 'Marteau d’or';

  @override
  String get weaponAxe => 'Hache de platine';

  @override
  String get weaponSpear => 'Lance de diamant';

  @override
  String get weaponSword => 'Épée du Maître';

  @override
  String get weaponCrownbreaker => 'Brise-Couronne';

  @override
  String clearFirst(String level) {
    return 'Gagne d’abord le niveau ${level}';
  }

  @override
  String needsWeapon(String weapon) {
    return 'Il faut ${weapon}';
  }

  @override
  String hurtOnlyBy(String weapon) {
    return 'Seul ${weapon} ou mieux peut le blesser';
  }

  @override
  String worldNeedsWeapon(String world, String weapon, String count) {
    return '${world} demande ${weapon} · encore ${count} étoiles';
  }

  @override
  String rematchOpponentLeft(String name) {
    return '${name} est parti · pas de revanche cette fois';
  }

  @override
  String get obNext => 'Suivant';

  @override
  String get obRaceTitle => 'Affronte une vraie personne.';

  @override
  String get obRaceBody => 'Le plus de répétitions en 60 secondes gagne. En direct, chacun sur son téléphone — ou contre une série enregistrée quand personne n’est en ligne.';

  @override
  String get obRepsTitle => 'Seules les répétitions complètes comptent.';

  @override
  String get obRepsBody => 'La caméra voit jusqu’où tu descends et jusqu’où tu remontes.';

  @override
  String get obRepsDown => 'Descends sous la ligne dorée';

  @override
  String get obRepsUp => 'Remonte au-dessus de la ligne du haut';

  @override
  String get obRepsBoth => 'Les deux, mains au sol. Une demi-répétition ne compte pas — ni chez toi, ni chez l’autre.';

  @override
  String get obClimbTitle => 'Grimpe jusqu’à Master.';

  @override
  String get obClimbBody => 'Gagne pour monter l’échelle : sept rangs de cinq paliers chacun.';

  @override
  String get obAdventureTitle => 'Tu t’entraînes seul ?';

  @override
  String get obAdventureBody => 'Aventure propose 140 niveaux de combats de pompes, chacun plus dur que le précédent.';

  @override
  String get obCountedHere => 'Compté sur ce téléphone';

  @override
  String get obGoldLine => 'ligne dorée';

  @override
  String obCalibrationRule(String gold) {
    return 'Descends sous la ${gold}, remonte au-dessus de celle du haut';
  }

  @override
  String get proTitleTop => 'Sans pub.';

  @override
  String get proTitleBottom => 'Que des pompes.';

  @override
  String get proBody => 'Tous les matchs restent gratuits. Pro retire la pub de chacun.';

  @override
  String get proThanks => 'Plus de pub. Merci d’être passé à Pro.';

  @override
  String get removeAds => 'Retirer la pub';

  @override
  String get adNotice => 'Une pub passe quand tu sors';

  @override
  String get adAskTitle => 'La pub garde outrepd gratuit';

  @override
  String get adAskBody => 'Ton iPhone va demander si les apps peuvent utiliser ton activité pour choisir les pubs. Si tu dis oui, les pubs te correspondent mieux ; si tu dis non, tu en verras quand même, juste moins pertinentes.';

  @override
  String get adAskCamera => 'Ta caméra n’y est pour rien : le suivi du corps reste sur ce téléphone, quoi que tu choisisses.';

  @override
  String get adAskRemove => 'Plutôt retirer la pub';

  @override
  String get monsterIronColossus => 'Colosse de fer';

  @override
  String get monsterScarab => 'Scarabée';

  @override
  String get monsterScarabPharaoh => 'Pharaon scarabée';

  @override
  String get monsterYeti => 'Yéti';

  @override
  String get monsterFrostYeti => 'Yéti du givre';

  @override
  String get monsterYetiChieftain => 'Chef yéti';

  @override
  String get monsterGoldSoldier => 'Soldat d’or';

  @override
  String get monsterGoldKnight => 'Chevalier d’or';

  @override
  String get monsterGoldKing => 'Roi d’or';

  @override
  String get monsterWisp => 'Feu follet';

  @override
  String get monsterWraith => 'Spectre';

  @override
  String get monsterFrostLich => 'Liche du givre';

  @override
  String get monsterCrystalDrake => 'Drake de cristal';

  @override
  String get monsterCrystalDragon => 'Dragon de cristal';

  @override
  String get monsterDiamondWyrm => 'Wyrm de diamant';

  @override
  String get monsterShadowGuard => 'Garde de l’ombre';

  @override
  String get monsterShadowKnight => 'Chevalier de l’ombre';

  @override
  String get monsterTheMaster => 'Le Maître';

  @override
  String get monsterPebbleGolem => 'Golem de galets';

  @override
  String get monsterStoneGolem => 'Golem de pierre';

  @override
  String get monsterOreGolem => 'Golem de minerai';

  @override
  String get monsterMinerGolem => 'Golem mineur';

  @override
  String get monsterScarabGrub => 'Larve de scarabée';

  @override
  String get monsterHornedScarab => 'Scarabée cornu';

  @override
  String get monsterScarabWarrior => 'Guerrier scarabée';

  @override
  String get monsterYetiCub => 'Petit yéti';

  @override
  String get monsterHornedYeti => 'Yéti cornu';

  @override
  String get monsterGoldRecruit => 'Recrue d’or';

  @override
  String get monsterGoldGuard => 'Garde d’or';

  @override
  String get monsterShade => 'Ombre';

  @override
  String get monsterIceSpecter => 'Spectre de glace';

  @override
  String get monsterCrystalHatchling => 'Bébé de cristal';

  @override
  String get monsterCrystalWhelp => 'Dragonnet de cristal';

  @override
  String get monsterShadowSquire => 'Écuyer de l’ombre';

  @override
  String get monsterShadowLord => 'Seigneur de l’ombre';

  @override
  String monsterWarden(String name) {
    return '${name} gardien';
  }

  @override
  String get obPhoneSees => 'Ce que ton téléphone doit voir';

  @override
  String get obPhoneSeesBody => 'Du haut de la tête jusqu’aux mains, à environ un mètre, en position de pompe.';
}
