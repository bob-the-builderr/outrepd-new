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
  String get passwordHint => 'Mot de passe';

  @override
  String get codeHint => 'Code de vérification';

  @override
  String get createAccountTitle => 'Créer un compte';

  @override
  String get createAccountBody =>
      'Ajoute un e-mail et un mot de passe pour que ce compte ne tienne pas qu\'à ce téléphone.';

  @override
  String get createAccountAction => 'Créer un compte';

  @override
  String get signInTitle => 'Se connecter';

  @override
  String get signInBody =>
      'Connecte-toi avec l\'e-mail et le mot de passe de ton compte.';

  @override
  String get signInAction => 'Se connecter';

  @override
  String get switchToSignIn => 'Déjà un compte ? Se connecter';

  @override
  String get switchToSignUp => 'Nouveau ici ? Créer un compte';

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
  String get orDivider => 'ou';

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
  String get usernameHint => 'Nom d\'utilisateur';

  @override
  String get usernameLabel => 'Nom d\'utilisateur';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get passwordMinLength => 'Au moins 8 caractères';

  @override
  String get logInSubtitle => 'Connecte-toi pour garder ton rang.';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String resetPasswordSent(String email) {
    return 'Si un compte existe pour $email, un lien de réinitialisation arrive.';
  }

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
  String get socialLinkFailed =>
      'Impossible de terminer la connexion. Réessaie.';

  @override
  String get showLabel => 'Afficher';

  @override
  String get hideLabel => 'Masquer';

  @override
  String get resetPasswordTitle => 'Définis un nouveau mot de passe';

  @override
  String get resetPasswordBody =>
      'Choisis un nouveau mot de passe pour ton compte.';

  @override
  String get setPasswordAction => 'Définir le mot de passe';

  @override
  String get wrongEmailOrPassword => 'E-mail ou mot de passe incorrect.';

  @override
  String get enterCodeTitle => 'Saisir le code';

  @override
  String codeInstructions(String email) {
    return 'Saisis le code envoyé à $email.';
  }

  @override
  String get verifyAction => 'Vérifier';

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
  String get height => 'Taille';

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
      'Doit comporter de 4 à 20 caractères, lettres et chiffres uniquement';

  @override
  String get usernameChanged => 'Nom d\'utilisateur modifié';

  @override
  String get usernameAlreadyChangedBody =>
      'Tu as déjà utilisé ton unique changement de nom d\'utilisateur — chaque compte n\'en reçoit qu\'un seul.';

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
  String get recalibrate => 'Recalibrer';

  @override
  String get resetCount => 'Remettre à zéro';

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
  String get units => 'Unités';

  @override
  String get weight => 'Poids';

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
  String challengeSent(String name) {
    return 'Défi envoyé à $name';
  }

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
      'Cette fonction nécessite un serveur et n\'est pas encore connectée';

  @override
  String get achievements => 'Succès';

  @override
  String get roadTitle => 'La route vers Maître';

  @override
  String get allTiers => 'Tous les rangs';

  @override
  String get topTier => 'Rang maximal';

  @override
  String lpToGo(String lp) {
    return '$lp PL';
  }

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
  String get shortKg => 'kg';

  @override
  String get shortLb => 'lb';

  @override
  String get shortCm => 'cm';

  @override
  String get shortFt => 'pi';

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
  String get stay => 'Rester';

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
    return 'il y a $n semaines';
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
  String get addFriend => 'Ajouter';

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
  String get findPeople => 'Trouver des gens';

  @override
  String get noRankYet => 'Pas encore classé';

  @override
  String placementsForFirstTier(String count) {
    return 'Termine $count duels de placement pour obtenir ton premier rang.';
  }

  @override
  String get startPlacements => 'Commencer les placements';

  @override
  String get unranked => 'Non classé';

  @override
  String placementsTerms(String done, String total, String seconds) {
    return '$done sur $total · $seconds secondes chacun';
  }

  @override
  String placementsLeft(String done, String total, String left) {
    return '$done sur $total · encore $left avant ton rang';
  }

  @override
  String placementsForTier(String count) {
    return 'Termine $count duels de placement pour voir où tu te situes.';
  }

  @override
  String placementsDoneCount(String done, String total) {
    return '$done sur $total placements terminés';
  }

  @override
  String get practiceFirst => 'S’entraîner d’abord';

  @override
  String get nextPlacement => 'Placement suivant';

  @override
  String get noConnection => 'Pas de connexion';

  @override
  String get practiceOffline => 'S’entraîner hors ligne';

  @override
  String get retry => 'Réessayer';

  @override
  String get youWonPlain => 'Tu as gagné';

  @override
  String opponentDisconnected(String name) {
    return '$name s’est déconnecté';
  }

  @override
  String get forfeitNoMargin => 'Abandon · l’écart ne compte pas';

  @override
  String get findAnotherMatch => 'Chercher un autre match';

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
  String lpSwing(String gain, String loss) {
    return '+$gain / −$loss LP';
  }

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
  String get yourRankCard => 'Ta carte de rang';

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
  String get obHowTitle => 'Trois choses, et tu es dedans.';

  @override
  String get obHow1 => 'Pose ton téléphone par terre';

  @override
  String get obHow1Body => 'Adosse-le à un mur, à un mètre devant toi.';

  @override
  String get obHow2 => 'La caméra compte tes répétitions';

  @override
  String get obHow2Body =>
      'La profondeur de chaque répétition est vérifiée. Les demies ne comptent pas.';

  @override
  String get obHow3 => 'Soixante secondes contre quelqu’un';

  @override
  String get obHow3Body =>
      'Gagne et tu montes. Perds et tu descends. Mêmes règles pour tous.';

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
  String get obOneMetre => '~1 m';

  @override
  String get obFullBody => 'tout le corps dans le cadre';

  @override
  String get obCheckHandsFeet => 'Mains et pieds visibles';

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
  String get obFramingAnkles => 'Chevilles';

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
  String get obPlacementsBody =>
      'Cinq duels décident de ton palier de départ. Rien ne compte contre toi pour l’instant.';

  @override
  String get obFindFirstOpponent => 'Trouver mon premier adversaire';

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
      'Chaque fois que tu confirmes un décompte après un duel, cette série est comparée à ce que tu as annoncé. Le chiffre s’affiche ici.';

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
  String get lpRowWin => 'Victoire';

  @override
  String get lpRowLoss => 'Défaite';

  @override
  String get lpRowOpponent => 'Rang de l\'adversaire';

  @override
  String get lpRowMargin => 'Écart';

  @override
  String get lpRowDepth => 'Profondeur';

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
      'Chaque répétition est jugée sur la descente et la remontée de tes épaules, et seule la caméra peut le voir. Sans elle, pas de comptage, et sans comptage, pas de duel. La caméra n\'est allumée que pendant une série.';

  @override
  String get obWelcomeBack => 'Content de te revoir';

  @override
  String get obDuelTitle => 'Tu affrontes la minute d\'une vraie personne';

  @override
  String get obDuelBody =>
      'Sa série a été enregistrée répétition par répétition. Tu la vois se dérouler en direct pendant la tienne.';

  @override
  String obDuelWinBy(String count) {
    return 'Gagne avec $count répétitions d\'avance';
  }

  @override
  String get obDuelLpRule =>
      'Les points de rang sont l\'écart en répétitions. Gagne largement, grimpe vite.';

  @override
  String get obLadderTitle => 'Sept rangs à gravir';

  @override
  String get obLadderBody =>
      'Cinq duels de placement fixent ton point de départ. Gagne pour grimper, et un rang atteint reste acquis.';

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
  String get paywallStart => 'Commencer l’ascension';

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
  String get signOutBody => 'Ton compte reste tel quel, avec son rang, son historique et son abonnement. Reconnecte-toi quand tu veux avec ton e-mail.';
}
